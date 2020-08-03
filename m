Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E812823ADE9
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgHCUEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbgHCUEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:04:05 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C80C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 13:04:05 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id e8so20671229pgc.5
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 13:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w3YhjIQaukEPPLH/jNkBUf/vMt37cfb63+G9c5Z5O/k=;
        b=Mo+zSk4uIxSmEmPk2t1x6aYKKTaLxhIOFmVd6EUr2gfAc7ULE7st8V54SGJGCtzWk/
         0mPru642TUHRdumqCed1yhdIw08JaDiJYMoryDsTvLVz9kSRz5i2NMk/qq6cw0/NnPVl
         waSPpm0pkEqgku1zaUu/wT0U2xX0LWXlgxr+NzTPYpT0VHbqv9e+H3iiS54mdCXHxL4b
         jPSUZOtbyQfIfXWLSEyroNUJqw7nuyGMAU9wELwrguLYi89n8L4qPLQGACO6mr0PV4YS
         GADGG3ZAaOYmryC6wiZaFDAqWiWO9x9L+MDBYczPNJv36jTlCd/hwKPBfMujzO1joGtW
         zq0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w3YhjIQaukEPPLH/jNkBUf/vMt37cfb63+G9c5Z5O/k=;
        b=i43sWVwe5QtwfCOoMPeiRrf4hwUYY+E1aH7WLH+pbdYtM8Ayy1Mtb5HmOm/XhQeJPO
         0u0SeJnSKLqZX5RLKqKsNXTnn8zp+IBkCC+uZA/JoSDnaKWk/ukWu81gZgiMZkHa6+Mh
         /shz1A2QSWupT2V9VEQBU3k983Uii+gWSQ7Jg03N/HUt1K3STUcbKZniKXDLbRNGzSRC
         hG5bjFFO6hKYcMeis5KIkq3WGFRufic1Noxk+jBOTYfbaaYoX+0Yw0gqDZV1X0awb/Yv
         v+67rLQcvhqKznwMKLHagKKS/o5xK+z+GGdkNi8ZaL6PYwXP9MUEUPeB6uv/MO4cj2zy
         hWQA==
X-Gm-Message-State: AOAM530FyJrs1k7XFOsvqDObm79HywAkmE9miu0L281X6LwCuIDqp0s5
        +ZrpcdvDJ99MfKlq8PV+yRW1Ig3m
X-Google-Smtp-Source: ABdhPJzaRXBkckWdfsE4UYuvLcxCJPwMFz5gtNSCB+GwGcXYNYIjvhnrAmcLbKPYMVMf91L9/HqWzA==
X-Received: by 2002:a62:6302:: with SMTP id x2mr17005957pfb.26.1596485044363;
        Mon, 03 Aug 2020 13:04:04 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u24sm20017521pfm.211.2020.08.03.13.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 13:04:03 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/5] net: dsa: loop: Wire-up MTU callbacks
Date:   Mon,  3 Aug 2020 13:03:53 -0700
Message-Id: <20200803200354.45062-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200803200354.45062-1-f.fainelli@gmail.com>
References: <20200803200354.45062-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For now we simply store the port MTU into a per-port member.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/dsa_loop.c | 17 +++++++++++++++++
 include/linux/dsa/loop.h   |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index ed0b580c9944..6a7d661b5a59 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -225,6 +225,21 @@ static int dsa_loop_port_vlan_del(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int dsa_loop_port_change_mtu(struct dsa_switch *ds, int port,
+				    int new_mtu)
+{
+	struct dsa_loop_priv *priv = ds->priv;
+
+	priv->ports[port].mtu = new_mtu;
+
+	return 0;
+}
+
+static int dsa_loop_port_max_mtu(struct dsa_switch *ds, int port)
+{
+	return ETH_MAX_MTU;
+}
+
 static const struct dsa_switch_ops dsa_loop_driver = {
 	.get_tag_protocol	= dsa_loop_get_protocol,
 	.setup			= dsa_loop_setup,
@@ -241,6 +256,8 @@ static const struct dsa_switch_ops dsa_loop_driver = {
 	.port_vlan_prepare	= dsa_loop_port_vlan_prepare,
 	.port_vlan_add		= dsa_loop_port_vlan_add,
 	.port_vlan_del		= dsa_loop_port_vlan_del,
+	.port_change_mtu	= dsa_loop_port_change_mtu,
+	.port_max_mtu		= dsa_loop_port_max_mtu,
 };
 
 static int dsa_loop_drv_probe(struct mdio_device *mdiodev)
diff --git a/include/linux/dsa/loop.h b/include/linux/dsa/loop.h
index bb39401a8056..5a3470bcc8a7 100644
--- a/include/linux/dsa/loop.h
+++ b/include/linux/dsa/loop.h
@@ -27,6 +27,7 @@ enum dsa_loop_mib_counters {
 struct dsa_loop_port {
 	struct dsa_loop_mib_entry mib[__DSA_LOOP_CNT_MAX];
 	u16 pvid;
+	int mtu;
 };
 
 struct dsa_loop_priv {
-- 
2.25.1

