Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91ACC64DADA
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 13:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiLOMJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 07:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiLOMJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 07:09:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242532CE3F
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 04:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671106106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=39zYL8hPR4DzE3guy3K/AlTv/snxpvpGROWPklcgoQg=;
        b=CGv6wedlvxLb0AopqeT1XDveoKPxvMLDK9KP9XlsMquN7zwVp78gz22rRWVZt5yEi6blhk
        mDfNOBqZi1Fyv5mx6cStVxtGhhuaTUYsrUusOZ17WrGwv7cGS4YAl4ynGIUqpVEiNZBHSd
        SUMJVPjcAx1TZS+4X/QHKsfPTI5G5LY=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-251-3-Rxp1KTPwWyeN7A6w0JNg-1; Thu, 15 Dec 2022 07:08:25 -0500
X-MC-Unique: 3-Rxp1KTPwWyeN7A6w0JNg-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-349423f04dbso32648537b3.13
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 04:08:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=39zYL8hPR4DzE3guy3K/AlTv/snxpvpGROWPklcgoQg=;
        b=16bbEla7t2DmSFKMKkt6Q/LkMwlSutIDD62HSfpJL4rzwXPrA/i9PxDnlEIDiUQ5iO
         wunWi7ICKQozUnpbmzzejaB6USrQac4rsKkDjuPB1CVJMXtqU+GHXpPPhkbvOIsjdNvj
         +xRDScaC1ObdB9/9ei+Rk1I7l1R1JxoZiJNx3vHBwHdakLoqzGTO59brk3etgL/F867n
         dTq1fD9+cgDrZivRfuHqtBdQesjr453l5iXABdOla1Xjgvi0SC1fHyx+DuQpUNjEon1X
         JLVPgvzQ+rhVj8xuXcQpqNY6HUUU3KvUg3EvUfd//QZU/RRnnwZ8huO4E4E8QfrIMFXL
         4/qQ==
X-Gm-Message-State: ANoB5plpmG3fFLrDNK7IsHBVeCvfqlEC8G1kMkjEdyYoZUOPxddsRBM8
        2WplfRTu2vGRWk3KpQpqNSF8SAug1XubKuMvBDBilKPJPCfcmPe8ornaF8Ue88+pJeMzSz3MoFL
        KEcK9RqRyECcCdGWN
X-Received: by 2002:a05:7500:2394:b0:ea:959e:97ed with SMTP id v20-20020a057500239400b000ea959e97edmr3135456gac.35.1671106104231;
        Thu, 15 Dec 2022 04:08:24 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5eJlcRSYLP8H0zFj2M5+CgVanGyTBLkzw4TA/u4wfE1TTtNNIpjw5mJnZcJxRDeS3zvAI6aA==
X-Received: by 2002:a05:7500:2394:b0:ea:959e:97ed with SMTP id v20-20020a057500239400b000ea959e97edmr3135441gac.35.1671106103818;
        Thu, 15 Dec 2022 04:08:23 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-97-87.dyn.eolo.it. [146.241.97.87])
        by smtp.gmail.com with ESMTPSA id w19-20020a05620a0e9300b006e07228ed53sm11722971qkm.18.2022.12.15.04.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 04:08:22 -0800 (PST)
Message-ID: <877d0130f434ac6f8066711cb6cdca09c7767843.camel@redhat.com>
Subject: Re: [PATCH net v3 1/3] net: Introduce sk_use_task_frag in struct
 sock.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Benjamin Coddington <bcodding@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     Guillaume Nault <gnault@redhat.com>,
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
        Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Date:   Thu, 15 Dec 2022 13:08:15 +0100
In-Reply-To: <1a369325ac2d4a604a074428f58fa72a6065e197.1670929442.git.bcodding@redhat.com>
References: <cover.1670929442.git.bcodding@redhat.com>
         <1a369325ac2d4a604a074428f58fa72a6065e197.1670929442.git.bcodding@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-13 at 06:10 -0500, Benjamin Coddington wrote:
> From: Guillaume Nault <gnault@redhat.com>
> 
> Sockets that can be used while recursing into memory reclaim, like
> those used by network block devices and file systems, mustn't use
> current->task_frag: if the current process is already using it, then
> the inner memory reclaim call would corrupt the task_frag structure.
> 
> To avoid this, sk_page_frag() uses ->sk_allocation to detect sockets
> that mustn't use current->task_frag, assuming that those used during
> memory reclaim had their allocation constraints reflected in
> ->sk_allocation.
> 
> This unfortunately doesn't cover all cases: in an attempt to remove all
> usage of GFP_NOFS and GFP_NOIO, sunrpc stopped setting these flags in
> ->sk_allocation, and used memalloc_nofs critical sections instead.
> This breaks the sk_page_frag() heuristic since the allocation
> constraints are now stored in current->flags, which sk_page_frag()
> can't read without risking triggering a cache miss and slowing down
> TCP's fast path.
> 
> This patch creates a new field in struct sock, named sk_use_task_frag,
> which sockets with memory reclaim constraints can set to false if they
> can't safely use current->task_frag. In such cases, sk_page_frag() now
> always returns the socket's page_frag (->sk_frag). The first user is
> sunrpc, which needs to avoid using current->task_frag but can keep
> ->sk_allocation set to GFP_KERNEL otherwise.
> 
> Eventually, it might be possible to simplify sk_page_frag() by only
> testing ->sk_use_task_frag and avoid relying on the ->sk_allocation
> heuristic entirely (assuming other sockets will set ->sk_use_task_frag
> according to their constraints in the future).
> 
> The new ->sk_use_task_frag field is placed in a hole in struct sock and
> belongs to a cache line shared with ->sk_shutdown. Therefore it should
> be hot and shouldn't have negative performance impacts on TCP's fast
> path (sk_shutdown is tested just before the while() loop in
> tcp_sendmsg_locked()).
> 
> Link: https://lore.kernel.org/netdev/b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com/
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
> ---
>  include/net/sock.h | 11 +++++++++--
>  net/core/sock.c    |  1 +
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index e0517ecc6531..44380c6dc6c4 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -318,6 +318,9 @@ struct sk_filter;
>    *	@sk_stamp: time stamp of last packet received
>    *	@sk_stamp_seq: lock for accessing sk_stamp on 32 bit architectures only
>    *	@sk_tsflags: SO_TIMESTAMPING flags
> +  *	@sk_use_task_frag: allow sk_page_frag() to use current->task_frag.
> +  *			   Sockets that can be used under memory reclaim should
> +  *			   set this to false.
>    *	@sk_bind_phc: SO_TIMESTAMPING bind PHC index of PTP virtual clock
>    *	              for timestamping
>    *	@sk_tskey: counter to disambiguate concurrent tstamp requests
> @@ -505,6 +508,7 @@ struct sock {
>  #endif
>  	u16			sk_tsflags;
>  	u8			sk_shutdown;
> +	bool			sk_use_task_frag;
>  	atomic_t		sk_tskey;
>  	atomic_t		sk_zckey;

I'm sorry, but after the post PR -net -> net-next merge, this does not
apply cleanly any-more, you need to rebase it once more.

Note that commit b534dc46c8ae ("net_tstamp: add
SOF_TIMESTAMPING_OPT_ID_TCP") moved the surronding fields a bit but
there is still one byte hole after sk_txtime_unused, before sk_socket.

Thanks!

Paolo

