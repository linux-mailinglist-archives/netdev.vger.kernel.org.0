Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576072691D2
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgINQlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:41:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26294 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726353AbgINPb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 11:31:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600097479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m+vcjl/WYR9TpPPDjmjqr4nMFYYTY/IojylAMQI9KPE=;
        b=USvDyn3RGrEbEvxFzvQ3sohebVP6rhq2hQuncvVn16/en39HeES00x2BSZ5pfK230Lomui
        WpkVFEq4P9E48Ek8eOapGEAyX8g+vAMvCFhjphuYOcIn/tME0qEv06RthUvI3NnHPXxc9u
        Ok2TnviMiz6tnfzeAbkvy7/kkhjvUGo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-4ptu5WxUNUin7KvMma181w-1; Mon, 14 Sep 2020 11:31:15 -0400
X-MC-Unique: 4ptu5WxUNUin7KvMma181w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A75B89CCFF;
        Mon, 14 Sep 2020 15:30:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-6.rdu2.redhat.com [10.10.113.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 823921002D46;
        Mon, 14 Sep 2020 15:30:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 1/5] rxrpc: Fix an error goto in rxrpc_connect_call()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 14 Sep 2020 16:30:53 +0100
Message-ID: <160009745364.1014072.15669282566191320805.stgit@warthog.procyon.org.uk>
In-Reply-To: <160009744625.1014072.11957943055200732444.stgit@warthog.procyon.org.uk>
References: <160009744625.1014072.11957943055200732444.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix an error-handling goto in rxrpc_connect_call() whereby it will jump to
free the bundle it failed to allocate.

Fixes: 245500d853e9 ("rxrpc: Rewrite the client connection manager")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/conn_client.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 0e4e1879c24d..180be4da8d26 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -724,8 +724,9 @@ int rxrpc_connect_call(struct rxrpc_sock *rx,
 	/* Paired with the write barrier in rxrpc_activate_one_channel(). */
 	smp_rmb();
 
-out:
+out_put_bundle:
 	rxrpc_put_bundle(bundle);
+out:
 	_leave(" = %d", ret);
 	return ret;
 
@@ -742,7 +743,7 @@ int rxrpc_connect_call(struct rxrpc_sock *rx,
 	trace_rxrpc_client(call->conn, ret, rxrpc_client_chan_wait_failed);
 	rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR, 0, ret);
 	rxrpc_disconnect_client_call(bundle, call);
-	goto out;
+	goto out_put_bundle;
 }
 
 /*


