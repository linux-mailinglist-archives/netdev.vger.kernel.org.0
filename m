Return-Path: <netdev+bounces-2721-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD9F17034A3
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:50:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A43A2813E7
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 483A7FBF2;
	Mon, 15 May 2023 16:50:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7BFFBE7;
	Mon, 15 May 2023 16:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A391C4339C;
	Mon, 15 May 2023 16:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169426;
	bh=tlJPUuUVRpEZGnrbkGEflL2jwDkHI9CNFTJwvu+RQuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8ywxX3Vi5XspSkFT3UOVNyTy1jHM5Jks06jrR6OrtaTta6hyTzaA4WlWo7GaurJk
	 FockyaiYZSbLxTy953Q9d46aTU73/Ql/C8ZjFcBbwhecIsCEla/uQ4ufx+I6CI0fJy
	 NfclnELAZZjc0e61ts0OiVeVtlMjoIko6f9NQG00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-afs@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 052/246] rxrpc: Make it so that a waiting process can be aborted
Date: Mon, 15 May 2023 18:24:24 +0200
Message-Id: <20230515161724.142586697@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 0eb362d254814ce04848730bf32e75b8ee1a4d6c ]

When sendmsg() creates an rxrpc call, it queues it to wait for a connection
and channel to be assigned and then waits before it can start shovelling
data as the encrypted DATA packet content includes a summary of the
connection parameters.

However, sendmsg() may get interrupted before a connection gets assigned
and further sendmsg() calls will fail with EBUSY until an assignment is
made.

Fix this so that the call can at least be aborted without failing on
EBUSY.  We have to be careful here as sendmsg() mustn't be allowed to start
the call timer if the call doesn't yet have a connection assigned as an
oops may follow shortly thereafter.

Fixes: 540b1c48c37a ("rxrpc: Fix deadlock between call creation and sendmsg/recvmsg")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 7498a77b5d397..c1b074c17b33e 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -656,10 +656,13 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 			goto out_put_unlock;
 	} else {
 		switch (rxrpc_call_state(call)) {
-		case RXRPC_CALL_UNINITIALISED:
 		case RXRPC_CALL_CLIENT_AWAIT_CONN:
-		case RXRPC_CALL_SERVER_PREALLOC:
 		case RXRPC_CALL_SERVER_SECURING:
+			if (p.command == RXRPC_CMD_SEND_ABORT)
+				break;
+			fallthrough;
+		case RXRPC_CALL_UNINITIALISED:
+		case RXRPC_CALL_SERVER_PREALLOC:
 			rxrpc_put_call(call, rxrpc_call_put_sendmsg);
 			ret = -EBUSY;
 			goto error_release_sock;
-- 
2.39.2




