Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA76396A53
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbhFAAfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbhFAAfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 20:35:21 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAD9C061574
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:41 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id cb9so3324315edb.1
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hGSr5yjkoeDOvoI4hj+Bt3/ijE2sUs7aPpRRmyrQl1k=;
        b=IYFfOM9CFixwZskFzKJeDL2drUyUKsXi8L2DL4ML0XLzkMlQbyi04A9oHmp0gLDFW6
         pgwGoxaTzsPnboGlnZnP78GYQ+kZPD4xdtGCuHN81Mxh1HyCQvj1i6bkhsAocLPxPPFu
         fsHJjrYwNDDxU18GrxmVrGcN4GHk0/+gv6VQZ7PSDUHO8i0a1FYjpIc7FcqWPqcBKtap
         tUqVrsHXuWyDWyMBYFCYn9GttAAWp1wR1sJIUMAi31UDOnX5Ike7P3IshmVerdcBTeh9
         kEhPAMTDaJ0+nDjSdHDWhM4U357J5IJTr7De6vgDdMfUvCMOztcCbrj1kGkxQI8EFbo8
         u9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hGSr5yjkoeDOvoI4hj+Bt3/ijE2sUs7aPpRRmyrQl1k=;
        b=BXSiewfVhuaFnaGxrF9RxwH7h9/cs0Zdt0AOz2iUM77JVpVRBzC+87raEhic/Xhul1
         xlkcO24wKq8Zh/42cRpwaye6dTQSIN1vGf3DRH9LODdf/R+gvcMd1CmtXJlVts2ZqQQo
         9A3TUud6+rwBSXHYwo7YgETKUKy0rWWA50ZdyxHyl7in/piBvzjZ4OK6V4ZNLmmEtyCY
         hCPJmw5rmfSzn10Q06IBsAUjYZ2anl67zORj6AVsf1jIInr3sxMsAZqK698Hl9GggZb0
         r6BEGCbDDubpeSEy/6T5GsbGbQGC8SDJ59UuxztszYstYJe8y8Gz5n2LLcrkZHetvdW4
         m+DA==
X-Gm-Message-State: AOAM531NQQml0aWPm6zDuaWlS8LQ++hZODsjPs7DzwjCAnB5B6yw3UKq
        Bq3eTIj8GRU0pp+++oqODCQ=
X-Google-Smtp-Source: ABdhPJwFYmWbcv318WvaZgiLLdTOoFV36pqQOZq0C9bkjPy6Wr/aI0HoWy874r8N87GDmCbPfuQQJQ==
X-Received: by 2002:aa7:de1a:: with SMTP id h26mr8168501edv.176.1622507619740;
        Mon, 31 May 2021 17:33:39 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm6510521ejr.63.2021.05.31.17.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 17:33:39 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 7/9] net: pcs: xpcs: use mdiobus_c45_addr in xpcs_{read,write}
Date:   Tue,  1 Jun 2021 03:33:23 +0300
Message-Id: <20210601003325.1631980-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210601003325.1631980-1-olteanv@gmail.com>
References: <20210601003325.1631980-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Use the dedicated helper for abstracting away how the clause 45 address
is packed in reg_addr.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/pcs/pcs-xpcs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 964433849ef8..c3760192fe20 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -275,14 +275,14 @@ static bool __xpcs_linkmode_supported(const struct xpcs_compat *compat,
 
 static int xpcs_read(struct mdio_xpcs_args *xpcs, int dev, u32 reg)
 {
-	u32 reg_addr = MII_ADDR_C45 | dev << 16 | reg;
+	u32 reg_addr = mdiobus_c45_addr(dev, reg);
 
 	return mdiobus_read(xpcs->bus, xpcs->addr, reg_addr);
 }
 
 static int xpcs_write(struct mdio_xpcs_args *xpcs, int dev, u32 reg, u16 val)
 {
-	u32 reg_addr = MII_ADDR_C45 | dev << 16 | reg;
+	u32 reg_addr = mdiobus_c45_addr(dev, reg);
 
 	return mdiobus_write(xpcs->bus, xpcs->addr, reg_addr, val);
 }
-- 
2.25.1

