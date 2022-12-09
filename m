Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00A764885E
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 19:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiLISUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 13:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiLISUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 13:20:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBFFE6A
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 10:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670609985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UyClCmc9OkJZV29U659EuNx26cL0DUx8R9OIL0g3wII=;
        b=gxLrWrlTvCrzt96VcxJa3RLcFf/68FSMu7OdEHRil0zbJgw2zKpmM7nio0hbY0aGbMwQGH
        4qsTg58wQGBLJRyCKwhAjxO3UAvy3N0ngm1m/1HtCrV/hxHOe6XaOdxuSddyr6W5l2L4/e
        1iOkACC1KxtRknHzIB4RNXb+OoemdCk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-MxJvRcAzNZaXtFArwvL2Kg-1; Fri, 09 Dec 2022 13:19:44 -0500
X-MC-Unique: MxJvRcAzNZaXtFArwvL2Kg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFE82185A7AE;
        Fri,  9 Dec 2022 18:19:42 +0000 (UTC)
Received: from bcodding.csb (unknown [10.22.50.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3FFB40C6EC3;
        Fri,  9 Dec 2022 18:19:41 +0000 (UTC)
Received: by bcodding.csb (Postfix, from userid 24008)
        id 26FD410C30F0; Fri,  9 Dec 2022 13:19:39 -0500 (EST)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Philipp Reisner <philipp.reisner@linbit.com>,
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
Subject: [PATCH net v2 0/3] Stop corrupting socket's task_frag
Date:   Fri,  9 Dec 2022 13:19:22 -0500
Message-Id: <cover.1670609077.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

