Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022E145D38B
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 04:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhKYDWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 22:22:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238752AbhKYDUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 22:20:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D8366108B;
        Thu, 25 Nov 2021 03:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637810210;
        bh=v8EnFvaWn1dsw5XtWPGIJHBw/XRhcawsTpJuGMLdQv4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QyhWNSsYRJSeg6AWDIrXt0x98gXrJgCoKARxJeW+n5jAht0AORIP40mpvpw8v9aJZ
         1onkEQodQkyLjsyZ72avzuP+oqdDzWnvPVKY7f+tzDASVBG1tTIhPbY+JKAjhpqpxY
         z3ba0/ilC01G3qz1NFwE0qk588tIm+8gej4jPJKx6FvaH//+0nqvPTtoRIcxxfO3Pa
         tP47UbYMys7N+uzk0g9RKt/hu9jED2GZXEJVtNfQ6CCIm9CIF20nkGhfU0uz3/3k1D
         MNT0eCTV2e9wimtGY73FAPGXDzswjwU7sagaUYOmJ+v3P1OqS+MSne4VckzvI508LR
         cKMzzHMltjRvA==
Date:   Wed, 24 Nov 2021 19:16:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Serhiy Boiko <serhiy.boiko@marvell.com>
Subject: Re: [PATCH net-next 2/3] net: prestera: add counter HW API
Message-ID: <20211124191649.08f7ba14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1637686684-2492-3-git-send-email-volodymyr.mytnyk@plvision.eu>
References: <1637686684-2492-1-git-send-email-volodymyr.mytnyk@plvision.eu>
        <1637686684-2492-3-git-send-email-volodymyr.mytnyk@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 18:58:01 +0200 Volodymyr Mytnyk wrote:
> +	block = prestera_counter_block_lookup_not_full(counter, client);
> +	if (!block) {

if (block)
	return block;

> +		block = kzalloc(sizeof(*block), GFP_KERNEL);
> +		if (!block)
> +			return ERR_PTR(-ENOMEM);
> +
> +		err = prestera_hw_counter_block_get(counter->sw, client,
> +						    &block->id, &block->offset,
> +						    &block->num_counters);
> +		if (err)
> +			goto err_block;
> +
> +		block->stats = kcalloc(block->num_counters,
> +				       sizeof(*block->stats), GFP_KERNEL);
> +		if (!block->stats) {
> +			err = -ENOMEM;
> +			goto err_stats;
> +		}
> +
> +		block->counter_flag = kcalloc(block->num_counters,
> +					      sizeof(*block->counter_flag),
> +					      GFP_KERNEL);
> +		if (!block->counter_flag) {
> +			err = -ENOMEM;
> +			goto err_flag;
> +		}
> +
> +		block->client = client;
> +		mutex_init(&block->mtx);
> +		refcount_set(&block->refcnt, 1);
> +		idr_init_base(&block->counter_idr, block->offset);
> +
> +		err = prestera_counter_block_list_add(counter, block);
> +		if (err)
> +			goto err_list_add;
> +	}
> +
> +	return block;
