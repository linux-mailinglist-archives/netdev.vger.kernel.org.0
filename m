Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A80F40CB7E
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 19:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbhIORQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 13:16:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:33465 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhIORQh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 13:16:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10108"; a="222046049"
X-IronPort-AV: E=Sophos;i="5.85,296,1624345200"; 
   d="scan'208";a="222046049"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2021 10:15:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,296,1624345200"; 
   d="scan'208";a="700305120"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 15 Sep 2021 10:15:17 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, Corinna Vinschen <vinschen@redhat.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>
Subject: [PATCH net 1/1] igc: fix tunnel offloading
Date:   Wed, 15 Sep 2021 10:19:07 -0700
Message-Id: <20210915171907.1652824-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Checking tunnel offloading, it turns out that offloading doesn't work
as expected.  The following script allows to reproduce the issue.
Call it as `testscript DEVICE LOCALIP REMOTEIP NETMASK'

=== SNIP ===
if [ $# -ne 4 ]
then
  echo "Usage $0 DEVICE LOCALIP REMOTEIP NETMASK"
  exit 1
fi
DEVICE="$1"
LOCAL_ADDRESS="$2"
REMOTE_ADDRESS="$3"
NWMASK="$4"
echo "Driver: $(ethtool -i ${DEVICE} | awk '/^driver:/{print $2}') "
ethtool -k "${DEVICE}" | grep tx-udp
echo
echo "Set up NIC and tunnel..."
ip addr add "${LOCAL_ADDRESS}/${NWMASK}" dev "${DEVICE}"
ip link set "${DEVICE}" up
sleep 2
ip link add vxlan1 type vxlan id 42 \
		   remote "${REMOTE_ADDRESS}" \
		   local "${LOCAL_ADDRESS}" \
		   dstport 0 \
		   dev "${DEVICE}"
ip addr add fc00::1/64 dev vxlan1
ip link set vxlan1 up
sleep 2
rm -f vxlan.pcap
echo "Running tcpdump and iperf3..."
( nohup tcpdump -i any -w vxlan.pcap >/dev/null 2>&1 ) &
sleep 2
iperf3 -c fc00::2 >/dev/null
pkill tcpdump
echo
echo -n "Max. Paket Size: "
tcpdump -r vxlan.pcap -nnle 2>/dev/null \
| grep "${LOCAL_ADDRESS}.*> ${REMOTE_ADDRESS}.*OTV" \
| awk '{print $8}' | awk -F ':' '{print $1}' \
| sort -n | tail -1
echo
ip link del vxlan1
ip addr del ${LOCAL_ADDRESS}/${NWMASK} dev "${DEVICE}"
=== SNAP ===

The expected outcome is

  Max. Paket Size: 64904

This is what you see on igb, the code igc has been taken from.
However, on igc the output is

  Max. Paket Size: 1516

so the GSO aggregate packets are segmented by the kernel before calling
igc_xmit_frame.  Inside the subsequent call to igc_tso, the check for
skb_is_gso(skb) fails and the function returns prematurely.

It turns out that this occurs because the feature flags aren't set
entirely correctly in igc_probe.  In contrast to the original code
from igb_probe, igc_probe neglects to set the flags required to allow
tunnel offloading.

Setting the same flags as igb fixes the issue on igc.

Fixes: 34428dff3679 ("igc: Add GSO partial support")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Tested-by: Corinna Vinschen <vinschen@redhat.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index b877efae61df..0e19b4d02e62 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6350,7 +6350,9 @@ static int igc_probe(struct pci_dev *pdev,
 	if (pci_using_dac)
 		netdev->features |= NETIF_F_HIGHDMA;
 
-	netdev->vlan_features |= netdev->features;
+	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
+	netdev->mpls_features |= NETIF_F_HW_CSUM;
+	netdev->hw_enc_features |= netdev->vlan_features;
 
 	/* MTU range: 68 - 9216 */
 	netdev->min_mtu = ETH_MIN_MTU;
-- 
2.26.2

