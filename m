Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F21562B5C5
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 09:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238214AbiKPI6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 03:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbiKPI6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 03:58:04 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5906D62E3;
        Wed, 16 Nov 2022 00:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668589084; x=1700125084;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZUP1oTqr+Bkok+eF/MjSkDF7g/U71BEDzdPwqzWGbIA=;
  b=JTSztSChs4YeHoCK+7QgbqpqWSaDm5mBsOpKhWOP4eJx6biyQ79lqLeJ
   8VBKoJDNjZsA9Go8ReIg5H3CoN3D5M53SrmHL7T98aMMHEYll+kwxURsl
   3IeAiFcVxeJNUJK8EX0WwPlw1bBgXXTkmcdLw2AHl4EDcY6DrnAWHHw6V
   Us/VZ7b7FeCSE8/L+HdS72Cau0YNzDJSJqGXduUaErUTk+wBRpTNHj3YR
   D+hMcHH939hZOonPHvjfwW562TQ3QmmWtPD6Bn3QiwWHVUwRaezaKhkwM
   0T6j/B392+6IF7H3AKPd9yiVRFX0t1zfnC6vU+g+8RDnfKH6OOWqs7VVq
   w==;
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="189220559"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Nov 2022 01:58:03 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 16 Nov 2022 01:58:02 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 16 Nov 2022 01:57:59 -0700
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
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next 2/8] net: microchip: sparx5: Ensure VCAP last_used_addr is set back to default
Date:   Wed, 16 Nov 2022 09:57:41 +0100
Message-ID: <20221116085747.3810427-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116085747.3810427-1-steen.hegelund@microchip.com>
References: <20221116085747.3810427-1-steen.hegelund@microchip.com>
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

This ensures that the last_used_addr in a VCAP instance is returned to the
default value when all rules have been deleted.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/vcap/vcap_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index d12c8ec40fe2..24f4ea1eacb3 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1249,9 +1249,9 @@ int vcap_del_rule(struct vcap_control *vctrl, struct net_device *ndev, u32 id)
 	vctrl->ops->init(ndev, admin, admin->last_used_addr, ri->size + gap);
 	kfree(ri);
 
-	/* Update the last used address */
+	/* Update the last used address, set to default when no rules */
 	if (list_empty(&admin->rules)) {
-		admin->last_used_addr = admin->last_valid_addr;
+		admin->last_used_addr = admin->last_valid_addr + 1;
 	} else {
 		elem = list_last_entry(&admin->rules, struct vcap_rule_internal,
 				       list);
-- 
2.38.1

