Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC79867F55F
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 08:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbjA1HI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 02:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbjA1HI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 02:08:57 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525C58305C
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 23:08:56 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-5063029246dso95513367b3.6
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 23:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wvQgEzOS0zsXxzL1+rW7hK3SK4Cvwj9Xqt58axyFIk0=;
        b=Scx4ZAXMjYGGlMP3a3EREoYq6yOTji2f+UbSlfjCgEUL9asm3lZFMd6fGSNeC2IGmU
         jqulgqOLnH+qpUYEKHZ5fcUFjtgINHPse1I9WY2cOLv0kW1JYfrEs86Gp/xWz2oRTI4X
         FhNVFc77RUMd4f7KFSGYTKp/7SlxDOPWmTfSPcI7xc5CGsGsu3EIDsKP4cUMTVZjNskw
         DksCzG2eXzUhv8KcN6+aHdl5aRNi8ZKb44T41WcybSaCeft7/23ynh1EYHNFsbFkUQPI
         NT7G3SBxbjYYJKcKcCeaAzoBGMx8Pjq/qgewkGLRseqZd9UZQhyH1dODt9SEOkZOwOZx
         xPrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wvQgEzOS0zsXxzL1+rW7hK3SK4Cvwj9Xqt58axyFIk0=;
        b=Idmz1ohTOFkKjrRBO2BsdqH/ISUKYb8Sl+uwjFimtiKr5KnoBS7nOl2azIWP6OC3FA
         TIJsPVx6XjyWcC3lA13pfN+EpJwNi/yXPjcuMAfx5N6o9tzYfESYr1Fx8Dy/j2x8vQUO
         Y56GDJtQMy2BTds/2p+XdaoPC75ofm1JOOE0nNzWptvo/i77/tnpwOStIMTNI0R/Oj/f
         TRLGviqEK+PCnhrXK4pV/zrChdapfyhLMtwHZPRGmeWoFz4/xDUTU/RLzN2c36AAzwm/
         TjmmO8DohZGlLrFw+nY2pR0n6v+w8vKbUtjL4Pf3KUwbxpGy0BClw8EL7+BlOkiF1UFA
         VUvQ==
X-Gm-Message-State: AO0yUKW/SAQ3A17lPQWSJcVO3EgBF9R7HSJaOQ9B5czHpq6qzK8rylJu
        ROQcIPKThYIMwA3i0IOyM3gDZ+6BqYmmXU0ISESRPQ==
X-Google-Smtp-Source: AK7set9Y/tg7ZNIwLzYRWWvLExUU4fm3MZw+TRn/glva2Kgy6rEdDUEnewprInl/hGT0RyWAoA1G2S+OD0h4d2a7EM8=
X-Received: by 2002:a81:ca0e:0:b0:508:8579:73fd with SMTP id
 p14-20020a81ca0e000000b00508857973fdmr1157732ywi.332.1674889735302; Fri, 27
 Jan 2023 23:08:55 -0800 (PST)
MIME-Version: 1.0
References: <04e27096-9ace-07eb-aa51-1663714a586d@nbd.name>
 <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain>
 <cde24ed8-1852-ce93-69f3-ff378731f52c@huawei.com> <20230127212646.4cfeb475@kernel.org>
In-Reply-To: <20230127212646.4cfeb475@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 28 Jan 2023 08:08:43 +0100
Message-ID: <CANn89iKgZU4Q+THXupzZi4hETuKuCOvOB=iHpp5JzQTNv_Fg_A@mail.gmail.com>
Subject: Re: [net PATCH] skb: Do mix page pool and page referenced frags in GRO
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Alexander Duyck <alexander.duyck@gmail.com>, nbd@nbd.name,
        davem@davemloft.net, hawk@kernel.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, lorenzo@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
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

On Sat, Jan 28, 2023 at 6:26 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 28 Jan 2023 10:37:47 +0800 Yunsheng Lin wrote:
> > If we are not allowing gro for the above case, setting NAPI_GRO_CB(p)->flush
> > to 1 in gro_list_prepare() seems to be making more sense so that the above
> > case has the same handling as skb_has_frag_list() handling?
> > https://elixir.bootlin.com/linux/v6.2-rc4/source/net/core/gro.c#L503
> >
> > As it seems to avoid some unnecessary operation according to comment
> > in tcp4_gro_receive():
> > https://elixir.bootlin.com/linux/v6.2-rc4/source/net/ipv4/tcp_offload.c#L322
>
> The frag_list case can be determined with just the input skb.
> For pp_recycle we need to compare input skb's pp_recycle with
> the pp_recycle of the skb already held by GRO.
>
> I'll hold off with applying a bit longer tho, in case Eric
> wants to chime in with an ack or opinion.

We can say that we are adding in the fast path an expensive check
about an unlikely condition.

GRO is by far the most expensive component in our stack.

I would at least make the extra checks conditional to CONFIG_PAGE_POOL=y
Ideally all accesses to skb->pp_recycle should be done via a helper [1]

I hope that we will switch later to a per-page marker, instead of a per-skb one.

( a la https://www.spinics.net/lists/netdev/msg874099.html )

[1] Problem is that CONFIG_PAGE_POOL=y is now forced because of
net/bpf/test_run.c

So... testing skb->pp_recycle seems needed for the time being

Reviewed-by: Eric Dumazet <edumazet@google.com>

My tentative patch was something like:

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4c8492401a101f1d6d43079fc70962210389763c..a53b176738b10f3b69b38c487e0c280f44990b6f
100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -918,8 +918,10 @@ struct sk_buff {
                                fclone:2,
                                peeked:1,
                                head_frag:1,
-                               pfmemalloc:1,
-                               pp_recycle:1; /* page_pool recycle indicator */
+#ifdef CONFIG_PAGE_POOL
+                               pp_recycle:1, /* page_pool recycle indicator */
+#endif
+                               pfmemalloc:1;
 #ifdef CONFIG_SKB_EXTENSIONS
        __u8                    active_extensions;
 #endif
@@ -3388,6 +3390,15 @@ static inline void __skb_frag_unref(skb_frag_t
*frag, bool recycle)
        put_page(page);
 }

+static inline bool skb_pp_recycle(const struct sk_buff *skb)
+{
+#ifdef CONFIG_PAGE_POOL
+       return skb->pp_recycle;
+#else
+       return false;
+#endif
+}
+
 /**
  * skb_frag_unref - release a reference on a paged fragment of an skb.
  * @skb: the buffer
@@ -3400,7 +3411,7 @@ static inline void skb_frag_unref(struct sk_buff
*skb, int f)
        struct skb_shared_info *shinfo = skb_shinfo(skb);

        if (!skb_zcopy_managed(skb))
-               __skb_frag_unref(&shinfo->frags[f], skb->pp_recycle);
+               __skb_frag_unref(&shinfo->frags[f], skb_pp_recycle(skb));
 }

 /**
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 180df58e85c72eaa16f5cb56b56d181a379b8921..7a2783a2c9608eec728a0adacea4619ab1c62791
100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -801,19 +801,13 @@ static void skb_clone_fraglist(struct sk_buff *skb)
                skb_get(list);
 }

-static bool skb_pp_recycle(struct sk_buff *skb, void *data)
-{
-       if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
-               return false;
-       return page_pool_return_skb_page(virt_to_page(data));
-}
-
 static void skb_free_head(struct sk_buff *skb)
 {
        unsigned char *head = skb->head;

        if (skb->head_frag) {
-               if (skb_pp_recycle(skb, head))
+               if (skb_pp_recycle(skb) &&
+                   page_pool_return_skb_page(virt_to_page(head)))
                        return;
                skb_free_frag(head);
        } else {
@@ -840,7 +834,7 @@ static void skb_release_data(struct sk_buff *skb,
enum skb_drop_reason reason)
        }

        for (i = 0; i < shinfo->nr_frags; i++)
-               __skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
+               __skb_frag_unref(&shinfo->frags[i], skb_pp_recycle(skb));

 free_head:
        if (shinfo->frag_list)
@@ -857,7 +851,10 @@ static void skb_release_data(struct sk_buff *skb,
enum skb_drop_reason reason)
         * Eventually the last SKB will have the recycling bit set and it's
         * dataref set to 0, which will trigger the recycling
         */
+#ifdef CONFIG_PAGE_POOL
        skb->pp_recycle = 0;
+#endif
+       return;
 }

 /*
@@ -1292,7 +1289,9 @@ static struct sk_buff *__skb_clone(struct
sk_buff *n, struct sk_buff *skb)
        n->nohdr = 0;
        n->peeked = 0;
        C(pfmemalloc);
+#ifdef CONFIG_PAGE_POOL
        C(pp_recycle);
+#endif
        n->destructor = NULL;
        C(tail);
        C(end);
@@ -3859,7 +3858,7 @@ int skb_shift(struct sk_buff *tgt, struct
sk_buff *skb, int shiftlen)
                fragto = &skb_shinfo(tgt)->frags[merge];

                skb_frag_size_add(fragto, skb_frag_size(fragfrom));
-               __skb_frag_unref(fragfrom, skb->pp_recycle);
+               __skb_frag_unref(fragfrom, skb_pp_recycle(skb));
        }

        /* Reposition in the original skb */
@@ -5529,7 +5528,7 @@ bool skb_try_coalesce(struct sk_buff *to, struct
sk_buff *from,
         * references for cloned SKBs at the moment that would result in
         * inconsistent reference counts.
         */
-       if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
+       if (skb_pp_recycle(to) != (skb_pp_recycle(from) && !skb_cloned(from)))
                return false;

        if (len <= skb_tailroom(to)) {
