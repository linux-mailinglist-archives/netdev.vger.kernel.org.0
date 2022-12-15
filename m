Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC61464DDED
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 16:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiLOPit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 10:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLOPir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 10:38:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01FB15FC0
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 07:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671118679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V4kXBpCyfZgn52Jo83hC/ZUB27N3FlYbi8b8ti3cThA=;
        b=DN09XUPgliFvxZ5r206vFP3Z2kYlxTYxtI0WT5uwjLPBHQ2sDhvVNPmO2AfrDQ9Fo1GvUj
        lLvIGI3JrPuwZqYOdQHI6Qq2dJoXpEV3qJ8nXiPORCC9ITWDuZIafGs/M3+19RtFbUOvbg
        bcXXxyOyUILWF3SPkwRqURROyYia7Qo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-421-LrVCGGDAOdyp2Pqz7bluSQ-1; Thu, 15 Dec 2022 10:37:58 -0500
X-MC-Unique: LrVCGGDAOdyp2Pqz7bluSQ-1
Received: by mail-wm1-f69.google.com with SMTP id 9-20020a1c0209000000b003d1c0a147f6so1277239wmc.4
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 07:37:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V4kXBpCyfZgn52Jo83hC/ZUB27N3FlYbi8b8ti3cThA=;
        b=PVpygRkVgU+NMvZ2GSRAFksRcYN9hrpbaL7E9Cqg2L5OTJY51SxiSPQgUY1OiOw+8S
         sN3vug/+eUjBML0sVwj+4R+IbRVl/wRd9IQaIUMTVttl74qRQjihbxgvD2/IsXdxKM0Y
         EFsdfLT8QcXLBYx/8covU6gOdGDk3Pyfe9QyF5kuM5QdKwwJsMKiHkfkXWGgA3n0vx2s
         NdjuC5FSwBYKO0aLsfEJyuyOlhe5VfRfOBpjZSZTFXgjaBqXp8qn5UR2uwv3sAcmWSdY
         jwRJqcoE0R4UMLtH7gneDSjx4TaS3URzCLk/WGGZv2T6UrrL+WKedTR3W9reow6JBd80
         RW5A==
X-Gm-Message-State: ANoB5pmzfJOiBKhLxOkXatmcuyGKUIUPrGCEKauENDtiAzEB46ujLPMV
        W+v7+bo7x2+IfG0BdplqUM9B35n6lsWn2I7rVi1CYxrSw5+FaC0l02WA3BcJ5Y/n+M9lMue8h8W
        UZ9o4dZyO/gZ6QHXf
X-Received: by 2002:a05:6000:609:b0:254:3dcb:d191 with SMTP id bn9-20020a056000060900b002543dcbd191mr9403516wrb.53.1671118677111;
        Thu, 15 Dec 2022 07:37:57 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5neODWya2MDrbCK0/DDU6vT61V4ERe6mDphYUBHOujHvxjDnRnvkmfU6fHfAuYCVW/YlQk+g==
X-Received: by 2002:a05:6000:609:b0:254:3dcb:d191 with SMTP id bn9-20020a056000060900b002543dcbd191mr9403490wrb.53.1671118676872;
        Thu, 15 Dec 2022 07:37:56 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id j18-20020a5d6052000000b002425c6d30c6sm7140430wrt.117.2022.12.15.07.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 07:37:56 -0800 (PST)
Date:   Thu, 15 Dec 2022 16:37:53 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Howells <dhowells@redhat.com>
Cc:     Benjamin Coddington <bcodding@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
Subject: Re: [PATCH net v3 2/3] Treewide: Stop corrupting socket's task_frag
Message-ID: <20221215153753.GA7408@pc-4.home>
References: <20221215135905.GA19378@pc-4.home>
 <92b887a9b90dcbf5083d1f47699c2f785820d708.1670929442.git.bcodding@redhat.com>
 <cover.1670929442.git.bcodding@redhat.com>
 <122424.1671106362@warthog.procyon.org.uk>
 <139538.1671115012@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <139538.1671115012@warthog.procyon.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 02:36:52PM +0000, David Howells wrote:
> 
> Guillaume Nault <gnault@redhat.com> wrote:
> 
> > Maybe setting sk_use_task_frag in fs/afs/rxrpc.c was overzealous but
> > I'm not familiar enough with the AF_RXRPC family to tell. If AF_RXRPC
> > sockets can't call sk_page_frag() and have no reason to do so in the
> > future, then it should be safe to drop this chunk.
> 
> As of this merge window, AF_RXRPC doesn't actually allocate sk_buffs apart
> from when it calls skb_unshare().  It does steal the incoming sk_buffs from
> the UDP socket it uses as a transport, but they're allocated in the IP/IP6
> stack somewhere.
> 
> The UDP transport socket, on the other hand, will allocate sk_buffs for
> transmission, but rxrpc sends an entire UDP packet at a time, each with a
> single sendmsg call.
> 
> Further, this mostly now moved such that the UDP sendmsg calls are performed
> inside an I/O thread.  The application thread does not interact directly with
> the UDP transport socket.
> 
> David

Thanks for the explanations. Looks like we could drop the fs/afs/rxrpc.c
chunk then.

