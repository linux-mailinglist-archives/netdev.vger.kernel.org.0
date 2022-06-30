Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA49F562518
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbiF3V1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237383AbiF3V13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:27:29 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9548D2C644;
        Thu, 30 Jun 2022 14:27:28 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id cf14so526748edb.8;
        Thu, 30 Jun 2022 14:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xwFag/8dD9IbF/CnQDYyQibGAMvtrP+argkacsTtWyA=;
        b=c6F7SPIBvZxuDf5DQh6bLbiCsnJEu9ZJgBpILntm10WfLxUfKHfF8e3yUt3C4xV+EG
         xve3lphmmuAiuYM5tkI766IJJ4RJKCOb141J8QGJh8tahssi5qZcQSY1kpE80ADTiQRl
         p9MS83pu8r7QuqBBTIzXwZdxUiy2KkHsIYKc8/CRgQTUZiTWFJdpdqj+Ol/8d4O2ZToz
         W1BS1mVrOdXJTqxfO06sFsb3EoD43U4Z/Eogl/HF07GFs41SyW/9jLQ505jMB185QNS3
         fp2M0yHlZgNORm/hFfMNYf42fbDYI4Y4ApmbmIsOdygm/QwtkJXuaZP9fE8aA8nFtgtw
         0KOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xwFag/8dD9IbF/CnQDYyQibGAMvtrP+argkacsTtWyA=;
        b=pqtmzculiZutJj8X6yEo5pidSqxLyI2eyrZBK4cN7X8haVzMYl1IN2bwoxOUKPLqbx
         8yRI/tTD1u9/6DrFkXNUQDtG10dPuhWlkMlDfcD3WIKAz9qfhkl0quWTYQ5q0332gEod
         Cgfi0TBlUjdVoriHNF1UlJkhWxsCXQ+M21gYUsrbJmqWBzLr3JWAA7LaCtSuCUV2lj9p
         P6CqLVVJPHWZjCkn41DrkVHT+5o6aEg39sNLv/RPV5rMLUzenhLIXcSdrRTGdiKGb1l1
         nEpdiCpbqHQINyidRBy202jtvGqcg1C6ynY0NW+9jVXcDPUjyRHPTXU1z34gCG/rZr9Q
         imGQ==
X-Gm-Message-State: AJIora/4JohFrSZER+5p5uJz8xaRXo7odrtq0gk+xwfUB31LbBIEfw6c
        uaPiyBptEWcquT2qSb+/FYQ=
X-Google-Smtp-Source: AGRyM1vXN3EgMlYBg+rl9Vt5tDnm/JV/8GAp02bbjgtXFlMB0v+gDe6RoAOMsSmbYiMOuMzMFsDgKw==
X-Received: by 2002:a05:6402:3785:b0:435:5d0e:2a2e with SMTP id et5-20020a056402378500b004355d0e2a2emr14829034edb.307.1656624447134;
        Thu, 30 Jun 2022 14:27:27 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4e7-0400-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4e7:400::e63])
        by smtp.googlemail.com with ESMTPSA id m9-20020a509989000000b004355d27799fsm14159078edb.96.2022.06.30.14.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 14:27:26 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hauke@hauke-m.de, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        stable@vger.kernel.org
Subject: [PATCH net v1] net: dsa: lantiq_gswip: Fix FDB add/remove on the CPU port
Date:   Thu, 30 Jun 2022 23:27:03 +0200
Message-Id: <20220630212703.3280485-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no bridge available when adding or removing a static FDB entry
for (towards) the CPU port. This is intentional because the CPU port is
always considered standalone, even if technically for the GSWIP driver
it's part of every bridge.

Handling FDB add/remove on the CPU port fixes the following message
during boot in OpenWrt:
  port 4 failed to add <LAN MAC address> vid 1 to fdb: -22
as well as the following message during system shutdown:
  port 4 failed to delete <LAN MAC address> vid 1 from fdb: -22

Use FID 0 (which is also the "default" FID) when adding/removing an FDB
entry for the CPU port. Testing with a BT Home Hub 5A shows that this
"default" FID works as expected:
- traffic from/to LAN (ports in a bridge) is not seen on the WAN port
  (standalone port)
- traffic from/to the WAN port (standalone port) is not seen on the LAN
  (ports in a bridge) ports
- traffic from/to LAN is not seen on another LAN port with a different
  VLAN
- traffic from/to one LAN port to another is still seen

Fixes: 58c59ef9e930c4 ("net: dsa: lantiq: Add Forwarding Database access")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
This patch is "minimalistic" on purpose: the goal is to have it
backported to Linux 5.15. Linux 5.15 doesn't have
dsa_fdb_present_in_other_db() or struct dsa_db yet. Once this patch has
been accepted I will work on implementing FDB isolation for the Lantiq
GSWIP driver.

Hauke, I hope I considered all test-cases which you find relevant. If not
then please let me know.


 drivers/net/dsa/lantiq_gswip.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index e531b93f3cb2..9dab28903af0 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1365,19 +1365,26 @@ static int gswip_port_fdb(struct dsa_switch *ds, int port,
 	int i;
 	int err;
 
-	if (!bridge)
-		return -EINVAL;
-
-	for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
-		if (priv->vlans[i].bridge == bridge) {
-			fid = priv->vlans[i].fid;
-			break;
+	if (bridge) {
+		for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
+			if (priv->vlans[i].bridge == bridge) {
+				fid = priv->vlans[i].fid;
+				break;
+			}
 		}
-	}
 
-	if (fid == -1) {
-		dev_err(priv->dev, "Port not part of a bridge\n");
-		return -EINVAL;
+		if (fid == -1) {
+			dev_err(priv->dev, "Port not part of a bridge\n");
+			return -EINVAL;
+		}
+	} else if (dsa_is_cpu_port(ds, port)) {
+		/* Use FID 0 which is the "default" and used as fallback. This
+		 * is not used by any standalone port or a bridge, so we can
+		 * safely use it for the CPU port.
+		 */
+		fid = 0;
+	} else {
+		return -EOPNOTSUPP;
 	}
 
 	mac_bridge.table = GSWIP_TABLE_MAC_BRIDGE;
-- 
2.37.0

