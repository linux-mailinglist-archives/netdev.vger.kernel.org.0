Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24F8596277
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiHPS21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiHPS2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:28:25 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A8E255B1
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660674504; x=1692210504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AdrCKEoQ28UCFTIsOiDs4cfi6yli2ZUP/K35a3cb5fY=;
  b=Yf9nCKjNau+Bol0mqlGK1lYJ/jQap/Tbqy0L4kXov3WwHia5lLNhozJR
   /MYQ8LbmGd8RKQBH2cVb09TiC/3b6ZogEDET5IYA9ttDIoKrJdgUfyT7G
   4MKT6BdfNoAhB5+nbNX/sEjuPNWsAekNRrJrvd1FtIF7k8gG9ZNXk171t
   xGP27AbFGo2JWLtkAmmoS6D9X4R297K3/HreFwGi5Td+V80+XOCc90WV5
   O7wEpJs7gRmv1CF0GM6BRC5Q1D2rCvJ/Yb6vOm1Aa4A2xBeg1MGeqj9mj
   S93Wb9QR7c7eGoNjRfWsfKGHJ33Ys4jYhYgVfYmO6IJQSUuyQWov+EUuL
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="293572975"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="293572975"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 11:27:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="710246355"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 16 Aug 2022 11:27:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        mgallo@fastly.com, jdamato@fastly.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net 1/2] i40e: Fix tunnel checksum offload with fragmented traffic
Date:   Tue, 16 Aug 2022 11:27:50 -0700
Message-Id: <20220816182751.2534028-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220816182751.2534028-1-anthony.l.nguyen@intel.com>
References: <20220816182751.2534028-1-anthony.l.nguyen@intel.com>
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
ip link add vxlan12_sut type vxlan id 12 group 238.168.100.100 dev \
enp130s0f0 dstport 4789
ip l s vxlan12_sut up
ip a a 20.10.110.2/24 dev vxlan12_sut
iperf3 -c 20.10.110.1 #should connect

Without this patch, TX descriptor was using wrong data, due to
l4 header pointing wrong address. NIC would then drop those packets
internally, due to incorrect TX descriptor data, which increased
GLV_TEPC register.

Fixes: b4fb2d33514a ("i40e: Add support for MPLS + TSO")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index f6ba97a0166e..d4226161a3ef 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3203,11 +3203,13 @@ static int i40e_tx_enable_csum(struct sk_buff *skb, u32 *tx_flags,
 
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
 
 	/* set the tx_flags to indicate the IP protocol type. this is
 	 * required so that checksum header computation below is accurate.
-- 
2.35.1

