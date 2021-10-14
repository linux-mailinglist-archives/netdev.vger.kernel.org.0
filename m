Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7E842D3F9
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 09:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhJNHq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 03:46:56 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:38630 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbhJNHq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 03:46:56 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id B32D020223; Thu, 14 Oct 2021 15:44:50 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH] mctp: Avoid leak of mctp_sk_key
Date:   Thu, 14 Oct 2021 15:44:28 +0800
Message-Id: <20211014074428.3007121-1-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mctp_key_alloc() returns a key already referenced.

The mctp_route_input() path receives a packet for a bind socket and
allocates a key. It passes the key to mctp_key_add() which takes a
refcount and adds the key to lists. mctp_route_input() should then
release its own refcount when setting the key pointer to NULL.

In the mctp_alloc_local_tag() path (for mctp_local_output()) we
similarly need to unref the key before returning (mctp_reserve_tag()
takes a refcount and adds the key to lists).

Fixes: 73c618456dc ("mctp: locking, lifetime and validity changes for sk_keys")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Reviewed-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/route.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 04781459b2be..82fb5ae524f6 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -372,6 +372,7 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 			trace_mctp_key_acquire(key);
 
 			/* we don't need to release key->lock on exit */
+			mctp_key_unref(key);
 			key = NULL;
 
 		} else {
@@ -584,6 +585,9 @@ static int mctp_alloc_local_tag(struct mctp_sock *msk,
 		trace_mctp_key_acquire(key);
 
 		*tagp = key->tag;
+		/* done with the key in this scope */
+		mctp_key_unref(key);
+		key = NULL;
 		rc = 0;
 	}
 
-- 
2.30.2

