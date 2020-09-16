Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385CA26BF7E
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 10:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgIPIjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 04:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgIPIjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 04:39:07 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D67C06174A
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 01:39:07 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id h11so5647114ilj.11
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 01:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JT6v7wMmRRApS8LmHSvE0RpU/6xtKoeS84pBH0gWQr8=;
        b=hrZv26mZbOdawlGGDUntFlNCFGHX9RG2dncSRkLVTNIK06u9xy9NOfglZd8EmquqqA
         Wk9rVE3elxEjwWLHWLgh2bb5/l0apJW9rj2DMIqyHDo6LGI95awOPoaxIcblBYJhkSMo
         aUkQabUHSOsmW2LBDvGD1irCNgmts6usIloEbvz3GilPUrvyZdk5K1THGh0qTEEEdogh
         9jiFE/mOi7OjgVXESARkVWKGEdO3CEj8B0keuB8796ksgZNL2ZfutuAVuCFjhinr0e03
         ortymrg2uAo6qnkShdTlX4otP1tXwTTtsES1gq05dAZRhjymEk8f/ShyDD//198O5eld
         6/7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JT6v7wMmRRApS8LmHSvE0RpU/6xtKoeS84pBH0gWQr8=;
        b=jNFkpfAPu/RyTMNTkCHLQARZywuwZFdBSy2u9x60W/UCFhTSTn613Oh6CPbf97lYn3
         agTMRUsMwogH6hwexGUocgAUvPravHnPNbmtLHKvHgZYaQzWXVYOG9+N6+n+gwUR2Z9Y
         6q7WwgycfKJnvDd3LAwxCaJ325rPsadzqqFjanR806bkCwPCupuY56WthHWRx71NKtR3
         9ifPmdrtgPAc7++Qzlvqh67THgJH64Pr5hB5s2X6epUSokPpl4WngXQNDwuOpVqbSOKZ
         rmKMJVT6jG5GtTnHr9vd1HzsNXtnw152okp4QSdYYFrRyv2Try0m0gHwD8BFOKpcncSO
         dQVw==
X-Gm-Message-State: AOAM530EZwGCWL6acioh3cgMxvJmn+rX+BKAuAfve4/y7kvxT9RBVglS
        N4r+cfOV+mWesoX57fs91sZI4NHwp696GMt+44gb1A==
X-Google-Smtp-Source: ABdhPJwOaAT/NvvF3qHlNr93GTy/LMlROi45Sxaeub50tguwCjp+Gpc2PMcAJgNTlqDPHSUy2jleSwq1Moaw8fvLqYA=
X-Received: by 2002:a92:1b8b:: with SMTP id f11mr3330268ill.216.1600245546474;
 Wed, 16 Sep 2020 01:39:06 -0700 (PDT)
MIME-Version: 1.0
References: <1600085217-26245-1-git-send-email-tanhuazhong@huawei.com>
 <1600085217-26245-7-git-send-email-tanhuazhong@huawei.com>
 <e615366cb2b260bf1b77fdaa0692957ab750a9a4.camel@nvidia.com>
 <2b1219b6-a7dd-38a3-bfb7-1cb49330df90@huawei.com> <f2a27306606ab6a882f6a6e4363d07174e55c745.camel@kernel.org>
In-Reply-To: <f2a27306606ab6a882f6a6e4363d07174e55c745.camel@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 16 Sep 2020 10:38:54 +0200
Message-ID: <CANn89iJwJwzv60pmWEcU-nJ1unbxXuAU7hyFBuzEo-nTHZmm8A@mail.gmail.com>
Subject: Re: [PATCH net-next 6/6] net: hns3: use napi_consume_skb() when
 cleaning tx desc
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 10:33 AM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On Tue, 2020-09-15 at 15:04 +0800, Yunsheng Lin wrote:
> > On 2020/9/15 13:09, Saeed Mahameed wrote:
> > > On Mon, 2020-09-14 at 20:06 +0800, Huazhong Tan wrote:
> > > > From: Yunsheng Lin <linyunsheng@huawei.com>
> > > >
> > > > Use napi_consume_skb() to batch consuming skb when cleaning
> > > > tx desc in NAPI polling.
> > > >
> > > > Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> > > > Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> > > > ---
> > > >  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 27
> > > > +++++++++++-
> > > > ----------
> > > >  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  2 +-
> > > >  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  4 ++--
> > > >  3 files changed, 17 insertions(+), 16 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> > > > b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> > > > index 4a49a76..feeaf75 100644
> > > > --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> > > > +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> > > > @@ -2333,10 +2333,10 @@ static int hns3_alloc_buffer(struct
> > > > hns3_enet_ring *ring,
> > > >  }
> > > >
> > > >  static void hns3_free_buffer(struct hns3_enet_ring *ring,
> > > > -                      struct hns3_desc_cb *cb)
> > > > +                      struct hns3_desc_cb *cb, int budget)
> > > >  {
> > > >   if (cb->type == DESC_TYPE_SKB)
> > > > -         dev_kfree_skb_any((struct sk_buff *)cb->priv);
> > > > +         napi_consume_skb(cb->priv, budget);
> > >
> > > This code can be reached from hns3_lb_clear_tx_ring() below which
> > > is
> > > your loopback test and called with non-zero budget, I am not sure
> > > you
> > > are allowed to call napi_consume_skb() with non-zero budget outside
> > > napi context, perhaps the cb->type for loopback test is different
> > > in lb
> > > test case ? Idk.. , please double check other code paths.
> >
> > Yes, loopback test may call napi_consume_skb() with non-zero budget
> > outside
> > napi context. Thanks for pointing out this case.
> >
> > How about add the below WARN_ONCE() in napi_consume_skb() to catch
> > this
> > kind of error?
> >
> > WARN_ONCE(!in_serving_softirq(), "napi_consume_skb() is called with
> > non-zero budget outside napi context");
> >
>
> Cc: Eric
>
> I don't know, need to check performance impact.
> And in_serving_softirq() doesn't necessarily mean in napi
> but looking at _kfree_skb_defer(), i think it shouldn't care if napi or
> not as long as it runs in soft irq it will push the skb to that
> particular cpu napi_alloc_cache, which should be fine.
>
> Maybe instead of the WARN_ONCE just remove the budget condition and
> replace it with
>
> if (!in_serving_softirq())
>       dev_consume_skb_any(skb);
>

I think we need to keep costs small.

So lets add a CONFIG_DEBUG_NET option so that developers can add
various DEBUG_NET() clauses.
