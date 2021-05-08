Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D783376DE2
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhEHAcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbhEHAcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:32:03 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6A4C061373;
        Fri,  7 May 2021 17:29:50 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso7283504wmc.1;
        Fri, 07 May 2021 17:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aOXIFQ6B/eqAVp4zbCeNkJnyhpNrD5T3KEJwsOpWC3o=;
        b=s2rEjKatrA4fQGVJiVFY8oerE9fRBgjLNhXXup+DTfDYkDDHVM/7UUh6SiZ1I2Swnc
         TGB8BMO4oMB0hiHZskKCtnUmY5dOz+0achz4M4ThIGGrvInP9QxG4DKd2jcqQ96f0QGE
         6j9GXXSc2nVtf8PGRNOinsBalqvk/AGU13eRX/AOdaua60yJdK3HdvUoEJKY5mCBhEpg
         +XERb9NcIgUmRe6U+ziNPcTT2FxXWm8RGhi2n2OvYRK9RSEdka/XzjsWW9M43Z0otDNN
         yB7gQSuEqb7QtJbxLJ2bLmQ/Scg9PQSjgpjNRC1UUbhPo/QpNk4QWhAkSm0DQZfCbKON
         tWRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aOXIFQ6B/eqAVp4zbCeNkJnyhpNrD5T3KEJwsOpWC3o=;
        b=bpG0micWGVnML3jXxaQN+zT6tDzPnTejYotXbfT6s+BO5Ag3M2Jg4BkS8OBnzoMsHu
         MMY8WQIYNCAspJXjnkgJkmstAo6i/2YXtCuDS9XPRm82R/dIk8vqlnY2O/vLo/MYJ1a4
         rI4dmMOf1ly+zkagvnTE9o3EtY22SzH0Z0EvyLIUs0aeVgnoOoEc5cY21rXPfTb/oHo+
         QkdxFNc0ZmHs98Qejusixjyl6bw0MLrvknuli5oB844Lf/dF/p++Nu871X0SEqx0Ibl9
         mipPTNSVJ/tVR02JhmEVX4BLgqduHaI0tldu58Rqj0wfA1YcRJPrMM0ENRLKfwNrv7xf
         JFNA==
X-Gm-Message-State: AOAM533xoV+jvozuy7uVjApknb3Vr0bz+aTqjA7kb6PeTmy2D1hhXdyf
        ZDxcZ0IPGC9cX/sPA9rJPEk=
X-Google-Smtp-Source: ABdhPJxAxvHPKWcpJwC1QxE85Ah5URf4mvJNLseQKQUQsG4v9SCqdFFONKftYcwh19n3ptGYNrIirw==
X-Received: by 2002:a1c:21d7:: with SMTP id h206mr12389354wmh.56.1620433789333;
        Fri, 07 May 2021 17:29:49 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:49 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 27/28] net: dsa: qca8k: pass switch_revision info to phy dev_flags
Date:   Sat,  8 May 2021 02:29:17 +0200
Message-Id: <20210508002920.19945-27-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define get_phy_flags to pass switch_Revision needed to tweak the
internal PHY with debug values based on the revision.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 3c3e05735b2d..8dafa581b7fa 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1678,6 +1678,22 @@ qca8k_port_vlan_del(struct dsa_switch *ds, int port,
 	return ret;
 }
 
+static u32 qca8k_get_phy_flags(struct dsa_switch *ds, int port)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	/* Communicate to the phy internal driver the switch revision.
+	 * Based on the switch revision different values needs to be
+	 * set to the dbg and mmd reg on the phy.
+	 * The first 2 bit are used to communicate the switch revision
+	 * to the phy driver.
+	 */
+	if (port > 0 && port < 6)
+		return priv->switch_revision;
+
+	return 0;
+}
+
 static enum dsa_tag_protocol
 qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 		       enum dsa_tag_protocol mp)
@@ -1741,6 +1757,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.phylink_mac_config	= qca8k_phylink_mac_config,
 	.phylink_mac_link_down	= qca8k_phylink_mac_link_down,
 	.phylink_mac_link_up	= qca8k_phylink_mac_link_up,
+	.get_phy_flags		= qca8k_get_phy_flags,
 };
 
 static int qca8k_read_switch_id(struct qca8k_priv *priv)
-- 
2.30.2

