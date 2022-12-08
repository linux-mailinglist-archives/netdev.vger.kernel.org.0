Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A3964703F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 13:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiLHM7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 07:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiLHM67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 07:58:59 -0500
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB31281383;
        Thu,  8 Dec 2022 04:58:57 -0800 (PST)
Received: from localhost.localdomain (unknown [124.16.138.125])
        by APP-05 (Coremail) with SMTP id zQCowABHZ8yH35FjhEHKBQ--.43615S2;
        Thu, 08 Dec 2022 20:58:47 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     jiri@resnulli.us
Cc:     leon@kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH net v3] ice: Add check for kzalloc
Date:   Thu,  8 Dec 2022 20:58:47 +0800
Message-Id: <20221208125847.45342-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowABHZ8yH35FjhEHKBQ--.43615S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CrW5uw4Uur4xAFWxKw43GFg_yoW8ZrWrpa
        13JryYyrW8Ar4UWrnxXF1jvFW5uayxJ3409ay3J3sxZF1qyr4rt3WqyryYkr1rGrW2va9x
        tF15AFZrCasFvr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_Xr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
        17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
        C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjfUeWlkDUUUU
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

v2 -> v3:

1. Use "while (i--)" to simplify the code.

v1 -> v2:

1. Use goto-label to share the clean code.
---
 drivers/net/ethernet/intel/ice/ice_gnss.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index b5a7f246d230..90c620c26516 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
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
+	while (i--) {
+		tty_port_destroy(pf->gnss_tty_port[i]);
+		kfree(pf->gnss_tty_port[i]);
+	}
+	kfree(ttydrv_name);
+	tty_driver_kref_put(pf->ice_gnss_tty_driver);
+
+	return NULL;
 }
 
 /**
-- 
2.25.1

