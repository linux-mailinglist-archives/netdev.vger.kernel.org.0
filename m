Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD032801E7
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732825AbgJAO6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:58:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732728AbgJAO6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:58:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EuIR3ONFiXsCuoYyKBFHgCry6+bR76jb/4bcA3hazMY=;
        b=XfbvIPM90lnMHGwU5G+EXZ1Rlixe4gxtgdd9qfgyHeB/qu6AOKQ8W1YM1HM3hN44h0Uh8x
        NzA0qunOsNDcQSytUJ4DIv3uVz7eEuarK5vxT2JICIlmtRCJMM6SXl2We6AYhAOpAHGlxy
        8qxnnZUEumDyybR1Nklffe3+n+Iq26w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-JMovgojRPimDKlL5pIgVrg-1; Thu, 01 Oct 2020 10:58:03 -0400
X-MC-Unique: JMovgojRPimDKlL5pIgVrg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 246E0801AB1;
        Thu,  1 Oct 2020 14:58:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 645F75D9D3;
        Thu,  1 Oct 2020 14:58:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 11/23] rxrpc: List the held token types in the key
 description in /proc/keys
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:57:59 +0100
Message-ID: <160156427966.1728886.13812238692015071101.stgit@warthog.procyon.org.uk>
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

When viewing an rxrpc-type key through /proc/keys, display a list of held
token types.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/key.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 75b500650257..b10b4db7c205 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -31,6 +31,7 @@ static void rxrpc_free_preparse_s(struct key_preparsed_payload *);
 static void rxrpc_destroy(struct key *);
 static void rxrpc_destroy_s(struct key *);
 static void rxrpc_describe(const struct key *, struct seq_file *);
+static void rxrpc_describe_s(const struct key *, struct seq_file *);
 static long rxrpc_read(const struct key *, char *, size_t);
 
 /*
@@ -61,7 +62,7 @@ struct key_type key_type_rxrpc_s = {
 	.free_preparse	= rxrpc_free_preparse_s,
 	.instantiate	= generic_key_instantiate,
 	.destroy	= rxrpc_destroy_s,
-	.describe	= rxrpc_describe,
+	.describe	= rxrpc_describe_s,
 };
 
 /*
@@ -494,6 +495,32 @@ static void rxrpc_destroy_s(struct key *key)
  * describe the rxrpc key
  */
 static void rxrpc_describe(const struct key *key, struct seq_file *m)
+{
+	const struct rxrpc_key_token *token;
+	const char *sep = ": ";
+
+	seq_puts(m, key->description);
+
+	for (token = key->payload.data[0]; token; token = token->next) {
+		seq_puts(m, sep);
+
+		switch (token->security_index) {
+		case RXRPC_SECURITY_RXKAD:
+			seq_puts(m, "ka");
+			break;
+		default: /* we have a ticket we can't encode */
+			seq_printf(m, "%u", token->security_index);
+			break;
+		}
+
+		sep = " ";
+	}
+}
+
+/*
+ * describe the rxrpc server key
+ */
+static void rxrpc_describe_s(const struct key *key, struct seq_file *m)
 {
 	seq_puts(m, key->description);
 }


