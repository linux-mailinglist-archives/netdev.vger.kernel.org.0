Return-Path: <netdev+bounces-2142-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBEF47007B9
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 14:25:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00F701C211F9
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D71FD53C;
	Fri, 12 May 2023 12:25:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA4CD536
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 12:25:10 +0000 (UTC)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6991213C19;
	Fri, 12 May 2023 05:24:55 -0700 (PDT)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34CCFgbC004065;
	Fri, 12 May 2023 12:24:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=qcppdkim1;
 bh=7PohaxLZKRfrIAYYudJSUE5FzDfCSmHXw1kgvsZoTXI=;
 b=Tm4pRa6HcWDkgTpCFbVauHJHyOMj0yi1sBbWQYp7ZLpDeWKYlho8eGxIJr+p08ywuqkv
 UTlLyk2op3SsagcpgHLz3+hg4r+gyzet4qNQ9stS4MIL5wPUu1Lp9StSoSm2vm56UooR
 ZLJeUfXrZ9I3fb4OVaa/O6B+M/NNoFRKj0KhabmCFld1D1zAnjd7/wEji9L65vOfcNtm
 I0LsCDmeEC/ybBqj/bYNHdyZm77pWP6p7TsfrtuthGZsKqmnlwj83UXa6ulCeDl+Ycsy
 mOIaHyzYxIJgVlZzxhbMWJSc1MT69hOA9rWLOaC1/dX2lGz410zxv8OIWtBYugpSrFhs Lg== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qhcj1s58e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 May 2023 12:24:31 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34CCOUAw015736
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 May 2023 12:24:30 GMT
Received: from hu-tdas-hyd.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Fri, 12 May 2023 05:24:24 -0700
From: Taniya Das <quic_tdas@quicinc.com>
To: Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd
	<sboyd@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran
	<richardcochran@gmail.com>,
        Conor Dooley <conor+dt@kernel.org>, Andy Gross
	<agross@kernel.org>
CC: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio
	<konrad.dybcio@linaro.org>,
        Imran Shaik <quic_imrashai@quicinc.com>,
        <linux-arm-msm@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <jkona@quicinc.com>,
        <quic_rohiagar@quicinc.com>, Taniya Das <quic_tdas@quicinc.com>
Subject: [PATCH V2 1/5] clk: qcom: branch: Extend the invert logic for branch2 clocks
Date: Fri, 12 May 2023 17:53:43 +0530
Message-ID: <20230512122347.1219-2-quic_tdas@quicinc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230512122347.1219-1-quic_tdas@quicinc.com>
References: <20230512122347.1219-1-quic_tdas@quicinc.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: GBFjZVh5AkMOiFkckidn1G_AqXQKPPX0
X-Proofpoint-ORIG-GUID: GBFjZVh5AkMOiFkckidn1G_AqXQKPPX0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305120104
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Imran Shaik <quic_imrashai@quicinc.com>

Add support to handle the invert logic for branch2 clocks.
Invert branch halt would indicate the clock ON when CLK_OFF
bit is '1' and OFF when CLK_OFF bit is '0'.

Signed-off-by: Imran Shaik <quic_imrashai@quicinc.com>
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
---
Changes since v1:
 - Removed the multiple returns from inside clk_branch2_check_halt.

 drivers/clk/qcom/clk-branch.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/clk-branch.c b/drivers/clk/qcom/clk-branch.c
index ca896ebf7e1b..fc4735f74f0f 100644
--- a/drivers/clk/qcom/clk-branch.c
+++ b/drivers/clk/qcom/clk-branch.c
@@ -43,6 +43,7 @@ static bool clk_branch2_check_halt(const struct clk_branch *br, bool enabling)
 {
 	u32 val;
 	u32 mask;
+	bool invert = (br->halt_check == BRANCH_HALT_ENABLE);
 
 	mask = CBCR_NOC_FSM_STATUS;
 	mask |= CBCR_CLK_OFF;
@@ -51,11 +52,10 @@ static bool clk_branch2_check_halt(const struct clk_branch *br, bool enabling)
 
 	if (enabling) {
 		val &= mask;
-		return (val & CBCR_CLK_OFF) == 0 ||
+		return (val & CBCR_CLK_OFF) == (invert ? CBCR_CLK_OFF : 0) ||
 			FIELD_GET(CBCR_NOC_FSM_STATUS, val) == FSM_STATUS_ON;
-	} else {
-		return val & CBCR_CLK_OFF;
 	}
+	return (val & CBCR_CLK_OFF) == (invert ? 0 : CBCR_CLK_OFF);
 }
 
 static int clk_branch_wait(const struct clk_branch *br, bool enabling,
-- 
2.17.1


