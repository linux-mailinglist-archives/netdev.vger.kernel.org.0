Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8C53D677B
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 21:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhGZSqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 14:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbhGZSqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 14:46:36 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198A6C061760
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 12:27:04 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id e14so12947288plh.8
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 12:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hoMlUsxgOOMGyLP12ayUGrpST+sHWMEehNbEOHJGoRk=;
        b=ddbNF3f4TElNBsVQqChP50/s0j6AMvocnzqu/pOjrladH5tctXf84jU1JXLONMhhHM
         DDaFTH0/VyAUvD2dxdLKsjInLVqQvQiDonyje1Zmo2WyogzYSSYH4BFwP1lp6U/2m6OZ
         wqK4s1kD8T7b1+flKvlcDsNDXfG7l+NL/+L8Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hoMlUsxgOOMGyLP12ayUGrpST+sHWMEehNbEOHJGoRk=;
        b=SkV9XIVjM5Xx9ehnyi6hkrwd9aqDne4b/3rCmNM3KGCfOXf/LuTrSB5diLdQdcIDQE
         A7f6Tr3DFOH2SdWe8dBcTnAs3gXgwzjXjW19N/U+Wx/KuSjqE1R8pDdLG14BpsaIbMYd
         jVHqqprI48uFgAefgORYRu4SLN2UV8/9QylAsHURQnJbnIdvirGFqg6cwRiK6I1y5aH9
         hC0r3aeERFAuZ2APgM7G31yl2rvCx3A1r1WZksrKigf8jcxugkQPjtNY3587fNZ9kJXl
         ibqa0b6NzJlbyokqblp38WBxtcU9jGfRejML1XlPoBI26kfbItTCthEADhD40hUoyJ1N
         Ir7w==
X-Gm-Message-State: AOAM531s/o2a3QQzoziN9bD2BHRmuWFt26f6UZVd6K/No2N97/8C6vw0
        XpLuyyKx3e2e2DnsyQl0DDlO/A==
X-Google-Smtp-Source: ABdhPJywrEtEv4h4Eh+iM8aL7EAjhtx6Xn/lXC18vPIDXhD87eVvoQlRbvHZKQPJXa+pZqw1iI0wEg==
X-Received: by 2002:aa7:980a:0:b029:358:adf9:c37b with SMTP id e10-20020aa7980a0000b0290358adf9c37bmr19394081pfl.12.1627327623361;
        Mon, 26 Jul 2021 12:27:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q14sm851027pfn.73.2021.07.26.12.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 12:27:02 -0700 (PDT)
Date:   Mon, 26 Jul 2021 12:27:01 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH net] af_unix: fix garbage collect vs. MSG_PEEK
Message-ID: <202107261049.DC0C9178@keescook>
References: <20210726153621.2658658-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726153621.2658658-1-gregkh@linuxfoundation.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 05:36:21PM +0200, Greg Kroah-Hartman wrote:
> From: Miklos Szeredi <mszeredi@redhat.com>
> 
> Gc assumes that in-flight sockets that don't have an external ref can't

I think this commit log could be expanded. I had to really study things
to even beging to understand what was going on. I assume "Gc" here means
specifically unix_gc()?

> gain one while unix_gc_lock is held.  That is true because
> unix_notinflight() will be called before detaching fds, which takes
> unix_gc_lock.

In reading the code, I *think* what is being protected by unix_gc_lock is
user->unix_inflight, u->inflight, unix_tot_inflight, and gc_inflight_list?

I note that unix_tot_inflight isn't an atomic but is read outside of
locking by unix_release_sock() and wait_for_unix_gc(), which seems wrong
(or at least inefficient).

But regardless, are the "external references" the f_count (i.e. get_file()
of u->sk.sk_socket->file) being changed by scm_fp_dup() and read by
unix_gc() (i.e. file_count())? It seems the test in unix_gc() is for
the making sure f_count isn't out of sync with u->inflight (is this the
corresponding "internal" reference?):

                total_refs = file_count(u->sk.sk_socket->file);
                inflight_refs = atomic_long_read(&u->inflight);

                BUG_ON(inflight_refs < 1);
                BUG_ON(total_refs < inflight_refs);
                if (total_refs == inflight_refs) {

> Only MSG_PEEK was somehow overlooked.  That one also clones the fds, also
> keeping them in the skb.  But through MSG_PEEK an external reference can
> definitely be gained without ever touching unix_gc_lock.

The idea appears to be that all scm_fp_dup() callers need to refresh the
u->inflight counts which is what unix_attach_fds() and unix_detach_fds()
do. Why is lock/unlock sufficient for unix_peek_fds()?

I assume the rationale is because MSG_PEEK uses a temporary scm, which
only gets fput() clean-up on destroy ("inflight" is neither incremented
nor decremented at any point in the scm lifetime).

But I don't see why any of this helps.

unix_attach_fds():
	fget(), spin_lock(), inflight++, spin_unlock()
unix_detach_fds():
	spin_lock(), inflight--, spin_unlock(), fput()
unix_peek_fds():
	fget(), spin_lock(), spin_unlock()
unix_gx():
	spin_lock(), "total_refs == inflight_refs" to hitlist,
	spin_unlock(), free hitlist skbs

Doesn't this mean total_refs and inflight_refs can still get out of
sync? What keeps an skb from being "visible" to unix_peek_fds() between
the unix_gx() spin_unlock() and the unix_peek_fds() fget()?

A: unix_gx():
	spin_lock()
	find "total_refs == inflight_refs", add to hitlist
	spin_unlock()
B: unix_peek_fds():
	fget()
A: unix_gc():
	walk hitlist and free(skb)
B: unix_peek_fds():
	*use freed skb*

I feel like I must be missing something since the above race would
appear to exist even for unix_attach_fds()/unix_detach_fds():

A: unix_gx():
	spin_lock()
	find "total_refs == inflight_refs", add to hitlist
	spin_unlock()
B: unix_attach_fds():
	fget()
A: unix_gc():
	walk hitlist and free(skb)
B: unix_attach_fds():
	*use freed skb*

I'm assuming I'm missing a top-level usage count on skb that is held by
callers, which means the skb isn't actually freed by unix_gc(). But I
return to not understanding why adding the lock/unlock helps.

What are the expected locking semantics here?

-Kees

> 
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/unix/af_unix.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> Note, this is a resend of this old submission that somehow fell through
> the cracks:
> 	https://lore.kernel.org/netdev/CAOssrKcfncAYsQWkfLGFgoOxAQJVT2hYVWdBA6Cw7hhO8RJ_wQ@mail.gmail.com/
> and was never submitted "properly" and this issue never seemed to get
> resolved properly.
> 
> I've cleaned it up and made the change much smaller and localized to
> only one file.  I kept Miklos's authorship as he did the hard work on
> this, I just removed lines and fixed a formatting issue :)
> 
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 23c92ad15c61..cdea997aa5bf 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1526,6 +1526,18 @@ static int unix_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
>  	return err;
>  }
>  
> +static void unix_peek_fds(struct scm_cookie *scm, struct sk_buff *skb)
> +{
> +	scm->fp = scm_fp_dup(UNIXCB(skb).fp);
> +
> +	/* During garbage collection it is assumed that in-flight sockets don't
> +	 * get a new external reference.  So we need to wait until current run
> +	 * finishes.
> +	 */
> +	spin_lock(&unix_gc_lock);
> +	spin_unlock(&unix_gc_lock);
> +}


-- 
Kees Cook
