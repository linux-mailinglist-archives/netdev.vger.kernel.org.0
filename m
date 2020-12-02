Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2D62CC208
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389129AbgLBQTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:19:09 -0500
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:63536 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728595AbgLBQSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:18:47 -0500
Received: from pps.filterd (m0170397.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2G6S9E032316;
        Wed, 2 Dec 2020 11:18:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=smtpout1;
 bh=Bmk7Zjvi9X+Swpw2hnAWUI3bYSwnfmYTchixWgSaeE4=;
 b=ZiiqItWSukaAy8VL+c9RXShTGsvMJC4OotIgGyEZCv3pScs7FrGGj89Ww95ntN6ozbNR
 k0+EcxmBQZ6eZeVxhlmDR9Vcy4pPqixcKoqyY969pqIvk+Ger40XzaaNoQ0PhE0Uj3AZ
 ym4a8T7zMf/rWO/GXJLop+PmfJ1w18z2waVgsfd/d5JLjbtmy/5eSiCZAwQvj6iUx63J
 +zh/o9Y4heRMKMlOqQBQqEWm/VtUDDC7MzyUI8D+lqOVhv/k3RVqfjvFBM7t3nPuXdBs
 naDBBhI/kh+M+Q907OYy/4MGFSt7dTTmyrwL78XBH9yoT1FbmQQhApf55EDbC0Q/wTCo FQ== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0b-00154904.pphosted.com with ESMTP id 353ggyrwc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 11:18:06 -0500
Received: from pps.filterd (m0142699.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2GDDaR114781;
        Wed, 2 Dec 2020 11:18:05 -0500
Received: from ausxippc110.us.dell.com (AUSXIPPC110.us.dell.com [143.166.85.200])
        by mx0a-00154901.pphosted.com with ESMTP id 3565vm86w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 11:18:05 -0500
X-LoopCount0: from 10.173.37.130
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.78,387,1599541200"; 
   d="scan'208";a="1013735361"
From:   Mario Limonciello <mario.limonciello@dell.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     linux-kernel@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        Vitaly Lifshits <vitaly.lifshits@intel.com>
Subject: [PATCH v2 1/5] e1000e: fix S0ix flow to allow S0i3.2 subset entry
Date:   Wed,  2 Dec 2020 10:17:44 -0600
Message-Id: <20201202161748.128938-2-mario.limonciello@dell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201202161748.128938-1-mario.limonciello@dell.com>
References: <20201202161748.128938-1-mario.limonciello@dell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_08:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 impostorscore=0 clxscore=1011 bulkscore=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020096
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

Changed a configuration in the flows to align with
architecture requirements to achieve S0i3.2 substate.

Also fixed a typo in the previous commit 632fbd5eb5b0
("e1000e: fix S0ix flows for cable connected case").

Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index b30f00891c03..128ab6898070 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6475,13 +6475,13 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 
 	/* Ungate PGCB clock */
 	mac_data = er32(FEXTNVM9);
-	mac_data |= BIT(28);
+	mac_data &= ~BIT(28);
 	ew32(FEXTNVM9, mac_data);
 
 	/* Enable K1 off to enable mPHY Power Gating */
 	mac_data = er32(FEXTNVM6);
 	mac_data |= BIT(31);
-	ew32(FEXTNVM12, mac_data);
+	ew32(FEXTNVM6, mac_data);
 
 	/* Enable mPHY power gating for any link and speed */
 	mac_data = er32(FEXTNVM8);
@@ -6525,11 +6525,11 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 	/* Disable K1 off */
 	mac_data = er32(FEXTNVM6);
 	mac_data &= ~BIT(31);
-	ew32(FEXTNVM12, mac_data);
+	ew32(FEXTNVM6, mac_data);
 
 	/* Disable Ungate PGCB clock */
 	mac_data = er32(FEXTNVM9);
-	mac_data &= ~BIT(28);
+	mac_data |= BIT(28);
 	ew32(FEXTNVM9, mac_data);
 
 	/* Cancel not waking from dynamic
-- 
2.25.1

