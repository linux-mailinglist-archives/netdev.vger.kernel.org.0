Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F18682438
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 06:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbjAaFwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 00:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjAaFwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 00:52:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521DC3B668;
        Mon, 30 Jan 2023 21:52:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C130EB81184;
        Tue, 31 Jan 2023 05:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037AAC433EF;
        Tue, 31 Jan 2023 05:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675144323;
        bh=wTgpW3dGevgcZKu/B5uphunmPqdkcXShhOveP7IOk1g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ppdnbqD0OAQMoEFgckylfI9L515y55Qro5OxF6u1pWh6KN8rP49ITU+tmDJReCtYg
         uQEeXluan0n2M2y3H2IKqnNt4YOlz8jwX7u0nMfjRxTYGr9dErSmaz8bAWMZdZliaT
         yK5TbcOOdTMAfCsWcsLkPqtdk4JC4UgRM6mrK5iKICBsPSiHKOliUIEebepQtdOaXI
         tynKkh7UvcMYmjAMiRxIUzmwY8hVKbiPo8rdHiCFAGgrt56xYFFXfRVdhTq+KXclxy
         7Q9dga8dFPK/VTZRd/v+Q9bPtWy8ipxJ6FaihlxkJ25ft0o8OM2rPTvLq4dSPbibET
         smIB6luOzvshw==
Date:   Mon, 30 Jan 2023 21:52:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>, Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 01/23] block: factor out a bvec_set_page helper
Message-ID: <20230130215200.0d0eaf66@kernel.org>
In-Reply-To: <Y9im8+cEyRhQLLfV@casper.infradead.org>
References: <20230130092157.1759539-1-hch@lst.de>
        <20230130092157.1759539-2-hch@lst.de>
        <20230130204758.38f4c6b9@kernel.org>
        <Y9igcK1d/iGn33pK@casper.infradead.org>
        <Y9im8+cEyRhQLLfV@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Jan 2023 05:28:19 +0000 Matthew Wilcox wrote:
> > I bet we can drop mm.h now.  It was originally added for nth_page()
> > in 3d75ca0adef4 but those were all removed by b8753433fc61.
> > 
> > A quick smoke test on my default testing config doesn't find any
> > problems.  Let me send a patch and see if the build bots complain.  
> 
> Disappointingly, it doesn't really change anything.  1134 files
> depend on mm.h both before and after [1].  Looks like it's due to
> arch/x86/include/asm/cacheflush.h pulling in linux/mm.h, judging by the
> contents of .build_test_kernel-x86_64/net/ipv6/.inet6_hashtables.o.cmd.
> But *lots* of header files pull in mm.h, including scatterlist.h,
> vt_kern.h, net.h, nfs_fs.h, sunrpc/svc.h and security.h.
> 
> I suppose it may cut down on include loops to drop it here, so I'm
> still in favour of the patch I posted, but this illustrates how
> deeply entangled our headers still are.

+1 it's a bit of a chicken and an egg problem. Until mm.h is gone 
from bvec there's no point removing other headers which pull it in 
to skbuff.h.
