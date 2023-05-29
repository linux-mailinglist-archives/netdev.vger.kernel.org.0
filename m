Return-Path: <netdev+bounces-6181-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 959007150FC
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 23:42:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA0541C20A9B
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 21:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3742A1096E;
	Mon, 29 May 2023 21:42:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269B07C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 21:42:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8851EA7
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 14:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685396519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=U3jRLLD0HROFKUKKa6mn+6LjPCmY/GKjW2WGQk4qoac=;
	b=jJJH3gnmWBBwFzeLC01siCydaOJSC6zkFyS+F+vGlU6XCHzSmhScwfd+KVFBXlOUlnrRGJ
	3iYIW8MfoScUIIyjV3xK6o7/XFYmAgFab67z4sOSqsU7/po57l69nMRvEiDL7Q5y/JpXbz
	btz/GlO6NnCR33Zo9Mh/ybxNqgDvsYY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-YqXCfNcuPXqc0dIcLqc8zw-1; Mon, 29 May 2023 17:41:53 -0400
X-MC-Unique: YqXCfNcuPXqc0dIcLqc8zw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30168380212E;
	Mon, 29 May 2023 21:41:53 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.39])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 05574112132C;
	Mon, 29 May 2023 21:41:51 +0000 (UTC)
From: Andrea Claudi <aclaudi@redhat.com>
To: netdev@vger.kernel.org
Cc: stephen@networkplumber.org,
	dsahern@gmail.com,
	parav@nvidia.com
Subject: [PATCH iproute2] vdpa: propagate error from cmd_dev_vstats_show()
Date: Mon, 29 May 2023 23:41:41 +0200
Message-Id: <5290b224a23e36b22e179ca83f2ce377f6d8dd1c.1685396319.git.aclaudi@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Error potentially returned from mnlu_gen_socket_sndrcv() are propagated
for each and every invocation in vdpa. Let's do the same here.

Fixes: 6f97e9c9337b ("vdpa: Add support for reading vdpa device statistics")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 vdpa/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index 27647d73..8bbe452c 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -986,7 +986,7 @@ static int cmd_dev_vstats_show(struct vdpa *vdpa, int argc, char **argv)
 	pr_out_section_start(vdpa, "vstats");
 	err = mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, cmd_dev_vstats_show_cb, vdpa);
 	pr_out_section_end(vdpa);
-	return 0;
+	return err;
 }
 
 static int cmd_dev_vstats(struct vdpa *vdpa, int argc, char **argv)
-- 
2.40.1


