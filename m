Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296146DAB1D
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 11:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbjDGJyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 05:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDGJyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 05:54:23 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 11746768B;
        Fri,  7 Apr 2023 02:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=zJolQ
        blrxXHCVLgO+nyEt5osyAW11cJMN5/d/Sc4rB4=; b=IvfXaWUKgUwFKTmCUmSKa
        zUnhtlQXdhbOK8pM2YSfVBUmro+fEU+1xbu+V7iB60t8sKF9KEDxMBvF/DNekQzK
        vKXwYMojyp8aGeHPCMraIKsvYNem8H22WBPWZgq+uvwMk7FwN9kllPHufLJ9iSWQ
        SHsbHEZNiMgpWAwuP3xW8g=
Received: from localhost.localdomain (unknown [119.3.119.19])
        by zwqz-smtp-mta-g1-3 (Coremail) with SMTP id _____wCnvzcM6C9k6kc8Aw--.29059S2;
        Fri, 07 Apr 2023 17:53:17 +0800 (CST)
From:   Chen Aotian <chenaotian2@163.com>
To:     alex.aring@gmail.com
Cc:     stefan@datenfreihafen.org, miquel.raynal@bootlin.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernelorg, Chen Aotian <chenaotian2@163.com>
Subject: [PATCH] ieee802154: hwsim: Fix possible memory leaks
Date:   Fri,  7 Apr 2023 17:53:01 +0800
Message-Id: <20230407095301.45858-1-chenaotian2@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wCnvzcM6C9k6kc8Aw--.29059S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zw4DAF1UGr4fJr48uFWUtwb_yoW8GryrpF
        Wjv3sIyr48tr18W3yDGw4kAa4Svayru348ur1fKa93ZFyIqrW09rnrGF1ayr4YyrZrCa4f
        AF4qqrnIvwn8CrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UEApbUUUUU=
X-Originating-IP: [119.3.119.19]
X-CM-SenderInfo: xfkh0tprwlt0qs6rljoofrz/1tbiRRFKwGDuzVHaEAAAsG
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After replacing e->info, it is necessary to free the old einfo.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: Chen Aotian <chenaotian2@163.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 8445c2189..6e7e10b17 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -685,7 +685,7 @@ static int hwsim_del_edge_nl(struct sk_buff *msg, struct genl_info *info)
 static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *info)
 {
 	struct nlattr *edge_attrs[MAC802154_HWSIM_EDGE_ATTR_MAX + 1];
-	struct hwsim_edge_info *einfo;
+	struct hwsim_edge_info *einfo, *einfo_old;
 	struct hwsim_phy *phy_v0;
 	struct hwsim_edge *e;
 	u32 v0, v1;
@@ -723,8 +723,10 @@ static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *info)
 	list_for_each_entry_rcu(e, &phy_v0->edges, list) {
 		if (e->endpoint->idx == v1) {
 			einfo->lqi = lqi;
+			einfo_old = rcu_dereference(e->info);
 			rcu_assign_pointer(e->info, einfo);
 			rcu_read_unlock();
+			kfree_rcu(einfo_old, rcu);
 			mutex_unlock(&hwsim_phys_lock);
 			return 0;
 		}
-- 
2.25.1

