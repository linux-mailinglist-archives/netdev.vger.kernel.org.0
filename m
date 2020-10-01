Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26AB2801FC
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732751AbgJAO7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:59:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732414AbgJAO7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:59:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eod1prXK2yEw/WMOusEQFAG/SpmPbH4nvvAlDUwZvFM=;
        b=NQN5OIkuxuqPfGYxoKVdCScwzhM3eev4svpgRG1ZEywFuXk4JIpsck/7k2ohTE7NMInQKk
        zibhJ5uSv37dDZRCIJaZWFbXawKN+lIP5fa2BPf1ce04slKrE1+sbaVyMPpr4c5pYq6Cjp
        xA1bys1LTwxymsUZ4XdTmJhAVjjV++w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-Wgx5DqP9ONOgD22BU_5aVw-1; Thu, 01 Oct 2020 10:59:13 -0400
X-MC-Unique: Wgx5DqP9ONOgD22BU_5aVw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D820184F226;
        Thu,  1 Oct 2020 14:59:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24345610F3;
        Thu,  1 Oct 2020 14:59:11 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 21/23] rxrpc: Allow security classes to give more
 info on server keys
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:59:10 +0100
Message-ID: <160156435039.1728886.16686648974772019017.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index af4dfb2a23bf..a3091a10b7c5 100644
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


