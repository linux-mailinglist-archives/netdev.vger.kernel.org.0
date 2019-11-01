Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFF2EC497
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 15:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfKAOYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 10:24:06 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45465 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfKAOYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 10:24:05 -0400
Received: by mail-pf1-f193.google.com with SMTP id z4so1152072pfn.12
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 07:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+tWBk8RYlbebI5rMcKZiOfpg14oYGTQBvwooaX0n6ck=;
        b=hjBRP1ilKDsh/t2GeIa/BAcS85bNhG1VQYYMTDVN0ajpBNHFQm87OrIPhvU/yYToa3
         o0HlW4J4JuXFcIlYB6aE3lv8eI4FoCwlTL/w6eqRC3zCeXXo70TYoSEe0HwR3TbHB6lJ
         gPvKBLvFscNAgP8Vdj5El3kpyNLWsBiTDiQ9P38U3yyt+ejvq48KLxEqAFnGN+zDsdfn
         E+oQlvoRP+9TUgBmYtOtQ05UmH8IsBEE0hVGBewxyOxZQdqiQbhk37yYISBKYnHFoZuB
         FkVFv22a2lzmlKnPrahVvtrnePBnC+7C4WthmB7vlUFgz12kXg1+9czqF/yMk+StzEA8
         fkKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+tWBk8RYlbebI5rMcKZiOfpg14oYGTQBvwooaX0n6ck=;
        b=lSMz2KovuIXKxLL6VwmsPEigkFEnmKkpiM27sy8HDNJBZ9iygsSUDyHR2ysW8liMXZ
         KkooYEc/snRaHm6xanwo1E1TK70fgKt+MkNotR/zBXx+F617RTDmoWvHvlNCXH88BQp1
         vd3rf3sFS42pIrto/5Xdz6W28Mo1ybb/zSbnAjgUEdUeGuW0zYJBQ9xXSpfdxA8dfSms
         uksl83I/j31+wXkvIN0vizpzXSmKbsecifS+En8/yC22gPR1rEBk1ZJOCYM3YvJK4/Xq
         cliOkzbJopsfUS5AWHHMAPx7tTCiaJP3zLn5gzOLgeUB/66YRKWRzwcwp5OkkNl09WTx
         YIXQ==
X-Gm-Message-State: APjAAAXFl9IlSa01yH0euHUUiQ7c0F5OF6aRFVCyWcHySooc6gTqZiNh
        pwdwnd6q/5dOAIX+PBuIBI8=
X-Google-Smtp-Source: APXvYqwJ3AxUDk25vKFFRR/9L30wBpDaHRtxtVMvy/nzsry8eiC/w1UyYWMfOO7H7QfH8ZcCIPQJmw==
X-Received: by 2002:a63:5f54:: with SMTP id t81mr13510293pgb.20.1572618244996;
        Fri, 01 Nov 2019 07:24:04 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([1.203.173.208])
        by smtp.gmail.com with ESMTPSA id c12sm8296499pfp.67.2019.11.01.07.24.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Nov 2019 07:24:03 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v6 00/10] optimize openvswitch flow looking up
Date:   Fri,  1 Nov 2019 22:23:44 +0800
Message-Id: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This series patch optimize openvswitch for performance or simplify
codes.

Patch 1, 2, 4: Port Pravin B Shelar patches to
linux upstream with little changes.

Patch 5, 6, 7: Optimize the flow looking up and
simplify the flow hash.

Patch 8, 9: are bugfix.

The performance test is on Intel Xeon E5-2630 v4.
The test topology is show as below:

+-----------------------------------+
|   +---------------------------+   |
|   | eth0   ovs-switch    eth1 |   | Host0
|   +---------------------------+   |
+-----------------------------------+
      ^                       |
      |                       |
      |                       |
      |                       |
      |                       v
+-----+----+             +----+-----+
| netperf  | Host1       | netserver| Host2
+----------+             +----------+

We use netperf send the 64B packets, and insert 255+ flow-mask:
$ ovs-dpctl add-flow ovs-switch "in_port(1),eth(dst=00:01:00:00:00:00/ff:ff:ff:ff:ff:01),eth_type(0x0800),ipv4(frag=no)" 2
...
$ ovs-dpctl add-flow ovs-switch "in_port(1),eth(dst=00:ff:00:00:00:00/ff:ff:ff:ff:ff:ff),eth_type(0x0800),ipv4(frag=no)" 2
$
$ netperf -t UDP_STREAM -H 2.2.2.200 -l 40 -- -m 18

* Without series patch, throughput 8.28Mbps
* With series patch, throughput 46.05Mbps

v6:
some coding style fixes

v5:
rewrite patch 8, release flow-mask when freeing flow

v4:
access ma->count with READ_ONCE/WRITE_ONCE API. More information,
see patch 5 comments. 

v3:
update ma point when realloc mask_array in patch 5

v2:
simplify codes. e.g. use kfree_rcu instead of call_rcu

Tonghao Zhang (10):
  net: openvswitch: add flow-mask cache for performance
  net: openvswitch: convert mask list in mask array
  net: openvswitch: shrink the mask array if necessary
  net: openvswitch: optimize flow mask cache hash collision
  net: openvswitch: optimize flow-mask looking up
  net: openvswitch: simplify the flow_hash
  net: openvswitch: add likely in flow_lookup
  net: openvswitch: fix possible memleak on destroy flow-table
  net: openvswitch: don't unlock mutex when changing the user_features
    fails
  net: openvswitch: simplify the ovs_dp_cmd_new

 net/openvswitch/datapath.c   |  65 +++++---
 net/openvswitch/flow.h       |   1 -
 net/openvswitch/flow_table.c | 381 ++++++++++++++++++++++++++++++++++---------
 net/openvswitch/flow_table.h |  19 ++-
 4 files changed, 361 insertions(+), 105 deletions(-)

-- 
1.8.3.1

