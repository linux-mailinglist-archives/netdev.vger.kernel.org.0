Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9932D83D8
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 02:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406561AbgLLB3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 20:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437076AbgLLB3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 20:29:03 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32718C0613CF;
        Fri, 11 Dec 2020 17:28:23 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id b5so1785715pjk.2;
        Fri, 11 Dec 2020 17:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=XE0rlFPg1mJA2Km2y94Yg0vZGLDfpfOBughewlzeYmE=;
        b=CPWCmAYDsODAr5NF3xVJP/lJ5CUeMNvmGI89cSrGrwutCtKLNL9oqUeKrfvD2q5PIR
         J1KBIPOcQ+EVTmBBTkKWRMeRPmj0mxpxzUnAHoYHn+7/qTCL0pfkiKnIld/m5f0fFI3U
         1dGxxHpephKLoKixY5j3sSknaBybig1M7EdIeIgwaqo88BmJmbprRd+N7aLpfeQcp8JG
         FhLM/UO7szwaonqIGXwj0oDcGjwPSBpDQScQCcTu83UD2gbc0ajHmkxUbifE9oyVIXWi
         jHCvMiSNRQ3sjCAswH7INvKz7Li7HR/cWLEGrS4gzBDUuLDAOjz9OQi/L0ce0N4BFMoB
         DJuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=XE0rlFPg1mJA2Km2y94Yg0vZGLDfpfOBughewlzeYmE=;
        b=LeT1TXU/klcujaQSoknuTggdyWjbiiKlhPXjKS3FwX5xILTeU1Hgemn+imd+RmBMcr
         dev7kcmoKLbG6+kDDY8r0CZuyNGkaskOoxbimeihnUyToaE4g33qG/KNVfmQd3l1P0Tl
         2T1B6yiAIzBAofIzsD/JprhCj15aQSn9krMfK7fKWl1U6ZHXec0FMs/UI82QtQUeW8NI
         xFbNzfOZQ9ZWbvOEt1nndsA34YsrhOKtDTNVjABFifcIDgtD+xR82lNsBDwIY8OosX1J
         fYvY/5i01Qu9Z1lD9s5yYcrY4ZcCHIcGD0ZhaTyUKRkOUiEPwhP7mztLop8o4bo93ijZ
         5BuQ==
X-Gm-Message-State: AOAM532y5xQNKz2lI1PYqUejm3GPgQgDA5qq99f31ddjwhtLqno5eJGU
        5/vX7DDY59Adz9m5mOx9cz0=
X-Google-Smtp-Source: ABdhPJya+ZautjadHl5y0UxotaFPIPROXEqF+OXYbVDEBrqR+KWp4LlzeUi9q9mNTNbm1sqpic/+4Q==
X-Received: by 2002:a17:90a:301:: with SMTP id 1mr5715894pje.86.1607736502490;
        Fri, 11 Dec 2020 17:28:22 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id l23sm11764759pgm.22.2020.12.11.17.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 17:28:21 -0800 (PST)
Subject: [net-next PATCH] tcp: Add logic to check for SYN w/ data in
 tcp_simple_retransmit
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        ycheng@google.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kafai@fb.com,
        kernel-team@fb.com
Date:   Fri, 11 Dec 2020 17:28:19 -0800
Message-ID: <160773649920.2387.14668844101686155199.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

There are cases where a fastopen SYN may trigger either a ICMP_TOOBIG
message in the case of IPv6 or a fragmentation request in the case of
IPv4. This results in the socket stalling for a second or more as it does
not respond to the message by retransmitting the SYN frame.

Normally a SYN frame should not be able to trigger a ICMP_TOOBIG or
ICMP_FRAG_NEEDED however in the case of fastopen we can have a frame that
makes use of the entire MSS. In the case of fastopen it does, and an
additional complication is that the retransmit queue doesn't contain the
original frames. As a result when tcp_simple_retransmit is called and
walks the list of frames in the queue it may not mark the frames as lost
because both the SYN and the data packet each individually are smaller than
the MSS size after the adjustment. This results in the socket being stalled
until the retransmit timer kicks in and forces the SYN frame out again
without the data attached.

In order to resolve this we can generate our best estimate for the original
packet size by detecting the fastopen SYN frame and then adding the
overhead for MAX_TCP_OPTION_SPACE and verifying if the SYN w/ data would
have exceeded the MSS. If so we can mark the frame as lost and retransmit
it.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 net/ipv4/tcp_input.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9e8a6c1aa019..79375b58de84 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2686,11 +2686,35 @@ static void tcp_mtup_probe_success(struct sock *sk)
 void tcp_simple_retransmit(struct sock *sk)
 {
 	const struct inet_connection_sock *icsk = inet_csk(sk);
+	struct sk_buff *skb = tcp_rtx_queue_head(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
-	struct sk_buff *skb;
-	unsigned int mss = tcp_current_mss(sk);
+	unsigned int mss;
+
+	/* A fastopen SYN request is stored as two separate packets within
+	 * the retransmit queue, this is done by tcp_send_syn_data().
+	 * As a result simply checking the MSS of the frames in the queue
+	 * will not work for the SYN packet. So instead we must make a best
+	 * effort attempt by validating the data frame with the mss size
+	 * that would be computed now by tcp_send_syn_data and comparing
+	 * that against the data frame that would have been included with
+	 * the SYN.
+	 */
+	if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN && tp->syn_data) {
+		struct sk_buff *syn_data = skb_rb_next(skb);
+
+		mss = tcp_mtu_to_mss(sk, icsk->icsk_pmtu_cookie) +
+		      tp->tcp_header_len - sizeof(struct tcphdr) -
+		      MAX_TCP_OPTION_SPACE;
 
-	skb_rbtree_walk(skb, &sk->tcp_rtx_queue) {
+		if (syn_data && syn_data->len > mss)
+			tcp_mark_skb_lost(sk, skb);
+
+		skb = syn_data;
+	} else {
+		mss = tcp_current_mss(sk);
+	}
+
+	skb_rbtree_walk_from(skb) {
 		if (tcp_skb_seglen(skb) > mss)
 			tcp_mark_skb_lost(sk, skb);
 	}


