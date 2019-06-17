Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADAE49532
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfFQWeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:34:01 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34597 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfFQWeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 18:34:01 -0400
Received: by mail-pf1-f196.google.com with SMTP id c85so6437182pfc.1
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 15:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FXE9WdbG9ONgkM2/gm0jD5YCXgChNzqx26okDQdVIS0=;
        b=fkN3QYHRp7QiLIcPu4dvDIWVt80ClVW0UbIbNSd/IH5oix6gqwyZPPETgiA9JVT5mN
         SMyfA1ZvhGv2uzDu2fD6iruT2/x6yxnDAOnSgGNTsIipSqYv4MONuPv2G8OQNPt5nCC2
         mH5r6bOyCadCLyVo3AmTCv1IODdK6iCbkdXxpPfwhFt1koB6V0KLqX1a7UlA/MwS/FZo
         1mXEU0biZqULzGnujdXbDNGAzSt/rHSgsE38DD8zE7e9CRjQyNP/lzH5KbRYmQg1/zIG
         WGX0aGC21snDoZiSyKVZV4vyPtsln2vDqPLxxdRt0kF7WPSUARC1VTbYAb3kiZmNS0Ht
         NYPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FXE9WdbG9ONgkM2/gm0jD5YCXgChNzqx26okDQdVIS0=;
        b=QWKqKTRrGoUS3qqP3fQCmLbZc0ziTxGvIVRttnfqa3/Ey/1VHJRbsVMo87J3FKU7C8
         VnUUElPLg7xKGV4xxAiCMC+zj0t/TD8bdH5NW7/IK5FP+uMDoKD4y4Gg3EsTXikH32Xd
         o9niiSd4BgjF2YFODZyUVLUPs0T9RgV1gouCWWXDbmdPoN94FNx5KNGD/xrExTZbp41d
         8ZWo/N3Vm4rnnDAqSijhll1Z1sKDwmnIdTBxGqQNzNA5F0vLOjwR7Sbl9nTK4FOlIPsw
         7Ly3caHLIgbaqRbpAAwcgPixPID6TZIHr78uhUQxNGbWmLzKqEleZldrmQyj8/gBPOzd
         oIxw==
X-Gm-Message-State: APjAAAWJBLe4prLRMvDKc+T5KSKqGV5rxLW2+cdPvt3t+vvWxvMtmXsl
        Dqa0E80SSQiBD4mulaLRA1YidedOREsYbTHlvi7fGC2NN0s=
X-Google-Smtp-Source: APXvYqxtMwmz5RMBXpPbNAtqBRzVafRwjmwU8uECK3WmiEkXlHqlTTg5kFMybqS1+4dBG7QUU9tpoRIK0FnUwRUdsVc=
X-Received: by 2002:a62:3543:: with SMTP id c64mr33498528pfa.242.1560810840892;
 Mon, 17 Jun 2019 15:34:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190617181111.5025-1-jakub.kicinski@netronome.com> <20190617181111.5025-3-jakub.kicinski@netronome.com>
In-Reply-To: <20190617181111.5025-3-jakub.kicinski@netronome.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 17 Jun 2019 15:33:49 -0700
Message-ID: <CAM_iQpWakh+Tv6URcGtD4FJ-TvOLzf8p2EvYdv8trebfHEk_8g@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] net: netem: fix use after free and double free
 with packet corruption
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        netem@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Eric Dumazet <edumazet@google.com>,
        posk@google.com, Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 11:11 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> Brendan reports that the use of netem's packet corruption capability
> leads to strange crashes.  This seems to be caused by
> commit d66280b12bd7 ("net: netem: use a list in addition to rbtree")
> which uses skb->next pointer to construct a fast-path queue of
> in-order skbs.
>
> Packet corruption code has to invoke skb_gso_segment() in case
> of skbs in need of GSO.  skb_gso_segment() returns a list of
> skbs.  If next pointers of the skbs on that list do not get cleared
> fast path list may point to freed skbs or skbs which are also on
> the RB tree.
>
> Let's say skb gets segmented into 3 frames:
>
> A -> B -> C
>
> A gets hooked to the t_head t_tail list by tfifo_enqueue(), but it's
> next pointer didn't get cleared so we have:
>
> h t
> |/
> A -> B -> C
>
> Now if B and C get also get enqueued successfully all is fine, because
> tfifo_enqueue() will overwrite the list in order.  IOW:
>
> Enqueue B:
>
> h    t
> |    |
> A -> B    C
>
> Enqueue C:
>
> h         t
> |         |
> A -> B -> C
>
> But if B and C get reordered we may end up with:
>
> h t            RB tree
> |/                |
> A -> B -> C       B
>                    \
>                     C
>
> Or if they get dropped just:
>
> h t
> |/
> A -> B -> C
>
> where A and B are already freed.
>
> To reproduce either limit has to be set low to cause freeing of
> segs or reorders have to happen (due to delay jitter).
>
> Note that we only have to mark the first segment as not on the
> list, "finish_segs" handling of other frags already does that.
>
> Another caveat is that qdisc_drop_all() still has to free all
> segments correctly in case of drop of first segment, therefore
> we re-link segs before calling it.


Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks for the detailed description!
