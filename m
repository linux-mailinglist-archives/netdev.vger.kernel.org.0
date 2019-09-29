Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E424FC1A15
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 04:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbfI3CJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 22:09:00 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41623 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfI3CI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 22:08:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id q7so4665653pfh.8
        for <netdev@vger.kernel.org>; Sun, 29 Sep 2019 19:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wVVKrGxWk9og3U6wg8lbEs1Zjzj0LObjQYzJMnPihA0=;
        b=jnK/Q7zPPjD8ojUB5dzfiYQmqWWjnKirKWmhx2dYcyNtFRQp9TMI8jpJ7YK8m63yV7
         ligTrv6TFlpzR/AeLqS2dZoAw+I5AG4hhh3+vR7KdSfmPtrUOCl4Yo4fmzDpkI114Sms
         qV2hAAGczrQ6qwbJnWnDzEwDQfmXrrFFVzTSj6cQdv8IB8raZBarF96koj13aQEEi2LH
         8+1YFR/mOdq5z3Qtq3Yr7jjI8vu09ELwVX5uZdwXqcOQlO0LbgdRRLn1p4o/oyK8eT4i
         uIWcVFylZv7+Cr5nciUEp7Z30UTJTaVbOqfsahFmxqhXmEEKJXV26SOIu5uhSWtZ9I8N
         I0gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wVVKrGxWk9og3U6wg8lbEs1Zjzj0LObjQYzJMnPihA0=;
        b=VfDPcuRuec5XsB9VDlk/+U+lG9t4gY8xYZys3Yn+QSuydFz3uKAWOFFJpmZcK6lM5P
         C/ClqNcr8sxsjHP9a5nEQe+esx+oSTEbGz8HWWWXNuGmwVAOaBsFHUlCunOh2F8LZnK1
         WhFR8iRSK0MFP4OzSfLpgJ6hpCmYzLTAzL/uliW00fYd62MmE/Db6F3z/iZfGtkNzJRA
         NtPfg6tDfKSesUrg+azz53fh3w7ZeXnw4Y43wS1p0IMlWtpOBFd21WQD8wu7DD4idZZ9
         Bg+Onvwhi5NZ+xlldDsiDwoyBMSJR0dygu4BSAcSnJjfXIk1eELf9vBxbLmuKmIuaj+4
         e/YQ==
X-Gm-Message-State: APjAAAW2NWMDqm3IfpTaCLaQxMniL+J/wIS6vKHl80qIh0Pf8wmA8sHj
        oKK8dPqopOJYXvKpMacIBngODXfp
X-Google-Smtp-Source: APXvYqznuYFeTgsO9YxdG20x07Oac5idVwAFme58wwB+PHni/+R6cibA4b9ds7bcc9zQ9gTjVmMX2g==
X-Received: by 2002:a62:db84:: with SMTP id f126mr19074913pfg.25.1569809339204;
        Sun, 29 Sep 2019 19:08:59 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d69sm9941635pfd.175.2019.09.29.19.08.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2019 19:08:58 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 0/9] optimize openvswitch flow looking up
Date:   Mon, 30 Sep 2019 01:09:57 +0800
Message-Id: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
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

Patch 8: is a bugfix.

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

Tonghao Zhang (9):
  net: openvswitch: add flow-mask cache for performance
  net: openvswitch: convert mask list in mask array
  net: openvswitch: shrink the mask array if necessary
  net: openvswitch: optimize flow mask cache hash collision
  net: openvswitch: optimize flow-mask looking up
  net: openvswitch: simplify the flow_hash
  net: openvswitch: add likely in flow_lookup
  net: openvswitch: fix possible memleak on destroy flow table
  net: openvswitch: simplify the ovs_dp_cmd_new

 net/openvswitch/datapath.c   |  63 +++++----
 net/openvswitch/flow.h       |   1 -
 net/openvswitch/flow_table.c | 318 +++++++++++++++++++++++++++++++++++++------
 net/openvswitch/flow_table.h |  19 ++-
 4 files changed, 330 insertions(+), 71 deletions(-)

-- 
1.8.3.1

