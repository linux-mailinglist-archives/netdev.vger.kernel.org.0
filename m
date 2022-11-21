Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECFF6323D4
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbiKUNg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiKUNgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:36:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC25C1F65
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669037724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=kv3DFPK60Zt0kQKX09txPuy6ctuc3jatg8rhDf4HcIA=;
        b=O5rPuOKeDtDbe9/3nmiTJdktTG2g1P/j3C/SS7QrXb0DJ21VZ4PSVPzuKokY0lR7jC0Utg
        XNj9MqVCg0HXW0AdqE/s2pGBYh2s2OFj9BuTn/l4CHl1s788rHd/tTP2a0ynrhRTiCNI3f
        JZfXD9WqyR+f/C4DOIt01i7cBYVDGWM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-P1zce99uPti9aGvqoLm26g-1; Mon, 21 Nov 2022 08:35:23 -0500
X-MC-Unique: P1zce99uPti9aGvqoLm26g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E89FA887400;
        Mon, 21 Nov 2022 13:35:22 +0000 (UTC)
Received: from bcodding.csb (unknown [10.22.50.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B230117585;
        Mon, 21 Nov 2022 13:35:22 +0000 (UTC)
Received: by bcodding.csb (Postfix, from userid 24008)
        id 33D9010C30E3; Mon, 21 Nov 2022 08:35:19 -0500 (EST)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/3] Stop corrupting socket's task_frag
Date:   Mon, 21 Nov 2022 08:35:16 -0500
Message-Id: <cover.1669036433.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
 14 files changed, 24 insertions(+), 4 deletions(-)

-- 
2.31.1

