Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D088C26216E
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730278AbgIHUvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:51:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38767 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728631AbgIHUvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 16:51:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599598277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/vYiscYO+ORFUdOiUUtyHPdjWVlpvJ1fdCdpC1aIvMI=;
        b=KvC1LAN02SrLpgLAkYr9u3lHykOLtutEIJpedNIGhqbyrV5bLFL+rwz7QKAVpvCfG4kHh1
        LiBcOSzr7Vwf9UYQKUX/FxbTG6yFQ8N2maoQ+yUdsyDStOp8uxzvj5i2E5K7acaLdRRyLC
        pTq3Lh5vdJ1EhsQSvR2X9EBy5WpaarA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-aJilGBotOMKkPvu9_BG1FQ-1; Tue, 08 Sep 2020 16:51:15 -0400
X-MC-Unique: aJilGBotOMKkPvu9_BG1FQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F15D01006488;
        Tue,  8 Sep 2020 20:51:13 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-6.rdu2.redhat.com [10.10.113.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 305E58357E;
        Tue,  8 Sep 2020 20:51:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 3/3] rxrpc: Allow multiple client connections to the
 same peer
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Sep 2020 21:51:12 +0100
Message-ID: <159959827240.645007.5925464824704611056.stgit@warthog.procyon.org.uk>
In-Reply-To: <159959825107.645007.502549394334535916.stgit@warthog.procyon.org.uk>
References: <159959825107.645007.502549394334535916.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the number of parallel connections to a machine to be expanded from a
single connection to a maximum of four.  This allows up to 16 calls to be
in progress at the same time to any particular peer instead of 4.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/conn_client.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 8b41c87b3333..0e4e1879c24d 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -486,6 +486,12 @@ static void rxrpc_maybe_add_conn(struct rxrpc_bundle *bundle, gfp_t gfp)
 	if (!usable)
 		goto alloc_conn;
 
+	if (!bundle->avail_chans &&
+	    !bundle->try_upgrade &&
+	    !list_empty(&bundle->waiting_calls) &&
+	    usable < ARRAY_SIZE(bundle->conns))
+		goto alloc_conn;
+
 	spin_unlock(&bundle->channel_lock);
 	_leave("");
 	return;


