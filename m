Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6862113FB
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 22:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgGAUAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 16:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgGAUAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 16:00:10 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24979C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 13:00:10 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id i3so19418724qtq.13
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 13:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z2AYLqZe7+oeO9500TGvgS5SEDobRRoBjbq0iP77qKw=;
        b=XoCVPQpFfttccwINgy2qm/AI9YAw+P6Wx3eVmypHyOS8dr5jYh96/IqUm7xdOWiNsF
         4fmP/HZTaav2AsNqKgPAYSbzv1mjLHEIJzaTR0dk1Spnoz3Xf/8t4SyoAULHLunOALhy
         cEE3XOEq94qiv+OXuhGELhOp13S8H9DLy462vKpDCfvtGhPJtsGtm4AjLgmxL2x5tZMr
         HdLbKiSjO0M/f1O4TQFCD111iOn7t1pLAaMPHkCsNLUNDMMy3CoL7yaHmyyFmWj7Fy8D
         FojY+3Ou1z6d64A20lEdFoesCeQXmm6TwpueMiyaMMh+ElSylXOXcQnkpTpNQPXlgc/z
         tT+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z2AYLqZe7+oeO9500TGvgS5SEDobRRoBjbq0iP77qKw=;
        b=mb7Ot9nTU/Gewh21Bz4hLKgdc8uzEOAg87kH1XLbop7kM5jMH2TL+T/QU+2XC3MJJ0
         uMoyyhJfRF6CxXO5+B6VNLiovbbF7Kbun53FaPH0+r882wmDh/LSZxo1+eStWW+MnuOJ
         apAz4oQtWt0EqtSXJFzpdPpkLOY96rP+wIO/aQNTJ6jLJSUy/ATlaifCbaWaEU8dNVb3
         tOPmIEGpi0QSKAO48Ze0B+oWxtHUijHMHpFmuuY1YkGssBSikjZVKk1oP3PmjhAdkeDE
         20Q82ocynCsWMSag056e2kiGQQLT+ctCogGmbhBaPv0QX46hbplXKM7Pd6iWkTOsaZ/+
         2Phw==
X-Gm-Message-State: AOAM532CDMz8BT4Tx99nc06bFdC9O0EeCSmoJKvzQPuDoLQkB2O5YVVt
        R5QfddcCw9q6+OhiZVAaNuW+SlU6
X-Google-Smtp-Source: ABdhPJxQrpGX04nORuKT0Xkc/oOHWjVcV4GtqpuWHg62In2JGn8kr46dhQ119uKE6CWiYBHpUMlrTQ==
X-Received: by 2002:ac8:748a:: with SMTP id v10mr24027006qtq.19.1593633608835;
        Wed, 01 Jul 2020 13:00:08 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id v62sm1828872qkb.81.2020.07.01.13.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 13:00:08 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kafai@fb.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] ip: Fix SO_MARK in RST, ACK and ICMP packets
Date:   Wed,  1 Jul 2020 16:00:06 -0400
Message-Id: <20200701200006.2414835-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

When no full socket is available, skbs are sent over a per-netns
control socket. Its sk_mark is temporarily adjusted to match that
of the real (request or timewait) socket or to reflect an incoming
skb, so that the outgoing skb inherits this in __ip_make_skb.

Introduction of the socket cookie mark field broke this. Now the
skb is set through the cookie and cork:

<caller>		# init sockc.mark from sk_mark or cmsg
ip_append_data
  ip_setup_cork		# convert sockc.mark to cork mark
ip_push_pending_frames
  ip_finish_skb
    __ip_make_skb	# set skb->mark to cork mark

But I missed these special control sockets. Update all callers of
__ip(6)_make_skb that were originally missed.

For IPv6, the same two icmp(v6) paths are affected. The third
case is not, as commit 92e55f412cff ("tcp: don't annotate
mark on control socket from tcp_v6_send_response()") replaced
the ctl_sk->sk_mark with passing the mark field directly as a
function argument. That commit predates the commit that
introduced the bug.

Fixes: c6af0c227a22 ("ip: support SO_MARK cmsg")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reported-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/icmp.c      | 4 ++--
 net/ipv4/ip_output.c | 2 +-
 net/ipv6/icmp.c      | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 956a806649f7..e30515f89802 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -427,7 +427,7 @@ static void icmp_reply(struct icmp_bxm *icmp_param, struct sk_buff *skb)
 
 	ipcm_init(&ipc);
 	inet->tos = ip_hdr(skb)->tos;
-	sk->sk_mark = mark;
+	ipc.sockc.mark = mark;
 	daddr = ipc.addr = ip_hdr(skb)->saddr;
 	saddr = fib_compute_spec_dst(skb);
 
@@ -710,10 +710,10 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 	icmp_param.skb	  = skb_in;
 	icmp_param.offset = skb_network_offset(skb_in);
 	inet_sk(sk)->tos = tos;
-	sk->sk_mark = mark;
 	ipcm_init(&ipc);
 	ipc.addr = iph->saddr;
 	ipc.opt = &icmp_param.replyopts.opt;
+	ipc.sockc.mark = mark;
 
 	rt = icmp_route_lookup(net, &fl4, skb_in, iph, saddr, tos, mark,
 			       type, code, &icmp_param);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 090d3097ee15..17206677d503 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1702,7 +1702,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 	sk->sk_protocol = ip_hdr(skb)->protocol;
 	sk->sk_bound_dev_if = arg->bound_dev_if;
 	sk->sk_sndbuf = sysctl_wmem_default;
-	sk->sk_mark = fl4.flowi4_mark;
+	ipc.sockc.mark = fl4.flowi4_mark;
 	err = ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base,
 			     len, 0, &ipc, &rt, MSG_DONTWAIT);
 	if (unlikely(err)) {
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index fc5000370030..9df8737ae0d3 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -566,7 +566,6 @@ static void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 	fl6.mp_hash = rt6_multipath_hash(net, &fl6, skb, NULL);
 	security_skb_classify_flow(skb, flowi6_to_flowi(&fl6));
 
-	sk->sk_mark = mark;
 	np = inet6_sk(sk);
 
 	if (!icmpv6_xrlim_allow(sk, type, &fl6))
@@ -583,6 +582,7 @@ static void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 		fl6.flowi6_oif = np->ucast_oif;
 
 	ipcm6_init_sk(&ipc6, np);
+	ipc6.sockc.mark = mark;
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
 	dst = icmpv6_route_lookup(net, skb, sk, &fl6);
@@ -751,7 +751,6 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	sk = icmpv6_xmit_lock(net);
 	if (!sk)
 		goto out_bh_enable;
-	sk->sk_mark = mark;
 	np = inet6_sk(sk);
 
 	if (!fl6.flowi6_oif && ipv6_addr_is_multicast(&fl6.daddr))
@@ -779,6 +778,7 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	ipcm6_init_sk(&ipc6, np);
 	ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
 	ipc6.tclass = ipv6_get_dsfield(ipv6_hdr(skb));
+	ipc6.sockc.mark = mark;
 
 	if (ip6_append_data(sk, icmpv6_getfrag, &msg,
 			    skb->len + sizeof(struct icmp6hdr),
-- 
2.27.0.212.ge8ba1cc988-goog

