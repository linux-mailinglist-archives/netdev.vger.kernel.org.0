Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF152621EF
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 23:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgIHV3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 17:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgIHV3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 17:29:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48544C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 14:29:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v3so408847ybb.22
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 14:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=JCqQvADuzCwutYreVJR8w/9wOOJud5Wrr6GetaxH47s=;
        b=tmC/E8D1sQjt8ZZVTIZLr3aSk2px9LLOul5ZK5SE+wxRZ5RGvCDy2rIYh20+tATWvZ
         EbEnaMxVreonGxTucXcqYzBrw5AVigTrbH24wCLmJHY9W3RCG56FDSzdJtkuvmTNRS4y
         hczjLm/UWHHrBfxTiM84kloiRT+UjOe+y5FCae2WaRxi3S5Nw6MA7GUkIMSyxt/NsyBg
         PEDBLm09LxF1Zlbk4/KAEW+EVK+uZddtdIuRJylKHIpc0kxDf2CBlroDEuj88+58mKYL
         2GJlC3tBYP0CO8Y6fnv5ytBQEixQsrxAcpVOwhzMnAQVhrAy6VZCFkxpaD0csIlg9u3Q
         2AnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=JCqQvADuzCwutYreVJR8w/9wOOJud5Wrr6GetaxH47s=;
        b=QyrN5V8t9fZXa2d0y20vk0Xj4JwLG9ahRLhIry/3KCYYI5PadV1yQv6O4kP1BN3/w2
         Z4I/sA+ILWQQYKia1Xcz0jqL3Zg8XbylE4WSYY8SZhe3EaZpEHTmc9VbPGI7PNzk0Nfu
         D5kzx2y6KK84euhSPLW/VkWHaW9GCmwV859XOxJGrUSVacjnTEP05oME+9jOT/RVtMZF
         gL1y24fAdkCXlxETjuH/EpdENdPwPDH3GOf+JB1qv0XJIKAC7YX7b2uxpR3cBgWmbP0e
         XS16QjFGbMa6KZzWapl8LutjkG+kKCi4f6sjcvIUgoo+VETG0vO0gqPZ1YSdSuEcV7ES
         QQvQ==
X-Gm-Message-State: AOAM5315PhEqts/5HNOmeiEKpJYIm7XEoQZrNhbZ4JzoxahByyHAXfmw
        vy4waHqF4vQ6j5cXDvjb+1Sw+NO3WM4=
X-Google-Smtp-Source: ABdhPJyspW9K4JvlFdnMZn5JhooY1GiGSWZIuPqvH568rkWZjzfm8FvTuvsT7bigPbrmapYV1tvY7E5sDRw=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a25:9c87:: with SMTP id y7mr1479189ybo.18.1599600570466;
 Tue, 08 Sep 2020 14:29:30 -0700 (PDT)
Date:   Tue,  8 Sep 2020 14:29:02 -0700
Message-Id: <20200908212902.3525935-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net-next] ipv6: add tos reflection in TCP reset and ack
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wei Wang <weiwan@google.com>, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, ipv6 stack does not do any TOS reflection. To make the
behavior consistent with v4 stack, this commit adds TOS reflection in
tcp_v6_reqsk_send_ack() and tcp_v6_send_reset(). We clear the lower
2-bit ECN value of the received TOS in compliance with RFC 3168 6.1.5
robustness principles.

Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/tcp_ipv6.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 87a633e1fbef..04efa3ee80ef 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -959,8 +959,8 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(buff, dst);
-		ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL, tclass,
-			 priority);
+		ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL,
+			 tclass & ~INET_ECN_MASK, priority);
 		TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 		if (rst)
 			TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
@@ -1068,8 +1068,8 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 			label = ip6_flowlabel(ipv6h);
 	}
 
-	tcp_v6_send_response(sk, skb, seq, ack_seq, 0, 0, 0, oif, key, 1, 0,
-			     label, priority);
+	tcp_v6_send_response(sk, skb, seq, ack_seq, 0, 0, 0, oif, key, 1,
+			     ipv6_get_dsfield(ipv6h), label, priority);
 
 #ifdef CONFIG_TCP_MD5SIG
 out:
@@ -1122,7 +1122,7 @@ static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			tcp_time_stamp_raw() + tcp_rsk(req)->ts_off,
 			req->ts_recent, sk->sk_bound_dev_if,
 			tcp_v6_md5_do_lookup(sk, &ipv6_hdr(skb)->saddr, l3index),
-			0, 0, sk->sk_priority);
+			ipv6_get_dsfield(ipv6_hdr(skb)), 0, sk->sk_priority);
 }
 
 
-- 
2.28.0.526.ge36021eeef-goog

