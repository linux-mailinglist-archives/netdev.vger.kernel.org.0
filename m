Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF97B56A6FC
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 17:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbiGGPbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 11:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbiGGPbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 11:31:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4A7D30F46
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 08:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657207883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JAYfRfFRfQ3OquVsrRGDSHn0L3YxC2qy0CyOEqXHADk=;
        b=IVCI3WWzdi2lR5lpMFZbtafYWbNzIF8YF5+dJp2M0AQW9qfXOyoaqbMURBuI3cf6ww7LGg
        PLIudwg3BrONJAb2/Jbff7jRRzlxXxQcpwKDGGmMO8rzwwVLGbTKJxACRMRhLLdGDAkFZa
        Z33kXVKvlXs8Z8CheWjS1EGNtBmpjAY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-I2lETD5RMq2jMmqMhJcy9w-1; Thu, 07 Jul 2022 11:31:21 -0400
X-MC-Unique: I2lETD5RMq2jMmqMhJcy9w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F0CB80A0C7;
        Thu,  7 Jul 2022 15:31:19 +0000 (UTC)
Received: from [172.16.176.1] (unknown [10.22.48.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 64CD040EC003;
        Thu,  7 Jul 2022 15:31:17 +0000 (UTC)
From:   "Benjamin Coddington" <bcodding@redhat.com>
To:     "Guillaume Nault" <gnault@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, netdev@vger.kernel.org,
        "Chuck Lever" <chuck.lever@oracle.com>,
        "Jeff Layton" <jlayton@kernel.org>,
        "Trond Myklebust" <trond.myklebust@hammerspace.com>,
        "Anna Schumaker" <anna@kernel.org>,
        "Steve French" <sfrench@samba.org>,
        "Josef Bacik" <josef@toxicpanda.com>,
        "Scott Mayhew" <smayhew@redhat.com>, "Tejun Heo" <tj@kernel.org>
Subject: Re: [RFC net] Should sk_page_frag() also look at the current GFP
 context?
Date:   Thu, 07 Jul 2022 11:31:16 -0400
Message-ID: <DFCAFA84-8FE1-45B1-914A-356244F4D307@redhat.com>
In-Reply-To: <b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com>
References: <b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1 Jul 2022, at 14:41, Guillaume Nault wrote:

> I'm investigating a kernel oops that looks similar to
> 20eb4f29b602 ("net: fix sk_page_frag() recursion from memory reclaim")
> and dacb5d8875cc ("tcp: fix page frag corruption on page fault").
>
> This time the problem happens on an NFS client, while the previous bzs
> respectively used NBD and CIFS. While NBD and CIFS clear __GFP_FS in
> their socket's ->sk_allocation field (using GFP_NOIO or GFP_NOFS), NFS
> leaves sk_allocation to its default value since commit a1231fda7e94
> ("SUNRPC: Set memalloc_nofs_save() on all rpciod/xprtiod jobs").
>
> To recap the original problems, in commit 20eb4f29b602 and 
> dacb5d8875cc,
> memory reclaim happened while executing tcp_sendmsg_locked(). The code
> path entered tcp_sendmsg_locked() recursively as pages to be reclaimed
> were backed by files on the network. The problem was that both the
> outer and the inner tcp_sendmsg_locked() calls used 
> current->task_frag,
> thus leaving it in an inconsistent state. The fix was to use the
> socket's ->sk_frag instead for the file system socket, so that the
> inner and outer calls wouln't step on each other's toes.
>
> But now that NFS doesn't modify ->sk_allocation anymore, 
> sk_page_frag()
> sees sunrpc sockets as plain TCP ones and returns ->task_frag in the
> inner tcp_sendmsg_locked() call.
>
> Also it looks like the trend is to avoid GFS_NOFS and GFP_NOIO and use
> memalloc_no{fs,io}_save() instead. So maybe other network file systems
> will also stop setting ->sk_allocation in the future and we should
> teach sk_page_frag() to look at the current GFP flags. Or should we
> stick to ->sk_allocation and make NFS drop __GFP_FS again?

We need this fix in NFS.

I think we should try to get the other filesystems to move toward
memalloc_nofs_save() as per:
Documentation/core-api/gfp_mask-from-fs-io.rst

So this looks like the right fix to me and I think if you resend it 
without
the RFC and and question in the subject, it would get picked up.

Reviewed-by: Benjamin Coddington <bcodding@redhat.com>

Ben

>
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  include/net/sock.h | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 72ca97ccb460..b934c9851058 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -46,6 +46,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/skbuff.h>	/* struct sk_buff */
>  #include <linux/mm.h>
> +#include <linux/sched/mm.h>
>  #include <linux/security.h>
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
> @@ -2503,14 +2504,17 @@ static inline void 
> sk_stream_moderate_sndbuf(struct sock *sk)
>   * socket operations and end up recursing into sk_page_frag()
>   * while it's already in use: explicitly avoid task page_frag
>   * usage if the caller is potentially doing any of them.
> - * This assumes that page fault handlers use the GFP_NOFS flags.
> + * This assumes that page fault handlers use the GFP_NOFS flags
> + * or run under memalloc_nofs_save() protection.
>   *
>   * Return: a per task page_frag if context allows that,
>   * otherwise a per socket one.
>   */
>  static inline struct page_frag *sk_page_frag(struct sock *sk)
>  {
> -	if ((sk->sk_allocation & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC | 
> __GFP_FS)) ==
> +	gfp_t gfp_mask = current_gfp_context(sk->sk_allocation);
> +
> +	if ((gfp_mask & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC | __GFP_FS)) 
> ==
>  	    (__GFP_DIRECT_RECLAIM | __GFP_FS))
>  		return &current->task_frag;
>
> -- 
> 2.21.3

This seems like th

