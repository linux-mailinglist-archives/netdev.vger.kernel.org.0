Return-Path: <netdev+bounces-1306-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 921596FD3E2
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 04:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6BDF28131E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 02:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C49373;
	Wed, 10 May 2023 02:40:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDF8361
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 02:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF274C4339C;
	Wed, 10 May 2023 02:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683686415;
	bh=xTwXGJpY+tfvtuEgoFDlHnaFapgn8t7yLtoIYT2vFVk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=A22gwnVL1ZntAP9vyhb7DWjkw4mSJeYqGJfQeJBnvCZa6ylXZUajqblHiEPYjv4yX
	 W5CztsJMkTAvq6v8FimwwfjjDyoYdIhVpJHcvbjaRTBvX5v8XYeF491T6qV6ZGFZC3
	 sqJk7loQFy8d3xq6F3sliZIDd9TywBZQfhD+S6SbDTlPh9zDulQplY9A4UKskuEyLZ
	 O/Ry1qWzTZFYeHod72OAeJJg6JegHwn7fchW1W0ckEU+zAZ2hX9YcLUpQ64VkEAnZZ
	 ckv5UqTWIcWqrIbbjsTNWTYHNni9Cq0Zz30RDPsHWHcge7AU7QQ9E/k/CFoHBdoJrc
	 MhMHmCRgedW2A==
Date: Tue, 9 May 2023 19:40:13 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Louis Peens <louis.peens@corigine.com>
Cc: David Miller <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
 stable@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH net] nfp: fix rcu_read_lock/unlock while
 rcu_derefrencing
Message-ID: <20230509194013.3c73ffbb@kernel.org>
In-Reply-To: <20230509060632.8233-1-louis.peens@corigine.com>
References: <20230509060632.8233-1-louis.peens@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  9 May 2023 08:06:32 +0200 Louis Peens wrote:
> +static inline
> +struct net_device *nfp_app_dev_get_locked(struct nfp_app *app, u32 id,

_locked() in what way? RCU functions typically use an _rcu suffix, no?

> +					  bool *redir_egress)
> +{
> +	struct net_device *dev;
> +
> +	if (unlikely(!app || !app->type->dev_get))
> +		return NULL;
> +
> +	rcu_read_lock();
> +	dev = app->type->dev_get(app, id, redir_egress);
> +	rcu_read_unlock();
> +
> +	return dev;

this looks very suspicious, RCU takes care primarily of the lifetime of
objects, in this case dev. Returning it after dropping the lock seems
wrong.

If the context is safe maybe it's a better idea to change the 
condition in rcu_dereference_check() to include rcu_read_lock_bh_held()?
-- 
pw-bot: cr

