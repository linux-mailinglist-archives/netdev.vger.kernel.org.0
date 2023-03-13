Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788E96B8612
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjCMX04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbjCMX0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:26:54 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9D666D35
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 16:26:50 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id e194so13721241ybf.1
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 16:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678750009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=67tD5tvMaOk5W/jeNzca29PpDn68PRP+YOGw5fjDWNA=;
        b=mcCzrYee2Wi4dij7/hFvhunpfG/REbGtyDMaNRHaCrQIYY9MMWBvzVPVAZDhvXy8w3
         1ZuBlF56lkl4ca7NBZOvJeO1HFWiNKhRzTlY4Et/E3iwH784aND81NZpEobWlvm/0L/a
         mftj5OCTgMSL7gkARlEaoZc5Nzup59Tt6E8HsTjOupeMpNM8Id8fy/wqEjREVCVAB1wU
         a/Zkxy6D4lhljTxA++n4GnS8DNX2U+4eG9mwrvKuCqxwswCrL+umGRJvK6lWrdIZNOn6
         jiKJXqBIEoo/2nowhmPug0zexLif23qG8bJ5GSGJ60CAiMH2Z4PEmp9BgiYyh4tMhYxf
         PDfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678750009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=67tD5tvMaOk5W/jeNzca29PpDn68PRP+YOGw5fjDWNA=;
        b=15205rHhN9jTuPSVOJai/o4/7vHQF01c6yYN9pCBpvepQBWGPuFlQmat6EjpWZBqQG
         LsaZqje6C58d1+jT9gIN5M0BaZmBATTG6N3aCJccFdQIIb5ZIwNscWL8B/mKByfwr8LG
         1m0fOf9RppgprJ9izJfu80Rb9UlBem02i961+NQv4IME8ijcrNEdItrQmEQDC4/Ya/0j
         +h9u/e6Nqz3co8mUcwCjLd1FRYrE5/GBhSSvV31K7sYZe/FQ/sy/oZoMU93+gvAMrtnC
         +LyKMZ7upbrruQmENUdrHsUjvS2tSwuIO9ViDMSQaD55hwV6gui6Q6lI0XZXF9U7lVgB
         Xsxg==
X-Gm-Message-State: AO0yUKUxkX9nnQyB2FqSKxeF3rp+bnxZZc3xFlUhlYkcokjFQkJUp6oi
        3bH7j6unLmqzq+oF4rdWuR4mmY0LtnzrWAYWI4rd8o1OU100sFmP5R314xyQ
X-Google-Smtp-Source: AK7set/zeIrUxJlytGnJaqFpSu7jcq4EFTGszIUewwIo9jbcJzKYEvV6W+67NWFnJYpg96dHsQtx3XpNLBda+b0izGk=
X-Received: by 2002:a25:928f:0:b0:b3e:c715:c313 with SMTP id
 y15-20020a25928f000000b00b3ec715c313mr2048746ybl.6.1678750009344; Mon, 13 Mar
 2023 16:26:49 -0700 (PDT)
MIME-Version: 1.0
References: <dfd6a9a7d85e9113063165e1f47b466b90ad7b8a.1678748579.git.lorenzo@kernel.org>
In-Reply-To: <dfd6a9a7d85e9113063165e1f47b466b90ad7b8a.1678748579.git.lorenzo@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 13 Mar 2023 16:26:37 -0700
Message-ID: <CANn89iKuj-R8Y9GREQ46UROMpRPeHALQr8+TiG959uTj9FxfKw@mail.gmail.com>
Subject: Re: [PATCH net] veth: rely on rtnl_dereference() instead of on
 rcu_dereference() in veth_set_xdp_features()
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        matthieu.baerts@tessares.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 4:08=E2=80=AFPM Lorenzo Bianconi <lorenzo@kernel.or=
g> wrote:
>
> Fix the following kernel warning in veth_set_xdp_features routine
> relying on rtnl_dereference() instead of on rcu_dereference():
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> 6.3.0-rc1-00144-g064d70527aaa #149 Not tainted
> -----------------------------
> drivers/net/veth.c:1265 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 1 lock held by ip/135:
> (net/core/rtnetlink.c:6172)
>

> Fixes: fccca038f300 ("veth: take into account device reconfiguration for =
xdp_features flag")
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Link: https://lore.kernel.org/netdev/cover.1678364612.git.lorenzo@kernel.=
org/T/#me4c9d8e985ec7ebee981cfdb5bc5ec651ef4035d
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Reported-by: syzbot+c3d0d9c42d59ff644ea6@syzkaller.appspotmail.com
Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.


>  drivers/net/veth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 293dc3b2c84a..4da74ac27f9a 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -1262,7 +1262,7 @@ static void veth_set_xdp_features(struct net_device=
 *dev)
>         struct veth_priv *priv =3D netdev_priv(dev);
>         struct net_device *peer;
>
> -       peer =3D rcu_dereference(priv->peer);
> +       peer =3D rtnl_dereference(priv->peer);
>         if (peer && peer->real_num_tx_queues <=3D dev->real_num_rx_queues=
) {
>                 xdp_features_t val =3D NETDEV_XDP_ACT_BASIC |
>                                      NETDEV_XDP_ACT_REDIRECT |
> --
> 2.39.2
>
