Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56CBAD4226
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 16:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbfJKOFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 10:05:36 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39598 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbfJKOFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 10:05:36 -0400
Received: by mail-pl1-f193.google.com with SMTP id s17so4522014plp.6
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 07:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=OTrRKP+pfR00lNFe6P3aYnafLB/pj3jI6/k8pHbXUEY=;
        b=IYszo9sySQJrEKxz4w8OHcl4Qt0HigNENTRBq6pX/1vLLnZAYjZyHpyn+uCsHSqs6f
         S3XJv/BqYCzIR5pRIj2EokbVweCoTyszYzhLOcBEKUcETvT0S+rzelCxBY5HqoCsBh7K
         If2ZHZD8McnkYn1o2F8xgVxiaomio18QyhM/OIlCnFFw+r69CnfZcfuDd6VRA2E1Ujp2
         I2T89UeERpST1Uwa8hvqcAPzrByy1KfteczEWDowYEG6dHtRjUSUmWn+WZGDuJSuMKwI
         93ybe7jHoOp4sdeF3dnYpJWJx/K5l+D+tzYp3avxuRINfHBTdlNp5P0g/SZnFNMLHXqu
         zUiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OTrRKP+pfR00lNFe6P3aYnafLB/pj3jI6/k8pHbXUEY=;
        b=U8LTCNbKaDfrNAh5O2MamO1O7tlkacu4q8kH3pQj6ydgz4Z1U2HIsgd+PLW/3quoGN
         o0fBnoZ383LBEjUoq0R2U1O3YadtOdKuEEUT6HIBmEX/JaFdh847ys5M6y3X0G5c1HtV
         L9rZZSvVASI4BglE0f9h0dsZup30vSaAMCSlM6xrIqhWc+RGC72I6s4cywVDIUw27ICf
         0bt+suB31pnxCITp2drgmDB+x3oGqrOSCLy2LAQUdZyglLIi9a6DzJn28mG6pO88NdDa
         CyYNaKXhX/38KKJgwoTbs+4Vgv0mjyBBbtA4zGX3TTNCC0WPudZ7U7FlXLqMwKrbdG8P
         AFVA==
X-Gm-Message-State: APjAAAX9JgPWN4ioyiKa4+BgLVyYk3KrVSVtStAKHOLoGzoVJg55FZM9
        lz0NcsapAObcXP8qQ/KfHl8=
X-Google-Smtp-Source: APXvYqwpFtofTnQRxh3Ib/LjVpcq6u59xrkUs71xHbEKN6QtmZlhNjyRpx3XyEdyoeSdO89cgwF82g==
X-Received: by 2002:a17:902:126:: with SMTP id 35mr10516225plb.327.1570802735727;
        Fri, 11 Oct 2019 07:05:35 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.143.130.165])
        by smtp.gmail.com with ESMTPSA id p190sm11499392pfb.160.2019.10.11.07.05.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 07:05:35 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 00/10] optimize openvswitch flow looking up
Date:   Fri, 11 Oct 2019 22:00:37 +0800
Message-Id: <1570802447-8019-1-git-send-email-xiangxia.m.yue@gmail.com>
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

v2: simplify codes. e.g. use kfree_rcu instead of call_rcu, use
ma->count in the fastpath.
v3: update ma point when realloc mask_array in patch 5.

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
 net/openvswitch/flow_table.c | 315 +++++++++++++++++++++++++++++++++++++------
 net/openvswitch/flow_table.h |  19 ++-
 4 files changed, 328 insertions(+), 72 deletions(-)

-- 
1.8.3.1

