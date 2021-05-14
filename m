Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF5C381240
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbhENVBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbhENVBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:41 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE7BC061343;
        Fri, 14 May 2021 14:00:25 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id lz27so523631ejb.11;
        Fri, 14 May 2021 14:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e8E4taDWDkn6x+puoWyXqPUCXo9lK/+PWbdX0SI+nIU=;
        b=oZDyqiMle6RPq25QqegGRhlAKawWXY76eS4JMuY1UsuyFP8E1LU+EgybW2C64EUHyt
         caRxDsflm7nKLFtrD5bvpDxgm2JKHPaL7B9fTsfBw1w1zjs9tgPrTd0lVUtMTM/Nml9X
         8Q/n3vXHsNKpfKLTedwq2jgLGKymFYaTxsJ15xprOapAIEoRxsPgsA5OHD9EoHyCi3Ed
         qlPzzFWouBidWz9FI2holfxIqqgsaRp+uH72Ys0DwPtzsOR8slI1bk/14VgoNuHZL+uA
         ewK0QTkYeHeyvSNrLAo7DH58XDhOA1S3bhJGPnvMG05z6V5Te7iaitxpE3tg990Ckx+q
         iNgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e8E4taDWDkn6x+puoWyXqPUCXo9lK/+PWbdX0SI+nIU=;
        b=ScvQZsBq96Yeq5aHgAB58uu0m6VkgFV63Ul+X1Jw3dk4E61X1pAAwcefIbFv09MOKk
         YfRESlFnzxt9U2gLT2LoCTfIq3yol//tYpCsqnpvoqFqA45KdHwVBVD3El18SaRs65wD
         KI/2lXQzsacy+Q2+s7LlR7IrscYZBHovaYx3GjdRyBWuUOL3XALBLEL3b+l3t1o2HoDB
         xCYFZ4j+OFtB/L538NzbpzjRrgZrij75ng/ddd4c6fCHdSwfHLPRb0gO3ZPUWyyaYINq
         xQgweHAfu+a4Ju6vBIHeNUuHv3P0g4BUKh6XMPfXwv0FqLaR97M6eRIsv3jyW7TvA67D
         BpJA==
X-Gm-Message-State: AOAM53326xe4QJM6mDtCYDo5gBmD0RfDJPiw8RUHK+F6EXb+5oYPoFA8
        hJPeyupYjSbPXSXn/m8zMvQ=
X-Google-Smtp-Source: ABdhPJxZMbxqvpW9exD19q6UEoJk1rkTq9xMumTpjb3gXq8CUG2finrdwkxCMR778tMTxjBLyX6y1A==
X-Received: by 2002:a17:906:58d1:: with SMTP id e17mr51465298ejs.179.1621026024046;
        Fri, 14 May 2021 14:00:24 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:23 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 08/25] net: dsa: qca8k: handle error from qca8k_busy_wait
Date:   Fri, 14 May 2021 22:59:58 +0200
Message-Id: <20210514210015.18142-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Propagate errors from qca8k_busy_wait instead of hardcoding return
value.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca8k.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 409f6592048a..d4e3f81576ec 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -388,8 +388,9 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 		return ret;
 
 	/* wait for completion */
-	if (qca8k_busy_wait(priv, QCA8K_REG_ATU_FUNC, QCA8K_ATU_FUNC_BUSY))
-		return -1;
+	ret = qca8k_busy_wait(priv, QCA8K_REG_ATU_FUNC, QCA8K_ATU_FUNC_BUSY);
+	if (ret)
+		return ret;
 
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_FDB_LOAD) {
@@ -468,8 +469,9 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 		return ret;
 
 	/* wait for completion */
-	if (qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY))
-		return -ETIMEDOUT;
+	ret = qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY);
+	if (ret)
+		return ret;
 
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_VLAN_LOAD) {
@@ -580,7 +582,9 @@ qca8k_mib_init(struct qca8k_priv *priv)
 	if (ret)
 		goto exit;
 
-	qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
+	ret = qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
+	if (ret)
+		goto exit;
 
 	ret = qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
 	if (ret)
@@ -670,9 +674,10 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
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

