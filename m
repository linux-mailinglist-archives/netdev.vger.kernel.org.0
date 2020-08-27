Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792C3254865
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgH0PGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:06:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27381 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728141AbgH0PEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 11:04:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598540676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0VtB92U4i32c4hyLQXA23+fVFBgzf/HjN24g5GHtvlw=;
        b=cVkKFhzpMpB9uVWqnc9R+iCyrtVb31I2RyAuTNSVls59xRCBe8NWrtIBGcANOOIF4bc+wa
        3A421DtLn7mjQSb+9qE1jTDuv0pWQQVYumZ6ETF9YV778oXvBwLGfBi928sAZk1PoHVJS5
        eGa+7Ly0NWbUShYPBpQFs2gzUMnzEcw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-gb8lPW1HNZa5SkDJINWjOw-1; Thu, 27 Aug 2020 11:04:33 -0400
X-MC-Unique: gb8lPW1HNZa5SkDJINWjOw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 084C01015DDF;
        Thu, 27 Aug 2020 15:04:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-127.rdu2.redhat.com [10.10.120.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CC9F19936;
        Thu, 27 Aug 2020 15:04:02 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 4/7] afs: Remove afs_vlserver->probe.have_result
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 27 Aug 2020 16:04:01 +0100
Message-ID: <159854064142.1382667.3537073236297188885.stgit@warthog.procyon.org.uk>
In-Reply-To: <159854061331.1382667.9693163318506702951.stgit@warthog.procyon.org.uk>
References: <159854061331.1382667.9693163318506702951.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove afs_vlserver->probe.have_result as it's neither read nor waited
upon.

Fixes: 3bf0fb6f33dd ("afs: Probe multiple fileservers simultaneously")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/internal.h |    1 -
 fs/afs/vl_probe.c |    5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 792ac711985e..2e6ae6388c72 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -412,7 +412,6 @@ struct afs_vlserver {
 		unsigned int	rtt;		/* RTT as ktime/64 */
 		u32		abort_code;
 		short		error;
-		bool		have_result;
 		bool		responded:1;
 		bool		is_yfs:1;
 		bool		not_yfs:1;
diff --git a/fs/afs/vl_probe.c b/fs/afs/vl_probe.c
index 081b7e5b13f5..ee59188433b9 100644
--- a/fs/afs/vl_probe.c
+++ b/fs/afs/vl_probe.c
@@ -109,11 +109,8 @@ void afs_vlserver_probe_result(struct afs_call *call)
 	       server_index, index, &alist->addrs[index].transport, rtt_us, ret);
 
 	have_result |= afs_vl_probe_done(server);
-	if (have_result) {
-		server->probe.have_result = true;
-		wake_up_var(&server->probe.have_result);
+	if (have_result)
 		wake_up_all(&server->probe_wq);
-	}
 }
 
 /*


