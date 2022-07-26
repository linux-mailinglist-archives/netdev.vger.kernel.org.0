Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E7F581B53
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 22:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239955AbiGZUtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 16:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239804AbiGZUtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 16:49:51 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F71A1AD93
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658868590; x=1690404590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ygwDtnd5naVVUtjFsTJxJkuNGWhVj2qBd0LwtAuSg7s=;
  b=MEHKYM/I1RsDqet3NhcthgE+/5wMT6A9eJ51E0P0t/Shix93QE+YEgL8
   MP06e0c5uqVa4tKLrsJeKevL8uEdqdCxiDvwK/UrgRIFNDzZzcTz7gGyR
   mhh6l8UHdPp1ukre+nJVAW7sYBrRl5HX7I20Nuq/SkgFaBBUJwiYoX8NG
   tJkxpPPu1ShvRSTJiQ4z1NgT03xLbZuZ6NTYksgwgTvXQOQ90spdTax4w
   saQEtd0uzpFVf3CWk2V8TuerULWZQHfKs1BovgVarAoIxWNSTj5aPJd/q
   EgA3lhDoASl6NPThjNNoCbzZ1hFT5DOMBVKy+iFWoLopFq4qhJwt34HEO
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="268440955"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="268440955"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 13:49:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="575654574"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 26 Jul 2022 13:49:48 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        jdamato@fastly.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 2/5] ice: Fix tunnel checksum offload with fragmented traffic
Date:   Tue, 26 Jul 2022 13:46:43 -0700
Message-Id: <20220726204646.2171589-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220726204646.2171589-1-anthony.l.nguyen@intel.com>
References: <20220726204646.2171589-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

Fix checksum offload on VXLAN tunnels.
In case, when mpls protocol is not used, set l4 header to transport
header of skb. This fixes case, when user tries to offload checksums
of VXLAN tunneled traffic.

Steps for reproduction (requires link partner with tunnels):
ip l s enp130s0f0 up
ip a f enp130s0f0
ip a a 10.10.110.2/24 dev enp130s0f0
ip l s enp130s0f0 mtu 1600
ip link add vxlan12_sut type vxlan id 12 group 238.168.100.100 dev enp130s0f0 dstport 4789
ip l s vxlan12_sut up
ip a a 20.10.110.2/24 dev vxlan12_sut
iperf3 -c 20.10.110.1 #should connect

Offload params: td_offset, cd_tunnel_params were
corrupted, due to l4 header pointing wrong address. NIC would then drop
those packets internally, due to incorrect TX descriptor data,
which increased GLV_TEPC register.

Fixes: 69e66c04c672 ("ice: Add mpls+tso support")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 3f8b7274ed2f..836dce840712 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1751,11 +1751,13 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 
 	protocol = vlan_get_protocol(skb);
 
-	if (eth_p_mpls(protocol))
+	if (eth_p_mpls(protocol)) {
 		ip.hdr = skb_inner_network_header(skb);
-	else
+		l4.hdr = skb_checksum_start(skb);
+	} else {
 		ip.hdr = skb_network_header(skb);
-	l4.hdr = skb_checksum_start(skb);
+		l4.hdr = skb_transport_header(skb);
+	}
 
 	/* compute outer L2 header size */
 	l2_len = ip.hdr - skb->data;
-- 
2.35.1

