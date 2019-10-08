Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAE0CCF8F8
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730530AbfJHL4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:56:53 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:42211 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730332AbfJHL4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:56:53 -0400
Received: by mail-pf1-f176.google.com with SMTP id q12so10627894pff.9
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 04:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uMT5k8HqcDBmMPYq0DVQCim5rhwcdyIlWTUIXEOJkqM=;
        b=NvY/5ctPxJpkqS95z9q+ytZYzcYBXSa4Xug+nE+Z1SKA4ppUScbaXntZykqnRqc4xK
         k6iRd3KkjAqWzGYdIXR85xGwJkE5loanMGL1Z3HiCJq+nUv73ZkG+SALT4ydBCrZxzHK
         4DgXqj+H1VLygf7+cR6SYgCtWaLvr4qBS+W5c+Kc9W6kjIWeN3GLeoq/fDOIFTNd/Pnn
         WmI6oNMApm1xB1W9TDriC7Z7b6R1F7bovu8LT8Ps/n+ys9vA/wBCS6DJseeWAwRicVKt
         fmejYIUJFhDd7R7kKyLjfu71u2f5baWb2lsICZaaHRjMBMm8FroC2RAqKm2POicklh1W
         XTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uMT5k8HqcDBmMPYq0DVQCim5rhwcdyIlWTUIXEOJkqM=;
        b=YEeK50Sny0HuUgJFDFxxS5ObKQgQkNzXksbSx/azLPumoru3JqEiExQAsi1EavxtI7
         r7e7gymOQ8K23Msi+sAoTJa+5UgwD7yyk290ooME6wvSzUH6SfNHwU/MlHoKzXXU4c2A
         76NFjbvrq6jkU9aADQ72YkQ18uJIafGyWrPg3FY/NuLOnljXwuWG8EQS/2HYrS3AIspC
         7k4ipda2f6PFCyu99LjOBDTvUaP5WzL2BxlaunJFza9gpaMTflSyY2PJ+cKD05aN/hJg
         FVMKg2gzgDZiKMuvti+R+J5WO8hpBJbzo6cPBBv47eiwVRPPEGqfLvw1++AJcZ7byFRF
         5E3w==
X-Gm-Message-State: APjAAAVGivcHWNnPem1dasyMg8JdIy/ZL/Zr8FLhFjxjM2aKClDdkVYT
        ZBObIJ6FUaNQdoG4k+hubS4=
X-Google-Smtp-Source: APXvYqyFv9xjwaiVQVWyKZ0w9rCP8RwB7t9StyFmqvS40/OSEQnNdewTRfmTpFQ7r2zuiVcVj9+Oyg==
X-Received: by 2002:a17:90a:8990:: with SMTP id v16mr5183771pjn.137.1570535812308;
        Tue, 08 Oct 2019 04:56:52 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id b14sm18149932pfi.95.2019.10.08.04.56.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:56:51 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 00/10] optimize openvswitch flow looking up
Date:   Tue,  8 Oct 2019 09:00:28 +0800
Message-Id: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
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

v1 -> v2:
1. use kfree_rcu instead of call_rcu.
2. add barrier when changing the ma->count.
3. change the ma->max to ma->count in flow_lookup. 

Tonghao Zhang (10):
  net: openvswitch: add flow-mask cache for performance
  net: openvswitch: convert mask list in mask array
  net: openvswitch: shrink the mask array if necessary
  net: openvswitch: optimize flow-mask cache hash collision
  net: openvswitch: optimize flow-mask looking up
  net: openvswitch: simplify the flow_hash
  net: openvswitch: add likely in flow_lookup
  net: openvswitch: fix possible memleak on destroy flow-table
  net: openvswitch: don't unlock mutex when changing the user_features
    fails
  net: openvswitch: simplify the ovs_dp_cmd_new

 net/openvswitch/datapath.c   |  65 +++++----
 net/openvswitch/flow.h       |   1 -
 net/openvswitch/flow_table.c | 315 +++++++++++++++++++++++++++++++++++++------
 net/openvswitch/flow_table.h |  19 ++-
 4 files changed, 328 insertions(+), 72 deletions(-)

-- 
1.8.3.1

