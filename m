Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2ED66906E
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240986AbjAMIQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236698AbjAMIPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:15:43 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAC3395D9;
        Fri, 13 Jan 2023 00:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673597679; x=1705133679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CSSQa3dD4gybR3nOez6pDisJkzG2bVCeG3CLX4+Xp4Q=;
  b=qmPcU7C1baRvAb+yz+RCH8mb0pCLs3TgtyCz4T9klcnylYpuMSLeaHF6
   nJHrx2JXcyFbRksO7lE5ReHaMmN5LdjGlH1tJj842RAKjGddtMeS6InVQ
   FyCj1Z1noItCR9WS4cJzmIq0XuxsrC2wI2M+rZA4Qbg3W3LD7uZ+0nGld
   6fpERjEtqqIOKmwBnLJBYvN1FwXrCdG+zBwbxyxKNJiE0ez9Sf+Jh3Bsm
   Q7VCrjBM+737QU6DOiOEMbw7IrS8vcefU2qlnesiTP8HK08FDZSE073ov
   dr+IA1okk0T5BRCuQGjGYGr/0Lfjpa3HoxusQ+aw7vOqXStzfxYqeECD/
   w==;
X-IronPort-AV: E=Sophos;i="5.97,213,1669100400"; 
   d="scan'208";a="195616560"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2023 01:14:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 13 Jan 2023 01:14:37 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 13 Jan 2023 01:14:33 -0700
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
Subject: [PATCH net-next v3 1/8] net: microchip: vcap api: Erase VCAP cache before encoding rule
Date:   Fri, 13 Jan 2023 09:14:17 +0100
Message-ID: <20230113081424.3505035-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230113081424.3505035-1-steen.hegelund@microchip.com>
References: <20230113081424.3505035-1-steen.hegelund@microchip.com>
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

For consistency the VCAP cache area is erased just before the new rule is
being encoded.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/vcap/vcap_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 664aae3e2acd..b9b6432f4094 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1823,6 +1823,7 @@ int vcap_add_rule(struct vcap_rule *rule)
 	}
 	if (move.count > 0)
 		vcap_move_rules(ri, &move);
+	vcap_erase_cache(ri);
 	ret = vcap_encode_rule(ri);
 	if (ret) {
 		pr_err("%s:%d: rule encoding error: %d\n", __func__, __LINE__, ret);
@@ -1885,7 +1886,6 @@ struct vcap_rule *vcap_alloc_rule(struct vcap_control *vctrl,
 	ri->vctrl = vctrl; /* refer to the client */
 	if (vcap_set_rule_id(ri) == 0)
 		goto out_free;
-	vcap_erase_cache(ri);
 	return (struct vcap_rule *)ri;
 
 out_free:
-- 
2.39.0

