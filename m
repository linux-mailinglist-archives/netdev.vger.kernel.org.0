Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB20A43FFDA
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 17:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhJ2PyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 11:54:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhJ2PyH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 11:54:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22141610E8;
        Fri, 29 Oct 2021 15:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635522698;
        bh=LxH5sUi4SHna9mTlQxpZpMSawWP1QJy4K9+JfGIUpk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnO42VslFDrBDDTIfra7fSkaWjc9pxJSYaYa1ot43zs2125BufSCOhts8NuE4XEGi
         UCuvTIrcs93OKgzT+dzw0dS+V75r7rm6KVXbZMbMRs+9b2351BBS4mng59kwvcBJIq
         xGodcO8aBF8IHn5G5VyPWKkvVD9bgnj8y9NH/KkukdafcbFugkImM7+F8FzBwUfJY3
         9MHM/wwyxLaruKx6ixcDJHKCkYQKnWE2GBPw52+PGbc2bOWeHIW8apt6dSkxKRiBA9
         AorxxBkvohO0R/bbG4YKLVQ8f0KxZRXoDu4GHz32bL8w30d7LFoRlvasssTeBLVA1r
         JwrXcWs95CDXA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, willemb@google.com
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Xintong Hu <huxintong@fb.com>
Subject: [PATCH net 1/2] udp6: allow SO_MARK ctrl msg to affect routing
Date:   Fri, 29 Oct 2021 08:51:34 -0700
Message-Id: <20211029155135.468098-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029155135.468098-1-kuba@kernel.org>
References: <20211029155135.468098-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit c6af0c227a22 ("ip: support SO_MARK cmsg")
added propagation of SO_MARK from cmsg to skb->mark.
For IPv4 and raw sockets the mark also affects route
lookup, but in case of IPv6 the flow info is
initialized before cmsg is parsed.

Fixes: c6af0c227a22 ("ip: support SO_MARK cmsg")
Reported-and-tested-by: Xintong Hu <huxintong@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv6/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 8d785232b479..be6dc64ece29 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1435,7 +1435,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (!fl6.flowi6_oif)
 		fl6.flowi6_oif = np->sticky_pktinfo.ipi6_ifindex;
 
-	fl6.flowi6_mark = ipc6.sockc.mark;
 	fl6.flowi6_uid = sk->sk_uid;
 
 	if (msg->msg_controllen) {
@@ -1471,6 +1470,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	ipc6.opt = opt;
 
 	fl6.flowi6_proto = sk->sk_protocol;
+	fl6.flowi6_mark = ipc6.sockc.mark;
 	fl6.daddr = *daddr;
 	if (ipv6_addr_any(&fl6.saddr) && !ipv6_addr_any(&np->saddr))
 		fl6.saddr = np->saddr;
-- 
2.31.1

