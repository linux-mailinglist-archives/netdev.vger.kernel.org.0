Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2398943C5C8
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239682AbhJ0I7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239693AbhJ0I7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:59:30 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3424AC061570;
        Wed, 27 Oct 2021 01:57:05 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id 64-20020a4a0d43000000b002b866fa13eeso695337oob.2;
        Wed, 27 Oct 2021 01:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YwSSRfZtyXtdnhgE1o7XRnPpqRuEycign/6LI2KK2b8=;
        b=hDDCHPg19TyIv1FMbpzb7tnnPUacwJcXPMN5sAEngXNzFurL0deg5JYhsYwENi2Gxh
         UeN+j05leWo3OuSHIznM1N7HmbSKBKsYeW24akSDHn2lvd/FUdmiUktizi7l6RgjXkm7
         ucg/vgZY86n0z4KD/I9AwP+X8lBSAJ9qNslRCrGnrXVD1aBA3pnmkiDo3siSrGwMrnu4
         NMHgRgygac3po5+uWICwM6Sz7Fbw7ev8tF8YcpfX82WyoN/dZqI8pLdoO+pLUk5evJBH
         BYDnrkQN7F0AMfdRYUa+iRgLNTuVybQN9FlS25OQegBTAPu6X5iey8tAfWARmqTdOm8w
         Q3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YwSSRfZtyXtdnhgE1o7XRnPpqRuEycign/6LI2KK2b8=;
        b=8M/3838G5XkwXkDxQqQ5fkAmYaa2Wk58g/9l4gDvfZ34WQhFSrcKtZ7guI2EcNGNs1
         OoRRy+bU9jzSlfuDxS0/DGcSdEyuIscFl+lIfDhKTZsapEfagzaRKsNn4rbNO5E9gqvx
         5eRQzIa04VxUrvTrV/aXvb3vspAjIYkjJYIM7JiIuCu65AdhSog8SpimssKFD2VeeFsJ
         gEixPvMELndJOwYCNjSC1KKh4qTsBTYp1sQ9X295+Fof6GIZU3baA5Koo3wGl887UaRw
         jSZkkvimeHzCrAPPaCrxwgDUWBTAOgji7+4dcY5UHm0ie3cpnLzIrJQ8HA9s5uQCiHrL
         1zUQ==
X-Gm-Message-State: AOAM532gu2sds+QEirEFqpr/PMuB8XjeZLrvwVIT5ozvXRVSKp8sKbgQ
        cWW6Bx9G/J2Eh2lubfBXL6AOnkMlAYs8daeqzSw=
X-Google-Smtp-Source: ABdhPJzciFHjUV8q+/lzZKUDAynjdaiZON5aE9i6mkICaiVsIwDus2j2PCeA2quiz9KQcuIihAQWaLwnAJ0v3AkgiVc=
X-Received: by 2002:a4a:be0a:: with SMTP id l10mr20752771oop.64.1635325024588;
 Wed, 27 Oct 2021 01:57:04 -0700 (PDT)
MIME-Version: 1.0
References: <20211026131859.59114-1-kerneljasonxing@gmail.com>
 <CAL+tcoC487AF=HAiNVhKO6kA0yhjT+hmp5DQSdaGBnJEtGgqPA@mail.gmail.com> <CAL+tcoAD+iiEFbvMnaHjg_-42_r7ukxDt8CveYW7pE4arcdKsg@mail.gmail.com>
In-Reply-To: <CAL+tcoAD+iiEFbvMnaHjg_-42_r7ukxDt8CveYW7pE4arcdKsg@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 27 Oct 2021 16:56:28 +0800
Message-ID: <CAL+tcoAUwEx3ZJ5ysu_+-1eYfuL82JoV0fk7305dSOSo6J80-w@mail.gmail.com>
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

On Wed, Oct 27, 2021 at 4:07 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> On Wed, Oct 27, 2021 at 3:23 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >
> > On Tue, Oct 26, 2021 at 9:19 PM <kerneljasonxing@gmail.com> wrote:
> > >
> > > From: Jason Xing <xingwanli@kuaishou.com>
> > >
> > > Setting the @next of the last skb to NULL to prevent the panic in future
> > > when someone does something to the last of the gro list but its @next is
> > > invalid.
> > >
> > > For example, without the fix (commit: ece23711dd95), a panic could happen
> > > with the clsact loaded when skb is redirected and then validated in
> > > validate_xmit_skb_list() which could access the error addr of the @next
> > > of the last skb. Thus, "general protection fault" would appear after that.
> > >
> > > Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> > > ---
> > >  net/core/skbuff.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 2170bea..7b248f1 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -4396,6 +4396,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> > >                 skb_shinfo(p)->frag_list = skb;
> > >         else
> > >                 NAPI_GRO_CB(p)->last->next = skb;
> > > +       skb->next = NULL;
> > >         NAPI_GRO_CB(p)->last = skb;
> >
> > Besides, I'm a little bit confused that this operation inserts the
> > newest skb into the tail of the flow, so the tail of flow is the
> > newest, head oldest. The patch (commit: 600adc18) introduces the flush
> > of the oldest when the flow is full to lower the latency, but actually
> > it fetches the tail of the flow. Do I get something wrong here? I feel
>
> I have to update this part. The commit 600adc18 evicts and flushes the
> oldest flow. But for the current kernel, when
> "napi->gro_hash[hash].count >= MAX_GRO_SKBS" happens, the
> gro_flush_oldest() flushes the oldest skb of one certain flow,
> actually it is the newest skb because it is at the end of the list.

I just submitted another patch to explain how it happens, please help
me review both patches.

Link: https://lore.kernel.org/lkml/20211027084944.4508-1-kerneljasonxing@gmail.com/

Thanks again,
Jason

>
> > it is really odd.
> >
> > Thanks,
> > Jason
> >
> > >         __skb_header_release(skb);
> > >         lp = p;
> > > --
> > > 1.8.3.1
> > >
