Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B968564EB90
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 13:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiLPMqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 07:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiLPMq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 07:46:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818AA38AA
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 04:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671194741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CvwOufv5pEhIhgMEysvlJf2UTI5YhOfiynf6OZftv3I=;
        b=h3h1mqXxWQm6KhDfVB+XxwoKFUTOZfFLVZoKzDErTtBfrjvECKOJqemdpMUR1NCBwL9Lzq
        J7CmmJBIa0bk4bB12xpYuNMJZNza0fvfSz18FgsWL4Jd+T0Aew+Oh9z+MpQgLxhRkn6pDB
        z518zsfh4qccFFgxpvw8zS96S6praPA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-qPHV_NjlMjW_IukuuCYGHQ-1; Fri, 16 Dec 2022 07:45:37 -0500
X-MC-Unique: qPHV_NjlMjW_IukuuCYGHQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41DEC38041D0;
        Fri, 16 Dec 2022 12:45:36 +0000 (UTC)
Received: from bcodding.csb (unknown [10.22.50.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1183C40C2064;
        Fri, 16 Dec 2022 12:45:36 +0000 (UTC)
Received: by bcodding.csb (Postfix, from userid 24008)
        id B390710C30E1; Fri, 16 Dec 2022 07:45:35 -0500 (EST)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     Guillaume Nault <gnault@redhat.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        Josef Bacik <josef@toxicpanda.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Steve French <sfrench@samba.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: [PATCH net v4 3/3] net: simplify sk_page_frag
Date:   Fri, 16 Dec 2022 07:45:28 -0500
Message-Id: <38d42a20af803cb51178510a64a558bfe9d10ddd.1671194454.git.bcodding@redhat.com>
In-Reply-To: <cover.1671194454.git.bcodding@redhat.com>
References: <cover.1671194454.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that in-kernel socket users that may recurse during reclaim have benn
converted to sk_use_task_frag = false, we can have sk_page_frag() simply
check that value.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/sock.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index fefe1f4abf19..dcd72e6285b2 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2564,19 +2564,14 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
  * Both direct reclaim and page faults can nest inside other
  * socket operations and end up recursing into sk_page_frag()
  * while it's already in use: explicitly avoid task page_frag
- * usage if the caller is potentially doing any of them.
- * This assumes that page fault handlers use the GFP_NOFS flags or
- * explicitly disable sk_use_task_frag.
+ * when users disable sk_use_task_frag.
  *
  * Return: a per task page_frag if context allows that,
  * otherwise a per socket one.
  */
 static inline struct page_frag *sk_page_frag(struct sock *sk)
 {
-	if (sk->sk_use_task_frag &&
-	    (sk->sk_allocation & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC |
-				  __GFP_FS)) ==
-	    (__GFP_DIRECT_RECLAIM | __GFP_FS))
+	if (sk->sk_use_task_frag)
 		return &current->task_frag;
 
 	return &sk->sk_frag;
-- 
2.31.1

