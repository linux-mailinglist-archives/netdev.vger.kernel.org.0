Return-Path: <netdev+bounces-7150-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F33471EEAD
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:22:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB36E1C20F04
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8461542509;
	Thu,  1 Jun 2023 16:22:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76ADB22D77
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:22:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BADD134
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685636528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OEv0joFCDuHbuGt/Asb4AZElQyo2ctgPqP8Gt2HoqV8=;
	b=dyUv/2+1/iKjYM/ba5aHCI1wovu39/XLMbEb4tPJ3ksoVAnCGVfDAYAuzpPXthg7dv75Ld
	sBrc5eKB/R30VSf+7HLFDDtWPqVguF3Bqe45LephdAKstsMe91jsSsaxshasoo2W+K7qRk
	HSDaXOXjtkgIK1fylp0nV5WH77czRkU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-BC_obQn7OWOoJhdNPx9a_g-1; Thu, 01 Jun 2023 12:21:57 -0400
X-MC-Unique: BC_obQn7OWOoJhdNPx9a_g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 932D4802355;
	Thu,  1 Jun 2023 16:21:56 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.21])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3E5C1492B0B;
	Thu,  1 Jun 2023 16:21:56 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
	by firesoul.localdomain (Postfix) with ESMTP id 7F3D2307372E8;
	Thu,  1 Jun 2023 18:21:54 +0200 (CEST)
Subject: [PATCH bpf-next V2] bpf/xdp: optimize bpf_xdp_pointer to avoid
 reading sinfo
From: Jesper Dangaard Brouer <brouer@redhat.com>
To: Tariq Toukan <ttoukan.linux@gmail.com>,
 Daniel Borkmann <borkmann@iogearbox.net>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrii Nakryiko <andrii.nakryiko@gmail.com>, bpf@vger.kernel.org
Cc: Jesper Dangaard Brouer <brouer@redhat.com>,
 Tariq Toukan <tariqt@nvidia.com>, gal@nvidia.com, lorenzo@kernel.org,
 netdev@vger.kernel.org, echaudro@redhat.com, andrew.gospodarek@broadcom.com
Date: Thu, 01 Jun 2023 18:21:54 +0200
Message-ID: <168563651438.3436004.17735707525651776648.stgit@firesoul>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently we observed a significant performance degradation in
samples/bpf xdp1 and xdp2, due XDP multibuffer "xdp.frags" handling,
added in commit 772251742262 ("samples/bpf: fixup some tools to be able
to support xdp multibuffer").

This patch reduce the overhead by avoiding to read/load shared_info
(sinfo) memory area, when XDP packet don't have any frags. This improves
performance because sinfo is located in another cacheline.

Function bpf_xdp_pointer() is used by BPF helpers bpf_xdp_load_bytes()
and bpf_xdp_store_bytes(). As a help to reviewers, xdp_get_buff_len() can
potentially access sinfo, but it uses xdp_buff_has_frags() flags bit check
to avoid accessing sinfo in no-frags case.

The likely/unlikely instrumentation lays out asm code such that sinfo
access isn't interleaved with no-frags case (checked on GCC 12.2.1-4).
The generated asm code is more compact towards the no-frags case.

The BPF kfunc bpf_dynptr_slice() also use bpf_xdp_pointer(). Thus, it
should also take effect for that.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/filter.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 968139f4a1ac..961db5bd2f94 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3948,20 +3948,21 @@ void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
 
 void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
 {
-	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	u32 size = xdp->data_end - xdp->data;
+	struct skb_shared_info *sinfo;
 	void *addr = xdp->data;
 	int i;
 
 	if (unlikely(offset > 0xffff || len > 0xffff))
 		return ERR_PTR(-EFAULT);
 
-	if (offset + len > xdp_get_buff_len(xdp))
+	if (unlikely(offset + len > xdp_get_buff_len(xdp)))
 		return ERR_PTR(-EINVAL);
 
-	if (offset < size) /* linear area */
+	if (likely((offset < size))) /* linear area */
 		goto out;
 
+	sinfo = xdp_get_shared_info_from_buff(xdp);
 	offset -= size;
 	for (i = 0; i < sinfo->nr_frags; i++) { /* paged area */
 		u32 frag_size = skb_frag_size(&sinfo->frags[i]);



