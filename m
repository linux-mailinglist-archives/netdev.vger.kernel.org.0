Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6466D2558
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbjCaQU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233804AbjCaQUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:20:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8425F22222
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0V0VYuNRGUsctVySLnEH8GinGQ4l5nQcc0Sx6Q5aq0A=;
        b=ZUZBSF5BwFA62Fo1jPr7EN6YBXxMfgoX+VXFgRh5c83eaPOLdKS6J5et8Hro1eq8aGsgk5
        DINPuv1YktYlBHVihMhRTLtCizebNaCJh8VFEjcwbqhSFvVpg3BlKyMHvC4So88ROEcw38
        N2awZI6ytrX2rSDh1trFVPb4lEviY3c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-JJSK7rSYNzmbFtG3J_VYoA-1; Fri, 31 Mar 2023 12:11:15 -0400
X-MC-Unique: JJSK7rSYNzmbFtG3J_VYoA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C1CF29ABA1F;
        Fri, 31 Mar 2023 16:11:14 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42ABB40B3EDB;
        Fri, 31 Mar 2023 16:11:12 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH v3 41/55] iscsi: Assume "sendpage" is okay in iscsi_tcp_segment_map()
Date:   Fri, 31 Mar 2023 17:09:00 +0100
Message-Id: <20230331160914.1608208-42-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As iscsi is now using sendmsg() with MSG_SPLICE_PAGES rather than sendpage,
assume that sendpage_ok() will return true in iscsi_tcp_segment_map() and
leave it to TCP to copy the data if not.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-scsi@vger.kernel.org
cc: target-devel@vger.kernel.org
cc: netdev@vger.kernel.org
---
 drivers/scsi/libiscsi_tcp.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index c182aa83f2c9..07ba0d864820 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -128,18 +128,11 @@ static void iscsi_tcp_segment_map(struct iscsi_segment *segment, int recv)
 	 * coalescing neighboring slab objects into a single frag which
 	 * triggers one of hardened usercopy checks.
 	 */
-	if (!recv && sendpage_ok(sg_page(sg)))
+	if (!recv)
 		return;
 
-	if (recv) {
-		segment->atomic_mapped = true;
-		segment->sg_mapped = kmap_atomic(sg_page(sg));
-	} else {
-		segment->atomic_mapped = false;
-		/* the xmit path can sleep with the page mapped so use kmap */
-		segment->sg_mapped = kmap(sg_page(sg));
-	}
-
+	segment->atomic_mapped = true;
+	segment->sg_mapped = kmap_atomic(sg_page(sg));
 	segment->data = segment->sg_mapped + sg->offset + segment->sg_offset;
 }
 

