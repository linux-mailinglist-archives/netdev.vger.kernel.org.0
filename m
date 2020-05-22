Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECA51DDF4D
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 07:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgEVF0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 01:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgEVF0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 01:26:23 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89634C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 22:26:23 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id n15so4480613pjt.4
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 22:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=v/pdDd52Cc1xqER29G+NUJd3ToovMfngacO3KT8uxxg=;
        b=E+eooJJC1G+DLhLEmpn+Z4RsnK6YgUK+78+x9E7BnUkJFPtPz7tt4dY+BCo6aNaXxd
         qK5hMzBs/Wgj0WUGxpvFJ/znK3yZvSsn6mjEFdYhyrMbgSt0LV9MKBPUB1BZyWZ/3GvO
         M0Z+MfJwV7fsgjRFarO1JqVM6us3Ve58ghGAA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=v/pdDd52Cc1xqER29G+NUJd3ToovMfngacO3KT8uxxg=;
        b=TWELCRFktAfa+vP/I+Tqda6ctrheV3RpEDEjMnYih0He63PCKo6hns/KK1UcKDdDB3
         XJpl9I0sIte+HEs8mZmhaks898h37sHGdrJJ4c2fv+0aWaDUoPvnryeK7xZpnHMj26Nv
         vY7Ow659xEgG8TwZ6vj0owQfStuo5HFHdr+TGYECgO2N/RXB+tVtUJBX9PfXlOz2ZH5U
         aD4lngNtjdh/VhsiQyF+cXR+XTZqa4PM0AjN42arqujXhJ+vvMxRyxrROhyLg0NgAFvR
         GYKvegqpm2xVlXTkZeNYYB3atPRnN4foZcb5DxFI6sK9T6TiqTpBPQzQqjgNwlLPIrW8
         hlSw==
X-Gm-Message-State: AOAM530oM3KKcG7/cx8O1bBpanN+FU91witYv6yyNFscaVJzh5e/CU2U
        EqAqhBhqiVneI1dQvv3Fa/qQPw==
X-Google-Smtp-Source: ABdhPJwU8AZIMKu95zGotuYDKKoniqcURINB6tAbiE9TmRw3UD4rRCuVexCzpvjXr3TFc96X5F7rbA==
X-Received: by 2002:a17:90b:110d:: with SMTP id gi13mr2333909pjb.131.1590125182797;
        Thu, 21 May 2020 22:26:22 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id a16sm5670310pff.41.2020.05.21.22.26.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 22:26:21 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next v4 0/5] Support for fdb ECMP nexthop groups
Date:   Thu, 21 May 2020 22:26:12 -0700
Message-Id: <1590125177-39176-1-git-send-email-roopa@cumulusnetworks.com>
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

v4 -
    - fix error path free_skb in vxlan_xmit_nh
    - fix atomic notifier initialization issue
      (Reported-by: kernel test robot <rong.a.chen@intel.com>)
      The reported error was easy to locate and fix, but i was not
      able to re-test with the robot reproducer script due to some
      other issues with running the script on my test system.

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

 drivers/net/vxlan.c                         | 340 ++++++++++++++++++++++------
 include/net/ip6_fib.h                       |   1 +
 include/net/netns/nexthop.h                 |   1 +
 include/net/nexthop.h                       |  44 ++++
 include/net/vxlan.h                         |  25 ++
 include/uapi/linux/neighbour.h              |   1 +
 include/uapi/linux/nexthop.h                |   3 +
 net/core/neighbour.c                        |   2 +
 net/ipv4/nexthop.c                          | 159 +++++++++++--
 net/ipv6/route.c                            |   5 +
 tools/testing/selftests/net/fib_nexthops.sh | 160 ++++++++++++-
 11 files changed, 651 insertions(+), 90 deletions(-)

-- 
2.1.4

