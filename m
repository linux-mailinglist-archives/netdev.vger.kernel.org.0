Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD1BF130BD3
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 02:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgAFBel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 20:34:41 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56239 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727219AbgAFBei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 20:34:38 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so13498712wmj.5
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 17:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=As5BJs7Wcn/3NYRiYDzWUBHBtnYT6vEwUo+nQW+Syf4=;
        b=PjuJ8ZeiOcyxF9SFpN8D2ddqgDY190bYaGxKrnG4nyuiaEmYVba+hwYeHaQ4uKCxE7
         HYXDpqoHqAk8XgqxSjY+8XCshVswgZWhymQzozh3OlNy4oJOVVgvJgu69ta4HQIf46pF
         d7WOq9yP9JVpDT7keomli/VQc+nDYbB/JqulmWe5Yses8B0/qg7oeHC3McYe/kJXlxtu
         7PxkGeoPw2EYoE8Lysy3m60i6pjxLZde3MOX1jBx5wDs3TFMOKmnf1g2DihzwA47sjmX
         5Xyb5H5C8FNbJzpY/dqXch4AWyZNQNvf2wlZVyEu/SA7QD0KNsVNt5cf5dA0zaVkel6z
         dRzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=As5BJs7Wcn/3NYRiYDzWUBHBtnYT6vEwUo+nQW+Syf4=;
        b=TMiZtvA5z+PwTlfKVOKhV/gm7YbQrhDpoFMvn8otY6DsVO6cE9DZa2z/mWuPMZcnom
         CYY8MrsxCRuxET764u5inEeRAHbGVkNWhXNjKLrNFsFI9XRn27bb+XClxnyG/RqFu3yM
         mWTllDH70rv/e1aLQiO/xBEiBSUjHJtEN3s6i6KCnAcd2N104Awbr80lvaCYDRNvMIsB
         VdPFqNWnEDVKk9xaCetpgyM58NjzpM9xVg5d4nzsGBtVLLWRxj61B/JYfHY3pAaYdq81
         KEUbsdix4Ial1vv9Jh+ZyTEEaK/janta5apPfej+L2Sdjba9/IUoGDoodEO964k4FCqD
         0dDw==
X-Gm-Message-State: APjAAAXy/+IPxo/jSomgmPJnH6pjUXxaCL2c4GzfJ7J6eanmvSPHDF6g
        x8QPFa35TWvhNIeuHBmCuRah5wGT
X-Google-Smtp-Source: APXvYqxFVFFSRHgAY4UpXfS928ohDYJQZ8gDQkTuvyuD/ZkX//ZIMpJWaiYV7F8NOEeJm+u2g8utZQ==
X-Received: by 2002:a05:600c:248:: with SMTP id 8mr32662655wmj.175.1578274476644;
        Sun, 05 Jan 2020 17:34:36 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id l6sm1412756wmf.21.2020.01.05.17.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 17:34:36 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 4/9] net: dsa: Pass pcs_poll flag from driver to PHYLINK
Date:   Mon,  6 Jan 2020 03:34:12 +0200
Message-Id: <20200106013417.12154-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200106013417.12154-1-olteanv@gmail.com>
References: <20200106013417.12154-1-olteanv@gmail.com>
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
Changes in v5:
- None.

Changes in v4:
- None.

Changes in v3:
- Patch is new.

 include/net/dsa.h | 5 +++++
 net/dsa/port.c    | 1 +
 2 files changed, 6 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 23b1c58656d4..0c39fed8cd99 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -279,6 +279,11 @@ struct dsa_switch {
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

