Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD907184C0
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 07:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbfEIFNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 01:13:49 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45524 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbfEIFNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 01:13:49 -0400
Received: by mail-lj1-f193.google.com with SMTP id r76so816712lja.12
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 22:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ziFPAPis9UqEKW8aSnfoIiAF+SVzl0wIceTxI4Vz1n4=;
        b=UTRqvsMzZAr/sI+sy91rspoTSWo1uLBhbiQc+0wo/iIchS4ur9+55jEI1fn2FUWKhH
         pkYsfk2jsQc1jv6sti73A9DRTU1ls+sBKbarvANSZGlfzq5+r1PiHTONXNe77QE/OMo1
         pNbYpDhU/UfnF+MSuNuq5/DE8dvOlYIWkzk1APAiOHvtArPOAA+kNoB+f1ECmECtJ2/5
         ja8zlyVd5KYMMke8me8YPVPhUpsX7iDWR+RzYtFS2dAmCFvB7tsZQK1wQOqqgd7I0H0M
         ePozo/9cMrr9Wirvz0I1cxE8eQZoIayulmIFL8gB2vjW1OXD4lFzEDu5sSsztWDCD+7C
         kUUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ziFPAPis9UqEKW8aSnfoIiAF+SVzl0wIceTxI4Vz1n4=;
        b=P6BsQZLx82vD8ZBCGtmovcdUOJJHu4CKA4SfqWVfZCpMfGQSWfjmc/nqC6+fSGUKhy
         OFj8K+O0ZD/LGXp9ZpE9aZHmIBd9IxrUFymV1fhChE5Ep0KB5lOfH2mw9Zg5qQlbMJFS
         Pk60X//wda+ThUewb6XRh7FN1rBuJwtq1NkPUYB785x7xKv1tTuo4A1y0pRnprpQeM0K
         5qPjIV/YoaYSVdOpuqsiphE+j6iOuTLMFSHmERDA0yUpDtlK2y5jyLxk1T9n2Jkz+xbP
         +ohoPTdtQatMk5VMUEre4jmXjHW5xUr79xtCGkuKkgDA6TNKl5FB/gYTx1Aph6Fw/0Zi
         ha1g==
X-Gm-Message-State: APjAAAUSeWQDLD3Nh6WUNuTyNMq5M2wLELAtjbt9MwSWhcqSd/KWkV2n
        DefgnpxCU9uZbPPfKA3Jgy0=
X-Google-Smtp-Source: APXvYqz+Ok450GFVVm5HeiWKCEeRbGAX69U18Qw4Ov7scTUJcUtII2Zvfmgw7ov7f5MexjyJYDwFYg==
X-Received: by 2002:a2e:2191:: with SMTP id h17mr939855lji.40.1557378827169;
        Wed, 08 May 2019 22:13:47 -0700 (PDT)
Received: from partha-pc.edgeware.tv (94.127.35.102.c.fiberdirekt.net. [94.127.35.102])
        by smtp.gmail.com with ESMTPSA id 17sm137623lji.2.2019.05.08.22.13.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 22:13:46 -0700 (PDT)
From:   Parthasarathy Bhuvaragan <parthasarathy.bhuvaragan@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     jon.maloy@ericsson.com, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net,
        Parthasarathy Bhuvaragan <parthasarathy.bhuvaragan@gmail.com>,
        Jon Maloy <jon.maloy@ericsson.se>
Subject: [PATCH net v1] tipc: fix hanging clients using poll with EPOLLOUT flag
Date:   Thu,  9 May 2019 07:13:42 +0200
Message-Id: <20190509051342.6187-1-parthasarathy.bhuvaragan@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 517d7c79bdb398 ("tipc: fix hanging poll() for stream sockets")
introduced a regression for clients using non-blocking sockets.
After the commit, we send EPOLLOUT event to the client even in
TIPC_CONNECTING state. This causes the subsequent send() to fail
with ENOTCONN, as the socket is still not in TIPC_ESTABLISHED state.

In this commit, we:
- improve the fix for hanging poll() by replacing sk_data_ready()
  with sk_state_change() to wake up all clients.
- revert the faulty updates introduced by commit 517d7c79bdb398
  ("tipc: fix hanging poll() for stream sockets").

Fixes: 517d7c79bdb398 ("tipc: fix hanging poll() for stream sockets")
Signed-off-by: Parthasarathy Bhuvaragan <parthasarathy.bhuvaragan@gmail.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.se>
---
 net/tipc/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index b542f14ed444..2851937f6e32 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -734,11 +734,11 @@ static __poll_t tipc_poll(struct file *file, struct socket *sock,
 
 	switch (sk->sk_state) {
 	case TIPC_ESTABLISHED:
-	case TIPC_CONNECTING:
 		if (!tsk->cong_link_cnt && !tsk_conn_cong(tsk))
 			revents |= EPOLLOUT;
 		/* fall through */
 	case TIPC_LISTEN:
+	case TIPC_CONNECTING:
 		if (!skb_queue_empty(&sk->sk_receive_queue))
 			revents |= EPOLLIN | EPOLLRDNORM;
 		break;
@@ -2041,7 +2041,7 @@ static bool tipc_sk_filter_connect(struct tipc_sock *tsk, struct sk_buff *skb)
 			if (msg_data_sz(hdr))
 				return true;
 			/* Empty ACK-, - wake up sleeping connect() and drop */
-			sk->sk_data_ready(sk);
+			sk->sk_state_change(sk);
 			msg_set_dest_droppable(hdr, 1);
 			return false;
 		}
-- 
2.21.0

