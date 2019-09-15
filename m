Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC3ACB2F4E
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 11:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfIOJJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 05:09:01 -0400
Received: from ja.ssi.bg ([178.16.129.10]:53432 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbfIOJJB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Sep 2019 05:09:01 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x8F98roF018763;
        Sun, 15 Sep 2019 12:08:53 +0300
Date:   Sun, 15 Sep 2019 12:08:53 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     David Ahern <dsahern@gmail.com>
cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>
Subject: rt_uses_gateway was removed?
Message-ID: <alpine.LFD.2.21.1909151104060.2546@ja.home.ssi.bg>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

	Looks like I'm a bit late with the storm of changes
in the routing.

	By default, after allocation rt_uses_gateway was set to 0.
Later it can be set to 1 if nh_gw is not the final route target,
i.e. it is indirect GW and not a target on LAN (the RT_SCOPE_LINK
check in rt_set_nexthop).

	What remains hidden for the rt_uses_gateway semantic
is this code in rt_set_nexthop:

	if (unlikely(!cached)) {
		/* Routes we intend to cache in nexthop exception or
		 * FIB nexthop have the DST_NOCACHE bit clear.
		 * However, if we are unsuccessful at storing this
		 * route into the cache we really need to set it.
		 */
		if (!rt->rt_gateway)
			rt->rt_gateway = daddr;
		rt_add_uncached_list(rt);
	}

and this code in rt_bind_exception:

	if (!rt->rt_gateway)
		rt->rt_gateway = daddr;

	I.e. even if rt_uses_gateway remains 0, rt_gateway
can contain address, i.e. the target is on LAN and not
behind nh_gw.

	Now I see commit 1550c171935d wrongly changes that to
"If rt_gw_family is set it implies rt_uses_gateway.".
As result, we set rt_gw_family while rt_uses_gateway was 0
for above cases. Think about it in this way: there should be
a reason why we used rt_uses_gateway flag instead a simple
"rt_gateway != 0" check, right?

	Replacing rt->rt_gateway checks with rt_gw_family
checks is right but rt_uses_gateway checks should be put
back because they indicates the route has more hops to
target.

	As the problem is related to some FNHW and non-cached
routes, redirects, etc the easiest way to see the problem is with
'ip route get LOCAL_IP oif eth0' where extra 'via GW' line is
shown.

Regards

--
Julian Anastasov <ja@ssi.bg>
