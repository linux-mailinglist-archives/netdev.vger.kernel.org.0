Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E1E4FAA35
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 20:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243022AbiDISlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 14:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243007AbiDISlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 14:41:09 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D210429D25E;
        Sat,  9 Apr 2022 11:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649529543; x=1681065543;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=egRgAcVpqsi35K+VjlJJW60X1GVnDcMnXByx+r3KOJ0=;
  b=h4D1Lgq/fzU9nYURCAKe5nXJizfV1qjdF40m3Ur17KxqRT/pS/mpo9XD
   I1+Lzkr0ogjPVGi0qj1nuzUJzGcWDkLwSzo9Qyaw3HzCzipztIv+i1UI0
   V821EwtiF/ERNaNnPY67XNYVHXFXlY/0xOfSAZzNqOCsIRU3JsMup9DOI
   sy73MoXMsz57jqgxDRNmp2N2lxJWaE0JdQY78/HHVB2rHpOD8zKQLhw+/
   s3ONJH58J5YwMQ4kNLxquU2fGa05DZr6OFGWMnubWwDaq1+cy+Ybot8xe
   XHG+tCtOiL9jntbIJrAVKAMaHzddbJT5NnXH1aBsDSCI5cwgX2AWFog8g
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,248,1643698800"; 
   d="scan'208";a="159534950"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Apr 2022 11:39:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 9 Apr 2022 11:39:01 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 9 Apr 2022 11:38:59 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 2/4] net: lan966x: Fix IGMP snooping when frames have vlan tag
Date:   Sat, 9 Apr 2022 20:41:41 +0200
Message-ID: <20220409184143.1204786-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220409184143.1204786-1-horatiu.vultur@microchip.com>
References: <20220409184143.1204786-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case an IGMP frame has a vlan tag, then the function
lan966x_hw_offload couldn't figure out that is a IGMP frame. Therefore
the SW thinks that the frame was already forward by the HW which is not
true.
Extend lan966x_hw_offload to pop the vlan tag if are any and then check
for IGMP frames.

Fixes: 47aeea0d57e80c ("net: lan966x: Implement the callback SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED ")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 1f8c67f0261b..958e55596b82 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -446,6 +446,12 @@ static bool lan966x_hw_offload(struct lan966x *lan966x, u32 port,
 		     ANA_CPU_FWD_CFG_MLD_REDIR_ENA)))
 		return true;
 
+	if (eth_type_vlan(skb->protocol)) {
+		skb = skb_vlan_untag(skb);
+		if (unlikely(!skb))
+			return false;
+	}
+
 	if (skb->protocol == htons(ETH_P_IP) &&
 	    ip_hdr(skb)->protocol == IPPROTO_IGMP)
 		return false;
-- 
2.33.0

