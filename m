Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0786EE7C60
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 23:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbfJ1Wcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 18:32:53 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54370 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfJ1Wcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 18:32:52 -0400
Received: by mail-wm1-f68.google.com with SMTP id g7so588829wmk.4
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 15:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NRXdgAc0PcgTXqIaaJzCtAmcNG62VLkqQ9HRilNs6zE=;
        b=ZHIxAVYyRjROE32D+4tXWNI+kto7Xb09zjTOvcw/H/buB5PgOTxrv6V6Fx8KUcilZS
         sxfNwosrz1QSk68MwAtEJ9qI8AbY7x/H8BNKp6aNswu8Q0CE8kKJZdNS9AltSKPyUYkS
         sf1C9RXq98MwBRsntX9QMxU6t+yMo2FpwGo3BSKg1muk6WLBTpLCEuL7RZ4794h1+4M5
         I35sodn741Dlw1fNbgqMijQc78bXkT0IULlcL+wS4DXFl4YloNWQnuO9rQKLV0JWh3Dh
         wP3YODwzIhUZSGqulgPu+jgYkvvbUh7q1YQtq1v0oTT/raFGCfMLjVGLoiC0eehu9AdZ
         5HYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NRXdgAc0PcgTXqIaaJzCtAmcNG62VLkqQ9HRilNs6zE=;
        b=SxXwoo9NKTDrGjCYdYHhPnZMUIQnvRurjEfU9w3+G+C63Lx/bqyZb3GGXUEsW4zYd6
         WNRwyqNTrDuQMakmzrDkNoqpVue3ZmAOptNhFjbtL7A6Ie1Ikdt+na7h7BqbCy0uDoUm
         yds/C0a6hVKSyxwze7jym1lFyoMn3/YQsKNm1YrQeUNrM+VgOliLet736h1hZyTxYMFc
         FnQbYBX0/POu2PXC4lbNBQQUXzl+cWuI5jRKg/tUl6WJDQPNkW3jXF0oQC4XRi6haP96
         yJqa7J+NXgp0NEvyXfW4TFM+LKkLgaS9gEeQbOxaJ5ofhjx1+s6ISWid0vv4XITmFmVu
         3i9g==
X-Gm-Message-State: APjAAAWVB8s10AfHOLZqZ4KpdqrjvZQU5yWSvxL6q+ME2Kg96a9AbtJD
        6FsDJ86u9GaFe/9t3N0O6+iohVA5
X-Google-Smtp-Source: APXvYqw9CbcSLr8899Un44D3Envf664o1tc76Ntt8bUZUxDMixKzcA5ErFm7H4+FOzG/8mSWUcetDA==
X-Received: by 2002:a1c:28d4:: with SMTP id o203mr1306627wmo.147.1572301970576;
        Mon, 28 Oct 2019 15:32:50 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s21sm17551607wrb.31.2019.10.28.15.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 15:32:49 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 2/2] net: dsa: b53: Add CPU port election callback
Date:   Mon, 28 Oct 2019 15:32:36 -0700
Message-Id: <20191028223236.31642-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191028223236.31642-1-f.fainelli@gmail.com>
References: <20191028223236.31642-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ability to select a particular CPU port to be chosen when
multiple such ports are defined/available in the platform configuration.
On all Broadcom switches but 5325 and 5365, port 8 should be selected.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 17 +++++++++++++++++
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 drivers/net/dsa/bcm_sf2.c        |  1 +
 3 files changed, 19 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index baadf622ac55..ce7c22f151a6 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1833,6 +1833,22 @@ enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port)
 }
 EXPORT_SYMBOL(b53_get_tag_protocol);
 
+int b53_elect_cpu_port(struct dsa_switch *ds, int port)
+{
+	struct b53_device *dev = ds->priv;
+	int cpu_port = dev->cpu_port;
+
+	if (is5325(dev) || is5365(dev))
+		cpu_port = B53_CPU_PORT_25;
+
+	/* We would prefer to use a different CPU port that this one */
+	if (port != cpu_port)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(b53_elect_cpu_port);
+
 int b53_mirror_add(struct dsa_switch *ds, int port,
 		   struct dsa_mall_mirror_tc_entry *mirror, bool ingress)
 {
@@ -1962,6 +1978,7 @@ EXPORT_SYMBOL(b53_set_mac_eee);
 
 static const struct dsa_switch_ops b53_switch_ops = {
 	.get_tag_protocol	= b53_get_tag_protocol,
+	.elect_cpu_port		= b53_elect_cpu_port,
 	.setup			= b53_setup,
 	.get_strings		= b53_get_strings,
 	.get_ethtool_stats	= b53_get_ethtool_stats,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index a7dd8acc281b..f12b0fae6743 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -354,6 +354,7 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 int b53_mirror_add(struct dsa_switch *ds, int port,
 		   struct dsa_mall_mirror_tc_entry *mirror, bool ingress);
 enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port);
+int b53_elect_cpu_port(struct dsa_switch *ds, int port);
 void b53_mirror_del(struct dsa_switch *ds, int port,
 		    struct dsa_mall_mirror_tc_entry *mirror);
 int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy);
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index c068a3b7207b..ab399d7d76b6 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -934,6 +934,7 @@ static int bcm_sf2_sw_get_sset_count(struct dsa_switch *ds, int port,
 
 static const struct dsa_switch_ops bcm_sf2_ops = {
 	.get_tag_protocol	= b53_get_tag_protocol,
+	.elect_cpu_port		= b53_elect_cpu_port,
 	.setup			= bcm_sf2_sw_setup,
 	.get_strings		= bcm_sf2_sw_get_strings,
 	.get_ethtool_stats	= bcm_sf2_sw_get_ethtool_stats,
-- 
2.17.1

