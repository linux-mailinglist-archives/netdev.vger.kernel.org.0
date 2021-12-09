Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C18846E73C
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 12:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236328AbhLILJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 06:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbhLILJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 06:09:45 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BD5C061746;
        Thu,  9 Dec 2021 03:06:11 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id u17so9045318wrt.3;
        Thu, 09 Dec 2021 03:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=De9KvF5/yla07zEAmA185om11Z7ZBDnnTpkB/t6a6ss=;
        b=dbxstdsFT+2CcwuMIiny5cXYRuQzKz7NdZFvmEm4GC726lAl0yW51Hg7bTawkPxubz
         qdnAGVw95s2h5sI8FtNp/qBJksq+knlY8AukQ1QmaBldq+rsj5YLTHJ6GCFZ167lGguD
         feemBpNNoJMZCBIAzwz1orJA9y+bMTCqvnAuCibkEfSP+w4q6G5ueqJoz+Z468659ll+
         BN628bCGVQ+Mdf/BnshbK8laoyOSnE8fxKmo1XBFfmL1WUNJSh+rrIWJPVC/ZzuosdCp
         jD5g5pkBit+f4NRbiCxCiKdaeoxd2u1GRC2hX6iMeSvL8kGUjZuvKUUYol3q9Yliqc7l
         ewbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=De9KvF5/yla07zEAmA185om11Z7ZBDnnTpkB/t6a6ss=;
        b=nv/5yisuO6ceFaDkbKMMsfO2y4EXTVHlHrQBLQHP1kk/PHSK/o+WgX5dJr/H6JPlRs
         vANE2KzTwpCZD0twp65wMbASz3DifFX/DI4ElMwCLWB8Q8h8B9+yg4iwVrqH0Di+BigS
         oaqykx1wBCnglKCRbTrOl1l6YlKTrfdT+cLw83+Yifg4Zjs3RCQKHvb1ESlJlmxERYLX
         LDZLMkasJaKBesZzis2uyVBNWyYaC5tulKVsSpuCF4gijrmdUyEpo2MofLJPSencjix7
         TGcx111I8L7KTjSpOZYhUpA4UzxIJ/y5ndNZWJVZp/Vczj7eZ/p/Xrf0KJglHZEYHN9D
         O22A==
X-Gm-Message-State: AOAM533aJPjKHl4vyIB+qlHdMYk1lkSScTZrPNbGu94VkqrgeGZWwsp3
        hbp0d6z9IgX1y3R2gOsQyAU=
X-Google-Smtp-Source: ABdhPJxmjPdACT+CfD8uqBPKucIyK+kxDgRiD1zU/VKQarSIr3+6OJ/mc9cnv+yq1rF+eKtrFwFj6w==
X-Received: by 2002:a5d:6d06:: with SMTP id e6mr5642870wrq.210.1639047970421;
        Thu, 09 Dec 2021 03:06:10 -0800 (PST)
Received: from localhost.localdomain ([217.113.240.86])
        by smtp.gmail.com with ESMTPSA id n2sm8573634wmi.36.2021.12.09.03.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 03:06:09 -0800 (PST)
From:   =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>
To:     vladimir.oltean@nxp.com
Cc:     claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>
Subject: [PATCH v2] net: dsa: felix: Fix memory leak in felix_setup_mmio_filtering
Date:   Thu,  9 Dec 2021 12:05:40 +0100
Message-Id: <20211209110538.11585-1-jose.exposito89@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid a memory leak if there is not a CPU port defined.

Fixes: 8d5f7954b7c8 ("net: dsa: felix: break at first CPU port during init and teardown")
Addresses-Coverity-ID: 1492897 ("Resource leak")
Addresses-Coverity-ID: 1492899 ("Resource leak")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

---

v2: Add Fixes and Reviewed-by tags
---
 drivers/net/dsa/ocelot/felix.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 327cc4654806..f1a05e7dc818 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -290,8 +290,11 @@ static int felix_setup_mmio_filtering(struct felix *felix)
 		}
 	}
 
-	if (cpu < 0)
+	if (cpu < 0) {
+		kfree(tagging_rule);
+		kfree(redirect_rule);
 		return -EINVAL;
+	}
 
 	tagging_rule->key_type = OCELOT_VCAP_KEY_ETYPE;
 	*(__be16 *)tagging_rule->key.etype.etype.value = htons(ETH_P_1588);
-- 
2.25.1

