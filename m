Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06606A1C3C
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 13:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjBXMgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 07:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjBXMgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 07:36:13 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC6F671F8
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 04:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oOUHfm6liK2+pEkFLHJseKqdt6YDS6UDIHuq/c0TaYE=; b=z8KdmSnkzkHmL83t8pGRNLz1+D
        CC4LZFOjWj+X1hOVleI5M4h6cu8bYP5ARnxb5Wxf3NQ6qiSfUju2vMZ4J8iZz1Jeawbzh/AIizPlC
        N05QPZ+2PU+rbBHxnbw8TYYYEienuFt2kpx4ecGTvWx5UNO06k80+AoGApYBc3umEXkOHzBLygDNP
        Ex+H7NepQD2eqKfSWwSHN+Px54dExvyzukOXZEQMdWPXrFqJGYK4r2E2DDYWMERigAjxtONLEKTBO
        L9VrQhZS1uN43fZR00z1ENsZCbuQc56KuDZdOsBgBq6vQUcrENLngzWI7nZL6xXrzPZSPqBKkopND
        OSPTF8TQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35628)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pVXIg-0000cw-7b; Fri, 24 Feb 2023 12:35:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pVXIa-0005PH-Am; Fri, 24 Feb 2023 12:35:40 +0000
Date:   Fri, 24 Feb 2023 12:35:40 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH RFC net-next 0/4] Various mtk_eth_soc cleanups
Message-ID: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

These are a number of patches that do a bit of cleanup to mtk_eth_soc,
including one (the last) which seems to indicate that I somehow missed
adding RMII and REVMII to the supported_interfaces - but no one has
complained, and checking the DT files in the kernel, no one uses these
modes (so the driver is probably untested for these.)

The first patch cleans up mtk_gmac0_rgmii_adjust(), which is the
troublesome function preventing the driver becoming a post-March2020
phylink driver. It doesn't solve that problem, merely makes the code
easier to follow by getting rid of repeated tenary operators.

The second patch moves the check for DDR2 memory to the initialisation
of phylink's supported_interfaces - if TRGMII is not possible for some
reason, we should not be erroring out in phylink MAC operations when
that can be determined prior to phylink creation.

The third patch removes checks from mtk_mac_config() that are done
when initialising supported_interfaces - phylink will not call
mtk_mac_config() with an interface that was not marked as supported,
so these checks are redundant.

The last patch adds comments for REVMII and RMII. As I note, these
seem to be unused in the DT files, and as no one has reported that
these don't work, I suggest that no one uses them. Should we drop
support for these modes, or add them to supported_interfaces?

Please review, and I'll collect attributations for resending after
net-next has re-opened.

Thanks.

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 71 ++++++++++++++---------------
 1 file changed, 34 insertions(+), 37 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
