Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC942801FE
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732534AbgJAO7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:59:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45995 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732616AbgJAO7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:59:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZRWnPCbcest3+Z+TNc8aKcVZF9uV3bL+kuRQ0c/qGbk=;
        b=Gu0Ibou2siH5LR4/TfZy462i3Jfq3li515Zb0ZCfMX7UtfefjqV01i4i3FGrgbtwnSoxXl
        lOo6hB5Z6EPREnQ8YNNR7+u3ADMP/ty139YwyMd7ZH7L76bpBRsEEyiXkWiUPnC6Z0tA2O
        /nudFAqVsy8ti8BUwR5KeXkCLIaxDmM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-oa6bs0_iNQCdRScbQ2BqAg-1; Thu, 01 Oct 2020 10:59:06 -0400
X-MC-Unique: oa6bs0_iNQCdRScbQ2BqAg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28B018030DB;
        Thu,  1 Oct 2020 14:59:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FF145D9EF;
        Thu,  1 Oct 2020 14:59:02 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 20/23] rxrpc: Don't leak the service-side session key
 to userspace
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:59:02 +0100
Message-ID: <160156434215.1728886.7071961658509702368.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't let someone reading a service-side rxrpc-type key get access to the
session key that was exchanged with the client.  The server application
will, at some point, need to be able to read the information in the ticket,
but this probably shouldn't include the key material.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/keys/rxrpc-type.h |    1 +
 net/rxrpc/key.c           |    8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/keys/rxrpc-type.h b/include/keys/rxrpc-type.h
index 8e4ced9b4ecf..333c0f49a9cd 100644
--- a/include/keys/rxrpc-type.h
+++ b/include/keys/rxrpc-type.h
@@ -36,6 +36,7 @@ struct rxkad_key {
  */
 struct rxrpc_key_token {
 	u16	security_index;		/* RxRPC header security index */
+	bool	no_leak_key;		/* Don't copy the key to userspace */
 	struct rxrpc_key_token *next;	/* the next token in the list */
 	union {
 		struct rxkad_key *kad;
diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 822152ce381f..c08827b87979 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -579,7 +579,8 @@ static long rxrpc_read(const struct key *key,
 		case RXRPC_SECURITY_RXKAD:
 			toksize += 8 * 4;	/* viceid, kvno, key*2, begin,
 						 * end, primary, tktlen */
-			toksize += RND(token->kad->ticket_len);
+			if (!token->no_leak_key)
+				toksize += RND(token->kad->ticket_len);
 			break;
 
 		default: /* we have a ticket we can't encode */
@@ -654,7 +655,10 @@ static long rxrpc_read(const struct key *key,
 			ENCODE(token->kad->start);
 			ENCODE(token->kad->expiry);
 			ENCODE(token->kad->primary_flag);
-			ENCODE_DATA(token->kad->ticket_len, token->kad->ticket);
+			if (token->no_leak_key)
+				ENCODE(0);
+			else
+				ENCODE_DATA(token->kad->ticket_len, token->kad->ticket);
 			break;
 
 		default:


