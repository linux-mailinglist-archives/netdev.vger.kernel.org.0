Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09903353C28
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 09:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbhDEHHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 03:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhDEHHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 03:07:07 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D7BC061756
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 00:07:01 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q10so7592899pgj.2
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 00:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wmNdKTcqG9F0uqO6s49Xz7s10PBgTm5zewutxoY2oGM=;
        b=sjkagA184bjGS5DfXdi9cDqXrTQHE80hoPUh9nAVs77mtWLXZLOpl17vvg9ooHUxOt
         T42kSr5K2vG7hPW1dPeX2X0I1tJh+JELxg3QNL+xAq6Bru/DHrF98dr5TGXhjpdmboGV
         atssFPZTW3peDZwl6PMRLO+p+nNi8iLJSedO3WAZ2OpDYVn5++Jkucyybj7GOeZlsoRk
         S6vdgnyM8f6WJJ/o9ZSc3t04ECFs4yf1AQ9XlmBJl0uPTIvFm/hFlv00PQluorsus6XG
         sTEbqwDPNjpyhsKk8SBcNnN4MSxIP8Fxk/8ulJVhSi7fwf9/wcwpQJjrQCqE2ca7q8iJ
         2uFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wmNdKTcqG9F0uqO6s49Xz7s10PBgTm5zewutxoY2oGM=;
        b=CKpU8gjN+RnA9UeyKfIIcLVa0VlJj9XZ5M2/B4LGwweq8tt/DeQTYEmTbfw5dAO60Y
         a9Jc+WuBhwNkdwhT0yrohAk1FbRD2H4GP5mBthYdOrylK9EfnZQrcIvBQ+ficHP+3s0L
         4Aa+65nFW0VQ91S/ZcTrRGeUQ9s3z9gsQ6YbQ68/Nv/Ih7VShsCpH7ROyqEPT5g2cpSJ
         WXWXtgzeT7Y9zcYyeYx1DtnPy/d/lirIgGHgCuSIb95Uzc+F85nxjW3Dr0yICfyI6R7E
         DOZp1VC3vM6TTqdUIxJzH03mDdICN//fjmxWORsWwfQByF6BdBSMqSc1qYgrEDbFyixy
         MkGQ==
X-Gm-Message-State: AOAM531sYNpL48DwaOjhc1hCgxKjqjG2Xq6joddCK/+A7kVAn8bzrQlE
        Qcl5hK8XdHCONM19/bTnQlo=
X-Google-Smtp-Source: ABdhPJxGQODBU/m7CUnJuvTzLbEl6OoXRQ0UB00/IV+aiLE8wIEoaUh3+OD9LZXclZtiPfUK7Ajtrg==
X-Received: by 2002:a62:33c6:0:b029:225:5266:28df with SMTP id z189-20020a6233c60000b0290225526628dfmr22035849pfz.7.1617606420892;
        Mon, 05 Apr 2021 00:07:00 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:7c09:9a81:b829:6f7f])
        by smtp.gmail.com with ESMTPSA id a6sm15096859pfc.61.2021.04.05.00.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 00:07:00 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH] net-ipv6: bugfix - raw & sctp - switch to ipv6_can_nonlocal_bind()
Date:   Mon,  5 Apr 2021 00:06:52 -0700
Message-Id: <20210405070652.2447152-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Found by virtue of ipv6 raw sockets not honouring the per-socket
IP{,V6}_FREEBIND setting.

Based on hits found via:
  git grep '[.]ip_nonlocal_bind'
We fix both raw ipv6 sockets to honour IP{,V6}_FREEBIND and IP{,V6}_TRANSPARENT,
and we fix sctp sockets to honour IP{,V6}_TRANSPARENT (they already honoured
FREEBIND), and not just the ipv6 'ip_nonlocal_bind' sysctl.

The helper is defined as:
  static inline bool ipv6_can_nonlocal_bind(struct net *net, struct inet_sock *inet) {
    return net->ipv6.sysctl.ip_nonlocal_bind || inet->freebind || inet->transparent;
  }
so this change only widens the accepted opt-outs and is thus a clean bugfix.

I'm not entirely sure what 'fixes' tag to add, since this is AFAICT an ancient bug,
but IMHO this should be applied to stable kernels as far back as possible.
As such I'm adding a 'fixes' tag with the commit that originally added the helper,
which happened in 4.19.  Backporting to older LTS kernels (at least 4.9 and 4.14)
would presumably require open-coding it or backporting the helper as well.

Other possibly relevant commits:
  v4.18-rc6-1502-g83ba4645152d net: add helpers checking if socket can be bound to nonlocal address
  v4.18-rc6-1431-gd0c1f01138c4 net/ipv6: allow any source address for sendmsg pktinfo with ip_nonlocal_bind
  v4.14-rc5-271-gb71d21c274ef sctp: full support for ipv6 ip_nonlocal_bind & IP_FREEBIND
  v4.7-rc7-1883-g9b9742022888 sctp: support ipv6 nonlocal bind
  v4.1-12247-g35a256fee52c ipv6: Nonlocal bind

Cc: Lorenzo Colitti <lorenzo@google.com>
Fixes: 83ba4645152d ("net: add helpers checking if socket can be bound to nonlocal address")
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/ipv6/raw.c  | 2 +-
 net/sctp/ipv6.c | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 1f56d9aae589..bf3646b57c68 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -298,7 +298,7 @@ static int rawv6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 		 */
 		v4addr = LOOPBACK4_IPV6;
 		if (!(addr_type & IPV6_ADDR_MULTICAST) &&
-		    !sock_net(sk)->ipv6.sysctl.ip_nonlocal_bind) {
+		    !ipv6_can_nonlocal_bind(sock_net(sk), inet)) {
 			err = -EADDRNOTAVAIL;
 			if (!ipv6_chk_addr(sock_net(sk), &addr->sin6_addr,
 					   dev, 0)) {
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index c3e89c776e66..bd08807c9e44 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -664,8 +664,8 @@ static int sctp_v6_available(union sctp_addr *addr, struct sctp_sock *sp)
 	if (!(type & IPV6_ADDR_UNICAST))
 		return 0;
 
-	return sp->inet.freebind || net->ipv6.sysctl.ip_nonlocal_bind ||
-		ipv6_chk_addr(net, in6, NULL, 0);
+	return ipv6_can_nonlocal_bind(net, &sp->inet) ||
+	       ipv6_chk_addr(net, in6, NULL, 0);
 }
 
 /* This function checks if the address is a valid address to be used for
@@ -954,8 +954,7 @@ static int sctp_inet6_bind_verify(struct sctp_sock *opt, union sctp_addr *addr)
 			net = sock_net(&opt->inet.sk);
 			rcu_read_lock();
 			dev = dev_get_by_index_rcu(net, addr->v6.sin6_scope_id);
-			if (!dev || !(opt->inet.freebind ||
-				      net->ipv6.sysctl.ip_nonlocal_bind ||
+			if (!dev || !(ipv6_can_nonlocal_bind(net, &opt->inet) ||
 				      ipv6_chk_addr(net, &addr->v6.sin6_addr,
 						    dev, 0))) {
 				rcu_read_unlock();
-- 
2.31.0.208.g409f899ff0-goog

