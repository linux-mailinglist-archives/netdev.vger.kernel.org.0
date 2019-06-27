Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B37E058DA5
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfF0WIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:08:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10810 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726498AbfF0WIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:08:40 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5RM8csS006106
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 15:08:39 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2tcxeyj066-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 15:08:38 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Jun 2019 15:08:37 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 97579240E9958; Thu, 27 Jun 2019 15:08:36 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <netdev@vger.kernel.org>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <saeedm@mellanox.com>,
        <maximmi@mellanox.com>, <brouer@redhat.com>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH 3/6 bpf-next] Always check the recycle stack when using the umem fq.
Date:   Thu, 27 Jun 2019 15:08:33 -0700
Message-ID: <20190627220836.2572684-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
References: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=992 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270254
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The specific _rq variants are deprecated, and will be removed next.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/net/xdp_sock.h | 22 +++-------------------
 net/xdp/xsk.c          | 22 +++++++++++++++++++---
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 7df7b417ac53..55f5f27ef22a 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -99,33 +99,17 @@ static inline dma_addr_t xdp_umem_get_dma(struct xdp_umem *umem, u64 addr)
 /* Reuse-queue aware version of FILL queue helpers */
 static inline bool xsk_umem_has_addrs_rq(struct xdp_umem *umem, u32 cnt)
 {
-	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
-
-	if (rq->length >= cnt)
-		return true;
-
-	return xsk_umem_has_addrs(umem, cnt - rq->length);
+	return xsk_umem_has_addrs(umem, cnt);
 }
 
 static inline u64 *xsk_umem_peek_addr_rq(struct xdp_umem *umem, u64 *addr)
 {
-	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
-
-	if (!rq->length)
-		return xsk_umem_peek_addr(umem, addr);
-
-	*addr = rq->handles[rq->length - 1] & umem->chunk_mask;
-	return addr;
+	return xsk_umem_peek_addr(umem, addr);
 }
 
 static inline void xsk_umem_discard_addr_rq(struct xdp_umem *umem)
 {
-	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
-
-	if (!rq->length)
-		xsk_umem_discard_addr(umem);
-	else
-		rq->length--;
+	return xsk_umem_discard_addr(umem);
 }
 
 static inline void xsk_umem_recycle_addr(struct xdp_umem *umem, u64 addr)
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 74417a851ed5..fc33070b1821 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -39,19 +39,35 @@ bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
 
 bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt)
 {
-	return xskq_has_addrs(umem->fq, cnt);
+	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
+
+        if (rq->length >= cnt)
+                return true;
+
+	return xskq_has_addrs(umem->fq, cnt - rq->length);
 }
 EXPORT_SYMBOL(xsk_umem_has_addrs);
 
 u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr)
 {
-	return xskq_peek_addr(umem->fq, addr);
+	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
+
+	if (!rq->length)
+		return xskq_peek_addr(umem->fq, addr);
+
+	*addr = rq->handles[rq->length - 1] & umem->chunk_mask;
+	return addr;
 }
 EXPORT_SYMBOL(xsk_umem_peek_addr);
 
 void xsk_umem_discard_addr(struct xdp_umem *umem)
 {
-	xskq_discard_addr(umem->fq);
+	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
+
+	if (!rq->length)
+		xskq_discard_addr(umem->fq);
+	else
+		rq->length--;
 }
 EXPORT_SYMBOL(xsk_umem_discard_addr);
 
-- 
2.17.1

