Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A18520E93
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 09:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236585AbiEJHho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 03:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238730AbiEJHJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 03:09:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC4728FEAA;
        Tue, 10 May 2022 00:05:25 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24A6hQn1024939;
        Tue, 10 May 2022 07:05:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dv74yVCTxJWMrGmc+xkj7P21G7PTlAbLvXX/vB7xbco=;
 b=aKzn50qNAi93z9l5BAcZ9RyGBKRmYChBibarp6pSNjr4wk8uPl3NN2qs68/jRLZG071Z
 h6xHNVKMKoT8oCb+T+o0a6EUt4sEWUYydBGovhr3OHzk3r4uj536TM4LjP35Q44YEdN1
 BYRB1EozozNY6oRIOCrnxZCCpzlTOg9W9wfvmnsu5Db+V3ToVsOo7t//2uAS3omclGyf
 M57DKezXyQairnH0UO1jqKRIE4+c7D4nq/bE9k1jMDtN8Kw+tY4MdTn7jR/eUy1X4CHJ
 f1YmFGrsyBNVJvIJv6bmnP6q/BC3V1clBR/iR3geiPlNHGLKLDrWob+DYsaFtShpGjHW rA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fyk18rdun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 07:05:21 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24A72UW4029090;
        Tue, 10 May 2022 07:05:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3fwgd8uka5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 07:05:18 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24A75FnV37552606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 07:05:15 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECFC3AE051;
        Tue, 10 May 2022 07:05:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB071AE045;
        Tue, 10 May 2022 07:05:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 10 May 2022 07:05:14 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id 9C220E78E9; Tue, 10 May 2022 09:05:14 +0200 (CEST)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net 3/3] s390/lcs: fix variable dereferenced before check
Date:   Tue, 10 May 2022 09:05:08 +0200
Message-Id: <20220510070508.334726-4-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220510070508.334726-1-wintera@linux.ibm.com>
References: <20220510070508.334726-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QjBhA2ZkHKUSZyduHqVxFCGjKjmDnGDa
X-Proofpoint-ORIG-GUID: QjBhA2ZkHKUSZyduHqVxFCGjKjmDnGDa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_06,2022-05-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 spamscore=0 clxscore=1015 mlxlogscore=720 priorityscore=1501
 impostorscore=0 bulkscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205100028
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

smatch complains about
drivers/s390/net/lcs.c:1741 lcs_get_control() warn: variable dereferenced before check 'card->dev' (see line 1739)

Fixes: 27eb5ac8f015 ("[PATCH] s390: lcs driver bug fixes and improvements [1/2]")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/lcs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index bab9b34926c6..84c8981317b4 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -1736,10 +1736,11 @@ lcs_get_control(struct lcs_card *card, struct lcs_cmd *cmd)
 			lcs_schedule_recovery(card);
 			break;
 		case LCS_CMD_STOPLAN:
-			pr_warn("Stoplan for %s initiated by LGW\n",
-				card->dev->name);
-			if (card->dev)
+			if (card->dev) {
+				pr_warn("Stoplan for %s initiated by LGW\n",
+					card->dev->name);
 				netif_carrier_off(card->dev);
+			}
 			break;
 		default:
 			LCS_DBF_TEXT(5, trace, "noLGWcmd");
-- 
2.32.0

