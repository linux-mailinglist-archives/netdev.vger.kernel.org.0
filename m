Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8EA65C2D1
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 16:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbjACPPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 10:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbjACPPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 10:15:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC1710045
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 07:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672758863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yeTxSlXjX/Qjt2MgnWieGR8E8NjZSpxjmxVxOPf7mHU=;
        b=QPucemjzDJ/ztSlbh1eHULd/eawekDnyByYpSgj1ODcTljbAJ5ED+X6+/jocgiigKG7AeK
        kgIwyt+ZSCOvRTCi0kAbMgdrD7g+xMdjEot6cDz9+m+9AKuYmiW6qb1unsV+/Xk/WmBu1C
        aQoG4Y++6CjgyvzoS6QqMUAOezMlCVU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-346-awyG9ca5MgmYsPZILyZJ7g-1; Tue, 03 Jan 2023 10:14:21 -0500
X-MC-Unique: awyG9ca5MgmYsPZILyZJ7g-1
Received: by mail-wm1-f70.google.com with SMTP id n8-20020a05600c294800b003d1cc68889dso6887916wmd.7
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 07:14:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yeTxSlXjX/Qjt2MgnWieGR8E8NjZSpxjmxVxOPf7mHU=;
        b=fJfMeG1r4hP+zZ1E5MbKS9GQE+S2Isf2fmdnu9yndNPNRWmQarkScW0QD22x47c01K
         ZzeWr/y5m2ObScYPvx+sFMhh5QgbsewEtD0Y/sXdMp3nVmaAyeqNKC2GWt8u3vSjhUtq
         Xz+4GCXf00hDQHLI5Kohujbjy8bITd8nvOyX5Ls9KGeXu1PHAXwL4lj22xDeiH2VeAG2
         mhoIoSew93RYhI71uRqQOSG1nH+WA/ZMeYCo46uYaqcLCmFbQMCDxbo5ziOZMOhX/2r3
         HPUg6Vhoa7/E5yqIjG7dwSAIzB6HsaHeupC+SHVPcxZ9JiB5hBQZ7iqS3ZVGB4eY3DkO
         R5nA==
X-Gm-Message-State: AFqh2koGPxglEUYe+ujpEkavrYHb4G/FboWA8CDAKxdTyUJ29HxSnULj
        JGHbPv16fkTiL1zrCfNBqzyl6+KHfftjPl1e45u7pbLCBRcOlODCQ+hg+UK6zFVWOh6Xr8EXma9
        fE9G9Fry7msDkdJ9n
X-Received: by 2002:a05:600c:4d20:b0:3d3:5737:3afb with SMTP id u32-20020a05600c4d2000b003d357373afbmr32179315wmp.41.1672758860754;
        Tue, 03 Jan 2023 07:14:20 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvb+RDP3IsD8PO8gr4LIIeyxQwbPNQQ/EKlL7EG07fJ2gAdc5ehOvdV/uUbX2Foec+Y1wv2gA==
X-Received: by 2002:a05:600c:4d20:b0:3d3:5737:3afb with SMTP id u32-20020a05600c4d2000b003d357373afbmr32179291wmp.41.1672758860479;
        Tue, 03 Jan 2023 07:14:20 -0800 (PST)
Received: from debian (2a01cb058918ce0092f241420f8f9b63.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:92f2:4142:f8f:9b63])
        by smtp.gmail.com with ESMTPSA id bg12-20020a05600c3c8c00b003d1e34bcbb2sm47475756wmb.13.2023.01.03.07.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 07:14:19 -0800 (PST)
Date:   Tue, 3 Jan 2023 16:14:17 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Benjamin Coddington <bcodding@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Christoph =?iso-8859-1?Q?B=F6hmwalder?= 
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
Subject: Re: [PATCH net v4 2/3] Treewide: Stop corrupting socket's task_frag
Message-ID: <Y7RGSbWX0L4EoA8W@debian>
References: <cover.1671194454.git.bcodding@redhat.com>
 <ceaf7a4b035e78cdbdde4e9a4ab71ba61a5e5457.1671194454.git.bcodding@redhat.com>
 <CANn89iKik8uMO6=ztufPwYdg1qRPsxToz0Nu-uaZWkE63bKSUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKik8uMO6=ztufPwYdg1qRPsxToz0Nu-uaZWkE63bKSUQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 03:26:27PM +0100, Eric Dumazet wrote:
> On Fri, Dec 16, 2022 at 1:45 PM Benjamin Coddington <bcodding@redhat.com> wrote:
> >
> > Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
> > GFP_NOIO flag on sk_allocation which the networking system uses to decide
> > when it is safe to use current->task_frag.  The results of this are
> > unexpected corruption in task_frag when SUNRPC is involved in memory
> > reclaim.
> >
> > The corruption can be seen in crashes, but the root cause is often
> > difficult to ascertain as a crashing machine's stack trace will have no
> > evidence of being near NFS or SUNRPC code.  I believe this problem to
> > be much more pervasive than reports to the community may indicate.
> >
> > Fix this by having kernel users of sockets that may corrupt task_frag due
> > to reclaim set sk_use_task_frag = false.  Preemptively correcting this
> > situation for users that still set sk_allocation allows them to convert to
> > memalloc_nofs_save/restore without the same unexpected corruptions that are
> > sure to follow, unlikely to show up in testing, and difficult to bisect.
> >
> 
> I am back from PTO.
> 
> It seems inet_ctl_sock_create() has been forgotten.
> 
> Without following fix, ICMP messages sent from softirq would corrupt
> innocent thread task_frag.

I didn't consider setting ->sk_use_task_frag on ICMP sockets as my
understanding was that only TCP and ip_append_data() could eventually
call sk_page_frag(). Therefore, I didn't see how ICMP sockets could be
affected. Did I miss something?

> (I will submit this patch formally a bit later today)
> 
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index ab4a06be489b5d410cec603bf56248d31dbc90dd..6c0ec27899431eb56e2f9d0c3a936b77f44ccaca
> 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1665,6 +1665,7 @@ int inet_ctl_sock_create(struct sock **sk,
> unsigned short family,
>         if (rc == 0) {
>                 *sk = sock->sk;
>                 (*sk)->sk_allocation = GFP_ATOMIC;
> +               (*sk)->sk_use_task_frag = false;
>                 /*
>                  * Unhash it so that IP input processing does not even see it,
>                  * we do not wish this socket to see incoming packets.
> 

