Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42306E6D72
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 22:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbjDRUZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 16:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbjDRUZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 16:25:47 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27C69748
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 13:25:41 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33IH4L2M017753;
        Tue, 18 Apr 2023 13:25:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=9Dx/MFnNFXnY8kaTQiekaQ2emotuUK08zer1o6bRRJY=;
 b=QXvToqX/kAtQvgZOAwjfSLEToZFNx+/yrtiK46gIMANJIZVuAuaj6gd/DIbYb9JCUb+7
 0gqN+KqVLXwI1GTo/nqbPrwYOELqhipPA1Mn/AifFFcEvBhbusIOy9LrLWckv3Y8PMzP
 36CRLnvTlsRA7bQhkE9Lh3m/X1Al1qI3v/pNZT9832XOve1NOFVhoEqEm/zhoioBnLyJ
 SknkMrag40D3sqwbgx+OjkHK8OjuQosHADoVRB21uMVCxuD5dqrpYvIOaGQI+uehX5AY
 DrS3jOcx3bzcyG7LcN5KUmTFgfOZpMgZeZTK/n1lDBx1RjIGDg8kW/advuDNTAkV+EGB rA== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3q1k6k5ufd-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Apr 2023 13:25:35 -0700
Received: from devvm1736.cln0.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server id
 15.1.2507.23; Tue, 18 Apr 2023 13:25:27 -0700
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
CC:     Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Vadim Fedorenko <vadfed@meta.com>, <netdev@vger.kernel.org>
Subject: [PATCH net] bnxt_en: fix free-runnig PHC mode 
Date:   Tue, 18 Apr 2023 13:25:11 -0700
Message-ID: <20230418202511.1544735-1-vadfed@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::d]
X-Proofpoint-ORIG-GUID: shIp672R3rLCcQE7k93_c9rK8KLT6hYE
X-Proofpoint-GUID: shIp672R3rLCcQE7k93_c9rK8KLT6hYE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_15,2023-04-18_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch in fixes changed the way real-time mode is chosen for PHC on
the NIC. Apparently there is one more use case of the check outside of
ptp part of the driver which was not converted to the new macro and is
making a lot of noise in free-running mode.

Fixes: 131db4991622 ("bnxt_en: reset PHC frequency in free-running mode")
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ef97a4190b39..651b79ce5d80 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2388,7 +2388,7 @@ static int bnxt_async_event_process(struct bnxt *bp,
 	case ASYNC_EVENT_CMPL_EVENT_ID_PHC_UPDATE: {
 		switch (BNXT_EVENT_PHC_EVENT_TYPE(data1)) {
 		case ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_FLAGS_PHC_RTC_UPDATE:
-			if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC) {
+			if (BNXT_PTP_USE_RTC(bp)) {
 				struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
 				u64 ns;
 
-- 
2.34.1

