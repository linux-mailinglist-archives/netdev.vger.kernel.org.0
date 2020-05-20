Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4EB1DBCB6
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 20:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgETSXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 14:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbgETSXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 14:23:16 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87924C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:23:16 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p30so1814157pgl.11
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ZA5QRiyt0oxIJrH+C83tYmZFgZXgf/+MN/USoNN7hj8=;
        b=P/VBukI54ixBlmhrHsmwA0mN3At5yGvCV2nwX4GazNaMugEL9IF5jfvgqKvwdAMWWZ
         /gRYXDBU+Lq7UfoeQcCbWd6LgTW7N9Oo0VaPkWRPYn1bKKXgHpk3SjrRlTewIKQqYWFe
         TZU9iP63NJ5Yk/2q0kDEtVmJmZMV03g0GvIQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZA5QRiyt0oxIJrH+C83tYmZFgZXgf/+MN/USoNN7hj8=;
        b=aCuLO4FKOFDCY+ZUtnFadTXqQIafU6bjjZTR1yBaGiksYSybA3HOAZZ0Pl73X3j68Y
         Z+TfgOZKL2unLr5gmVX2AJk4TxTSPOM/wZTC8sq9WrByiJYDDv5EiT/M9+6G7ypJycJ0
         EOHKxS9gPo+dR3CscUntVD9fQbQgQa9kVR7a9cxUsHKj7cHghTgEVWt/nXfsuSS2xuw3
         Xj/Llg3AM6CFdAnZVZqmp/Ti3hUgNYhRtZ8iiRgRboRzQQRc0ymTqeyrdvI0h77QLO0K
         jVW+2eZFUYTqMvs5Q+1KZMl7zo/Cc7QQtxkClbSPvU3k64YtPA9uyjgi96l8uJ7P+ZXG
         Uukg==
X-Gm-Message-State: AOAM5325YIoRvvS1e1cXT1tOUkXpnIikP6riGKs3ZyUE/SwkfOcVbmlR
        7phh0JJfufFMqDrxfVLlp4ogIA==
X-Google-Smtp-Source: ABdhPJxvJp4p8WqylJGZMWaWctV5ORvhQOFs74+8XHRS1jawzeQeTY0y8t0RCkKzSxJrmlFUIR3wag==
X-Received: by 2002:a63:6c8:: with SMTP id 191mr5168141pgg.22.1589998995973;
        Wed, 20 May 2020 11:23:15 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id d184sm2490238pfc.130.2020.05.20.11.23.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 May 2020 11:23:15 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next v3 0/5] Support for fdb ECMP nexthop groups
Date:   Wed, 20 May 2020 11:23:06 -0700
Message-Id: <1589998991-40120-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

This series introduces ecmp nexthops and nexthop groups
for mac fdb entries. In subsequent patches this is used
by the vxlan driver fdb entries. The use case is
E-VPN multihoming [1,2,3] which requires bridged vxlan traffic
to be load balanced to remote switches (vteps) belonging to
the same multi-homed ethernet segment (This is analogous to
a multi-homed LAG but over vxlan).

Changes include new nexthop flag NHA_FDB for nexthops
referenced by fdb entries. These nexthops only have ip.
The patches make sure that routes dont reference such nexthops.

example:
$ip nexthop add id 12 via 172.16.1.2 fdb
$ip nexthop add id 13 via 172.16.1.3 fdb
$ip nexthop add id 102 group 12/13 fdb

$bridge fdb add 02:02:00:00:00:13 dev vxlan1000 nhid 101 self

[1] E-VPN https://tools.ietf.org/html/rfc7432
[2] E-VPN VxLAN: https://tools.ietf.org/html/rfc8365
[3] LPC talk with mention of nexthop groups for L2 ecmp
http://vger.kernel.org/lpc_net2018_talks/scaling_bridge_fdb_database_slidesV3.pdf

v3 - fix wording in selftest print as pointed out by davidA

v2 -
	- dropped nikolays fixes for nexthop multipath null pointer deref
	  (he will send those separately)
	- added negative tests for route add with fdb nexthop + a few more
	- Fixes for a few  fdb replace conditions found during more testing
	- Moved to rcu_dereference_rtnl in vxlan_fdb_info and consolidate rcu
	  dereferences
	- Fixes to build failures Reported-by: kbuild test robot <lkp@intel.com>
	- DavidA, I am going to send a separate patch for the neighbor code validation
	  for NDA_NH_ID if thats ok.

Roopa Prabhu (5):
  nexthop: support for fdb ecmp nexthops
  vxlan: ecmp support for mac fdb entries
  nexthop: add support for notifiers
  vxlan: support for nexthop notifiers
  selftests: net: add fdb nexthop tests

 drivers/net/vxlan.c                         | 334 ++++++++++++++++++++++------
 include/net/ip6_fib.h                       |   1 +
 include/net/netns/nexthop.h                 |   1 +
 include/net/nexthop.h                       |  44 ++++
 include/net/vxlan.h                         |  25 +++
 include/uapi/linux/neighbour.h              |   1 +
 include/uapi/linux/nexthop.h                |   3 +
 net/core/neighbour.c                        |   2 +
 net/ipv4/nexthop.c                          | 158 ++++++++++---
 net/ipv6/route.c                            |   5 +
 tools/testing/selftests/net/fib_nexthops.sh | 160 ++++++++++++-
 11 files changed, 644 insertions(+), 90 deletions(-)

-- 
2.1.4

