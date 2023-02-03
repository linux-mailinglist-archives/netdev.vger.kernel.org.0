Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6237689D52
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbjBCPHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233752AbjBCPHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:07:32 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090CDA0EA5;
        Fri,  3 Feb 2023 07:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=xaXfHvtmirT//H/Mo9JZTCfopwE0ARO2STlU1q4PXIU=; b=LwFg4o7FNRjNvzeL1UIeY+PB30
        pigk8LO6ghAV/PW8A2diZklP7ONPkf/QuZ1j8F2QHoj76RmFvj/Q8pZxLQNZCU995h2ds4C/fgoU6
        vJrgHAy3JyTeMQU3sBiEJ2k75Q4WOqSb0agWbK9kpPxrkSUpCMcMfqkAl8xQSVnMiGJsWds5MEA0/
        ttVela2LE/82AgMzn2QpTZPgzNm+u+iJUJj6KJXJcu0gz4sOsbBmYQNi3tJoXH33FBOPEsxVAF/p5
        5brK/jfAn9M2GdavX3Sg69iNnol9jENDgRqr7idObKYZRPtBjJSz+TRjAv8KvwNM3XfV2T+AE+LX+
        QYoCj3mg==;
Received: from [2001:4bb8:19a:272a:910:bb67:7287:f956] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pNxe8-002abR-B0; Fri, 03 Feb 2023 15:06:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
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
Subject: add bvec initialization helpers v2
Date:   Fri,  3 Feb 2023 16:06:11 +0100
Message-Id: <20230203150634.3199647-1-hch@lst.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

this series adds the helpers to initalize a bvec.  These remove open coding of
bvec internals and help with experimenting with other representations like
a phys_addr_t instead of page + offset.

Changes since v1:
 - fix a typo
 - simplify the code in ceph's __iter_get_bvecs a little bit further
 - fix two subject prefixes

Diffstat:
 block/bio-integrity.c             |    7 ------
 block/bio.c                       |   12 +----------
 drivers/block/rbd.c               |    7 ++----
 drivers/block/virtio_blk.c        |    4 ---
 drivers/block/zram/zram_drv.c     |   15 +++-----------
 drivers/nvme/host/core.c          |    4 ---
 drivers/nvme/target/io-cmd-file.c |   10 +--------
 drivers/nvme/target/tcp.c         |    5 +---
 drivers/scsi/sd.c                 |   36 ++++++++++++++++------------------
 drivers/target/target_core_file.c |   18 +++++------------
 drivers/vhost/vringh.c            |    5 +---
 fs/afs/write.c                    |    8 ++-----
 fs/ceph/file.c                    |   12 +++--------
 fs/cifs/connect.c                 |    5 ++--
 fs/cifs/fscache.c                 |   16 +++++----------
 fs/cifs/misc.c                    |    5 +---
 fs/cifs/smb2ops.c                 |    6 ++---
 fs/coredump.c                     |    7 +-----
 fs/nfs/fscache.c                  |   16 +++++----------
 fs/orangefs/inode.c               |   22 ++++++--------------
 fs/splice.c                       |    5 +---
 include/linux/bvec.h              |   40 ++++++++++++++++++++++++++++++++++++++
 io_uring/rsrc.c                   |    4 ---
 mm/page_io.c                      |    8 +------
 net/ceph/messenger_v1.c           |    7 +-----
 net/ceph/messenger_v2.c           |   28 ++++++++++----------------
 net/rxrpc/rxperf.c                |    8 ++-----
 net/sunrpc/svcsock.c              |    7 +-----
 net/sunrpc/xdr.c                  |    5 +---
 29 files changed, 142 insertions(+), 190 deletions(-)
