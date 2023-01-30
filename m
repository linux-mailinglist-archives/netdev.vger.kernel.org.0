Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECEE6815E8
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbjA3QEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjA3QES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:04:18 -0500
X-Greylist: delayed 470 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Jan 2023 08:04:16 PST
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716E311156;
        Mon, 30 Jan 2023 08:04:16 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id AF6077FC21;
        Mon, 30 Jan 2023 15:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1675094184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9mWu6waa/eExAxYRUAnoTwItAGCpuazH4rLKqgG96C8=;
        b=IUWRXB4ZfZFvP08TAcu46IaSIPcqcOXTl56O8WHSQOaAhhkIQ9u88zYSEpIN2pbiC4jpac
        jwGLtOnkbS+BV6uGbYvUTH2ghLzufe3qfEFRbAHRz9p2wIlhENt9DpUj0oE60tlK+yywCT
        paOb0uNIIGHUk9S0XG3mYKsUFRPaYkoUgAjTvyhLEVU5Z9Cvmu7NO+rjrH2opN+EgEjgFa
        fnzP4VIRAyAwr2ru+CZp9aX3dvfrMSXIvEWmaEh/hC29vO//ntKkMtDT6T0I20V2zRFjSn
        4AWbxuRM00n7wzPS9dmDdPu7fsBiZbJIvRcLAZa39v75gFyA93kfj3o+j2QjPg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
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
        Jakub Kicinski <kuba@kernel.org>,
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
Subject: Re: [PATCH 13/23] cifs: use bvec_set_page to initialize bvecs
In-Reply-To: <20230130092157.1759539-14-hch@lst.de>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-14-hch@lst.de>
Date:   Mon, 30 Jan 2023 12:56:16 -0300
Message-ID: <87357shv8f.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> Use the bvec_set_page helper to initialize bvecs.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/cifs/connect.c |  5 +++--
>  fs/cifs/fscache.c | 16 ++++++----------
>  fs/cifs/misc.c    |  5 ++---
>  fs/cifs/smb2ops.c |  6 +++---
>  4 files changed, 14 insertions(+), 18 deletions(-)

Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
