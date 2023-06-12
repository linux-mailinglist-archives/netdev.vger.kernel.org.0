Return-Path: <netdev+bounces-10151-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CE5572C8C9
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:40:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB6361C20BC7
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 898AB1C75B;
	Mon, 12 Jun 2023 14:38:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4261C742
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:38:45 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF37F0
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:38:41 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 28E19227B0;
	Mon, 12 Jun 2023 14:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1686580720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rUw5WSitLdVOck4DEQEf1XMYhkpVmGy7HF5W++dITRI=;
	b=Jv7Mqdxc3vUzlvjFuqEq2Epvy0SB0PrOS8CkvvBdNcqduPAC2fgYtZjRFMhU3iiHK2E8qG
	RC6HlZaYqA89ekNdgLo0WITqzpH0vl1j3o3mAf+IWqridrS3sU2GcJNIHRX23hVXhJkzLZ
	sfMtz+Gp0sCyCxy+TFOVhDciNWVtgtw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1686580720;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rUw5WSitLdVOck4DEQEf1XMYhkpVmGy7HF5W++dITRI=;
	b=j/5OfCZLH5d3R4eG/vOVpu4AZZEF3mZsUyxwNp/gFDK781hljF7fHLx36oTllKy2A7q/Sf
	GWmAKAzj/kRAvbDQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
	by relay2.suse.de (Postfix) with ESMTP id E5E682C145;
	Mon, 12 Jun 2023 14:38:39 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
	id D6E2651C4CBD; Mon, 12 Jun 2023 16:38:39 +0200 (CEST)
From: Hannes Reinecke <hare@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	linux-nvme@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>,
	Boris Pismenny <boris.pismenny@gmail.com>
Subject: [PATCH 3/4] net/tls: implement ->read_sock()
Date: Mon, 12 Jun 2023 16:38:32 +0200
Message-Id: <20230612143833.70805-4-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230612143833.70805-1-hare@suse.de>
References: <20230612143833.70805-1-hare@suse.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement ->read_sock() function for use with nvme-tcp.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Cc: Boris Pismenny <boris.pismenny@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 net/tls/tls.h      |  2 ++
 net/tls/tls_main.c |  2 ++
 net/tls/tls_sw.c   | 71 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 804c3880d028..a5bf3a9ce142 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -113,6 +113,8 @@ bool tls_sw_sock_is_readable(struct sock *sk);
 ssize_t tls_sw_splice_read(struct socket *sock, loff_t *ppos,
 			   struct pipe_inode_info *pipe,
 			   size_t len, unsigned int flags);
+int tls_sw_read_sock(struct sock *sk, read_descriptor_t *desc,
+		     sk_read_actor_t read_actor);
 
 int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int tls_device_sendpage(struct sock *sk, struct page *page,
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index f2e7302a4d96..767297a029b9 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -922,9 +922,11 @@ static void build_proto_ops(struct proto_ops ops[TLS_NUM_CONFIG][TLS_NUM_CONFIG]
 
 	ops[TLS_BASE][TLS_SW  ] = ops[TLS_BASE][TLS_BASE];
 	ops[TLS_BASE][TLS_SW  ].splice_read	= tls_sw_splice_read;
+	ops[TLS_BASE][TLS_SW  ].read_sock	= tls_sw_read_sock;
 
 	ops[TLS_SW  ][TLS_SW  ] = ops[TLS_SW  ][TLS_BASE];
 	ops[TLS_SW  ][TLS_SW  ].splice_read	= tls_sw_splice_read;
+	ops[TLS_SW  ][TLS_SW  ].read_sock	= tls_sw_read_sock;
 
 #ifdef CONFIG_TLS_DEVICE
 	ops[TLS_HW  ][TLS_BASE] = ops[TLS_BASE][TLS_BASE];
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 16eae0c5c819..e34ff6f9e51f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2225,6 +2225,77 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	goto splice_read_end;
 }
 
+int tls_sw_read_sock(struct sock *sk, read_descriptor_t *desc,
+		     sk_read_actor_t read_actor)
+{
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
+	struct strp_msg *rxm = NULL;
+	struct tls_msg *tlm;
+	struct sk_buff *skb;
+	ssize_t copied = 0;
+	int err, used;
+
+	if (!skb_queue_empty(&ctx->rx_list)) {
+		skb = __skb_dequeue(&ctx->rx_list);
+	} else {
+		struct tls_decrypt_arg darg;
+
+		err = tls_rx_rec_wait(sk, NULL, true, true);
+		if (err <= 0)
+			return err;
+
+		memset(&darg.inargs, 0, sizeof(darg.inargs));
+
+		err = tls_rx_one_record(sk, NULL, &darg);
+		if (err < 0) {
+			tls_err_abort(sk, -EBADMSG);
+			return err;
+		}
+
+		tls_rx_rec_done(ctx);
+		skb = darg.skb;
+	}
+
+	do {
+		rxm = strp_msg(skb);
+		tlm = tls_msg(skb);
+
+		/* read_sock does not support reading control messages */
+		if (tlm->control != TLS_RECORD_TYPE_DATA) {
+			err = -EINVAL;
+			goto read_sock_requeue;
+		}
+
+		used = read_actor(desc, skb, rxm->offset, rxm->full_len);
+		if (used <= 0) {
+			err = used;
+			goto read_sock_end;
+		}
+
+		copied += used;
+		if (used < rxm->full_len) {
+			rxm->offset += used;
+			rxm->full_len -= used;
+			if (!desc->count)
+				goto read_sock_requeue;
+		} else {
+			consume_skb(skb);
+			if (desc->count && !skb_queue_empty(&ctx->rx_list))
+				skb = __skb_dequeue(&ctx->rx_list);
+			else
+				skb = NULL;
+		}
+	} while (skb);
+
+read_sock_end:
+	return copied ? : err;
+
+read_sock_requeue:
+	__skb_queue_head(&ctx->rx_list, skb);
+	goto read_sock_end;
+}
+
 bool tls_sw_sock_is_readable(struct sock *sk)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
-- 
2.35.3


