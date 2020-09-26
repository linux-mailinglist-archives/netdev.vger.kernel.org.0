Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E882795C0
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbgIZA5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729868AbgIZA5C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 20:57:02 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A50CC23119;
        Sat, 26 Sep 2020 00:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601081819;
        bh=uHQBQDw5EqZsbpLq2td11X0FSaVovfEOMhVFJwjuaQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXOyojSBaPcYIU02ZuWO3bZsnJOfzAxOPZLXmXIJ2LDYaHKb28YGPuc17RfTFENZZ
         0Rd44YBjzcDtPeXvNf1V/iAVHRg12tBM0d0CDvMYAuzOOwlmTk/kdh/fR0Yjg0mPnb
         yB1EaBrAoVrhJ7CYsWCQmaXfUE0mfgIU79ldq3vA=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 10/10] docs: vxlan: add info about device features
Date:   Fri, 25 Sep 2020 17:56:49 -0700
Message-Id: <20200926005649.3285089-11-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200926005649.3285089-1-kuba@kernel.org>
References: <20200926005649.3285089-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some information about VxLAN-related netdev features
and how to dump port table via ethtool.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/vxlan.rst | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/networking/vxlan.rst b/Documentation/networking/vxlan.rst
index ce239fa01848..2759dc1cc525 100644
--- a/Documentation/networking/vxlan.rst
+++ b/Documentation/networking/vxlan.rst
@@ -58,3 +58,31 @@ forwarding table using the new bridge command.
 3. Show forwarding table::
 
     # bridge fdb show dev vxlan0
+
+The following NIC features may indicate support for UDP tunnel-related
+offloads (most commonly VXLAN features, but support for a particular
+encapsulation protocol is NIC specific):
+
+ - `tx-udp_tnl-segmentation`
+ - `tx-udp_tnl-csum-segmentation`
+    ability to perform TCP segmentation offload of UDP encapsulated frames
+
+ - `rx-udp_tunnel-port-offload`
+    receive side parsing of UDP encapsulated frames which allows NICs to
+    perform protocol-aware offloads, like checksum validation offload of
+    inner frames (only needed by NICs without protocol-agnostic offloads)
+
+For devices supporting `rx-udp_tunnel-port-offload` the list of currently
+offloaded ports can be interrogated with `ethtool`::
+
+  $ ethtool --show-tunnels eth0
+  Tunnel information for eth0:
+    UDP port table 0:
+      Size: 4
+      Types: vxlan
+      No entries
+    UDP port table 1:
+      Size: 4
+      Types: geneve, vxlan-gpe
+      Entries (1):
+          port 1230, vxlan-gpe
-- 
2.26.2

