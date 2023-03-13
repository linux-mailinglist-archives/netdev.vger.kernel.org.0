Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3192F6B73F9
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCMK2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjCMK2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:28:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B5811158;
        Mon, 13 Mar 2023 03:28:32 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32DAC09w005750;
        Mon, 13 Mar 2023 10:28:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=muZ9b9QG8ti4PvgdDLqM1F05w3CLaqzEdtPew8PthAQ=;
 b=jGPYURnoYs54v2ATfz5BnKT+WBtz5Rcer/kgw9jM5pGjxM/M7ev2d3UHyIUwZyIAYmzy
 8pZuVTtP8DB+ZWwl9uaaSwImYNvUgEp9MT42QK4TZwQDDgmCmoeGp6uj/45Zz3M8uIaz
 uHwmPpl1nMrswxPx7WyKH8xAkFSG6yFoxSc37HEKaUSO5MCPSYxh3aj8M5Y5WKljPrY+
 FWOV8q8/pSPEy/9JtMkmBRthbJrB+H2kLEkgQ5nChjli2FMuIvsC4k3WBrzsLDag7be2
 03TbcUWuInwnVJgtDz2Xr/1zFPKAuj7hlP84FPjqpkf1mlc0N7k631rL0vbKccV2a4SC BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p93aksjxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 10:28:27 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32DAGXLW022821;
        Mon, 13 Mar 2023 10:28:26 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p93aksjwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 10:28:26 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32CKQvOS006605;
        Mon, 13 Mar 2023 10:28:24 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3p8h96jfbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 10:28:24 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32DASLFr62980492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Mar 2023 10:28:21 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1E5F20229;
        Mon, 13 Mar 2023 10:10:45 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3A782022B;
        Mon, 13 Mar 2023 10:10:41 +0000 (GMT)
Received: from MBP-von-Wenjia.fritz.box.com (unknown [9.163.87.100])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 13 Mar 2023 10:10:41 +0000 (GMT)
From:   Wenjia Zhang <wenjia@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Subject: [PATCH net-next 1/2] net/smc: Introduce explicit check for v2 support
Date:   Mon, 13 Mar 2023 11:10:31 +0100
Message-Id: <20230313101032.13180-2-wenjia@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313101032.13180-1-wenjia@linux.ibm.com>
References: <20230313101032.13180-1-wenjia@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OfyVVgSNn4r-s8iLu0L3je1LA3ot-Z7b
X-Proofpoint-GUID: JwHKG8QIAfbMqc4A0k27mnMb21uiHMUA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_02,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303130082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Raspl <raspl@linux.ibm.com>

Previously, v2 support was derived from a very specific format of the SEID
as part of the SMC-D codebase. Make this part of the SMC-D device API, so
implementers do not need to adhere to a specific SEID format.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Reviewed-and-tested-by: Jan Karcher <jaka@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 drivers/s390/net/ism_drv.c | 7 +++++++
 include/net/smc.h          | 1 +
 net/smc/smc_ism.c          | 2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index eb7e13486087..1c73d32966f1 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -842,6 +842,12 @@ static int smcd_move(struct smcd_dev *smcd, u64 dmb_tok, unsigned int idx,
 	return ism_move(smcd->priv, dmb_tok, idx, sf, offset, data, size);
 }
 
+static int smcd_supports_v2(void)
+{
+	return SYSTEM_EID.serial_number[0] != '0' ||
+		SYSTEM_EID.type[0] != '0';
+}
+
 static u64 smcd_get_local_gid(struct smcd_dev *smcd)
 {
 	return ism_get_local_gid(smcd->priv);
@@ -869,6 +875,7 @@ static const struct smcd_ops ism_ops = {
 	.reset_vlan_required = smcd_reset_vlan_required,
 	.signal_event = smcd_signal_ieq,
 	.move_data = smcd_move,
+	.supports_v2 = smcd_supports_v2,
 	.get_system_eid = ism_get_seid,
 	.get_local_gid = smcd_get_local_gid,
 	.get_chid = smcd_get_chid,
diff --git a/include/net/smc.h b/include/net/smc.h
index 597cb9381182..a002552be29c 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -67,6 +67,7 @@ struct smcd_ops {
 	int (*move_data)(struct smcd_dev *dev, u64 dmb_tok, unsigned int idx,
 			 bool sf, unsigned int offset, void *data,
 			 unsigned int size);
+	int (*supports_v2)(void);
 	u8* (*get_system_eid)(void);
 	u64 (*get_local_gid)(struct smcd_dev *dev);
 	u16 (*get_chid)(struct smcd_dev *dev);
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 3b0b7710c6b0..fbee2493091f 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -429,7 +429,7 @@ static void smcd_register_dev(struct ism_dev *ism)
 		u8 *system_eid = NULL;
 
 		system_eid = smcd->ops->get_system_eid();
-		if (system_eid[24] != '0' || system_eid[28] != '0') {
+		if (smcd->ops->supports_v2()) {
 			smc_ism_v2_capable = true;
 			memcpy(smc_ism_v2_system_eid, system_eid,
 			       SMC_MAX_EID_LEN);
-- 
2.37.2

