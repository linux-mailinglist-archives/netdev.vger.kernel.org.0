Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A4C458472
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 16:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237989AbhKUP2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 10:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237966AbhKUP2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 10:28:03 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC6BC061574
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 07:24:58 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id y196so12993144wmc.3
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 07:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J4cx2tGtwlAk6BUzdosGtBfEhk0ZjqHbyOc5Bps+Ah8=;
        b=NmZp0PozNvlL/qQ5/Ta6hCh2+YY/GNRhYJfXqMh+M/wzCJsM+0KZwDh9gmoyJVjcl9
         e13VQKaHXWP6bZvGKsy3aFPqxC41lhrDaJgTsAv05jDxJd0r6SmbFvGKwDHYFTkJ27CD
         HbEXAx8E1CzxK1nM7FjshUYj+14ALYWy3ENk3/kBgeZqzn6wT2fkij0rFXMPQa/9E+A+
         ZJ/UYHqVGrDRipGX0zFATwQyult/Sz+JsqI72UY0FB91t6Dea9WP9YPFvHqLYPYSV2iK
         lhV9sjvXebTw5KpJrZqhE0uXS8JaEVnDqksjeU05OZO7veSxdA+9c41xIdj4H4pFXwuJ
         0NPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J4cx2tGtwlAk6BUzdosGtBfEhk0ZjqHbyOc5Bps+Ah8=;
        b=rgU5/JWxcvJgzzVlzCCQtLutCGIt2uu/Tbj4Yhc86fp/h7Y9d2He2Nbwa+3eJqcq90
         nSTZM+tJ24wK+gV4xrzM8TnhK/fXOszTgSLwMyakk5PvwAWJneq/2va6K8q+oxxCLtZS
         nqAZXNjDcRDAEAjx7iOzZwTYVHUPYDWXFJL6Mpx2kGQAVON9oH0dd1PZo76r6Ic9xHB7
         dWAEDkuTnX2xWy+1fmCMAdJlfyEAv4zuEKYd8GkhPc/jz2O+IqwNioMQmIqcjB9zrfce
         S8nG6l386nGauT36bvf4Q6PIxaPChNJDPlE2E/Db5pjwX1zeO4ONL4nCTmZjaZWDYZer
         uz/A==
X-Gm-Message-State: AOAM533Gmp6mzTLA+E8KpWGjFqMH8HrM0JwkeVHXU1M3omK1C1CPUeJ2
        wMj71b8JnoSGIf1QYYV4Pglqf7ItbmjJxjXr
X-Google-Smtp-Source: ABdhPJzKkd+7pXtTKm+9so9kfh/ZHhTLpLdGT9qtXfCDo3rW0tbzB8vCcB1ExgPsmBnWHXfbOIW6SA==
X-Received: by 2002:a7b:cc96:: with SMTP id p22mr20500999wma.69.1637508296558;
        Sun, 21 Nov 2021 07:24:56 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m36sm7165559wms.25.2021.11.21.07.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 07:24:56 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 0/3] net: nexthop: fix refcount issues when replacing groups
Date:   Sun, 21 Nov 2021 17:24:50 +0200
Message-Id: <20211121152453.2580051-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This set fixes a refcount bug when replacing nexthop groups and
modifying routes. It is complex because the objects look valid when
debugging memory dumps, but we end up having refcount dependency between
unlinked objects which can never be released, so in turn they cannot
free their resources and refcounts. The problem happens because we can
have stale IPv6 per-cpu dsts in nexthops which were removed from a
group. Even though the IPv6 gen is bumped, the dsts won't be released
until traffic passes through them or the nexthop is freed, that can take
arbitrarily long time, and even worse we can create a scenario[1] where it
can never be released. The fix is to release the IPv6 per-cpu dsts of
replaced nexthops after an RCU grace period so no new ones can be
created. To do that we add a new IPv6 stub - fib6_nh_release_dsts, which
is used by the nexthop code only when necessary. We can further optimize
group replacement, but that is more suited for net-next as these patches
would have to be backported to stable releases.

Thanks,
 Nik

[1]
This info is also present in patch 02's commit message.
Initial state:
 $ ip nexthop list
  id 200 via 2002:db8::2 dev bridge.10 scope link onlink
  id 201 via 2002:db8::3 dev bridge scope link onlink
  id 203 group 201/200
 $ ip -6 route
  2001:db8::10 nhid 203 metric 1024 pref medium
     nexthop via 2002:db8::3 dev bridge weight 1 onlink
     nexthop via 2002:db8::2 dev bridge.10 weight 1 onlink

Create rt6_info through one of the multipath legs, e.g.:
 $ taskset -a -c 1  ./pkt_inj 24 bridge.10 2001:db8::10
 (pkt_inj is just a custom packet generator, nothing special)

Then remove that leg from the group by replace (let's assume it is id
200 in this case):
 $ ip nexthop replace id 203 group 201

Now remove the IPv6 route:
 $ ip -6 route del 2001:db8::10/128

The route won't be really deleted due to the stale rt6_info holding 1
refcnt in nexthop id 200.
At this point we have the following reference count dependency:
 (deleted) IPv6 route holds 1 reference over nhid 203
 nh 203 holds 1 ref over id 201
 nh 200 holds 1 ref over the net device and the route due to the stale
 rt6_info

Now to create circular dependency between nh 200 and the IPv6 route, and
also to get a reference over nh 200, restore nhid 200 in the group:
 $ ip nexthop replace id 203 group 201/200

And now we have a permanent circular dependncy because nhid 203 holds a
reference over nh 200 and 201, but the route holds a ref over nh 203 and
is deleted.

To trigger the bug just delete the group (nhid 203):
 $ ip nexthop del id 203

It won't really be deleted due to the IPv6 route dependency, and now we
have 2 unlinked and deleted objects that reference each other: the group
and the IPv6 route. Since the group drops the reference it holds over its
entries at free time (i.e. its own refcount needs to drop to 0) that will
never happen and we get a permanent ref on them, since one of the entries
holds a reference over the IPv6 route it will also never be released.

At this point the dependencies are:
 (deleted, only unlinked) IPv6 route holds reference over group nh 203
 (deleted, only unlinked) group nh 203 holds reference over nh 201 and 200
 nh 200 holds 1 ref over the net device and the route due to the stale
 rt6_info

This is the last point where it can be fixed by running traffic through
nh 200, and specifically through the same CPU so the rt6_info (dst) will
get released due to the IPv6 genid, that in turn will free the IPv6
route, which in turn will free the ref count over the group nh 203.

If nh 200 is deleted at this point, it will never be released due to the
ref from the unlinked group 203, it will only be unlinked:
 $ ip nexthop del id 200
 $ ip nexthop
 $

Now we can never release that stale rt6_info, we have IPv6 route with ref
over group nh 203, group nh 203 with ref over nh 200 and 201, nh 200 with
rt6_info (dst) with ref over the net device and the IPv6 route. All of
these objects are only unlinked, and cannot be released, thus they can't
release their ref counts.

 Message from syslogd@dev at Nov 19 14:04:10 ...
  kernel:[73501.828730] unregister_netdevice: waiting for bridge.10 to become free. Usage count = 3
 Message from syslogd@dev at Nov 19 14:04:20 ...
  kernel:[73512.068811] unregister_netdevice: waiting for bridge.10 to become free. Usage count = 3


Nikolay Aleksandrov (3):
  net: ipv6: add fib6_nh_release_dsts stub
  net: nexthop: release IPv6 per-cpu dsts when replacing a nexthop group
  selftests: net: fib_nexthops: add test for group refcount imbalance
    bug

 include/net/ip6_fib.h                       |  1 +
 include/net/ipv6_stubs.h                    |  1 +
 net/ipv4/nexthop.c                          | 25 ++++++++-
 net/ipv6/af_inet6.c                         |  1 +
 net/ipv6/route.c                            | 19 +++++++
 tools/testing/selftests/net/fib_nexthops.sh | 56 +++++++++++++++++++++
 6 files changed, 101 insertions(+), 2 deletions(-)

-- 
2.31.1

