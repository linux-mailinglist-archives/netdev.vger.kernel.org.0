Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819036D8060
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 17:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbjDEPFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 11:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238232AbjDEPFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 11:05:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09121CE;
        Wed,  5 Apr 2023 08:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=48zfX+R4D/KjMsx+hDA/cvkhA+0xsbJ5NdemC9lhYPY=; b=B02mlYlJo8YnMyQr/pWc9OnEnq
        vEJIGspvLVhFvrfqZuBhFZHYfgv7nUd/IPKRXT9kbgCspMF2tMgWY0+bN3DfUsk/13eXXorMhzvmV
        7ntFHGEVgjLr8cf4FiuTOtAXT59DJ4KFaYmyDbti6ZboZJRfRoXeAW/d3H6CudDLC5+nCdO24mnNR
        UfohHx/9mrphbQjnBPzo1WAs2C36jcLVaNglLHuXQ/ABCkjwzCKDifjQJ9P885VG0STzpw4Ib+raR
        tdyvGBLga1M53Hj0uKOomN1uzFQFf/13OisHdpxe4VkTj//an2R3WqqmRoE1A+0h4rMALfGY/ZdiR
        oVVnJqpA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pk4gy-004kve-08;
        Wed, 05 Apr 2023 15:04:56 +0000
Date:   Wed, 5 Apr 2023 08:04:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v3 06/55] mm: Make the page_frag_cache allocator use
 per-cpu
Message-ID: <ZC2OGCxXj2QfQhtJ@infradead.org>
References: <20230331160914.1608208-1-dhowells@redhat.com>
 <20230331160914.1608208-7-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331160914.1608208-7-dhowells@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 05:08:25PM +0100, David Howells wrote:
> Make the page_frag_cache allocator have a separate allocation bucket for
> each cpu to avoid racing.  This means that no lock is required, other than
> preempt disablement, to allocate from it, though if a softirq wants to
> access it, then softirq disablement will need to be added.

Can you split this into a separte series?  Right now I only see this
patch in mbox and miss the context on why wed want this.

> Make the NVMe and mediatek drivers pass in NULL to page_frag_cache() and
> use the default allocation buckets rather than defining their own.

Can you explain why?
