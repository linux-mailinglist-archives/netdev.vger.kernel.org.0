Return-Path: <netdev+bounces-10972-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1035E730E02
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:20:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABF7B281635
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 04:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E763D644;
	Thu, 15 Jun 2023 04:20:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A310E625
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7FAC433C8;
	Thu, 15 Jun 2023 04:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686802833;
	bh=r3ZuN3Io1bp4/Cx8s+S52ckgv49Kj7xPRrS9LZj78qw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IfbgiUVc7uLqqHRL8KUASPv6Z16ClS1aiRs7oGyJKkm/vhvLNrYXGPrQvYT/obKXm
	 c9h3k8mpXRhCvKEL54FL1UlN0zFVlOpJLoyB1BlcRBMF1FWv62TmYAmyu5XYhzdcxz
	 5gnZMnTvnLuEmvFRn93YX9HF/IqxuKZEt22OrrO4sP+8TVqYOr2ywPFWM47ny5A//L
	 NG32aWIHLBVnkJBVj3QaELhB9/74dKIcqoo8IzrYq7n1kormZsFT82JdnD8EfbKlBG
	 93YF/4eKN2QjvfSpTMjnYaHm6bVAqATiV9rg8aloSxoXYyjxJoVprc3uwH8HawQPih
	 +wIdq5NQ88LTQ==
Date: Wed, 14 Jun 2023 21:20:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Liang Chen <liangchen.linux@gmail.com>
Cc: hawk@kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com
Subject: Re: [PATCH net-next] page pool: not return page to alloc cache
 during pool destruction
Message-ID: <20230614212031.7e1b6893@kernel.org>
In-Reply-To: <20230615013645.7297-1-liangchen.linux@gmail.com>
References: <20230615013645.7297-1-liangchen.linux@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 09:36:45 +0800 Liang Chen wrote:
> When destroying a page pool, the alloc cache and recycle ring are emptied.
> If there are inflight pages, the retry process will periodically check the
> recycle ring for recently returned pages, but not the alloc cache (alloc
> cache is only emptied once). As a result, any pages returned to the alloc
> cache after the page pool destruction will be stuck there and cause the
> retry process to continuously look for inflight pages and report warnings.
> 
> To safeguard against this situation, any pages returning to the alloc cache
> after pool destruction should be prevented.

Let's hear from the page pool maintainers but I think the driver 
is supposed to prevent allocations while pool is getting destroyed.
Perhaps we can add DEBUG_NET_WARN_ON_ONCE() for this condition to
prevent wasting cycles in production builds?

