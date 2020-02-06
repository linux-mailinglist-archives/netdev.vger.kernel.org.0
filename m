Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50F21544A7
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 14:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgBFNND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 08:13:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59360 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbgBFNND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 08:13:03 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BA50514C76F98;
        Thu,  6 Feb 2020 05:13:01 -0800 (PST)
Date:   Thu, 06 Feb 2020 14:13:00 +0100 (CET)
Message-Id: <20200206.141300.1752448469848126511.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, maximmi@mellanox.com
Subject: Re: [PATCH net] ipv6/addrconf: fix potential NULL deref in
 inet6_set_link_af()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200205165544.242623-1-edumazet@google.com>
References: <20200205165544.242623-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Feb 2020 05:13:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed,  5 Feb 2020 08:55:44 -0800

> __in6_dev_get(dev) called from inet6_set_link_af() can return NULL.
> 
> The needed check has been recently removed, let's add it back.

I am having trouble understanding this one.

When we have a do_setlink operation the flow is that we first validate
the AFs and then invoke setlink operations after that validation.

do_setlink() {
 ..
	err = validate_linkmsg(dev, tb);
	if (err < 0)
		return err;
 ..
	if (tb[IFLA_AF_SPEC]) {
 ...
			err = af_ops->set_link_af(dev, af);
			if (err < 0) {
				rcu_read_unlock();
				goto errout;
			}

By definition, we only get to ->set_link_af() if there is an
IFLA_AF_SPEC nested attribute and if we look at the validation
performed by validate_linkmsg() it goes:

	if (tb[IFLA_AF_SPEC]) {
 ...
			if (af_ops->validate_link_af) {
				err = af_ops->validate_link_af(dev, af);
 ...

And validate_link_af in net/ipv6/addrconf.c clearly does the
following:

static int inet6_validate_link_af(const struct net_device *dev,
				  const struct nlattr *nla)
 ...
	if (dev) {
		idev = __in6_dev_get(dev);
		if (!idev)
			return -EAFNOSUPPORT;
	}
 ...

It checks the idev and makes sure it is not-NULL.

I therefore cannot find a path by which we arrive at inet6_set_link_af
with a NULL idev.  The above validation code should trap it.

Please explain.

Thank you.
