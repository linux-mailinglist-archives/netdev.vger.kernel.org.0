Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34886521AA
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 14:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiLTNqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 08:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiLTNqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 08:46:34 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C523F63EC;
        Tue, 20 Dec 2022 05:46:33 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id o12so12435830pjo.4;
        Tue, 20 Dec 2022 05:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5Mi7AIDjIfOPqR55AXqe7e5c1t5p7e8HTIfmStCSqNY=;
        b=P6YimTcI2NVjm/mvcgxx18QsOM1+dHBvOSjKI93SRuLwCpScJWDzm6HFdRXPVws3kt
         xnjcAi7spd5cggU61SRWtHYwXivJt36PSFsK4UZIOYR3vxR2PJv1m7EseZEsr1MwSeyR
         XkwrWS2GVBKSoYxXglpUGSC5Bi4OfPvNXc3betVtb4vO834YQud+VxehHyB7cgCzj3yV
         B8up0ukIu7ncgfM9LxOqRxPpQO1kmH43557vrM1pmjukDp056u0/dVCFSYoC6QFwj0iy
         O/VhFXR2BC84ysL4hillKM5RED6mJFG8+lmD1EEqebEjEk7VWEuDV90PDTd+dPXDEaa7
         E9Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Mi7AIDjIfOPqR55AXqe7e5c1t5p7e8HTIfmStCSqNY=;
        b=yUXDe5z388FyDxVpnwrM4GhUGlICI3hzNBbXikPbCxzgU3HqOBz0kliFbFmtGx0Zy8
         OQsTu/V3AWn7Pkg5dQchT+rP8TakKusr4JarK+ACxt0HctATJs4b1dIm04alXgCesTVy
         XeX6f6edgC0b1uz9LAiNZLinxlsoAOGwE4wwa6olEgjxNUVnsY8pY9HviG6KVSfTK+ve
         QRdAG60lFYxwc42n+M/Qi6j0AW8gPytuzhBwWnxtz3Ghcoeuw7nHFuPw2eb4davKBINZ
         Su042Ikfl8trwZk05pR4z+ohNEA5npXuy/0nnsyB0H0ZVe5Urx5J/ULyBcd2yIxbUG2W
         y/Sw==
X-Gm-Message-State: ANoB5pm3pA59C/MdSC/mhgtevkXPfkkU5K5b2O76rRBMNbcNd9ycoPIi
        m0IEznu9OqKHmS8lE6gzNxmx2zNLgZP5IFXu
X-Google-Smtp-Source: AA0mqf4bKfQ4hJWTxJTdgYW0ASN+Dg3qXnbmwgc0jSy6lzMXH1MGqGef3ajpTAxnifUdCQ2NHmYVvA==
X-Received: by 2002:a17:90a:420f:b0:219:4793:2979 with SMTP id o15-20020a17090a420f00b0021947932979mr48117302pjg.22.1671543993339;
        Tue, 20 Dec 2022 05:46:33 -0800 (PST)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id on16-20020a17090b1d1000b0020b21019086sm1519598pjb.3.2022.12.20.05.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 05:46:32 -0800 (PST)
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
Subject: [PATCH] nfc:  Fix potential resource leaks
Date:   Tue, 20 Dec 2022 17:46:23 +0400
Message-Id: <20221220134623.2084443-1-linmq006@gmail.com>
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
 net/nfc/netlink.c | 51 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 9d91087b9399..d081beaf4828 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1497,6 +1497,7 @@ static int nfc_genl_se_io(struct sk_buff *skb, struct genl_info *info)
 	u32 dev_idx, se_idx;
 	u8 *apdu;
 	size_t apdu_len;
+	int error;
 
 	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
 	    !info->attrs[NFC_ATTR_SE_INDEX] ||
@@ -1510,25 +1511,37 @@ static int nfc_genl_se_io(struct sk_buff *skb, struct genl_info *info)
 	if (!dev)
 		return -ENODEV;
 
-	if (!dev->ops || !dev->ops->se_io)
-		return -ENOTSUPP;
+	if (!dev->ops || !dev->ops->se_io) {
+		error = -EOPNOTSUPP;
+		goto put_dev;
+	}
 
 	apdu_len = nla_len(info->attrs[NFC_ATTR_SE_APDU]);
-	if (apdu_len == 0)
-		return -EINVAL;
+	if (apdu_len == 0) {
+		error = -EINVAL;
+		goto put_dev;
+	}
 
 	apdu = nla_data(info->attrs[NFC_ATTR_SE_APDU]);
-	if (!apdu)
-		return -EINVAL;
+	if (!apdu) {
+		error = -EINVAL;
+		goto put_dev;
+	}
 
 	ctx = kzalloc(sizeof(struct se_io_ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		error = -ENOMEM;
+		goto put_dev;
+	}
 
 	ctx->dev_idx = dev_idx;
 	ctx->se_idx = se_idx;
 
-	return nfc_se_io(dev, se_idx, apdu, apdu_len, se_io_cb, ctx);
+	error = nfc_se_io(dev, se_idx, apdu, apdu_len, se_io_cb, ctx);
+
+put_dev:
+	nfc_put_device(dev);
+	return error;
 }
 
 static int nfc_genl_vendor_cmd(struct sk_buff *skb,
@@ -1551,14 +1564,20 @@ static int nfc_genl_vendor_cmd(struct sk_buff *skb,
 	subcmd = nla_get_u32(info->attrs[NFC_ATTR_VENDOR_SUBCMD]);
 
 	dev = nfc_get_device(dev_idx);
-	if (!dev || !dev->vendor_cmds || !dev->n_vendor_cmds)
+	if (!dev)
 		return -ENODEV;
+	if (!dev->vendor_cmds || !dev->n_vendor_cmds) {
+		err = -ENODEV;
+		goto put_dev;
+	}
 
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
@@ -1573,10 +1592,14 @@ static int nfc_genl_vendor_cmd(struct sk_buff *skb,
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

