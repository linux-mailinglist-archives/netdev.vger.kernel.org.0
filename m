Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35D226BF60
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 10:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgIPIdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 04:33:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbgIPIdh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 04:33:37 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F2D8206DC;
        Wed, 16 Sep 2020 08:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600245217;
        bh=Rxv7LUtX5OOwYwfMY6OFP0ly0hsgeYow1jDz+KP5aNA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nd09tyczy1fwGBIA4dlKWgU20CIqgxVYoR7eidAzDV84z4U170OgQdsLYFaKUlxR4
         uikblA9OmXDhqrnZ9dhX+ajoujqfaUi+rCCtz5JKw0ZdHIL9Kf2B8HJjhips2CIcc3
         EeJc5w5m39NHViYfjArIlqsT+JQSfKCsM/o3BWZw=
Message-ID: <f2a27306606ab6a882f6a6e4363d07174e55c745.camel@kernel.org>
Subject: Re: [PATCH net-next 6/6] net: hns3: use napi_consume_skb() when
 cleaning tx desc
From:   Saeed Mahameed <saeed@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Date:   Wed, 16 Sep 2020 01:33:35 -0700
In-Reply-To: <2b1219b6-a7dd-38a3-bfb7-1cb49330df90@huawei.com>
References: <1600085217-26245-1-git-send-email-tanhuazhong@huawei.com>
         <1600085217-26245-7-git-send-email-tanhuazhong@huawei.com>
         <e615366cb2b260bf1b77fdaa0692957ab750a9a4.camel@nvidia.com>
         <2b1219b6-a7dd-38a3-bfb7-1cb49330df90@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-09-15 at 15:04 +0800, Yunsheng Lin wrote:
> On 2020/9/15 13:09, Saeed Mahameed wrote:
> > On Mon, 2020-09-14 at 20:06 +0800, Huazhong Tan wrote:
> > > From: Yunsheng Lin <linyunsheng@huawei.com>
> > > 
> > > Use napi_consume_skb() to batch consuming skb when cleaning
> > > tx desc in NAPI polling.
> > > 
> > > Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> > > Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> > > ---
> > >  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 27
> > > +++++++++++-
> > > ----------
> > >  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  2 +-
> > >  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  4 ++--
> > >  3 files changed, 17 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> > > b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> > > index 4a49a76..feeaf75 100644
> > > --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> > > +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> > > @@ -2333,10 +2333,10 @@ static int hns3_alloc_buffer(struct
> > > hns3_enet_ring *ring,
> > >  }
> > >  
> > >  static void hns3_free_buffer(struct hns3_enet_ring *ring,
> > > -			     struct hns3_desc_cb *cb)
> > > +			     struct hns3_desc_cb *cb, int budget)
> > >  {
> > >  	if (cb->type == DESC_TYPE_SKB)
> > > -		dev_kfree_skb_any((struct sk_buff *)cb->priv);
> > > +		napi_consume_skb(cb->priv, budget);
> > 
> > This code can be reached from hns3_lb_clear_tx_ring() below which
> > is
> > your loopback test and called with non-zero budget, I am not sure
> > you
> > are allowed to call napi_consume_skb() with non-zero budget outside
> > napi context, perhaps the cb->type for loopback test is different
> > in lb
> > test case ? Idk.. , please double check other code paths.
> 
> Yes, loopback test may call napi_consume_skb() with non-zero budget
> outside
> napi context. Thanks for pointing out this case.
> 
> How about add the below WARN_ONCE() in napi_consume_skb() to catch
> this
> kind of error?
> 
> WARN_ONCE(!in_serving_softirq(), "napi_consume_skb() is called with
> non-zero budget outside napi context");
> 

Cc: Eric

I don't know, need to check performance impact.
And in_serving_softirq() doesn't necessarily mean in napi
but looking at _kfree_skb_defer(), i think it shouldn't care if napi or
not as long as it runs in soft irq it will push the skb to that
particular cpu napi_alloc_cache, which should be fine.

Maybe instead of the WARN_ONCE just remove the budget condition and
replace it with

if (!in_serving_softirq())
      dev_consume_skb_any(skb);


