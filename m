Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A3463C5B4
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbiK2QyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbiK2Qx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:53:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DBE73B81
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 08:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669740482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e0muEHBDbnLFxSz/8uKrynkgUxzkHQQXyf0Q/GGNCDo=;
        b=I1UPBpX690gKst9qm+36xfZ416r4hf/tD31SjdIWa8ouuL08YFQs5ucRG2nfqn2J+YF7W0
        FH9zo5Zj2x/pCyWuhei0e55fVxSo1EmFdctzIKe3fCc5OYmJe1m1T7+bn9CPr5iCc+GbZd
        SwdkRaxm7hxEp0Tgtt8YHD5YXui+fDs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-NLEV3qqHMjm2VIHjZofz1g-1; Tue, 29 Nov 2022 11:47:58 -0500
X-MC-Unique: NLEV3qqHMjm2VIHjZofz1g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA346101E155;
        Tue, 29 Nov 2022 16:47:53 +0000 (UTC)
Received: from [10.22.16.202] (unknown [10.22.16.202])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 417A52166B2D;
        Tue, 29 Nov 2022 16:47:51 +0000 (UTC)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        =?utf-8?q?Christoph_B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        Josef Bacik <josef@toxicpanda.com>,
        Keith Busch <kbusch@kernel.org>,
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
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, nbd@other.debian.org,
        linux-nvme@lists.infradead.org, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, v9fs-developer@lists.sourceforge.net,
        ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH v1 2/3] Treewide: Stop corrupting socket's task_frag
Date:   Tue, 29 Nov 2022 11:47:47 -0500
Message-ID: <794DBAB0-EDAF-4DA2-A837-C1F99916BC8E@redhat.com>
In-Reply-To: <20221129140242.GA15747@lst.de>
References: <cover.1669036433.git.bcodding@redhat.com>
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
 <20221129140242.GA15747@lst.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29 Nov 2022, at 9:02, Christoph Hellwig wrote:

> Hmm.  Having to set a flag to not accidentally corrupt per-task
> state seems a bit fragile.  Wouldn't it make sense to find a way to opt
> into the feature only for sockets created from the syscall layer?

It's totally fragile, and that's why it's currently broken in production.
The fragile ship sailed when networking decided to depend on users setting
the socket's GFP_ flags correctly to avoid corruption.

Meantime, this problem needs fixing in a way that makes everyone happy.
This fix doesn't make it less fragile, but it may (hopefully) address the
previous criticisms enough that something gets done to fix it.

Ben

