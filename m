Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F665F03EA
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 06:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiI3EwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 00:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiI3EwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 00:52:02 -0400
Received: from cstnet.cn (smtp23.cstnet.cn [159.226.251.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8074C79EDE;
        Thu, 29 Sep 2022 21:51:25 -0700 (PDT)
Received: from localhost.localdomain (unknown [124.16.138.125])
        by APP-03 (Coremail) with SMTP id rQCowABXCVksdTZjYwKKAg--.3946S2;
        Fri, 30 Sep 2022 12:48:44 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     vmytnyk@marvell.com, davem@davemloft.net, tchornyi@marvell.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] net: prestera: acl: Add check for kmemdup
Date:   Fri, 30 Sep 2022 12:48:43 +0800
Message-Id: <20220930044843.32647-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowABXCVksdTZjYwKKAg--.3946S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWFWktr15Wr4fZr4kKw1Utrb_yoW5KrW5pr
        4IyryYkr1UJr48X397Cw18ZFn8Wa4YqanrKr4kA34furWfGrZ7AryUGF4xursrJF4rXa4I
        qw4Y9w4UuFnxWw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkq14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
        1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8
        XwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
        1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
        64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
        0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
        0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUjGYLDUUUUU==
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

