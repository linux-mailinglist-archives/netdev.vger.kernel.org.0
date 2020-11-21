Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3772BBCCB
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 04:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgKUDrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 22:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgKUDrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 22:47:48 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F667C0613CF;
        Fri, 20 Nov 2020 19:47:48 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id i12so8810894qtj.0;
        Fri, 20 Nov 2020 19:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=OjtrnDz5pBQKChdFgy/uhtHZBB4JOLkyA/WpYevGjWo=;
        b=kam1e2PWrENckpMeGS7a0OAC3a1xolR7SDRd4z3UlWRdVPEwo2Vv+407kYhovlxWni
         tIjCJUO+9x63LNjdlmDVdCpEv8qZDIV2Bk/oh67fAcABWB8QJmhNSs3wgg280tA4Ks/1
         qvwTIyuowJVx9pf1jmboCzzvZfNPvvtdNsywS/0IWcAJkK1ZwHjcRdltChWYt1fHSfPq
         gu9L+sVu5sLWq+OG0W0X6m2u6KBf/KZLCJt7aZ8FuF7OcKrkAQsRDzrHhy830nnEQBQo
         Vw8NcpKTEDRFSN9eGoheiSYighjZhoU0f16OA545HZLdI/XfaphMPO996/6oKSV+IDsb
         NwFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=OjtrnDz5pBQKChdFgy/uhtHZBB4JOLkyA/WpYevGjWo=;
        b=lwHUBR+PboE+i9+jLuZr/1yTwgl00I8MrMrZhwQzXDcqapUP6TT3LvIKDVKvaqUbMN
         jDuzWUjiH2AQnp4J1ZOR0/1MwmmrOOEVpE6JB0xQk/N3nx2hgtGHRqi8i/seADF0V5vu
         ICKLubFir7poWNdujFu6E8ixKioKodoDq+rVwhEV6iXH4MCrSGLWQfAieMsHkedSH6fB
         K0Isol2e2yb9p5Lnv9dnJe6qjPiDZUyb+P1xa2AbALPB2qAtzC77v5iZQ+NNPVIcU55r
         jbCnITO+/hDnO8TDwZ+stjCaPj6ZRFqRWP7Nuoth/l2potly4ZGLJk3K0qwg5MDViaOY
         lBMw==
X-Gm-Message-State: AOAM532ATNDZXPRzxyDs8FgtfB77n/uR8m08pMLFwB0oPcuCZ4B2+jbT
        C2YlYzsuNnF0RR1956VErZY=
X-Google-Smtp-Source: ABdhPJw/YspS/LeeHsaXCUUAlosXVb9su95oJK+WPwnXgf6queWpcuPJiHzAtZkfWXNUB61NoW8lcw==
X-Received: by 2002:ac8:5649:: with SMTP id 9mr18426812qtt.379.1605930467253;
        Fri, 20 Nov 2020 19:47:47 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id l22sm3507326qke.118.2020.11.20.19.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 19:47:46 -0800 (PST)
Subject: [net PATCH] tcp: Set ECT0 bit in tos/tclass for synack when BPF needs
 ECN
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, kafai@fb.com,
        kernel-team@fb.com, edumazet@google.com, brakmo@fb.com,
        alexanderduyck@fb.com
Date:   Fri, 20 Nov 2020 19:47:44 -0800
Message-ID: <160593039663.2604.1374502006916871573.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

When a BPF program is used to select between a type of TCP congestion
control algorithm that uses either ECN or not there is a case where the
synack for the frame was coming up without the ECT0 bit set. A bit of
research found that this was due to the final socket being configured to
dctcp while the listener socket was staying in cubic.

To reproduce it all that is needed is to monitor TCP traffic while running
the sample bpf program "samples/bpf/tcp_cong_kern.c". What is observed,
assuming tcp_dctcp module is loaded or compiled in and the traffic matches
the rules in the sample file, is that for all frames with the exception of
the synack the ECT0 bit is set.

To address that it is necessary to make one additional call to
tcp_bpf_ca_needs_ecn using the request socket and then use the output of
that to set the ECT0 bit for the tos/tclass of the packet.

Fixes: 91b5b21c7c16 ("bpf: Add support for changing congestion control")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 net/ipv4/tcp_ipv4.c |   12 ++++++++----
 net/ipv6/tcp_ipv6.c |    9 +++++++--
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index c5f8b686aa82..d20d779b18f3 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -980,13 +980,17 @@ static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
 
 	skb = tcp_make_synack(sk, dst, req, foc, synack_type, syn_skb);
 
-	tos = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
-			tcp_rsk(req)->syn_tos & ~INET_ECN_MASK :
-			inet_sk(sk)->tos;
-
 	if (skb) {
 		__tcp_v4_send_check(skb, ireq->ir_loc_addr, ireq->ir_rmt_addr);
 
+		tos = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
+				tcp_rsk(req)->syn_tos & ~INET_ECN_MASK :
+				inet_sk(sk)->tos;
+
+		if (!INET_ECN_is_capable(tos) &&
+		    tcp_bpf_ca_needs_ecn((struct sock *)req))
+			tos |= INET_ECN_ECT_0;
+
 		rcu_read_lock();
 		err = ip_build_and_send_pkt(skb, sk, ireq->ir_loc_addr,
 					    ireq->ir_rmt_addr,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 3d49e8d0afee..e2b360e9bec4 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -527,11 +527,16 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 		if (np->repflow && ireq->pktopts)
 			fl6->flowlabel = ip6_flowlabel(ipv6_hdr(ireq->pktopts));
 
-		rcu_read_lock();
-		opt = ireq->ipv6_opt;
 		tclass = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
 				tcp_rsk(req)->syn_tos & ~INET_ECN_MASK :
 				np->tclass;
+
+		if (!INET_ECN_is_capable(tclass) &&
+		    tcp_bpf_ca_needs_ecn((struct sock *)req))
+			tclass |= INET_ECN_ECT_0;
+
+		rcu_read_lock();
+		opt = ireq->ipv6_opt;
 		if (!opt)
 			opt = rcu_dereference(np->opt);
 		err = ip6_xmit(sk, skb, fl6, sk->sk_mark, opt,


