Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021CC4862A3
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 11:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237543AbiAFKEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 05:04:37 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:50014 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236677AbiAFKEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 05:04:36 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-05 (Coremail) with SMTP id zQCowADHpxScvtZhVC62BQ--.57808S2;
        Thu, 06 Jan 2022 18:04:12 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] fsl/fman: Check for null pointer after calling devm_ioremap
Date:   Thu,  6 Jan 2022 18:04:10 +0800
Message-Id: <20220106100410.2761573-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowADHpxScvtZhVC62BQ--.57808S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXFWfur43CF13urWrZr4kXrb_yoW5Ar1xpa
        1F9ayUta4DJrn8uF4DX3ykAr45Aw48t3y8KFW8tw4Fq3W7twn3XFW8GFW8AryYqFZ5Jr15
        JrZ8Aa1UCF1ak37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_Gw1l
        42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
        WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAK
        I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r
        4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
        42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUjhL0UUUUU
        U==
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the possible failure of the allocation, the devm_ioremap() may return
NULL pointer.
Take tgec_initialization() as an example.
If allocation fails, the params->base_addr will be NULL pointer and will
be assigned to tgec->regs in tgec_config().
Then it will cause the dereference of NULL pointer in set_mac_address(),
which is called by tgec_init().
Therefore, it should be better to add the sanity check after the calling
of the devm_ioremap().

Fixes: 3933961682a3 ("fsl/fman: Add FMan MAC driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/net/ethernet/freescale/fman/mac.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 46ecb42f2ef8..6cf00569bd20 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -94,14 +94,17 @@ static void mac_exception(void *handle, enum fman_mac_exceptions ex)
 		__func__, ex);
 }
 
-static void set_fman_mac_params(struct mac_device *mac_dev,
-				struct fman_mac_params *params)
+static int set_fman_mac_params(struct mac_device *mac_dev,
+			       struct fman_mac_params *params)
 {
 	struct mac_priv_s *priv = mac_dev->priv;
 
 	params->base_addr = (typeof(params->base_addr))
 		devm_ioremap(priv->dev, mac_dev->res->start,
 			     resource_size(mac_dev->res));
+	if (!params->base_addr)
+		return -ENOMEM;
+
 	memcpy(&params->addr, mac_dev->addr, sizeof(mac_dev->addr));
 	params->max_speed	= priv->max_speed;
 	params->phy_if		= mac_dev->phy_if;
@@ -112,6 +115,8 @@ static void set_fman_mac_params(struct mac_device *mac_dev,
 	params->event_cb	= mac_exception;
 	params->dev_id		= mac_dev;
 	params->internal_phy_node = priv->internal_phy_node;
+
+	return 0;
 }
 
 static int tgec_initialization(struct mac_device *mac_dev)
@@ -123,7 +128,9 @@ static int tgec_initialization(struct mac_device *mac_dev)
 
 	priv = mac_dev->priv;
 
-	set_fman_mac_params(mac_dev, &params);
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
 
 	mac_dev->fman_mac = tgec_config(&params);
 	if (!mac_dev->fman_mac) {
@@ -169,7 +176,9 @@ static int dtsec_initialization(struct mac_device *mac_dev)
 
 	priv = mac_dev->priv;
 
-	set_fman_mac_params(mac_dev, &params);
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
 
 	mac_dev->fman_mac = dtsec_config(&params);
 	if (!mac_dev->fman_mac) {
@@ -218,7 +227,9 @@ static int memac_initialization(struct mac_device *mac_dev)
 
 	priv = mac_dev->priv;
 
-	set_fman_mac_params(mac_dev, &params);
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
 
 	if (priv->max_speed == SPEED_10000)
 		params.phy_if = PHY_INTERFACE_MODE_XGMII;
-- 
2.25.1

