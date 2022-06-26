Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FB455B174
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 13:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbiFZLMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 07:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbiFZLMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 07:12:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A03614090;
        Sun, 26 Jun 2022 04:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=o0GW7CA8KUZY6d8aF+3/YcEueAIlMj5T+JesYfgsKuc=; b=zqcujx+80DTsCWXxoP71ZqxRYi
        uCkXs9GDLZ1MhcvWG0Y8ygzDPxwYNDA+VblI5CwPMk/Dfe6PjWXVIf2zeuDaxgkML320qxcWC2ekB
        0LKBfFjCt2veWJeiYdqQo8uD10cpk0QhsZXz5h9bAdmMGz2FWhIiP0XrPuG9E6F/lG9E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o5QBp-008Hu5-5d; Sun, 26 Jun 2022 13:12:29 +0200
Date:   Sun, 26 Jun 2022 13:12:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sebastian Gottschall <s.gottschall@newmedia-net.de>
Cc:     Praghadeesh T K S <praghadeeshthevendria@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        praghadeeshtks@zohomail.in, skhan@linuxfoundation.org
Subject: Re: [PATCH] net: wireless/broadcom: fix possible condition with no
 effect
Message-ID: <Yrg/HTOnVF53WRVV@lunn.ch>
References: <20220625192902.30050-1-praghadeeshthevendria@gmail.com>
 <458bd8dd-29c2-8029-20f5-f746db57740a@newmedia-net.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <458bd8dd-29c2-8029-20f5-f746db57740a@newmedia-net.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 26, 2022 at 01:03:57PM +0200, Sebastian Gottschall wrote:
> Am 25.06.2022 um 21:29 schrieb Praghadeesh T K S:
> > Fix a coccinelle warning by removing condition with no possible effect
> > 
> > Signed-off-by: Praghadeesh T K S <praghadeeshthevendria@gmail.com>
> > ---
> >   drivers/net/wireless/broadcom/b43/xmit.c | 7 +------
> >   1 file changed, 1 insertion(+), 6 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/broadcom/b43/xmit.c b/drivers/net/wireless/broadcom/b43/xmit.c
> > index 7651b1b..667a74b 100644
> > --- a/drivers/net/wireless/broadcom/b43/xmit.c
> > +++ b/drivers/net/wireless/broadcom/b43/xmit.c
> > @@ -169,12 +169,7 @@ static u16 b43_generate_tx_phy_ctl1(struct b43_wldev *dev, u8 bitrate)
> >   	const struct b43_phy *phy = &dev->phy;
> >   	const struct b43_tx_legacy_rate_phy_ctl_entry *e;
> >   	u16 control = 0;
> > -	u16 bw;
> > -
> > -	if (phy->type == B43_PHYTYPE_LP)
> > -		bw = B43_TXH_PHY1_BW_20;
> > -	else /* FIXME */
> > -		bw = B43_TXH_PHY1_BW_20;
> > +	u16 bw = B43_TXH_PHY1_BW_20;

Hi Praghadeesh

I assume you took a deep look at the FIXME, understand why it is
there, looked at the datasheet etc, and decided it is not in fact
broken. Hence it is safe to remove the FIXME. Please could you
summarise your findings in the commit messages.

	  Andrew
