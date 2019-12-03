Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4293F10F523
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 03:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfLCCrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 21:47:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44208 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfLCCrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 21:47:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6364314F121E1;
        Mon,  2 Dec 2019 18:47:07 -0800 (PST)
Date:   Mon, 02 Dec 2019 18:47:04 -0800 (PST)
Message-Id: <20191202.184704.723174427717421022.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, ja@ssi.bg, marcelo.leitner@gmail.com,
        dsahern@gmail.com, edumazet@google.com
Subject: Re: [PATCHv2 net] ipv6/route: should not update neigh confirm time
 during PMTU update
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191203021137.26809-1-liuhangbin@gmail.com>
References: <20191122061919.26157-1-liuhangbin@gmail.com>
        <20191203021137.26809-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Dec 2019 18:47:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Tue,  3 Dec 2019 10:11:37 +0800

> Fix it by removing the dst_confirm_neigh() in __ip6_rt_update_pmtu() as
> there is no two-way communication during PMTU update.
> 
> v2: remove dst_confirm_neigh directly as David Miller pointed out.

That's not what I said.

I said that this interface is designed for situations where the neigh
update is appropriate, and that's what happens for most callers _except_
these tunnel cases.

The tunnel use is the exception and invoking the interface
inappropriately.

It is important to keep the neigh reachability fresh for TCP flows so
you cannot remove this dst_confirm_neigh() call.

Instead, make a new interface that the tunnel use cases can call into
to elide the neigh update.

Yes, this means you will have too update all of the tunnel callers
into these calls chains but that's the price we have to pay in this
situation unfortunately.
