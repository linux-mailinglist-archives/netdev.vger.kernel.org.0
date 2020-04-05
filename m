Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCFE519EDC7
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 22:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgDEUAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 16:00:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46898 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgDEUAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 16:00:39 -0400
Received: by mail-wr1-f66.google.com with SMTP id j17so14851072wru.13;
        Sun, 05 Apr 2020 13:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=VLVnSq472ZJWcRIFfrtdvmcQ4Q6YhtKhA+2SpNJSSFY=;
        b=tisiBEh+hi212zrFvsb8QK9bg6uUxFD20rxK396zIiaVnelUtKohfPkHxgigT8gX3x
         wwScEba4+4R71KEjAFRJjKakmS2aUF0aq0QVkLrbvnuQMXBAw5DXu4rVf0Mi4E2r5b1a
         L5+mj1SfqVLqQARZi5vA7nK+wA6D0ZULCDLlcSCeGCGQsI0ynsw3XEzyzS4fp/pzQk/h
         mEoOzok1P/Mo8DJXBc/AJ310C5+3aIZTadztgXXlOzhXsN8Z4bVFZEy9ABve4sDLVqbB
         tzfVc9/MIVOut0sDyoVDT52a8ocwDG+b6mlMS74qD557+XtiGY0mEqn3nfRwyguP2HBN
         t6aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VLVnSq472ZJWcRIFfrtdvmcQ4Q6YhtKhA+2SpNJSSFY=;
        b=gdebPjlBIzua+c1JwFuVrt92mE+igLPRwB3QKHOdGDk+KplcCPfoy/SZkr0qS3Pmtd
         Ca7OOoTaEdxC+YISFIYxLjXKAai1nMV99V/ZFFYWrvdn+RjQeUeS3NGZNMigM3lvrME7
         nbMR3nO6SiVe2U9pi1QBSOybKdOdE492+kyx4beaSALHNqi0PzJbCpzak5hJwmSOVBSu
         r+dPyaMeifc+uozOHMot2wHEsrEZAxupIvKdPiMJjanlBwmoNVBYeW9Pnyn5tecOj3i4
         dwhysOCp33FZXp1g3naMtV2MxyXbx7+3MunX487/H30YAUva0QgGv5cf2vRQAKWBFlnr
         wSdA==
X-Gm-Message-State: AGi0PuZ6qWsMqQp6BKGX3QPI0ToUKfgMJFOhdfYVg3KAIBbnE1P+8OS8
        38cFaIzvVIYGejSkSLTkERgNMwt/
X-Google-Smtp-Source: APiQypLwDyEZDBhpvrBuB2T68qQlJnJY6a4tehVFtzhkayjoer40jPntEFLQaNx/E+PyePvx/TOC0w==
X-Received: by 2002:a5d:4bc1:: with SMTP id l1mr21693434wrt.103.1586116837278;
        Sun, 05 Apr 2020 13:00:37 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v7sm6855700wmg.3.2020.04.05.13.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2020 13:00:36 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net: dsa: bcm_sf2: Ensure correct sub-node is parsed
Date:   Sun,  5 Apr 2020 13:00:30 -0700
Message-Id: <20200405200031.27263-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the bcm_sf2 was converted into a proper platform device driver and
used the new dsa_register_switch() interface, we would still be parsing
the legacy DSA node that contained all the port information since the
platform firmware has intentionally maintained backward and forward
compatibility to client programs. Ensure that we do parse the correct
node, which is "ports" per the revised DSA binding.

Fixes: d9338023fb8e ("net: dsa: bcm_sf2: Make it a real platform device driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index cc95adc5ab4b..c7ac63f41918 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1079,6 +1079,7 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 	const struct bcm_sf2_of_data *data;
 	struct b53_platform_data *pdata;
 	struct dsa_switch_ops *ops;
+	struct device_node *ports;
 	struct bcm_sf2_priv *priv;
 	struct b53_device *dev;
 	struct dsa_switch *ds;
@@ -1146,7 +1147,11 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 	set_bit(0, priv->cfp.used);
 	set_bit(0, priv->cfp.unique);
 
-	bcm_sf2_identify_ports(priv, dn->child);
+	ports = of_find_node_by_name(dn, "ports");
+	if (ports) {
+		bcm_sf2_identify_ports(priv, ports);
+		of_node_put(ports);
+	}
 
 	priv->irq0 = irq_of_parse_and_map(dn, 0);
 	priv->irq1 = irq_of_parse_and_map(dn, 1);
-- 
2.17.1

