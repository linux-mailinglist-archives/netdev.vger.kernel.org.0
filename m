Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F56F567B01
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 01:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiGEX7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 19:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiGEX7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 19:59:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DAB183AD;
        Tue,  5 Jul 2022 16:59:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 456CA61196;
        Tue,  5 Jul 2022 23:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDECC341D1;
        Tue,  5 Jul 2022 23:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657065577;
        bh=C32Cn5loiON0F7czPEkArPlWf1v6YWueU3OQ7k4g/ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a20SWPQaGHEfFOAKcjStygR5nLVDigWPQgBYnb7ep+N7hCamfpCFcWFZMHvBicf5q
         W0x0t2m6E95/i3WJEJWaS12eevvytFbedMdYYjjQWUt1tlGX8hppbBRpwIioAR8OJK
         EuOFIjBL/rHHwfOjzN/79HNBuKusI9JVxLNk1+5+y5caHj/gAMU+O0JEJLnuPHq+c1
         wyuQNtkx7KsipLk0eNliKQWrGuo2eExTktkl9EwDcvMWp5YIaUq5SCVOhXyVirkpmJ
         ObXJgp99Ww0wi+Ij14koqcgrrvN3P/qQrxPdJvERnvyeUq1+sLcwuC36nzNIsezkKX
         zfthKtO+5Rv7A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        john.fastabend@gmail.com, borisp@nvidia.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        maximmi@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/5] tls: rx: periodically flush socket backlog
Date:   Tue,  5 Jul 2022 16:59:26 -0700
Message-Id: <20220705235926.1035407-6-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220705235926.1035407-1-kuba@kernel.org>
References: <20220705235926.1035407-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We continuously hold the socket lock during large reads and writes.
This may inflate RTT and negatively impact TCP performance.
Flush the backlog periodically. I tried to pick a flush period (128kB)
which gives significant benefit but the max Bps rate is not yet visibly
impacted.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/sock.c  |  1 +
 net/tls/tls_sw.c | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index 92a0296ccb18..4cb957d934a2 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2870,6 +2870,7 @@ void __sk_flush_backlog(struct sock *sk)
 	__release_sock(sk);
 	spin_unlock_bh(&sk->sk_lock.slock);
 }
+EXPORT_SYMBOL_GPL(__sk_flush_backlog);
 
 /**
  * sk_wait_data - wait for data to arrive at sk_receive_queue
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 7592b6519953..79043bc3da39 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1738,6 +1738,24 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 	return copied ? : err;
 }
 
+static void
+tls_read_flush_backlog(struct sock *sk, struct tls_prot_info *prot,
+		       size_t len_left, size_t decrypted, ssize_t done,
+		       size_t *flushed_at)
+{
+	size_t max_rec;
+
+	if (len_left <= decrypted)
+		return;
+
+	max_rec = prot->overhead_size - prot->tail_size + TLS_MAX_PAYLOAD_SIZE;
+	if (done - *flushed_at < SZ_128K && tcp_inq(sk) > max_rec)
+		return;
+
+	*flushed_at = done;
+	sk_flush_backlog(sk);
+}
+
 int tls_sw_recvmsg(struct sock *sk,
 		   struct msghdr *msg,
 		   size_t len,
@@ -1750,6 +1768,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	struct sk_psock *psock;
 	unsigned char control = 0;
 	ssize_t decrypted = 0;
+	size_t flushed_at = 0;
 	struct strp_msg *rxm;
 	struct tls_msg *tlm;
 	struct sk_buff *skb;
@@ -1839,6 +1858,10 @@ int tls_sw_recvmsg(struct sock *sk,
 		if (err <= 0)
 			goto recv_end;
 
+		/* periodically flush backlog, and feed strparser */
+		tls_read_flush_backlog(sk, prot, len, to_decrypt,
+				       decrypted + copied, &flushed_at);
+
 		ctx->recv_pkt = NULL;
 		__strp_unpause(&ctx->strp);
 		__skb_queue_tail(&ctx->rx_list, skb);
-- 
2.36.1

