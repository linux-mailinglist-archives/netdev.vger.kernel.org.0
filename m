Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E460C308244
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhA2ANJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhA2ANH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 19:13:07 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1016C061756
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 16:12:26 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id j12so5080556pfj.12
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 16:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netflix.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iL85OwvSHEEjPH/Ibd2Zyg0+w/6cazxndVl8cnT2uog=;
        b=k6tRyYQ5NmgR9Nn6vV6gp064uodQdmwaW5e04JQgWpHIcM8wWjtCkDf+89hEtvQO6W
         Yx17D/Of0TwsQoB2MUEwxu5I4UcKKBr4fGpIxMxaicydnKMVjQhTid/Rhr7A7weRlPmF
         /SNVvBZdLmE5oIE0+xhGLgjnfpemMadqIIltA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iL85OwvSHEEjPH/Ibd2Zyg0+w/6cazxndVl8cnT2uog=;
        b=rD1TVRxWPbZ/kZFp6iG53CYTPoyv2euXrIy9/XZYSl8TmDNAVsE9weir6LIeIdDpgP
         aWfahPl372j2CJoMoUBSFSXQJ6juMUxXVBtyRAAUYKhmsVebGt+PQb0DRdkz5t5XC+ri
         AYytTdooTfKngNwYpa/Dm6FaITpsM9dCvEtLMUgmneLEqn4nQGiS+B2rUq6juunrEanU
         LxhaqPBu9RL7/45jmp7z6GlEtVTL4BRNevQvg4jQ2vskkR7urKK3lhxw/w1rfo3axf+t
         Qd6VXFxpl3PhgFoeMsr73A1/1wIzot9QVcUsmnTpTwC+9LoxVEoZ8kxExTwfwrfuSbi/
         TgvA==
X-Gm-Message-State: AOAM532nxOC46ceVoRbx3zU0Vcqvy3cO17ID5v3o7wA+lWieTrp07Gi/
        bxonWhyFEzro147OCz17s92RyA==
X-Google-Smtp-Source: ABdhPJxm+gHQfTNfMPdvOLEDM93ijecQneN7x/ZaH/mAqGmFxB/NoKx0qlWQ8PMB/lPG4GLxReh8tw==
X-Received: by 2002:a63:a542:: with SMTP id r2mr1903715pgu.211.1611879145886;
        Thu, 28 Jan 2021 16:12:25 -0800 (PST)
Received: from localhost.localdomain (c-69-181-214-217.hsd1.ca.comcast.net. [69.181.214.217])
        by smtp.gmail.com with ESMTPSA id m4sm7093600pfa.53.2021.01.28.16.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 16:12:25 -0800 (PST)
From:   Hariharan Ananthakrishnan <hari@netflix.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Hariharan Ananthakrishnan <hari@netflix.com>
Subject: [PATCH] net: tracepoint: exposing sk_family in all tcp:tracepoints
Date:   Fri, 29 Jan 2021 00:12:10 +0000
Message-Id: <20210129001210.344438-1-hari@netflix.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to sock:inet_sock_set_state tracepoint, expose sk_family to
distinguish AF_INET and AF_INET6 families.

The following tcp tracepoints are updated:
tcp:tcp_destroy_sock
tcp:tcp_rcv_space_adjust
tcp:tcp_retransmit_skb
tcp:tcp_send_reset
tcp:tcp_receive_reset
tcp:tcp_retransmit_synack
tcp:tcp_probe

Signed-off-by: Hariharan Ananthakrishnan <hari@netflix.com>
Signed-off-by: Brendan Gregg <bgregg@netflix.com>
---
 include/trace/events/tcp.h | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index cf97f6339acb..a319d2f86cd9 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -59,6 +59,7 @@ DECLARE_EVENT_CLASS(tcp_event_sk_skb,
 		__field(int, state)
 		__field(__u16, sport)
 		__field(__u16, dport)
+		__field(__u16, family)
 		__array(__u8, saddr, 4)
 		__array(__u8, daddr, 4)
 		__array(__u8, saddr_v6, 16)
@@ -75,6 +76,7 @@ DECLARE_EVENT_CLASS(tcp_event_sk_skb,
 
 		__entry->sport = ntohs(inet->inet_sport);
 		__entry->dport = ntohs(inet->inet_dport);
+		__entry->family = sk->sk_family;
 
 		p32 = (__be32 *) __entry->saddr;
 		*p32 = inet->inet_saddr;
@@ -86,7 +88,8 @@ DECLARE_EVENT_CLASS(tcp_event_sk_skb,
 			      sk->sk_v6_rcv_saddr, sk->sk_v6_daddr);
 	),
 
-	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c state=%s",
+	TP_printk("family=%s sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c state=%s",
+		  show_family_name(__entry->family),
 		  __entry->sport, __entry->dport, __entry->saddr, __entry->daddr,
 		  __entry->saddr_v6, __entry->daddr_v6,
 		  show_tcp_state_name(__entry->state))
@@ -125,6 +128,7 @@ DECLARE_EVENT_CLASS(tcp_event_sk,
 		__field(const void *, skaddr)
 		__field(__u16, sport)
 		__field(__u16, dport)
+		__field(__u16, family)
 		__array(__u8, saddr, 4)
 		__array(__u8, daddr, 4)
 		__array(__u8, saddr_v6, 16)
@@ -140,6 +144,7 @@ DECLARE_EVENT_CLASS(tcp_event_sk,
 
 		__entry->sport = ntohs(inet->inet_sport);
 		__entry->dport = ntohs(inet->inet_dport);
+		__entry->family = sk->sk_family;
 
 		p32 = (__be32 *) __entry->saddr;
 		*p32 = inet->inet_saddr;
@@ -153,7 +158,8 @@ DECLARE_EVENT_CLASS(tcp_event_sk,
 		__entry->sock_cookie = sock_gen_cookie(sk);
 	),
 
-	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c sock_cookie=%llx",
+	TP_printk("family=%s sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c sock_cookie=%llx",
+		  show_family_name(__entry->family),
 		  __entry->sport, __entry->dport,
 		  __entry->saddr, __entry->daddr,
 		  __entry->saddr_v6, __entry->daddr_v6,
@@ -192,6 +198,7 @@ TRACE_EVENT(tcp_retransmit_synack,
 		__field(const void *, req)
 		__field(__u16, sport)
 		__field(__u16, dport)
+		__field(__u16, family)
 		__array(__u8, saddr, 4)
 		__array(__u8, daddr, 4)
 		__array(__u8, saddr_v6, 16)
@@ -207,6 +214,7 @@ TRACE_EVENT(tcp_retransmit_synack,
 
 		__entry->sport = ireq->ir_num;
 		__entry->dport = ntohs(ireq->ir_rmt_port);
+		__entry->family = sk->sk_family;
 
 		p32 = (__be32 *) __entry->saddr;
 		*p32 = ireq->ir_loc_addr;
@@ -218,7 +226,8 @@ TRACE_EVENT(tcp_retransmit_synack,
 			      ireq->ir_v6_loc_addr, ireq->ir_v6_rmt_addr);
 	),
 
-	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c",
+	TP_printk("family=%s sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c",
+	          show_family_name(__entry->family),
 		  __entry->sport, __entry->dport,
 		  __entry->saddr, __entry->daddr,
 		  __entry->saddr_v6, __entry->daddr_v6)
@@ -238,6 +247,7 @@ TRACE_EVENT(tcp_probe,
 		__array(__u8, daddr, sizeof(struct sockaddr_in6))
 		__field(__u16, sport)
 		__field(__u16, dport)
+		__field(__u16, family)
 		__field(__u32, mark)
 		__field(__u16, data_len)
 		__field(__u32, snd_nxt)
@@ -264,6 +274,7 @@ TRACE_EVENT(tcp_probe,
 		__entry->sport = ntohs(inet->inet_sport);
 		__entry->dport = ntohs(inet->inet_dport);
 		__entry->mark = skb->mark;
+		__entry->family = sk->sk_family;
 
 		__entry->data_len = skb->len - __tcp_hdrlen(th);
 		__entry->snd_nxt = tp->snd_nxt;
@@ -276,7 +287,8 @@ TRACE_EVENT(tcp_probe,
 		__entry->sock_cookie = sock_gen_cookie(sk);
 	),
 
-	TP_printk("src=%pISpc dest=%pISpc mark=%#x data_len=%d snd_nxt=%#x snd_una=%#x snd_cwnd=%u ssthresh=%u snd_wnd=%u srtt=%u rcv_wnd=%u sock_cookie=%llx",
+	TP_printk("family=%s src=%pISpc dest=%pISpc mark=%#x data_len=%d snd_nxt=%#x snd_una=%#x snd_cwnd=%u ssthresh=%u snd_wnd=%u srtt=%u rcv_wnd=%u sock_cookie=%llx",
+		  show_family_name(__entry->family),
 		  __entry->saddr, __entry->daddr, __entry->mark,
 		  __entry->data_len, __entry->snd_nxt, __entry->snd_una,
 		  __entry->snd_cwnd, __entry->ssthresh, __entry->snd_wnd,

base-commit: bbc20b70424aeb3c84f833860f6340adda5141fc
-- 
2.27.0

