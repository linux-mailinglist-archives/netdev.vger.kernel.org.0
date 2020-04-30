Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7B41C051F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 20:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgD3StW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 14:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgD3StV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 14:49:21 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA41C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 11:49:21 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r4so3228894pgg.4
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 11:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fB2mfIxTFNT/SrlQDRXy4ElURGcii1+ovktAmZ7QXmg=;
        b=JI7JQYFVQW5xvPsrsMEihtwFU+rLNrI0uhx7pl4heqSR9jQqepynlNulf0mp7D5add
         P0/JaRKMEZ4SbpaA2UGN/nVWMX9xaZluow2nLpWG68Y38NVa6A86Vy0a4tLGyHn9Ci1Q
         oOLqx4Z1+XeENiV19ZdAnwC47O6sGIqoWyodG8JuJ1vpozjINAasbA7V5/Kkx04fDJBw
         Qd694Bn8dVS6jkgOwBQVn0jfI5tC+sC2vqTgmkPWnqrk7+KJSY5SbMnfNUsRHPc7zkgW
         zTaIdSPoTeKp4pgT5X8qOgdP/5x4Nnqson7txqMyQDaVupLqhFvSIUgOY2d6UxQaA3lb
         QzpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fB2mfIxTFNT/SrlQDRXy4ElURGcii1+ovktAmZ7QXmg=;
        b=RMEBbfLjOoI1hSYDXQSfAiomvzjC/GYRXeHLUWi8/5lg1a7e/Xe+jUWr51cq81gEkL
         N6AEUq8XNcdjTN6LPGTVQvyHt6I1W/ZeaRYuHk218SE86SkFo0K6eeICOpkRSCnX5buU
         NAkvlIs8iYibiDq1VjH6b13lCPXF+MtO/8L8hmU0ATNOW+XHqA+UbVZMgel6mCXtTm57
         Np+TD58W6bU8TaEUadn0ksjnZF392T4bJkrjdTghC0NgoUtN5NXgRb5FSCBXc833s18R
         RI7IYxs4IIor/RKMzsZmvQA1ghEv1KihHyV/RT68wC86JmbJiKLynMNJM1OrKS2cTqZU
         9UCw==
X-Gm-Message-State: AGi0Pua/a+ZLt0LkVrXY+pwToT9J2JDyZhguMms93+RKp4BYMb4FYcBz
        JMlSDd2LUdpxoQk3A6uS7gScXOC1
X-Google-Smtp-Source: APiQypIhsiVj1UyMjz4L8PDwMAUg1jbyV1/lcz1QcdVINPFPEFy7j40HxX5eEzZjkrLUAhHw9EPvZg==
X-Received: by 2002:a62:7ece:: with SMTP id z197mr148891pfc.244.1588272560181;
        Thu, 30 Apr 2020 11:49:20 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a23sm426886pfo.145.2020.04.30.11.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 11:49:19 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org
Subject: [PATCH net-next 3/4] net: dsa: b53: Bound check ARL searches
Date:   Thu, 30 Apr 2020 11:49:10 -0700
Message-Id: <20200430184911.29660-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430184911.29660-1-f.fainelli@gmail.com>
References: <20200430184911.29660-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ARL searches are done by reading two ARL entries at a time, do not cap
the search at 1024 which would only limit us to half of the possible ARL
capacity, but use b53_max_arl_entries() instead which does the right
multiplication between bins and indexes.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 drivers/net/dsa/b53/b53_priv.h   | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index aa0836ac751c..9550d972f8c5 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1702,7 +1702,7 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 				break;
 		}
 
-	} while (count++ < 1024);
+	} while (count++ < b53_max_arl_entries(priv) / 2);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 694e26cdfd4d..e942c60e4365 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -213,6 +213,11 @@ static inline int is58xx(struct b53_device *dev)
 #define B53_CPU_PORT_25	5
 #define B53_CPU_PORT	8
 
+static inline unsigned int b53_max_arl_entries(struct b53_device *dev)
+{
+	return dev->num_arl_buckets * dev->num_arl_bins;
+}
+
 struct b53_device *b53_switch_alloc(struct device *base,
 				    const struct b53_io_ops *ops,
 				    void *priv);
-- 
2.17.1

