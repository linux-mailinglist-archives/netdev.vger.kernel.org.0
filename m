Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDFF411498F
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 23:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfLEW5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 17:57:41 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48832 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfLEW5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 17:57:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EEA57150B96D6;
        Thu,  5 Dec 2019 14:57:39 -0800 (PST)
Date:   Thu, 05 Dec 2019 14:57:39 -0800 (PST)
Message-Id: <20191205.145739.377846077558856039.davem@davemloft.net>
To:     sfr@canb.auug.org.au
Cc:     netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, sd@queasysnail.net
Subject: Re: linux-next: build warning after merge of the net tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191205084440.1d2bb0fa@canb.auug.org.au>
References: <20191205084440.1d2bb0fa@canb.auug.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Dec 2019 14:57:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 5 Dec 2019 08:44:40 +1100

> After merging the net tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c: In function 'mlx5e_tc_tun_create_header_ipv6':
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:332:20: warning: 'n' may be used uninitialized in this function [-Wmaybe-uninitialized]
>   332 |  struct neighbour *n;
>       |                    ^
> 
> Introduced by commit
> 
>   6c8991f41546 ("net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup")
> 
> It looks like a false positive.

I think it is a false positive as well.  It looks like the compiler
has trouble seeing through ptr error guards.  Actually, the top level
logic looks generically like this:


Old code:

int foo(int *byref)
{
	int err, val;

	err = something(&val);
	if (err < 0)
		return err;

	*byref = val;
	return 0;
}

...
	struct whatever *obj;
	
	err = foo(&obj);
	if (err < 0)
		return err;
	a = obj->something;

New code:

int foo(int *byref)
{
	struct otherthing *x;

	x = something(&val);
	if (IS_ERR(x))
		return PTR_ERR(x);
	*byref = bar(x);
	return 0;
}

...
	struct whatever *obj;

	err = foo(&obj);
	if (err < 0)
		return err;
	a = obj->somethng;

In the new code the compiler can only see that the return value in the
error case is non-zero, not necessarily that it is < 0 which is the
guard against uninitialized accesses of 'obj'.

It will satisfy this property, but through the various casts and
implicit demotions, this information is lost on the compiler.

My compiler didn't emit this warning FWIW.

gcc (GCC) 8.3.1 20190223 (Red Hat 8.3.1-2)

I'm unsure how to handle this, setting 'n' to explicitly be NULL
is bogus because the compiler now will think that a NULL deref
happens since the guard isn't guarding the existing assignment.
