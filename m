Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48893645930
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiLGLpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiLGLpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:45:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DB83C6D9
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 03:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670413484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tttsLE0OS8xqs4V7cT407BTm7S4Gqrc7PZ/SPvprOPQ=;
        b=ZvfFm1OIfulLHYb0b+ZHaYzUSk6ZwGAbupw5d+BloRQQ1WO2xSo1TtC1I9vPtXliQyYoF0
        u3U64cH6iHyfmlGjvXxBfWV8lHdUWSTlUAM3sitbNXeqmLLmch80EgsSSi2ScA/Rg+Qsm5
        2zjvYqm47Z72Amt7ks7PXkgPmZVG6Xo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-2thKos0KMDGp6nxsIksRKw-1; Wed, 07 Dec 2022 06:44:41 -0500
X-MC-Unique: 2thKos0KMDGp6nxsIksRKw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 228FA293249C;
        Wed,  7 Dec 2022 11:44:41 +0000 (UTC)
Received: from [172.16.176.1] (unknown [10.22.50.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 14265492B05;
        Wed,  7 Dec 2022 11:44:39 +0000 (UTC)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1 0/3] Stop corrupting socket's task_frag
Date:   Wed, 07 Dec 2022 06:44:34 -0500
Message-ID: <364A2E37-B912-4160-ABC8-AC630A8777B2@redhat.com>
In-Reply-To: <cover.1669036433.git.bcodding@redhat.com>
References: <cover.1669036433.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Eric, Jakub, Paolo,

I think it makes sense for all three of these to go together through netd=
ev.
If you agree, would you like me to chase down individual ACKs for each
treewide touch?

What can I do from netdev's perspective to move this forward?

Ben

On 21 Nov 2022, at 8:35, Benjamin Coddington wrote:

> The networking code uses flags in sk_allocation to determine if it can =
use
> current->task_frag, however in-kernel users of sockets may stop setting=

> sk_allocation when they convert to the preferred memalloc_nofs_save/res=
tore,
> as SUNRPC has done in commit a1231fda7e94 ("SUNRPC: Set memalloc_nofs_s=
ave()
> on all rpciod/xprtiod jobs").
>
> This will cause corruption in current->task_frag when recursing into th=
e
> network layer for those subsystems during page fault or reclaim.  The
> corruption is difficult to diagnose because stack traces may not contai=
n the
> offending subsystem at all.  The corruption is unlikely to show up in
> testing because it requires memory pressure, and so subsystems that
> convert to memalloc_nofs_save/restore are likely to continue to run int=
o
> this issue.
>
> Previous reports and proposed fixes:
> https://lore.kernel.org/netdev/96a18bd00cbc6cb554603cc0d6ef1c551965b078=
=2E1663762494.git.gnault@redhat.com/
> https://lore.kernel.org/netdev/b4d8cb09c913d3e34f853736f3f5628abfd7f4b6=
=2E1656699567.git.gnault@redhat.com/
> https://lore.kernel.org/linux-nfs/de6d99321d1dcaa2ad456b92b3680aa77c07a=
747.1665401788.git.gnault@redhat.com/
>
> Guilluame Nault has done all of the hard work tracking this problem dow=
n and
> finding the best fix for this issue.  I'm just taking a turn posting an=
other
> fix.
>
> Benjamin Coddington (2):
>   Treewide: Stop corrupting socket's task_frag
>   net: simplify sk_page_frag
>
> Guillaume Nault (1):
>   net: Introduce sk_use_task_frag in struct sock.
>
>  drivers/block/drbd/drbd_receiver.c |  3 +++
>  drivers/block/nbd.c                |  1 +
>  drivers/nvme/host/tcp.c            |  1 +
>  drivers/scsi/iscsi_tcp.c           |  1 +
>  drivers/usb/usbip/usbip_common.c   |  1 +
>  fs/afs/rxrpc.c                     |  1 +
>  fs/cifs/connect.c                  |  1 +
>  fs/dlm/lowcomms.c                  |  2 ++
>  fs/ocfs2/cluster/tcp.c             |  1 +
>  include/net/sock.h                 | 10 ++++++----
>  net/9p/trans_fd.c                  |  1 +
>  net/ceph/messenger.c               |  1 +
>  net/core/sock.c                    |  1 +
>  net/sunrpc/xprtsock.c              |  3 +++
>  14 files changed, 24 insertions(+), 4 deletions(-)
>
> -- =

> 2.31.1

