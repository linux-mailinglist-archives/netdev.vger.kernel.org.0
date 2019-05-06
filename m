Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3594154E1
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 22:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfEFUZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 16:25:21 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45366 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfEFUZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 16:25:20 -0400
Received: by mail-ed1-f65.google.com with SMTP id g57so16557801edc.12;
        Mon, 06 May 2019 13:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bDKWxpSWtN7t9ZwYgFWuZ3G1rf5UldWM78eGgF598PI=;
        b=mYrhtD+ZdOfyuP/KMjr3IxVl5tOI76UviXEWVb8LHlvUcywAjfQflwrhcVFcEclSNi
         SyZY6+T5HlazSvwS/5/VR/hygzj4JU7UVT/I4YvD/nVDOfvDw5I8IlWYkwVHyQd/x8wV
         BEZF+z8BOzxzhrHJAlA4zwUPuDm+wTu60K3pBNvKB4JIvIy9FPitLXUAKz2uBsMV8ZPL
         QbsAcsPdoHDBsdkd2EiQb4aBc5/NYr15Wi7nsHagN5ORyymdCpXQ5C+kpsiL9LonA42j
         3EVEJlRJ3AWYHLLlNvEYkS+MnyxlEdztxtqKHvg7RDA0p7KAmOxsGJwZODN9BGgbrWjX
         3gDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bDKWxpSWtN7t9ZwYgFWuZ3G1rf5UldWM78eGgF598PI=;
        b=P1As+IFGNVA2nnZc85jz7i13wFGkYLGzzcX8q854HUUEGvXnq10cf2m0NKaxUY4GTH
         S+tpHzk+nEnERsuWqbaatDn4BklR61NmqyWaSd+NyXdzT8H0plUGDjec0BRzRKcY7i6U
         07FgbJZlPbtG6WjaYTBABTkaoz9ceBK3ioXbOhBqa43OUWE8dAEjspHPBjBPWOXGqG5M
         eGexJwEdnCRPE64aBmCREIXAoEkIu+WfzapeyXWPEk+9wZSYA0V0+atvOwm6LDR6F2hC
         7cs0/yqZrk+1FBaV7+VyeIVzDGBRClR0VMcJoKDjWRDQa5zBa/hgZHTZT+MfpaBbs17B
         OxBA==
X-Gm-Message-State: APjAAAXGm0q4CTQosAltKvtAMldJsDbaxVwwC1ERHZNE6N1EOlj87jxx
        WT8WbrXNw+g8m0tQ0mgZZiRXZgtP
X-Google-Smtp-Source: APXvYqwGvfQTQo31h6V2msi7QKP8O/IdcP5J3pC2myev/vMCkuRXX9r/Q8AKMcn2+H6xuoeYxoP0Xg==
X-Received: by 2002:a17:906:27c5:: with SMTP id k5mr21244496ejc.141.1557174318651;
        Mon, 06 May 2019 13:25:18 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f9:2b:2b84::2])
        by smtp.gmail.com with ESMTPSA id i9sm3394847edk.56.2019.05.06.13.25.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 13:25:17 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] net: dsa: sja1105: Fix status initialization in sja1105_get_ethtool_stats
Date:   Mon,  6 May 2019 13:24:47 -0700
Message-Id: <20190506202447.30907-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

drivers/net/dsa/sja1105/sja1105_ethtool.c:316:39: warning: suggest
braces around initialization of subobject [-Wmissing-braces]
        struct sja1105_port_status status = {0};
                                             ^
                                             {}
1 warning generated.

One way to fix these warnings is to add additional braces like Clang
suggests; however, there has been a bit of push back from some
maintainers[1][2], who just prefer memset as it is unambiguous, doesn't
depend on a particular compiler version[3], and properly initializes all
subobjects. Do that here so there are no more warnings.

[1]: https://lore.kernel.org/lkml/022e41c0-8465-dc7a-a45c-64187ecd9684@amd.com/
[2]: https://lore.kernel.org/lkml/20181128.215241.702406654469517539.davem@davemloft.net/
[3]: https://lore.kernel.org/lkml/20181116150432.2408a075@redhat.com/

Fixes: 52c34e6e125c ("net: dsa: sja1105: Add support for ethtool port counters")
Link: https://github.com/ClangBuiltLinux/linux/issues/471
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_ethtool.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ethtool.c b/drivers/net/dsa/sja1105/sja1105_ethtool.c
index 46d22be31309..ab581a28cd41 100644
--- a/drivers/net/dsa/sja1105/sja1105_ethtool.c
+++ b/drivers/net/dsa/sja1105/sja1105_ethtool.c
@@ -313,9 +313,11 @@ static char sja1105pqrs_extra_port_stats[][ETH_GSTRING_LEN] = {
 void sja1105_get_ethtool_stats(struct dsa_switch *ds, int port, u64 *data)
 {
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_port_status status = {0};
+	struct sja1105_port_status status;
 	int rc, i, k = 0;
 
+	memset(&status, 0, sizeof(status));
+
 	rc = sja1105_port_status_get(priv, &status, port);
 	if (rc < 0) {
 		dev_err(ds->dev, "Failed to read port %d counters: %d\n",
-- 
2.21.0

