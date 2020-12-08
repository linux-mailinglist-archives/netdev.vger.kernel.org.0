Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FF52D37B9
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732006AbgLIA0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:26:54 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:28334 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731067AbgLIA0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:26:53 -0500
Received: from pps.filterd (m0170390.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B8J1vks028414;
        Tue, 8 Dec 2020 14:01:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=smtpout1; bh=jnL+NMBCfbHJnfixupP+eK8YJew68ryjGuo6zSr4mNg=;
 b=FuQ5Ph8B94hWYk4zFfPzoRi0nTWaesbO2sGicGZ2bqPS+7nVvQkxxD1E4SJJvIMLuyii
 3R9ncFN849D/ieDpcHttIFTfXQ0pIff2uKPymNWVqdiq9+SIaxppXHEkBu15qSwGm7Oy
 Lf+uGtjqRuRGC8fnojx6Ajw/IJ6kR4iyzD93tEFzojZUj9kl2mb250/DvHGpI8vaZjsU
 l+rTbXAJJiYPw5BaMYSPjnvAV9f13/yEQ/RdEV05GCGsP1yE7SGb4MIvLnteLAyAfyUW
 dbQ2tsSgNOmm8spE6+ysAtPQYvLT86Izx42lA90lbV0cPtGW6SpS2FR4LjwqUnh3ycWL qQ== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0a-00154904.pphosted.com with ESMTP id 3587vyungx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 14:01:57 -0500
Received: from pps.filterd (m0090351.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B8IvRVA087147;
        Tue, 8 Dec 2020 14:01:56 -0500
Received: from ausc60ps301.us.dell.com (ausc60ps301.us.dell.com [143.166.148.206])
        by mx0b-00154901.pphosted.com with ESMTP id 35abtj5m6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 14:01:56 -0500
X-LoopCount0: from 10.173.37.130
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.78,403,1599541200"; 
   d="scan'208";a="1511744183"
From:   Mario Limonciello <mario.limonciello@dell.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        anthony.wong@canonical.com,
        Vitaly Lifshits <vitaly.lifshits@intel.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Mario Limonciello <mario.limonciello@dell.com>
Subject: [PATCH RESEND] e1000e: fix S0ix flow to allow S0i3.2 subset entry
Date:   Tue,  8 Dec 2020 12:56:32 -0600
Message-Id: <20201208185632.151052-1-mario.limonciello@dell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_14:2020-12-08,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080115
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080116
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

Changed a configuration in the flows to align with
architecture requirements to achieve S0i3.2 substate.

This helps both i219V and i219LM configurations.

Also fixed a typo in the previous commit 632fbd5eb5b0
("e1000e: fix S0ix flows for cable connected case").

Fixes: 632fbd5eb5b0 ("e1000e: fix S0ix flows for cable connected case").
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
---
This patch was originally part of 
https://marc.info/?l=linux-netdev&m=160677194809564&w=2
which requested fixes. It was then resubmitted as part of:
https://patchwork.ozlabs.org/project/netdev/list/?series=218712
However there is discussion on the other patches of the series.
As it fixes existing hardware that is not blocked by ME check (i219V)
resubmit it separately to at least fix that hardware.

 drivers/net/ethernet/intel/e1000e/netdev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 3ecd05b28fe6..6588f5d4a2be 100644
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

