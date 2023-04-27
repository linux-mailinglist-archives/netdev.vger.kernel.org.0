Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E212F6F0C87
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 21:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343691AbjD0T0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 15:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343609AbjD0T0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 15:26:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC083A91
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 12:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682623511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6RKOOlWWioBpaQB9cIVqDn0lBoM9rOyQ40nRIHqqT98=;
        b=S24l6T2x3A8r2Jmli3kV4A+04PWase+8TzV3Gu3xiWkqrINZrCTL/Xa1VWP9lAY6ESN3/N
        XOgrABD30Oisy6HL3/CGR4vPevRyS7qq/AM/gIvmBHbFFhyy+rLGHuw+IxkNFi7CnYA88T
        g0uP/xSGEfW7C+KPjQz5R0OfXgsvF58=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-Mlcdwb_vNcS1b2U4E0kPUQ-1; Thu, 27 Apr 2023 15:25:08 -0400
X-MC-Unique: Mlcdwb_vNcS1b2U4E0kPUQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ADA6885A588;
        Thu, 27 Apr 2023 19:25:07 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F14B62027043;
        Thu, 27 Apr 2023 19:25:06 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 428B6307372E8;
        Thu, 27 Apr 2023 21:25:06 +0200 (CEST)
Subject: [PATCH RFC net-next/mm V2 0/2] page_pool: new approach for leak
 detection and shutdown phase
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-mm@kvack.org, Mel Gorman <mgorman@techsingularity.net>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, lorenzo@kernel.org,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linyunsheng@huawei.com, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org
Date:   Thu, 27 Apr 2023 21:25:06 +0200
Message-ID: <168262348084.2036355.16294550378793036683.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patchset change summary:
 - Remove PP workqueue and inflight warnings, instead rely on inflight
   pages to trigger cleanup
 - Moves leak detection to the MM-layer page allocator when combined
   with CONFIG_DEBUG_VM.

The page_pool (PP) workqueue calling page_pool_release_retry generate
too many false-positive reports. Further more, these reports of
page_pool shutdown still having inflight packets are not very helpful
to track down the root-cause.

In the past these reports have helped us catch driver bugs, that
leaked pages by invoking put_page directly, often in code paths
handling error cases. PP pages had a shorter lifespan (within driver
and XDP code paths). Since PP pages got a recycle return path for
SKBs, the lifespan for a PP page can be much longer. Thus, it is time
to revisit periodic release retry mechanism. The default 60 sec
lifespan assumption is obviously wrong/obsolete, as things like TCP
sockets can keep SKBs around for much longer (e.g. retransmits,
timeouts, NAPI defer schemes etc).

The inflight reports, means one of two things: (1) API user is still
holding on, or (2) page got leaked and will never be returned to PP.
The PP need to accept it have no control over (1) how long outstanding
PP pages are kept by the API users. What we really want to is to catch
are(2) pages that "leak". Meaning they didn't get proper returned via
PP APIs.

Leaked PP pages result in these issues: (A) We can never release
page_pool memory structs, which (B) holds on to a refcnt on struct
device for DMA mapping, and (C) leaking DMA-mappings that (D) means a
hardware device can potentially write into a page returned to the page
allocator.

V2: Fix race found by Yunsheng Lin <linyunsheng@huawei.com>

---

Jesper Dangaard Brouer (2):
      page_pool: Remove workqueue in new shutdown scheme
      mm/page_pool: catch page_pool memory leaks


 include/net/page_pool.h |   9 ++--
 mm/page_alloc.c         |   7 +++
 net/core/page_pool.c    | 100 +++++++++++++++++++++++++---------------
 3 files changed, 73 insertions(+), 43 deletions(-)

--
Jesper

