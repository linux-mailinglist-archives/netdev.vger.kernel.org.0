Return-Path: <netdev+bounces-581-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A17136F8469
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:59:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A195B1C21887
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00F9AC15B;
	Fri,  5 May 2023 13:59:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21491FAB
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 13:59:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E3D1569C
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 06:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683295139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ute/2gMbAAtLq8tVQWomtI9PPiMUehdUb/om3PAjAZ8=;
	b=RUizomvY3TFZrVVdE3vAuvOzoP9ERmfdEScnrfLQapuOoYKYmHZ+GqDueQv4hCrB50DJpl
	vLJ2yfzM9cLNXJNovuB0LMhlletCWha47z0y2yfIzHrzDvUUUl4mC4jHhfYJ50OCA1lP6I
	Cu+QA1NVDcey+XZZyuNUyNX21Iyk6KU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-w7VcQG1MNGe5CKP0BRaS1Q-1; Fri, 05 May 2023 09:58:53 -0400
X-MC-Unique: w7VcQG1MNGe5CKP0BRaS1Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD1803C0F25C;
	Fri,  5 May 2023 13:58:52 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.194.151])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 46AF6492C3F;
	Fri,  5 May 2023 13:58:51 +0000 (UTC)
From: Andrea Claudi <aclaudi@redhat.com>
To: netdev@vger.kernel.org
Cc: stephen@networkplumber.org,
	dsahern@gmail.com
Subject: [PATCH iproute2-next] mptcp: add support for implicit flag
Date: Fri,  5 May 2023 15:58:34 +0200
Message-Id: <1eaea070b52f2db1f310506ac49f4b5d51b5704c.1683294873.git.aclaudi@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
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
 ip/ipmptcp.c | 1 +
 1 file changed, 1 insertion(+)

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
-- 
2.40.1


