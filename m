Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7667367529D
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 11:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjATKfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 05:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjATKfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 05:35:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B83561BC
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674210898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=a1oLV1CGniA/YYPQkFcz+2dVcvAyRiZqseuy6OqvH9k=;
        b=MYlZ6R9CgmVXvh93lZcx0YImv/1GwgcqyuSxCX25NrQNA4lNa21NkFhyw8Soo+EC1bZcOj
        eo2wye5FsqzxaDN+X6hnCMiMb1Hl6id2l72YoMezWI0ruE4oWbWdXaH9X97fMDI/aJ5mvp
        NB3apbA9FUmmp7h5ML0PJJYuBreE4Yw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-yAvjEi2UOMmkd-Tk0Agxvw-1; Fri, 20 Jan 2023 05:34:46 -0500
X-MC-Unique: yAvjEi2UOMmkd-Tk0Agxvw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2C5B183B3C1;
        Fri, 20 Jan 2023 10:34:45 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-34.brq.redhat.com [10.40.208.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B9E939D93;
        Fri, 20 Jan 2023 10:34:45 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 4473E300003EB;
        Fri, 20 Jan 2023 11:34:44 +0100 (CET)
Subject: [PATCH net-next V2] net: fix kfree_skb_list use of
 skb_mark_not_on_list
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com,
        syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
Date:   Fri, 20 Jan 2023 11:34:44 +0100
Message-ID: <167421088417.1125894.9761158218878962159.stgit@firesoul>
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

In this patch we choose to remove the skb_mark_not_on_list() call as it
isn't necessary. It would be possible and correct to call
skb_mark_not_on_list() only when __kfree_skb_reason() returns true,
meaning the SKB is ready to be free'ed, as it calls/check skb_unref().

This fix is needed as kfree_skb_list() is also invoked on skb_shared_info
frag_list (skb_drop_fraglist() calling kfree_skb_list()). A frag_list can
have SKBs with elevated refcnt due to cloning via skb_clone_fraglist(),
which takes a reference on all SKBs in the list. This implies the
invariant that all SKBs in the list must have the same refcnt, when using
kfree_skb_list().

Reported-by: syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
Fixes: eedade12f4cb ("net: kfree_skb_list use kmem_cache_free_bulk")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/skbuff.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4e73ab3482b8..180df58e85c7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -999,8 +999,6 @@ kfree_skb_list_reason(struct sk_buff *segs, enum skb_drop_reason reason)
 	while (segs) {
 		struct sk_buff *next = segs->next;
 
-		skb_mark_not_on_list(segs);
-
 		if (__kfree_skb_reason(segs, reason))
 			kfree_skb_add_bulk(segs, &sa, reason);
 


