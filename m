Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B8C67E62A
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 14:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbjA0NKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 08:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbjA0NJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 08:09:30 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E0C80012;
        Fri, 27 Jan 2023 05:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674824953; x=1706360953;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u8DnF1t00zWzTonmr+R22MKl2bbsYSJ4oF8S7fYeWRI=;
  b=s/ytQforZQEFfLlqO5KAkONSeUD7oz1M1P90YnCMMxveDrGzHW1cMeke
   ITXZdV8mXPcbU9ILjryVoDFo9uR3Q/7roGMHT7J+HIi7fQ4vVU/XTmL1t
   OWgm+gTJ90UO+Zm4MEJ77J66+rBaE6eFVymtDJn5NCHW6vpny0938ctHF
   m4O4sxucWQEsIPdXnNunyBz6mU2BK4OZ+2NZxtVfRKgWIFXHTNjTOsGZE
   tvf2ObsINIAyN4zFLOfDPgmli749AaeCGYppiradT8IE0QYvXn3F6LGNI
   gRP1u9i/N7GwjYeXPnV+quo5wi3tYa/XE94DzWRtH85jJ7TqOIUFqYXf3
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,251,1669100400"; 
   d="scan'208";a="194150444"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2023 06:09:01 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 06:08:56 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 27 Jan 2023 06:08:52 -0700
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
Subject: [PATCH net-next 3/8] net: microchip: sparx5: Improve error message when parsing CVLAN filter
Date:   Fri, 27 Jan 2023 14:08:25 +0100
Message-ID: <20230127130830.1481526-4-steen.hegelund@microchip.com>
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

This improves the error message when a TC filter with CVLAN tag is used and
the selected VCAP instance does not support this.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 8982c434cf54..f9922b35ee33 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -325,8 +325,11 @@ sparx5_tc_flower_handler_cvlan_usage(struct sparx5_tc_flower_parse_usage *st)
 	u16 tpid;
 	int err;
 
-	if (st->admin->vtype != VCAP_TYPE_IS0)
+	if (st->admin->vtype != VCAP_TYPE_IS0) {
+		NL_SET_ERR_MSG_MOD(st->fco->common.extack,
+				   "cvlan not supported in this VCAP");
 		return -EINVAL;
+	}
 
 	flow_rule_match_cvlan(st->frule, &mt);
 
-- 
2.39.1

