Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D51F5308BF
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 07:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240056AbiEWF33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 01:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355608AbiEWF3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 01:29:09 -0400
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 566302127D;
        Sun, 22 May 2022 22:28:39 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [124.236.130.193])
        by mail-app2 (Coremail) with SMTP id by_KCgDHeAhqG4tiw6+eAA--.65502S2;
        Mon, 23 May 2022 13:28:19 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-wireless@vger.kernel.org
Cc:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH v3] mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv
Date:   Mon, 23 May 2022 13:28:10 +0800
Message-Id: <20220523052810.24767-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgDHeAhqG4tiw6+eAA--.65502S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZw4rJrW3Kr4xZFyrJFWDArb_yoW5Gr4xpw
        s8KF92vFW8Krs5ZayDJa1vg3W5K3W8Ary7CFsF9w1rGas3J3yfZrWYkFyS9rs5X3s2yFW2
        qF45Zw13CF9rtFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
        JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_GrWl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
        17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
        C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjfUOb18DUUUU
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgISAVZdtZ0biwAysS
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are sleep in atomic context bugs when uploading device dump
data in mwifiex. The root cause is that dev_coredumpv could not
be used in atomic contexts, because it calls dev_set_name which
include operations that may sleep. The call tree shows execution
paths that could lead to bugs:

   (Interrupt context)
fw_dump_timer_fn
  mwifiex_upload_device_dump
    dev_coredumpv(..., GFP_KERNEL)
      dev_coredumpm()
        kzalloc(sizeof(*devcd), gfp); //may sleep
        dev_set_name
          kobject_set_name_vargs
            kvasprintf_const(GFP_KERNEL, ...); //may sleep
            kstrdup(s, GFP_KERNEL); //may sleep

In order to let dev_coredumpv support atomic contexts, this patch
changes the gfp_t parameter of kvasprintf_const and kstrdup in
kobject_set_name_vargs from GFP_KERNEL to GFP_ATOMIC. What's more,
In order to mitigate bug, this patch changes the gfp_t parameter
of dev_coredumpv from GFP_KERNEL to GFP_ATOMIC.

Fixes: 57670ee882d4 ("mwifiex: device dump support via devcoredump framework")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in v3:
  - Let dev_coredumpv support atomic contexts.

 drivers/net/wireless/marvell/mwifiex/main.c | 2 +-
 lib/kobject.c                               | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index ace7371c477..258906920a2 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1116,7 +1116,7 @@ void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter)
 	mwifiex_dbg(adapter, MSG,
 		    "== mwifiex dump information to /sys/class/devcoredump start\n");
 	dev_coredumpv(adapter->dev, adapter->devdump_data, adapter->devdump_len,
-		      GFP_KERNEL);
+		      GFP_ATOMIC);
 	mwifiex_dbg(adapter, MSG,
 		    "== mwifiex dump information to /sys/class/devcoredump end\n");
 
diff --git a/lib/kobject.c b/lib/kobject.c
index 5f0e71ab292..7672c54944c 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -254,7 +254,7 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 	if (kobj->name && !fmt)
 		return 0;
 
-	s = kvasprintf_const(GFP_KERNEL, fmt, vargs);
+	s = kvasprintf_const(GFP_ATOMIC, fmt, vargs);
 	if (!s)
 		return -ENOMEM;
 
@@ -267,7 +267,7 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 	if (strchr(s, '/')) {
 		char *t;
 
-		t = kstrdup(s, GFP_KERNEL);
+		t = kstrdup(s, GFP_ATOMIC);
 		kfree_const(s);
 		if (!t)
 			return -ENOMEM;
-- 
2.17.1

