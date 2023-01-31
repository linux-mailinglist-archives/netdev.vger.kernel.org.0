Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524AA68239B
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 06:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjAaFBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 00:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjAaFBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 00:01:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C14241EA;
        Mon, 30 Jan 2023 21:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HeiethKseVGJ70/5PjRlX5YDB3+nnc26Ua2pXcSZvpo=; b=Q5zfNh/EB2Bmq7oWjxZpT6+msk
        Wru/DAC5G3Ah5BIaBZRlzZAeO/DNnzrkJTotw+xknA145DoaVDP0PapXQz9haLCp6JFInHd1m/Gq0
        Ugh3dsiSMTuuFZDfTCVfD5u3uqBFHZNFvaNOEf6GBWhQrOrUuRM/LfCeHe1ih3TKWB/32GnPqOt0M
        +KS/+gertHCfno38+Xr4AT42h2GV1/Lh8Psc34Ane6VpgoKN86DPzQO3EbFQEM4/mJ4G+4ucfZfY3
        NPYL3uNiTdgqjKCEqIT2kmWqSZZmNNoBtb5mihNp+8SSg7Q7Ae2AfDTQFg5YePXBH3WHd0Kojkyq6
        mP4yNoNg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMiky-00B1Pp-3D; Tue, 31 Jan 2023 05:00:32 +0000
Date:   Tue, 31 Jan 2023 05:00:32 +0000
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
Message-ID: <Y9igcK1d/iGn33pK@casper.infradead.org>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-2-hch@lst.de>
 <20230130204758.38f4c6b9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130204758.38f4c6b9@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 08:47:58PM -0800, Jakub Kicinski wrote:
> kinda random thought but since we're touching this area - could we
> perhaps move the definition of struct bio_vec and trivial helpers 
> like this into a new header? bvec.h pulls in mm.h which is a right
> behemoth :S

I bet we can drop mm.h now.  It was originally added for nth_page()
in 3d75ca0adef4 but those were all removed by b8753433fc61.

A quick smoke test on my default testing config doesn't find any
problems.  Let me send a patch and see if the build bots complain.
