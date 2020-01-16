Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE2D13F86B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732351AbgAPTSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:18:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729903AbgAPQyj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 696D220730;
        Thu, 16 Jan 2020 16:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193678;
        bh=XQKsPWErsPgbw5v5Rfqyy6rs8flD5VJUc1xLev5jRyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPPiu1fopwVhd3gvBYMlc1XvcK9J0TjuRsv6Q0tJOFPqTe0T26chZ4Abg7F3Rnj90
         9cNc2SkkkY6Y8ejhdwEGHQ/5p1hTNyxdYXaNgB8U9fcWIPEB9RwNJD4YDlJGmhNFzR
         q2Uuy2NDU8MdntCzUpVCViK57/ibrUQHbV0JPzRU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuong Lien <tuong.t.lien@dektech.com.au>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 202/205] tipc: fix retrans failure due to wrong destination
Date:   Thu, 16 Jan 2020 11:42:57 -0500
Message-Id: <20200116164300.6705-202-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>

[ Upstream commit abc9b4e0549b93fdaff56e9532bc49a2d7b04955 ]

When a user message is sent, TIPC will check if the socket has faced a
congestion at link layer. If that happens, it will make a sleep to wait
for the congestion to disappear. This leaves a gap for other users to
take over the socket (e.g. multi threads) since the socket is released
as well. Also, in case of connectionless (e.g. SOCK_RDM), user is free
to send messages to various destinations (e.g. via 'sendto()'), then
the socket's preformatted header has to be updated correspondingly
prior to the actual payload message building.

Unfortunately, the latter action is done before the first action which
causes a condition issue that the destination of a certain message can
be modified incorrectly in the middle, leading to wrong destination
when that message is built. Consequently, when the message is sent to
the link layer, it gets stuck there forever because the peer node will
simply reject it. After a number of retransmission attempts, the link
is eventually taken down and the retransmission failure is reported.

This commit fixes the problem by rearranging the order of actions to
prevent the race condition from occurring, so the message building is
'atomic' and its header will not be modified by anyone.

Fixes: 365ad353c256 ("tipc: reduce risk of user starvation during link congestion")
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/socket.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 90ace35dbf0f..aea951a1f805 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1306,8 +1306,8 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 	struct tipc_msg *hdr = &tsk->phdr;
 	struct tipc_name_seq *seq;
 	struct sk_buff_head pkts;
-	u32 dport, dnode = 0;
-	u32 type, inst;
+	u32 dport = 0, dnode = 0;
+	u32 type = 0, inst = 0;
 	int mtu, rc;
 
 	if (unlikely(dlen > TIPC_MAX_USER_MSG_SIZE))
@@ -1360,23 +1360,11 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 		type = dest->addr.name.name.type;
 		inst = dest->addr.name.name.instance;
 		dnode = dest->addr.name.domain;
-		msg_set_type(hdr, TIPC_NAMED_MSG);
-		msg_set_hdr_sz(hdr, NAMED_H_SIZE);
-		msg_set_nametype(hdr, type);
-		msg_set_nameinst(hdr, inst);
-		msg_set_lookup_scope(hdr, tipc_node2scope(dnode));
 		dport = tipc_nametbl_translate(net, type, inst, &dnode);
-		msg_set_destnode(hdr, dnode);
-		msg_set_destport(hdr, dport);
 		if (unlikely(!dport && !dnode))
 			return -EHOSTUNREACH;
 	} else if (dest->addrtype == TIPC_ADDR_ID) {
 		dnode = dest->addr.id.node;
-		msg_set_type(hdr, TIPC_DIRECT_MSG);
-		msg_set_lookup_scope(hdr, 0);
-		msg_set_destnode(hdr, dnode);
-		msg_set_destport(hdr, dest->addr.id.ref);
-		msg_set_hdr_sz(hdr, BASIC_H_SIZE);
 	} else {
 		return -EINVAL;
 	}
@@ -1387,6 +1375,22 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 	if (unlikely(rc))
 		return rc;
 
+	if (dest->addrtype == TIPC_ADDR_NAME) {
+		msg_set_type(hdr, TIPC_NAMED_MSG);
+		msg_set_hdr_sz(hdr, NAMED_H_SIZE);
+		msg_set_nametype(hdr, type);
+		msg_set_nameinst(hdr, inst);
+		msg_set_lookup_scope(hdr, tipc_node2scope(dnode));
+		msg_set_destnode(hdr, dnode);
+		msg_set_destport(hdr, dport);
+	} else { /* TIPC_ADDR_ID */
+		msg_set_type(hdr, TIPC_DIRECT_MSG);
+		msg_set_lookup_scope(hdr, 0);
+		msg_set_destnode(hdr, dnode);
+		msg_set_destport(hdr, dest->addr.id.ref);
+		msg_set_hdr_sz(hdr, BASIC_H_SIZE);
+	}
+
 	__skb_queue_head_init(&pkts);
 	mtu = tipc_node_get_mtu(net, dnode, tsk->portid);
 	rc = tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
-- 
2.20.1

