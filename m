Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12607AC4C4
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 07:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394431AbfIGFa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 01:30:27 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44501 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394420AbfIGFa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 01:30:26 -0400
Received: by mail-wr1-f66.google.com with SMTP id 30so8515484wrk.11
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 22:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SFYVCFDmUtuKidhMHe9RczcjQTKIIorRjG9j3ugVPdw=;
        b=s9bRZvm3HQhxMVncU//uvmFID8o8X1N1cKK2RH6Qzr4XUrBe0OKfqK6U4Io9qOQzjY
         t4KitTVnRP79JQKYOc+XKBbucLERi1yYfI+sE/FrOrKHzZS6iI5LBLfYiJXKQrBc30x5
         2oxUKBjvJh5xvCCsESDpvzPwKtk2V52UayGALrJRKCVV3OcErZ5shRZXjGpWtUFG6tit
         cDLCSiJTbQcLl55N9Sl9O2aofEHTZ+NG/ptjq922TiSxEjUkBfzaPycR0zGUm+iwmVPu
         ZRhucdnNCSYCkakx/nZEFnpCWAil1aXp+q60i0WFj09HqIwf4Zjge/M6vNNwRoWwoXwb
         hjzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SFYVCFDmUtuKidhMHe9RczcjQTKIIorRjG9j3ugVPdw=;
        b=UK50r5qWP3gZYzrbCOjvq3npe3D6CcoB+6xLp5b56k8BpsySyw/8tT9XYtjLHJxPsq
         EV0NB5impiP71gNkDk9bgxV8vHi6e74clWAUW0qGLlS1fuyZOwBxHhFvBGi0M2xx4qzK
         xpeVHETQHHWezQSPSb/YgqDirTrGSbhDNm6KMgzgPnT06EkChdoBjCa5tLlaDoV5dfLH
         zyNEpMtnWti4ZLUamDbGoALQZVHvU1p5L05FJD+pHbvqrs6Z9FpF9XQslq/mNLt7bbB1
         jpDTUbw5Yh3+zCzKM6vwUbMvq29EpQEyJjHAFuDAjx2veAUHFgUl7mc+MYhbELzwooQi
         OpAg==
X-Gm-Message-State: APjAAAWXisBZyGtGw8pows3eqRPhlCp1bSjwHQrQF4dARTJESY7qqS3x
        9pX4V/dSyXb3mzk05j2M3MfqoQ==
X-Google-Smtp-Source: APXvYqzH1ZcCtyiHq0xxlUSZwVoVvH6gwGRRH6HP7c1rz3BR3ifCJmqlfu4ufsGFQ01sfpDWnDw4Ww==
X-Received: by 2002:adf:fd41:: with SMTP id h1mr9492644wrs.315.1567834224856;
        Fri, 06 Sep 2019 22:30:24 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n4sm2446939wmd.45.2019.09.06.22.30.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 22:30:24 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 3/4] net/tls: remove the record tail optimization
Date:   Fri,  6 Sep 2019 22:29:59 -0700
Message-Id: <20190907053000.23869-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190907053000.23869-1-jakub.kicinski@netronome.com>
References: <20190907053000.23869-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For TLS device offload the tag/message authentication code are
filled in by the device. The kernel merely reserves space for
them. Because device overwrites it, the contents of the tag make
do no matter. Current code tries to save space by reusing the
header as the tag. This, however, leads to an additional frag
being created and defeats buffer coalescing (which trickles
all the way down to the drivers).

Remove this optimization, and try to allocate the space for
the tag in the usual way, leave the memory uninitialized.
If memory allocation fails rewind the record pointer so that
we use the already copied user data as tag.

Note that the optimization was actually buggy, as the tag
for TLS 1.2 is 16 bytes, but header is just 13, so the reuse
may had looked past the end of the page..

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 67 +++++++++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 20 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b11355e00514..916c3c0a99f0 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -256,29 +256,13 @@ static int tls_push_record(struct sock *sk,
 			   struct tls_context *ctx,
 			   struct tls_offload_context_tx *offload_ctx,
 			   struct tls_record_info *record,
-			   struct page_frag *pfrag,
-			   int flags,
-			   unsigned char record_type)
+			   int flags)
 {
 	struct tls_prot_info *prot = &ctx->prot_info;
 	struct tcp_sock *tp = tcp_sk(sk);
-	struct page_frag dummy_tag_frag;
 	skb_frag_t *frag;
 	int i;
 
-	/* fill prepend */
-	frag = &record->frags[0];
-	tls_fill_prepend(ctx,
-			 skb_frag_address(frag),
-			 record->len - prot->prepend_size,
-			 record_type,
-			 prot->version);
-
-	/* HW doesn't care about the data in the tag, because it fills it. */
-	dummy_tag_frag.page = skb_frag_page(frag);
-	dummy_tag_frag.offset = 0;
-
-	tls_append_frag(record, &dummy_tag_frag, prot->tag_size);
 	record->end_seq = tp->write_seq + record->len;
 	list_add_tail_rcu(&record->list, &offload_ctx->records_list);
 	offload_ctx->open_record = NULL;
@@ -302,6 +286,38 @@ static int tls_push_record(struct sock *sk,
 	return tls_push_sg(sk, ctx, offload_ctx->sg_tx_data, 0, flags);
 }
 
+static int tls_device_record_close(struct sock *sk,
+				   struct tls_context *ctx,
+				   struct tls_record_info *record,
+				   struct page_frag *pfrag,
+				   unsigned char record_type)
+{
+	struct tls_prot_info *prot = &ctx->prot_info;
+	int ret;
+
+	/* append tag
+	 * device will fill in the tag, we just need to append a placeholder
+	 * use socket memory to improve coalescing (re-using a single buffer
+	 * increases frag count)
+	 * if we can't allocate memory now, steal some back from data
+	 */
+	if (likely(skb_page_frag_refill(prot->tag_size, pfrag,
+					sk->sk_allocation))) {
+		ret = 0;
+		tls_append_frag(record, pfrag, prot->tag_size);
+	} else {
+		ret = prot->tag_size;
+		if (record->len <= prot->overhead_size)
+			return -ENOMEM;
+	}
+
+	/* fill prepend */
+	tls_fill_prepend(ctx, skb_frag_address(&record->frags[0]),
+			 record->len - prot->overhead_size,
+			 record_type, prot->version);
+	return ret;
+}
+
 static int tls_create_new_record(struct tls_offload_context_tx *offload_ctx,
 				 struct page_frag *pfrag,
 				 size_t prepend_size)
@@ -452,13 +468,24 @@ static int tls_push_data(struct sock *sk,
 
 		if (done || record->len >= max_open_record_len ||
 		    (record->num_frags >= MAX_SKB_FRAGS - 1)) {
+			rc = tls_device_record_close(sk, tls_ctx, record,
+						     pfrag, record_type);
+			if (rc) {
+				if (rc > 0) {
+					size += rc;
+				} else {
+					size = orig_size;
+					destroy_record(record);
+					ctx->open_record = NULL;
+					break;
+				}
+			}
+
 			rc = tls_push_record(sk,
 					     tls_ctx,
 					     ctx,
 					     record,
-					     pfrag,
-					     tls_push_record_flags,
-					     record_type);
+					     tls_push_record_flags);
 			if (rc < 0)
 				break;
 		}
-- 
2.21.0

