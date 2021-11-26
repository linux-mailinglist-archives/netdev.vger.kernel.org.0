Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863F845EBD0
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 11:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbhKZKlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 05:41:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43747 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238038AbhKZKjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 05:39:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637922955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vXBd28bcX264VU/S4G66DmxsLM80Ytxzh6lebwq/wHQ=;
        b=Y1+7J1n1BKsYurR9GgQPLE0iyqmh+cNdD4120vrPRiNxEp7JhKihlmnVIOVR84DUkYECRN
        MXQLrWxmjA1/79jC//9pjaB/iqstXVMDHE4ysVbXKi/5zTPNntF9x8OYhy8B8omz/ks8f3
        Pyl3NLL84MSw5CDfFRgrFz8/ZpzBMbA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-tqsyYKIfOyyXxwuqk_2U4A-1; Fri, 26 Nov 2021 05:35:51 -0500
X-MC-Unique: tqsyYKIfOyyXxwuqk_2U4A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9164F801B17;
        Fri, 26 Nov 2021 10:35:50 +0000 (UTC)
Received: from gerbillo.fritz.box (unknown [10.39.194.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B04061972E;
        Fri, 26 Nov 2021 10:35:49 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.linux.dev
Subject: [PATCH iproute2-next] mptcp: add support for fullmesh flag
Date:   Fri, 26 Nov 2021 11:35:44 +0100
Message-Id: <247b8dfb7254d4a1fb435b5efa756cea989b62cb.1637922870.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The link kernel supports this endpoint flag since v5.15, let's
expose it to user-space. It allows creation on fullmesh topolgy
via MPTCP subflow.

Additionally update the related man-page, clarifying the behavior
of related options.

Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 ip/ipmptcp.c        |  3 ++-
 man/man8/ip-mptcp.8 | 61 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 49 insertions(+), 15 deletions(-)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index 0f5b6e2d..433fa68d 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -31,7 +31,7 @@ static void usage(void)
 		"	ip mptcp limits show\n"
 		"	ip mptcp monitor\n"
 		"FLAG-LIST := [ FLAG-LIST ] FLAG\n"
-		"FLAG  := [ signal | subflow | backup ]\n");
+		"FLAG  := [ signal | subflow | backup | fullmesh ]\n");
 
 	exit(-1);
 }
@@ -53,6 +53,7 @@ static const struct {
 	{ "signal",		MPTCP_PM_ADDR_FLAG_SIGNAL },
 	{ "subflow",		MPTCP_PM_ADDR_FLAG_SUBFLOW },
 	{ "backup",		MPTCP_PM_ADDR_FLAG_BACKUP },
+	{ "fullmesh",		MPTCP_PM_ADDR_FLAG_FULLMESH },
 };
 
 static void print_mptcp_addr_flags(unsigned int flags)
diff --git a/man/man8/ip-mptcp.8 b/man/man8/ip-mptcp.8
index 22335b61..019debe2 100644
--- a/man/man8/ip-mptcp.8
+++ b/man/man8/ip-mptcp.8
@@ -53,6 +53,8 @@ ip-mptcp \- MPTCP path manager configuration
 .B subflow
 .RB "|"
 .B backup
+.RB "|"
+.B fullmesh
 .RB  "]"
 
 .ti -8
@@ -103,22 +105,41 @@ is a unique numeric identifier for the given endpoint
 
 .TP
 .BR signal
-the endpoint will be announced/signalled to each peer via an ADD_ADDR MPTCP
-sub-option
+The endpoint will be announced/signaled to each peer via an MPTCP ADD_ADDR
+sub-option. Upon reception of an ADD_ADDR sub-option, the peer can try to
+create additional subflows, see
+.BR ADD_ADDR_ACCEPTED_NR.
 
 .TP
 .BR subflow
-if additional subflow creation is allowed by MPTCP limits, the endpoint will
-be used as the source address to create an additional subflow after that
-the MPTCP connection is established.
+If additional subflow creation is allowed by the MPTCP limits, the MPTCP
+path manager will try to create an additional subflow using this endpoint
+as the source address after the MPTCP connection is established.
 
 .TP
 .BR backup
-the endpoint will be announced as a backup address, if this is a
-.BR signal
-endpoint, or the subflow will be created as a backup one if this is a
+If this is a
+.BR subflow
+endpoint, the subflows created using this endpoint will have the backup
+flag set during the connection process. This flag instructs the peer to
+only send data on a given subflow when all non-backup subflows are
+unavailable. This does not affect outgoing data, where subflow priority
+is determined by the backup/non-backup flag received from the peer
+
+.TP
+.BR fullmesh
+If this is a
+.BR subflow
+endpoint and additional subflow creation is allowed by the MPTCP limits,
+the MPTCP path manager will try to create an additional subflow for each
+known peer address, using this endpoint as the source address. This will
+occur after the MPTCP connection is established. If the peer did not
+announce any additional addresses using the MPTCP ADD_ADDR sub-option,
+this will behave the same as a plain
 .BR subflow
-endpoint
+endpoint. When the peer does announce addresses, each received ADD_ADDR
+sub-option will trigger creation of an additional subflow to generate a
+full mesh topology.
 
 .sp
 .PP
@@ -136,17 +157,29 @@ ip mptcp limits set	change the MPTCP subflow creation limits
 .IR SUBFLOW_NR
 specifies the maximum number of additional subflows allowed for each MPTCP
 connection. Additional subflows can be created due to: incoming accepted
-ADD_ADDR option, local
+ADD_ADDR sub-option, local
 .BR subflow
 endpoints, additional subflows started by the peer.
 
 .TP
 .IR ADD_ADDR_ACCEPTED_NR
-specifies the maximum number of ADD_ADDR suboptions accepted for each MPTCP
-connection. The MPTCP path manager will try to create a new subflow for
-each accepted ADD_ADDR option, respecting the
+specifies the maximum number of incoming ADD_ADDR sub-options accepted for
+each MPTCP connection. After receiving the specified number of ADD_ADDR
+sub-options, any other incoming one will be ignored for the MPTCP connection
+lifetime. When an ADD_ADDR sub-option is accepted and there are no local
+.IR fullmesh
+endpoints, the MPTCP path manager will try to create a new subflow using the
+address in the ADD_ADDR sub-option as the destination address and a source
+address determined using local routing resolution
+When
+.IR fullmesh
+endpoints are available, the MPTCP path manager will try to create new subflows
+using each
+.IR fullmesh
+endpoint as a source address and the peer's ADD_ADDR address as the destination.
+In both cases the
 .IR SUBFLOW_NR
-limit.
+limit is enforced.
 
 .sp
 .PP
-- 
2.33.1

