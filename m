Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4082C09BA
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 18:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfI0Qjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 12:39:44 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45580 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfI0Qjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 12:39:44 -0400
Received: by mail-lf1-f65.google.com with SMTP id r134so2372556lff.12
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 09:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xCf1P0jSPhZkBtwHTc7vUPr69Q1RyQk/RlFM9BYZbYY=;
        b=pUMk2g4DCkoXn0/vLtWnyJN2nfxb6zSsltCNso/CF29YsYoY4ZzcMfR+i527Etw+B/
         wvzXS2pkVoaX1e6m0pIG9rACkLHK7UnK9N2Azf87jcZQnJP2mLxIicNxgJ/KHnEuApVp
         +TVAnSM8UgKQjsgSannSJ1wBpa2cxSFwM3Xg3nFTSq3C01oM4VPiqmkohUja1Pq/gpw2
         8OIZviqmGaEolvyP2wNgTQgKPXs0L/htJU+6e2wT4lsbpHQpkxJWkkKJcWYbDzMe6mDl
         kQeov3qVsIZ+yaqIIVRPF8pWmeu+3hlMaOHtuy7blvehh+i7NSOO7n2o1Bh+SoZtFGgK
         ERog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xCf1P0jSPhZkBtwHTc7vUPr69Q1RyQk/RlFM9BYZbYY=;
        b=N/tHB7TEw5PJ+5Mn64Bg/e04A6QQi56Fl9tElahNh2XhETcRwneQscpmVUDx+CAQ7g
         gkZxzx7YPGOUDUpTsl5jE4K1gzBRcJFgoW4jZnqgOefOgWHqtkPQgKmmTlKc4Y/J6ddK
         4t2MTD/fVmI5NO8FBKBaYC+SR2NjD4GTAWI3R+8KjOrBZx7TItyY0zbMWZ5IIUsQNDzJ
         BLWYwSmOmE9y+dwiOhXWj4Qdk4LgzypuX9FUHSbnVtePBvVt+RWJ9b3Iq+/3N3gbv2P6
         YCqRy0U/gF1zJtZP7wPOC5e06yHtNdMVyZCTgS6isRyrnsouaNVIiFQa37GkMDmvLIpp
         ZvwA==
X-Gm-Message-State: APjAAAUpr5R/w38gZAPCwkPR4v/6fEWS/sCbROYBASzYCbehlF3njiWT
        vwW8Qe6y1TnsIi3HHncsKwwfsg==
X-Google-Smtp-Source: APXvYqwwSE0dqH/P7HDPuTE/6DP+cZrPAzHDr1w+B5VpkMFRGlLVVz3P0Q7UnspDeIQ3b1URrXY3kw==
X-Received: by 2002:ac2:46d2:: with SMTP id p18mr3480582lfo.140.1569602380474;
        Fri, 27 Sep 2019 09:39:40 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id j84sm564846ljb.91.2019.09.27.09.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 09:39:38 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] net: dsa: rtl8366: Check VLAN ID and not ports
Date:   Fri, 27 Sep 2019 18:39:11 +0200
Message-Id: <20190927163911.11179-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There has been some confusion between the port number and
the VLAN ID in this driver. What we need to check for
validity is the VLAN ID, nothing else.

The current confusion came from assigning a few default
VLANs for default routing and we need to rewrite that
properly.

Instead of checking if the port number is a valid VLAN
ID, check the actual VLAN IDs passed in to the callback
one by one as expected.

Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/rtl8366.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index ca3d17e43ed8..e2c91b75e843 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -340,9 +340,11 @@ int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
 {
 	struct realtek_smi *smi = ds->priv;
 	int ret;
+	int i;
 
-	if (!smi->ops->is_vlan_valid(smi, port))
-		return -EINVAL;
+	for (i = vlan->vid_begin; i < vlan->vid_end; i++)
+		if (!smi->ops->is_vlan_valid(smi, port))
+			return -EINVAL;
 
 	dev_info(smi->dev, "prepare VLANs %04x..%04x\n",
 		 vlan->vid_begin, vlan->vid_end);
@@ -369,9 +371,11 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 	u32 untag = 0;
 	u16 vid;
 	int ret;
+	int i;
 
-	if (!smi->ops->is_vlan_valid(smi, port))
-		return;
+	for (i = vlan->vid_begin; i < vlan->vid_end; i++)
+		if (!smi->ops->is_vlan_valid(smi, port))
+			return;
 
 	dev_info(smi->dev, "add VLAN on port %d, %s, %s\n",
 		 port,
-- 
2.21.0

