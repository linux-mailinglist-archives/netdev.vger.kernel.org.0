Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6B362D5E1
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239687AbiKQJIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239229AbiKQJID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:08:03 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784AC5A6F2
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:08:02 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-36cbcda2157so12599787b3.11
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tZI3ET1B5OK0xvivSm+mxuGd/VhYNjLWMrya0GxKvTo=;
        b=oEINoLjoZS9MK3KdraU0j+P5JfTkYQPNUzKa2MSDzON7+wcM7bxZ/U65/60VlZctBA
         Ruy+jHf9iWcZ6qklIQsTFhV9ctgzUepm8HvOVVuyHjsmjWP01VjWTo24n5cOpvPbvHps
         arNp8TmLeOARAO+ppakR5uhMEx8iqcavhwDKELazfqq6+0vMl3qB4mfr46Ddkd5Dkb0H
         BxVyumyP9mODrOXvoc4GGoXpnxjqfev7ko/0BAleXLeHQtW9iJ1ZFB2ni9pDRe5d+A8i
         rwewJ7ABKrDTgZuFqR4gHi0CTNTGJ02htoovHJriZnzhEikmF98QgF5GAtojyvx2tWVI
         8vsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tZI3ET1B5OK0xvivSm+mxuGd/VhYNjLWMrya0GxKvTo=;
        b=YGCS7yaqJH/pWoP4qcYWPYqNBuP3DKnQCXIEnjnegR5U38yEJrL591lUrygu8WKTWq
         3ml12O6Jm3ORnAIdJi7iD0BxxYUvmXbX+CXuyb3OAenM2eQr4RYkNGCWW/ktm+V1Dfx9
         NWsZZpvXjf7RQ7QTSDF/de9vwkI/6rG+/xzvAia1pPk7f5Lyxop4FvYgibCFSkwPdoMP
         yk4ifEBRzKEN0+lkXPJCBGBO0hOirQsS1cjvACiNO05Idyi7chpYJ0oGqPOhHiTi5BJT
         v60+u9pm3lmVcwgEG37+D2hvqQlU+w6Rv309fbtMIErpuakwgaqGRtGneIPw15x18YBQ
         5X2w==
X-Gm-Message-State: ANoB5pkAEN8iMPsxpeUVWvtbggefxEtKpUY/C7eQNLsAP4PiKAhemocH
        O5utiuGGQ6qq3SMLynGjOXI31yKDB30FJv4EX//GGQ==
X-Google-Smtp-Source: AA0mqf6V3LO/6sB6V30kXhayiduGeQIiv1V2Et3PfHoLDv4NcbAquB9JGlhu/a3x6Va64eKZgBcfzqNqcWCmRt9Pauk=
X-Received: by 2002:a05:690c:b81:b0:37e:6806:a5f9 with SMTP id
 ck1-20020a05690c0b8100b0037e6806a5f9mr1206123ywb.47.1668676081539; Thu, 17
 Nov 2022 01:08:01 -0800 (PST)
MIME-Version: 1.0
References: <20221114191619.124659-1-jakub@cloudflare.com> <166860541774.25745.4396978792984957790.git-patchwork-notify@kernel.org>
In-Reply-To: <166860541774.25745.4396978792984957790.git-patchwork-notify@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Nov 2022 01:07:50 -0800
Message-ID: <CANn89iLQUZnyGNCn2GpW31FXpE_Lt7a5Urr21RqzfAE4sYxs+w@mail.gmail.com>
Subject: Re: [PATCH net v4] l2tp: Serialize access to sk_user_data with sk_callback_lock
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        tparkin@katalix.com, g1042620637@gmail.com
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Nov 16, 2022 at 5:30 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
>
> Hello:
>
> This patch was applied to netdev/net.git (master)
> by David S. Miller <davem@davemloft.net>:
>
> On Mon, 14 Nov 2022 20:16:19 +0100 you wrote:
> > sk->sk_user_data has multiple users, which are not compatible with each
> > other. Writers must synchronize by grabbing the sk->sk_callback_lock.
> >
> > l2tp currently fails to grab the lock when modifying the underlying tunnel
> > socket fields. Fix it by adding appropriate locking.
> >
> > We err on the side of safety and grab the sk_callback_lock also inside the
> > sk_destruct callback overridden by l2tp, even though there should be no
> > refs allowing access to the sock at the time when sk_destruct gets called.
> >
> > [...]
>
> Here is the summary with links:
>   - [net,v4] l2tp: Serialize access to sk_user_data with sk_callback_lock
>     https://git.kernel.org/netdev/net/c/b68777d54fac
>
>

I guess this patch has not been tested with LOCKDEP, right ?

sk_callback_lock always needs _bh safety.

I will send something like:

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 754fdda8a5f52e4e8e2c0f47331c3b22765033d0..a3b06a3cf68248f5ec7ae8be2a9711d0f482ac36
100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1474,7 +1474,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel
*tunnel, struct net *net,
        }

        sk = sock->sk;
-       write_lock(&sk->sk_callback_lock);
+       write_lock_bh(&sk->sk_callback_lock);

        ret = l2tp_validate_socket(sk, net, tunnel->encap);
        if (ret < 0)
@@ -1522,7 +1522,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel
*tunnel, struct net *net,
        if (tunnel->fd >= 0)
                sockfd_put(sock);

-       write_unlock(&sk->sk_callback_lock);
+       write_unlock_bh(&sk->sk_callback_lock);
        return 0;

 err_sock:
@@ -1531,7 +1531,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel
*tunnel, struct net *net,
        else
                sockfd_put(sock);

-       write_unlock(&sk->sk_callback_lock);
+       write_unlock_bh(&sk->sk_callback_lock);
 err:
        return ret;
 }
