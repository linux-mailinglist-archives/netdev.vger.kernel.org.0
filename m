Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0E3467CC2
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 18:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353352AbhLCRsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 12:48:20 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13100 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229789AbhLCRsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 12:48:19 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1B38QEL1014985;
        Fri, 3 Dec 2021 09:44:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=1bTEKIufp1t3DOJeTbdyZ16H21n4dfI3fUoV7QVFp8g=;
 b=SkwPYCc/qOuhy14Wl87LSYagQlNTnoOqfwAYkNsLs4E5RBJrRY3uxPd4HNJtYfU4UhT+
 F5nd2DTI/jCxrv9Yyxpm8ryyVxY2tUFrRS6RfrABlPtYyo4AkZjFd/YH6efQjwog/Xfw
 szUfDfLAGKI8Ebgdg6RdXtObHzXGUgkqVbCVJQn61RwjNMfmUKHQZAVai9xWOfpsdbnR
 6acvRPeaFlOgrLbT2SPU//sLEOJM9kKKL4z8eKtVmSuuRV9CVlGdds0qeQ+hY83HLCGu
 RboZppHJkM7ns7CqKCf2hNw5F4k5K+3/oVYFUzk64UOVRGTX441B0QuHFZEXkRTGMEVD tw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cqfqqa03g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 09:44:46 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Dec
 2021 09:44:45 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 3 Dec 2021 09:44:45 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 58C713F7068;
        Fri,  3 Dec 2021 09:44:45 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1B3HiU5o013128;
        Fri, 3 Dec 2021 09:44:30 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1B3HiEvk013126;
        Fri, 3 Dec 2021 09:44:14 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <palok@marvell.com>, <pkushwaha@marvell.com>
Subject: [PATCH v2 net] qede: validate non LSO skb length
Date:   Fri, 3 Dec 2021 09:44:13 -0800
Message-ID: <20211203174413.13090-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: MDJ0PbU7TMHNiGygQ8I_fKMKbd4rAAwp
X-Proofpoint-ORIG-GUID: MDJ0PbU7TMHNiGygQ8I_fKMKbd4rAAwp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_07,2021-12-02_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although it is unlikely that stack could transmit a non LSO
skb with length > MTU, however in some cases or environment such
occurrences actually resulted into firmware asserts due to packet
length being greater than the max supported by the device (~9700B).

This patch adds the safeguard for such odd cases to avoid firmware
asserts.

v1->v2:
--------

* Added "Fixes" tag with one of the initial driver commit
  which enabled the TX traffic actually (as this was probably
  day1 issue which was discovered recently by some customer
  environment)

Fixes: a2ec6172d29c ("qede: Add support for link")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 065e900..999abcf 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1643,6 +1643,13 @@ netdev_tx_t qede_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			data_split = true;
 		}
 	} else {
+		if (unlikely(skb->len > ETH_TX_MAX_NON_LSO_PKT_LEN)) {
+			DP_ERR(edev, "Unexpected non LSO skb length = 0x%x\n", skb->len);
+			qede_free_failed_tx_pkt(txq, first_bd, 0, false);
+			qede_update_tx_producer(txq);
+			return NETDEV_TX_OK;
+		}
+
 		val |= ((skb->len & ETH_TX_DATA_1ST_BD_PKT_LEN_MASK) <<
 			 ETH_TX_DATA_1ST_BD_PKT_LEN_SHIFT);
 	}
--
1.8.3.1

