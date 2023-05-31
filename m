Return-Path: <netdev+bounces-6823-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9732871855A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:52:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 312F61C20BB8
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9AB616422;
	Wed, 31 May 2023 14:52:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4DFC8E6
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:52:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866CD107
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685544759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Lghs6j2iL3h/kh8yLidsa6G+fvLplrWudkyLTE3LDVk=;
	b=CEqWRta6kpgYuiP2KiVRhW3ZI9JJy/vCCDSj3RJ0qAXPq+9I+tvB3SnN7aGVMAqrXPdXE6
	hLM5fkg1dUEY98Q8CCI60wTjBkJEeMTjOlbyzwIpxg2pdXrjvIPRuQI1nJbrZ4Suz96D++
	2T2hxxJQfVEtJczvvY2r5fEA4TrUrlo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-A4Oy1bqLN8mJM4oL6uyAtg-1; Wed, 31 May 2023 10:52:35 -0400
X-MC-Unique: A4Oy1bqLN8mJM4oL6uyAtg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCC578032E4;
	Wed, 31 May 2023 14:52:34 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.21])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 867B8140E962;
	Wed, 31 May 2023 14:52:34 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
	by firesoul.localdomain (Postfix) with ESMTP id C06E4307372E8;
	Wed, 31 May 2023 16:52:33 +0200 (CEST)
Subject: [PATCH bpf-next] bpf/xdp: optimize bpf_xdp_pointer to avoid reading
 sinfo
From: Jesper Dangaard Brouer <brouer@redhat.com>
To: Tariq Toukan <ttoukan.linux@gmail.com>,
 Daniel Borkmann <borkmann@iogearbox.net>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrii Nakryiko <andrii.nakryiko@gmail.com>, bpf@vger.kernel.org
Cc: Jesper Dangaard Brouer <brouer@redhat.com>,
 Tariq Toukan <tariqt@nvidia.com>, gal@nvidia.com, lorenzo@kernel.org,
 netdev@vger.kernel.org, echaudro@redhat.com, andrew.gospodarek@broadcom.com
Date: Wed, 31 May 2023 16:52:33 +0200
Message-ID: <168554475365.3262482.9868965521545045945.stgit@firesoul>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
potentially access sinfo.

Perf report show bpf_xdp_pointer() percentage utilization being reduced
from 4,19% to 3,37% (on CPU E5-1650 @3.60GHz).

The BPF kfunc bpf_dynptr_slice() also use bpf_xdp_pointer(). Thus, it
should also take effect for that.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/filter.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 968139f4a1ac..a635f537d499 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3948,20 +3948,24 @@ void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
 
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
-		return ERR_PTR(-EINVAL);
+	if (likely((offset < size))) /* linear area */
+		goto out;
 
-	if (offset < size) /* linear area */
+	if (likely(!xdp_buff_has_frags(xdp)))
 		goto out;
 
+	if (offset + len > xdp_get_buff_len(xdp))
+		return ERR_PTR(-EINVAL);
+
+	sinfo = xdp_get_shared_info_from_buff(xdp);
 	offset -= size;
 	for (i = 0; i < sinfo->nr_frags; i++) { /* paged area */
 		u32 frag_size = skb_frag_size(&sinfo->frags[i]);



