Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 218FCBEDB6
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 10:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfIZIrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 04:47:20 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:43308 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfIZIrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 04:47:20 -0400
Received: by mail-pg1-f178.google.com with SMTP id v27so1168432pgk.10
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 01:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hneh49/VTYNgeMJTUheOxi0GA/yx1CJCsYcZZK/T7Bk=;
        b=MrNSt433kRy37Yr55T3n+0pR5od8LYccbHENa4byYjCD+wCvipi1fWAZt8cwrXCdo9
         gU/zTBnAVlhdVoPpseBjESEUvI3ycgkzkrUt1bfV5rlwkbTeoUTJqh6hAkKfPSuZdsnO
         IDu6XOiR2PIeXv9McT3IBwI+gJ09DD+WQbJIPjRqNNuWOU6Vxm+BCGJDMb3YSWSOhwjQ
         Eds8i9xhm396lC0dXpSIlTUyL9JK+Hfd7w/ytl+GFZ63UHLmScZKnp1RjpHX735PfzH5
         QQay8vH63Cn+915PXjwWwiHJ0m5DIEcV7/TqGr+VqOB44nPRA/56yyKLETwqeBMgOJVQ
         E74w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hneh49/VTYNgeMJTUheOxi0GA/yx1CJCsYcZZK/T7Bk=;
        b=CNQPIo75G6HRjcCPaRQj+eREVgODdikXBhDSSE5C+nCE0v/AwXYIqSTvY+CuoozPc8
         exm35aZD6zqSwBkvRKG3KGfEvPzPAurXfy/1aVQrw0r0Fg6DiBhV146hJxNmiUHWjqH8
         TeevaO/1jbgPeu1mKyw2EnnzJ+5zl2Y6g8wj24xo0OFLnatJiy3n7rFH22Vp8RWDLVCW
         5/DAUYlJrlASH8L93IBFCaQ2nPeBC5B9RD54GonpruBOsXJNcabnDfklMs+lMJl9KHYb
         pVkTZWHLRWb49SsKWkbMYsAtd0ArDJP1hLSZpoU276sXDPORjkzqULE3nLqoK0aiFREJ
         Xffg==
X-Gm-Message-State: APjAAAVgnvv0cCAgyk/xjGh5Hcii7JZ6q0Y6a02j9oixTNVd11Lz/+pc
        NnRHG403uuZFyvz1F7az83WUlJ4NqS0=
X-Google-Smtp-Source: APXvYqzKyggy3XRDvOOCAVqvYOklE68AyX+Ij8CoaPU2ngK2+gT3RX9/kQKifymTQr85TchQwlOH8w==
X-Received: by 2002:aa7:9e50:: with SMTP id z16mr2385657pfq.83.1569487639549;
        Thu, 26 Sep 2019 01:47:19 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id t12sm1340513pjq.18.2019.09.26.01.47.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 01:47:18 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, gvrose8192@gmail.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 0/7] optimize openvswitch flow looking up
Date:   Fri, 20 Sep 2019 00:54:46 +0800
Message-Id: <1568912093-68535-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This series patch optimize openvswitch.

Patch 1, 2, 4: Port Pravin B Shelar patches to
linux upstream with little changes.

Patch 5, 6, 7: Optimize the flow looking up and
simplify the flow hash.

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

We use netperf send the 64B frame, and insert 255+ flow-mask:
$ ovs-dpctl add-flow ovs-switch "in_port(1),eth(dst=00:01:00:00:00:00/ff:ff:ff:ff:ff:01),eth_type(0x0800),ipv4(frag=no)" 2
...
$ ovs-dpctl add-flow ovs-switch "in_port(1),eth(dst=00:ff:00:00:00:00/ff:ff:ff:ff:ff:ff),eth_type(0x0800),ipv4(frag=no)" 2
$ netperf -t UDP_STREAM -H 2.2.2.200 -l 40 -- -m 18

* Without series patch, throughput 8.28Mbps
* With series patch, throughput 46.05Mbps

Tonghao Zhang (7):
  net: openvswitch: add flow-mask cache for performance
  net: openvswitch: convert mask list in mask array
  net: openvswitch: shrink the mask array if necessary
  net: openvswitch: optimize flow mask cache hash collision
  net: openvswitch: optimize flow-mask looking up
  net: openvswitch: simplify the flow_hash
  net: openvswitch: add likely in flow_lookup

 net/openvswitch/datapath.c   |   3 +-
 net/openvswitch/flow.h       |   1 -
 net/openvswitch/flow_table.c | 308 ++++++++++++++++++++++++++++++++++++-------
 net/openvswitch/flow_table.h |  19 ++-
 4 files changed, 282 insertions(+), 49 deletions(-)

-- 
1.8.3.1

