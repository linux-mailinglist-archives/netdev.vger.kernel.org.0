Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18322801C2
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732556AbgJAO5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:57:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732511AbgJAO5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:57:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E80zfX10GM71QYbwRp5VKZqIJ13VHfC/M3iL+IxUjrc=;
        b=cadNhsXXuUJxZy7qNubWocRzgRLAw1pvYe/40ISblscH6H9Wp5K0S83ugWjQ6BX0jmjXVp
        IsiEEuzgqCzlnK6KS+WEEhNPN9ZVvFkfLEamK2Z2Abzbvv08I2WM7GvD8fVDZPJvYuew+Z
        /S2XVD8Di+zotGwFinw65Fej5b/sHZQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-o0pUREdwP_-S4UJ39owMaw-1; Thu, 01 Oct 2020 10:57:06 -0400
X-MC-Unique: o0pUREdwP_-S4UJ39owMaw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E09681891E86;
        Thu,  1 Oct 2020 14:57:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 149B010013C1;
        Thu,  1 Oct 2020 14:57:04 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 03/23] rxrpc: Fix rxkad token xdr encoding
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:57:04 +0100
Message-ID: <160156422423.1728886.7845123357278479696.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Dionne <marc.dionne@auristor.com>

The session key should be encoded with just the 8 data bytes and
no length; ENCODE_DATA precedes it with a 4 byte length, which
confuses some existing tools that try to parse this format.

Add an ENCODE_BYTES macro that does not include a length, and use
it for the key.  Also adjust the expected length.

Note that commit 774521f353e1d ("rxrpc: Fix an assertion in
rxrpc_read()") had fixed a BUG by changing the length rather than
fixing the encoding.  The original length was correct.

Fixes: 99455153d067 ("RxRPC: Parse security index 5 keys (Kerberos 5)")
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/key.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 94c3df392651..8f7d7a6187db 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -1072,7 +1072,7 @@ static long rxrpc_read(const struct key *key,
 
 		switch (token->security_index) {
 		case RXRPC_SECURITY_RXKAD:
-			toksize += 9 * 4;	/* viceid, kvno, key*2 + len, begin,
+			toksize += 8 * 4;	/* viceid, kvno, key*2, begin,
 						 * end, primary, tktlen */
 			toksize += RND(token->kad->ticket_len);
 			break;
@@ -1138,6 +1138,14 @@ static long rxrpc_read(const struct key *key,
 			memcpy((u8 *)xdr + _l, &zero, 4 - (_l & 3));	\
 		xdr += (_l + 3) >> 2;					\
 	} while(0)
+#define ENCODE_BYTES(l, s)						\
+	do {								\
+		u32 _l = (l);						\
+		memcpy(xdr, (s), _l);					\
+		if (_l & 3)						\
+			memcpy((u8 *)xdr + _l, &zero, 4 - (_l & 3));	\
+		xdr += (_l + 3) >> 2;					\
+	} while(0)
 #define ENCODE64(x)					\
 	do {						\
 		__be64 y = cpu_to_be64(x);		\
@@ -1165,7 +1173,7 @@ static long rxrpc_read(const struct key *key,
 		case RXRPC_SECURITY_RXKAD:
 			ENCODE(token->kad->vice_id);
 			ENCODE(token->kad->kvno);
-			ENCODE_DATA(8, token->kad->session_key);
+			ENCODE_BYTES(8, token->kad->session_key);
 			ENCODE(token->kad->start);
 			ENCODE(token->kad->expiry);
 			ENCODE(token->kad->primary_flag);


