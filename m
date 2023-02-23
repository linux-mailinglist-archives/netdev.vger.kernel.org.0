Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8360F6A03CC
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 09:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjBWI2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 03:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbjBWI2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 03:28:13 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C9D193C4
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 00:28:12 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id l7-20020a05600c4f0700b003e79fa98ce1so5481441wmq.2
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 00:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5JP0Qc8ruGYWVaQbW0uy7zOGKeXg+ZWCRPXehIt5VSU=;
        b=D32xqW7fUSWMmNdezA856aIOGyecjgoslkTi40dOGr5Uu+5v+ZiNIYCQU++DLoDbNM
         apGNVdSKG4I3QUfHWfE2i2B53oHB1dvr9u8HMAyg9t1YKvpJOxXWFtrvrVNlHqWdCfvS
         o8mBKzeYByqvhpKNciA+1i1C8XHm2b9e6+msldLfzKmovqlDxik3IY55KpET72ke5nCu
         o/MuMWYSRscvWNsrKMmmceHNZlDfNxhu7RyS2fm3s606rWTXCU76YCLWCUif+oP/rJoL
         ID/TC6BXPh4wrRt6IJ5NsTRHw4OscablpXMV2/FHK+k4cSSJ5TR5WZOSZ4BeC79KK5c0
         Ozng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5JP0Qc8ruGYWVaQbW0uy7zOGKeXg+ZWCRPXehIt5VSU=;
        b=vdij+ecec7NtH6ErdivCf7+zcwDHbw3egN5uhKpu8zyP6xEYKn5UVgfCEukLazERE6
         9pO6pADYrogjzFwCTar/1h4ZEDS2UuTjnKIJlzqxJoxKAjvRFkQLhaKN3wsgE8cx7PT6
         Ncp9qDa1mufxbHJY6Kf4/S5hWwey7f0mkmE5reqnvL9fBKfj6i3MuYGiYSP1KInCs+9F
         cnBuCKAoO0wHxJgkmBiPj7owYOE8pay0aaFnY3Rdl/Yr6CPXxiMuIxW7JF8LoicwSdgW
         iLdVXOm4CIRdLjYtl5AQcosEarrzJQMI9xMlwpuf2M6wdFrkrigIF/c1hyf+xyta+ckj
         nygA==
X-Gm-Message-State: AO0yUKXWLAQSAJFZa8qEqkj0TXO0xtqs6q3iaZCw4ti/80NIB7E8ppvm
        pS/6iT5ZsUe/5tkMNpps7NkD17cwJk/i9hsJORdoIeLsCXYGItJXpgQ=
X-Google-Smtp-Source: AK7set8J9VxGBjC6qIikGZjxXrxqG8t3xoImvs9H2fUQH+TB2MCfdFx7VIEwbT78m2UWsJXUjnyMXLOxq7/sOGp4HpE=
X-Received: by 2002:a05:600c:3d16:b0:3df:f862:fe42 with SMTP id
 bh22-20020a05600c3d1600b003dff862fe42mr317703wmb.10.1677140890449; Thu, 23
 Feb 2023 00:28:10 -0800 (PST)
MIME-Version: 1.0
References: <20230223000713.1407316-1-edumazet@google.com> <d57c8374-3803-2038-c83c-627ee5d4523f@huawei.com>
In-Reply-To: <d57c8374-3803-2038-c83c-627ee5d4523f@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 23 Feb 2023 09:27:58 +0100
Message-ID: <CANn89iLhD=tMjYRscr51uSGWtt_0Fggh48G8niDxYA8jHNay_g@mail.gmail.com>
Subject: Re: [PATCH net] net: fix __dev_kfree_skb_any() vs drop monitor
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
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

On Thu, Feb 23, 2023 at 1:48=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.co=
m> wrote:
>
> On 2023/2/23 8:07, Eric Dumazet wrote:
> > dev_kfree_skb() is aliased to consume_skb().
> >
> > When a driver is dropping a packet by calling dev_kfree_skb_any()
> > we should propagate the drop reason instead of pretending
> > the packet was consumed.
> >
> > Note: Now we have enum skb_drop_reason we could remove
> > enum skb_free_reason (for linux-6.4)
> >
> > Fixes: e6247027e517 ("net: introduce dev_consume_skb_any()")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  net/core/dev.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 18dc8d75ead9795163ace74e8e86fe35cb9b7552..2bf60afde1e2e4be4806070=
754ae7486705c5237 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -3134,8 +3134,10 @@ void __dev_kfree_skb_any(struct sk_buff *skb, en=
um skb_free_reason reason)
> >  {
> >       if (in_hardirq() || irqs_disabled())
> >               __dev_kfree_skb_irq(skb, reason);
> > +     else if (reason =3D=3D SKB_REASON_DROPPED)
>
> Perhaps add the unlikely() for the SKB_REASON_DROPPED case
> as it is uesed in data path.

Sure I can do this, I will send a v2.

Note that I plan to switch the whole thing when net-next opens with
something like this
(showing not complete patch of course)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2bf60afde1e2e4be4806070754ae7486705c5237..67baed2c8c5ef6577a2256c02c3=
00947b8a919b7
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3130,16 +3130,14 @@ void __dev_kfree_skb_irq(struct sk_buff *skb,
enum skb_free_reason reason)
 }
 EXPORT_SYMBOL(__dev_kfree_skb_irq);

-void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason)
+void dev_kfree_skb_any_reason(struct sk_buff *skb, enum skb_drop_reason re=
ason)
 {
        if (in_hardirq() || irqs_disabled())
                __dev_kfree_skb_irq(skb, reason);
-       else if (reason =3D=3D SKB_REASON_DROPPED)
-               kfree_skb(skb);
        else
-               consume_skb(skb);
+               kfree_skb_reason(skb, reason);
 }
-EXPORT_SYMBOL(__dev_kfree_skb_any);
+EXPORT_SYMBOL(dev_kfree_skb_any_reason);


 /**
