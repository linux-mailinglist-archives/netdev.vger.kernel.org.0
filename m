Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDB536178F
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 04:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238241AbhDPC2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 22:28:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238194AbhDPC2T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 22:28:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53729610FA;
        Fri, 16 Apr 2021 02:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618540075;
        bh=kGhJclpsgxQPTXBZhdlBlJuKmjSTKksx4UOyUrAzjYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iskL0a2+FQ3CS1L1jdAwH2Msk0lZoidL5HnJt+o753ch8w2SKS2VzDtf50gicxS6v
         9yAx3F1RxPUZhvQltKotZA7Skg77Opn/hCBKqU8iIaScFeBNDfmsGFwssFDIPPlGzE
         YBZGgn2lZT/1OwcrWrG5sWRqxwi2Zv6my5USG7ScC2au1vmSQBrwwtJlI8Gu6HetyY
         nhdNaI+lPA0exBEJ4Ez7QnSG4h5ki62YWZpaJdHTl4Q9k7QdHFfReHImPEBaprQX3R
         8Y9+YOgF7vIhWan2JD01TeFp1xbxefQsycbqO1EZ7ICIOpAp5YdFlowd2s9v8wBSvU
         QwYCBJutj0T7w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, mkubecek@suse.cz,
        idosch@nvidia.com, saeedm@nvidia.com, michael.chan@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/9] docs: networking: extend the statistics documentation
Date:   Thu, 15 Apr 2021 19:27:44 -0700
Message-Id: <20210416022752.2814621-2-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416022752.2814621-1-kuba@kernel.org>
References: <20210416022752.2814621-1-kuba@kernel.org>
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
index b748fe44ee02..5aaa66bba971 100644
--- a/Documentation/networking/statistics.rst
+++ b/Documentation/networking/statistics.rst
@@ -44,8 +44,27 @@ If `-s` is specified once the detailed errors won't be shown.
 Protocol-specific statistics
 ----------------------------
 
-Some of the interfaces used for configuring devices are also able
-to report related statistics. For example ethtool interface used
+Protocol-specific statistics are exposed via relevant interfaces,
+the same interfaces used to configure them.
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

