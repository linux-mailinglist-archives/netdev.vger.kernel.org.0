Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977CD2DB8A6
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 02:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725308AbgLPByP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 20:54:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPByO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 20:54:14 -0500
Date:   Tue, 15 Dec 2020 17:53:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608083614;
        bh=Swk2QsEjVPuDUv8Z76BruXJHN/OEnY6gppqMoHzKYms=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=e794k+B40UufqoG0Ly+HoDAI26ww87wr17W7QoXDFaZWvCYKpxa78JmZy5yvCv+FH
         X1UovYb3v/0ayYU8MbNc3tiXPXk0IfOpUqEi3tYWmJMSwITwj7SRDYr0wpf5IBme0v
         jnF06U24TJldwrvJkeFeNFA3JwjG1IEUd1GcrpPgATLgJO23VjV5qnoopO93NuACXn
         78/+Aq3YvUFStl9dWFArfMeRIHbayuvS3S8Bdy70ULPjTkp4jtJt5SDjQHgUnHOI+f
         AszknGfWm7F74UhDHrBKz1o6b7A9ur+z7FpnhVNz8+9+Kgj/A+LktstGxTMmptGRp/
         3JLc502KPRuCQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v5 2/3] net: implement threaded-able napi poll
 loop support
Message-ID: <20201215175333.16735bf1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201216012515.560026-3-weiwan@google.com>
References: <20201216012515.560026-1-weiwan@google.com>
        <20201216012515.560026-3-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 17:25:14 -0800 Wei Wang wrote:
> +void napi_enable(struct napi_struct *n)
> +{
> +	bool locked = rtnl_is_locked();

Maybe you'll prove me wrong but I think this is never a correct
construct.

> +	BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
> +	smp_mb__before_atomic();
> +	clear_bit(NAPI_STATE_SCHED, &n->state);
> +	clear_bit(NAPI_STATE_NPSVC, &n->state);
> +	if (!locked)
> +		rtnl_lock();

Why do we need the lock? Can't we assume the caller of napi_enable()
has the sole ownership of the napi instance? Surely clearing the other
flags would be pretty broken as well, so the napi must had been
disabled when this is called by the driver.

> +	WARN_ON(napi_set_threaded(n, n->dev->threaded));
> +	if (!locked)
> +		rtnl_unlock();
> +}
> +EXPORT_SYMBOL(napi_enable);

Let's switch to RFC postings and get it in for 5.12 :(
