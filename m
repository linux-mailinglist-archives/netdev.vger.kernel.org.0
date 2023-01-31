Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237A9682405
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 06:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjAaFag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 00:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjAaFaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 00:30:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BBF41B6D;
        Mon, 30 Jan 2023 21:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CQYz9YB3giOSRpIimXEFMxgqmfkfwruFek5pOzrb5IQ=; b=JvR8QuquuMwb2FdJFO6IqAmkUN
        tBrsFCSIXyqkvHRM7fZ5u2Yg3NPMsUB4PxUX/qu0v0Y/y56IW2JyHo3ZH+sQn74OeI+wQgRHwm469
        ekItn7tysg17ZoXo4wlDrE+odoN2wcg/QN0iGuhxZacjagKnw/aMq2JYFfGPuFT057WF6LsNJV+MO
        pG5SmCKtbNcmU931OJT8zqoMhqX/QZsBHuLW2VtKp9GTurrJUSgXCqAjzkF+H+0oZnKPQSIf5WWDS
        sHj5zkmFAK0ZxjLLSQoGz0ejpEslLySYtQeDdfyez4NU/l444zvg47QBe/HZXhOo5g6wjc5+Ht4Gj
        7x1ystVw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMjBr-00B2qK-A1; Tue, 31 Jan 2023 05:28:19 +0000
Date:   Tue, 31 Jan 2023 05:28:19 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jakub Kicinski <kuba@kernel.org>
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
Message-ID: <Y9im8+cEyRhQLLfV@casper.infradead.org>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-2-hch@lst.de>
 <20230130204758.38f4c6b9@kernel.org>
 <Y9igcK1d/iGn33pK@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9igcK1d/iGn33pK@casper.infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 05:00:32AM +0000, Matthew Wilcox wrote:
> On Mon, Jan 30, 2023 at 08:47:58PM -0800, Jakub Kicinski wrote:
> > kinda random thought but since we're touching this area - could we
> > perhaps move the definition of struct bio_vec and trivial helpers 
> > like this into a new header? bvec.h pulls in mm.h which is a right
> > behemoth :S
> 
> I bet we can drop mm.h now.  It was originally added for nth_page()
> in 3d75ca0adef4 but those were all removed by b8753433fc61.
> 
> A quick smoke test on my default testing config doesn't find any
> problems.  Let me send a patch and see if the build bots complain.

Disappointingly, it doesn't really change anything.  1134 files
depend on mm.h both before and after [1].  Looks like it's due to
arch/x86/include/asm/cacheflush.h pulling in linux/mm.h, judging by the
contents of .build_test_kernel-x86_64/net/ipv6/.inet6_hashtables.o.cmd.
But *lots* of header files pull in mm.h, including scatterlist.h,
vt_kern.h, net.h, nfs_fs.h, sunrpc/svc.h and security.h.

I suppose it may cut down on include loops to drop it here, so I'm
still in favour of the patch I posted, but this illustrates how
deeply entangled our headers still are.

[1] find .build_test_kernel-x86_64/ -name '.*.cmd' |xargs grep 'include/linux/mm.h' |wc -l
