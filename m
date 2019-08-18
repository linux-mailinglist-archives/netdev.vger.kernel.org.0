Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5E791752
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 16:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfHROZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 10:25:54 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42848 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726097AbfHROZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 10:25:54 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7IEPprj031410;
        Sun, 18 Aug 2019 07:25:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=8/caMfNQZ5mLqcQZw88sSFmgxEjFo8vH8DXG7+VbdvU=;
 b=kciRO/U4xPd3K56YzD3PDc2dgbgAslKZZfhEd71bpj08E3XlqXitqMVGQ43I7CyIrKNX
 xUilEud+mK2L6YUqyP4VN7VQTyXFIJazR0vfTaP+EWvWTyiuLNPBZO00571zIB8tUeVV
 m3gOfdFycpP4lSHNwXy7sHFbP6iSgOXKruhVEyODyRj8ExWkk9nQMnlXzkjIorM1OtDP
 BX/91u3VlAhi59K/mCAedeAkUhswi8g3tdvVArG+iGBLVAesMosodATxuQ8wCJcyL18I
 t0M2O/dsz/tYFTFHTKb/TQbzPUYlnvEF9KJNHGRwta4fmQgvpDWIcR71N73DhSmBz//+ 1A== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ueexpkgkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 18 Aug 2019 07:25:51 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 18 Aug
 2019 07:25:50 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Sun, 18 Aug 2019 07:25:50 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 428DA3F703F;
        Sun, 18 Aug 2019 07:25:50 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7IEPogD022402;
        Sun, 18 Aug 2019 07:25:50 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7IEPn4x022401;
        Sun, 18 Aug 2019 07:25:49 -0700
From:   Manish Chopra <manishc@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <skalluru@marvell.com>
Subject: [PATCH net 1/1] bnx2x: Fix VF's VLAN reconfiguration in reload.
Date:   Sun, 18 Aug 2019 07:25:48 -0700
Message-ID: <20190818142548.22365-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-18_07:2019-08-16,2019-08-18 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 04f05230c5c13 ("bnx2x: Remove configured vlans as
part of unload sequence."), introduced a regression in driver
that as a part of VF's reload flow, VLANs created on the VF
doesn't get re-configured in hardware as vlan metadata/info
was not getting cleared for the VFs which causes vlan PING to stop.

This patch clears the vlan metadata/info so that VLANs gets
re-configured back in the hardware in VF's reload flow and
PING/traffic continues for VLANs created over the VFs.

Fixes: 04f05230c5c13 ("bnx2x: Remove configured vlans as part of unload sequence.")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Sudarsana Kalluru <skalluru@marvell.com>
Signed-off-by: Shahed Shaikh <shshaikh@marvell.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |  7 ++++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h |  2 ++
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c    | 17 ++++++++++++-----
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index e47ea92e2ae3..d10b421ed1f1 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -3057,12 +3057,13 @@ int bnx2x_nic_unload(struct bnx2x *bp, int unload_mode, bool keep_link)
 	/* if VF indicate to PF this function is going down (PF will delete sp
 	 * elements and clear initializations
 	 */
-	if (IS_VF(bp))
+	if (IS_VF(bp)) {
+		bnx2x_clear_vlan_info(bp);
 		bnx2x_vfpf_close_vf(bp);
-	else if (unload_mode != UNLOAD_RECOVERY)
+	} else if (unload_mode != UNLOAD_RECOVERY) {
 		/* if this is a normal/close unload need to clean up chip*/
 		bnx2x_chip_cleanup(bp, unload_mode, keep_link);
-	else {
+	} else {
 		/* Send the UNLOAD_REQUEST to the MCP */
 		bnx2x_send_unload_req(bp, unload_mode);
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
index c2f6e44e9a3f..8b08cb18e363 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
@@ -425,6 +425,8 @@ void bnx2x_set_reset_global(struct bnx2x *bp);
 void bnx2x_disable_close_the_gate(struct bnx2x *bp);
 int bnx2x_init_hw_func_cnic(struct bnx2x *bp);
 
+void bnx2x_clear_vlan_info(struct bnx2x *bp);
+
 /**
  * bnx2x_sp_event - handle ramrods completion.
  *
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 2cc14db8f0ec..192ff8d5da32 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -8482,11 +8482,21 @@ int bnx2x_set_vlan_one(struct bnx2x *bp, u16 vlan,
 	return rc;
 }
 
+void bnx2x_clear_vlan_info(struct bnx2x *bp)
+{
+	struct bnx2x_vlan_entry *vlan;
+
+	/* Mark that hw forgot all entries */
+	list_for_each_entry(vlan, &bp->vlan_reg, link)
+		vlan->hw = false;
+
+	bp->vlan_cnt = 0;
+}
+
 static int bnx2x_del_all_vlans(struct bnx2x *bp)
 {
 	struct bnx2x_vlan_mac_obj *vlan_obj = &bp->sp_objs[0].vlan_obj;
 	unsigned long ramrod_flags = 0, vlan_flags = 0;
-	struct bnx2x_vlan_entry *vlan;
 	int rc;
 
 	__set_bit(RAMROD_COMP_WAIT, &ramrod_flags);
@@ -8495,10 +8505,7 @@ static int bnx2x_del_all_vlans(struct bnx2x *bp)
 	if (rc)
 		return rc;
 
-	/* Mark that hw forgot all entries */
-	list_for_each_entry(vlan, &bp->vlan_reg, link)
-		vlan->hw = false;
-	bp->vlan_cnt = 0;
+	bnx2x_clear_vlan_info(bp);
 
 	return 0;
 }
-- 
2.18.1

