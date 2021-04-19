Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244B9364038
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 13:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhDSLGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 07:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbhDSLF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 07:05:58 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87678C061760
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 04:05:28 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id x76so28222496ybe.5
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 04:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5LqvcoPM7aAQAIxRhAZ6fd0FECC20Osn+I0reTRncUE=;
        b=ZO9NymKa3LAaawzpOVdexZjSPKp7U4zlElcQBLoqnCDOfmv6CHMcl+Ky0yOyC/AKTc
         pMtDB4EK2xiMgC3dP5Wtc+dcMGECpkOkSVC3VJ3XonC1vCIbxXjyAYCigsdcNV99x+FN
         0NQpXD3+LMz8vsuC1Azj2wVtf2eF68H93ZnL4GB367BO3bDo9cpMc03nGXRK7hwAMxHp
         mDp8LqQbyc9N+kerBezoq7+coFvdzx/D59UvMJbZv1j+9+RgCSSkbaAuZplSXd2OjG0X
         evW7lTD7gilOR8VAB5y2M50wCmx+1ws658G/WCiyegX2LnsQGtnKBAApl08QNHL2wHq9
         lFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5LqvcoPM7aAQAIxRhAZ6fd0FECC20Osn+I0reTRncUE=;
        b=PPDs7kWKCwOI0rP7wiq3Rz/uBHyoTLghMHechu7TWThl01FhIY4Ec125ak33+BU7+P
         7lqkMMoIETfCmjZEVxZyXfqlteYoGlvJ8G5X9F6SxrOZ21vgo9xU/6nXHtUcQSsFxiD9
         3HUwcRZKyLpMxN/pC+B7Tw8PDELYIr6Db896uEtucOyRVcBhR+LYjtmBDM0zwQKJw5sf
         PfQdW6hbG3If35Sbr5RUuz5pmP3CnP08cXuOyZbUlCz69GDdOik2fWSyVwszg4DnDMkm
         SY/EPcq9ESM82wBjlwbaCzZMa3eh1ACxxEZ6vYOuTsNt5j6xlmOLQ3Cm6N0Lb8l4qM69
         dQ/w==
X-Gm-Message-State: AOAM5307d5cbFZBftOXco1IwP5Gw0b5BeTZIsSjZFnG0Dq4Cl7g4zA8R
        itTeAL1/y/tornC2I9c0SeZpmDB+SfvAtHsVxGDKDQ==
X-Google-Smtp-Source: ABdhPJx2OjyQuMkimOyMB6R/FRIN3pN/2b1ww6PAx/yBwzmlS+Ps69LISVBLhfiYdhbvwdZIX0m4wGTOQRgp5e8rvtA=
X-Received: by 2002:a25:850b:: with SMTP id w11mr16207623ybk.518.1618830327412;
 Mon, 19 Apr 2021 04:05:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210418114200.5839-1-alobakin@pm.me>
In-Reply-To: <20210418114200.5839-1-alobakin@pm.me>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 19 Apr 2021 13:05:16 +0200
Message-ID: <CANn89iJQebFaJKsj3BC0tY27f1ttDpbpMOXjOFtgrFNVN_B9wA@mail.gmail.com>
Subject: Re: [PATCH net] gro: fix napi_gro_frags() Fast GRO breakage due to IP
 alignment check
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 18, 2021 at 1:43 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> Commit 38ec4944b593 ("gro: ensure frag0 meets IP header alignment")
> did the right thing, but missed the fact that napi_gro_frags() logics
> calls for skb_gro_reset_offset() *before* pulling Ethernet header
> to the skb linear space.
> That said, the introduced check for frag0 address being aligned to 4
> always fails for it as Ethernet header is obviously 14 bytes long,
> and in case with NET_IP_ALIGN its start is not aligned to 4.
>
> Fix this by adding @nhoff argument to skb_gro_reset_offset() which
> tells if an IP header is placed right at the start of frag0 or not.
> This restores Fast GRO for napi_gro_frags() that became very slow
> after the mentioned commit, and preserves the introduced check to
> avoid silent unaligned accesses.
>
> Fixes: 38ec4944b593 ("gro: ensure frag0 meets IP header alignment")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  net/core/dev.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1f79b9aa9a3f..965d5f9b6fee 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5914,7 +5914,7 @@ static struct list_head *gro_list_prepare(struct napi_struct *napi,
>         return head;
>  }
>
> -static void skb_gro_reset_offset(struct sk_buff *skb)
> +static void skb_gro_reset_offset(struct sk_buff *skb, u32 nhoff)
>  {
>         const struct skb_shared_info *pinfo = skb_shinfo(skb);
>         const skb_frag_t *frag0 = &pinfo->frags[0];
> @@ -5925,7 +5925,7 @@ static void skb_gro_reset_offset(struct sk_buff *skb)
>
>         if (!skb_headlen(skb) && pinfo->nr_frags &&
>             !PageHighMem(skb_frag_page(frag0)) &&
> -           (!NET_IP_ALIGN || !(skb_frag_off(frag0) & 3))) {
> +           (!NET_IP_ALIGN || !((skb_frag_off(frag0) + nhoff) & 3))) {
>                 NAPI_GRO_CB(skb)->frag0 = skb_frag_address(frag0);
>                 NAPI_GRO_CB(skb)->frag0_len = min_t(unsigned int,
>                                                     skb_frag_size(frag0),
> @@ -6143,7 +6143,7 @@ gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
>         skb_mark_napi_id(skb, napi);
>         trace_napi_gro_receive_entry(skb);
>
> -       skb_gro_reset_offset(skb);
> +       skb_gro_reset_offset(skb, 0);
>
>         ret = napi_skb_finish(napi, skb, dev_gro_receive(napi, skb));
>         trace_napi_gro_receive_exit(ret);
> @@ -6232,7 +6232,7 @@ static struct sk_buff *napi_frags_skb(struct napi_struct *napi)
>         napi->skb = NULL;
>
>         skb_reset_mac_header(skb);
> -       skb_gro_reset_offset(skb);
> +       skb_gro_reset_offset(skb, hlen);
>
>         if (unlikely(skb_gro_header_hard(skb, hlen))) {
>                 eth = skb_gro_header_slow(skb, hlen, 0);
> --
> 2.31.1
>
>

Good catch, thanks.

This has the unfortunate effect of increasing code length on x86,
maybe we should have an exception to
normal rules so that skb_gro_reset_offset() is inlined.

Reviewed-by: Eric Dumazet <edumazet@google.com>
