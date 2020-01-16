Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8DC13F5D4
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437218AbgAPS7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:59:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:37124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388960AbgAPRGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E9E32467C;
        Thu, 16 Jan 2020 17:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194397;
        bh=G119LmTMJv1Qr6TBvPOcR64ACHZ5QVcS4KzM4Z6mSc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ex/JPYY/T8U2o1oTjLQrXC6rojB2JJfZGsd3Cd6mf/SMGnCKFle8+DTyRAVdQBwF2
         4SxSWFSgeKzxtlqiVNlhD+egu5VW09kpbMO1gqW4wQcvvBn3ctlD2wM7o71eDOT2pH
         vU/KwdhcNaN0JCPhG+GjU+wH3gBmj1Oy9rEjSalU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>,
        David Laight <David.Laight@aculab.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 323/671] packet: in recvmsg msg_name return at least sizeof sockaddr_ll
Date:   Thu, 16 Jan 2020 11:59:21 -0500
Message-Id: <20200116170509.12787-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit b2cf86e1563e33a14a1c69b3e508d15dc12f804c ]

Packet send checks that msg_name is at least sizeof sockaddr_ll.
Packet recv must return at least this length, so that its output
can be passed unmodified to packet send.

This ceased to be true since adding support for lladdr longer than
sll_addr. Since, the return value uses true address length.

Always return at least sizeof sockaddr_ll, even if address length
is shorter. Zero the padding bytes.

Change v1->v2: do not overwrite zeroed padding again. use copy_len.

Fixes: 0fb375fb9b93 ("[AF_PACKET]: Allow for > 8 byte hardware addresses.")
Suggested-by: David Laight <David.Laight@aculab.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ac65e66d1d72..60ba18a4bb0f 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3371,20 +3371,29 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	sock_recv_ts_and_drops(msg, sk, skb);
 
 	if (msg->msg_name) {
+		int copy_len;
+
 		/* If the address length field is there to be filled
 		 * in, we fill it in now.
 		 */
 		if (sock->type == SOCK_PACKET) {
 			__sockaddr_check_size(sizeof(struct sockaddr_pkt));
 			msg->msg_namelen = sizeof(struct sockaddr_pkt);
+			copy_len = msg->msg_namelen;
 		} else {
 			struct sockaddr_ll *sll = &PACKET_SKB_CB(skb)->sa.ll;
 
 			msg->msg_namelen = sll->sll_halen +
 				offsetof(struct sockaddr_ll, sll_addr);
+			copy_len = msg->msg_namelen;
+			if (msg->msg_namelen < sizeof(struct sockaddr_ll)) {
+				memset(msg->msg_name +
+				       offsetof(struct sockaddr_ll, sll_addr),
+				       0, sizeof(sll->sll_addr));
+				msg->msg_namelen = sizeof(struct sockaddr_ll);
+			}
 		}
-		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa,
-		       msg->msg_namelen);
+		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa, copy_len);
 	}
 
 	if (pkt_sk(sk)->auxdata) {
-- 
2.20.1

