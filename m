Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F5F64826E
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 13:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiLIMiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 07:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLIMiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 07:38:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EF4663F6
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 04:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670589435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kKcc7XQPg0UZn1AHNfQ4N2d5zF9JzBW3g3hPGFAB4Kc=;
        b=ZG3qqAatQhAgpOboJAhhAnXOsAls6GT3djKhXpAx8qhAmpWP+j5Ewoo4/diUxYxZxAhmAx
        IsB4N7gRUZDNj5yOs+yBwaGHPcGpIAQwcjkCOeZuP6frx+KIOVT+ppWBotynfu9bGbnIWY
        PFnFWXmmPhUxIB2B9Yq/ZGaPsueGibY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-98-iStCORDvOMO8XaybwRqR2A-1; Fri, 09 Dec 2022 07:37:14 -0500
X-MC-Unique: iStCORDvOMO8XaybwRqR2A-1
Received: by mail-wm1-f69.google.com with SMTP id b47-20020a05600c4aaf00b003d031aeb1b6so3878479wmp.9
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 04:37:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kKcc7XQPg0UZn1AHNfQ4N2d5zF9JzBW3g3hPGFAB4Kc=;
        b=klRn49RT8pYm6TcqIPlirGBObIZsJmKsxRHDhZt+mIPoy8zu8Msk8Mi8Jev/FkHwvO
         MXRey8mAAEyRHluwnfpmLRgu397BDNrJrTPHH+II8chPX2mPTv0LTrqweAM6swjMGEF1
         jszU3dK8Qg7IP6NScwtttNtth77ScO7OheXSvfGGpPoTxFhuqvovnluGnDwsCSagH3El
         1zlBEGDlFUkJKtm+BzfmvFujgeWpN/SczzrFgh0gJabpR4NEMNbGfJ3xICRCutyyAbs6
         +frNjVmQ6xPTo9W8LrRBmv7KvXBJ4Uwt0Uh/PYM9zBvDGCIBFfUL30jzev47gg0bE/V+
         hR/Q==
X-Gm-Message-State: ANoB5pkZ/sI3vu4MmxSBUtT/VcOTFZHZc1zindHNa/0WTxhMCbv1g2g3
        mrzWyW2YNWu55Sf8HTRsa4UctQIkkbBiqIL5T5y3degbSej6vV5absWSkdVMwVGpA7jelCZS3a3
        IVmA/caquCllSFe15
X-Received: by 2002:a05:600c:4fd0:b0:3d1:c0a1:4804 with SMTP id o16-20020a05600c4fd000b003d1c0a14804mr4752759wmq.17.1670589432845;
        Fri, 09 Dec 2022 04:37:12 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5DyMiYpWNcqaQueb0cVh7tJ5lH4JY75MZjLcmrbwYgfM+x/au0sr5C4m2hvq8cZrZMVyWo5g==
X-Received: by 2002:a05:600c:4fd0:b0:3d1:c0a1:4804 with SMTP id o16-20020a05600c4fd000b003d1c0a14804mr4752714wmq.17.1670589432518;
        Fri, 09 Dec 2022 04:37:12 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-106-22.dyn.eolo.it. [146.241.106.22])
        by smtp.gmail.com with ESMTPSA id j10-20020a05600c1c0a00b003b49bd61b19sm9284355wms.15.2022.12.09.04.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 04:37:11 -0800 (PST)
Message-ID: <d220402a232e204676d9100d6fe4c2ae08f753ee.camel@redhat.com>
Subject: Re: [PATCH v1 2/3] Treewide: Stop corrupting socket's task_frag
From:   Paolo Abeni <pabeni@redhat.com>
To:     Benjamin Coddington <bcodding@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Christoph =?ISO-8859-1?Q?B=F6hmwalder?= 
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
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
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
Date:   Fri, 09 Dec 2022 13:37:08 +0100
In-Reply-To: <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
References: <cover.1669036433.git.bcodding@redhat.com>
         <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-11-21 at 08:35 -0500, Benjamin Coddington wrote:
> Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
> GFP_NOIO flag on sk_allocation which the networking system uses to decide
> when it is safe to use current->task_frag.  The results of this are
> unexpected corruption in task_frag when SUNRPC is involved in memory
> reclaim.
> 
> The corruption can be seen in crashes, but the root cause is often
> difficult to ascertain as a crashing machine's stack trace will have no
> evidence of being near NFS or SUNRPC code.  I believe this problem to
> be much more pervasive than reports to the community may indicate.
> 
> Fix this by having kernel users of sockets that may corrupt task_frag due
> to reclaim set sk_use_task_frag = false.  Preemptively correcting this
> situation for users that still set sk_allocation allows them to convert to
> memalloc_nofs_save/restore without the same unexpected corruptions that are
> sure to follow, unlikely to show up in testing, and difficult to bisect.
> 
> CC: Philipp Reisner <philipp.reisner@linbit.com>
> CC: Lars Ellenberg <lars.ellenberg@linbit.com>
> CC: "Christoph Böhmwalder" <christoph.boehmwalder@linbit.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: Josef Bacik <josef@toxicpanda.com>
> CC: Keith Busch <kbusch@kernel.org>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Sagi Grimberg <sagi@grimberg.me>
> CC: Lee Duncan <lduncan@suse.com>
> CC: Chris Leech <cleech@redhat.com>
> CC: Mike Christie <michael.christie@oracle.com>
> CC: "James E.J. Bottomley" <jejb@linux.ibm.com>
> CC: "Martin K. Petersen" <martin.petersen@oracle.com>
> CC: Valentina Manea <valentina.manea.m@gmail.com>
> CC: Shuah Khan <shuah@kernel.org>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: David Howells <dhowells@redhat.com>
> CC: Marc Dionne <marc.dionne@auristor.com>
> CC: Steve French <sfrench@samba.org>
> CC: Christine Caulfield <ccaulfie@redhat.com>
> CC: David Teigland <teigland@redhat.com>
> CC: Mark Fasheh <mark@fasheh.com>
> CC: Joel Becker <jlbec@evilplan.org>
> CC: Joseph Qi <joseph.qi@linux.alibaba.com>
> CC: Eric Van Hensbergen <ericvh@gmail.com>
> CC: Latchesar Ionkov <lucho@ionkov.net>
> CC: Dominique Martinet <asmadeus@codewreck.org>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Eric Dumazet <edumazet@google.com>
> CC: Jakub Kicinski <kuba@kernel.org>
> CC: Paolo Abeni <pabeni@redhat.com>
> CC: Ilya Dryomov <idryomov@gmail.com>
> CC: Xiubo Li <xiubli@redhat.com>
> CC: Chuck Lever <chuck.lever@oracle.com>
> CC: Jeff Layton <jlayton@kernel.org>
> CC: Trond Myklebust <trond.myklebust@hammerspace.com>
> CC: Anna Schumaker <anna@kernel.org>
> CC: drbd-dev@lists.linbit.com
> CC: linux-block@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> CC: nbd@other.debian.org
> CC: linux-nvme@lists.infradead.org
> CC: open-iscsi@googlegroups.com
> CC: linux-scsi@vger.kernel.org
> CC: linux-usb@vger.kernel.org
> CC: linux-afs@lists.infradead.org
> CC: linux-cifs@vger.kernel.org
> CC: samba-technical@lists.samba.org
> CC: cluster-devel@redhat.com
> CC: ocfs2-devel@oss.oracle.com
> CC: v9fs-developer@lists.sourceforge.net
> CC: netdev@vger.kernel.org
> CC: ceph-devel@vger.kernel.org
> CC: linux-nfs@vger.kernel.org
> 
> Suggested-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Benjamin Coddington <bcodding@redhat.com>

I think this is the most feasible way out of the existing issue, and I
think this patchset should go via the networking tree, targeting the
Linux 6.2.

If someone has disagreement with the above, please speak! 

Thanks,

Paolo

