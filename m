Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C711AFBA1
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 13:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfIKLnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 07:43:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:65012 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727806AbfIKLnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 07:43:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8BBbL0m020084;
        Wed, 11 Sep 2019 04:43:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=tbgQxomcqigM7VDCwko5xkkMrNDhWIcSlAE5QjCjqxI=;
 b=ADbVVLGag7cWZoOnajXQV4wzP2HPrHzKd5t+0t+VLu0jifCH7e2XYcVMkJ+5CYArUvsL
 uwPRMcWHStx+uHXhWy1S1mWM+7BDtFEUFe3eBF5MH6W5219EZYibZRs2E2Eu/hBrNCcq
 +AAQTHSLW0qhp5dFbBGihcTIe+quaPkVmoZR4AiLs4JeFvkxz9p/WY/TczOrN79Evo5Z
 8HIQbuxHPtWK7npjTkHCcZ99hhinkGuS5cueEbD4yMtVsR/V5J2ZLNU1NJk5PglJT0+7
 GtkAk4pf7cbNPGDuna33rWIQyd8ZpUCaIkgwhfaNuI8m89NwarvQITap0ribNu2v13rk +w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uvc2js69b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Sep 2019 04:43:04 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 11 Sep
 2019 04:43:02 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Wed, 11 Sep 2019 04:43:02 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 21C7D3F7041;
        Wed, 11 Sep 2019 04:43:02 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8BBh2RU007058;
        Wed, 11 Sep 2019 04:43:02 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8BBh138007057;
        Wed, 11 Sep 2019 04:43:01 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 2/2] qed: Fix Config attribute frame format.
Date:   Wed, 11 Sep 2019 04:42:51 -0700
Message-ID: <20190911114251.7013-3-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190911114251.7013-1-skalluru@marvell.com>
References: <20190911114251.7013-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-11_07:2019-09-11,2019-09-11 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MFW associates the entity id to a config attribute instead of assigning
one entity id for all the config attributes.
This patch incorporates driver changes to link entity id to a config id
attribute.

Fixes: 0dabbe1bb3a4 ("qed: Add driver API for flashing the config attributes.")
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 38c0ec3..2ce7009 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -2240,12 +2240,13 @@ static int qed_nvm_flash_image_validate(struct qed_dev *cdev,
 /* Binary file format -
  *     /----------------------------------------------------------------------\
  * 0B  |                       0x5 [command index]                            |
- * 4B  | Entity ID     | Reserved        |  Number of config attributes       |
- * 8B  | Config ID                       | Length        | Value              |
+ * 4B  | Number of config attributes     |          Reserved                  |
+ * 4B  | Config ID                       | Entity ID      | Length            |
+ * 4B  | Value                                                                |
  *     |                                                                      |
  *     \----------------------------------------------------------------------/
- * There can be several cfg_id-Length-Value sets as specified by 'Number of...'.
- * Entity ID - A non zero entity value for which the config need to be updated.
+ * There can be several cfg_id-entity_id-Length-Value sets as specified by
+ * 'Number of config attributes'.
  *
  * The API parses config attributes from the user provided buffer and flashes
  * them to the respective NVM path using Management FW inerface.
@@ -2265,18 +2266,17 @@ static int qed_nvm_flash_cfg_write(struct qed_dev *cdev, const u8 **data)
 
 	/* NVM CFG ID attribute header */
 	*data += 4;
-	entity_id = **data;
-	*data += 2;
 	count = *((u16 *)*data);
-	*data += 2;
+	*data += 4;
 
 	DP_VERBOSE(cdev, NETIF_MSG_DRV,
-		   "Read config ids: entity id %02x num _attrs = %0d\n",
-		   entity_id, count);
+		   "Read config ids: num_attrs = %0d\n", count);
 	/* NVM CFG ID attributes */
 	for (i = 0; i < count; i++) {
 		cfg_id = *((u16 *)*data);
 		*data += 2;
+		entity_id = **data;
+		(*data)++;
 		len = **data;
 		(*data)++;
 		memcpy(buf, *data, len);
@@ -2286,7 +2286,8 @@ static int qed_nvm_flash_cfg_write(struct qed_dev *cdev, const u8 **data)
 			QED_NVM_CFG_SET_FLAGS;
 
 		DP_VERBOSE(cdev, NETIF_MSG_DRV,
-			   "cfg_id = %d len = %d\n", cfg_id, len);
+			   "cfg_id = %d entity = %d len = %d\n", cfg_id,
+			   entity_id, len);
 		rc = qed_mcp_nvm_set_cfg(hwfn, ptt, cfg_id, entity_id, flags,
 					 buf, len);
 		if (rc) {
-- 
1.8.3.1

