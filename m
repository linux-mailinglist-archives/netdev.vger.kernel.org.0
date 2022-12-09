Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37D864822F
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 13:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiLIMLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 07:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiLIMKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 07:10:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2AD389DE
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 04:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670587795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9QQYI9IjkkIUTVxaX3edo06SmbOZzGyRFi5ji2As464=;
        b=O5KRlxydps/kI/+MdT/WYVcdqq4widH+DK/mysuAhcd4XE2R/G/Kr0paXfdwjscOGIk4j5
        nkmsZkXGxIGB7+PToZ6Yof53gyjJMtSxMAb979iBpml3yLSBKV6zOXWOK03kw+RCa+Rm7E
        wSc+UgnzUglClDylHYNKd18MNlhZvjQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-513-rUI1uRrXMyWXx48nGuXHpQ-1; Fri, 09 Dec 2022 07:09:54 -0500
X-MC-Unique: rUI1uRrXMyWXx48nGuXHpQ-1
Received: by mail-wm1-f71.google.com with SMTP id x10-20020a05600c420a00b003cfa33f2e7cso2319184wmh.2
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 04:09:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9QQYI9IjkkIUTVxaX3edo06SmbOZzGyRFi5ji2As464=;
        b=hKfr3elB4ivdUeP8dskV1XUEjIIRhqhipTm7BR2h7mSXiH0CuRCtPNWGyeYq7kmOQE
         GXfNRKliCnn8xxtmNwrB/QzsyYX5ae7NtPN583NW+EPGPtWc8QPqj66aLTlIWR4eM/dm
         bA+VfcyFnSJ9N/PrwoW1SIXcoGNkIkg8LwIMmI60nVVgYKWd36LZzRTRk+iFMZYv+q+9
         5OfJSREekMUcupOUiwgkmhZivx7M2zC9F30Ixca8Wux3uboEpMz0f/QjRVFNjhTnhv92
         5ITVii/b7tLqITBeIdWKBCmQRKTg3A7q8OyCVp7Ppl/q0lU8g2C5EdWZpgv8WXrCDHC5
         L/6w==
X-Gm-Message-State: ANoB5pkr/+ZaTjM2xEVvyf/Rdy1enxh6aDIxkqsZJFxUUnYO0TZJl07/
        EWq3/Qqad/3IX2/soaj4MO51zmaWlJug9/ci7V0ISBHtAVnUcvRNaHW89uzkWmHUw/VWWJJI9Gm
        zOuMQSphFbI/E41n0
X-Received: by 2002:a05:600c:3d8f:b0:3cf:a18d:399c with SMTP id bi15-20020a05600c3d8f00b003cfa18d399cmr4694838wmb.1.1670587792793;
        Fri, 09 Dec 2022 04:09:52 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5VbKfDtttCZRPwGTHKs3v9F/8RFX/CRXfdCnsfU40ZgE1sK/uB/WXkrBatvEsKr8aAuej8PA==
X-Received: by 2002:a05:600c:3d8f:b0:3cf:a18d:399c with SMTP id bi15-20020a05600c3d8f00b003cfa18d399cmr4694822wmb.1.1670587792506;
        Fri, 09 Dec 2022 04:09:52 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-106-22.dyn.eolo.it. [146.241.106.22])
        by smtp.gmail.com with ESMTPSA id iv7-20020a05600c548700b003d1f3e9df3csm9221828wmb.7.2022.12.09.04.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 04:09:52 -0800 (PST)
Message-ID: <dd5260c621d3cf8733fab6287a8182b821c937c5.camel@redhat.com>
Subject: Re: [PATCH v1 1/3] net: Introduce sk_use_task_frag in struct sock.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Benjamin Coddington <bcodding@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Maciej =?UTF-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Menglong Dong <imagedong@tencent.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>,
        Alexander Duyck <alexanderduyck@fb.com>
Date:   Fri, 09 Dec 2022 13:09:50 +0100
In-Reply-To: <d9041e542ade6af472c7be14b5a28856692815cf.1669036433.git.bcodding@redhat.com>
References: <cover.1669036433.git.bcodding@redhat.com>
         <d9041e542ade6af472c7be14b5a28856692815cf.1669036433.git.bcodding@redhat.com>
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

On Mon, 2022-11-21 at 08:35 -0500, Benjamin Coddington wrote:
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
> ---
>  include/net/sock.h | 11 +++++++++--
>  net/core/sock.c    |  1 +
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index d08cfe190a78..ffba9e95470d 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -318,6 +318,9 @@ struct sk_filter;
>    *	@sk_stamp: time stamp of last packet received
>    *	@sk_stamp_seq: lock for accessing sk_stamp on 32 bit architectures only
>    *	@sk_tsflags: SO_TIMESTAMPING flags
> +  *	@sk_use_task_frag: allow sk_page_frag() to use current->task_frag.
> +			   Sockets that can be used under memory reclaim should
> +			   set this to false.
>    *	@sk_bind_phc: SO_TIMESTAMPING bind PHC index of PTP virtual clock
>    *	              for timestamping
>    *	@sk_tskey: counter to disambiguate concurrent tstamp requests
> @@ -504,6 +507,7 @@ struct sock {
>  #endif
>  	u16			sk_tsflags;
>  	u8			sk_shutdown;
> +	bool			sk_use_task_frag;
>  	atomic_t		sk_tskey;
>  	atomic_t		sk_zckey;

I think the above should be fine from a data locality PoV, as the used
cacheline should be hot at sk_page_frag_refill() usage time, as
sk_tsflags has been accessed just before.

@Eric, does the above fit with the planned sock fields reordering?

Jakub noted we could use a bitfield here to be future proof for
additional flags addition. I think in this specific case a bool is
preferable, because we actually wont to discourage people to add more
of such flags, and the search for holes (or the bool -> bitflag
conversion) should give to such eventual future changes some additional
thoughts.

Thanks!

Paolo

