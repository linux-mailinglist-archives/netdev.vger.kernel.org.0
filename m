Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7986DB999
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 10:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjDHIUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 04:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjDHIUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 04:20:47 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.215])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9105ED530;
        Sat,  8 Apr 2023 01:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=q88BU
        pvmZ6iY8iv/Jnzwzgvp9hI37+33vq+2lKikbco=; b=dAVf0/BULyVNAFIhUE7HC
        di4oMruLhZzo1nqJ3A+RfsZthCYWrZBSY4GNYRt8iTbEXusMBH0un0/Q3IIrIH4L
        pJv3uCJPc2v8q6Ucgz7/W5dOJYtId50W0zPdAa0ugRBV7oCDBey81qxEDVQREg+X
        QoAPTCq57un0Gdq2IM1v90=
Received: from localhost.localdomain (unknown [106.39.149.90])
        by zwqz-smtp-mta-g2-4 (Coremail) with SMTP id _____wDHhM2iIzFkqZh8Aw--.62148S2;
        Sat, 08 Apr 2023 16:19:47 +0800 (CST)
From:   Chen Aotian <chenaotian2@163.com>
To:     alex.aring@gmail.com
Cc:     stefan@datenfreihafen.org, miquel.raynal@bootlin.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Chen Aotian <chenaotian2@163.com>
Subject: [PATH wpan v2] ieee802154: hwsim: Fix possible memory leaks
Date:   Sat,  8 Apr 2023 16:19:34 +0800
Message-Id: <20230408081934.54002-1-chenaotian2@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wDHhM2iIzFkqZh8Aw--.62148S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zw4DAF1UJw4UuF48XF17trb_yoW8Wr1fpF
        Wj9asIyr48tF1xW3yDCw4kAa4Sqayru348urWfKa9xZ3W2qr409r17GF1Svr45JrZ7C3WS
        yF4qqrnIvw1DArDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j1eHgUUUUU=
X-Originating-IP: [106.39.149.90]
X-CM-SenderInfo: xfkh0tprwlt0qs6rljoofrz/xtbBEQZLwFaENWcJDwAAsa
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After replacing e->info, it is necessary to free the old einfo.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Chen Aotian <chenaotian2@163.com>
---

V1 -> V2:
* Using rcu_replace_pointer() is better then rcu_dereference()
  and rcu_assign_pointer().

 drivers/net/ieee802154/mac802154_hwsim.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 8445c2189..6ffcadb9d 100644
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
-			rcu_assign_pointer(e->info, einfo);
+			einfo_old = rcu_replace_pointer(e->info, einfo,
+							lock_is_held(&hwsim_phys_lock));
 			rcu_read_unlock();
+			kfree_rcu(einfo_old, rcu);
 			mutex_unlock(&hwsim_phys_lock);
 			return 0;
 		}
-- 
2.25.1

