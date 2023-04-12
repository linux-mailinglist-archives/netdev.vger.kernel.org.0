Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD24F6DFA27
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 17:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjDLPcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 11:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjDLPcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 11:32:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4ACC65A6;
        Wed, 12 Apr 2023 08:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jVIUX30CHSeuMRIZ4MbX/VFPgD+9bUpANKvI3RmLVRc=; b=y5JRgZIJ8RY6GdBqYVEE/YVMEp
        dqmS2vYU/39+lDvSEZChJo8KFFmv8H+CObQ8w7xEEbiDMJhtF/yb+Sl/X5fUSnZLlwk5OQrb+Uu7o
        ZkIPfe/2ZZeZXXOqAzImp8FRwvcc9X0cS72YSeedaNoOOZNDB5A+r6WbRAOn5ceLv6Me3d41Soyoe
        BJBLTcoAnPbOOhKgq5tMK0+vkFJBKfg8+/OO9XGGllNz7hfJ5qiiEcg6g9PP3Or4q28T5+OLNIggI
        i48okYGNvg3shRsABwU6JgMeVEKYWVJtUTT6ZRFivxtjHE15fUaUidKVR+Nc1Uxpghun2l+zXXadg
        v88nBQMw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pmcRi-003dp9-1Q;
        Wed, 12 Apr 2023 15:31:42 +0000
Date:   Wed, 12 Apr 2023 08:31:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        Shailend Chand <shailend@google.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH net-next v6 04/18] mm: Make the page_frag_cache allocator
 use per-cpu
Message-ID: <ZDbO3haK/1+7xdRC@infradead.org>
References: <20230411160902.4134381-1-dhowells@redhat.com>
 <20230411160902.4134381-5-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411160902.4134381-5-dhowells@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 05:08:48PM +0100, David Howells wrote:
> Make the page_frag_cache allocator have a separate allocation bucket for
> each cpu to avoid racing.  This means that no lock is required, other than
> preempt disablement, to allocate from it, though if a softirq wants to
> access it, then softirq disablement will need to be added.

Can you show any performance numbers?

> Make the NVMe, mediatek and GVE drivers pass in NULL to page_frag_cache()
> and use the default allocation buckets rather than defining their own.

Let me ask a third time as I've not got an answer the last two times:
why are these callers treated different from the others?

