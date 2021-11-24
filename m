Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A8045B765
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 10:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbhKXJ3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 04:29:02 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61474 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229479AbhKXJ27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 04:28:59 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AO2UeqE007527;
        Wed, 24 Nov 2021 01:25:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=2tmP0RrEvUdQZWZRp6AXnzCfUAsDdHI1B2rOB2FR5go=;
 b=O2bX73MhRia0be1rO9mkgtfXsBXEP6srcMP3/PXz9hBCSuKRAK0VsdQbJlJbCocrJB2w
 +fLIps+19UBt4gGiu/0OMp5pMb2G0+OVvuznBizYLUs0rGghz9IJO+JwJ7nsz1nMnVhZ
 l9SAHVFYthaOahu5SvgvOTzcE8TwqjffkGzql4DxpGNDawur3tGGBymLpbsGgMnwXfWU
 ywlmjX2DlBePFe06yXbuGfd8v0s07dscW9XwZ/9fctKFvl5xvvR+71bWACQiFBmpVRnT
 pU1b+k2GkYzX/1lJDM0u66fQLZVtKvAvu+yQF1i41M4RnQ4fQaBux06/q6GeJxebH7QF Rw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ch9tt22gy-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 24 Nov 2021 01:25:47 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 24 Nov
 2021 01:25:37 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 24 Nov 2021 01:25:37 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 89BD23F71A1;
        Wed, 24 Nov 2021 01:24:32 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1AO9OMTI028880;
        Wed, 24 Nov 2021 01:24:22 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1AO9O7QD028870;
        Wed, 24 Nov 2021 01:24:07 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <palok@marvell.com>, <pkushwaha@marvell.com>
Subject: [PATCH net] qede: validate non LSO skb length
Date:   Wed, 24 Nov 2021 01:24:05 -0800
Message-ID: <20211124092405.28834-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Q9__VBFfwVBxnAeZ79PfeYR-7IxyvtsM
X-Proofpoint-GUID: Q9__VBFfwVBxnAeZ79PfeYR-7IxyvtsM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-24_03,2021-11-23_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although it is unlikely that stack could transmit a non LSO
skb with length > MTU, however in some cases or environment such
occurrences actually resulted into firmware asserts due to packet
length being greater than the max supported by the device (~9700B).

This patch adds the safeguard for such odd cases to avoid firmware
asserts.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index e113fbd56e86..5ea9cb4311a1 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1644,6 +1644,13 @@ netdev_tx_t qede_start_xmit(struct sk_buff *skb, struct net_device *ndev)
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
2.27.0

