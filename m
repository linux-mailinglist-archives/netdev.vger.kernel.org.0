Return-Path: <netdev+bounces-2933-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C71A7049A7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:48:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BC241C20DD6
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94332171A5;
	Tue, 16 May 2023 09:48:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888BA2C726
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:48:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7644F44AA
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684230498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oGV9GFvpKwyXKCkY7SZJXtiQcygHIMENcujN1v78Ubo=;
	b=Dmc3CNj637dtMNQCpteeTs8RcAt1Sg7+8OK/RoZvHDePH87FnKZ2wfFVUkz3ST+RUI9vrx
	fFaDExXxmAiSMQzYDgTYy54TO53CUJj2mL/GAzBCZa1oBWuf1hMR9SzIjAs8EVbYhijWSQ
	RAuGnJq1l6Sehmks8VvvjrTZ/b+KcZE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-U68xPP6XPA-J98M3_QmyIg-1; Tue, 16 May 2023 05:48:15 -0400
X-MC-Unique: U68xPP6XPA-J98M3_QmyIg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2331685A588;
	Tue, 16 May 2023 09:48:15 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.195.8])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CEE24C15BA0;
	Tue, 16 May 2023 09:48:13 +0000 (UTC)
From: Andrea Claudi <aclaudi@redhat.com>
To: netdev@vger.kernel.org
Cc: stephen@networkplumber.org,
	dsahern@gmail.com
Subject: [PATCH iproute2-next v2] mptcp: add support for implicit flag
Date: Tue, 16 May 2023 11:48:04 +0200
Message-Id: <ff2f39fddd59cbeec87dc534e73f70a188649fe8.1684230221.git.aclaudi@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Kernel supports implicit flag since commit d045b9eb95a9 ("mptcp:
introduce implicit endpoints"), included in v5.18.

Let's add support for displaying it to iproute2.

Before this change:
$ ip mptcp endpoint show
10.0.2.2 id 1 rawflags 10

After this change:
$ ip mptcp endpoint show
10.0.2.2 id 1 implicit

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
v2: added implicit to ip-mptcp man page, as suggested by David Ahern

 ip/ipmptcp.c        | 1 +
 man/man8/ip-mptcp.8 | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index beba7a41..9847f95b 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -58,6 +58,7 @@ static const struct {
 	{ "subflow",		MPTCP_PM_ADDR_FLAG_SUBFLOW },
 	{ "backup",		MPTCP_PM_ADDR_FLAG_BACKUP },
 	{ "fullmesh",		MPTCP_PM_ADDR_FLAG_FULLMESH },
+	{ "implicit",		MPTCP_PM_ADDR_FLAG_IMPLICIT },
 	{ "nobackup",		MPTCP_PM_ADDR_FLAG_NONE },
 	{ "nofullmesh",		MPTCP_PM_ADDR_FLAG_NONE }
 };
diff --git a/man/man8/ip-mptcp.8 b/man/man8/ip-mptcp.8
index 72762f49..b427065c 100644
--- a/man/man8/ip-mptcp.8
+++ b/man/man8/ip-mptcp.8
@@ -176,6 +176,15 @@ endpoint. When the peer does announce addresses, each received ADD_ADDR
 sub-option will trigger creation of an additional subflow to generate a
 full mesh topology.
 
+.TP
+.BR implicit
+In some scenarios, an MPTCP
+.BR subflow
+can use a local address mapped by a implicit endpoint created by the
+in-kernel path manager. Once set, the implicit flag cannot be removed, but
+other flags can be added to the endpoint. Implicit endpoints cannot be
+created from user-space.
+
 .sp
 .PP
 The
-- 
2.40.1


