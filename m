Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375722E1532
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbgLWCWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:22:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729561AbgLWCWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42FD922A99;
        Wed, 23 Dec 2020 02:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690110;
        bh=mCL/6JX8PjkAtZ/N2abdTYj3YjbBv9fu3lg3hFY6z3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/NN+3AHEvYErDjKGlM/CBQLfJ7XECL2AWuLD5SMWH73GsFBGR4TKpaB3hqeHQ68U
         5ZKTOvu2Ikzsn0dUull0z2wZEQqMj0/n/t7vjNyDq+5N4vh3w59sQEhCoB5ZcscolT
         T7H8cs9mfxikCzKMSpXC3oppaDRIcd0E8NfV3TrlPBe9wggXWlZIidhXhOGSsHU4x7
         LVp1V0+sG3WiZy9LX4B0cGVyiHkldVzIJe5dRoJRLRSZbtZokc3DtNX8MkUE6WYu6K
         gVN0h3xs0AHxhhBGO5tWdvsl8B4yb8eK+VfW8dUIPNph94KkTXIwgHRgrbeqqT+l0Y
         zgm45jFgFoSYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        keyrings@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 38/87] rxrpc: Don't leak the service-side session key to userspace
Date:   Tue, 22 Dec 2020 21:20:14 -0500
Message-Id: <20201223022103.2792705-38-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit d2ae4e918218f543214fbd906db68a6c580efbbb ]

Don't let someone reading a service-side rxrpc-type key get access to the
session key that was exchanged with the client.  The server application
will, at some point, need to be able to read the information in the ticket,
but this probably shouldn't include the key material.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/keys/rxrpc-type.h | 1 +
 net/rxrpc/key.c           | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/keys/rxrpc-type.h b/include/keys/rxrpc-type.h
index 8cf829dbf20ec..1cb996dac3238 100644
--- a/include/keys/rxrpc-type.h
+++ b/include/keys/rxrpc-type.h
@@ -88,6 +88,7 @@ struct rxk5_key {
  */
 struct rxrpc_key_token {
 	u16	security_index;		/* RxRPC header security index */
+	bool	no_leak_key;		/* Don't copy the key to userspace */
 	struct rxrpc_key_token *next;	/* the next token in the list */
 	union {
 		struct rxkad_key *kad;
diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 2fe2add62a8ed..dd8a12847b712 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -1077,7 +1077,8 @@ static long rxrpc_read(const struct key *key,
 		case RXRPC_SECURITY_RXKAD:
 			toksize += 8 * 4;	/* viceid, kvno, key*2, begin,
 						 * end, primary, tktlen */
-			toksize += RND(token->kad->ticket_len);
+			if (!token->no_leak_key)
+				toksize += RND(token->kad->ticket_len);
 			break;
 
 		case RXRPC_SECURITY_RXK5:
@@ -1181,7 +1182,10 @@ static long rxrpc_read(const struct key *key,
 			ENCODE(token->kad->start);
 			ENCODE(token->kad->expiry);
 			ENCODE(token->kad->primary_flag);
-			ENCODE_DATA(token->kad->ticket_len, token->kad->ticket);
+			if (token->no_leak_key)
+				ENCODE(0);
+			else
+				ENCODE_DATA(token->kad->ticket_len, token->kad->ticket);
 			break;
 
 		case RXRPC_SECURITY_RXK5:
-- 
2.27.0

