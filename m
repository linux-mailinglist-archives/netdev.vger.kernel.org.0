Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75D2DDF717
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbfJUUwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:52:01 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41956 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730498AbfJUUwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:52:01 -0400
Received: by mail-qk1-f196.google.com with SMTP id p10so14144514qkg.8;
        Mon, 21 Oct 2019 13:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iu1nzxuAMPzL4Wl9WpBs+eqjfwquU4uIp1Guqhyr0Z0=;
        b=kVuc8Ee2ZFKoWP8EtCe3+JYsnUEBvJhCoxygbMPdBtO1L+Na7inYTo3E+/GVs2w3eV
         0Si5KHehSFk8jNDmRW448hK4L/dXhIW9klv67OW60jfzjoCIx4DLvX/kHw+B+EFuUw1U
         Ms7lv8HTt0/psa6xgMaBspVzupn1lOsgoUmLGL6FAMlX/lhrTZyeNGPdq7DPIIbgOBA7
         X0yiilHiXJuI49cy4nLqtkxD5XnHsVvmVvUJPPxYaIii89DL17ihme8uQo7zKZQDZs24
         MPpX1qj0kSh8hQPIXBAFxG8PG5a6SIEUlLve7A3NhGDXj4A4F+WZy/PLyvdtTltjA+Ut
         BGmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iu1nzxuAMPzL4Wl9WpBs+eqjfwquU4uIp1Guqhyr0Z0=;
        b=VIvhlHQSIxukUhTQ4Z7MkSBxxtQtRlJAM18/Zi4b01xkjwnHfzhZAYkrHFUrzYERlC
         S9yQ16505xMbdEOsf/HiCxq72SV7i2boa6RsjQpioQc+tVB3FC3bBk8H9nWVx/QlNijf
         jokxL/3M519ZeeapCv76DEaYiWC9nGOoooHc/2m0/h3sOr0tWtC1E39s6VDc4h5TJtEB
         dR8rXcNq+9ZB7mT17mFm39CFHBHDrFUVDzaH/L0tAjV8iXqg/s4uB/owwARUUnRgnIDW
         XjQq/Ou5o/o/sExVH8QYEKf7ypjby0mD0YNn5OmKjTDHdXqxUsQrKecFPYIIOpRXFBnP
         Im6Q==
X-Gm-Message-State: APjAAAUrowZRFSfR/BE5DQCBvVHlGagybAHrMVuFU+NLQQ4tt6mEMfQ6
        gKshtK/b7L03at9QREe7Vcg=
X-Google-Smtp-Source: APXvYqxr7KtxYoGFXeCvU1ibSKjkRocVmqGtv4Ts8ZWs0lNrd4ngYaD5wmH0TJ6+BRKBrLT+r9KpZw==
X-Received: by 2002:a05:620a:905:: with SMTP id v5mr3898142qkv.373.1571691119783;
        Mon, 21 Oct 2019 13:51:59 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id s67sm396440qkh.70.2019.10.21.13.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:51:59 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 15/16] net: dsa: allocate ports on touch
Date:   Mon, 21 Oct 2019 16:51:29 -0400
Message-Id: <20191021205130.304149-16-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021205130.304149-1-vivien.didelot@gmail.com>
References: <20191021205130.304149-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allocate the struct dsa_port the first time it is accessed with
dsa_port_touch, and remove the static dsa_port array from the
dsa_switch structure.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/net/dsa.h |  2 --
 net/dsa/dsa2.c    | 16 ++++++++++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f572134eb5de..9bc1d3f71f89 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -277,9 +277,7 @@ struct dsa_switch {
 	 */
 	bool			vlan_filtering;
 
-	/* Dynamically allocated ports, keep last */
 	size_t num_ports;
-	struct dsa_port ports[];
 };
 
 static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index bf8b4e0fcb4f..83cba4623698 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -588,7 +588,13 @@ static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 	struct dsa_switch_tree *dst = ds->dst;
 	struct dsa_port *dp;
 
-	dp = &ds->ports[index];
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dp->ds == ds && dp->index == index)
+			return dp;
+
+	dp = kzalloc(sizeof(*dp), GFP_KERNEL);
+	if (!dp)
+		return NULL;
 
 	dp->ds = ds;
 	dp->index = index;
@@ -857,7 +863,7 @@ struct dsa_switch *dsa_switch_alloc(struct device *dev, size_t n)
 {
 	struct dsa_switch *ds;
 
-	ds = devm_kzalloc(dev, struct_size(ds, ports, n), GFP_KERNEL);
+	ds = devm_kzalloc(dev, sizeof(*ds), GFP_KERNEL);
 	if (!ds)
 		return NULL;
 
@@ -885,6 +891,12 @@ static void dsa_switch_remove(struct dsa_switch *ds)
 {
 	struct dsa_switch_tree *dst = ds->dst;
 	unsigned int index = ds->index;
+	struct dsa_port *dp, *next;
+
+	list_for_each_entry_safe(dp, next, &dst->ports, list) {
+		list_del(&dp->list);
+		kfree(dp);
+	}
 
 	dsa_tree_remove_switch(dst, index);
 }
-- 
2.23.0

