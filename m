Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA62C507660
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 19:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345440AbiDSRVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 13:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344949AbiDSRVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 13:21:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 12A1037031
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650388744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CGTewbNlZUGfFdE30/MN+3b/au+fh0iegi/684GrH9E=;
        b=BYac0g3BkTPPBa/cUIreC0w4O82LOpB1HWJNVZNbrELuXC2IJHUypd4mTnxAQozoxcVNWs
        hKVmM1LkS5ToUUkrc0jCYCPM43mlPWtq9/nGhF3H51RozxZx48g2aOTYrX3eOuRAREm+iV
        EyuFG28ta4qOgicoqGr4iop++VHPbGI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-AdcT_uPVMpSvmAXXxaYmHg-1; Tue, 19 Apr 2022 13:19:02 -0400
X-MC-Unique: AdcT_uPVMpSvmAXXxaYmHg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1B4128EC109;
        Tue, 19 Apr 2022 17:18:46 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D314E403372;
        Tue, 19 Apr 2022 17:18:45 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, mptcp@lists.linux.dev
Subject: [RFC PATCH 1/2] tcp: allow MPTCP to update the announced window.
Date:   Tue, 19 Apr 2022 19:18:23 +0200
Message-Id: <7a91a8d9980c668c4de07b3f0304a7808d0a1113.1650386197.git.pabeni@redhat.com>
In-Reply-To: <cover.1650386197.git.pabeni@redhat.com>
References: <cover.1650386197.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MPTCP RFC requires that the MPTCP-level receive window's
right edge never moves backward. Currently the MPTCP code
enforces such constraint while tracking the right edge, but it
does not reflects the constraint back on the wire, as lacks a
suitable hook to update accordingly the TCP header.

This change modifies the existing mptcp_write_options() hook,
providing the current packet's TCP header up to the MPTCP protocol
level, so that the next patch could implement the above mentioned
constraint.

No functional changes intended.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/mptcp.h   |  2 +-
 net/ipv4/tcp_output.c | 14 ++++++++------
 net/mptcp/options.c   |  2 +-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 0a3b0fb04a3b..ded4359b15be 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -124,7 +124,7 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 			       struct mptcp_out_options *opts);
 bool mptcp_incoming_options(struct sock *sk, struct sk_buff *skb);
 
-void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
+void mptcp_write_options(struct tcphdr *th, __be32 *ptr, struct tcp_sock *tp,
 			 struct mptcp_out_options *opts);
 
 void mptcp_diag_fill_info(struct mptcp_sock *msk, struct mptcp_info *info);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c221f3bce975..7d64c3fc5d40 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -444,12 +444,13 @@ struct tcp_out_options {
 	struct mptcp_out_options mptcp;
 };
 
-static void mptcp_options_write(__be32 *ptr, const struct tcp_sock *tp,
+static void mptcp_options_write(struct tcphdr *th, __be32 *ptr,
+				struct tcp_sock *tp,
 				struct tcp_out_options *opts)
 {
 #if IS_ENABLED(CONFIG_MPTCP)
 	if (unlikely(OPTION_MPTCP & opts->options))
-		mptcp_write_options(ptr, tp, &opts->mptcp);
+		mptcp_write_options(th, ptr, tp, &opts->mptcp);
 #endif
 }
 
@@ -605,9 +606,10 @@ static void bpf_skops_write_hdr_opt(struct sock *sk, struct sk_buff *skb,
  * At least SACK_PERM as the first option is known to lead to a disaster
  * (but it may well be that other scenarios fail similarly).
  */
-static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
+static void tcp_options_write(struct tcphdr *th, struct tcp_sock *tp,
 			      struct tcp_out_options *opts)
 {
+	__be32 *ptr = (__be32 *)(th + 1);
 	u16 options = opts->options;	/* mungable copy */
 
 	if (unlikely(OPTION_MD5 & options)) {
@@ -701,7 +703,7 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 
 	smc_options_write(ptr, &options);
 
-	mptcp_options_write(ptr, tp, opts);
+	mptcp_options_write(th, ptr, tp, opts);
 }
 
 static void smc_set_option(const struct tcp_sock *tp,
@@ -1354,7 +1356,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		th->window	= htons(min(tp->rcv_wnd, 65535U));
 	}
 
-	tcp_options_write((__be32 *)(th + 1), tp, &opts);
+	tcp_options_write(th, tp, &opts);
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* Calculate the MD5 hash, as we have all we need now */
@@ -3590,7 +3592,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 
 	/* RFC1323: The window in SYN & SYN/ACK segments is never scaled. */
 	th->window = htons(min(req->rsk_rcv_wnd, 65535U));
-	tcp_options_write((__be32 *)(th + 1), NULL, &opts);
+	tcp_options_write(th, NULL, &opts);
 	th->doff = (tcp_header_size >> 2);
 	__TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
 
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 325383646f5c..9d6f14b496df 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1265,7 +1265,7 @@ static u16 mptcp_make_csum(const struct mptcp_ext *mpext)
 				 ~csum_unfold(mpext->csum));
 }
 
-void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
+void mptcp_write_options(struct tcphdr *th, __be32 *ptr, struct tcp_sock *tp,
 			 struct mptcp_out_options *opts)
 {
 	const struct sock *ssk = (const struct sock *)tp;
-- 
2.35.1

