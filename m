Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921D8669930
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 14:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241483AbjAMNzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 08:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240603AbjAMNzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 08:55:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE2A6085E
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 05:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673617919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QXTffDYYJCXYBqBf0FqQRae4Pnf8pp6FZUyduUKOU38=;
        b=ZEsVEX6MY6VpBIyJHSRgDaAEbtZZdFLs32fhPdFzDuaAZxj/70I+Mvm4rw1NBODhDB4mBn
        5zruCRaX5jHlFDevaZa4a1GwiUNCaPTx4NAHRCIRoyEOBxZNajDXaGlSoiYDLOV7Pn+MqZ
        4JEERJif0RKzP9mWw4jX9JnAB7BXkXM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-ixhFJkc-Obq2pY4kl4RO8w-1; Fri, 13 Jan 2023 08:51:56 -0500
X-MC-Unique: ixhFJkc-Obq2pY4kl4RO8w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA78B3C0D85E;
        Fri, 13 Jan 2023 13:51:55 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-34.brq.redhat.com [10.40.208.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89DE34078904;
        Fri, 13 Jan 2023 13:51:55 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 86CCD30721A6C;
        Fri, 13 Jan 2023 14:51:54 +0100 (CET)
Subject: [PATCH net-next V2 0/2] net: use kmem_cache_free_bulk in
 kfree_skb_list
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Date:   Fri, 13 Jan 2023 14:51:54 +0100
Message-ID: <167361788585.531803.686364041841425360.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

Performance measurements done in [1]:
 [1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/kfree_skb_list01.org

---

Jesper Dangaard Brouer (2):
      net: fix call location in kfree_skb_list_reason
      net: kfree_skb_list use kmem_cache_free_bulk


 net/core/skbuff.c | 68 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 57 insertions(+), 11 deletions(-)

--

