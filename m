Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673205ED8EE
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbiI1J2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbiI1J21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:28:27 -0400
X-Greylist: delayed 464 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Sep 2022 02:28:25 PDT
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63A6DB5E42;
        Wed, 28 Sep 2022 02:28:25 -0700 (PDT)
Received: from localhost.localdomain (unknown [124.16.138.125])
        by APP-01 (Coremail) with SMTP id qwCowAAHp2jZETRjtfiQAg--.16889S2;
        Wed, 28 Sep 2022 17:20:27 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] net: prestera: acl: Add check for kmemdup
Date:   Wed, 28 Sep 2022 17:20:24 +0800
Message-Id: <20220928092024.6996-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: qwCowAAHp2jZETRjtfiQAg--.16889S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWFWktr15Wr4fZr4kKw1Utrb_yoW5KrW5pr
        4IyryYkr1UJr48X397Cw18ZFn8Wa4YqanrKr4kA34furWfGrZ7AryUGF4xursrJF4rXa4I
        qw4Y9w4UuFnxWw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkS14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r4f
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUeLvtDUUUU
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the kemdup could return NULL, it should be better to check the return
value and return error if fails.
Moreover, the return value of prestera_acl_ruleset_keymask_set() should
be checked by cascade.

Fixes: 604ba230902d ("net: prestera: flower template support")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/net/ethernet/marvell/prestera/prestera_acl.c    | 8 ++++++--
 drivers/net/ethernet/marvell/prestera/prestera_acl.h    | 4 ++--
 drivers/net/ethernet/marvell/prestera/prestera_flower.c | 6 +++++-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index 3d4b85f2d541..f6b2933859d0 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -178,10 +178,14 @@ prestera_acl_ruleset_create(struct prestera_acl *acl,
 	return ERR_PTR(err);
 }
 
-void prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
-				      void *keymask)
+int prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
+				     void *keymask)
 {
 	ruleset->keymask = kmemdup(keymask, ACL_KEYMASK_SIZE, GFP_KERNEL);
+	if (!ruleset->keymask)
+		return -ENOMEM;
+
+	return 0;
 }
 
 int prestera_acl_ruleset_offload(struct prestera_acl_ruleset *ruleset)
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
index 03fc5b9dc925..131bfbc87cd7 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
@@ -185,8 +185,8 @@ struct prestera_acl_ruleset *
 prestera_acl_ruleset_lookup(struct prestera_acl *acl,
 			    struct prestera_flow_block *block,
 			    u32 chain_index);
-void prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
-				      void *keymask);
+int prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
+				     void *keymask);
 bool prestera_acl_ruleset_is_offload(struct prestera_acl_ruleset *ruleset);
 int prestera_acl_ruleset_offload(struct prestera_acl_ruleset *ruleset);
 void prestera_acl_ruleset_put(struct prestera_acl_ruleset *ruleset);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index 19d3b55c578e..cf551a8379ac 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -452,7 +452,9 @@ int prestera_flower_tmplt_create(struct prestera_flow_block *block,
 	}
 
 	/* preserve keymask/template to this ruleset */
-	prestera_acl_ruleset_keymask_set(ruleset, rule.re_key.match.mask);
+	err = prestera_acl_ruleset_keymask_set(ruleset, rule.re_key.match.mask);
+	if (err)
+		goto err_ruleset_keymask_set;
 
 	/* skip error, as it is not possible to reject template operation,
 	 * so, keep the reference to the ruleset for rules to be added
@@ -468,6 +470,8 @@ int prestera_flower_tmplt_create(struct prestera_flow_block *block,
 	list_add_rcu(&template->list, &block->template_list);
 	return 0;
 
+err_ruleset_keymask_set:
+	prestera_acl_ruleset_put(ruleset);
 err_ruleset_get:
 	kfree(template);
 err_malloc:
-- 
2.25.1

