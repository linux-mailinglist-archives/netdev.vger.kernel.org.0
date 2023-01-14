Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DFD66ABB3
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 14:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjANNnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 08:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjANNm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 08:42:59 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E74B5277;
        Sat, 14 Jan 2023 05:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673703775; x=1705239775;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CSSQa3dD4gybR3nOez6pDisJkzG2bVCeG3CLX4+Xp4Q=;
  b=laVHcM7ErbSfZF9R3yZWmMuuHwZuDNTXmLqlrD/z8leYXPTCW2vzYmSJ
   Ipu5D0JW9iVMrv3ue5QacUV+l7JkAtldFyTYQSt6R2Tzv0ndLdXQfyvMg
   Dm7GU9qHUVftGOjOHodZeQiyTJ7q0kpjpGrurzH/9DhAX84+WWRSVFjGf
   5q7POkkM7aqc4yVcIg1rmiw/ITK2hoZagfgfYAUeJawdMucSjL46p6XnJ
   mXKszD2jFF7KDGrq8vKH2at+ZDsN8pZadkmVRnJvyyGoNZYzj1/pEDJ2S
   4VSRR5QygGG3ZdJTqnB4L92diFy4FeUsm/FzBrBH5icINQK0avxFynriA
   g==;
X-IronPort-AV: E=Sophos;i="5.97,216,1669100400"; 
   d="scan'208";a="196798566"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jan 2023 06:42:55 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 14 Jan 2023 06:42:53 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Sat, 14 Jan 2023 06:42:50 -0700
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
Subject: [PATCH net-next v4 1/8] net: microchip: vcap api: Erase VCAP cache before encoding rule
Date:   Sat, 14 Jan 2023 14:42:35 +0100
Message-ID: <20230114134242.3737446-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230114134242.3737446-1-steen.hegelund@microchip.com>
References: <20230114134242.3737446-1-steen.hegelund@microchip.com>
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

