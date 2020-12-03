Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A05B2CD0D3
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 09:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbgLCIIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 03:08:47 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:9870 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728929AbgLCIIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 03:08:47 -0500
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B385mNb007754;
        Thu, 3 Dec 2020 03:07:42 -0500
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 355vj5n03q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 03:07:41 -0500
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 0B387dSh000771
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 3 Dec 2020 03:07:39 -0500
Received: from ASHBCASHYB5.ad.analog.com (10.64.17.133) by
 ASHBMBX9.ad.analog.com (10.64.17.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 3 Dec 2020 03:07:38 -0500
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by
 ASHBCASHYB5.ad.analog.com (10.64.17.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 3 Dec 2020 03:07:38 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.1.1779.2 via Frontend
 Transport; Thu, 3 Dec 2020 03:07:37 -0500
Received: from saturn.ad.analog.com ([10.48.65.108])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 0B387W5x027599;
        Thu, 3 Dec 2020 03:07:33 -0500
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <catherine.redmond@analog.com>, <brian.murray@analog.com>,
        <danail.baylov@analog.com>, <maurice.obrien@analog.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH] net: phy: adin: add signal mean square error registers to phy-stats
Date:   Thu, 3 Dec 2020 10:07:19 +0200
Message-ID: <20201203080719.30040-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_03:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030049
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the link is up on the ADIN1300/ADIN1200, the signal quality on each
pair is indicated in the mean square error register for each pair (MSE_A,
MSE_B, MSE_C, and MSE_D registers, Address 0x8402 to Address 0x8405,
Bits[7:0]).

These values can be useful for some industrial applications.

This change implements support for these registers using the PHY
statistics mechanism.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 55a0b91816e2..e4441bba98c3 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -184,6 +184,7 @@ struct adin_hw_stat {
 	const char *string;
 	u16 reg1;
 	u16 reg2;
+	bool do_not_accumulate;
 };
 
 static const struct adin_hw_stat adin_hw_stats[] = {
@@ -197,6 +198,10 @@ static const struct adin_hw_stat adin_hw_stats[] = {
 	{ "odd_preamble_packet_count",		0x9412 },
 	{ "dribble_bits_frames_count",		0x9413 },
 	{ "false_carrier_events_count",		0x9414 },
+	{ "signal_mean_square_error_a",		0x8402,	0,	true },
+	{ "signal_mean_square_error_b",		0x8403,	0,	true },
+	{ "signal_mean_square_error_c",		0x8404,	0,	true },
+	{ "signal_mean_square_error_d",		0x8405,	0,	true },
 };
 
 /**
@@ -757,7 +762,10 @@ static u64 adin_get_stat(struct phy_device *phydev, int i)
 		val = (ret & 0xffff);
 	}
 
-	priv->stats[i] += val;
+	if (stat->do_not_accumulate)
+		priv->stats[i] = val;
+	else
+		priv->stats[i] += val;
 
 	return priv->stats[i];
 }
-- 
2.27.0

