Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445AB4E466E
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 20:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiCVTFg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Mar 2022 15:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiCVTFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 15:05:34 -0400
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D075DE88
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 12:04:06 -0700 (PDT)
Date:   Tue, 22 Mar 2022 19:03:52 +0000
Authentication-Results: mail-4018.proton.ch; dkim=none
To:     netdev@vger.kernel.org
From:   Torin Carey <torin@tcarey.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Reply-To: Torin Carey <torin@tcarey.uk>
Subject: [PATCH] udp: change MSG_TRUNC return behaviour for MSG_PEEK in recvmsg
Message-ID: <YjodjXHN7j69h/kd@kappa>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make UDP recvmsg only return the MSG_TRUNC flag if the read does not
copy the tail end of the datagram.  Specifically, this targets MSG_PEEK
when we're using a positive peek offset.

The current behaviour means that if we have a positive peek offset `off`
and we're reading `r` bytes from a datagram of `ulen` length, we respond
with MSG_TRUNC if and only if `r <= ulen - off`.  This is odd behaviour
as we return MSG_TRUNC if the user requests exactly `ulen - off` which
has no truncation.

The behaviour could be corrected in two ways:

This patch returns MSG_TRUNC only for tail-end truncation and not head
truncation.  This is more consistent with recv(2):
> MSG_TRUNC
>     indicates that the trailing portion of a datagram was discarded
>     because the datagram was larger than the buffer supplied.
although this isn't written with SO_PEEK_OFF in mind.

The second option is to always return MSG_TRUNC if `off > 0` like the
man-pages socket(7) page states:
> For datagram sockets, if the "peek offset" points to the middle of a
> packet, the data returned will be marked with the MSG_TRUNC flag.

Signed-off-by: Torin Carey <torin@tcarey.uk>
---
 net/ipv4/udp.c | 2 +-
 net/ipv6/udp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 319dd7bbfe33..e57740a2c308 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1855,7 +1855,7 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 	copied = len;
 	if (copied > ulen - off)
 		copied = ulen - off;
-	else if (copied < ulen)
+	else if (copied < ulen - off)
 		msg->msg_flags |= MSG_TRUNC;

 	/*
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 14a94cddcf0b..d6c0eed94564 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -348,7 +348,7 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	copied = len;
 	if (copied > ulen - off)
 		copied = ulen - off;
-	else if (copied < ulen)
+	else if (copied < ulen - off)
 		msg->msg_flags |= MSG_TRUNC;

 	is_udp4 = (skb->protocol == htons(ETH_P_IP));
--
2.34.1


