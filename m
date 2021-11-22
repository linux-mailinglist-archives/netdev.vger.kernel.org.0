Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5042F459118
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239037AbhKVPS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhKVPS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:18:28 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1C8C061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 07:15:21 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id z5so78622509edd.3
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 07:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=88LHCR+PjO2INkYg6VrTl9B0cxBHATNNu+7/7SBwxmU=;
        b=RSuRuywV+As+UE3lo8JZJy4WWj3ChHRMIumrjQmFH90j36Uvbq+LRio16xsxrKtXzR
         bZo+wa32t3Vgy8ugjdYpYdY+3q9gzXoFT6j0bIIPEO6RYWFrUtH6LhxeUMjphQhn7fex
         9RQ8fgS2Uer1vpP+G9Gy3M4+iLd5ZCWXubHJQIyDMGcG4IOkuWZ0fIbLbsrxr56dKYto
         f3fS7DB1KFeqLcuGzC77d6xHZ7SyzQW1zRfaVy5P7NQD/zUY33ArEvz70Op1Dccz/9Ir
         +jDYxgZxWCQ2NhMwEwNkOrTE1/fcyxqxZ/6qbZAsNRvnh/LoSFGYD6hWMJy1zZH+WEpn
         DIFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=88LHCR+PjO2INkYg6VrTl9B0cxBHATNNu+7/7SBwxmU=;
        b=n2NUzVhtsmyIWOArAn1gp3xPAQfVwR5CH4JpqOSxI0gHTJzd6qgYOUdWmf6dSKWB2O
         giS6jDfblNBn9tLZ4aAodf7HQSv5REal1ubqp6i+J+InZxqawMeP03os6bP+j4X0NrG4
         LDsfVry3EMf1/3aJ78tuHorzMOVDvcWKTgkR4x62YhxZkrwR5iBGWEOBu6yKVOYHu5dv
         UG9K3aazspMjm2N9QIlByxzXmRldxHNLuA0YwSNPqTOK+qg5o1zl5J/5hHyAJhPKgBtw
         cXm9mmrhQ3nw+Xcrl5TxObVL08zFJJmHDiGx047qQzMP6/eGy643dxyS74lScNfqmG/N
         K20Q==
X-Gm-Message-State: AOAM532JjPQ8Ve/LOXhTk3SbtVXIJ7FuhbH7xfLXXO4XAXlxpyfETWBp
        UQWLG9TlX1n93Moai3h8505YwvpD/xX2tTgE
X-Google-Smtp-Source: ABdhPJxVy0l/H9KCuRumnHQmTDDxRoW0yN1H8KkOD9xTnXa8eck1nVkY4QY9TDxcDQ1jJek/jtA4Xg==
X-Received: by 2002:a17:907:d0b:: with SMTP id gn11mr41560504ejc.355.1637594119594;
        Mon, 22 Nov 2021 07:15:19 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id qb21sm3906904ejc.78.2021.11.22.07.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 07:15:19 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net v2 0/3] net: nexthop: fix refcount issues when replacing groups
Date:   Mon, 22 Nov 2021 17:15:11 +0200
Message-Id: <20211122151514.2813935-1-razor@blackwall.org>
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

v2: patch 02: update commit msg
    patch 03: check for mausezahn before testing and make a few comments
              more verbose

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
 net/ipv4/nexthop.c                          | 25 +++++++-
 net/ipv6/af_inet6.c                         |  1 +
 net/ipv6/route.c                            | 19 +++++++
 tools/testing/selftests/net/fib_nexthops.sh | 63 +++++++++++++++++++++
 6 files changed, 108 insertions(+), 2 deletions(-)

-- 
2.31.1

