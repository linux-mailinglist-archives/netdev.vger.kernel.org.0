Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05469351D88
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237500AbhDAS3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:29:01 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:56160 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239317AbhDASZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 14:25:53 -0400
Received: from localhost.localdomain (124.18-200-80.adsl-dyn.isp.belgacom.be [80.200.18.124])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 5747820199F4;
        Thu,  1 Apr 2021 20:23:49 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 5747820199F4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1617301429;
        bh=o4CFOdJBsyvO9mXm8DSedxPegA2UYyXvK4QZr/xBjhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IyYgdROlC6rv3XKmtfRu3LRZxwLwAApD++Uz4dESq/Ly1/a+E1D/BkBFnRhpYsqYL
         3iz7ktXE/RpWYkw/CZQXnjXC1UW1wSrfKrvy0+Wod6316HAZI6tyRBIG3EiH3VwBNx
         Tfvrd/xyp93f9kSD50jCvOBlG29Nf8U9pVjI0kFqMCpTonI8aFBAfOUjut4UnEEmkQ
         sZHYzLPVChpSrDeO9bST12Cb29wBMPBX/VVXIoflYlGWLmmhr4Zv8shGdyW1aNzQ1S
         9GTsyfxmSif2/5soxRhK4/2N8bcbopEthrttzY3VjSE/5Z2mtuEUS3d+CQ4pL/3sIO
         N9InnElzv1R+Q==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, tom@herbertland.com,
        justin.iurman@uliege.be
Subject: [PATCH net-next v3 5/5] ipv6: ioam: Documentation for new IOAM sysctls
Date:   Thu,  1 Apr 2021 20:23:38 +0200
Message-Id: <20210401182338.24077-6-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210401182338.24077-1-justin.iurman@uliege.be>
References: <20210401182338.24077-1-justin.iurman@uliege.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for new IOAM sysctls:
 - ioam6_id: a namespace sysctl
 - ioam6_enabled and ioam6_id: two per-interface sysctls

Example of IOAM configuration based on the following simple topology:

 _____              _____              _____
|     | eth0  eth0 |     | eth1  eth0 |     |
|  A  |.----------.|  B  |.----------.|  C  |
|_____|            |_____|            |_____|

1) Node and interface IDs can be configured for IOAM:

  # IOAM ID of A = 1, IOAM ID of A.eth0 = 11
  (A) sysctl -w net.ipv6.ioam6_id=1
  (A) sysctl -w net.ipv6.conf.eth0.ioam6_id=11

  # IOAM ID of B = 2, IOAM ID of B.eth0 = 21, IOAM ID of B.eth1 = 22
  (B) sysctl -w net.ipv6.ioam6_id=2
  (B) sysctl -w net.ipv6.conf.eth0.ioam6_id=21
  (B) sysctl -w net.ipv6.conf.eth1.ioam6_id=22

  # IOAM ID of C = 3, IOAM ID of C.eth0 = 31
  (C) sysctl -w net.ipv6.ioam6_id=3
  (C) sysctl -w net.ipv6.conf.eth0.ioam6_id=31

2) Each node can be configured to form an IOAM domain. For instance,
   we allow IOAM from A to C, i.e. enable IOAM on ingress for B.eth0
   and C.eth0:

  (B) sysctl -w net.ipv6.conf.eth0.ioam6_enabled=1
  (C) sysctl -w net.ipv6.conf.eth0.ioam6_enabled=1

3) An IOAM domain (e.g. ID=123) is defined and made known to each node:

  (A) ip ioam namespace add 123
  (B) ip ioam namespace add 123
  (C) ip ioam namespace add 123

4) Finally, an IOAM Pre-allocated Trace can be inserted in traffic sent
   by A when C (e.g. db02::2) is the destination:

  (A) ip -6 route add db02::2/128 encap ioam6 trace type 0x800000 ns 123
      size 12 dev eth0

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 Documentation/networking/ioam6-sysctl.rst | 20 ++++++++++++++++++++
 Documentation/networking/ip-sysctl.rst    |  5 +++++
 2 files changed, 25 insertions(+)
 create mode 100644 Documentation/networking/ioam6-sysctl.rst

diff --git a/Documentation/networking/ioam6-sysctl.rst b/Documentation/networking/ioam6-sysctl.rst
new file mode 100644
index 000000000000..37a9b4e731a0
--- /dev/null
+++ b/Documentation/networking/ioam6-sysctl.rst
@@ -0,0 +1,20 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================
+IOAM6 Sysfs variables
+=====================
+
+
+/proc/sys/net/conf/<iface>/ioam6_* variables:
+=============================================
+
+ioam6_enabled - BOOL
+	Accept or ignore IPv6 IOAM options for ingress on this interface.
+
+	* 0 - disabled (default)
+	* not 0 - enabled
+
+ioam6_id - INTEGER
+	Define the IOAM id of this interface.
+
+	Default is 0.
diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 4130bce40765..b2f7597c554b 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1841,6 +1841,11 @@ fib_notify_on_flag_change - INTEGER
         - 1 - Emit notifications.
         - 2 - Emit notifications only for RTM_F_OFFLOAD_FAILED flag change.
 
+ioam6_id - INTEGER
+	Define the IOAM id of this node.
+
+	Default: 0
+
 IPv6 Fragmentation:
 
 ip6frag_high_thresh - INTEGER
-- 
2.17.1

