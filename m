Return-Path: <netdev+bounces-3512-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB8B3707A51
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 08:41:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57591281800
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 06:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E6E617F1;
	Thu, 18 May 2023 06:41:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8271D7E
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:41:09 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C408A2D73;
	Wed, 17 May 2023 23:41:03 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34I3FM7R009185;
	Wed, 17 May 2023 23:40:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=Rlf1QmTU//frsFPjgKpfYB2mYuh3MZ8T+K51frDtL4s=;
 b=H9eiDey2GbsfD1SDJS4QuOZObyoj84qWm2jIvLHPQ68Fbo4qjz9PbFHLt19AaDRcnmAL
 tfJpfG10TzymbL4aTMAqh52tQcLWQUDhMsKcxyXFOFzFSwFrKvyknsKgnEU65EcDBOhC
 mG7sIholx47MoYJxEPsFM284kZ7F3qr4ERp0oA39GSF96rHMC1a92aOOQThE85ikqdly
 7Lr3PncOpzQN5peBV0WX+PUhqxQ97XhMUbGyTefD2kd8JGJ68/C5phJw0QCpG+ECTniI
 aJliHrCuFmB77OwQlzxnu4nWxsuJ6G6nLNRBsPVQBF9DPDHgZAI4/PCf6LN/5s9dn+Gi oQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3qmyexb38x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Wed, 17 May 2023 23:40:50 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 17 May
 2023 23:40:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 17 May 2023 23:40:48 -0700
Received: from localhost.localdomain (unknown [10.28.36.165])
	by maili.marvell.com (Postfix) with ESMTP id 33EDC3F704A;
	Wed, 17 May 2023 23:40:44 -0700 (PDT)
From: Ratheesh Kannoth <rkannoth@marvell.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <sgoutham@marvell.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sbhatta@marvell.com>,
        <gakula@marvell.com>, <schalla@marvell.com>, <hkelam@marvell.com>,
        "Ratheesh
 Kannoth" <rkannoth@marvell.com>
Subject: [PATCH net] octeontx2-pf: Fix TSOv6 offload
Date: Thu, 18 May 2023 12:10:42 +0530
Message-ID: <20230518064042.3495575-1-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 5xqHrYI0h_tksI_WRnyIg7ohg---BLET
X-Proofpoint-ORIG-GUID: 5xqHrYI0h_tksI_WRnyIg7ohg---BLET
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_04,2023-05-17_02,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Sunil Goutham <sgoutham@marvell.com>

HW adds segment size to the payload length
in the IPv6 header. Fix payload length to
just TCP header length instead of 'TCP header
size + IPv6 header size'.

Fixes: 86d7476078b8 ("octeontx2-pf: TCP segmentation offload support")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 7045fedfd73a..7af223b0a37f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -652,9 +652,7 @@ static void otx2_sqe_add_ext(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 				htons(ext->lso_sb - skb_network_offset(skb));
 		} else if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV6) {
 			ext->lso_format = pfvf->hw.lso_tsov6_idx;
-
-			ipv6_hdr(skb)->payload_len =
-				htons(ext->lso_sb - skb_network_offset(skb));
+			ipv6_hdr(skb)->payload_len = htons(tcp_hdrlen(skb));
 		} else if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
 			__be16 l3_proto = vlan_get_protocol(skb);
 			struct udphdr *udph = udp_hdr(skb);
-- 
2.25.1


