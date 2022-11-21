Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47166323E6
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiKUNhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiKUNgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:36:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB62C0527
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669037743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mAyhqD1wQb+vA4DuCjO+sKuXXQHamchXQO5xWy2o6/w=;
        b=PmwDPDyfLIeE3O87bt8PQ5ofUu4hjghHEVdD6cN8OvvjQFpB3lZAyeAk1LlxfBglhg9AOz
        cS+E14Bbt8OpkrvDVjkB6jJIaiD2znr6lovrw8c+3OlNwFOYOP7C0VMnckBjBA0iR9jZtn
        m0qHaaaHIieSVhyXSIK/kOMXcoe86zU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-5JC7UypcMsWV8m8xtqhKjw-1; Mon, 21 Nov 2022 08:35:40 -0500
X-MC-Unique: 5JC7UypcMsWV8m8xtqhKjw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5C4B3C10147;
        Mon, 21 Nov 2022 13:35:39 +0000 (UTC)
Received: from bcodding.csb (unknown [10.22.50.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D85EC15BB3;
        Mon, 21 Nov 2022 13:35:39 +0000 (UTC)
Received: by bcodding.csb (Postfix, from userid 24008)
        id 19BD110C30E3; Mon, 21 Nov 2022 08:35:36 -0500 (EST)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v1 3/3] net: simplify sk_page_frag
Date:   Mon, 21 Nov 2022 08:35:19 -0500
Message-Id: <79b1009812b753c3a82d09271c4d655d644d37a6.1669036433.git.bcodding@redhat.com>
In-Reply-To: <cover.1669036433.git.bcodding@redhat.com>
References: <cover.1669036433.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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
index ffba9e95470d..fac24c6ee30d 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2539,19 +2539,14 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
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

