Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D9C56A819
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 18:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbiGGQ3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 12:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235723AbiGGQ3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 12:29:17 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE9F286D8
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 09:29:15 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id n74so3756257yba.3
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 09:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KdtnEcHUawpT1fLqKoUoq9rzfwMk1MR8HOGPic52smQ=;
        b=PqLmuFJ6AJjlrfAe08BEJii6fjSCA3hTYgqjqhvQ0eAf9GOP1LYpAJ0JJpo/QifbXZ
         hZClkaAzya/x2KQSh85giAW/OTMFBavIza1VA2zlTmzT6jC6D9JPdFmcTz4BzcVSncSl
         auyMDldebekRIb+1GZa9DG/KY0TxLCPA8foCbdylWWNRFS1CFm0EZvGcCgRmfMsMdM+T
         CfQXv7YCDFexKQHWOfJZ+8cnaHaCkNB44Gf/Y5NtybOl6qebO8pw5ItTB183zpXK1usD
         CNtrmwy9gkDn3EF2envDhcMXrUtLI6pPn3f5YUbjq63RDpzpohRE8s6ERwBsct3FNWYT
         AvxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KdtnEcHUawpT1fLqKoUoq9rzfwMk1MR8HOGPic52smQ=;
        b=aJb63hcU2RosmKmQp7H+QtuxJDG4qXB94QUiTsprJz3q41j9rnKA9dxavfM9MUWFNH
         Ve0pjclE/fi0PM936LsXbxO3tq5uuC5gNlHcOoVrFMe41i+Sfh+0RoZ0kbqBe+a3jtiQ
         MUm/YcSAAilndj/p+iCNchEQoec4+yR61PCxmhaYJV36HT8xDGk6Lixg11xReascwEZ6
         2glg/TOQKQGa8V5cFkyfauTdw7GtHvQtKIL83Secndcvm7613T8vPb9HCq/nSrJ87elu
         z8bHAm2hazpso72N0luWi6E7OcaFABn2cNwhcnWCFrnZcDBOKh+EQVx+buwYp20cMPRT
         x8ew==
X-Gm-Message-State: AJIora/PuRmcEBnTCB7GXPiGPwnTpMf4wy7RIQ2w/wufBnmAtS6Il1ZZ
        u/B689j0nl3sYskBsc5acwV+yIJ7E8C1deqM+mppVl3pOoYVug==
X-Google-Smtp-Source: AGRyM1vIRaSO5WewEYiFRJN0ER5hk5pa+VL5vWI8WlRfO9dMQKUuYerHSqvg3mKecQUKb/wAwsw0GwTrz8JhMDlwEcU=
X-Received: by 2002:a25:3383:0:b0:66b:6205:1583 with SMTP id
 z125-20020a253383000000b0066b62051583mr48661067ybz.387.1657211354704; Thu, 07
 Jul 2022 09:29:14 -0700 (PDT)
MIME-Version: 1.0
References: <b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com>
In-Reply-To: <b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 7 Jul 2022 18:29:03 +0200
Message-ID: <CANn89i+=GyHjkrHMZAftB-toEhi9GcAQom1_bpT+S0qMvCz0DQ@mail.gmail.com>
Subject: Re: [RFC net] Should sk_page_frag() also look at the current GFP context?
To:     Guillaume Nault <gnault@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Steve French <sfrench@samba.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Scott Mayhew <smayhew@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 1, 2022 at 8:41 PM Guillaume Nault <gnault@redhat.com> wrote:
>
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
> To recap the original problems, in commit 20eb4f29b602 and dacb5d8875cc,
> memory reclaim happened while executing tcp_sendmsg_locked(). The code
> path entered tcp_sendmsg_locked() recursively as pages to be reclaimed
> were backed by files on the network. The problem was that both the
> outer and the inner tcp_sendmsg_locked() calls used current->task_frag,
> thus leaving it in an inconsistent state. The fix was to use the
> socket's ->sk_frag instead for the file system socket, so that the
> inner and outer calls wouln't step on each other's toes.
>
> But now that NFS doesn't modify ->sk_allocation anymore, sk_page_frag()
> sees sunrpc sockets as plain TCP ones and returns ->task_frag in the
> inner tcp_sendmsg_locked() call.
>
> Also it looks like the trend is to avoid GFS_NOFS and GFP_NOIO and use
> memalloc_no{fs,io}_save() instead. So maybe other network file systems
> will also stop setting ->sk_allocation in the future and we should
> teach sk_page_frag() to look at the current GFP flags. Or should we
> stick to ->sk_allocation and make NFS drop __GFP_FS again?
>
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Can you provide a Fixes: tag ?

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
>  #include <linux/skbuff.h>      /* struct sk_buff */
>  #include <linux/mm.h>
> +#include <linux/sched/mm.h>
>  #include <linux/security.h>
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
> @@ -2503,14 +2504,17 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
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
> -       if ((sk->sk_allocation & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC | __GFP_FS)) ==
> +       gfp_t gfp_mask = current_gfp_context(sk->sk_allocation);

This is slowing down TCP sendmsg() fast path, reading current->flags,
possibly cold value.

I would suggest using one bit in sk, close to sk->sk_allocation to
make the decision,
instead of testing sk->sk_allocation for various flags.

Not sure if we have available holes.

> +
> +       if ((gfp_mask & ( | __GFP_MEMALLOC | __GFP_FS)) ==
>             (__GFP_DIRECT_RECLAIM | __GFP_FS))
>                 return &current->task_frag;
>
> --
> 2.21.3
>
