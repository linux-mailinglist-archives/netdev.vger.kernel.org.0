Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A659A54FFA6
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 00:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbiFQWBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 18:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235560AbiFQWBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 18:01:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900125D1A4;
        Fri, 17 Jun 2022 15:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+N2H+x44Iv08WsRXm2it/nhRDV8pHzv6Cqk9ZurKm5k=; b=X2qZ8Kde29X9DMRY4lTIZ/k3NS
        7krTSzi2HiIlRyudWk10Um2yZAkDxYoutdORY4W7lG9yTNwZ4c9RE5/nRES0AQPNWNMh1lOXL2sZq
        sFf8B5UOm4QQoYfsVg+qpKOJAqC+8M2CGHZ80E1zuGirpOm74jKERmPhDIUNgGZ96w6hAzej3/rjQ
        bu6sXtU8AIuxbT6BvaR8grdRWPf7mtDB7MQlH2XzD1XffIUrN3pss0BnRscM7xvo31OU/9bXuUGCp
        r6m6kbbZyG4FhwEjlszkU3ydaJHnII45fQ84SohWkixNIavNqrUJvJMLJ2fsjTMftb/JLHN0y05yJ
        QsthPtag==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32904)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o2K27-0003OY-MH; Fri, 17 Jun 2022 23:01:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o2K25-0002HX-13; Fri, 17 Jun 2022 23:01:37 +0100
Date:   Fri, 17 Jun 2022 23:01:36 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 25/28] [RFC] net: dpaa: Convert to phylink
Message-ID: <Yqz5wHy9zAQL1ddg@shell.armlinux.org.uk>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-26-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617203312.3799646-26-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jun 17, 2022 at 04:33:09PM -0400, Sean Anderson wrote:
> This converts DPAA to phylink. For the moment, only MEMAC is converted.
> This should work with no device tree modifications (including those made in
> this series), except for QSGMII (as noted previously).
> 
> One area where I wasn't sure how to do things was regarding when to call
> phy_init and phy_power_on. Should that happen when selecting the PCS?

Is this a common serdes PHY that is shared amongst the various PCS? I
think from what I understand having read the other patches, it is. In
which case, initialising the PHY prior to calling phylink_start() and
powering down the PHY after phylink_stop() should be sufficient.

> Similarly, I wasn't sure where to reconfigure the thresholds in
> dpaa_eth_cgr_init. Should happen in link_up? If so, I think we will need
> some kind of callback.

Bear in mind that with 1000BASE-X, SGMII, etc, we need the link working
in order for the link to come up, so if the serdes PHY hasn't been
properly configured for the interface mode, then the link may not come
up.

How granular are these threshold configurations? Do they depend on
speed? (Note that SGMII operates at a constant speed irrespective of
the data rate due to symbol replication, so there shouldn't be a speed
component beyond that described by the interface mode, aka
phy_interface_t.)

> This has been tested on an LS1046ARDB. Without the serdes enabled,
> everything works. With the serdes enabled, everything works but eth3 (aka
> MAC6). On that interface, SGMII never completes AN for whatever reason. I
> haven't tested the counterfactual (serdes enabled but no phylink). With
> managed=phy (e.g. unspecified), I was unable to get the interfaces to come
> up at all.

I'm not sure of the level of accurate detail in the above statement,
so the following is just to cover all bases...

It's worth enabling debug in phylink so you can see what's going on -
for example, whether the "MAC" (actually PCS today) is reporting that
the link came up (via its pcs_get_state() callback.) Also whether
phylib is reporting that the PHY is saying that the link is up. That
should allow you to identify which part of the system is not

Having looked through your phylink implementation, nothing obviously
wrong stands out horribly in terms of how you're using it.

The only issue I've noticed is in dpaa_ioctl(), where you only forward
one ioctl command to phylink, whereas there are actually three ioctls
for PHY access - SIOCGMIIPHY, SIOCGMIIREG and SIOCSMIIREG. Note that
phylink (and phylib) return -EOPNOTSUPP if the ioctl is not appropriate
for them to handle. However, note that phylib will handle
SIOCSHWTSTAMP.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
