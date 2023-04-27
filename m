Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128D26EFE7E
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242701AbjD0A0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbjD0A0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:26:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCFB10C;
        Wed, 26 Apr 2023 17:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=e+ONR4l8Tvoq8h4XXWTVVwKNe5nuN+XxQn9dOl48SKI=; b=HSaLSuvsWsInVIS1saBjps9VYz
        BLxr7P5neqVP6VhSL33opg7STAV4cvnmqEQowjffJq0l3KSmcBuyGOVVNZ/xvGIWih9sP5WN+HXV3
        fwSEht02+NNuDFVQV+AKuTUpivJkafDGFljW3szYMTy+k0X50jaBW5uRTWUh4JyjJFdA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prpSZ-00BJX8-DW; Thu, 27 Apr 2023 02:26:07 +0200
Date:   Thu, 27 Apr 2023 02:26:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net 2/3] r8152: fix the poor throughput for 2.5G devices
Message-ID: <78473807-e84e-47b3-83a1-39e583d1f334@lunn.ch>
References: <20230426122805.23301-400-nic_swsd@realtek.com>
 <20230426122805.23301-402-nic_swsd@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426122805.23301-402-nic_swsd@realtek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 08:28:04PM +0800, Hayes Wang wrote:
> Fix the poor throughput for 2.5G devices, when changing the speed from
> auto mode to force mode. This patch is used to notify the MAC when the
> mode is changed.
> 
> Fixes: 195aae321c82 ("r8152: support new chips")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 08d1786135f2..3ecd4651ae29 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -7554,6 +7554,11 @@ static void r8156_hw_phy_cfg(struct r8152 *tp)
>  				      ((swap_a & 0x1f) << 8) |
>  				      ((swap_a >> 8) & 0x1f));
>  		}
> +
> +		/*  set intr_en[3] */
> +		data = ocp_reg_read(tp, 0xa424);
> +		data |= BIT(3);
> +		ocp_reg_write(tp, 0xa424, data);

Please add #define for 0xa424. And a #define for BIT(3), just to
document what bit 3 is. Once we understand what bit 3 is, we might
then understand why this change makes 2.5G perform better. At the
moment all i see is magic.

       Andrew
