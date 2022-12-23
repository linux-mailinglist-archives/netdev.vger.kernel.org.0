Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4859B654CE7
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 08:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiLWHhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 02:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiLWHh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 02:37:29 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE97F12A9E;
        Thu, 22 Dec 2022 23:37:28 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso8135666pjt.0;
        Thu, 22 Dec 2022 23:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r0Pq6z8DEwQueVzvyIU52Z0rGP0y+vzxROpohdrh7mI=;
        b=RAmqRIPZVFG60+za8g3yVZgw9P4SgIhwJfXhfqulZWMbOs6uPyJ9qtBHX76U1Es031
         puH5T06b72iVSZtI+e6pAi8jbwNVzKD3JdoRdSZ4ggbM1+WPhsSHQL8CEsOGzzq8KtaI
         9GSdCSetpy/KZuDOcmr17g8dzCrXjrsBlqkWdy4U8p0P74Xh0ybywNEZOJPrFp4B1thZ
         lQ9Sk4ZFv7cPMGvVRl9NCX3GlHE2DxjR8jaXcD8DPh0hYuLGhmR+EdNuvaB80vEO4Kkv
         2l+1MHuJu1iZWrEZnvjlFvb4OsQYpVYXs6s2fTzsnSr5gB8T4MS6cfWTTpgVXI99Ywi/
         pl1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r0Pq6z8DEwQueVzvyIU52Z0rGP0y+vzxROpohdrh7mI=;
        b=eL64kFJGdiTCpsGzhGuZ2OnxonZUnEaK2/EjRWp32DKM5dKhKjJbuKrqxPZdrdiLH4
         YitEbW/nUoskhsT38pJ1zLzYHU3bs5Xa87IGuzZe/+KJ37ndXddfDCT7s9hycboY901x
         va9gApe/DBQObPZ+dVufpGowrbsfJa8oijp1y+RRmX77i3KGHy5mOptsSz95EvO31+tw
         0+8kYal3c0vMCV6UW8hN05bD2qjqye8PuqqTxRdMiVknhtpI39siizZvaKFbR7ZZamfA
         bbMnw8xDBciVHSND7Ddyz3ZZo5RaqiBXAvj23UMLhR5MAyouvsscfSZLd1BUYPacVXpQ
         T9rQ==
X-Gm-Message-State: AFqh2koIVoviWSfHS1dLOE4/+361DiOophRTUBeIK+UdE/jrFD76ZF2D
        OJUaNlR7c//Fg/LDwoBn8tf2ug5f21PbhdaV
X-Google-Smtp-Source: AMrXdXtViVnBAQkGpQMswAlJHl28nSXSKm0k8T07/7Xwq+vshq8fix2zsCDRP/CqdFei98TCgY7plA==
X-Received: by 2002:a17:90a:f614:b0:219:672a:42db with SMTP id bw20-20020a17090af61400b00219672a42dbmr10443032pjb.19.1671781048176;
        Thu, 22 Dec 2022 23:37:28 -0800 (PST)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id qe12-20020a17090b4f8c00b00212cf2fe8c3sm7271669pjb.1.2022.12.22.23.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 23:37:27 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH v2] nfc:  Fix potential resource leaks
Date:   Fri, 23 Dec 2022 11:37:18 +0400
Message-Id: <20221223073718.805935-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nfc_get_device() take reference for the device, add missing
nfc_put_device() to release it when not need anymore.
Also fix the style warnning by use error EOPNOTSUPP instead of
ENOTSUPP.

Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
Fixes: 29e76924cf08 ("nfc: netlink: Add capability to reply to vendor_cmd with data")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
changes in v2:
- rename error to rc.
- add blank line.
v1: https://lore.kernel.org/all/20221220134623.2084443-1-linmq006@gmail.com/
---
 net/nfc/netlink.c | 52 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 9d91087b9399..1fc339084d89 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1497,6 +1497,7 @@ static int nfc_genl_se_io(struct sk_buff *skb, struct genl_info *info)
 	u32 dev_idx, se_idx;
 	u8 *apdu;
 	size_t apdu_len;
+	int rc;
 
 	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
 	    !info->attrs[NFC_ATTR_SE_INDEX] ||
@@ -1510,25 +1511,37 @@ static int nfc_genl_se_io(struct sk_buff *skb, struct genl_info *info)
 	if (!dev)
 		return -ENODEV;
 
-	if (!dev->ops || !dev->ops->se_io)
-		return -ENOTSUPP;
+	if (!dev->ops || !dev->ops->se_io) {
+		rc = -EOPNOTSUPP;
+		goto put_dev;
+	}
 
 	apdu_len = nla_len(info->attrs[NFC_ATTR_SE_APDU]);
-	if (apdu_len == 0)
-		return -EINVAL;
+	if (apdu_len == 0) {
+		rc = -EINVAL;
+		goto put_dev;
+	}
 
 	apdu = nla_data(info->attrs[NFC_ATTR_SE_APDU]);
-	if (!apdu)
-		return -EINVAL;
+	if (!apdu) {
+		rc = -EINVAL;
+		goto put_dev;
+	}
 
 	ctx = kzalloc(sizeof(struct se_io_ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		rc = -ENOMEM;
+		goto put_dev;
+	}
 
 	ctx->dev_idx = dev_idx;
 	ctx->se_idx = se_idx;
 
-	return nfc_se_io(dev, se_idx, apdu, apdu_len, se_io_cb, ctx);
+	rc = nfc_se_io(dev, se_idx, apdu, apdu_len, se_io_cb, ctx);
+
+put_dev:
+	nfc_put_device(dev);
+	return rc;
 }
 
 static int nfc_genl_vendor_cmd(struct sk_buff *skb,
@@ -1551,14 +1564,21 @@ static int nfc_genl_vendor_cmd(struct sk_buff *skb,
 	subcmd = nla_get_u32(info->attrs[NFC_ATTR_VENDOR_SUBCMD]);
 
 	dev = nfc_get_device(dev_idx);
-	if (!dev || !dev->vendor_cmds || !dev->n_vendor_cmds)
+	if (!dev)
 		return -ENODEV;
 
+	if (!dev->vendor_cmds || !dev->n_vendor_cmds) {
+		err = -ENODEV;
+		goto put_dev;
+	}
+
 	if (info->attrs[NFC_ATTR_VENDOR_DATA]) {
 		data = nla_data(info->attrs[NFC_ATTR_VENDOR_DATA]);
 		data_len = nla_len(info->attrs[NFC_ATTR_VENDOR_DATA]);
-		if (data_len == 0)
-			return -EINVAL;
+		if (data_len == 0) {
+			err = -EINVAL;
+			goto put_dev;
+		}
 	} else {
 		data = NULL;
 		data_len = 0;
@@ -1573,10 +1593,14 @@ static int nfc_genl_vendor_cmd(struct sk_buff *skb,
 		dev->cur_cmd_info = info;
 		err = cmd->doit(dev, data, data_len);
 		dev->cur_cmd_info = NULL;
-		return err;
+		goto put_dev;
 	}
 
-	return -EOPNOTSUPP;
+	err = -EOPNOTSUPP;
+
+put_dev:
+	nfc_put_device(dev);
+	return err;
 }
 
 /* message building helper */
-- 
2.25.1

