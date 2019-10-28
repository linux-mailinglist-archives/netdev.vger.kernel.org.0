Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F07E7C5F
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 23:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfJ1Wcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 18:32:51 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39064 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfJ1Wcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 18:32:51 -0400
Received: by mail-wm1-f68.google.com with SMTP id r141so527522wme.4
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 15:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L0MRpHg3NqmxOViVQZVLjVVcefjjrT3+oHbXlEljkHs=;
        b=UQnHHCWG3Bj6KIt9dNd8RDYBZvochaazObLxQopd8HLkGLhJAPV6Lf9atUhHmsMjR4
         wB/MONsyf9HsVz7JakZsscxgqJ0NmPcdDVWFPRr+hCY8Ev/r7ygVm6myTuxIVgwqRx1i
         YANQjhCTuwPkJ8s5knrE1wrzFYtN1n7PxcS63aXpLqp4tQs8IOtWHX8L5Ue7gLvib1Zw
         +FZbilmJ1/YfvFVzulgyXIDLylODUV9bsbLGLbJ3t3UAk2Uen501FYHiLCOjBeAtdRrk
         jwcYJdzDQThabyCNwbom6f8GJzfjQUZGhpGl4j9OUdIV2rlLWZBY369PE+fBQNnXxqNX
         pcaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L0MRpHg3NqmxOViVQZVLjVVcefjjrT3+oHbXlEljkHs=;
        b=ozksa+97Q77slHcBGNkp7AQXSM65+7JDcRbnyQcN/2hee8p22Ugs/PpPqve7ymAuIT
         Rli8jeCPcIW3ZCeNFXdcEYMvcksVR+w4l+kGXJrc2XuMtv5OXoLEuz9AmjGCOdE5POp5
         661YRhahsuZ0w2XPa6vO/TqhihEB443u613PIXZ5DSx3nsej1desql6TkwWa0tPnVOcY
         GA/wx9lBzK485Ur+d2FVj6I58JD3D2KrOq1He5UIVPGJmKc5IBVoMibkBC9xCzGDp88K
         H3mNwfIdQPHWjco2qFxiBz16kOS8mgA+3uEArjQRvat/PI/VUI9o5wkJ7QCNpFC495SM
         MTPg==
X-Gm-Message-State: APjAAAWhLxHBIkhjV5UwVhE6ZgdJnYS6ajqGmjhUNEyYxphbIxTubQpY
        R70O+C3A+XUiL/wPexpUgTmLx9Tg
X-Google-Smtp-Source: APXvYqw0nNzq5s7KoCv5Sj8Uix0i0F/qLtAULyMdjW0k1bRz7eM/qV0dLBveHKu7TI7wLN9kCtzJuw==
X-Received: by 2002:a1c:a6c8:: with SMTP id p191mr1197527wme.99.1572301968455;
        Mon, 28 Oct 2019 15:32:48 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s21sm17551607wrb.31.2019.10.28.15.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 15:32:46 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 1/2] net: dsa: Add ability to elect CPU port
Date:   Mon, 28 Oct 2019 15:32:35 -0700
Message-Id: <20191028223236.31642-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191028223236.31642-1-f.fainelli@gmail.com>
References: <20191028223236.31642-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a configuration where multiple CPU ports are declared within the
platform configuration, it may be desirable to make sure that a
particular CPU port gets used. This is particularly true for Broadcom
switch that are fairly flexible to some extent in which port can be the
CPU port, yet will be more featureful if port 8 is elected.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/net/dsa.h |  1 +
 net/dsa/dsa2.c    | 19 +++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index e3c14dc3bab9..f4f209576f8e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -361,6 +361,7 @@ typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 struct dsa_switch_ops {
 	enum dsa_tag_protocol (*get_tag_protocol)(struct dsa_switch *ds,
 						  int port);
+	int	(*elect_cpu_port)(struct dsa_switch *ds, int port);
 
 	int	(*setup)(struct dsa_switch *ds);
 	void	(*teardown)(struct dsa_switch *ds);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 214dd703b0cc..31c4b692bd19 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -184,14 +184,25 @@ static bool dsa_tree_setup_routing_table(struct dsa_switch_tree *dst)
 	return complete;
 }
 
-static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
+static struct dsa_port *dsa_tree_find_cpu(struct dsa_switch_tree *dst)
 {
+	struct dsa_switch *ds;
 	struct dsa_port *dp;
+	int err;
 
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_is_cpu(dp))
+	list_for_each_entry(dp, &dst->ports, list) {
+		ds = dp->ds;
+		if (!dsa_port_is_cpu(dp))
+			continue;
+
+		if (!ds->ops->elect_cpu_port)
 			return dp;
 
+		err = ds->ops->elect_cpu_port(ds, dp->index);
+		if (err == 0)
+			return dp;
+	}
+
 	return NULL;
 }
 
@@ -199,7 +210,7 @@ static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *cpu_dp, *dp;
 
-	cpu_dp = dsa_tree_find_first_cpu(dst);
+	cpu_dp = dsa_tree_find_cpu(dst);
 	if (!cpu_dp) {
 		pr_err("DSA: tree %d has no CPU port\n", dst->index);
 		return -EINVAL;
-- 
2.17.1

