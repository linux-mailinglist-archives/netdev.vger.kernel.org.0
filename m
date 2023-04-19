Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8788B6E7ACA
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 15:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbjDSNay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 09:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbjDSNat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:30:49 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB34446B8;
        Wed, 19 Apr 2023 06:30:45 -0700 (PDT)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JCxTIX009628;
        Wed, 19 Apr 2023 13:30:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=qcppdkim1;
 bh=RpsRvXvb/m23/CEmpkdaobByEZtgO+aU85Pq5Ig2c08=;
 b=P+kiUgRpKeSNvaRNK8V/HKmX/aM7dw8vRWulY0CgC7Y6worwQBa5B60ZgRIdBqeGPZkc
 sGVDHHsVJ/JOIyqkYLRYZfoWvvdsbuls2N5lG6cbrsP7x/57AdKWFp+tYBuF4N84PSpa
 oFmpxGmBulI4yPma0UcqRRknjYYQU9tEQJZ0tVjVQIAl3+f6xZD1xyHKAraA3OYWcTzd
 IfmEpVp29MV8wSw0SjH9wsCXJkGKL1nblTtG6RKRkK38jFNZZ40BQ2rUNxJ7Za5iuHJJ
 28QtkMrQlDooCOt2n9NABRIlRDTYjRUWUyBHJ3VyuACmuuQYyGDRdGYO+lCD3697nyuN KQ== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3q1wxk2t9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 13:30:42 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 33JDUepl015251
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 13:30:40 GMT
Received: from hu-tdas-hyd.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Wed, 19 Apr 2023 06:30:35 -0700
From:   Taniya Das <quic_tdas@quicinc.com>
To:     Stephen Boyd <sboyd@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        Andy Gross <agross@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Michael Turquette <mturquette@baylibre.com>
CC:     <quic_skakitap@quicinc.com>,
        Imran Shaik <quic_imrashai@quicinc.com>,
        <linux-arm-msm@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Taniya Das <quic_tdas@quicinc.com>,
        <quic_rohiagar@quicinc.com>, <netdev@vger.kernel.org>
Subject: [PATCH 1/4] clk: qcom: branch: Extend the invert logic for branch2 clocks
Date:   Wed, 19 Apr 2023 19:00:10 +0530
Message-ID: <20230419133013.2563-2-quic_tdas@quicinc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230419133013.2563-1-quic_tdas@quicinc.com>
References: <20230419133013.2563-1-quic_tdas@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: IlTUYRaTcud-ZlYEwNMDej2meQUqyfpU
X-Proofpoint-ORIG-GUID: IlTUYRaTcud-ZlYEwNMDej2meQUqyfpU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_08,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304190121
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Imran Shaik <quic_imrashai@quicinc.com>

Add support to handle the invert logic for branch2 clocks.
Invert branch halt would indicate the clock ON when CLK_OFF
bit is '1' and OFF when CLK_OFF bit is '0'.

Signed-off-by: Imran Shaik <quic_imrashai@quicinc.com>
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
---
 drivers/clk/qcom/clk-branch.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/qcom/clk-branch.c b/drivers/clk/qcom/clk-branch.c
index f869fc6aaed6..4b24d45be771 100644
--- a/drivers/clk/qcom/clk-branch.c
+++ b/drivers/clk/qcom/clk-branch.c
@@ -48,6 +48,7 @@ static bool clk_branch2_check_halt(const struct clk_branch *br, bool enabling)
 {
 	u32 val;
 	u32 mask;
+	bool invert = (br->halt_check == BRANCH_HALT_ENABLE);
 
 	mask = BRANCH_NOC_FSM_STATUS_MASK << BRANCH_NOC_FSM_STATUS_SHIFT;
 	mask |= BRANCH_CLK_OFF;
@@ -56,9 +57,16 @@ static bool clk_branch2_check_halt(const struct clk_branch *br, bool enabling)
 
 	if (enabling) {
 		val &= mask;
+
+		if (invert)
+			return (val & BRANCH_CLK_OFF) == BRANCH_CLK_OFF;
+
 		return (val & BRANCH_CLK_OFF) == 0 ||
 			val == BRANCH_NOC_FSM_STATUS_ON;
 	} else {
+		if (invert)
+			return (val & BRANCH_CLK_OFF) == 0;
+
 		return val & BRANCH_CLK_OFF;
 	}
 }
-- 
2.17.1

