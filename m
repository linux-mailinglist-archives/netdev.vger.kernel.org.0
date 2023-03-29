Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE9F6CDC3C
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbjC2OU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjC2OT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:19:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9F4618A
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680099337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0V0VYuNRGUsctVySLnEH8GinGQ4l5nQcc0Sx6Q5aq0A=;
        b=c78w6wncXK2A7qKBNp/fqp/QLdog2d7a7+Y5riDnZFpKgCuQJ2A3HhS6otgSGW1eMfIgI1
        uVeWcEMz3sZgfa5fdgtpVM1MHiGRO7STJ6WiN2FnnpiqYwwV0G2ocWgMLnXfKEPV8GrZBr
        oW+sF5ijcJT9WBVx6yfv7g/mFiq7EpM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-kCehxZq9PD6SIf6owZvSow-1; Wed, 29 Mar 2023 10:15:33 -0400
X-MC-Unique: kCehxZq9PD6SIf6owZvSow-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7FF3185A790;
        Wed, 29 Mar 2023 14:15:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BD4C1121330;
        Wed, 29 Mar 2023 14:15:27 +0000 (UTC)
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
Subject: [RFC PATCH v2 33/48] iscsi: Assume "sendpage" is okay in iscsi_tcp_segment_map()
Date:   Wed, 29 Mar 2023 15:13:39 +0100
Message-Id: <20230329141354.516864-34-dhowells@redhat.com>
In-Reply-To: <20230329141354.516864-1-dhowells@redhat.com>
References: <20230329141354.516864-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
 

