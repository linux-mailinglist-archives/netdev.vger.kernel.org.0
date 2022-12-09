Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87172648861
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 19:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiLISVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 13:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiLISUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 13:20:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6591AA1D
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 10:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670609990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V/w30f9SkTUVDHK6i30ml4/BX4Rz/Na86rURXxxoeIo=;
        b=XP6axeVWgpNYrQh0z9+T92TmtDpnAaZZpO2YDzGz7q+mSEKMFLQWgiIGY7JwOp01RS8gwl
        ZnPOeR3al4TcLjIbWoRj0y2wSHgPfugUGCeusGENzcg4P1xp6UFzh1MNSt+CagvhJnOZSu
        vbuiq5c3wlEG5KLMxiiBiI8zj/8nSWk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-3P1FfrzeOHSCJNAXUUCuNg-1; Fri, 09 Dec 2022 13:19:44 -0500
X-MC-Unique: 3P1FfrzeOHSCJNAXUUCuNg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF71D185A7AD;
        Fri,  9 Dec 2022 18:19:42 +0000 (UTC)
Received: from bcodding.csb (unknown [10.22.50.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB444C16922;
        Fri,  9 Dec 2022 18:19:41 +0000 (UTC)
Received: by bcodding.csb (Postfix, from userid 24008)
        id 4F18A10C3101; Fri,  9 Dec 2022 13:19:39 -0500 (EST)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Philipp Reisner <philipp.reisner@linbit.com>,
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
Subject: [PATCH net v2 3/3] net: simplify sk_page_frag
Date:   Fri,  9 Dec 2022 13:19:25 -0500
Message-Id: <392d4a3cf4948af266d0cb02934d17c599787a56.1670609077.git.bcodding@redhat.com>
In-Reply-To: <cover.1670609077.git.bcodding@redhat.com>
References: <cover.1670609077.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
---
 include/net/sock.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 1bdba14c208f..a705cefc96f0 100644
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

