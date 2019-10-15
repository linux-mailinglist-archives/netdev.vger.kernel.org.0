Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5F5D917F
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405185AbfJPMud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:50:33 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38694 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbfJPMub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 08:50:31 -0400
Received: by mail-pg1-f196.google.com with SMTP id w3so7332050pgt.5
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 05:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2C2OrMiiuTVKe2fm9lr915Cda6TbBh7c/NsCg4UbzoY=;
        b=MtmkFHMlZx+yeHSpiL5jqg6vvsclRok5mh6R5RDdadqe9Yxtk2ExVisFDDTwMvjcAa
         1ynWlSysHckn/8GDc04OwfVYRjtzvMLywNUlCQtbCMlT09ajPiwgO3rlPUtzYCbHaPWE
         is14qYv2tNh1iaFQ/4eCqrIhq7Pe+c9HayF3xl38Wlfy9aATRaLYJ5UQd0jKvSazjZD8
         /Bin8yeozHxzUr3r3kD7FfTug1lqcB1y4EppD1F7xq11C3gTKW1WuddH6h2AaRJE16aO
         LWlSuQNPfENJXaBUywyoraIViRp/W49VWJOflFQZvu4gwglnHXFXrK1XsknGzqPhYLSQ
         tTpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2C2OrMiiuTVKe2fm9lr915Cda6TbBh7c/NsCg4UbzoY=;
        b=DLpxQjE5ZWUaOKmuQOAEAonVFzWdt/uDDviFyI10cj46hrtgT+16enr0Tob2UwX7wJ
         hjI1nJlhJ1WzgDSQL8hF9fLxcQftY3b4hqYt8AlVrKtPBK/4t39jia3PupBS4aEVTDS7
         N0mrDmeN6JnGdTl7TqaS6AaKDcTagGlalYH6wjbdzMscveOSp9JAlNZttlXOMfLPNE7h
         kMCbJtdEf7Lp42hZSd+6m6IOJeOBDSSuJnp2Pa7ohcvBN5WViDz8RYfYfly/iikkhcs5
         MafwD4+zvfXY4KYNFZBDKgg5b2tEY2s1jpozXnW4pjsXeZF0JzZ/vDvUp0bDjdvwqkK8
         W6zw==
X-Gm-Message-State: APjAAAXIqfTp8OEWH4O8kRYg2Zr1myYwPmP92a4LA5RAqVfHTR4v90Zi
        rn5Cw/MCSUog9rl3cLCsrRuHvs+f
X-Google-Smtp-Source: APXvYqwtIgFU7UArPsKSXKkJSMIsU/UiuSPPP+ywUHltbqohhRfmTuOh0Q5kc2l7Sz4slkYDLnHhvw==
X-Received: by 2002:a17:90a:ba83:: with SMTP id t3mr4767791pjr.139.1571230231040;
        Wed, 16 Oct 2019 05:50:31 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d19sm2747339pjz.5.2019.10.16.05.50.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 05:50:30 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 00/10] optimize openvswitch flow looking up
Date:   Tue, 15 Oct 2019 18:30:30 +0800
Message-Id: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
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

v3->v4:
access ma->count with READ_ONCE/WRITE_ONCE API. More information,
see patch 5 comments. 

v2->v3:
update ma point when realloc mask_array in patch 5.

v1->v2:
use kfree_rcu instead of call_rcu

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

 net/openvswitch/datapath.c   |  65 +++++----
 net/openvswitch/flow.h       |   1 -
 net/openvswitch/flow_table.c | 316 +++++++++++++++++++++++++++++++++++++------
 net/openvswitch/flow_table.h |  19 ++-
 4 files changed, 329 insertions(+), 72 deletions(-)

-- 
1.8.3.1

