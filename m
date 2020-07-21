Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63CF228270
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 16:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbgGUOmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 10:42:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16806 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727023AbgGUOmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 10:42:04 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06LEe7Cw010662;
        Tue, 21 Jul 2020 07:42:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=y38RFFmhWQp0xB1mHG8UXNBIa7pUa208twph4jHGR4Q=;
 b=IkzuQZN0G8+ZPhHcHyTbGtfbXWPmCYRbo2MruDvslGjV6NZxvhNoqmjbHI0Yf88GlPiZ
 WN5RZ2WHTXvMO4Z20tcNLt9YwuA0luQ1sFYvvPgvSWdKEc2LEJ4bU18Shchgv8+34PQp
 e5Cb5WpfCkYrJIZZ3YV4FT2G86WxFPlbYCKrcbbIBGHwAaSNwofdz2e1VuOPQtuDjPoN
 d4/BXOXSi2PPlHaOl/AS3xqNYvIVClqS365vNGpjkUopaqIN+858qLU1HHybwwxbk9lu
 zbxJzIwolOJjKP1wKsUlsYiYmBlJKFUCUsIYJ/1I8PuOb34soPIrZ0Lu8iPGyivWHc9Y IQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkk78h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 07:42:01 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Jul
 2020 07:41:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Jul 2020 07:41:59 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 070283F703F;
        Tue, 21 Jul 2020 07:41:55 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Tomer Tayar" <tomer.tayar@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 1/2] qed: suppress "don't support RoCE & iWARP" flooding on HW init
Date:   Tue, 21 Jul 2020 17:41:42 +0300
Message-ID: <20200721144143.379-2-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721144143.379-1-alobakin@marvell.com>
References: <20200721144143.379-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_09:2020-07-21,2020-07-21 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the verbosity of the "don't support RoCE & iWARP simultaneously"
warning to debug level to stop flooding on driver/hardware initialization:

[    4.783230] qede 01:00.00: Storm FW 8.37.7.0, Management FW 8.52.9.0
[MBI 15.10.6] [eth0]
[    4.810020] [qed_rdma_set_pf_params:2076()]Current day drivers don't
support RoCE & iWARP simultaneously on the same PF. Default to RoCE-only
[    4.861186] qede 01:00.01: Storm FW 8.37.7.0, Management FW 8.52.9.0
[MBI 15.10.6] [eth1]
[    4.893311] [qed_rdma_set_pf_params:2076()]Current day drivers don't
support RoCE & iWARP simultaneously on the same PF. Default to RoCE-only
[    5.181713] qede a1:00.00: Storm FW 8.37.7.0, Management FW 8.52.9.0
[MBI 15.10.6] [eth2]
[    5.224740] [qed_rdma_set_pf_params:2076()]Current day drivers don't
support RoCE & iWARP simultaneously on the same PF. Default to RoCE-only
[    5.276449] qede a1:00.01: Storm FW 8.37.7.0, Management FW 8.52.9.0
[MBI 15.10.6] [eth3]
[    5.318671] [qed_rdma_set_pf_params:2076()]Current day drivers don't
support RoCE & iWARP simultaneously on the same PF. Default to RoCE-only
[    5.369548] qede a1:00.02: Storm FW 8.37.7.0, Management FW 8.52.9.0
[MBI 15.10.6] [eth4]
[    5.411645] [qed_rdma_set_pf_params:2076()]Current day drivers don't
support RoCE & iWARP simultaneously on the same PF. Default to RoCE-only

Fixes: e0a8f9de16fc ("qed: Add iWARP enablement support")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index 08ba9d54ab63..d13ec88313c3 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -2008,8 +2008,8 @@ static void qed_rdma_set_pf_params(struct qed_hwfn *p_hwfn,
 	enum protocol_type proto;
 
 	if (p_hwfn->mcp_info->func_info.protocol == QED_PCI_ETH_RDMA) {
-		DP_NOTICE(p_hwfn,
-			  "Current day drivers don't support RoCE & iWARP simultaneously on the same PF. Default to RoCE-only\n");
+		DP_VERBOSE(p_hwfn, QED_MSG_SP,
+			   "Current day drivers don't support RoCE & iWARP simultaneously on the same PF. Default to RoCE-only\n");
 		p_hwfn->hw_info.personality = QED_PCI_ETH_ROCE;
 	}
 
-- 
2.25.1

