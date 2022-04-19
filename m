Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA01507661
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 19:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344750AbiDSRVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 13:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344046AbiDSRVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 13:21:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2582135DEC
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650388743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+OY+yFzsQIMqQoPMP1panGUfFqcHdiP2vcaSQtdolkA=;
        b=ECERY72eOro82vnIG8tZ1df4pScvRGAx0qMdQKlCZi4o+hSp1/4P+aKcidSr5n/XT5Ztun
        1g+B47He5MEUtClWC6ez3R4D4TTivGw5Clo374Eve1NVnql7ndEFG/D4l6YeiYr3/C1Hdb
        RcZkZA0Lv/ne8T7y4tIcDj5TEJm2KZ4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-03ZBCMCGNd2K67i1YWzM7Q-1; Tue, 19 Apr 2022 13:18:59 -0400
X-MC-Unique: 03ZBCMCGNd2K67i1YWzM7Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3DBF8517FB;
        Tue, 19 Apr 2022 17:18:47 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2199F40146E;
        Tue, 19 Apr 2022 17:18:46 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, mptcp@lists.linux.dev
Subject: [RFC PATCH 2/2] mptcp: never shrink offered window
Date:   Tue, 19 Apr 2022 19:18:24 +0200
Message-Id: <4742d835a4550db1a6f6f8ac6eea3433f819c36a.1650386197.git.pabeni@redhat.com>
In-Reply-To: <cover.1650386197.git.pabeni@redhat.com>
References: <cover.1650386197.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per RFC, the offered MPTCP-level window should never shrink.
While we currently track the right edge, we don't enforce the
above constraint on the wire.
Additionally, concurrent xmit on different subflows can end-up in
erroneous right edge update.
Address the above explicitly updating the announced window and
protecting the update with an additional atomic operation (sic)

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c | 52 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 9d6f14b496df..86d67ad41266 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1224,20 +1224,58 @@ bool mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 	return true;
 }
 
-static void mptcp_set_rwin(const struct tcp_sock *tp)
+static void mptcp_set_rwin(struct tcp_sock *tp, struct tcphdr *th)
 {
 	const struct sock *ssk = (const struct sock *)tp;
-	const struct mptcp_subflow_context *subflow;
+	struct mptcp_subflow_context *subflow;
+	u64 ack_seq, rcv_wnd_old, rcv_wnd_new;
 	struct mptcp_sock *msk;
-	u64 ack_seq;
+	u32 new_win;
+	u64 win;
 
 	subflow = mptcp_subflow_ctx(ssk);
 	msk = mptcp_sk(subflow->conn);
 
-	ack_seq = READ_ONCE(msk->ack_seq) + tp->rcv_wnd;
+	ack_seq = READ_ONCE(msk->ack_seq);
+	rcv_wnd_new = ack_seq + tp->rcv_wnd;
+
+	rcv_wnd_old = READ_ONCE(msk->rcv_wnd_sent);
+	if (after64(rcv_wnd_new, rcv_wnd_old)) {
+		u64 rcv_wnd;
+
+		for (;;) {
+			rcv_wnd = cmpxchg64(&msk->rcv_wnd_sent, rcv_wnd_old, rcv_wnd_new);
+
+			if (rcv_wnd == rcv_wnd_old)
+				break;
+			if (before64(rcv_wnd_new, rcv_wnd))
+				goto raise_win;
+			rcv_wnd_old = rcv_wnd;
+		};
+		return;
+	}
+
+	if (rcv_wnd_new != rcv_wnd_old) {
+raise_win:
+		win = rcv_wnd_old - ack_seq;
+		tp->rcv_wnd = min_t(u64, win, U32_MAX);
+		new_win = tp->rcv_wnd;
 
-	if (after64(ack_seq, READ_ONCE(msk->rcv_wnd_sent)))
-		WRITE_ONCE(msk->rcv_wnd_sent, ack_seq);
+		/* Make sure we do not exceed the maximum possible
+		 * scaled window.
+		 */
+		if (unlikely(th->syn))
+			new_win = min(new_win, 65535U) << tp->rx_opt.rcv_wscale;
+		if (!tp->rx_opt.rcv_wscale &&
+		    sock_net(ssk)->ipv4.sysctl_tcp_workaround_signed_windows)
+			new_win = min(new_win, MAX_TCP_WINDOW);
+		else
+			new_win = min(new_win, (65535U << tp->rx_opt.rcv_wscale));
+
+		/* RFC1323 scaling applied */
+		new_win >>= tp->rx_opt.rcv_wscale;
+		th->window = htons(new_win);
+	}
 }
 
 u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum sum)
@@ -1550,7 +1588,7 @@ void mptcp_write_options(struct tcphdr *th, __be32 *ptr, struct tcp_sock *tp,
 	}
 
 	if (tp)
-		mptcp_set_rwin(tp);
+		mptcp_set_rwin(tp, th);
 }
 
 __be32 mptcp_get_reset_option(const struct sk_buff *skb)
-- 
2.35.1

