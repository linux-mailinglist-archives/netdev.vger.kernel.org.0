Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9024B5FD6B
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 21:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfGDTYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 15:24:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52466 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfGDTYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 15:24:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E19E61433DB45;
        Thu,  4 Jul 2019 12:24:49 -0700 (PDT)
Date:   Thu, 04 Jul 2019 12:24:49 -0700 (PDT)
Message-Id: <20190704.122449.742393341056317443.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] ipv4: Fix NULL pointer dereference in
 ipv4_neigh_lookup()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190704162638.17913-1-idosch@idosch.org>
References: <20190704162638.17913-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jul 2019 12:24:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu,  4 Jul 2019 19:26:38 +0300

> Both ip_neigh_gw4() and ip_neigh_gw6() can return either a valid pointer
> or an error pointer, but the code currently checks that the pointer is
> not NULL.
 ...
> @@ -447,7 +447,7 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
>  		n = ip_neigh_gw4(dev, pkey);
>  	}
>  
> -	if (n && !refcount_inc_not_zero(&n->refcnt))
> +	if (!IS_ERR(n) && !refcount_inc_not_zero(&n->refcnt))
>  		n = NULL;
>  
>  	rcu_read_unlock_bh();

Don't the callers expect only non-error pointers?

All of this stuff is so confusing and fragile...
