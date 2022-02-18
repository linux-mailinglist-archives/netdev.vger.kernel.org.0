Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1D64BC301
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 00:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240200AbiBRXqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 18:46:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240195AbiBRXqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 18:46:04 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D54D27B495
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 15:45:46 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id w20so8314471plq.12
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 15:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BRKtG2RbWHWlFsCS+MbnnMvR+LS0PYZ6YNNc0vjVZ8U=;
        b=iY2cmRL41msx6CjsUFP3D1i7IfhlO+QL1NgJ0ROoX29HwPpzu3mr+nyxWcrfHRioFH
         yDrf0EC0PoY+2cl7QUfxJxlS/1xwsr5xN5G/nTkOkFtCysEgw3tLN49oDonbNqezuwW2
         WBOu55vWoR367QJ42uF3+ooEe+M3wtHGTPWRc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BRKtG2RbWHWlFsCS+MbnnMvR+LS0PYZ6YNNc0vjVZ8U=;
        b=luDxcVSr4+TT68iAvhEq1bDSE5UumgA8P3B8QWsUXqwMbuPVXsRa6APsouiWS62kSe
         3oPMWOudQlbB9r6UttnNqtkiPWZxJsMAei/CArsqDvu4llWpfDn52zx8FJaC/6ps6bxQ
         eCcmwooYb2gu/Et9Gk7CiEjmyDNAmLlEELWVy2JXa6pRodt/nlv4tMY8OL1X63mWHsiN
         ER7ZGtFsdbtU2i1QKoTRSJZjggMSM7aNKYrq+TLhhkL2lhDOE3un6oPXN6urE5s04toR
         luB7dDwwq897+HGI/SUtBAkZTg0vDMwMA/+kf/12D3hQsgnsKfyqFfXGHJDyYG9ixq/6
         DmRg==
X-Gm-Message-State: AOAM532vNgMHjU1FCQA07KH63hK0uVwHl0yi5PMvAdBNfyWOFj3xArdr
        38VE0Wj+KqJkclx1F6h53YAnTg==
X-Google-Smtp-Source: ABdhPJxrh/jCcPjzKVmNeyfYYCocAzjrMOHiwJwXDZIXybU41kauGJerYT134uhPzs2pyAoTPsAFQQ==
X-Received: by 2002:a17:902:f605:b0:14f:5d75:4fb0 with SMTP id n5-20020a170902f60500b0014f5d754fb0mr9378919plg.101.1645227946116;
        Fri, 18 Feb 2022 15:45:46 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id g126sm11723406pgc.31.2022.02.18.15.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 15:45:45 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v7 5/8] net/funeth: devlink support
Date:   Fri, 18 Feb 2022 15:45:33 -0800
Message-Id: <20220218234536.9810-6-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220218234536.9810-1-dmichail@fungible.com>
References: <20220218234536.9810-1-dmichail@fungible.com>
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

