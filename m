Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9669A5879D
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfF0Qup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:50:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56312 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfF0Quo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 12:50:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C98514C823C2;
        Thu, 27 Jun 2019 09:50:44 -0700 (PDT)
Date:   Thu, 27 Jun 2019 09:50:43 -0700 (PDT)
Message-Id: <20190627.095043.1607458136575294159.davem@davemloft.net>
To:     sw@simonwunderlich.de
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        linus.luessing@c0d3.blue, sven@narfation.org
Subject: Re: [PATCH 06/10] batman-adv: mcast: collect softif listeners from
 IP lists instead
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190627103938.7488-7-sw@simonwunderlich.de>
References: <20190627103938.7488-1-sw@simonwunderlich.de>
        <20190627103938.7488-7-sw@simonwunderlich.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 09:50:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>
Date: Thu, 27 Jun 2019 12:39:34 +0200

> +	in_dev = in_dev_get(dev);
> +	if (!in_dev)
> +		return 0;

Move this below the rcu_read_lock() and use __in_dev_get_rcu()
instead.

And then...

> +
> +	rcu_read_lock();
 ...
> +	rcu_read_unlock();
> +	in_dev_put(in_dev);

You can drop this in_dev_put() as well.

> +	in6_dev = in6_dev_get(dev);
> +	if (!in6_dev)
> +		return 0;
> +
> +	read_lock_bh(&in6_dev->lock);

Similarly here you can use __in6_dev_get().
