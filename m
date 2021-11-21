Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDEE458572
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 18:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238420AbhKURaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 12:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235943AbhKURaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 12:30:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B41C061574
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 09:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4YX+422lpA2i2obPa2qv1ZJT/yjDHECZ/2EezDPv3Nk=; b=vxIcO9/uW/4vT2/OrMcJ2QC6Sw
        QcH/F/HzpvvcuGjMnA6EWU2v0Ko02tRle+bahtIy+D+4DiqL0matDQugKVduL+kWx7sLgVDypCdrG
        q6cGTpbj8p/vVOTGr9os6cqH+Eu+1wmuSW2WMWhMjKOE2H9gfMap93B6Lm2OR4+LRYvs1HMF/6Ri5
        pNoB+zdSb8MhplqqBIAaDQzviFbiyfhLn1YNFp6+vJOgff4lc8Ft1sIE9ztBTclKfVLP7+yWu8TRU
        QFyr/L9q/ncn+BAXrIHq6pPpkCNRisrwdjAzWfqlPRp1gkPxIfAyGWK4ARKHEH3tPertFDeGQFB9I
        YAyE5g1A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55778)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1moqcS-0005nN-R2; Sun, 21 Nov 2021 17:27:12 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1moqcQ-0006u9-Fz; Sun, 21 Nov 2021 17:27:10 +0000
Date:   Sun, 21 Nov 2021 17:27:10 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Landen Chao <landen.chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     netdev@vger.kernel.org
Subject: mt753x DSA switch support - bug?
Message-ID: <YZqBbvbBrj3OAz4i@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

While updating drivers that use phylink, I came across this code in
the mt7530 driver in mt753x_phylink_validate():

        if (state->interface != PHY_INTERFACE_MODE_TRGMII ||
            !phy_interface_mode_is_8023z(state->interface)) {
                phylink_set(mask, 10baseT_Half);
                phylink_set(mask, 10baseT_Full);
                phylink_set(mask, 100baseT_Half);
                phylink_set(mask, 100baseT_Full);
                phylink_set(mask, Autoneg);
        }

which looks wrong to me. The if() condition is always true, so all
these modes are always set in the mask.

If state->interface is PHY_INTERFACE_MODE_TRGMII, then the first
part of the condition is false. phy_interface_mode_is_8023z() is
also false, so !phy_interface_mode_is_8023z() will be true. The
logical-or results in the if() condition being true.

If state->interface is PHY_INTERFACE_MODE_1000BASEX, then the first
part of the condition is true, and due to the logical-or not needing
to be further evaluated, results in the if() condition being true.

If state->interface is PHY_INTERFACE_MODE_RGMII, then the first part
of the condition is true, and this is exactly the same as the second
case above.

I think that "||" should be "&&", since I believe you intend these
modes not to be available in TRGMII nor 802.3z modes. Please confirm.
Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
