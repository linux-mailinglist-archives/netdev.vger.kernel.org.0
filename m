Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31E0376DBC
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhEHAas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhEHAad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:33 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D423C061574;
        Fri,  7 May 2021 17:29:31 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id a10-20020a05600c068ab029014dcda1971aso5924691wmn.3;
        Fri, 07 May 2021 17:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fczMnBhmtho0URtHNyya3OojQZqoHKWZ9vHMvarIH4c=;
        b=GMZUbkLFdCtKOD6dICwJX75JY5AO7q4joRFUMf31IZMEs6E+SDv4gu71bUHLnlJjvZ
         64V/Nv3hYin3HeOTkgVkz6J+QeE8R+ISmGRVOmlLWIMVyOCApJeIRHHO4VbBbgeDuper
         xDX/BhbS3h4pdD9UKaseMD7gv6UIRSBE/knH6/fx+T8fCMuDQQLe21+4xIpja7VWSOTV
         1esZ2ywap+g67bhhebsgG3vdawDe+3en3/vm6JL+7MbpsrBxucvSjkKXvXBJsbJ6i3u7
         ByywiYN7LsVTY72Y14y8AtcMJGRhP9Ypf+7H+bKvDVaoXtyvrhdCNLB3lGjRLbU9XLT0
         D5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fczMnBhmtho0URtHNyya3OojQZqoHKWZ9vHMvarIH4c=;
        b=mOT+WZghn6G8YausgcaXx2risign/67F+baU/NDD3/7iyWSDGr0x37IlpwlM8OtbJw
         NUhHE9wXN2E15mJio12/IVIc5df+t8fJJcqpDxCeg03e4bgmpFNKnlc4YazZRhtE5tyP
         9mUoMCYfbDjA7XPy+TYS8bXm7TCuUjDy6HZqXvW1SfaeoucUFCXKqM6XafxKJwxfpyX7
         PkFxQrWWTPnyz/z3PLrMf8c+mjjXj7+ifQuUCzMAojc4+H6KlmWYZZ1c2+cC2iHH9St0
         2OW5qVQd3Cm+G9wUF9odv/0EEQpmoV6KC6rBNy0LMi2toPWCN0mIgfwFuLM265a9LxIx
         HqRA==
X-Gm-Message-State: AOAM532rJGfniSHdzSwHhyHi0LvBDdo+c4hBmDaBKmA9l/a0ULQxSmyp
        RnB8KMcGvDdo1tcx1Xnl8Yg=
X-Google-Smtp-Source: ABdhPJy2PDNubHcf2bzf91/pxEcz8wWMCzCEPl4WZFyP2wb9nqyopzjTHlw/zg40MPHCiTk8W4BMFw==
X-Received: by 2002:a1c:35c2:: with SMTP id c185mr12553502wma.54.1620433770032;
        Fri, 07 May 2021 17:29:30 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:29 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 11/28] net: dsa: qca8k: handle error from qca8k_busy_wait
Date:   Sat,  8 May 2021 02:29:01 +0200
Message-Id: <20210508002920.19945-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Propagate errors from qca8k_busy_wait instead of hardcoding return
value.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 16ffff478de0..6c65c6013c5f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -397,8 +397,9 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 		return ret;
 
 	/* wait for completion */
-	if (qca8k_busy_wait(priv, QCA8K_REG_ATU_FUNC, QCA8K_ATU_FUNC_BUSY))
-		return -1;
+	ret = qca8k_busy_wait(priv, QCA8K_REG_ATU_FUNC, QCA8K_ATU_FUNC_BUSY);
+	if (ret)
+		return ret;
 
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_FDB_LOAD) {
@@ -480,8 +481,9 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 		return ret;
 
 	/* wait for completion */
-	if (qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY))
-		return -ETIMEDOUT;
+	ret = qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY);
+	if (ret)
+		return ret;
 
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_VLAN_LOAD) {
@@ -592,7 +594,9 @@ qca8k_mib_init(struct qca8k_priv *priv)
 	if (ret)
 		goto exit;
 
-	qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
+	ret = qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
+	if (ret)
+		goto exit;
 
 	ret = qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
 	if (ret)
@@ -682,9 +686,10 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 	if (ret)
 		return ret;
 
-	if (qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-			    QCA8K_MDIO_MASTER_BUSY))
-		return -ETIMEDOUT;
+	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+			      QCA8K_MDIO_MASTER_BUSY);
+	if (ret)
+		return ret;
 
 	val = qca8k_read(priv, QCA8K_MDIO_MASTER_CTRL);
 	if (val < 0)
-- 
2.30.2

