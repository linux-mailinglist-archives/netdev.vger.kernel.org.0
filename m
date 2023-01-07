Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83971660BF3
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 03:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjAGC3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 21:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjAGC3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 21:29:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC361EAC6
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 18:29:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3A0FB81EBA
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 02:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEBFC433D2;
        Sat,  7 Jan 2023 02:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673058550;
        bh=lOYpsjbsy/7f18JnH362xjIVkwIljRJpnMq/C2qCx18=;
        h=From:To:Cc:Subject:Date:From;
        b=kwJCtMtYLOccofCD9WCJ6Lb5naRYzbVXVeMCib2Yr2XIsJPNuK5JdyAWq8gGO7Zoc
         8HTHCCJ5n+i5kXbAWLG31KSJmT9mL5VpyyG939D3sXlblmWBsqqYqOzk5IHxdWHFrp
         FiXHvCi1wGkF5QiKh3Ms/djdXm9wQ8rnhXjPLJdjFYZ+/RMtHwOENA4U5Pp/XKulNd
         jKsOm2HMW8IbUXLHykVDzJD6u1iKsGkd7vI8JCp+vbC+mmHLrz2dyTL4Mjceqmc10w
         V0LUiIXMFZGMoQ6drw6EvqJwGK5iQzgA5rNCGSY1LHDl4bncsHPW8Jx9IXywwLERpR
         /IId8MUilmUug==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: skb: remove old comments about frag_size for build_skb()
Date:   Fri,  6 Jan 2023 18:29:04 -0800
Message-Id: <20230107022904.582051-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit ce098da1497c ("skbuff: Introduce slab_build_skb()")
drivers trying to build skb around slab-backed buffers should
go via slab_build_skb() rather than passing frag_size = 0 to
the main build_skb().

Remove the copy'n'pasted comments about 0 meaning slab.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/skbuff.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4a0eb5593275..3a10387f9434 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -386,8 +386,6 @@ struct sk_buff *__build_skb(void *data, unsigned int frag_size)
 
 /* build_skb() is wrapper over __build_skb(), that specifically
  * takes care of skb->head and skb->pfmemalloc
- * This means that if @frag_size is not zero, then @data must be backed
- * by a page fragment, not kmalloc() or vmalloc()
  */
 struct sk_buff *build_skb(void *data, unsigned int frag_size)
 {
@@ -406,7 +404,7 @@ EXPORT_SYMBOL(build_skb);
  * build_skb_around - build a network buffer around provided skb
  * @skb: sk_buff provide by caller, must be memset cleared
  * @data: data buffer provided by caller
- * @frag_size: size of data, or 0 if head was kmalloced
+ * @frag_size: size of data
  */
 struct sk_buff *build_skb_around(struct sk_buff *skb,
 				 void *data, unsigned int frag_size)
@@ -428,7 +426,7 @@ EXPORT_SYMBOL(build_skb_around);
 /**
  * __napi_build_skb - build a network buffer
  * @data: data buffer provided by caller
- * @frag_size: size of data, or 0 if head was kmalloced
+ * @frag_size: size of data
  *
  * Version of __build_skb() that uses NAPI percpu caches to obtain
  * skbuff_head instead of inplace allocation.
@@ -452,7 +450,7 @@ static struct sk_buff *__napi_build_skb(void *data, unsigned int frag_size)
 /**
  * napi_build_skb - build a network buffer
  * @data: data buffer provided by caller
- * @frag_size: size of data, or 0 if head was kmalloced
+ * @frag_size: size of data
  *
  * Version of __napi_build_skb() that takes care of skb->head_frag
  * and skb->pfmemalloc when the data is a page or page fragment.
-- 
2.38.1

