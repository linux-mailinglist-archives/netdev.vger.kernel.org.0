Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D413A5D953
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfGCAkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:40:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45122 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfGCAkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:40:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3699F13EABC35;
        Tue,  2 Jul 2019 14:07:03 -0700 (PDT)
Date:   Tue, 02 Jul 2019 14:07:02 -0700 (PDT)
Message-Id: <20190702.140702.1594186047058268389.davem@davemloft.net>
To:     sbrivio@redhat.com
Cc:     dsahern@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] ipv4: Fix off-by-one in route dump counter without
 netlink strict checking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <74faa085e6af026f8b9f0d3cce8a94147781f257.1561830851.git.sbrivio@redhat.com>
References: <74faa085e6af026f8b9f0d3cce8a94147781f257.1561830851.git.sbrivio@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 14:07:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>
Date: Sat, 29 Jun 2019 19:55:08 +0200

> In commit ee28906fd7a1 ("ipv4: Dump route exceptions if requested") I
> added a counter of per-node dumped routes (including actual routes and
> exceptions), analogous to the existing counter for dumped nodes. Dumping
> exceptions means we need to also keep track of how many routes are dumped
> for each node: this would be just one route per node, without exceptions.
> 
> When netlink strict checking is not enabled, we dump both routes and
> exceptions at the same time: the RTM_F_CLONED flag is not used as a
> filter. In this case, the per-node counter 'i_fa' is incremented by one
> to track the single dumped route, then also incremented by one for each
> exception dumped, and then stored as netlink callback argument as skip
> counter, 's_fa', to be used when a partial dump operation restarts.
> 
> The per-node counter needs to be increased by one also when we skip a
> route (exception) due to a previous non-zero skip counter, because it
> needs to match the existing skip counter, if we are dumping both routes
> and exceptions. I missed this, and only incremented the counter, for
> regular routes, if the previous skip counter was zero. This means that,
> in case of a mixed dump, partial dump operations after the first one
> will start with a mismatching skip counter value, one less than expected.
> 
> This means in turn that the first exception for a given node is skipped
> every time a partial dump operation restarts, if netlink strict checking
> is not enabled (iproute < 5.0).
> 
> It turns out I didn't repeat the test in its final version, commit
> de755a85130e ("selftests: pmtu: Introduce list_flush_ipv4_exception test
> case"), which also counts the number of route exceptions returned, with
> iproute2 versions < 5.0 -- I was instead using the equivalent of the IPv6
> test as it was before commit b964641e9925 ("selftests: pmtu: Make
> list_flush_ipv6_exception test more demanding").
> 
> Always increment the per-node counter by one if we previously dumped
> a regular route, so that it matches the current skip counter.
> 
> Fixes: ee28906fd7a1 ("ipv4: Dump route exceptions if requested")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Applied to net-next, thanks for fixing this.
