Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312AB63D842
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiK3Ocu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiK3OcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:32:22 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9801481396;
        Wed, 30 Nov 2022 06:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669818725; x=1701354725;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5bmNXCaH4WkjF1B9qtqchebaca/+53Y+sh38HZJtfrI=;
  b=pxV5vUXdrCpz5SwtXyV1uqLc0eziqE5diAjIpH4IgQ6RAuiOdrScyitF
   /q+ZF0KG2BSrQOj9uiBY8/beyN0aQxX7xjFwDynhTm4CAOlH6XHhtFxRU
   EhNKdxs8b7QmhpJ3A606iNrXZmB8RYgbJGl1Fzmm9dfjErd1ASFGOpSme
   H4RcieAk+Lqky5JYg5dDs/QDIcrpyxBTgAnREQ7RutsinEEAG0zonxkiC
   ccUWaqMDjf80l7EkijKh3ep/HVbN12vMN03nqoixniPinp6fmv7gwS8hf
   e1id1uzsHV6GIRpneb3Dx5XBHDfBTQe18tbfiWDGYaMOAGxZVih0IjI20
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="191144791"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2022 07:30:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 30 Nov 2022 07:30:34 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 30 Nov 2022 07:30:32 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/4] net: microchip: vcap: Add vcap_mod_rule
Date:   Wed, 30 Nov 2022 15:35:23 +0100
Message-ID: <20221130143525.934906-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221130143525.934906-1-horatiu.vultur@microchip.com>
References: <20221130143525.934906-1-horatiu.vultur@microchip.com>
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

Add the function vcap_mod_rule which allows to update an existing rule
in the vcap. It is required for the rule to exist in the vcap to be able
to modify it.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    | 36 +++++++++++++++++++
 .../ethernet/microchip/vcap/vcap_api_client.h |  2 ++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 27128313f15f1..eae4e9fe0e147 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1955,6 +1955,42 @@ struct vcap_rule *vcap_get_rule(struct vcap_control *vctrl, u32 id)
 }
 EXPORT_SYMBOL_GPL(vcap_get_rule);
 
+/* Update existing rule */
+int vcap_mod_rule(struct vcap_rule *rule)
+{
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	struct vcap_counter ctr;
+	int err;
+
+	err = vcap_api_check(ri->vctrl);
+	if (err)
+		return err;
+
+	if (!vcap_lookup_rule(ri->vctrl, ri->data.id))
+		return -ENOENT;
+
+	mutex_lock(&ri->admin->lock);
+	/* Encode the bitstreams to the VCAP cache */
+	vcap_erase_cache(ri);
+	err = vcap_encode_rule(ri);
+	if (err)
+		goto out;
+
+	err = vcap_write_rule(ri);
+	if (err)
+		goto out;
+
+	memset(&ctr, 0, sizeof(ctr));
+	err =  vcap_write_counter(ri, &ctr);
+	if (err)
+		goto out;
+
+out:
+	mutex_unlock(&ri->admin->lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(vcap_mod_rule);
+
 /* Return the alignment offset for a new rule address */
 static int vcap_valid_rule_move(struct vcap_rule_internal *el, int offset)
 {
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index a354dcd741e22..fdfc5d58813bb 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -172,6 +172,8 @@ int vcap_del_rule(struct vcap_control *vctrl, struct net_device *ndev, u32 id);
 struct vcap_rule *vcap_copy_rule(struct vcap_rule *rule);
 /* Get rule from a VCAP instance */
 struct vcap_rule *vcap_get_rule(struct vcap_control *vctrl, u32 id);
+/* Update existing rule */
+int vcap_mod_rule(struct vcap_rule *rule);
 
 /* Update the keyset for the rule */
 int vcap_set_rule_set_keyset(struct vcap_rule *rule,
-- 
2.38.0

