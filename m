Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC032E12EE
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730815AbgLWC0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:26:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730660AbgLWCZ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7112922202;
        Wed, 23 Dec 2020 02:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690343;
        bh=B+8l2agkKDcZLAW+qbtt2QYxTPDQoPOWLdsRuzdY8ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQO0d9k6S74vHpHrv5RZcCG53plCEwkDpHRZcbsyN3rV65HxKHGu4Mm6CLedcEvlZ
         qTsF9D1EJIE+GSSivj4p8TuRkt1DNRCIHEVEy4pOJeqjrqAwb6/CMndvlIuHs38dSA
         dcLUeIIq3mPKWV4Q2f8j+FZTlHx/PUZr2Y9bH2Xx/fnCGUlPhPxupu/4PahiNbrJ2V
         t8kMXfOnj/DCVsSk09EB4Q5eshr6UnwQ/GftZetqjLo5DxMMXZf8gUrzyZNtUy+Mfi
         bFI0inP4sd4bznD4nRufX+di1IZHl1NEe2hsCL/SR5unXPruklrfHprWfhjz1N/i1Q
         6RvEo3aHnIs7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        keyrings@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 21/38] rxrpc: Don't leak the service-side session key to userspace
Date:   Tue, 22 Dec 2020 21:24:59 -0500
Message-Id: <20201223022516.2794471-21-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022516.2794471-1-sashal@kernel.org>
References: <20201223022516.2794471-1-sashal@kernel.org>
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
 net/rxrpc/ar-key.c        | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/keys/rxrpc-type.h b/include/keys/rxrpc-type.h
index fc48754338179..5bd32114a51ad 100644
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
diff --git a/net/rxrpc/ar-key.c b/net/rxrpc/ar-key.c
index ea615e53eab28..ab4e21ffb4de9 100644
--- a/net/rxrpc/ar-key.c
+++ b/net/rxrpc/ar-key.c
@@ -1081,7 +1081,8 @@ static long rxrpc_read(const struct key *key,
 		case RXRPC_SECURITY_RXKAD:
 			toksize += 8 * 4;	/* viceid, kvno, key*2, begin,
 						 * end, primary, tktlen */
-			toksize += RND(token->kad->ticket_len);
+			if (!token->no_leak_key)
+				toksize += RND(token->kad->ticket_len);
 			break;
 
 		case RXRPC_SECURITY_RXK5:
@@ -1190,7 +1191,10 @@ static long rxrpc_read(const struct key *key,
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

