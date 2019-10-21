Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D92DF723
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730630AbfJUUwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:52:45 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40857 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730419AbfJUUvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:51:46 -0400
Received: by mail-qt1-f195.google.com with SMTP id o49so15489581qta.7;
        Mon, 21 Oct 2019 13:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zmHdrtIAzJso5M2LnfOM9dJxmuEt0nVQPAtxHNuTfN0=;
        b=GzzTpeJRM7yMt0wzr6zYJanU1LYDbykEABgzZadCW267nFtj1ftBq21ED3PXsAsfEl
         UkfbcB4n85nGz/dZP9cWFawbA6odiu8dfszb9qemzJxXj3LGEq1HyaarT/IcvGtSQmPr
         c7ljYE/57R4BVxm5vpxXqoBxCP8GxvQb62LK8BJC5LRGhWfLNvb7aEGbvyzegyO5o/YQ
         m1GsWu9B4G2PNBVLp0SNhOVVYMs0VQb4oxYXa7F4Nu6bIo5W/IzNrAW8ngQj2jQC60An
         QT/uxyPVk3/eaL50hnkVbImAe6AL7zbjhDJPqhZ7my+Bul6O7mQXI8Ca7CWhACcLSrTy
         meDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zmHdrtIAzJso5M2LnfOM9dJxmuEt0nVQPAtxHNuTfN0=;
        b=Fa0kZpkiLnaK3HhpeWSeQWzOI60rZkG8iBqJsWJldZFqXshlSKVR1bI0QYvFiC8nqt
         e68Tr3qg5HyqLqG5bLo9U5rlr98whTQN9W/XsxYGNZYjcGQV0p5+sJ+OHPB9sL609k1U
         mdjuRTdEbE9YuIsPe5zSkV3onmCgRWA6bAFn1F5uej2cNxTDEeg4iUlEfx3RG0ufYbXg
         Rm54QPrmSmeHUa0OgaCR/8D6qsqWkxCRhCpBT8FaHX/levA7yMErswr6cUk2pgkZY9bP
         sogU/DLBTmtKPpo+Z8UiuGrBEqj//TDE1p/Ai3w4JSU8hfLR4DF52708E9No2bhn7hnY
         42KA==
X-Gm-Message-State: APjAAAXr9tamX5xIQ3vkHtI/5q07h+r60YjsPREv5Fn7a0cvM7WGmI6r
        jeo9F3dmKfnv/G+qX8Eq59k=
X-Google-Smtp-Source: APXvYqxwQNRDu9W+lllrC0cZIgapYpZAbmxA+Pti7psCTsJqoJc8nRSthG6dU+OqkQURuZOsI3JgPQ==
X-Received: by 2002:ac8:23e8:: with SMTP id r37mr27024190qtr.365.1571691105393;
        Mon, 21 Oct 2019 13:51:45 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id o13sm2272328qto.96.2019.10.21.13.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:51:44 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 06/16] net: dsa: use ports list for routing table setup
Date:   Mon, 21 Oct 2019 16:51:20 -0400
Message-Id: <20191021205130.304149-7-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021205130.304149-1-vivien.didelot@gmail.com>
References: <20191021205130.304149-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new ports list instead of accessing the dsa_switch array
of ports when iterating over DSA ports of a switch to set up the
routing table.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dsa/dsa2.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 01b6047d9b7b..623805ba8e1a 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -157,6 +157,7 @@ static bool dsa_port_setup_routing_table(struct dsa_port *dp)
 
 static bool dsa_switch_setup_routing_table(struct dsa_switch *ds)
 {
+	struct dsa_switch_tree *dst = ds->dst;
 	bool complete = true;
 	struct dsa_port *dp;
 	int i;
@@ -164,10 +165,8 @@ static bool dsa_switch_setup_routing_table(struct dsa_switch *ds)
 	for (i = 0; i < DSA_MAX_SWITCHES; i++)
 		ds->rtable[i] = DSA_RTABLE_NONE;
 
-	for (i = 0; i < ds->num_ports; i++) {
-		dp = &ds->ports[i];
-
-		if (dsa_port_is_dsa(dp)) {
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->ds == ds && dsa_port_is_dsa(dp)) {
 			complete = dsa_port_setup_routing_table(dp);
 			if (!complete)
 				break;
-- 
2.23.0

