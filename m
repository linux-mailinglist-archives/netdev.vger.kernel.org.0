Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA671F4BE3
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 05:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgFJDt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 23:49:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgFJDtz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 23:49:55 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F500206F4;
        Wed, 10 Jun 2020 03:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591760995;
        bh=GytVTXC7LuaYpCdTfzk76j9G+F2gwP88nwMGjL3/+KY=;
        h=From:To:Cc:Subject:Date:From;
        b=X/oEwkbH5g03tPLUbIUDDWLvH6e5eOhY7JeOvEtvPQg4/tbEsimYhjzP7aPjE/k1b
         lJW65Dxd7lVEWqIshZvmIEF/nyWLP4fWRDIIYH3wEJkyx4X+sw6rye6lNFnpuhnsPh
         4mSnRvQdmcBcKaaF5MgFkIfoqsgz9chrxkK2y2UY=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, assogba.emery@gmail.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH RFC net-next 0/8] nexthop: Add support for active-backup nexthop type
Date:   Tue,  9 Jun 2020 21:49:45 -0600
Message-Id: <20200610034953.28861-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set adds support for a new nexthop group - active-backup.
The intent is that the group describes a primary nexthop with a backup
option if the primary is not available. Since nexthop code removes
entries on carrier or admin down this really means the backup applies
when the neighbor entry for the active becomes invalid. In that case,
the lookup atomically switches to use the backup. I mentioned this use
case at LPC2019[0] as a follow on use case for the nexthop code.

The first 6 patches refactor existing code to get ready for a new
group type. The a-b group is added in patch 7 with selftests in
patch 8.

[0] https://linuxplumbersconf.org/event/4/contributions/434/attachments/251/436/nexthop-objects-talk.pdf

David Ahern (8):
  nexthop: Rename nexthop_free_mpath
  nexthop: Refactor nexthop_select_path
  nexthop: Refactor nexthop_for_each_fib6_nh
  nexthop: Move nexthop_get_nhc_lookup to nexthop.c
  nexthop: Move nexthop_uses_dev to nexthop.c
  nexthop: Add primary_only argument to nexthop_for_each_fib6_nh
  nexthop: Add support for active-backup nexthop type
  selftests: Add active-backup nexthop tests

 include/net/nexthop.h                       | 106 +++---
 include/uapi/linux/nexthop.h                |   1 +
 net/ipv4/fib_semantics.c                    |   6 +-
 net/ipv4/nexthop.c                          | 356 +++++++++++++++++---
 net/ipv6/ip6_fib.c                          |   4 +-
 net/ipv6/route.c                            |  37 +-
 tools/testing/selftests/net/fib_nexthops.sh | 334 +++++++++++++++++-
 7 files changed, 713 insertions(+), 131 deletions(-)

-- 
2.21.1 (Apple Git-122.3)

