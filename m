Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD31164B3E7
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 12:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbiLMLM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 06:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235364AbiLMLLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 06:11:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41ECD1146A
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 03:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670929849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=M0e9HVP7QSvh2aSmzFOzNPfVb5oLm5eou4kVigVxLRo=;
        b=QplCt/fJAxXcPpThZMEf8qSoDD8ZyXA9vBXrv6jfuqHwLzzsLEzxdW1qlwXvccLI8ZjrSY
        cKeecouurxjblWdTuIYMkEGYQY1N6iQI5D3bF5kK1VMyiDaSVUZgcDkjezRdAGh8SgTt/o
        5LyXBvZmLtCFHfHWCiDJYXLgEddiAPg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-qycAe3MRPZumVk5ZtPd17Q-1; Tue, 13 Dec 2022 06:10:48 -0500
X-MC-Unique: qycAe3MRPZumVk5ZtPd17Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD1D33C0F246;
        Tue, 13 Dec 2022 11:10:46 +0000 (UTC)
Received: from bcodding.csb (unknown [10.22.50.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEC2A1121315;
        Tue, 13 Dec 2022 11:10:45 +0000 (UTC)
Received: by bcodding.csb (Postfix, from userid 24008)
        id 4C5F110C30E0; Tue, 13 Dec 2022 06:10:43 -0500 (EST)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     Guillaume Nault <gnault@redhat.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        Josef Bacik <josef@toxicpanda.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Steve French <sfrench@samba.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: [PATCH net v3 0/3] Stop corrupting socket's task_frag
Date:   Tue, 13 Dec 2022 06:10:36 -0500
Message-Id: <cover.1670929442.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The networking code uses flags in sk_allocation to determine if it can use
current->task_frag, however in-kernel users of sockets may stop setting
sk_allocation when they convert to the preferred memalloc_nofs_save/restore,
as SUNRPC has done in commit a1231fda7e94 ("SUNRPC: Set memalloc_nofs_save()
on all rpciod/xprtiod jobs").

This will cause corruption in current->task_frag when recursing into the
network layer for those subsystems during page fault or reclaim.  The
corruption is difficult to diagnose because stack traces may not contain the
offending subsystem at all.  The corruption is unlikely to show up in
testing because it requires memory pressure, and so subsystems that
convert to memalloc_nofs_save/restore are likely to continue to run into
this issue.

Previous reports and proposed fixes:
https://lore.kernel.org/netdev/96a18bd00cbc6cb554603cc0d6ef1c551965b078.1663762494.git.gnault@redhat.com/
https://lore.kernel.org/netdev/b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com/
https://lore.kernel.org/linux-nfs/de6d99321d1dcaa2ad456b92b3680aa77c07a747.1665401788.git.gnault@redhat.com/

Guilluame Nault has done all of the hard work tracking this problem down and
finding the best fix for this issue.  I'm just taking a turn posting another
fix.

Changes on v2:
	- rebased on -net
	- set sk_use_task_frag = false for xfrm/espintcp.c

Changes on v3:
	- fixup comments in sock.h for kernel-doc

Benjamin Coddington (2):
  Treewide: Stop corrupting socket's task_frag
  net: simplify sk_page_frag

Guillaume Nault (1):
  net: Introduce sk_use_task_frag in struct sock.

 drivers/block/drbd/drbd_receiver.c |  3 +++
 drivers/block/nbd.c                |  1 +
 drivers/nvme/host/tcp.c            |  1 +
 drivers/scsi/iscsi_tcp.c           |  1 +
 drivers/usb/usbip/usbip_common.c   |  1 +
 fs/afs/rxrpc.c                     |  1 +
 fs/cifs/connect.c                  |  1 +
 fs/dlm/lowcomms.c                  |  2 ++
 fs/ocfs2/cluster/tcp.c             |  1 +
 include/net/sock.h                 | 10 ++++++----
 net/9p/trans_fd.c                  |  1 +
 net/ceph/messenger.c               |  1 +
 net/core/sock.c                    |  1 +
 net/sunrpc/xprtsock.c              |  3 +++
 net/xfrm/espintcp.c                |  1 +
 15 files changed, 25 insertions(+), 4 deletions(-)

-- 
2.31.1

