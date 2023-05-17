Return-Path: <netdev+bounces-3158-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E80A705CC4
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 04:02:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9962C1C20A8C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 02:02:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB1BA111A1;
	Wed, 17 May 2023 02:02:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7C7290FD
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 02:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC292C433D2;
	Wed, 17 May 2023 02:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684288954;
	bh=nZ5Yl1aBqjCNoqsfkbnNbFU0g+9j9zoBOVEbjHTgBAw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Sdlt1vIGnne6o9mHrt4pOxUbgOMlCsyUYtFYmZaVHMF+0HEd+dVcgpSIRhpKzT8U6
	 8UT6Q4jqE3Ol/90RKS2QZjnJ9OqA16x/G8hXLwYieQeam94V7EmNxj6zAVtI4jOw7/
	 hmcVDpFxsKunPnP2T8bxj3bwcvMhUimB8zX1oiJnYjPPJTgLbTZ29oDze9gbor8YYy
	 SAWD926GaDTIjU68x024VzIpSSUmWYVNrIptYjl+n9hgTJsMQpLiBx4L0wE0fW5sp0
	 XO5ACsRVS3hNDM44i0es0vYpjWZpOlMeYptzHo9cQLeTKx1rZhMp0e5KZYZne6iqr1
	 kNh9F5YOZ0IKA==
Date: Tue, 16 May 2023 19:02:32 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
 saeedm@nvidia.com, leon@kernel.org, brouer@redhat.com, tariqt@mellanox.com
Subject: Re: [PATCH net] net/mlx5e: do as little as possible in napi poll
 when budget is 0
Message-ID: <20230516190232.71b1ba28@kernel.org>
In-Reply-To: <CANn89iJgT49PKvwZKXShQXivayESxRWYOHC5tHC8CLwkTSwmZg@mail.gmail.com>
References: <20230512025740.1068965-1-kuba@kernel.org>
	<CANn89iJgT49PKvwZKXShQXivayESxRWYOHC5tHC8CLwkTSwmZg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 May 2023 18:39:20 +0200 Eric Dumazet wrote:
> > +       /* budget=0 means we may be in IRQ context, do as little as possible */
> > +       if (unlikely(!budget)) {
> > +               /* no work done, can't be asked to re-enable IRQs */
> > +               WARN_ON_ONCE(napi_complete_done(napi, work_done));  
> 
> This is not clear why you call napi_complete_done() here ?
> 
> Note the fine doc  ( https://www.kernel.org/doc/html/next/networking/napi.html )
> says:
> 
> <quote>If the budget is 0 napi_complete_done() should never be called.</quote>

fair point, I was trying to be conservative because I think it would
have gotten called before

