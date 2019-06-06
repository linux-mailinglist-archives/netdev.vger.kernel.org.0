Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D64036D3D
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 09:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfFFHVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 03:21:37 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:59638 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFFHVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 03:21:36 -0400
Received: from glumotte.dev.6wind.com. (unknown [10.16.0.195])
        by proxy.6wind.com (Postfix) with ESMTP id C455F2C603A;
        Thu,  6 Jun 2019 09:15:39 +0200 (CEST)
From:   Olivier Matz <olivier.matz@6wind.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: [PATCH net 1/2] ipv6: use READ_ONCE() for inet->hdrincl as in ipv4
Date:   Thu,  6 Jun 2019 09:15:18 +0200
Message-Id: <20190606071519.5841-2-olivier.matz@6wind.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190606071519.5841-1-olivier.matz@6wind.com>
References: <20190606071519.5841-1-olivier.matz@6wind.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it was done in commit 8f659a03a0ba ("net: ipv4: fix for a race
condition in raw_sendmsg") and commit 20b50d79974e ("net: ipv4: emulate
READ_ONCE() on ->hdrincl bit-field in raw_sendmsg()") for ipv4, copy the
value of inet->hdrincl in a local variable, to avoid introducing a race
condition in the next commit.

Signed-off-by: Olivier Matz <olivier.matz@6wind.com>
---
 net/ipv6/raw.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 96a3559f2a09..af2f9a833c4e 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -783,6 +783,7 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct flowi6 fl6;
 	struct ipcm6_cookie ipc6;
 	int addr_len = msg->msg_namelen;
+	int hdrincl;
 	u16 proto;
 	int err;
 
@@ -796,6 +797,13 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (msg->msg_flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
+	/* hdrincl should be READ_ONCE(inet->hdrincl)
+	 * but READ_ONCE() doesn't work with bit fields.
+	 * Doing this indirectly yields the same result.
+	 */
+	hdrincl = inet->hdrincl;
+	hdrincl = READ_ONCE(hdrincl);
+
 	/*
 	 *	Get and verify the address.
 	 */
@@ -908,7 +916,7 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		fl6.flowi6_oif = np->ucast_oif;
 	security_sk_classify_flow(sk, flowi6_to_flowi(&fl6));
 
-	if (inet->hdrincl)
+	if (hdrincl)
 		fl6.flowi6_flags |= FLOWI_FLAG_KNOWN_NH;
 
 	if (ipc6.tclass < 0)
@@ -931,7 +939,7 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		goto do_confirm;
 
 back_from_confirm:
-	if (inet->hdrincl)
+	if (hdrincl)
 		err = rawv6_send_hdrinc(sk, msg, len, &fl6, &dst,
 					msg->msg_flags, &ipc6.sockc);
 	else {
-- 
2.11.0

