Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE51554B8C8
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 20:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241861AbiFNSj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 14:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbiFNSj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 14:39:26 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6C93584C
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 11:39:25 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id l12so3611531uan.5
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 11:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WSwsbC7CrxmTIJa8mY/YZVvyjVCeZE4/7gorKhBoSLE=;
        b=oliTjXjlFpa6xeM2I6nowGvDiSIoCzi8L0c6VXeGfXI4vd7VQejaci+6EzXVvishxh
         j1MPSWUzoaw3+/6L40sEMXVnyjk+Ud47AQcdXBzJSkMbUW7QYRPZhTBFaDSIryfd3pOx
         hYMyldMrqFlGF5uSLasC9niirdI7FVQE3BJnoxdJ/rWFfyZOilbm8uYpWP4/pLTVxX4k
         ImpYoVBgM5QAFEw3EYenezaKrlBtThbZpSK9Sjn6Dl9GD1VFqYnRsXr7Wz0YjPdmF94R
         EqavZDgxfs8A/OJxYMFNCdoO98luITDwbx9MHF2eDqy0ZzOdYS5HANapXCZOGgkfEFjC
         3u+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WSwsbC7CrxmTIJa8mY/YZVvyjVCeZE4/7gorKhBoSLE=;
        b=qtp/4MMitbtkaReaKycG/1ePEBafwnKp9e14Y9QfkhO/qu3YLQ62azcN8ghL3kvvO5
         ZIYvGkdXMcStjzLNUO4SHvdIOI9w1Xd8HgmSP/5Tac7T2j+w6Lymjk0VAOnozSjzvv1M
         MfgMwqH17znHtfLI4Pf2wOSwffwEnxhsIjuiCLMdQ9py0Ox6q+Xvl0WzcUE6aUu65Ro6
         ymaQhwS/cq5070Ee0qPyB63oy5pXvok1rVgML38SpuwBq9zi0hdu43hp7nQ/bZpQAVgE
         qkxIzkxHZP1Kg5yXoLskyKfbpht1/kAwS60F8H3eHTbiaTCeyMoR2yVmPFT5vCh5JSGu
         Lkng==
X-Gm-Message-State: AJIora+AyIfDQyIh4MAgOH8Wq8fc0uvXMa3rJzVVqMDZqfZXvAGKrZF3
        SCGkdhaeh/+JfXP4Tbd7ijUwHbEy93Kj1RAMvfhtlA==
X-Google-Smtp-Source: AGRyM1u2ep66lFljGclOK5rJtpH6aLnS0qeZtqDQszT3iv5YThb6p8vrvf7i7whmIsr1E+hQ9WgT290Yxq4htOK16AM=
X-Received: by 2002:a9f:2e0f:0:b0:379:6861:b4b2 with SMTP id
 t15-20020a9f2e0f000000b003796861b4b2mr3162240uaj.22.1655231964638; Tue, 14
 Jun 2022 11:39:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220614171734.1103875-1-eric.dumazet@gmail.com>
 <20220614171734.1103875-2-eric.dumazet@gmail.com> <CACSApvYMCum+4HWeB0rBgh2QJuOFcW=9f0ib_MHF11Tu3168Qw@mail.gmail.com>
In-Reply-To: <CACSApvYMCum+4HWeB0rBgh2QJuOFcW=9f0ib_MHF11Tu3168Qw@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 14 Jun 2022 11:39:13 -0700
Message-ID: <CAEA6p_A91+jnVSx3tiKQiq38bXM-0GOBx4auQMA=xPRTbcp3VA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 1/2] tcp: fix over estimation in sk_forced_mem_schedule()
To:     Soheil Hassas Yeganeh <soheil@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
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

On Tue, Jun 14, 2022 at 10:41 AM Soheil Hassas Yeganeh
<soheil@google.com> wrote:
>
> On Tue, Jun 14, 2022 at 1:17 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> >
> > sk_forced_mem_schedule() has a bug similar to ones fixed
> > in commit 7c80b038d23e ("net: fix sk_wmem_schedule() and
> > sk_rmem_schedule() errors")
> >
> > While this bug has little chance to trigger in old kernels,
> > we need to fix it before the following patch.
> >
> > Fixes: d83769a580f1 ("tcp: fix possible deadlock in tcp_send_fin()")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Wei Wang <weiwan@google.com>

>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
>
> > ---
> >  net/ipv4/tcp_output.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index 8ab98e1aca6797a51eaaf8886680d2001a616948..18c913a2347a984ae8cf2793bb8991e59e5e94ab 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -3362,11 +3362,12 @@ void tcp_xmit_retransmit_queue(struct sock *sk)
> >   */
> >  void sk_forced_mem_schedule(struct sock *sk, int size)
> >  {
> > -       int amt;
> > +       int delta, amt;
> >
> > -       if (size <= sk->sk_forward_alloc)
> > +       delta = size - sk->sk_forward_alloc;
> > +       if (delta <= 0)
> >                 return;
> > -       amt = sk_mem_pages(size);
> > +       amt = sk_mem_pages(delta);
> >         sk->sk_forward_alloc += amt << PAGE_SHIFT;
> >         sk_memory_allocated_add(sk, amt);
> >
> > --
> > 2.36.1.476.g0c4daa206d-goog
> >
