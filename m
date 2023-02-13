Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA8F69501E
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjBMS7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjBMS7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:59:35 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2401221A0C
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676314751; x=1707850751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FsU12iEeWY2TrxoWON/6pNeI1NRO49vyIV9hIt00ayA=;
  b=OsWk+fwJvthLLf3Rua4kyLYCJ9Djh9wNAHFlA777WLmOUZI0TT7tlULD
   BX43V1UrChDYF7KSrxCGH2Y4EfI+VtymOfDotaRn1+lTMpHgYO73EYNAi
   XZ3OdI5DDIPn1p6bJ76f7IvQOZlcimtMMpu3+3KiTOIlQZ/mDtNMLeyFv
   jCNPZCL5yercYF7N8LhewBYdJUg7ior0a4eI1X4w7KBn0++Slfbv/FfGt
   SvS0FUoHnNOtcOZAWtR45rOapbS6wF/xo8WtstB50ezJ5sn2nIZuhmfcV
   O02IApsTCv/MFnVUSBUEEnoAyefuNAtfuy1O+0QnNuZxQy3bRCpYFfKVi
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="328677779"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="328677779"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 10:53:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="737619910"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="737619910"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga004.fm.intel.com with ESMTP; 13 Feb 2023 10:53:33 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: [PATCH net 2/2] ice: fix lost multicast packets in promisc mode
Date:   Mon, 13 Feb 2023 10:52:59 -0800
Message-Id: <20230213185259.3959224-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230213185259.3959224-1-anthony.l.nguyen@intel.com>
References: <20230213185259.3959224-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

There was a problem reported to us where the addition of a VF with an IPv6
address ending with a particular sequence would cause the parent device on
the PF to no longer be able to respond to neighbor discovery packets.

In this case, we had an ovs-bridge device living on top of a VLAN, which
was on top of a PF, and it would not be able to talk anymore (the neighbor
entry would expire and couldn't be restored).

The root cause of the issue is that if the PF is asked to be in IFF_PROMISC
mode (promiscuous mode) and it had an ipv6 address that needed the
33:33:ff:00:00:04 multicast address to work, then when the VF was added
with the need for the same multicast address, the VF would steal all the
traffic destined for that address.

The ice driver didn't auto-subscribe a request of IFF_PROMISC to the
"multicast replication from other port's traffic" meaning that it won't get
for instance, packets with an exact destination in the VF, as above.

The VF's IPv6 address, which adds a "perfect filter" for 33:33:ff:00:00:04,
results in no packets for that multicast address making it to the PF (which
is in promisc but NOT "multicast replication").

The fix is to enable "multicast promiscuous" whenever the driver is asked
to enable IFF_PROMISC, and make sure to disable it when appropriate.

Fixes: e94d44786693 ("ice: Implement filter sync, NDO operations and bump version")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 26 +++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b288a01a321a..8ec24f6cf6be 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -275,6 +275,8 @@ static int ice_set_promisc(struct ice_vsi *vsi, u8 promisc_m)
 	if (status && status != -EEXIST)
 		return status;
 
+	netdev_dbg(vsi->netdev, "set promisc filter bits for VSI %i: 0x%x\n",
+		   vsi->vsi_num, promisc_m);
 	return 0;
 }
 
@@ -300,6 +302,8 @@ static int ice_clear_promisc(struct ice_vsi *vsi, u8 promisc_m)
 						    promisc_m, 0);
 	}
 
+	netdev_dbg(vsi->netdev, "clear promisc filter bits for VSI %i: 0x%x\n",
+		   vsi->vsi_num, promisc_m);
 	return status;
 }
 
@@ -414,6 +418,16 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 				}
 				err = 0;
 				vlan_ops->dis_rx_filtering(vsi);
+
+				/* promiscuous mode implies allmulticast so
+				 * that VSIs that are in promiscuous mode are
+				 * subscribed to multicast packets coming to
+				 * the port
+				 */
+				err = ice_set_promisc(vsi,
+						      ICE_MCAST_PROMISC_BITS);
+				if (err)
+					goto out_promisc;
 			}
 		} else {
 			/* Clear Rx filter to remove traffic from wire */
@@ -430,6 +444,18 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 				    NETIF_F_HW_VLAN_CTAG_FILTER)
 					vlan_ops->ena_rx_filtering(vsi);
 			}
+
+			/* disable allmulti here, but only if allmulti is not
+			 * still enabled for the netdev
+			 */
+			if (!(vsi->current_netdev_flags & IFF_ALLMULTI)) {
+				err = ice_clear_promisc(vsi,
+							ICE_MCAST_PROMISC_BITS);
+				if (err) {
+					netdev_err(netdev, "Error %d clearing multicast promiscuous on VSI %i\n",
+						   err, vsi->vsi_num);
+				}
+			}
 		}
 	}
 	goto exit;
-- 
2.38.1

