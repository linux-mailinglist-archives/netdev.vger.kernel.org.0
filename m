Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CA9674054
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjASRu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjASRus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:50:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3078AF76B
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 09:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674150605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PHBxulZsM33HQC4VRd0nBemxtBNmGGXakB15JT7+a7M=;
        b=WmYEVInUVWxZQWOHG7zuUFEtNBGkR+D0GgGQiSx/P2Nxu/FEZo56WOe6CwpAzawbxVwOAz
        tosGLsvc1tX9LhTZfQhwpIte/Zz63fqx9XfsHmBqXp2niLbKuFoofmDB85uEqOyZHBUffZ
        cLCl5XSp3pRjM6haduX3lTPUCdAzz/4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-Bi9CFGr8M1W9IEIuXwtsHQ-1; Thu, 19 Jan 2023 12:50:02 -0500
X-MC-Unique: Bi9CFGr8M1W9IEIuXwtsHQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A66052A59575;
        Thu, 19 Jan 2023 17:50:01 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-34.brq.redhat.com [10.40.208.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6114051EF;
        Thu, 19 Jan 2023 17:50:01 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 5930730721A6C;
        Thu, 19 Jan 2023 18:50:00 +0100 (CET)
Subject: [PATCH net-next] net: fix kfree_skb_list use of skb_mark_not_on_list
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com,
        syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
Date:   Thu, 19 Jan 2023 18:50:00 +0100
Message-ID: <167415060025.1124471.10712199130760214632.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A bug was introduced by commit eedade12f4cb ("net: kfree_skb_list use
kmem_cache_free_bulk"). It unconditionally unlinked the SKB list via
invoking skb_mark_not_on_list().

The skb_mark_not_on_list() should only be called if __kfree_skb_reason()
returns true, meaning the SKB is ready to be free'ed, as it calls/check
skb_unref().

This is needed as kfree_skb_list() is also invoked on skb_shared_info
frag_list. A frag_list can have SKBs with elevated refcnt due to cloning
via skb_clone_fraglist(), which takes a reference on all SKBs in the
list. This implies the invariant that all SKBs in the list must have the
same refcnt, when using kfree_skb_list().

Reported-by: syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
Fixes: eedade12f4cb ("net: kfree_skb_list use kmem_cache_free_bulk")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/skbuff.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4e73ab3482b8..1bffbcbe6087 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -999,10 +999,10 @@ kfree_skb_list_reason(struct sk_buff *segs, enum skb_drop_reason reason)
 	while (segs) {
 		struct sk_buff *next = segs->next;
 
-		skb_mark_not_on_list(segs);
-
-		if (__kfree_skb_reason(segs, reason))
+		if (__kfree_skb_reason(segs, reason)) {
+			skb_mark_not_on_list(segs);
 			kfree_skb_add_bulk(segs, &sa, reason);
+		}
 
 		segs = next;
 	}


