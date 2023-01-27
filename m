Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C4167E627
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 14:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbjA0NJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 08:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbjA0NJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 08:09:27 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D797FA01;
        Fri, 27 Jan 2023 05:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674824952; x=1706360952;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aOekovlU26BZ6lJ7Al8iWnX4uypFmQKrzcdds3/X4kA=;
  b=ZDNk7kFVOvbpPYnBBQjnBVgyBHFwEafS/iHVYqLumBLR3r2HHxRtVg0a
   LRO0UjT5e6YQfXjTOyhKz0wmInpef6V67KjL1Q4YAPx9kGjcfmL98dD0+
   gsSZ/YH3HjQkLkZLP2tnRHJapZ46Lm9XhDIOpgSN3CSgCCc3z31E/lu98
   ByPBdLtN4GtM5lkUHr4TgY6stjOyhDJemVqCLRtvAx7lbOj7SH69CKIkj
   JPtNYRRquZkeiyHRSOySA/imR+GDjQAlXUuJsnQC4yf3mGpmLKdFUgkPE
   rWLuxgqIK/7gbRoy+Bf1ZsZqlysn1Dut1miZy92JzUl/TkLgtbeAS2OpY
   A==;
X-IronPort-AV: E=Sophos;i="5.97,251,1669100400"; 
   d="scan'208";a="198504099"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2023 06:08:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 06:08:52 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 27 Jan 2023 06:08:47 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 2/8] net: microchip: sparx5: Improve the IP frame key match for IPv6 frames
Date:   Fri, 27 Jan 2023 14:08:24 +0100
Message-ID: <20230127130830.1481526-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230127130830.1481526-1-steen.hegelund@microchip.com>
References: <20230127130830.1481526-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This ensures that it will be possible for a VCAP rule to distinguish IPv6
frames from non-IP frames, as the IS0 keyset usually selected for the IPv6
traffic class in (7TUPLE) does not offer a key that specifies IPv6
directly: only non-IPv4.

The IP_SNAP key ensures that we select (at least) IP frames.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 59d6ed6f4191..8982c434cf54 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -266,6 +266,14 @@ sparx5_tc_flower_handler_basic_usage(struct sparx5_tc_flower_parse_usage *st)
 						    VCAP_BIT_0);
 			if (err)
 				goto out;
+			if (st->admin->vtype == VCAP_TYPE_IS0) {
+				err = vcap_rule_add_key_bit(st->vrule,
+							    VCAP_KF_IP_SNAP_IS,
+							    VCAP_BIT_1);
+				if (err)
+					goto out;
+			}
+
 		}
 	}
 
-- 
2.39.1

