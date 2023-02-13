Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBEC6940F1
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjBMJZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjBMJZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:25:00 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96A014EAF;
        Mon, 13 Feb 2023 01:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676280298; x=1707816298;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YV62iu9/O8cBsP3qS4XjVw4K1ZerXtPbvNDExU2QIF8=;
  b=OYk2pf8YvMCcFuz5HyKIUhGTt5ZdcVVFkZdlBmO08swe491APS11b4TL
   VsheyhbJKbZ1GU19Sgy54aUaG2/k7/4cMzE1IwqrHAYjkKJ6gqUjNVK7J
   AczE+9lar238EYEsL/S0krAxANNbA6C+IaTNHuQFlsKgHgnTtwAA24K/2
   NWmpr+o28c/5+WXNwCH4EPBhmAvyz4Zf2cMKC2mXbAicWvhJEM3oM4ixG
   k9BH9w2zo9xssmeWJB5MefhygCaDMQVr3Km58bhB0DzYhm6vW7aR6FFpf
   pR5CEUlrN5eE9g7Fn+UP4yQYaZSusXsrqA8J+rZVrD4J5e6vT57aWO78V
   A==;
X-IronPort-AV: E=Sophos;i="5.97,293,1669100400"; 
   d="scan'208";a="196611584"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Feb 2023 02:24:52 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 02:24:50 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 02:24:47 -0700
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
Subject: [PATCH net-next 04/10] net: microchip: sparx5: Use chain ids without offsets when enabling rules
Date:   Mon, 13 Feb 2023 10:24:20 +0100
Message-ID: <20230213092426.1331379-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213092426.1331379-1-steen.hegelund@microchip.com>
References: <20230213092426.1331379-1-steen.hegelund@microchip.com>
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

This improves the check performed on linked rules when enabling or
disabling them.  The chain id used must be the chain id without the offset
used for linking the rules.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    | 21 ++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 68e04d47f6fd..9ca0cb855c3c 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1568,6 +1568,18 @@ static int vcap_write_counter(struct vcap_rule_internal *ri,
 	return 0;
 }
 
+/* Return the chain id rounded down to nearest lookup */
+static int vcap_round_down_chain(int cid)
+{
+	return cid - (cid % VCAP_CID_LOOKUP_SIZE);
+}
+
+/* Return the chain id rounded up to nearest lookup */
+static int vcap_round_up_chain(int cid)
+{
+	return vcap_round_down_chain(cid + VCAP_CID_LOOKUP_SIZE);
+}
+
 /* Convert a chain id to a VCAP lookup index */
 int vcap_chain_id_to_lookup(struct vcap_admin *admin, int cur_cid)
 {
@@ -1650,9 +1662,7 @@ bool vcap_is_next_lookup(struct vcap_control *vctrl, int src_cid, int dst_cid)
 		return false;
 
 	/* The offset must be at least one lookup, round up */
-	next_cid = src_cid + VCAP_CID_LOOKUP_SIZE;
-	next_cid /= VCAP_CID_LOOKUP_SIZE;
-	next_cid *= VCAP_CID_LOOKUP_SIZE;
+	next_cid = vcap_round_up_chain(src_cid);
 
 	if (dst_cid < next_cid)
 		return false;
@@ -2177,12 +2187,13 @@ static int vcap_get_next_chain(struct vcap_control *vctrl,
 static bool vcap_path_exist(struct vcap_control *vctrl, struct net_device *ndev,
 			    int dst_cid)
 {
+	int cid = vcap_round_down_chain(dst_cid);
 	struct vcap_enabled_port *eport = NULL;
 	struct vcap_enabled_port *elem;
 	struct vcap_admin *admin;
 	int tmp;
 
-	if (dst_cid == 0) /* Chain zero is always available */
+	if (cid == 0) /* Chain zero is always available */
 		return true;
 
 	/* Find first entry that starts from chain 0*/
@@ -2201,7 +2212,7 @@ static bool vcap_path_exist(struct vcap_control *vctrl, struct net_device *ndev,
 		return false;
 
 	tmp = eport->dst_cid;
-	while (tmp != dst_cid && tmp != 0)
+	while (tmp != cid && tmp != 0)
 		tmp = vcap_get_next_chain(vctrl, ndev, tmp);
 
 	return !!tmp;
-- 
2.39.1

