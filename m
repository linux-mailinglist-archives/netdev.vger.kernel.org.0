Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F6F27EF86
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbgI3Qoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:44:44 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35224 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725355AbgI3Qoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:44:44 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UGfOHO023431;
        Wed, 30 Sep 2020 09:44:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=YERbTWxOZHRaFXA4+oWLj787IXntDC3gkrJC0FQc+Jw=;
 b=gZ4BDHc3x1xDyAmzv1d2sd7Qa2iXpWwA51Ix83jS7Ho7Pk0gZ14gsKcx8vuJYqwi+65n
 QUk/qjkr65qP12Bro5VHr/z8qqVDEOGyKLeYlZm3qJ2Crd963jGKOBnhueQcQ0aQaprw
 tIKF3u9da4IbsGDhBugz70USxlzursRoOWE51ZaCf69DGUetJQ38ksDnNSo4dnl20SVz
 5iLDBlwyxrxcTc/b5E5erSNGcSALGTuAy2dwmgGu4mZE0pwEWNk5mMDebqf4hf4mTLpn
 LL1FBfxuQSdrIX1PluwwEZlrYPyOzXHp9it57/hzsQ/ZOogAzs/pRUSQF1Kn3rVIt0K7 LQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teemh576-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 30 Sep 2020 09:44:42 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 30 Sep
 2020 09:44:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 30 Sep 2020 09:44:41 -0700
Received: from cavium.com.marvell.com (unknown [10.29.8.35])
        by maili.marvell.com (Postfix) with ESMTP id 6A4B33F703F;
        Wed, 30 Sep 2020 09:44:39 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <davem@davemloft.net>, Geetha sowjanya <gakula@marvell.com>
Subject: [net PATCH v2 2/4] octeontx2-pf: Fix TCP/UDP checksum offload for IPv6 frames
Date:   Wed, 30 Sep 2020 21:38:52 +0530
Message-ID: <1601482132-14972-1-git-send-email-gakula@marvell.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_09:2020-09-30,2020-09-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For TCP/UDP checksum offload feature in Octeontx2
expects L3TYPE to be set irrespective of IP header
checksum is being offloaded or not. Currently for
IPv6 frames L3TYPE is not being set resulting in
packet drop with checksum error. This patch fixes
this issue.

Fixes: 3ca6c4c88 ("octeontx2-pf: Add packet transmission support")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 3a5b34a..e46834e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -524,6 +524,7 @@ static void otx2_sqe_add_hdr(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 			sqe_hdr->ol3type = NIX_SENDL3TYPE_IP4_CKSUM;
 		} else if (skb->protocol == htons(ETH_P_IPV6)) {
 			proto = ipv6_hdr(skb)->nexthdr;
+			sqe_hdr->ol3type = NIX_SENDL3TYPE_IP6;
 		}
 
 		if (proto == IPPROTO_TCP)
-- 
2.7.4

