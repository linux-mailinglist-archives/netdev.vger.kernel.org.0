Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC70F690DE7
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 17:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbjBIQGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 11:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbjBIQGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 11:06:04 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8615F658DF;
        Thu,  9 Feb 2023 08:05:40 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id a1so2878858ybj.9;
        Thu, 09 Feb 2023 08:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yQadYf6e65UEzea3KfRKlYcIL6JHJlniZ3uGgG4Zjmc=;
        b=hNJHb+saLoK+h1yUMOKPgOXT+9OQqIvgDPdmByuD4rumVAGAjW2dGG74VXtmy6d+EL
         7lqey5Nagk6GqVmI2B0bppX1UVXuy8toeU4XdEvzCcozavpNESiCB59eig8VwKdNpXSq
         xuiaeQXsuS9NGAswpKrRbN25Fbx2DILKrJuZ+EcgfrtFYqvPkPQz7EQ8deOJlUTGSaUb
         mfzrN+HsDAZ0OdeCv98FoBSNwsLwpJsROWu3HqIXIEP13ymQO5kzhXXKUrfitPEEyAay
         gzp5KudbfktB8QI2NzqhJa8feLiP0Cd1l69Hr9zjv9MGBcOjlLL6d/rO6qbavvo0HFPv
         QC9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yQadYf6e65UEzea3KfRKlYcIL6JHJlniZ3uGgG4Zjmc=;
        b=gSeQGgsW/r/VCrKfmZDnUwMxmrymP7R5NSssjlaExJ09O+ySqGwWH9ZBq+KM8HY/eD
         B4BafHLM34okPgBRjbmsXkKgBwysj73Gb8bN9WI4UX8pHDuf2LQV+S0tYaOJuWiwe4+M
         VvyajrNvr9IIc5Z3bI4oSAHZUGEYZGdy+AG++dcYrs9sdCY1vK/SxpSCMyrQeT0EoPgL
         Z0JaBdwQ2ODMqujADLC+ZwsyXSeTQFkVBG1qlhw2wVJvyvRJUzT7Mb8VYvZ0Vic4GPba
         8SwVxotl6FzyMxf4c5VqLYPdjDkk/zilnGKxxGqN4rsh42u3o317pZCjES4HqoMYfN7M
         steA==
X-Gm-Message-State: AO0yUKXCtsSh3/3veHIG4mlVdotWIQp5Dc0RsjrWss2gTbdoUKRFhqOA
        R86LGkOM9LEESbXWiA4dzVXZiPHdEKF4ZZeVG6c=
X-Google-Smtp-Source: AK7set93RpLeNZwu3FKKGkXQO4ltKMAPuEA2SRD3vcAjWtWTHPrm/kxn2Hu0gUBQXIfU+zoHGp/Uj/sboB8B1b2SCF0=
X-Received: by 2002:a5b:905:0:b0:8ad:1128:f8fb with SMTP id
 a5-20020a5b0905000000b008ad1128f8fbmr1559622ybq.337.1675958739628; Thu, 09
 Feb 2023 08:05:39 -0800 (PST)
MIME-Version: 1.0
References: <20230208-sctp-filter-v2-1-6e1f4017f326@diag.uniroma1.it>
In-Reply-To: <20230208-sctp-filter-v2-1-6e1f4017f326@diag.uniroma1.it>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 9 Feb 2023 11:05:13 -0500
Message-ID: <CADvbK_fAOS_4efEVaEc8swS33fY+MH=Qrteg1KLyPaxQ1BaZvg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] sctp: sctp_sock_filter(): avoid list_entry()
 on possibly empty list
To:     Pietro Borrello <borrello@diag.uniroma1.it>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 9, 2023 at 7:13 AM Pietro Borrello
<borrello@diag.uniroma1.it> wrote:
>
> Use list_is_first() to check whether tsp->asoc matches the first
> element of ep->asocs, as the list is not guaranteed to have an entry.
>
> Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
> Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
> ---
> Changes in v2:
> - Use list_is_first()
> - Link to v1: https://lore.kernel.org/r/20230208-sctp-filter-v1-1-84ae70d90091@diag.uniroma1.it
> ---
>
> The list_entry on an empty list creates a type confused pointer.
> While using it is undefined behavior, in this case it seems there
> is no big risk, as the `tsp->asoc != assoc` check will almost
> certainly fail on the type confused pointer.
> We report this bug also since it may hide further problems since
> the code seems to assume a non-empty `ep->asocs`.
>
> We were able to trigger sctp_sock_filter() using syzkaller, and
> cause a panic inserting `BUG_ON(list_empty(&ep->asocs))`, so the
> list may actually be empty.
> But we were not able to minimize our testcase and understand how
> sctp_sock_filter may end up with an empty asocs list.
> We suspect a race condition between a connecting sctp socket
> and the diag query.
>
> We attach the stacktrace when triggering the injected
> `BUG_ON(list_empty(&ep->asocs))`:
>
> ```
> [  217.044169][T18237] kernel BUG at net/sctp/diag.c:364!
> [  217.044845][T18237] invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> [  217.045681][T18237] CPU: 0 PID: 18237 Comm: syz-executor Not
> tainted 6.1.0-00003-g190ee984c3e0-dirty #72
> [  217.046934][T18237] Hardware name: QEMU Standard PC (i440FX +
> PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [  217.048241][T18237] RIP: 0010:sctp_sock_filter+0x1ce/0x1d0
> [...]
> [  217.060554][T18237] Call Trace:
> [  217.061003][T18237]  <TASK>
> [  217.061409][T18237]  sctp_transport_traverse_process+0x17d/0x470
> [  217.062212][T18237]  ? sctp_ep_dump+0x620/0x620
> [  217.062835][T18237]  ? sctp_sock_filter+0x1d0/0x1d0
> [  217.063524][T18237]  ? sctp_transport_lookup_process+0x280/0x280
> [  217.064330][T18237]  ? sctp_diag_get_info+0x260/0x2c0
> [  217.065026][T18237]  ? sctp_for_each_endpoint+0x16f/0x200
> [  217.065762][T18237]  ? sctp_diag_get_info+0x2c0/0x2c0
> [  217.066435][T18237]  ? sctp_for_each_endpoint+0x1c0/0x200
> [  217.067155][T18237]  sctp_diag_dump+0x2ea/0x480
> [...]
> [  217.093117][T18237]  do_writev+0x22d/0x460
> ```
> ---
>  net/sctp/diag.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> index a557009e9832..c3d6b92dd386 100644
> --- a/net/sctp/diag.c
> +++ b/net/sctp/diag.c
> @@ -343,11 +343,9 @@ static int sctp_sock_filter(struct sctp_endpoint *ep, struct sctp_transport *tsp
>         struct sctp_comm_param *commp = p;
>         struct sock *sk = ep->base.sk;
>         const struct inet_diag_req_v2 *r = commp->r;
> -       struct sctp_association *assoc =
> -               list_entry(ep->asocs.next, struct sctp_association, asocs);
>
>         /* find the ep only once through the transports by this condition */
> -       if (tsp->asoc != assoc)
> +       if (!list_is_first(&tsp->asoc->asocs, &ep->asocs))
>                 return 0;
>
>         if (r->sdiag_family != AF_UNSPEC && sk->sk_family != r->sdiag_family)
>
> ---
> base-commit: 4ec5183ec48656cec489c49f989c508b68b518e3
> change-id: 20230208-sctp-filter-73453e659360
>
> Best regards,
> --
> Pietro Borrello <borrello@diag.uniroma1.it>
>
Acked-by: Xin Long <lucien.xin@gmail.com>
