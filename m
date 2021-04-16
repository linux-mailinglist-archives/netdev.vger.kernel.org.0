Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA7436289C
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 21:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243191AbhDPT2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 15:28:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240873AbhDPT2Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 15:28:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82C42613B7;
        Fri, 16 Apr 2021 19:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618601271;
        bh=RtSKre+oOiIWwcEfOU92+jouuI2KO2+4cDyMVrsMUcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TsIeZxBeU+b3F8WQzo4f43nuWdpC7sJ5wB3c8clbWpZcx3l5GaHntbHo7uGaPeXif
         z3NCHJ7f9Bl9rloydW9J3m5KzercPEYY9ny5u1+yjEUzPF8xlqbpq/AZ6l81B+VP2l
         dPeRxyDxo5DkvpP7GJRcdqZYHxQt5jIcciMEoW4SeTElsx3V/49kCNo4E7n7k9uL1W
         YiMgFzQiA8j50xTsOdTSEImLEXS0VIzS6CsbQfZv7rEppIODbKyRCSa15ULnCwKD/I
         rvLbpFZdPGYDImVjFfnIubrH+dXsKHTowAm4FM1sbgYpqX/is6VjfY+UQQtwtSWIqN
         v7KzfJcm1tJRQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, mkubecek@suse.cz,
        idosch@nvidia.com, saeedm@nvidia.com, michael.chan@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/9] docs: networking: extend the statistics documentation
Date:   Fri, 16 Apr 2021 12:27:37 -0700
Message-Id: <20210416192745.2851044-2-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416192745.2851044-1-kuba@kernel.org>
References: <20210416192745.2851044-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the lack of expectations for switching NICs explicit,
describe the new stats.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/statistics.rst | 44 +++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/statistics.rst b/Documentation/networking/statistics.rst
index b748fe44ee02..c9aeb70dafa2 100644
--- a/Documentation/networking/statistics.rst
+++ b/Documentation/networking/statistics.rst
@@ -44,8 +44,27 @@ If `-s` is specified once the detailed errors won't be shown.
 Protocol-specific statistics
 ----------------------------
 
-Some of the interfaces used for configuring devices are also able
-to report related statistics. For example ethtool interface used
+Protocol-specific statistics are exposed via relevant interfaces,
+the same interfaces as are used to configure them.
+
+ethtool
+~~~~~~~
+
+Ethtool exposes common low-level statistics.
+All the standard statistics are expected to be maintained
+by the device, not the driver (as opposed to driver-defined stats
+described in the next section which mix software and hardware stats).
+For devices which contain unmanaged
+switches (e.g. legacy SR-IOV or multi-host NICs) the events counted
+may not pertain exclusively to the packets destined to
+the local host interface. In other words the events may
+be counted at the network port (MAC/PHY blocks) without separation
+for different host side (PCIe) devices. Such ambiguity must not
+be present when internal switch is managed by Linux (so called
+switchdev mode for NICs).
+
+Standard ethtool statistics can be accessed via the interfaces used
+for configuration. For example ethtool interface used
 to configure pause frames can report corresponding hardware counters::
 
   $ ethtool --include-statistics -a eth0
@@ -57,6 +76,27 @@ to report related statistics. For example ethtool interface used
     tx_pause_frames: 1
     rx_pause_frames: 1
 
+General Ethernet statistics not associated with any particular
+functionality are exposed via ``ethtool -S $ifc`` by specifying
+the ``--groups`` parameter::
+
+  $ ethtool -S eth0 --groups eth-phy eth-mac eth-ctrl rmon
+  Stats for eth0:
+  eth-phy-SymbolErrorDuringCarrier: 0
+  eth-mac-FramesTransmittedOK: 1
+  eth-mac-FrameTooLongErrors: 1
+  eth-ctrl-MACControlFramesTransmitted: 1
+  eth-ctrl-MACControlFramesReceived: 0
+  eth-ctrl-UnsupportedOpcodesReceived: 1
+  rmon-etherStatsUndersizePkts: 1
+  rmon-etherStatsJabbers: 0
+  rmon-rx-etherStatsPkts64Octets: 1
+  rmon-rx-etherStatsPkts65to127Octets: 0
+  rmon-rx-etherStatsPkts128to255Octets: 0
+  rmon-tx-etherStatsPkts64Octets: 2
+  rmon-tx-etherStatsPkts65to127Octets: 3
+  rmon-tx-etherStatsPkts128to255Octets: 0
+
 Driver-defined statistics
 -------------------------
 
-- 
2.30.2

