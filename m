Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBC06EFE61
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242683AbjD0AXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242131AbjD0AXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:23:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA26BB;
        Wed, 26 Apr 2023 17:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HSdAdxKWBILv0s9CuHWUzCy8h/w713XGOWLhDld93Y4=; b=pExgCA2T17r4M97ONv1un6hIRE
        Hi9pOuv92hCfLjw8wOtx6MNOpg++WjSkvlC2FiUmxr8LveP6WaQPkuzh2rXg8XeezF1MpIbLgllAT
        +PTJdN4B8m8XjVGtXYtGtjQMfDbxP+EmO4jZTJGzCS0y6PATBgtEUzeHE8GRFIsWEP6s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prpOX-00BJTd-9e; Thu, 27 Apr 2023 02:21:57 +0200
Date:   Thu, 27 Apr 2023 02:21:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net 1/3] r8152: fix flow control issue of RTL8156A
Message-ID: <724a1f58-3df6-402f-9ebd-25fe48229ace@lunn.ch>
References: <20230426122805.23301-400-nic_swsd@realtek.com>
 <20230426122805.23301-401-nic_swsd@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426122805.23301-401-nic_swsd@realtek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 08:28:03PM +0800, Hayes Wang wrote:
> The feature of flow control becomes abnormal, if the device sends a
> pause frame and the tx/rx is disabled before sending a release frame. It
> causes the lost of packets.
> 
> Set PLA_RX_FIFO_FULL and PLA_RX_FIFO_EMPTY to zeros before disabling the
> tx/rx. And, toggle FC_PATCH_TASK before enabling tx/rx to reset the flow
> control patch and timer. Then, the hardware could clear the state and
> the flow control becomes normal after enabling tx/rx.
> 
> Fixes: 195aae321c82 ("r8152: support new chips")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 56 ++++++++++++++++++++++++++---------------
>  1 file changed, 36 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 0fc4b959edc1..08d1786135f2 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -5986,6 +5986,25 @@ static void rtl8153_disable(struct r8152 *tp)
>  	r8153_aldps_en(tp, true);
>  }
>  
> +static inline u32 fc_pause_on_auto(struct r8152 *tp)
> +{
> +	return (ALIGN(mtu_to_size(tp->netdev->mtu), 1024) + 6 * 1024);
> +}

No inline functions in .c files. Let the compiler decide. I see you
are just moving functions around, they were already inline, but now is
a good time to fix this.

  Andrew
