Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B643C3E9FE8
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 09:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbhHLHyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 03:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234931AbhHLHyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 03:54:10 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE94C061765
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 00:53:46 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id n15so9206118ybm.4
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 00:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9JZqOqVznYUDrbL2EoRp512OKS9G4P0uRZ0um+CeOM0=;
        b=XUc2jVtrB7HGyJ4RgVlBE/m0imZM91y9dpLQRoQ969ppV9XZj3r+vDvE1aQ5LirbJj
         hns/P4oiRBHGbOwLuOqcpo/5+GrpOE5yaH5lMZ8g32XXBAypiIRLx1o7XyDf4XF/pXWf
         OwWCdOtwoVCd0qkZQzfVuLnW2byfPh1TQdRXG+nAcffF7RuNEErxOfRVouewdnEdKtGP
         2CFdEj90UEqsqXNg5O12Gu2MlExzJhlvnq6Cf7AQicp/fE3ELEYRQhhHC3HGo4P/hpb4
         EECyfRRryVxByRHfUD7q52NmA2EC26ShONT1vp9GUk4mJhFE5eddXxkbXBWK6nYK4XdY
         UW9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9JZqOqVznYUDrbL2EoRp512OKS9G4P0uRZ0um+CeOM0=;
        b=VNJupD+Gk8LysV4t8XszMNdawRRon+X5k0LdpQbZvNYIUEbANrIRgteU8NDARgzH4a
         EPmPiIGgj6p6d90y/Y58XIFkLsokZkXg8VbIwxv3f3d/BPsydgwfk1qpIagNPJ1FWOh8
         cdrCzBzNpqn9p0WXK/2PI/cpNpCUeaUsY+5Vaa6mNPbmEWfmInA7fFW1TG0BIVrs5zb6
         OqQKvKJyFrMb0DURiX7FwxuI5T7IUKMZnW8tRuNmkUn85H73zo8y5zJTqexW8KtjO/B1
         imz6fo7xHxZrvlDS/lnwoDolaoT/7/8vs6zyXt7LQHqYdZuKefkX3+YMoGdRdRvYGcYq
         tfUA==
X-Gm-Message-State: AOAM531w6z5yXwD0QGNbjq60kC58mdVPkWwgVFKmxu6adyAp84LL4Kwr
        TRSen7yYpBxTjyftq/2Fwrrh0SQ2tfSUu0zooM5v+Q==
X-Google-Smtp-Source: ABdhPJxs/kuJ+XiRSam8U7yZfgUJ6Ac7G4si/rbymZzwb2k0B3GVlLuAS5eEQlm5OtFI6PPiX4j1TCxK4PvJ47ZaO98=
X-Received: by 2002:a25:cc44:: with SMTP id l65mr2914245ybf.303.1628754824872;
 Thu, 12 Aug 2021 00:53:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210811220652.567434-1-Rao.Shoaib@oracle.com>
In-Reply-To: <20210811220652.567434-1-Rao.Shoaib@oracle.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 12 Aug 2021 09:53:33 +0200
Message-ID: <CANn89i+utnHk-aoS=q2sLC8uLaMJDYsW=1O+c4fzODQd0P3stA@mail.gmail.com>
Subject: Re: [PATCH] af_unix: fix holding spinlock in oob handling
To:     Rao Shoaib <Rao.Shoaib@oracle.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 12:07 AM Rao Shoaib <Rao.Shoaib@oracle.com> wrote:
>
> From: Rao Shoaib <rao.shoaib@oracle.com>
>
> syzkaller found that OOB code was holding spinlock
> while calling a function in which it could sleep.
>
> Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com
>
> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
>
> Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
> ---

Please do not add these empty lines.

Fixes: ...
Reported-by: ...
Signed-off-by: ...

Also you might take a look at queue_oob()

1)  Setting skb->len tp 1 should not be needed, skb_put() already does that
2) After unix_state_lock(other); we probably need to check status of
the other socket.
3) Some skb_free() calls should have been consume_skb()

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index ec02e70a549b42f6c102253508c48426a13f7bc4..0c27e2976f9d234ca3bb131731375bc51a056846
100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1908,7 +1908,6 @@ static int queue_oob(struct socket *sock, struct
msghdr *msg, struct sock *other
                return err;

        skb_put(skb, 1);
-       skb->len = 1;
        err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, 1);

        if (err) {
@@ -1917,11 +1916,17 @@ static int queue_oob(struct socket *sock,
struct msghdr *msg, struct sock *other
        }

        unix_state_lock(other);
+       if (sock_flag(other, SOCK_DEAD) ||
+           (other->sk_shutdown & RCV_SHUTDOWN)) {
+               unix_state_unlock(other);
+               kfree_skb(skb);
+               return -EPIPE;
+       }
        maybe_add_creds(skb, sock, other);
        skb_get(skb);

        if (ousk->oob_skb)
-               kfree_skb(ousk->oob_skb);
+               consume_skb(ousk->oob_skb);

        ousk->oob_skb = skb;
