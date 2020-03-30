Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 849AD19858F
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 22:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgC3Ukp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 16:40:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33562 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgC3Uko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 16:40:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id a25so23391852wrd.0
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 13:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R8sj6WVyZB8rITepGXiyyokfdAE916pRlQveHEX+0jU=;
        b=dwNCqbalJH4kC4ncw3fAc73PkjLK8sPpsJpIU9oogobL9+YoTB09aZ8udF2CoGz5qz
         qmcDYFfu7uvWC5BKx0Foz/+1F5vPL8ath5R9K034NFR5ys7TBdpMDuFWoD4xjpbtolYe
         KM6i6ADLvKvJ8coxsTCyiFjPdZ1Kfipnu9vIqZcGtZpf79WHj0vxigWXTDgXokjh1k7R
         GWWJV4lBKo1GgduN3r3iZkwJuwGhnapaDi81Xi+bpaAcKTU/XEyLXWIeDgOHBhXa7Rf6
         e6x3wBRCKI5me6XbcNDWbBf/K33EMgxLaLixaZCzSsnK72AHC0GWu4gPpdY+N2/AZyQ3
         oWcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R8sj6WVyZB8rITepGXiyyokfdAE916pRlQveHEX+0jU=;
        b=Mjcw488qQWCLwv7408M/jQmHCVZoDFhJaPCNltKI2/H6U3fPgNWxfkYxDAgHCnTe0/
         Ihpa12HkSZnAEWNZ0/Ob/TGJUgs9EUj5wkVabI1+3k9vtOmG26suFcmqElMTFKNgZFNu
         NruVLwEyUJsan9z5Dwg4f0Ui4spsiktCESLYY6uhWsukIeYHdGJXwqtIKv2ruKP9rXOA
         KrkCiMT0KhoENzunV1tBbvB14iSZp+2WnDJJjCabHnaqym2/trOqKHAN399tdfSUqu5f
         tOe2qDhsm04JM3Y5IPIlfRTs6JxZzKHTVQWAwyj6xGh2H00hMS76crFHzG6vhuJHlHFd
         ozlA==
X-Gm-Message-State: ANhLgQ1catg0YhflQCwWWRpzZYVYHdrHMQnFyY8rYvRu3Mjv8lpN/3De
        7jF/dx8grjDuy04kJwffsvSYFoI3
X-Google-Smtp-Source: ADFU+vslbKfBv8aC00VjuwhNweinHXSULqOFm93NJhvvyMO2NzEaa7GOEJetS8EU+y8cEyMwCwSffA==
X-Received: by 2002:a5d:4081:: with SMTP id o1mr17341500wrp.114.1585600842532;
        Mon, 30 Mar 2020 13:40:42 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o16sm23371109wrs.44.2020.03.30.13.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 13:40:42 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next 1/9] net: dsa: bcm_sf2: Fix overflow checks
Date:   Mon, 30 Mar 2020 13:40:24 -0700
Message-Id: <20200330204032.26313-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330204032.26313-1-f.fainelli@gmail.com>
References: <20200330204032.26313-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit f949a12fd697 ("net: dsa: bcm_sf2: fix buffer overflow doing
set_rxnfc") tried to fix the some user controlled buffer overflows in
bcm_sf2_cfp_rule_set() and bcm_sf2_cfp_rule_del() but the fix was using
CFP_NUM_RULES, which while it is correct not to overflow the bitmaps, is
not representative of what the device actually supports. Correct that by
using bcm_sf2_cfp_rule_size() instead.

The latter subtracts the number of rules by 1, so change the checks from
greater than or equal to greater than accordingly.

Fixes: f949a12fd697 ("net: dsa: bcm_sf2: fix buffer overflow doing set_rxnfc")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index 1962c8330daa..f9785027c096 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -882,17 +882,14 @@ static int bcm_sf2_cfp_rule_set(struct dsa_switch *ds, int port,
 	     fs->m_ext.data[1]))
 		return -EINVAL;
 
-	if (fs->location != RX_CLS_LOC_ANY && fs->location >= CFP_NUM_RULES)
+	if (fs->location != RX_CLS_LOC_ANY &&
+	    fs->location > bcm_sf2_cfp_rule_size(priv))
 		return -EINVAL;
 
 	if (fs->location != RX_CLS_LOC_ANY &&
 	    test_bit(fs->location, priv->cfp.used))
 		return -EBUSY;
 
-	if (fs->location != RX_CLS_LOC_ANY &&
-	    fs->location > bcm_sf2_cfp_rule_size(priv))
-		return -EINVAL;
-
 	ret = bcm_sf2_cfp_rule_cmp(priv, port, fs);
 	if (ret == 0)
 		return -EEXIST;
@@ -973,7 +970,7 @@ static int bcm_sf2_cfp_rule_del(struct bcm_sf2_priv *priv, int port, u32 loc)
 	struct cfp_rule *rule;
 	int ret;
 
-	if (loc >= CFP_NUM_RULES)
+	if (loc > bcm_sf2_cfp_rule_size(priv))
 		return -EINVAL;
 
 	/* Refuse deleting unused rules, and those that are not unique since
-- 
2.17.1

