Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70193443A4
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392441AbfFMQbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:31:03 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36948 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730900AbfFMIbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 04:31:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5D8TLew013674;
        Thu, 13 Jun 2019 01:31:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=19viDgAmYrC9/3rlYnYLm+xtV0v+7DToEKeLM/mGmbc=;
 b=STMDFEp1MIiiPn/cc7sGmWwa1iEW6Zw9DUi03batHq+dW1gEjeHbtdqT9eAR/a5/wz0x
 KocHGYbf3jTwoa1rGSOW7liCSVoCIGvDyzcsk5IAm/w9zuNtET/mq0vHJN9rsvjv+zd1
 ZTgJTGFBebcopNPqPcvuwMgY9VmDGKy7sHl597K6vEEfPiSw6yufa/eCYSMw3Cle2ZuH
 0doKPNSMIMYKJTnK//bAEjVZD+XtZBRBxneTrLs+gVYQ63owQfnW44RVoD4A0fO5VYsb
 tsESV0+wQC61VQyUBGGM+nx8bN2EaCzpTDUVw0VqBt/BA181Nv5JKtXXapmCkBIwoPYW KQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2t3j8205qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 01:31:07 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 13 Jun
 2019 01:31:06 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 13 Jun 2019 01:31:06 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 1F8D73F7043;
        Thu, 13 Jun 2019 01:31:04 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH net-next 2/4] qed: iWARP - fix uninitialized callback
Date:   Thu, 13 Jun 2019 11:29:41 +0300
Message-ID: <20190613082943.5859-3-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190613082943.5859-1-michal.kalderon@marvell.com>
References: <20190613082943.5859-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix uninitialized variable warning by static checker.

Fixes: ae3488ff37dc ("qed: Add ll2 connection for processing unaligned MPA packets")
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index 4c69adb0b535..099177c6aca2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -2640,6 +2640,7 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 	cbs.rx_release_cb = qed_iwarp_ll2_rel_rx_pkt;
 	cbs.tx_comp_cb = qed_iwarp_ll2_comp_tx_pkt;
 	cbs.tx_release_cb = qed_iwarp_ll2_rel_tx_pkt;
+	cbs.slowpath_cb = NULL;
 	cbs.cookie = p_hwfn;
 
 	memset(&data, 0, sizeof(data));
-- 
2.14.5

