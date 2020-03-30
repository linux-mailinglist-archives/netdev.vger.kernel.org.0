Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00A5E1986B5
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbgC3VjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:39:06 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32984 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728819AbgC3VjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:39:06 -0400
Received: by mail-wm1-f66.google.com with SMTP id z14so592916wmf.0
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 14:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bl0yu2j4T+LH6lKOM5xoWi5HPF7bOq1CzLFkv/S3kcI=;
        b=FNwuV9kUyjIa/kmWbrt6eViGagkaBYgbU4BItZuNdQ5emO8d7ETIZv3siYpnbL6m8K
         cYsv1xWqL/kvqAmzCJQbk+c/KthtDanFl9peB9G4OUik8NgsrM21rSYasCAp72SB9hbT
         Wohoj76B/tqcxsvWynTI/LCBm8EJTAoYYftTJRY7PKY3twRhbU3OT3AIwMCvbfa6IS28
         UGJiwgSnZJ9mpsuSD1VCwmckrWsZWJTpUct41vbRD2T6pLHw22vB5XJuHxegfRlg5aqR
         9Od00kXh3vVAhQUv2KDbVe7t5w4M0hAa+CmmPvK63fqpRrfouV4BTj7aYa+jniBxjG90
         cuug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bl0yu2j4T+LH6lKOM5xoWi5HPF7bOq1CzLFkv/S3kcI=;
        b=PgdZWgERddfcwMK5n1WXkhYBlGhGNn8QgZp/jA+P06bFf5hg391y6cQqvoLFl4kO2a
         xuswWtrA0ABrPd33X97tRYSlFo9MYur9noM0upujSi3UkN01kwBGCUaq0bgOS9V5+XIt
         lD4iTfvQH6/r32yI8vEPGv7G/p809MJgqSyZDFWznhsgK1OUCXUJjuYzNoTicaZKY3if
         li5oUZ3ZOHIoZmR/AVebiPuWAHF0XuPWBnGMVlueRQz654sb745nwmVUz0sbdzjQhy5g
         eKImCn28fr0J6ymnjzinuQJUVe87mCAx/BxFidusvgy3CTaHt9vvr9/KEoTmJzzxZl55
         +3+A==
X-Gm-Message-State: ANhLgQ2IS5bU8iUmeCex8Az09Vr0wsKZkWD+Q3RiZT1rM0aAir9r0iF3
        F3igUijwR3nmJnw6OAGAziwYm5JI
X-Google-Smtp-Source: ADFU+vv8GWRPh32K5UKNfhYrJzph0MWtcYHOY4y+UBLRqmx5cLVIR3+5LLkUQi/WmuXsW1hq7uQr5Q==
X-Received: by 2002:a05:600c:24a:: with SMTP id 10mr130907wmj.98.1585604344304;
        Mon, 30 Mar 2020 14:39:04 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r17sm23600853wrx.46.2020.03.30.14.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 14:39:03 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next v2 2/9] net: dsa: b53: Restore VLAN entries upon (re)configuration
Date:   Mon, 30 Mar 2020 14:38:47 -0700
Message-Id: <20200330213854.4856-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330213854.4856-1-f.fainelli@gmail.com>
References: <20200330213854.4856-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first time b53_configure_vlan() is called we have not configured any
VLAN entries yet, since that happens later when interfaces get brought
up. When b53_configure_vlan() is called again from suspend/resume we
need to restore all VLAN entries though.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 39ae4ed87d1d..5cb678e8b9cd 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -681,7 +681,9 @@ int b53_configure_vlan(struct dsa_switch *ds)
 {
 	struct b53_device *dev = ds->priv;
 	struct b53_vlan vl = { 0 };
+	struct b53_vlan *v;
 	int i, def_vid;
+	u16 vid;
 
 	def_vid = b53_default_pvid(dev);
 
@@ -699,6 +701,19 @@ int b53_configure_vlan(struct dsa_switch *ds)
 		b53_write16(dev, B53_VLAN_PAGE,
 			    B53_VLAN_PORT_DEF_TAG(i), def_vid);
 
+	/* Upon initial call we have not set-up any VLANs, but upon
+	 * system resume, we need to restore all VLAN entries.
+	 */
+	for (vid = def_vid; vid < dev->num_vlans; vid++) {
+		v = &dev->vlans[vid];
+
+		if (!v->members)
+			continue;
+
+		b53_set_vlan_entry(dev, vid, v);
+		b53_fast_age_vlan(dev, vid);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_configure_vlan);
-- 
2.17.1

