Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A784ACD2F
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 02:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245692AbiBHBGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 20:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343527AbiBGXc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 18:32:56 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E21C0612A4;
        Mon,  7 Feb 2022 15:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644276776; x=1675812776;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8LcijeoOvZZoueOfarN7zBuLICOw8GrA65of4YyERrI=;
  b=UrpdR30cZH7FeVTCJG2kYBfY+UrzrapW7gfvoIAQOM+bZrb/9Okp33XJ
   xStVvyYxjTzcR7WQ5bqxH6vdRtLEu6TgNNF514pEtbxdUecR7n01zCEm4
   BA3b2ZAVN3igA4lOOxFv6Li/t6ejjOKMyLbTqmYd/7wfBeGMet9aFp+YS
   gWMx9ceurHFzttHEyobteqBsBM8sH6c0+Og4zFryqY9zqamMkJ2KpVrYn
   TUkfPmcIRYviEG4fcGZVvEMj59jKJOkDWiybWpiHRzel1420llUAUBp7R
   O4ZVBmb9boihOmIVn3rVtII2kzRKaEPeHR4bhGxzZPG+/hUnEcZAMSulL
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="335232072"
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="335232072"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 15:32:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="772948623"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 07 Feb 2022 15:32:55 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Corinna Vinschen <vinschen@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Lennert Buytenhek <buytenh@arista.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 1/2] igc: avoid kernel warning when changing RX ring parameters
Date:   Mon,  7 Feb 2022 15:32:45 -0800
Message-Id: <20220207233246.1172958-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220207233246.1172958-1-anthony.l.nguyen@intel.com>
References: <20220207233246.1172958-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corinna Vinschen <vinschen@redhat.com>

Calling ethtool changing the RX ring parameters like this:

  $ ethtool -G eth0 rx 1024

on igc triggers kernel warnings like this:

[  225.198467] ------------[ cut here ]------------
[  225.198473] Missing unregister, handled but fix driver
[  225.198485] WARNING: CPU: 7 PID: 959 at net/core/xdp.c:168
xdp_rxq_info_reg+0x79/0xd0
[...]
[  225.198601] Call Trace:
[  225.198604]  <TASK>
[  225.198609]  igc_setup_rx_resources+0x3f/0xe0 [igc]
[  225.198617]  igc_ethtool_set_ringparam+0x30e/0x450 [igc]
[  225.198626]  ethnl_set_rings+0x18a/0x250
[  225.198631]  genl_family_rcv_msg_doit+0xca/0x110
[  225.198637]  genl_rcv_msg+0xce/0x1c0
[  225.198640]  ? rings_prepare_data+0x60/0x60
[  225.198644]  ? genl_get_cmd+0xd0/0xd0
[  225.198647]  netlink_rcv_skb+0x4e/0xf0
[  225.198652]  genl_rcv+0x24/0x40
[  225.198655]  netlink_unicast+0x20e/0x330
[  225.198659]  netlink_sendmsg+0x23f/0x480
[  225.198663]  sock_sendmsg+0x5b/0x60
[  225.198667]  __sys_sendto+0xf0/0x160
[  225.198671]  ? handle_mm_fault+0xb2/0x280
[  225.198676]  ? do_user_addr_fault+0x1eb/0x690
[  225.198680]  __x64_sys_sendto+0x20/0x30
[  225.198683]  do_syscall_64+0x38/0x90
[  225.198687]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  225.198693] RIP: 0033:0x7f7ae38ac3aa

igc_ethtool_set_ringparam() copies the igc_ring structure but neglects to
reset the xdp_rxq_info member before calling igc_setup_rx_resources().
This in turn calls xdp_rxq_info_reg() with an already registered xdp_rxq_info.

Make sure to unregister the xdp_rxq_info structure first in
igc_setup_rx_resources.

Fixes: 73f1071c1d29 ("igc: Add support for XDP_TX action")
Reported-by: Lennert Buytenhek <buytenh@arista.com>
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index b965fb809d84..74b2c590ed5d 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -505,6 +505,9 @@ int igc_setup_rx_resources(struct igc_ring *rx_ring)
 	u8 index = rx_ring->queue_index;
 	int size, desc_len, res;
 
+	/* XDP RX-queue info */
+	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
+		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, ndev, index,
 			       rx_ring->q_vector->napi.napi_id);
 	if (res < 0) {
-- 
2.31.1

