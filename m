Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2F81F7BF8
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 19:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgFLRDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 13:03:17 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:43544 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726390AbgFLRDO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 13:03:14 -0400
X-Greylist: delayed 670 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2020 13:02:58 EDT
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 05CGpXZp019363
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 12 Jun 2020 18:51:33 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Dinesh Dutt <didutt@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [RFC,net-next, 0/5] Strict mode for VRF 
Date:   Fri, 12 Jun 2020 18:49:32 +0200
Message-Id: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds the new "strict mode" functionality to the Virtual
Routing and Forwarding infrastructure (VRF). Hereafter we discuss the
requirements and the main features of the "strict mode" for VRF.

On VRF creation, it is necessary to specify the associated routing table used
during the lookup operations. Currently, there is no mechanism that avoids
creating multiple VRFs sharing the same routing table. In other words, it is not
possible to force a one-to-one relationship between a specific VRF and the table
associated with it.


The "strict mode" imposes that each VRF can be associated to a routing table
only if such routing table is not already in use by any other VRF.
In particular, the strict mode ensures that:
 
 1) given a specific routing table, the VRF (if exists) is uniquely identified;
 2) given a specific VRF, the related table is not shared with any other VRF.

Constraints (1) and (2) force a one-to-one relationship between each VRF and the
corresponding routing table.


The strict mode feature is designed to be network-namespace aware and it can be
directly enabled/disabled acting on the "strict_mode" parameter.
Read and write operations are carried out through the classic sysctl command on
net.vrf.strict_mode path, i.e: sysctl -w net.vrf.strict_mode=1.

Only two distinct values {0,1} are accepted by the strict_mode parameter:

 - with strict_mode=0, multiple VRFs can be associated with the same table.
   This is the (legacy) default kernel behavior, the same that we experience
   when the strict mode patch set is not applied;

 - with strict_mode=1, the one-to-one relationship between the VRFs and the
   associated tables is guaranteed. In this configuration, the creation of a VRF
   which refers to a routing table already associated with another VRF fails and
   the error is returned to the user.


The kernel keeps track of the associations between a VRF and the routing table
during the VRF setup, in the "management" plane. Therefore, the strict mode does
not impact the performance or intrinsic functionality of the data plane in any
way.

When the strict mode is active it is always possible to disable the strict mode,
while the reverse operation is not always allowed.
Setting the strict_mode parameter to 0 is equivalent to removing the one-to-one
constraint between any single VRF and its associated routing table.

Conversely, if the strict mode is disabled and there are multiple VRFs that
refer to the same routing table, then it is prohibited to set the strict_mode
parameter to 1. In this configuration, any attempt to perform the operation will
lead to an error and it will be reported to the user.
To enable strict mode once again (by setting the strict_mode parameter to 1),
you must first remove all the VRFs that share common tables.

There are several use cases which can take advantage from the introduction of
the strict mode feature. In particular, the strict mode allows us to:

  i) guarantee the proper functioning of some applications which deal with
     routing protocols;

 ii) perform some tunneling decap operations which require to use specific
     routing tables for segregating and forwarding the traffic.


Considering (i), the creation of different VRFs that point to the same table
leads to the situation where two different routing entities believe they have
exclusive access to the same table. This leads to the situation where different
routing daemons can conflict for gaining routes control due to overlapping
tables. By enabling strict mode it is possible to prevent this situation which
often occurs due to incorrect configurations done by the users. 
The ability to enable/disable the strict mode functionality does not depend on
the tool used for configuring the networking. In essence, the strict mode patch
solves, at the kernel level, what some other patches [1] had tried to solve at
the userspace level (using only iproute2) with all the related problems.

Considering (ii), the introduction of the strict mode functionality allows us
implementing the SRv6 End.DT4 behavior. Such behavior terminates a SR tunnel and
it forwards the IPv4 traffic according to the routes present in the routing
table supplied during the configuration. The SRv6 End.DT4 can be realized
exploiting the routing capabilities made available by the VRF infrastructure.
This behavior could leverage a specific VRF for forcing the traffic to be
forwarded in accordance with the routes available in the VRF table.
Anyway, in order to make the End.DT4 properly work, it must be guaranteed that
the table used for the route lookup operations is bound to one and only one VRF.
In this way, it is possible to use the table for uniquely retrieving the
associated VRF and for routing packets.

I would like to thank David Ahern for his constant and valuable support during
the design and development phases of this patch set.

Comments, suggestions and improvements are very welcome!

Thanks,
Andrea Mayer


[1] https://lore.kernel.org/netdev/20200307205916.15646-1-sharpd@cumulusnetworks.com/

Andrea Mayer (5):
  l3mdev: add infrastructure for table to VRF mapping
  vrf: track associations between VRF devices and tables
  vrf: add sysctl parameter for strict mode
  vrf: add l3mdev registration for table to VRF device lookup
  selftests: add selftest for the VRF strict mode

 drivers/net/vrf.c                             | 450 +++++++++++++++++-
 include/net/l3mdev.h                          |  37 ++
 net/l3mdev/l3mdev.c                           |  95 ++++
 .../selftests/net/vrf_strict_mode_test.sh     | 390 +++++++++++++++
 4 files changed, 963 insertions(+), 9 deletions(-)
 create mode 100755 tools/testing/selftests/net/vrf_strict_mode_test.sh

-- 
2.20.1

