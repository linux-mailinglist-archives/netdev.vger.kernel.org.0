Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCF8646667
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLHBUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLHBUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:20:01 -0500
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 427C08DFE5;
        Wed,  7 Dec 2022 17:19:59 -0800 (PST)
Received: from localhost.localdomain (unknown [124.16.138.125])
        by APP-05 (Coremail) with SMTP id zQCowAAXfuyqO5FjpT+vBQ--.8312S2;
        Thu, 08 Dec 2022 09:19:38 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     jiri@resnulli.us
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH net v2] ice: Add check for kzalloc
Date:   Thu,  8 Dec 2022 09:19:36 +0800
Message-Id: <20221208011936.47943-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowAAXfuyqO5FjpT+vBQ--.8312S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CrW5uw4Uur4xAFyDuFykXwb_yoW8tF1Dpa
        15JFyjyrW8Ar4UWrnrXF4qvFW5uayxJ340ga9rJ345ZF1qyr1rt3WjkryYyr1rGrW7ZanI
        qF15AFZ7CasFvr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
        628vn2kIc2xKxwCY02Avz4vE14v_KwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
        67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
        IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
        0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
        VjvjDU0xZFpf9x0JUHpB-UUUUU=
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As kzalloc may return NULL pointer, the return value should
be checked and return error if fails in order to avoid the
NULL pointer dereference.
Moreover, use the goto-label to share the clean code.

Fixes: d6b98c8d242a ("ice: add write functionality for GNSS TTY")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
Changelog:

v1 -> v2:

1. Use goto-label to share the clean code.
---
 drivers/net/ethernet/intel/ice/ice_gnss.c | 25 ++++++++++++++---------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index b5a7f246d230..7bd3452a16d2 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -421,7 +421,7 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
 	const int ICE_TTYDRV_NAME_MAX = 14;
 	struct tty_driver *tty_driver;
 	char *ttydrv_name;
-	unsigned int i;
+	unsigned int i, j;
 	int err;
 
 	tty_driver = tty_alloc_driver(ICE_GNSS_TTY_MINOR_DEVICES,
@@ -462,6 +462,9 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
 					       GFP_KERNEL);
 		pf->gnss_serial[i] = NULL;
 
+		if (!pf->gnss_tty_port[i])
+			goto err_out;
+
 		tty_port_init(pf->gnss_tty_port[i]);
 		tty_port_link_device(pf->gnss_tty_port[i], tty_driver, i);
 	}
@@ -469,21 +472,23 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
 	err = tty_register_driver(tty_driver);
 	if (err) {
 		dev_err(dev, "Failed to register TTY driver err=%d\n", err);
-
-		for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++) {
-			tty_port_destroy(pf->gnss_tty_port[i]);
-			kfree(pf->gnss_tty_port[i]);
-		}
-		kfree(ttydrv_name);
-		tty_driver_kref_put(pf->ice_gnss_tty_driver);
-
-		return NULL;
+		goto err_out;
 	}
 
 	for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++)
 		dev_info(dev, "%s%d registered\n", ttydrv_name, i);
 
 	return tty_driver;
+
+err_out:
+	for (j = 0; j < i; j++) {
+		tty_port_destroy(pf->gnss_tty_port[j]);
+		kfree(pf->gnss_tty_port[j]);
+	}
+	kfree(ttydrv_name);
+	tty_driver_kref_put(pf->ice_gnss_tty_driver);
+
+	return NULL;
 }
 
 /**
-- 
2.25.1

