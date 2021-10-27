Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFED43C4AA
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbhJ0IKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239104AbhJ0IKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:10:12 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42408C061570;
        Wed, 27 Oct 2021 01:07:47 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id y15-20020a9d460f000000b0055337e17a55so2444581ote.10;
        Wed, 27 Oct 2021 01:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mtt6K2LWB25b7AgK97wNPqfxuIsCgwqKLzzbnl0i1Og=;
        b=Lq6qabtt5TSFhvKVjpTcThsWSl7eI2dotOpZ5O7Mpls+7760sqwjU6GEHLFl9uBUo3
         bzXa1dequ8KHrj7O842qkEk8yIyEP4McDhVijHxmygaN/xbOfyvFUPldpkwRPp8h9teA
         8jvhOnu6Pt56tAoEy6AgQDgoGHug8T8+V+Q3NH08NM+2E2JTe95d2Xq6D1hYy9dzzaC4
         ZXaq/z2D9vo2Q5O59mnr81Yn8YR4QIYFlijX0PXcRXhhKEBlv1UTN112MWfA/4+wYRhM
         2rOlrXb0ecdjOm8o2OZbx/1UP2Dqkj5+AKJFV3nYxbNaPbbMFcVUK6v81DgQLYMWOCWs
         bC6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mtt6K2LWB25b7AgK97wNPqfxuIsCgwqKLzzbnl0i1Og=;
        b=Utn0xVhzj7k1bwuUhUtmsjTcBY2E1S9oPoU+HlT79AbXobqtKF3iXRqq0LPFbPcTWc
         D6+8hezdcKUwgsi9ySqs3i5wkYTjMcBvnwgo5ymUHMhs+vB+sY4DjqpdLl30ybv8D/vy
         Gh41rN8LBYKuan3MK4j8gUv+Bu+qoXvtqk1JBMj9dhtDXyc554SyATrD4AOc1gKkNrKS
         HEDs+2Qs7jR5DenwTIaGoaXvkjFRtP3pLXmF0tOzOkE1MMAyfi+IgrL3R4X2IO3cSYB2
         MKb+BjXKoarrKlHMqI3lMKjdKYd4+wd2XCOGKMbV8Y/1GGR76xFy0afPqUdCk3/ldZx1
         QZig==
X-Gm-Message-State: AOAM5331rPh62u5hgOYq85KQ6G74xMSc4RXbtD6pK2+4KLU5HK94ZC+Q
        YmIu9Uv/gTpNN/lj+34rI6wjSSHykQ+E3x6XwV0=
X-Google-Smtp-Source: ABdhPJwKFSy0QLc1ujAAvBSvT8ED/3Qp3n2h+8nJvpeFvYE7sFnerjvzkmZgCwWdprqM87EmqpJ/FN2sDZF1oogDXtI=
X-Received: by 2002:a9d:72de:: with SMTP id d30mr23748654otk.18.1635322066670;
 Wed, 27 Oct 2021 01:07:46 -0700 (PDT)
MIME-Version: 1.0
References: <20211026131859.59114-1-kerneljasonxing@gmail.com> <CAL+tcoC487AF=HAiNVhKO6kA0yhjT+hmp5DQSdaGBnJEtGgqPA@mail.gmail.com>
In-Reply-To: <CAL+tcoC487AF=HAiNVhKO6kA0yhjT+hmp5DQSdaGBnJEtGgqPA@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 27 Oct 2021 16:07:10 +0800
Message-ID: <CAL+tcoAD+iiEFbvMnaHjg_-42_r7ukxDt8CveYW7pE4arcdKsg@mail.gmail.com>
Subject: Re: [PATCH net] net: gro: set the last skb->next to NULL when it get merged
To:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        alobakin@pm.me, jonathan.lemon@gmail.com,
        Willem de Bruijn <willemb@google.com>, pabeni@redhat.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jason Xing <xingwanli@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 3:23 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> On Tue, Oct 26, 2021 at 9:19 PM <kerneljasonxing@gmail.com> wrote:
> >
> > From: Jason Xing <xingwanli@kuaishou.com>
> >
> > Setting the @next of the last skb to NULL to prevent the panic in future
> > when someone does something to the last of the gro list but its @next is
> > invalid.
> >
> > For example, without the fix (commit: ece23711dd95), a panic could happen
> > with the clsact loaded when skb is redirected and then validated in
> > validate_xmit_skb_list() which could access the error addr of the @next
> > of the last skb. Thus, "general protection fault" would appear after that.
> >
> > Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> > ---
> >  net/core/skbuff.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 2170bea..7b248f1 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -4396,6 +4396,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> >                 skb_shinfo(p)->frag_list = skb;
> >         else
> >                 NAPI_GRO_CB(p)->last->next = skb;
> > +       skb->next = NULL;
> >         NAPI_GRO_CB(p)->last = skb;
>
> Besides, I'm a little bit confused that this operation inserts the
> newest skb into the tail of the flow, so the tail of flow is the
> newest, head oldest. The patch (commit: 600adc18) introduces the flush
> of the oldest when the flow is full to lower the latency, but actually
> it fetches the tail of the flow. Do I get something wrong here? I feel

I have to update this part. The commit 600adc18 evicts and flushes the
oldest flow. But for the current kernel, when
"napi->gro_hash[hash].count >= MAX_GRO_SKBS" happens, the
gro_flush_oldest() flushes the oldest skb of one certain flow,
actually it is the newest skb because it is at the end of the list.

> it is really odd.
>
> Thanks,
> Jason
>
> >         __skb_header_release(skb);
> >         lp = p;
> > --
> > 1.8.3.1
> >
