Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC0D6D7961
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 12:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbjDEKQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 06:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237753AbjDEKQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 06:16:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4139D19AF
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 03:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680689722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=5IwQffGQgbW5+GGPT7GHsPI80Xqx/MpQcxXTIga+7R4=;
        b=MUbAtwA1+wPs0JHsWLmTEsx24uZDQa/j2oAwCPJG+Yrs6idM6L19lvwDPyI/e6cJw6Jcki
        Ar9OyUScOOzxKbZy/+SSV6JGg9kP7PJeE8CN59S+oGRYG50Q2kIl37k7vbH4O5VC9cW3GS
        gBkf7jp/gn2Foib0ywyiVEZLfve4dV8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-h9N5vcbAOs2WQe-xnr3Yfg-1; Wed, 05 Apr 2023 06:15:19 -0400
X-MC-Unique: h9N5vcbAOs2WQe-xnr3Yfg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D560185A790;
        Wed,  5 Apr 2023 10:15:18 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1665F440D6;
        Wed,  5 Apr 2023 10:15:16 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
cc:     dhowells@redhat.com, Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iov_iter: Remove last_offset member
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2933617.1680689716.1@warthog.procyon.org.uk>
Date:   Wed, 05 Apr 2023 11:15:16 +0100
Message-ID: <2933618.1680689716@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jens,

Can you add this to the block tree?

David
---
iov_iter: Remove last_offset member

With the removal of ITER_PIPE, the last_offset member of struct iov_iter is
no longer used, so remove it and un-unionise the remaining member.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: Alexander Viro <viro@zeniv.linux.org.uk>
cc: linux-nfs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-mm@kvack.org
cc: netdev@vger.kernel.org
---
 include/linux/uio.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 74598426edb4..2d8a70cb9b26 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -43,10 +43,7 @@ struct iov_iter {
 	bool nofault;
 	bool data_source;
 	bool user_backed;
-	union {
-		size_t iov_offset;
-		int last_offset;
-	};
+	size_t iov_offset;
 	size_t count;
 	union {
 		const struct iovec *iov;

