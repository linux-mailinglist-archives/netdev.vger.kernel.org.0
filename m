Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64698286960
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgJGUrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 16:47:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727817AbgJGUrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 16:47:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED98620782;
        Wed,  7 Oct 2020 20:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602103668;
        bh=QkyYBwYAU0gbcgieGpN8QBhSkiPhbX6uskPmAzkOR4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oYncJtbUkQrwNOc2HFdtVvcxKKmpAV0uUVzfaSSe4oOYdg6pZ2QC3MSTuXP3vtRDA
         rW0LaMz4sFrN9VhDI4VcCJXq9DVvfQuHuZscf3iv5SWNAE2egE9cyaSPtgCSDcfpN/
         4WBa9K8uzK0yAyTbGjqmTgWWmmiPTCcctiXd+UPg=
Date:   Wed, 7 Oct 2020 13:47:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pooja Trivedi <poojatrivedi@gmail.com>
Cc:     linux-crypto@vger.kernel.org,
        Mallesham Jatharakonda <mallesh537@gmail.com>,
        Josh Tway <josh.tway@stackpath.com>, netdev@vger.kernel.org
Subject: Re: [RFC 1/1] net/tls(TLS_SW): Handle -ENOSPC error return from
 device/AES-NI
Message-ID: <20201007134746.069d7f2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAOrEdsnCbcKiNoyHB=mX2h8soG1txX+aynZaFLNhtwMZWTDkEg@mail.gmail.com>
References: <CAOrEdsmKn7_YWcWZ_b7+mL-uJC8m_=tU70q3aZTOzEDYw7j4ng@mail.gmail.com>
        <CAOrEdsnCbcKiNoyHB=mX2h8soG1txX+aynZaFLNhtwMZWTDkEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Oct 2020 15:19:47 -0400 Pooja Trivedi wrote:
> When an -ENOSPC error code is returned by the crypto device or AES-NI
> layer, TLS SW path sets an EBADMSG on the socket causing the
> application to fail.  In an attempt to address the -ENOSPC in the TLS
> SW path, changes were made in tls_sw_sendpage path to trim current
> payload off the plain and encrypted messages, and send a 'zero bytes
> copied' return to the application.  The following diff shows those
> changes:
> 
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 9a3d9fedd7aa..4dce4668cb07 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -762,7 +762,7 @@ static int tls_push_record(struct sock *sk, int flags,
>   rc = tls_do_encryption(sk, tls_ctx, ctx, req,
>         msg_pl->sg.size + prot->tail_size, i);
>   if (rc < 0) {
> -               if (rc != -EINPROGRESS) {
> +              if ((rc != -EINPROGRESS) && (rc != -ENOSPC)) {
>                             tls_err_abort(sk, EBADMSG);
>                             if (split) {
> 
> tls_ctx->pending_open_record_frags = true;
> 
> @@ -1073,8 +1073,15 @@ int tls_sw_sendmsg(struct sock *sk, struct
> msghdr *msg, size_t size)
>   else if (ret == -ENOMEM)
>                goto wait_for_memory;
>   else if (ret != -EAGAIN) {
> -              if (ret == -ENOSPC)
> +             if (ret == -ENOSPC) {
>                           ret = 0;
>                           copied -= try_to_copy;
>                           iov_iter_revert(&msg->msg_iter,
> msg_pl->sg.size - orig_size);
>                           tls_trim_both_msgs(sk, orig_size);
>                }
>                goto send_end;
>      }
>   }
> 
> @@ -1150,6 +1157,7 @@ static int tls_sw_do_sendpage(struct sock *sk,
> struct page *page,
>   ssize_t copied = 0;
>   bool full_record;
>   int record_room;
> + int orig_size;
>   int ret = 0;
>   bool eor;
> 
> @@ -1175,7 +1183,7 @@ static int tls_sw_do_sendpage(struct sock *sk,
> struct page *page,
>   }
> 
>   msg_pl = &rec->msg_plaintext;
> -
> + orig_size = msg_pl->sg.size;
>   full_record = false;
>   record_room = TLS_MAX_PAYLOAD_SIZE - msg_pl->sg.size;
>   copy = size;
> 
> @@ -1219,8 +1227,12 @@ static int tls_sw_do_sendpage(struct sock *sk,
> struct page *page,
> 
>   else if (ret == -ENOMEM)
>              goto wait_for_memory;
>   else if (ret != -EAGAIN) {
> -            if (ret == -ENOSPC)
> +           if (ret == -ENOSPC) {
> +                      tls_trim_both_msgs(sk, orig_size);
>                         copied -= copy;
>                         ret = 0;
>               }
>               goto sendpage_end;
>    }
>   }
> 
> 
> However, when above patch was tried, the application tried to send
> remaining data based on the offset as expected, but encryption failed
> due to data integrity issues.  Further debugging revealed that
> sk_msg_trim(), called by tls_trim_both_msgs() does not update the page
> frag offset.  It seems like sk_msg_trim() needs to subtract the trim
> length from the pfrag->offset corresponding to how the sk_msg_alloc()
> call increments the pfrag-->offset with the length it charges to the
> socket via sk_mem_charge().
> When sk_msg_trim() calls sk_mem_uncharge() to uncharge trim length off
> the socket, it should also perform
>            pfrag->offset -= trim;

Let's CC netdev. It's a bit surprising to me that pfrag->offset matters
here, we're basically "wasting" a bit of the page but why would that
cause data integrity issues?

> While the sk_msg_trim() pfrag->offset subtraction change hasn't been
> tried yet, the following hack in TLS layer has been tried and has
> correctly worked. This proves that the above observation/theory
> regarding pfrag->offset update would be the fix:
> 
> 
> +                                       if (ret == -ENOSPC) {
> +                                               struct page_frag *pfrag;
> +                                               tls_trim_both_msgs(sk,
> orig_size);
> +
> +                                               copied -= copy;
> +                                               pfrag = sk_page_frag(sk);
> +                                               pfrag->offset -= copy;
> 
> 
> What are your thoughts on the best way to fix the issue?
> sk_msg_trim() seems like the most logical place, but
> suggestions/comments/questions are welcome.
> 
> Another thing to think about is whether -EBUSY should be handled
> similarly. Vendors have differences and the conditions under which
> these error codes are returned are not very consistent when the sidecar
> device path is involved.

Why would the driver return EBUSY from an async API? What's the caller
supposed to do with that?


While we have you - weren't you sending a sendpage() fix at some point?
Did that get lost?
