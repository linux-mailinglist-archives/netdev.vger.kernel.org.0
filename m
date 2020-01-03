Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A70B112FD5F
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgACUBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:01:54 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42712 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728691AbgACUBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:01:51 -0500
Received: by mail-wr1-f67.google.com with SMTP id q6so43388163wro.9
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 12:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LZJqYBX7CDzgsniXXIG3bnkLFsj6LYm4IJNFXgIYNOQ=;
        b=EA4f5nm6sCGHSmEqbMN747ukVVRzmghXo+eDqYJaSjgsMZvyxmgz2ftFU5t4i2svyA
         n7lfc4d+0gltQNAusjzMHxhcTSE3M0qxuP137c0V2Q0u1bMD9sh8OKsPkOi11VHSxXwe
         cxuHB/VKXU85JdwE7oEtaqIxHSUZXrY3e4R7VYqT6B1BQCer/s4Z3O8xNrKGM/H7qbNe
         /6Hsp+/6jVXYO/6AeTKdbBJpnHqWXr4iU5u8LLClUnmVQzj2LrmY3d6LUpicq3k+StfV
         uP3d5DQXw0NPPsV0l3KIXkq1aRPqTUAa9E1+I+4IqLa5v9d9c2+UPmYFpVB8Mp79+4Di
         Ngyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LZJqYBX7CDzgsniXXIG3bnkLFsj6LYm4IJNFXgIYNOQ=;
        b=rwgsPs75I/SLt4bM71K5iOfHuk5B6SH+R7g2jtLIbjOv1ThE3hudVgsQusWOXXcSj0
         DKo2spPqhEwma/u85IvYhxjkolN46feDLEEzJGw6ECAxgmPOtPOOH1Gx2HWb9O0XVHm+
         Mj3eJD0A2Qgw62XKTxRDNajQ7A9YV5U+KOfB5UfcBL46gbEOehBLtVAZUzMBNcX2vM9z
         bQaP0rgddIaQI+HCYS+y4RMmNirM/NOpCiCKZV28HTQX9VuRmqcL80cFO2W+fG3Yq3SZ
         ZRgjgD4bYAEykaRfVsI0AT2mn5+UsffUVVmwlhITClEbRT5eMAvTcHF6hZjiLWqX5G/2
         uWrA==
X-Gm-Message-State: APjAAAXxV1K1K4b2SOWQEfcqV8ixd3UyPEcmutTrOpYylmVwgABLUcXj
        DrQtr4Q9kKnGnASTq1Zqzmc=
X-Google-Smtp-Source: APXvYqypOWy75U8rY1dJPKUGwnUzLE8YvBO41hZ7yQCs3YkcmX8OHOesTXJfekjb8vusTEa4uI3UZQ==
X-Received: by 2002:adf:df90:: with SMTP id z16mr95207331wrl.273.1578081710306;
        Fri, 03 Jan 2020 12:01:50 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id e12sm60998154wrn.56.2020.01.03.12.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 12:01:49 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 4/9] net: dsa: Pass pcs_poll flag from driver to PHYLINK
Date:   Fri,  3 Jan 2020 22:01:22 +0200
Message-Id: <20200103200127.6331-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200103200127.6331-1-olteanv@gmail.com>
References: <20200103200127.6331-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The DSA drivers that implement .phylink_mac_link_state should normally
register an interrupt for the PCS, from which they should call
phylink_mac_change(). However not all switches implement this, and those
who don't should set this flag in dsa_switch in the .setup callback, so
that PHYLINK will poll for a few ms until the in-band AN link timer
expires and the PCS state settles.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
- None.

 include/net/dsa.h | 5 +++++
 net/dsa/port.c    | 1 +
 2 files changed, 6 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index da5578db228e..dab1c4415f1e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -283,6 +283,11 @@ struct dsa_switch {
 	 */
 	bool			vlan_filtering;
 
+	/* MAC PCS does not provide link state change interrupt, and requires
+	 * polling. Flag passed on to PHYLINK.
+	 */
+	bool			pcs_poll;
+
 	size_t num_ports;
 };
 
diff --git a/net/dsa/port.c b/net/dsa/port.c
index ffb5601f7ed6..774facb8d547 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -599,6 +599,7 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 
 	dp->pl_config.dev = ds->dev;
 	dp->pl_config.type = PHYLINK_DEV;
+	dp->pl_config.pcs_poll = ds->pcs_poll;
 
 	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(port_dn),
 				mode, &dsa_port_phylink_mac_ops);
-- 
2.17.1

