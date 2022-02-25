Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B54D4C3C0E
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 03:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236877AbiBYC7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 21:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236873AbiBYC7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 21:59:43 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053EF270275
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 18:59:13 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id m13-20020a17090aab0d00b001bbe267d4d1so6826205pjq.0
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 18:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BRKtG2RbWHWlFsCS+MbnnMvR+LS0PYZ6YNNc0vjVZ8U=;
        b=PS3zA91T6GMrkLEoJwseG+HsZVkYmR7nrmQc4FgWrriC7iq2RsfUNaDTUvORBSQVZV
         NSKgcDGW7QXPtwcDBkXmUvMEDG4meOjHu42TWWy4Ar63AxzVRNKGqui+vSYDeaP/Pi7k
         g40mO4Jsjgw9LJ0KfzraVbEc7fROPxuxMtjdE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BRKtG2RbWHWlFsCS+MbnnMvR+LS0PYZ6YNNc0vjVZ8U=;
        b=mz03GZMrfJyGte0uRbhSTEsKQ+8jrvETkg3QemlLW21elA+6M/VAF02CBLqIgAdmhB
         IZmcslIdPzRA6vqjjocCTE0OKLAxlw4C/ubhitA46Yt/ewFHAtaG54OZ0Co0rRTOpsOd
         UdLDiMfkF9qYR6hldyJY8PNKNU02dMcSqazkUXb64b0paaJu7HUohA1VM69UN3jf01f8
         Lh9ONGlwHTSaSmKdeuARqf2I8qbWqRccan0duYOig8UIY4WIdpYQ4Gtv/6kfOt4P8tRn
         q9eKDiuZZEgFHeg5sUlkOpIFbzAekOrbBpLaLblee+UK/2e2dI3K2wrl1W+3s3SZ7E+p
         i3lg==
X-Gm-Message-State: AOAM5332xJBU7vuulR7QhGRKy+iDggYLr7loq9P+5YztiaJLSaD4GbNe
        rr2UcoZsXNfZnLpBbDSo6T14yg==
X-Google-Smtp-Source: ABdhPJxIePE8F6ZLmJqwcl93CCcg3Jte8Z6Cu4fKMFfo9p9wJkAfz3Y35WEeThk+UH5F4SZgRr9pIA==
X-Received: by 2002:a17:902:cf12:b0:14f:e0c2:1515 with SMTP id i18-20020a170902cf1200b0014fe0c21515mr5632230plg.4.1645757952514;
        Thu, 24 Feb 2022 18:59:12 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id q93-20020a17090a4fe600b001b9ba2a1dc3sm7397526pjh.25.2022.02.24.18.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 18:59:11 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v8 5/8] net/funeth: devlink support
Date:   Thu, 24 Feb 2022 18:58:59 -0800
Message-Id: <20220225025902.40167-6-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220225025902.40167-1-dmichail@fungible.com>
References: <20220225025902.40167-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink part, which is minimal at this time giving just the driver
name.

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 .../ethernet/fungible/funeth/funeth_devlink.c | 40 +++++++++++++++++++
 .../ethernet/fungible/funeth/funeth_devlink.h | 13 ++++++
 2 files changed, 53 insertions(+)
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_devlink.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_devlink.h

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_devlink.c b/drivers/net/ethernet/fungible/funeth/funeth_devlink.c
new file mode 100644
index 000000000000..a849b3c6b01f
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/funeth_devlink.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+
+#include "funeth.h"
+#include "funeth_devlink.h"
+
+static int fun_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
+			   struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static const struct devlink_ops fun_dl_ops = {
+	.info_get = fun_dl_info_get,
+};
+
+struct devlink *fun_devlink_alloc(struct device *dev)
+{
+	return devlink_alloc(&fun_dl_ops, sizeof(struct fun_ethdev), dev);
+}
+
+void fun_devlink_free(struct devlink *devlink)
+{
+	devlink_free(devlink);
+}
+
+void fun_devlink_register(struct devlink *devlink)
+{
+	devlink_register(devlink);
+}
+
+void fun_devlink_unregister(struct devlink *devlink)
+{
+	devlink_unregister(devlink);
+}
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_devlink.h b/drivers/net/ethernet/fungible/funeth/funeth_devlink.h
new file mode 100644
index 000000000000..e40464d57ff4
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/funeth_devlink.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+
+#ifndef __FUNETH_DEVLINK_H
+#define __FUNETH_DEVLINK_H
+
+#include <net/devlink.h>
+
+struct devlink *fun_devlink_alloc(struct device *dev);
+void fun_devlink_free(struct devlink *devlink);
+void fun_devlink_register(struct devlink *devlink);
+void fun_devlink_unregister(struct devlink *devlink);
+
+#endif /* __FUNETH_DEVLINK_H */
-- 
2.25.1

