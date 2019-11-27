Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B36E10B2D9
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 16:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfK0P7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 10:59:19 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:40986 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfK0P7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 10:59:18 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xARFxEcr106737;
        Wed, 27 Nov 2019 09:59:14 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574870354;
        bh=YRWe/K0Aw3uLblw7Xsa+RJ5R4nqhOQRu3ZilF1Lpw18=;
        h=From:To:CC:Subject:Date;
        b=JOd+v619xGmfvIPkefpbpMGiLuJ/cs/4ASFQKEHvl4kGIeknMK8T8Qyc85QUgnyPI
         9Pr79JneRvj+Vj1y7/Q1r1Hx8tZ9/3R/w7WTBdtxoB8vg5R+p6QnV9D8TcEGXTb0OO
         1kxoJj7Ws5nuW4mdhXTA/X2N+NJFkoLyVEcSF1kM=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xARFxEqZ053544
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 Nov 2019 09:59:14 -0600
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 27
 Nov 2019 09:59:14 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 27 Nov 2019 09:59:13 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xARFxCKS127610;
        Wed, 27 Nov 2019 09:59:13 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>
CC:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, Sekhar Nori <nsekhar@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] net: ethernet: ti: ale: ensure vlan/mdb deleted when no members
Date:   Wed, 27 Nov 2019 17:59:05 +0200
Message-ID: <20191127155905.22921-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recently updated ALE APIs cpsw_ale_del_mcast() and
cpsw_ale_del_vlan_modify() have an issue and will not delete ALE entry even
if VLAN/mcast group has no more members. Hence fix it here and delete ALE
entry if !port_mask.

The issue affected only new cpsw switchdev driver.

Fixes: e85c14370783 ("net: ethernet: ti: ale: modify vlan/mdb api for switchdev")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 929f3d3354e3..a5179ecfea05 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -396,12 +396,14 @@ int cpsw_ale_del_mcast(struct cpsw_ale *ale, const u8 *addr, int port_mask,
 	if (port_mask) {
 		mcast_members = cpsw_ale_get_port_mask(ale_entry,
 						       ale->port_mask_bits);
-		mcast_members &= ~port_mask;
-		cpsw_ale_set_port_mask(ale_entry, mcast_members,
+		port_mask = mcast_members & ~port_mask;
+	}
+
+	if (port_mask)
+		cpsw_ale_set_port_mask(ale_entry, port_mask,
 				       ale->port_mask_bits);
-	} else {
+	else
 		cpsw_ale_set_entry_type(ale_entry, ALE_TYPE_FREE);
-	}
 
 	cpsw_ale_write(ale, idx, ale_entry);
 	return 0;
@@ -478,6 +480,10 @@ static void cpsw_ale_del_vlan_modify(struct cpsw_ale *ale, u32 *ale_entry,
 	members = cpsw_ale_get_vlan_member_list(ale_entry,
 						ale->vlan_field_bits);
 	members &= ~port_mask;
+	if (!members) {
+		cpsw_ale_set_entry_type(ale_entry, ALE_TYPE_FREE);
+		return;
+	}
 
 	untag = cpsw_ale_get_vlan_untag_force(ale_entry,
 					      ale->vlan_field_bits);
-- 
2.17.1

