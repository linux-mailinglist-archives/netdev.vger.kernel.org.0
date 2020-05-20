Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E7F1DA944
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 06:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgETEdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 00:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgETEdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 00:33:39 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6EAC061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 21:33:39 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k19so807542pll.9
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 21:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=OxZYT6/RX2Pd2SmGI+sDG7caZXi1dvGr9Te3QhIuHdA=;
        b=hQ52jekC9UfkKNhtdPgz+pRWnMLYXB3MQXRHo5R7y+I0fcfnl5LRkfF8eC6FLVmzMJ
         Rj+5LcyJb/V3s6p2p1WzLLlTuVJZ1p7L8vHsnjLC5tK4wAUbF/1KVZpyXV2d59Kc65Nj
         0SXQWl7Oy6QuNQkv7WdNd8IqgzKU5kSMy6d90=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OxZYT6/RX2Pd2SmGI+sDG7caZXi1dvGr9Te3QhIuHdA=;
        b=GYYJZ6Oi8C7Vh/0xhiMLpsxk8Aglvw5XP4hWjUYzdC9ggEOHiw9aJ0tiWRObVr/JRB
         GZ/3enm/6pbtSOA/6DHNYsyDXF1CQiw1S0jmuypaQAV245Zs6z3dM9UPJdV/RTwrkQSY
         8KYDfDOUKL946MqCuCIcOAPVcNd1Vq4uncWiJstMSBUEDeTaA2KTZ6NwZm3ivTMZvxLU
         +atYwgEZDuSWLIRBTZFn8bERugNDuN1eMKvEbj6PLU+wKslzKyGICH3W1Loj0BwzoVHN
         Py2Fi5ak9TyHSyFpMKMFQmcehsnqT35QzWI6kMdPhKJhHs/NIjjaml6U8WgWe7UrNs/R
         sdOg==
X-Gm-Message-State: AOAM532+DXObvGYDQ+6INxRGIEmUu+zW3U++w9cu4rK3Nr48AYUCv9Li
        EWkajfBEPgw8UQ1ftAOgCbZnxg==
X-Google-Smtp-Source: ABdhPJzmS8jll+sesEn0oNpC9kk4abMqL2GvAUgoWVTF99vyoG+kh5bKKXtn24a24bZwwywb4ytNpw==
X-Received: by 2002:a17:90a:344c:: with SMTP id o70mr3265672pjb.23.1589949219065;
        Tue, 19 May 2020 21:33:39 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id g17sm753250pgg.43.2020.05.19.21.33.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 May 2020 21:33:38 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next v2 0/5] Support for fdb ECMP nexthop groups
Date:   Tue, 19 May 2020 21:33:29 -0700
Message-Id: <1589949214-14711-1-git-send-email-roopa@cumulusnetworks.com>
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

v2 -
	- dropped nikolays fixes for nexthop multipath null pointer deref
	  (he will send those separately)
	- Fixes for a few fdb replace conditions found during more testing today
          (mostly check for more error cases)
	- address review comments from davidA and nikolay
	- added negative tests for route add with fdb nexthop + a few more
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

