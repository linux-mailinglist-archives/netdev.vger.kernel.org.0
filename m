Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A0D1299D2
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 19:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfLWSX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 13:23:26 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18640 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726756AbfLWSX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 13:23:26 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBNIKfna002196;
        Mon, 23 Dec 2019 10:23:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=lBm3Kcp0twaluuIWcawWcxg6ADa767FM2VA7c82xUO4=;
 b=ygdJEMb2TeKZGBwwDA68bn4vVJR4WMPksLrI+ls8XHwBvtqxrdzC3u/Xv567S6XgG9Rv
 eV/gLAI4+Yfcj2i9YzeBK7uaLK0kMLPV+gze9NVMDX6VGF25TiWMkMploUTDhl/d19gK
 3VnTfhnt1peIRfy67Bd4ZQGQ7RVzpZxXAhFOlDDdOawd1A8mUpkIA50GFIOOWnwmzNCU
 0TCLeRXBPzxKruwiVxF7Nz796ArzAkEbnLES517TJj4hmF/Cgvd8yQuwGUrLUFuOA9oY
 T2AzjPzrFOBicfcmBgEg5Ig5atq1UswFRNa6MzEwhNmAUiFDNe7AKk9ClDa2JUlVRaf5 3g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2x1hmv5yjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Dec 2019 10:23:24 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Dec
 2019 10:23:22 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 23 Dec 2019 10:23:23 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3EFF63F703F;
        Mon, 23 Dec 2019 10:23:23 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBNINNeU003972;
        Mon, 23 Dec 2019 10:23:23 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBNINNpO003971;
        Mon, 23 Dec 2019 10:23:23 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <skalluru@marvell.com>
Subject: [PATCH net 2/2] bnx2x: Fix accounting of vlan resources among the PFs
Date:   Mon, 23 Dec 2019 10:23:09 -0800
Message-ID: <20191223182309.3919-3-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191223182309.3919-1-manishc@marvell.com>
References: <20191223182309.3919-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_07:2019-12-23,2019-12-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing max vlan configuration on the PF, firmware gets
assert as driver was configuring number of vlans more than what
is supported per port/engine, it was figured out that there is an
implicit vlan (hidden default vlan consuming hardware cam entry resource)
which is configured default for all the clients (PF/VFs) on client_init
ramrod by the adapter implicitly, so when allocating resources among the
PFs this implicit vlan should be considered or total vlan entries should
be reduced by one to accommodate that default/implicit vlan entry.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h
index ed237854939a..bacc8552bce1 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h
@@ -1536,8 +1536,11 @@ void bnx2x_get_rss_ind_table(struct bnx2x_rss_config_obj *rss_obj,
 	((MAX_MAC_CREDIT_E2 - GET_NUM_VFS_PER_PATH(bp) * VF_MAC_CREDIT_CNT) / \
 	 func_num + GET_NUM_VFS_PER_PF(bp) * VF_MAC_CREDIT_CNT)
 
+#define BNX2X_VFS_VLAN_CREDIT(bp)	\
+	(GET_NUM_VFS_PER_PATH(bp) * VF_VLAN_CREDIT_CNT)
+
 #define PF_VLAN_CREDIT_E2(bp, func_num)					 \
-	((MAX_VLAN_CREDIT_E2 - GET_NUM_VFS_PER_PATH(bp) * VF_VLAN_CREDIT_CNT) /\
+	((MAX_VLAN_CREDIT_E2 - 1 - BNX2X_VFS_VLAN_CREDIT(bp)) /	\
 	 func_num + GET_NUM_VFS_PER_PF(bp) * VF_VLAN_CREDIT_CNT)
 
 #endif /* BNX2X_SP_VERBS */
-- 
2.18.1

