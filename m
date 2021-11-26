Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1C045F01A
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 15:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377639AbhKZOtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 09:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350779AbhKZOru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 09:47:50 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC868C0613B8
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 06:19:03 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so10873198wme.0
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 06:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F+1zzOaF5cpZpIdJJdzUNWA/fxzVBTmrMRDmB1uT5FE=;
        b=aYpBDuWUKzWpRddkDXdV09l7HIIKc3cigBInfRtbFlwUlq7YDn9kddL+A/gMb0IyEa
         e7uRT6ok+mpOI8d96Busn15kf51No9GDn9IAhS3v5epHrAZstMeGdtBzpe++Aacr5zG0
         MI52AaxJIZCfraZIFFgK1pWTuD/N0/f5+7xTI7mtU6b9hWZRImHRxR+27VfYrTHcYAPt
         0dG+q/zq3hXufS4Om9k+yX9OGeIIzq9LFH3erQLnUnHfyxxghOcVg5gstkWIn8E61M5B
         t2jv27Be0NIVheFxrPEa7N13o4MT3F4YVHjID0OxozVgWgu93kLYJDeazMx6Jiz9V4pB
         occw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F+1zzOaF5cpZpIdJJdzUNWA/fxzVBTmrMRDmB1uT5FE=;
        b=xiZVZvdigRPOXQMlO98ybHyQBbihuh8hWO+iDGHlGe6XS0cjTANK/kw6w+rNE+81SI
         ycqzEZx2Pp49Gq46EA2AWvSwh82AvF7gQG+e94ePqDaxfGdHXq/0n/Cb89u8XV2u+l9x
         UJhNEVIP7I+bjF50yTm4CPlbyX+witk6DHKU1nFw4xOsP+At5FgsdfouyoCfz7LExnRP
         Bic4AlroV+5oVss7TD5tLqcyorj1VCJW9W9YgGGBs+2BMhQ2kikA06FfWQeY2XYRU9Rt
         9OHh6U/FmWD4N4Hj55vMwSXN04o8br3zsZFYn+UsPfhpD3d8YSoQOjC9q9IW8bgTaYCp
         KzWA==
X-Gm-Message-State: AOAM533ItuAifnLJeyTA+jIoBRx5xRiiC/qroNlzmj4YTeO11hVcBQxS
        qF6TZWReY+l2H8TWZkv03GIFlpkKTBHKXrHScsaYBgJIVFjOfA==
X-Google-Smtp-Source: ABdhPJypEAUN9iKbiSJ5rtF/tvr+Wj6V/UrbyXnR1tPOKQxWTCJeyUxoJCR5suG0OaZDKx0y6jlR/BWOstBL6BBqpfg=
X-Received: by 2002:a05:600c:3ba3:: with SMTP id n35mr16202591wms.88.1637936341806;
 Fri, 26 Nov 2021 06:19:01 -0800 (PST)
MIME-Version: 1.0
References: <d77eb546e29ce24be9ab88c47a66b70c52ce8109.1637923678.git.pabeni@redhat.com>
In-Reply-To: <d77eb546e29ce24be9ab88c47a66b70c52ce8109.1637923678.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Nov 2021 06:18:49 -0800
Message-ID: <CANn89iJdg0qFvnykrtGx5OrV3zQTEtm2htTOFtaK-nNwNmOmDA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix page frag corruption on page fault
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Steffen Froemer <sfroemer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 4:00 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Steffen reported a TCP stream corruption for HTTP requests
> served by the apache web-server using a cifs mount-point
> and memory mapping the relevant file.
>
> The root cause is quite similar to the one addressed by
> commit 20eb4f29b602 ("net: fix sk_page_frag() recursion from
> memory reclaim"). Here the nested access to the task page frag
> is caused by a page fault on the (mmapped) user-space memory
> buffer coming from the cifs file.
>
> The page fault handler performs an smb transaction on a different
> socket, inside the same process context. Since sk->sk_allaction
> for such socket does not prevent the usage for the task_frag,
> the nested allocation modify "under the hood" the page frag
> in use by the outer sendmsg call, corrupting the stream.
>
> The overall relevant stack trace looks like the following:
>
> httpd 78268 [001] 3461630.850950:      probe:tcp_sendmsg_locked:
>         ffffffff91461d91 tcp_sendmsg_locked+0x1
>         ffffffff91462b57 tcp_sendmsg+0x27
>         ffffffff9139814e sock_sendmsg+0x3e
>         ffffffffc06dfe1d smb_send_kvec+0x28
>         [...]
>         ffffffffc06cfaf8 cifs_readpages+0x213
>         ffffffff90e83c4b read_pages+0x6b
>         ffffffff90e83f31 __do_page_cache_readahead+0x1c1
>         ffffffff90e79e98 filemap_fault+0x788
>         ffffffff90eb0458 __do_fault+0x38
>         ffffffff90eb5280 do_fault+0x1a0
>         ffffffff90eb7c84 __handle_mm_fault+0x4d4
>         ffffffff90eb8093 handle_mm_fault+0xc3
>         ffffffff90c74f6d __do_page_fault+0x1ed
>         ffffffff90c75277 do_page_fault+0x37
>         ffffffff9160111e page_fault+0x1e
>         ffffffff9109e7b5 copyin+0x25
>         ffffffff9109eb40 _copy_from_iter_full+0xe0
>         ffffffff91462370 tcp_sendmsg_locked+0x5e0
>         ffffffff91462370 tcp_sendmsg_locked+0x5e0
>         ffffffff91462b57 tcp_sendmsg+0x27
>         ffffffff9139815c sock_sendmsg+0x4c
>         ffffffff913981f7 sock_write_iter+0x97
>         ffffffff90f2cc56 do_iter_readv_writev+0x156
>         ffffffff90f2dff0 do_iter_write+0x80
>         ffffffff90f2e1c3 vfs_writev+0xa3
>         ffffffff90f2e27c do_writev+0x5c
>         ffffffff90c042bb do_syscall_64+0x5b
>         ffffffff916000ad entry_SYSCALL_64_after_hwframe+0x65
>
> A possible solution would be adding the __GFP_MEMALLOC flag
> to the cifs allocation. That looks dangerous, as the memory
> allocated by the cifs fs will not be free soon and such
> allocation will not allow for more memory to be freed.
>
> Instead, this patch changes the tcp_sendmsg() code to avoid
> touching the page frag after performing the copy from the
> user-space buffer. Any page fault or memory reclaim operation
> there is now free to touch the task page fragment without
> corrupting the state used by the outer sendmsg().
>
> As a downside, if the user-space copy fails, there will be
> some additional atomic operations due to the reference counting
> on the faulty fragment, but that looks acceptable for a slow
> error path.
>
> Reported-by: Steffen Froemer <sfroemer@redhat.com>
> Fixes: 5640f7685831 ("net: use a per task frag allocator")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/ipv4/tcp.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index bbb3d39c69af..2d85636c1577 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1304,6 +1304,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>                         bool merge = true;
>                         int i = skb_shinfo(skb)->nr_frags;
>                         struct page_frag *pfrag = sk_page_frag(sk);
> +                       unsigned int offset;
>
>                         if (!sk_page_frag_refill(sk, pfrag))
>                                 goto wait_for_space;
> @@ -1331,14 +1332,11 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>                         if (!sk_wmem_schedule(sk, copy))
>                                 goto wait_for_space;
>
> -                       err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
> -                                                      pfrag->page,
> -                                                      pfrag->offset,
> -                                                      copy);
> -                       if (err)
> -                               goto do_error;
> -
> -                       /* Update the skb. */
> +                       /* Update the skb before accessing the user space buffer
> +                        * so that we leave the task frag in a consistent state.
> +                        * Just in case the page_fault handler need to use it
> +                        */
> +                       offset = pfrag->offset;
>                         if (merge) {
>                                 skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
>                         } else {
> @@ -1347,6 +1345,12 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>                                 page_ref_inc(pfrag->page);
>                         }
>                         pfrag->offset += copy;
> +
> +                       err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
> +                                                      pfrag->page,
> +                                                      offset, copy);
> +                       if (err)
> +                               goto do_error;
>                 } else {
>                         /* First append to a fragless skb builds initial
>                          * pure zerocopy skb
> --
> 2.33.1
>

This patch is completely wrong, you just horribly broke TCP.

Please investigate CIFS and gfpflags_normal_context() tandem to fix
this issue instead.

CIFS needs to make sure TCP will use the private socket sk->sk_frag
