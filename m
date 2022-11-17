Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A9F62E6FB
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240854AbiKQVcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240897AbiKQVbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:31:39 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938A95B5BD;
        Thu, 17 Nov 2022 13:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668720695; x=1700256695;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZUP1oTqr+Bkok+eF/MjSkDF7g/U71BEDzdPwqzWGbIA=;
  b=GZxGkBz+mzHuY7fGQYszL72EJkqSKxpwUt0bWQfo3BKapdopZ/7DpyFD
   nRmOF0/2ZIS9bMYmDW3o90HvqD3x9G+gcaTIMCI6b0ZUv/7b5pOWXQbRh
   xpA5YCIKQoi/U6qplwgjBZykzcWQtH8LGJK8DZKoaDtLztTDUcHC4lzfq
   TfC8I3CrFpCWiBTaZMZDbhM3OCgRAY+sWohuTGqFZDT0N+cxIC/AvkBAq
   OAPfWIAVy0/9+IW4Lk6+RvWxNhr4ag6E+meTcbYfO2pKvYfPqwbXauz9d
   0AM3oZ1zTJONWj7DIrErMGYK//J5Ydp+Xmk8NDqP9Tz1gIzv6A/REvkp8
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="187539404"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Nov 2022 14:31:31 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 17 Nov 2022 14:31:29 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 17 Nov 2022 14:31:25 -0700
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
Subject: [PATCH net-next v2 2/8] net: microchip: sparx5: Ensure VCAP last_used_addr is set back to default
Date:   Thu, 17 Nov 2022 22:31:08 +0100
Message-ID: <20221117213114.699375-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221117213114.699375-1-steen.hegelund@microchip.com>
References: <20221117213114.699375-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

