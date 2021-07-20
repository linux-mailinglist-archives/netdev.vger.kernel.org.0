Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9663D025D
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 21:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhGTTN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 15:13:57 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:37762 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbhGTTNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 15:13:10 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id CDDC3201235C;
        Tue, 20 Jul 2021 21:43:26 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be CDDC3201235C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1626810206;
        bh=uhWl3ueyOFhZTTNFt+1hW/3G5LYNRKCNvIers+PvTbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gFZEbQZZ8QykGJrSF1JD4an4nbTg89IciqEO5jMykkZeQsa9EtUlvM07c30IJCyVn
         mRiKf3JusDqXLyboLaHxGjzA204fR88cC2+hEIVOTMZ9oGX6cbjVVHBWaOJlqhmpRm
         pXQ8Y/UakPByyHTxFae6Fa5LZMqr9Y6RxKfvdi8pWNjfpLzzsJo1H6MBDBkCIdeYcw
         etS0dTEtSQugTdi9SoSLtzfzakrrnk7s6lLjDg25GYrfirDga/98OAYRcv9LiD6gFZ
         6h6+bh5Ihb9axQLCqRCWgHxiWoKDhyLgg089CFA6+k+FwKoG54EP0kOhvm//7mZrXZ
         p9D0oFD4+LiaA==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, tom@herbertland.com, justin.iurman@uliege.be
Subject: [PATCH net-next v5 5/6] ipv6: ioam: Documentation for new IOAM sysctls
Date:   Tue, 20 Jul 2021 21:43:00 +0200
Message-Id: <20210720194301.23243-6-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720194301.23243-1-justin.iurman@uliege.be>
References: <20210720194301.23243-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for new IOAM sysctls:
 - ioam6_id and ioam6_id_wide: two per-namespace sysctls
 - ioam6_enabled, ioam6_id and ioam6_id_wide: three per-interface sysctls

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

  Note that "_wide" IDs equivalents can be configured the same way.

2) Each node can be configured to form an IOAM domain. For instance,
   we allow IOAM from A to C only (not the reverse path), i.e. enable
   IOAM on ingress for B.eth0 and C.eth0:

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
 Documentation/networking/ioam6-sysctl.rst | 26 +++++++++++++++++++++++
 Documentation/networking/ip-sysctl.rst    | 17 +++++++++++++++
 2 files changed, 43 insertions(+)
 create mode 100644 Documentation/networking/ioam6-sysctl.rst

diff --git a/Documentation/networking/ioam6-sysctl.rst b/Documentation/networking/ioam6-sysctl.rst
new file mode 100644
index 000000000000..c18cab2c481a
--- /dev/null
+++ b/Documentation/networking/ioam6-sysctl.rst
@@ -0,0 +1,26 @@
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
+        Accept (= enabled) or ignore (= disabled) IPv6 IOAM options on ingress
+        for this interface.
+
+        * 0 - disabled (default)
+        * 1 - enabled
+
+ioam6_id - SHORT INTEGER
+        Define the IOAM id of this interface.
+
+        Default is ~0.
+
+ioam6_id_wide - INTEGER
+        Define the wide IOAM id of this interface.
+
+        Default is ~0.
diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index b3fa522e4cd9..4bb4fa45cc29 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1926,6 +1926,23 @@ fib_notify_on_flag_change - INTEGER
         - 1 - Emit notifications.
         - 2 - Emit notifications only for RTM_F_OFFLOAD_FAILED flag change.
 
+ioam6_id - INTEGER
+        Define the IOAM id of this node. Uses only 24 bits out of 32 in total.
+
+        Min: 0
+        Max: 0xFFFFFF
+
+        Default: 0xFFFFFF
+
+ioam6_id_wide - LONG INTEGER
+        Define the wide IOAM id of this node. Uses only 56 bits out of 64 in
+        total. Can be different from ioam6_id.
+
+        Min: 0
+        Max: 0xFFFFFFFFFFFFFF
+
+        Default: 0xFFFFFFFFFFFFFF
+
 IPv6 Fragmentation:
 
 ip6frag_high_thresh - INTEGER
-- 
2.25.1

