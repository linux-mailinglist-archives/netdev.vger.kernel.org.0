Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD2764B3EA
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 12:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbiLMLMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 06:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235157AbiLMLLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 06:11:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328371B1CA
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 03:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670929854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hI9mkHM5G9CEeZi4cKUF2sfIUfrvw+F8X2egulstA/A=;
        b=gkXamDCrUbGQPb3uBGfAHITwuqjgNHEiQFMr5ZHciFmGxOdeb/vRXGrJU+l1kSX9nXys6H
        2LzkKvvkHnn0OxtL0/5MBYRGQZD+MSV+IUKti506LHrfF5KdqwORIC7K2ryqyqO4tnEJlM
        x08FVqlP+sSQNg8huoAp8gOmn43KGaw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-Zzl3kFftO92a9axNpnqtDQ-1; Tue, 13 Dec 2022 06:10:51 -0500
X-MC-Unique: Zzl3kFftO92a9axNpnqtDQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 119F48039A2;
        Tue, 13 Dec 2022 11:10:50 +0000 (UTC)
Received: from bcodding.csb (unknown [10.22.50.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CED92492B00;
        Tue, 13 Dec 2022 11:10:49 +0000 (UTC)
Received: by bcodding.csb (Postfix, from userid 24008)
        id 7BB5A10C30E0; Tue, 13 Dec 2022 06:10:47 -0500 (EST)
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
Subject: [PATCH net v3 3/3] net: simplify sk_page_frag
Date:   Tue, 13 Dec 2022 06:10:39 -0500
Message-Id: <04b821e6fa644638eab6e2ac9d4720a88c0f9785.1670929442.git.bcodding@redhat.com>
In-Reply-To: <cover.1670929442.git.bcodding@redhat.com>
References: <cover.1670929442.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
index 44380c6dc6c4..8e23c6d5e899 100644
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

