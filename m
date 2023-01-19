Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBAD674080
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjASSFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjASSFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:05:11 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C14B740
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 10:05:09 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-4d13cb4bbffso38835857b3.3
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 10:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FkhcYN+cYujTamYbctHJzJNaxSoTgqt3dXRr9PdBMIM=;
        b=LgrlxD1RClP791LVKLLn3NdqR9h+IUIMzZYaQpJtbQwpwneuyrIZf4u1WH3F9jddD1
         myBgY0Ft50PY6DPT92k4opWOi6/mxeOPxTdvBeKl5fqBrecNoJDQfpZrmQIa5s9T78eZ
         cq7LUwCNoPmU7+NcQO4XoGPN5mt0pDo4J/59Bgib9PZuiEgwctOt1vhTPT0jDqDNF796
         JoZttXPXFKop6a7NUesrl9BTcnmTySLyNW9V60QT/itePBixTnxQeuC6bjnf+XQCM402
         3yRkPg1wHS8UE4KZVSQW9iW8VZTTtwECu1UqmTMQClukPuuO7uKJUUTXX7EVhtGa9cP4
         RHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FkhcYN+cYujTamYbctHJzJNaxSoTgqt3dXRr9PdBMIM=;
        b=kFLsxg43KzoaDcFXHb4pvknhSNSbmfv7sZ6m/zXSVFfTZYBuPNGdrtsdFJzLcSqLcM
         WET10DDpyMoXuDKsvrDWSA8YLhNwd+2zsEaS4X6tG2wGmaeFmxqWj3A738p4XhYzsAFq
         oBtcxIA/hPcHwW5Ezwsl9szv8b3H1q2GOV1RYwX/MOakvf0bgrFVwZs/zvJSJK7ac0Pz
         0JgyBDyQTH2m7gciDmGOxLv0T/FwIM+JX3HtG7C+jOKRjpLei3ox8EcTk2h+wQPha06W
         6P2j1MLt2GDx61E9cYVoyZ7lEcm2FWNtQ71GJxcyOfO2aBon/LaUqOxNWoFY6yGRMPNo
         FxWA==
X-Gm-Message-State: AFqh2kppzKqEBNO60/+WbT05788Oz/KcgjIleWgjI7rN1gSGZvlHokBL
        v8odfJOBlS1ueb/vOmQRdHu/l+khn3Pe7/Us3tmXeg==
X-Google-Smtp-Source: AMrXdXt+fMGF7e+mL8GQPv0YAxxMqO6piOyQL+8wVfySWlaIXXQN+MMoFgke8fJhAhy6mI9CU2BltHBcrwcTpDm0UXY=
X-Received: by 2002:a81:6e42:0:b0:3f2:e8b7:a6ec with SMTP id
 j63-20020a816e42000000b003f2e8b7a6ecmr1450082ywc.332.1674151508516; Thu, 19
 Jan 2023 10:05:08 -0800 (PST)
MIME-Version: 1.0
References: <167415060025.1124471.10712199130760214632.stgit@firesoul>
In-Reply-To: <167415060025.1124471.10712199130760214632.stgit@firesoul>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 19 Jan 2023 19:04:57 +0100
Message-ID: <CANn89iJ8Vd2V6jqVdMYLFcs0g_mu+bTJr3mKq__uXBFg1K0yhA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: fix kfree_skb_list use of skb_mark_not_on_list
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, pabeni@redhat.com,
        syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
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

On Thu, Jan 19, 2023 at 6:50 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> A bug was introduced by commit eedade12f4cb ("net: kfree_skb_list use
> kmem_cache_free_bulk"). It unconditionally unlinked the SKB list via
> invoking skb_mark_not_on_list().
>
> The skb_mark_not_on_list() should only be called if __kfree_skb_reason()
> returns true, meaning the SKB is ready to be free'ed, as it calls/check
> skb_unref().
>
> This is needed as kfree_skb_list() is also invoked on skb_shared_info
> frag_list. A frag_list can have SKBs with elevated refcnt due to cloning
> via skb_clone_fraglist(), which takes a reference on all SKBs in the
> list. This implies the invariant that all SKBs in the list must have the
> same refcnt, when using kfree_skb_list().

Yeah, or more precisely skb_drop_fraglist() calling kfree_skb_list()

>
> Reported-by: syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
> Fixes: eedade12f4cb ("net: kfree_skb_list use kmem_cache_free_bulk")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  net/core/skbuff.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 4e73ab3482b8..1bffbcbe6087 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -999,10 +999,10 @@ kfree_skb_list_reason(struct sk_buff *segs, enum skb_drop_reason reason)
>         while (segs) {
>                 struct sk_buff *next = segs->next;
>
> -               skb_mark_not_on_list(segs);
> -
> -               if (__kfree_skb_reason(segs, reason))
> +               if (__kfree_skb_reason(segs, reason)) {
> +                       skb_mark_not_on_list(segs);

Real question is : Why do we need to set/change/dirt skb->next ?

I would remove this completely, and save extra cache lines dirtying.

Before your patch, we were not calling skb_mark_not_on_list(segs),
so why bother ?

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4e73ab3482b87d81371cff266627dab646d3e84c..180df58e85c72eaa16f5cb56b56d181a379b8921
100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -999,8 +999,6 @@ kfree_skb_list_reason(struct sk_buff *segs, enum
skb_drop_reason reason)
        while (segs) {
                struct sk_buff *next = segs->next;

-               skb_mark_not_on_list(segs);
-
                if (__kfree_skb_reason(segs, reason))
                        kfree_skb_add_bulk(segs, &sa, reason);
