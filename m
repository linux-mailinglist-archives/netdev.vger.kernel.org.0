Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBDA13F893
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404789AbgAPTTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:19:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:38664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729398AbgAPQyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EFD7214AF;
        Thu, 16 Jan 2020 16:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193654;
        bh=DI6ICq4HWZ6XHBvN01VGY+os4flBLAgbrVEIZE3MPpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjaCEItej3zw/ZngP0YLLXJ+E+z56u49B1iJtdCLh0XWpMkg9tdNDsaVgxW/1MsVJ
         n47gDKf/kBDuh7mGms3Bpfqv33KTFPG6iDIT9QsYcL1IHymsU5ahJTuLOTp0mp1VxK
         77ZtcZqrCp+Lijhl+Nbo0r+RhH+ilW67YyE3RQgM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 183/205] tipc: fix potential memory leak in __tipc_sendmsg()
Date:   Thu, 16 Jan 2020 11:42:38 -0500
Message-Id: <20200116164300.6705-183-sashal@kernel.org>
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

From: Tung Nguyen <tung.q.nguyen@dektech.com.au>

[ Upstream commit 2fe97a578d7bad3116a89dc8a6692a51e6fc1d9c ]

When initiating a connection message to a server side, the connection
message is cloned and added to the socket write queue. However, if the
cloning is failed, only the socket write queue is purged. It causes
memory leak because the original connection message is not freed.

This commit fixes it by purging the list of connection message when
it cannot be cloned.

Fixes: 6787927475e5 ("tipc: buffer overflow handling in listener socket")
Reported-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/socket.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 4b92b196cfa6..8cbdda3d4503 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1392,8 +1392,10 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 	rc = tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
 	if (unlikely(rc != dlen))
 		return rc;
-	if (unlikely(syn && !tipc_msg_skb_clone(&pkts, &sk->sk_write_queue)))
+	if (unlikely(syn && !tipc_msg_skb_clone(&pkts, &sk->sk_write_queue))) {
+		__skb_queue_purge(&pkts);
 		return -ENOMEM;
+	}
 
 	trace_tipc_sk_sendmsg(sk, skb_peek(&pkts), TIPC_DUMP_SK_SNDQ, " ");
 	rc = tipc_node_xmit(net, &pkts, dnode, tsk->portid);
-- 
2.20.1

