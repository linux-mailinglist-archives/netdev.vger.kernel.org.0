Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203EC51366A
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241477AbiD1OMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235937AbiD1OMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:12:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7DF6C27CCD
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 07:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651154962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r89Z/7oHso894jLgFkyp7GZ9nOpRmCTTiW/mUMGcSaU=;
        b=JqjD+JZHPKkHfD4Kn3K4uBjONeHBzA3dPJBbsfK6Z6m8F+Mz42xhx9G1V+JVVf4HBJsFW2
        8YQKkf/KLKfs3/Ez+FQU3UZrGCnC/qZIpqcE79wHOkfVKMYJi64r3gTDRxqXi4pNquiGib
        OMaufqfdaEmB+wAaxgJ0nJ4l0WBMGI0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-_Aap0-ndPQmMqh42lv3zmw-1; Thu, 28 Apr 2022 10:09:19 -0400
X-MC-Unique: _Aap0-ndPQmMqh42lv3zmw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C873811E7A;
        Thu, 28 Apr 2022 14:09:18 +0000 (UTC)
Received: from [172.16.176.1] (ovpn-64-2.rdu2.redhat.com [10.10.64.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B093463EF5;
        Thu, 28 Apr 2022 14:09:18 +0000 (UTC)
From:   "Benjamin Coddington" <bcodding@redhat.com>
To:     "Hannes Reinecke" <hare@suse.de>
Cc:     "Jakub Kicinski" <kuba@kernel.org>,
        "Sagi Grimberg" <sagi@grimberg.me>,
        "Chuck Lever" <chuck.lever@oracle.com>, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
Date:   Thu, 28 Apr 2022 10:09:17 -0400
Message-ID: <E2BF9CFF-9361-400B-BDEE-CF5E0AFDCA63@redhat.com>
In-Reply-To: <be7e3c4b-8bb5-e818-1402-ac24cbbcb38c@suse.de>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
 <20220425101459.15484d17@kernel.org>
 <66077b73-c1a4-d2ae-c8e4-3e19e9053171@suse.de>
 <1fca2eda-83e4-fe39-13c8-0e5e7553689b@grimberg.me>
 <20220426080247.19bbb64e@kernel.org>
 <40bc060f-f359-081d-9ba7-fae531cf2cd6@suse.de>
 <20220426170334.3781cd0e@kernel.org>
 <23f497ab-08e3-3a25-26d9-56d94ee92cde@suse.de>
 <20220428063009.0a63a7f9@kernel.org>
 <be7e3c4b-8bb5-e818-1402-ac24cbbcb38c@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28 Apr 2022, at 9:51, Hannes Reinecke wrote:

> On 4/28/22 15:30, Jakub Kicinski wrote:
>> On Thu, 28 Apr 2022 09:26:41 +0200 Hannes Reinecke wrote:
>>> The whole thing started off with the problem on _how_ sockets could be
>>> passed between kernel and userspace and vice versa.
>>> While there is fd passing between processes via AF_UNIX, there is no
>>> such mechanism between kernel and userspace.
>>
>> Noob question - the kernel <> user space FD sharing is just
>> not implemented yet, or somehow fundamentally hard because kernel
>> fds are "special"?
>
> Noob reply: wish I knew.  (I somewhat hoped _you_ would've been able to
> tell me.)
>
> Thing is, the only method I could think of for fd passing is the POSIX fd
> passing via unix_attach_fds()/unix_detach_fds().  But that's AF_UNIX,
> which really is designed for process-to-process communication, not
> process-to-kernel.  So you probably have to move a similar logic over to
> AF_NETLINK. And design a new interface on how fds should be passed over
> AF_NETLINK.
>
> But then you have to face the issue that AF_NELINK is essentially UDP, and
> you have _no_ idea if and how many processes do listen on the other end.
> Thing is, you (as the sender) have to copy the fd over to the receiving
> process, so you'd better _hope_ there is a receiving process.  Not to
> mention that there might be several processes listening in...
>
> And that's something I _definitely_ don't feel comfortable with without
> guidance from the networking folks, so I didn't pursue it further and we
> went with the 'accept()' mechanism Chuck implemented.
>
> I'm open to suggestions, though.

EXPORT_SYMBOL(receive_fd) would allow interesting implementations.

The kernel keyring facilities have a good API for creating various key_types
which are able to perform work such as this from userspace contexts.

I have a working prototype for a keyring key instantiation which allows a
userspace process to install a kernel fd on its file table.  The problem
here is how to match/route such fd passing to appropriate processes in
appropriate namespaces.  I think this problem is shared by all
kernel-to-userspace upcalls, which I hope we can discuss at LSF/MM.

I don't think kernel fds are very special as compared to userspace fds.

Ben

