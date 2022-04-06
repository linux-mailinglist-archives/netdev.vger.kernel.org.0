Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5AD4F66C0
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238613AbiDFRN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238587AbiDFRNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:13:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B00A45907F
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 07:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zzkoDaINZ+gLK8TuKhSiIzaVc1cKAzjQiu56MMZAxVY=; b=UdEw+O+evcTtk7HiR6VaoTzLVY
        3/hleNnCkSftbhyDgikJuJdN241DKmca5s4HkEoXpp+nL1AnxmzJJLIjxvShTbNQsDhicT1RT6QlX
        bUcNOjKE7e/9FP/Ju8lY4pEoSBlQR57m7/nqtfRITeYDsxj1EOAin17e1uQQZ5oGBTlT2p3o8YFCm
        oz+miU0+7E4pCofLXMI+k7X2GPHAInH2CDhoH2+7pAsksw0BAUgsoFkWJlzB/orNtHhwJ+1VW6uHN
        TuA0ZWjqIfd0ttFCITM5Vw4DidL1GMWCCD+i0UPU61oJN5XEg/D81eRtSrFTBuFQIHi56nwcye+hz
        mxSx3Fbw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58148)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nc6jw-0002tc-K8; Wed, 06 Apr 2022 15:34:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nc6js-0005Dm-H3; Wed, 06 Apr 2022 15:34:28 +0100
Date:   Wed, 6 Apr 2022 15:34:28 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>, Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH RFC 00/12] mtk_eth_soc phylink updates
Message-ID: <Yk2k9D40QojsRhoo@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

This series ultimately updates mtk_eth_soc to use phylink_pcs, with some
fixes along the way.

Previous attempts to update this driver (which is now marked as legacy)
have failed due to lack of testing. I am hoping that this time will be
different; Marek can test RGMII modes, but not SGMII. So all that we
know is that this patch series probably doesn't break RGMII.

1) remove unused mac_mode and sgmii flags members from structures.
2) remove unnecessary interpretation of speed when configuring 1000
   and 2500 Base-X
3) move configuration of SGMII duplex setting from mac_config() to
   link_up()
4) only pass in interface mode to mtk_sgmii_setup_mode_force()
5) move decision about which mtk_sgmii_setup_mode_*() function to call
   into mtk_sgmii.c
6) add a fixme comment for RGMII explaning why the call to
   mtk_gmac0_rgmii_adjust() is completely wrong - this needs to be
   addressed by someone who has the hardware and can test an appropriate
   fix. This fixme means that the driver still can't become non-legacy.
7) move gmac setup from mac_config() to mac_finish() - this preserves
   the order that we write to the hardware when we eventually convert to
   phylink_pcs()
8) move configuration of syscfg0 in SGMII/802.3z mode to mac_finish()
   for the same reasons as (7).
9) convert mtk_sgmii.c code structure and the mtk_sgmii structure to
   suit conversion to phylink_pcs
10) finally convert to phylink_pcs

It would be nice to get these changes fully tested, but past experience
has shown that for this driver, that's unfortunately very unlikely. So,
I propose that the merging plan for this is that if there are no
comments after three weeks to a month, I'll send this for inclusion in
net-next.

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 103 +++++++++-------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  40 +++----
 drivers/net/ethernet/mediatek/mtk_sgmii.c   | 174 ++++++++++++++++------------
 3 files changed, 185 insertions(+), 132 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
