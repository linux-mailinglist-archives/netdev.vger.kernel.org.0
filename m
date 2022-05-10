Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16FB521558
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 14:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241429AbiEJM3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237699AbiEJM3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:29:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A232224685;
        Tue, 10 May 2022 05:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0SOHdnZm/qIXaafuGPsWb+8y+0cZMBYOdPMCj5bdxFs=; b=ssUW9aQmsIjXI3QzluEQbxRQ+M
        cC6kGQGCJDuXvSHWxXW8y1iNfTI+j8Pr2dCPhNVjmV4BapCvHOFAt32KVk6l1fFnJGmLp22dM2BFj
        8xqPnxzRt9SBMspCfijipgoFeOVo7+KZNQoQVXdxHYgyfhW0FWgkssAKHOFIPiBlpPGQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1noOvO-0028E6-3y; Tue, 10 May 2022 14:25:10 +0200
Date:   Tue, 10 May 2022 14:25:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
Subject: Re: [PATCH net] net: phy: mscc: Add error check when __phy_read()
 failed
Message-ID: <YnpZphRYEZJm/9D6@lunn.ch>
References: <20220510035458.9804-1-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510035458.9804-1-wanjiabing@vivo.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 11:54:56AM +0800, Wan Jiabing wrote:
> Calling __phy_read() might return a negative error code. Use 'int'
> to declare variables which call __phy_read() and also add error check
> for them.

It would be good to add a comment here:

The numerous callers of vsc8584_macsec_phy_read() don't expect it to
fail. So don't return the error code from __phy_read(), but also don't
return random values if it does fail.

The commit message should try to answer any questions to reviewer
has. And when i first looked at the change, i thought this is wrong,
the error code is thrown away. But then i remembers our discussion. So
it is good to mention that in the commit message.

> Fixes: fa164e40c53b ("net: phy: mscc: split the driver into separate files")
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  drivers/net/phy/mscc/mscc_macsec.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
> index b7b2521c73fb..8a63e32fafa0 100644
> --- a/drivers/net/phy/mscc/mscc_macsec.c
> +++ b/drivers/net/phy/mscc/mscc_macsec.c
> @@ -22,9 +22,9 @@
>  static u32 vsc8584_macsec_phy_read(struct phy_device *phydev,
>  				   enum macsec_bank bank, u32 reg)
>  {
> -	u32 val, val_l = 0, val_h = 0;
>  	unsigned long deadline;
> -	int rc;
> +	int rc, val, val_l, val_h;
> +	u32 ret = 0;

Networking code uses "reverse christmas tree", meaning these lines
should be sorted, longest first, shortest last. So deadline needs to
come after val_h.

     Andrew
