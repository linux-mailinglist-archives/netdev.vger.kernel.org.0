Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D321D4E656F
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 15:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351114AbiCXOk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 10:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351025AbiCXOk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 10:40:26 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35AE35DF8
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 07:38:54 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id f38so8825121ybi.3
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 07:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5eazXpvUYRuHpEXSXh/7pV6yjwLyPDdyTbYcpugheYI=;
        b=LZYbEpYPqdt2rybMGihDWkehY74Bx/oRyd2T0jfoT2yVukWTWdMEcHCe7gMPos5Tkq
         TquH2Fb++aZFVMMNUOjs1lmX+aDfCTdfE4vYyEuSCnmLf4UGEQHaO/zw6aLuaV3JEha8
         ZjyZ4H0upDKfQYsxA6oZg4EmiidfL8ajljihQavYDivdvkzHkNyDA9+aW5jPtLiKKC9t
         t+mvXy/x2NOg16qY5qSvdToEY+Zck0eTCliXHmboHPhr0GC6yTVAKy+0CFM7sV4IIWET
         74dK+5xmpuVz+WsTxmH2TUPPQna2D20+HFRBv/S/Ka8gye8sVaOVwda1AB94h7GDX8qV
         Cuzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5eazXpvUYRuHpEXSXh/7pV6yjwLyPDdyTbYcpugheYI=;
        b=P186sc5TqKvod4o4WJXeUE43U0BwL5v3e8opq0kEgFMbO0s44AQTkM3raNUqvwHCsm
         prCEKZTJ2Og7/ltnqpSxml12UPDsvOjWjuzY62w55UiLOD8ZWofYw1JpEZqr1iBOV1OE
         IbYBkJ7MoguEV408CKqRhEVwULjfLszCvp013QF7HSW/9hzjVz8/4lPxyQjvTiI5BY/J
         w0sTkSV+jFAX7oeJnJ/oQn7aw+5VYqhZsnIbVQXcol2MNgPIzpF+C1Vlq3h14eZIkbEe
         l4xrzVNP7eWP8IAyW8TGL6LDmvDV3WOqckvGh/eTas2zSQ+XGDnprbVS0hZnn2tJePfU
         hGEg==
X-Gm-Message-State: AOAM531h/oqiAVMvwFJt+CXCOfm/s3390qFQRDAHj0M0f5Rd/oZFwaKO
        7gL+KfE7hT9BuON3SZAkjiGWE1jCWWX8Of/pBvr6z9aIxteklQ==
X-Google-Smtp-Source: ABdhPJx5I40kNqQQZLQmA+RrWRpoNnvtdjlTCUinwy3T0ErqgVMz2tEk725HDKMxLnBLEz0f9lNePFLd61SqZN2vAE4=
X-Received: by 2002:a5b:7c6:0:b0:60b:a0ce:19b with SMTP id t6-20020a5b07c6000000b0060ba0ce019bmr4733011ybq.407.1648132733671;
 Thu, 24 Mar 2022 07:38:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220323004147.1990845-1-eric.dumazet@gmail.com> <20220324062243.GA2496@kili>
In-Reply-To: <20220324062243.GA2496@kili>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 24 Mar 2022 07:38:42 -0700
Message-ID: <CANn89iKJamk6v5gt67tE0tG0i3XS2LofJu34uT=_AVqYCs-0SQ@mail.gmail.com>
Subject: Re: [PATCH net-next] llc: fix netdevice reference leaks in llc_ui_bind()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?6LW15a2Q6L2p?= <beraphin@gmail.com>,
        Stoyan Manolov <smanolov@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, Mar 23, 2022 at 11:23 PM Dan Carpenter <dan.carpenter@oracle.com> w=
rote:
>
> On Tue, Mar 22, 2022 at 05:41:47PM -0700, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Whenever llc_ui_bind() and/or llc_ui_autobind()
> > took a reference on a netdevice but subsequently fail,
> > they must properly release their reference
> > or risk the infamous message from unregister_netdevice()
> > at device dismantle.
> >
> > unregister_netdevice: waiting for eth0 to become free. Usage count =3D =
3
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: =E8=B5=B5=E5=AD=90=E8=BD=A9 <beraphin@gmail.com>
> > Reported-by: Stoyan Manolov <smanolov@suse.de>
> > ---
> >
> > This can be applied on net tree, depending on how network maintainers
> > plan to push the fix to Linus, this is obviously a stable candidate.
>
> This patch is fine, but it's that function is kind of ugly and difficult
> for static analysis to parse.

We usually do not mix bug fixes and code refactoring.

Please feel free to send a refactor when net-next reopens in two weeks.

Thanks.

>
> net/llc/af_llc.c
>    274  static int llc_ui_autobind(struct socket *sock, struct sockaddr_l=
lc *addr)
>    275  {
>    276          struct sock *sk =3D sock->sk;
>    277          struct llc_sock *llc =3D llc_sk(sk);
>    278          struct llc_sap *sap;
>    279          int rc =3D -EINVAL;
>    280
>    281          if (!sock_flag(sk, SOCK_ZAPPED))
>    282                  goto out;
>
> This condition is checking to see if someone else already initialized
> llc->dev.  If we call dev_put_track(llc->dev, &llc->dev_tracker) on
> something we didn't allocate then it leads to a use after free.  But
> fortunately the callers all check SOCK_ZAPPED so the condition is
> impossible.
>
>    283          if (!addr->sllc_arphrd)
>    284                  addr->sllc_arphrd =3D ARPHRD_ETHER;
>    285          if (addr->sllc_arphrd !=3D ARPHRD_ETHER)
>    286                  goto out;
>
> Thus we know that "llc->dev" is NULL on these first couple gotos and
> calling dev_put_track(llc->dev, &llc->dev_tracker); is a no-op so it's
> fine.
>
> But complicated to review.
>
>    287          rc =3D -ENODEV;
>    288          if (sk->sk_bound_dev_if) {
>    289                  llc->dev =3D dev_get_by_index(&init_net, sk->sk_b=
ound_dev_if);
>    290                  if (llc->dev && addr->sllc_arphrd !=3D llc->dev->=
type) {
>    291                          dev_put(llc->dev);
>    292                          llc->dev =3D NULL;
>    293                  }
>    294          } else
>    295                  llc->dev =3D dev_getfirstbyhwtype(&init_net, addr=
->sllc_arphrd);
>    296          if (!llc->dev)
>    297                  goto out;
>    298          netdev_tracker_alloc(llc->dev, &llc->dev_tracker, GFP_KER=
NEL);
>    299          rc =3D -EUSERS;
>    300          llc->laddr.lsap =3D llc_ui_autoport();
>    301          if (!llc->laddr.lsap)
>    302                  goto out;
>    303          rc =3D -EBUSY; /* some other network layer is using the s=
ap */
>    304          sap =3D llc_sap_open(llc->laddr.lsap, NULL);
>    305          if (!sap)
>    306                  goto out;
>    307          memcpy(llc->laddr.mac, llc->dev->dev_addr, IFHWADDRLEN);
>    308          memcpy(&llc->addr, addr, sizeof(llc->addr));
>    309          /* assign new connection to its SAP */
>    310          llc_sap_add_socket(sap, sk);
>    311          sock_reset_flag(sk, SOCK_ZAPPED);
>    312          rc =3D 0;
>    313  out:
>    314          if (rc) {
>    315                  dev_put_track(llc->dev, &llc->dev_tracker);
>    316                  llc->dev =3D NULL;
>    317          }
>    318          return rc;
>    319  }
>
> regards,
> dan carpenter
