Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB142C1628
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 21:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732919AbgKWULj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 15:11:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21083 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732597AbgKWULN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 15:11:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606162272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=saslOu984ahwhKQKfNAWbZLu0fw2ozrT5TSfZyQgUMo=;
        b=OKdrp6yd1xwaCLqF2EIRta5Ds5N9F5OMeZbojCicIt/MHfQUVvKRxqAIWbqeoVf66htabA
        +V5NLr6zR3zYGbRY2SsdsOzg/0VdNJ/EURaJrcZqjtICiiNR1DQ4VBu4BZVJtvms3FH8+4
        6ByTP+DZzYeNJSkmdJFK93wmGqRSTtw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-w9mxzQzMMTOA8i4AQPfcbw-1; Mon, 23 Nov 2020 15:11:10 -0500
X-MC-Unique: w9mxzQzMMTOA8i4AQPfcbw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16B0A8030A5;
        Mon, 23 Nov 2020 20:11:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-111.rdu2.redhat.com [10.10.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48A165D6DC;
        Mon, 23 Nov 2020 20:11:08 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 09/17] rxrpc: Allow security classes to give more
 info on server keys
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 Nov 2020 20:11:07 +0000
Message-ID: <160616226750.830164.2093457327608722796.stgit@warthog.procyon.org.uk>
In-Reply-To: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
References: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow a security class to give more information on an rxrpc_s-type key when
it is viewed in /proc/keys.  This will allow the upcoming RxGK security
class to show the enctype name here.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |    3 +++
 net/rxrpc/server_key.c  |    4 ++++
 2 files changed, 7 insertions(+)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 6682c797b878..0fb294725ff2 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -227,6 +227,9 @@ struct rxrpc_security {
 	/* Destroy the payload of a server key */
 	void (*destroy_server_key)(struct key *);
 
+	/* Describe a server key */
+	void (*describe_server_key)(const struct key *, struct seq_file *);
+
 	/* initialise a connection's security */
 	int (*init_connection_security)(struct rxrpc_connection *,
 					struct rxrpc_key_token *);
diff --git a/net/rxrpc/server_key.c b/net/rxrpc/server_key.c
index 1a2f0b63ee1d..ead3471307ee 100644
--- a/net/rxrpc/server_key.c
+++ b/net/rxrpc/server_key.c
@@ -105,7 +105,11 @@ static void rxrpc_destroy_s(struct key *key)
 
 static void rxrpc_describe_s(const struct key *key, struct seq_file *m)
 {
+	const struct rxrpc_security *sec = key->payload.data[1];
+
 	seq_puts(m, key->description);
+	if (sec && sec->describe_server_key)
+		sec->describe_server_key(key, m);
 }
 
 /*


