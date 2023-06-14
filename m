Return-Path: <netdev+bounces-10831-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C5DF73063D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:46:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDA751C20C9C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE761AD4A;
	Wed, 14 Jun 2023 17:46:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212327F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48B9C433C8;
	Wed, 14 Jun 2023 17:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686764766;
	bh=5wkgv8tPp6pcWRSjESKf+awe3ziEHv9EgVGR5zQmIpM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tzfh2SEOrk6Jvkglq5+qNYdbI0BEuxpdJliWyFAvHQAWOz5oiY7NFUWeZEH+YfsOR
	 IsMLeCoNcWgYvWQC4xcuA1P5uNTmRp3CM3oiuW1cZtBHi20euPUZYcTu2cyfLHSNDF
	 81BSDk6Y7hnCVVAnfTa45Ji+mv4VK4XkDO+LbJnhBaGtwfYIt/cRsCd3FCBNbfvcxx
	 7DfDefHdNUYshvFALBNeKHVOEOoOmrNsehgr2P6QgG5jKou8ofziyeVndMy5xheUUe
	 lgp9n8yantfcHNXF2zzdLMXs3djRaTHVIvgR+RZnd7VSCqDCwjm4BXoTbtlK8PXVg3
	 Eumf5t04lySOA==
Date: Wed, 14 Jun 2023 10:46:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Maxim Mikityanskiy <maxtram95@gmail.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, j.vosburgh@gmail.com, andy@greyhouse.net,
 rajur@chelsio.com, ayush.sawal@chelsio.com, dmichail@fungible.com,
 borisp@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
 simon.horman@corigine.com, john.fastabend@gmail.com,
 anirudh.venkataramanan@intel.com, tariqt@nvidia.com, gal@nvidia.com,
 raeds@nvidia.com, liorna@nvidia.com, louis.peens@corigine.com,
 yinjun.zhang@corigine.com, na.wang@corigine.com,
 linux-rdma@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH net-next] net: tls: make the offload check helper take
 skb not socket
Message-ID: <20230614104605.2f9b205f@kernel.org>
In-Reply-To: <ZIlng6G_xP3V8O5E@mail.gmail.com>
References: <20230613205006.1995873-1-kuba@kernel.org>
	<ZIlng6G_xP3V8O5E@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 10:09:02 +0300 Maxim Mikityanskiy wrote:
> On Tue, 13 Jun 2023 at 13:50:06 -0700, Jakub Kicinski wrote:
> > All callers of tls_is_sk_tx_device_offloaded() currently do
> > an equivalent of:
> > 
> >  if (skb->sk && tls_is_skb_tx_device_offloaded(skb->sk))
> > 
> > Have the helper accept skb and do the skb->sk check locally.
> > Two drivers have local static inlines with similar wrappers
> > already.
> > 
> > While at it change the ifdef condition to TLS_DEVICE.
> > Only TLS_DEVICE selects SOCK_VALIDATE_XMIT, so the two are
> > equivalent. This makes removing the duplicated IS_ENABLED()
> > check in funeth more obviously correct.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> 
> Acked-by: Maxim Mikityanskiy <maxtram95@gmail.com>

Thanks!

> > diff --git a/include/net/tls.h b/include/net/tls.h
> > index b7d0f1e3058b..5e71dd3df8ca 100644
> > --- a/include/net/tls.h
> > +++ b/include/net/tls.h
> > @@ -370,10 +370,12 @@ struct sk_buff *
> >  tls_validate_xmit_skb_sw(struct sock *sk, struct net_device *dev,
> >  			 struct sk_buff *skb);
> >  
> > -static inline bool tls_is_sk_tx_device_offloaded(struct sock *sk)
> > +static inline bool tls_is_skb_tx_device_offloaded(const struct sk_buff *skb)
> >  {
> > -#ifdef CONFIG_SOCK_VALIDATE_XMIT
> > -	return sk_fullsock(sk) &&
> > +#ifdef CONFIG_TLS_DEVICE
> > +	struct sock *sk = skb->sk;
> > +
> > +	return sk && sk_fullsock(sk) &&
> >  	       (smp_load_acquire(&sk->sk_validate_xmit_skb) ==
> >  	       &tls_validate_xmit_skb);
> >  #else  
> 
> After this change, the only usage of CONFIG_SOCK_VALIDATE_XMIT remains
> in sk_validate_xmit_skb, which has #ifdef CONFIG_TLS_DEVICE inside
> #ifdef CONFIG_SOCK_VALIDATE_XMIT. If feels a little bit weird, given
> that both defines always have the same value, but maybe it's OK if we
> consider that more users can start using sk_validate_xmit_skb in the
> future.

I'm working on another user of CONFIG_SOCK_VALIDATE_XMIT
so let's keep the two separate.

