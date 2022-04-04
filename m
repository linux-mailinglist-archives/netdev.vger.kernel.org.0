Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0FF4F140E
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 13:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiDDLwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 07:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiDDLwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 07:52:34 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCB83CA73;
        Mon,  4 Apr 2022 04:50:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1649072989; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=mo9jhXQZ7dDfCf1zx7Yyf+stoyzYLHDat6/ldYvgARU4DTqk8M/fLkTKnk6kk4m8K4dDx/tbE29b02iB/+7WXLZVRt7BlxIAwga5gqJUmEcl1lwZPbYgk21o8TIOcGFeoY3s0Mn3bsubyzEqVQw9r+vjftyvK0Td6cDS0tLLy6k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1649072989; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=wH4MR2QRn9EFb2QbwxNQgFaKaRIZbXHNTjFSYpDqoMw=; 
        b=mvN16TYvpnQFqPff72eSPvIC0ozSHO71u54Mb9PCl6qVOfs55jVj68Nkm+weM4gCFg5kXX4T2LXE5+xbCP3qxkh9t/PeTwxTlKpBGcp4N+eK2KpPxvl0tjkMZyjmT97nrv+bq0/D604smZ9Nm/IYVVQB/EPkS7bim5lBRhRP5KI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1649072989;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Message-Id:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=wH4MR2QRn9EFb2QbwxNQgFaKaRIZbXHNTjFSYpDqoMw=;
        b=IkEd+cky5pBihx3tcwh3yFXJsL52aUpLmKI7SE1Veg6+CXdfer2QOO4OVurIN1cz
        kqH2BKaeeH708amasT03Nq1Lhc31tl7VooNJHHiuYATvSkEcCoDsm/Wsnxxl25FMKqS
        LHIoyRojQWUtUkheDaeSrCqNTo+eHvfAZKOwAWbg=
Received: from arinc9-PC.localdomain (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1649072986682935.7989606149916; Mon, 4 Apr 2022 04:49:46 -0700 (PDT)
From:   =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To:     Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH] net: ethernet: mtk_eth_soc: add label support for GMACs
Date:   Mon,  4 Apr 2022 14:40:00 +0300
Message-Id: <20220404114000.3549-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: René van Dorst <opensource@vdorst.com>

Add label support for GMACs. The network interface of the GMAC will have
the string of the label property defined on the devicetree as its name.

Signed-off-by: René van Dorst <opensource@vdorst.com>
[arinc.unal@arinc9.com: change commit log and rebase to current net-next]
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index f02d07ec5ccb..af2f0693180a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2911,6 +2911,7 @@ static const struct net_device_ops mtk_netdev_ops = {
 
 static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 {
+	const char *name = of_get_property(np, "label", NULL);
 	const __be32 *_id = of_get_property(np, "reg", NULL);
 	phy_interface_t phy_mode;
 	struct phylink *phylink;
@@ -3033,6 +3034,9 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	else
 		eth->netdev[id]->max_mtu = MTK_MAX_RX_LENGTH_2K - MTK_RX_ETH_HLEN;
 
+	if (name)
+		strlcpy(eth->netdev[id]->name, name, IFNAMSIZ);
+
 	return 0;
 
 free_netdev:
-- 
2.25.1

