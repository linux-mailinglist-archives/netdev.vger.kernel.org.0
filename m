Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B950B05C8
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 00:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbfIKWwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 18:52:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49924 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfIKWwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 18:52:49 -0400
Received: from localhost (unknown [88.214.186.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4EB0C154FCEC8;
        Wed, 11 Sep 2019 15:52:47 -0700 (PDT)
Date:   Thu, 12 Sep 2019 00:52:45 +0200 (CEST)
Message-Id: <20190912.005245.1148477077911617003.davem@davemloft.net>
To:     sbrivio@redhat.com
Cc:     gnault@redhat.com, ja@ssi.bg, nicolas.dichtel@6wind.com,
        dsahern@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ipv6: Don't use dst gateway directly in
 ip6_confirm_neigh()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <938b711c35ce3fa2b6f057cc23919e897a1e5c2b.1568061608.git.sbrivio@redhat.com>
References: <938b711c35ce3fa2b6f057cc23919e897a1e5c2b.1568061608.git.sbrivio@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 15:52:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>
Date: Mon,  9 Sep 2019 22:44:06 +0200

> This is the equivalent of commit 2c6b55f45d53 ("ipv6: fix neighbour
> resolution with raw socket") for ip6_confirm_neigh(): we can send a
> packet with MSG_CONFIRM on a raw socket for a connected route, so the
> gateway would be :: here, and we should pick the next hop using
> rt6_nexthop() instead.
> 
> This was found by code review and, to the best of my knowledge, doesn't
> actually fix a practical issue: the destination address from the packet
> is not considered while confirming a neighbour, as ip6_confirm_neigh()
> calls choose_neigh_daddr() without passing the packet, so there are no
> similar issues as the one fixed by said commit.
> 
> A possible source of issues with the existing implementation might come
> from the fact that, if we have a cached dst, we won't consider it,
> while rt6_nexthop() takes care of that. I might just not be creative
> enough to find a practical problem here: the only way to affect this
> with cached routes is to have one coming from an ICMPv6 redirect, but
> if the next hop is a directly connected host, there should be no
> topology for which a redirect applies here, and tests with redirected
> routes show no differences for MSG_CONFIRM (and MSG_PROBE) packets on
> raw sockets destined to a directly connected host.
> 
> However, directly using the dst gateway here is not consistent anymore
> with neighbour resolution, and, in general, as we want the next hop,
> using rt6_nexthop() looks like the only sane way to fetch it.
> 
> Reported-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Applied.
