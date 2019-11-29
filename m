Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2545510D93F
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 18:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfK2R6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 12:58:20 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:58620 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbfK2R6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 12:58:20 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xATHwDjG058044;
        Fri, 29 Nov 2019 11:58:13 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575050293;
        bh=P1uSBoJmDQ8Q5hjwiJepbv6UkgzRKi6n7TO9FbhvtSs=;
        h=From:To:CC:Subject:Date;
        b=zC2MmyuIkoRw3U2qRpJjMXjPe6NJEWZ985i7CfqBhv6IRXMIKjwZr72sU9naqOL9e
         XFB0d2SV79b8BpNXutvRnMncDCvAKmJMx2me8HFwjJIR4LfA5+hBr58E2nUWiyHcwb
         KxMtCK1Wva0CCwOQa7uat3MmPbukrv5MeLrmgxQ8=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xATHwDmg059290
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 29 Nov 2019 11:58:13 -0600
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 29
 Nov 2019 11:58:13 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 29 Nov 2019 11:58:13 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xATHwCfi110240;
        Fri, 29 Nov 2019 11:58:12 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>
CC:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, Sekhar Nori <nsekhar@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v2] net: ethernet: ti: ale: ensure vlan/mdb deleted when no members
Date:   Fri, 29 Nov 2019 19:58:09 +0200
Message-ID: <20191129175809.815-1-grygorii.strashko@ti.com>
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
 drivers/net/ethernet/ti/cpsw_ale.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 929f3d3354e3..ecdbde539eb7 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -384,7 +384,7 @@ int cpsw_ale_del_mcast(struct cpsw_ale *ale, const u8 *addr, int port_mask,
 		       int flags, u16 vid)
 {
 	u32 ale_entry[ALE_ENTRY_WORDS] = {0, 0, 0};
-	int mcast_members;
+	int mcast_members = 0;
 	int idx;
 
 	idx = cpsw_ale_match_addr(ale, addr, (flags & ALE_VLAN) ? vid : 0);
@@ -397,11 +397,13 @@ int cpsw_ale_del_mcast(struct cpsw_ale *ale, const u8 *addr, int port_mask,
 		mcast_members = cpsw_ale_get_port_mask(ale_entry,
 						       ale->port_mask_bits);
 		mcast_members &= ~port_mask;
+	}
+
+	if (mcast_members)
 		cpsw_ale_set_port_mask(ale_entry, mcast_members,
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

