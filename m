Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C631E24D2
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbgEZPBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgEZPBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 11:01:16 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80EE020723;
        Tue, 26 May 2020 15:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590505275;
        bh=KpAMo4QkQs9iyJKvD5yEc1wrgmerW3nbtoeJRE/zhSE=;
        h=From:To:Cc:Subject:Date:From;
        b=f2/bPX8XD+g1qLKvz/x5q928GSyXqP8lxURanZgp7OYcEW1jRVwqcQAj2x5DfqzXy
         Kgbc+N/R2JFV5rXe7tnnISpqpRGXdsvlpZ0YRKqgiSeo6eZ5Sl4tbFOJuPs98q/EyZ
         EnAsl4TL0G6+ODU+uqkkRS+8Ej/+Hr61DNYVY3TQ=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nikolay@cumulusnetworks.com,
        David Ahern <dahern@digitalocean.com>
Subject: [PATCH net 0/5] nexthops: Fix 2 fundamental flaws with nexthop groups
Date:   Tue, 26 May 2020 09:01:09 -0600
Message-Id: <20200526150114.41687-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Nik's torture tests have exposed 2 fundamental mistakes with the initial
nexthop code for groups. First, the nexthops entries and num_nh in the
nh_grp struct should not be modified once the struct is set under rcu.
Doing so has major affects on the datapath seeing valid nexthop entries.

Second, the helpers in the header file were convenient for not repeating
code, but they cause datapath walks to potentially see 2 different group
structs after an rcu replace, disrupting a walk of the path objects.
This second problem applies solely to IPv4 as I re-used too much of the
existing code in walking legs of a multipath route.

Patches 1 is refactoring change to simplify the overhead of reviewing and
understanding the change in patch 2 which fixes the update of nexthop
groups when a compnent leg is removed.

Patches 3-5 address the second problem. Patch 3 inlines the multipath
check such that the mpath lookup and subsequent calls all use the same
nh_grp struct. Patches 4 and 5 fix datapath uses of fib_info_num_path
with iterative calls to fib_info_nhc.

fib_info_num_path can be used in control plane path in a 'for loop' with
subsequent fib_info_nhc calls to get each leg since the nh_grp struct is
only changed while holding the rtnl; the combination can not be used in
the data plane with external nexthops as it involves repeated dereferences
of nh_grp struct which can change between calls.

Similarly, nexthop_is_multipath can be used for branching decisions in
the datapath since the nexthop type can not be changed (a group can not
be converted to standalone and vice versa).

Patch set developed in coordination with Nikolay Aleksandrov. He did a
lot of work creating a good reproducer, discussing options to fix it
and testing iterations.

I have adapted Nik's commands into additional tests in the nexthops
selftest script which I will send against -next.

David Ahern (4):
  nexthops: Move code from remove_nexthop_from_groups to
    remove_nh_grp_entry
  nexthop: Expand nexthop_is_multipath in a few places
  ipv4: Refactor nhc evaluation in fib_table_lookup
  ipv4: nexthop version of fib_info_nh_uses_dev

Nikolay Aleksandrov (1):
  nexthops: don't modify published nexthop groups

 include/net/ip_fib.h    |  12 +++++
 include/net/nexthop.h   | 100 ++++++++++++++++++++++++++++++++-------
 net/ipv4/fib_frontend.c |  19 ++++----
 net/ipv4/fib_trie.c     |  51 ++++++++++++++------
 net/ipv4/nexthop.c      | 102 +++++++++++++++++++++++++---------------
 5 files changed, 205 insertions(+), 79 deletions(-)

-- 
2.21.1 (Apple Git-122.3)

