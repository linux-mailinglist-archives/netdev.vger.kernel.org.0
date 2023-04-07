Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F686DA6B7
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 02:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbjDGAyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 20:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjDGAyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 20:54:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39AC93EA;
        Thu,  6 Apr 2023 17:54:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 625CF64DD2;
        Fri,  7 Apr 2023 00:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C35C433D2;
        Fri,  7 Apr 2023 00:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680828876;
        bh=uvT44qx5YO7bon6aMmqTeZtryVy3J03QEXu1FpcUChw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gb3r4KSO9gRu1kunqKSKRVILUWmx2/w1729zO1bnmOFwGTjK8Ft7VgeVIqQTRYktv
         IWoDAI4k/MGasNqIg8yOC4EaHRFW3OexmHky+FTATmWwQPv0fuyPhD9KqpUrJdUZvy
         04jSqe8Mz+djYDYAxW63CiCRaFAhGWCyS7LpVaX5D/mfbaRIUmoNGKxiZhnx++WVAf
         0Hlc/LhrSf7+y2+OvyhZRwCWgXuEjgUquY5PkBpHS6jI2oxJ0oTdmh9/bpv7XFAxsC
         dkHpoI3IwMJoz2Lwc/5kivXju8kVrsuuL0xWPpJK8r4SLNxcjeTU1NMtBFmuDOtKIE
         XV9HKRzNQ6t1Q==
Date:   Thu, 6 Apr 2023 17:54:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
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
Subject: Re: [PATCH net-next v5 03/19] mm: Make the page_frag_cache
 allocator use multipage folios
Message-ID: <20230406175434.0d74bbcc@kernel.org>
In-Reply-To: <20230406094245.3633290-4-dhowells@redhat.com>
References: <20230406094245.3633290-1-dhowells@redhat.com>
        <20230406094245.3633290-4-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Apr 2023 10:42:29 +0100 David Howells wrote:
> Change the page_frag_cache allocator to use multipage folios rather than
> groups of pages.  This reduces page_frag_free to just a folio_put() or
> put_page().

drivers/nvme/host/tcp.c:1315:15: warning: unused variable 'page' [-Wunused-variable]
        struct page *page;
                     ^

drivers/net/ethernet/mediatek/mtk_wed_wo.c:306:15: warning: unused variable 'page' [-Wunused-variable]
        struct page *page;
                     ^
