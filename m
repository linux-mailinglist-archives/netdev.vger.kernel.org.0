Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A43B65F059
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 16:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbjAEPnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 10:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbjAEPnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 10:43:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C405E09E
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 07:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672933365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2P9wk1S9E8QZ3lePJZo9dmltEt7LKewD/Zys3LGcGXg=;
        b=Rx6MRNAPpbhigj2poM+1onw0LXEIHJi08upRldGCkDbUtgityoq2verRDlwdktwST63Q0o
        YAtdI0jDbjorEI0LYppkjJ+BA/5KPqkjX+aepVtP4zQ9Fb3uUtrLJXvaSZnWb5S57hXFHk
        U3C5dLbcRWpxNshvco97YpuYvUAjPm4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-_scvoTZbPnW0UTS_YMyzSQ-1; Thu, 05 Jan 2023 10:42:39 -0500
X-MC-Unique: _scvoTZbPnW0UTS_YMyzSQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D32518E6201;
        Thu,  5 Jan 2023 15:42:39 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-34.brq.redhat.com [10.40.208.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCF931121314;
        Thu,  5 Jan 2023 15:42:38 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id BF78B30721A6C;
        Thu,  5 Jan 2023 16:42:37 +0100 (CET)
Subject: [PATCH net-next 0/2] net: use kmem_cache_free_bulk in kfree_skb_list
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Date:   Thu, 05 Jan 2023 16:42:37 +0100
Message-ID: <167293333469.249536.14941306539034136264.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kfree_skb_list function walks SKB (via skb->next) and frees them
individually to the SLUB/SLAB allocator (kmem_cache). It is more
efficient to bulk free them via the kmem_cache_free_bulk API.

Netstack NAPI fastpath already uses kmem_cache bulk alloc and free
APIs for SKBs.

The kfree_skb_list call got an interesting optimization in commit
520ac30f4551 ("net_sched: drop packets after root qdisc lock is
released") that can create a list of SKBs "to_free" e.g. when qdisc
enqueue fails or deliberately chooses to drop . It isn't a normal data
fastpath, but the situation will likely occur when system/qdisc are
under heavy workloads, thus it makes sense to use a faster API for
freeing the SKBs.

E.g. the (often distro default) qdisc fq_codel will drop batches of
packets from fattest elephant flow, default capped at 64 packets (but
adjustable via tc argument drop_batch).

---

Jesper Dangaard Brouer (2):
      net: fix call location in kfree_skb_list_reason
      net: kfree_skb_list use kmem_cache_free_bulk


 net/core/skbuff.c | 67 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 56 insertions(+), 11 deletions(-)

--

