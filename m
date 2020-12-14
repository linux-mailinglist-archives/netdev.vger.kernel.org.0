Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71532DA0A4
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 20:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441111AbgLNTf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 14:35:29 -0500
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:5026 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440695AbgLNTew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 14:34:52 -0500
Received: from pps.filterd (m0170396.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BEJWJwj006021;
        Mon, 14 Dec 2020 14:34:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=smtpout1;
 bh=sNA15cRlh9UBXWC1DUTFYUWH0qFfKqULfgKKopxOFyQ=;
 b=rmyGih9tlsJuFJuBhJptupRIF0Qtl+ysl+womFYtR17G+y2g9X4jxl9DMEM/9DaoNbYs
 9CDHnWsG3ve27FcD5tL95je/PoT6N7WXla3mom131h6ROJxkyGzLam+1o+XFeAbTKxwU
 dd6dJusrM8u53QGN2Mzi4oq4ymzW5LbSQc0mFhzse2UgA41/85z0lgIUUPz5n2UVx9WX
 ciOtqCJc4MV+SdF07TbC7yK3tvkp3dGLfIIxxesKeDF6WshlY1AJcWCsYsFEB1RBQhJ+
 5h444T9bYBTyV1OnIo7+rGQ/BTC5ld6KwZBEmShdJkRO2jZQWRPr76rcy2BvWICx4zM1 ag== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0b-00154904.pphosted.com with ESMTP id 35ctk4ejxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 14:34:09 -0500
Received: from pps.filterd (m0134746.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BEJY6Q2182661;
        Mon, 14 Dec 2020 14:34:09 -0500
Received: from ausxippc110.us.dell.com (AUSXIPPC110.us.dell.com [143.166.85.200])
        by mx0a-00154901.pphosted.com with ESMTP id 35e5emsm0j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 14:34:07 -0500
X-LoopCount0: from 10.173.37.130
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.78,420,1599541200"; 
   d="scan'208";a="1020795052"
From:   Mario Limonciello <mario.limonciello@dell.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        anthony.wong@canonical.com, Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <mario.limonciello@dell.com>
Subject: [PATCH v5 1/4] e1000e: Only run S0ix flows if shutdown succeeded
Date:   Mon, 14 Dec 2020 13:29:32 -0600
Message-Id: <20201214192935.895174-2-mario.limonciello@dell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201214192935.895174-1-mario.limonciello@dell.com>
References: <20201214192935.895174-1-mario.limonciello@dell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_10:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140129
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the shutdown failed, the part will be thawed and running
S0ix flows will put it into an undefined state.

Reported-by: Alexander Duyck <alexander.duyck@gmail.com>
Reviewed-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 128ab6898070..6588f5d4a2be 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6970,13 +6970,14 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
 	e1000e_pm_freeze(dev);
 
 	rc = __e1000_shutdown(pdev, false);
-	if (rc)
+	if (rc) {
 		e1000e_pm_thaw(dev);
-
-	/* Introduce S0ix implementation */
-	if (hw->mac.type >= e1000_pch_cnp &&
-	    !e1000e_check_me(hw->adapter->pdev->device))
-		e1000e_s0ix_entry_flow(adapter);
+	} else {
+		/* Introduce S0ix implementation */
+		if (hw->mac.type >= e1000_pch_cnp &&
+		    !e1000e_check_me(hw->adapter->pdev->device))
+			e1000e_s0ix_entry_flow(adapter);
+	}
 
 	return rc;
 }
-- 
2.25.1

