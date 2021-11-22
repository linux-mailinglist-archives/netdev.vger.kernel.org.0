Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A765D4587A7
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238594AbhKVBHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234187AbhKVBHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:07:12 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3F8C061714;
        Sun, 21 Nov 2021 17:04:06 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id x15so69481759edv.1;
        Sun, 21 Nov 2021 17:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ipg/cwuxG83ZlRU4KmBiBPxEeFiq4DS4sY/hkaep4GU=;
        b=T7CEQX5/JFmU51NfkTIs+qbKwsfOjao2NL9EAqrUNRmU2wswmIuhKT18+LiFz/9kbJ
         EkuURCmF928vQVIVCq+lPZOtGY9TwfZdYcJF0+TwMZ3GFiVS6IFMGoG2S3MiDkHePluk
         xNPE7mMHC5BIopN+c/o8kraF93WfFPBOp3VqQmWtnF12/9SQg/cc0pipKpeigd1NBj3Y
         KwwS4S9IWvab8TOmkcjHyZxQNJ4GjXQ5gdYww384jNJNAL8u+pVtNS0o9jRypp3Ezdsu
         wMFLF98/cBOfMX3nKYTbNp4DLNK+hBKk42DugLOKrLBbKRLPT+xil6WwxqQAhmlTEk/S
         s0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ipg/cwuxG83ZlRU4KmBiBPxEeFiq4DS4sY/hkaep4GU=;
        b=Un0m7MFG4l0CbGA98LRbGqogwENBf/hUO0QDAeVdUtYkZkxNjmZkP1/ky+KRPxSh+l
         m/3zCVRcqvZqEIEF1cXH7zXhn4wlWGFH8nZhwXKiGcyM5TwY/SSOEBJpeafmgiw9q13Q
         dGkiTzfjkhEfK5oiN/cx46LLGb97VP1zJdtYT74+3TZ1fUs+rqGup/9V2EbZ7n3+O7Xc
         qfnPHw+UUmVWDq2UKBmZkJivZgTH+B8VZU5GQEBARb5LZPmaRNUJ+iaLAGd5GawIIyI4
         IZuy/Ku5bJIx/keqaJxOmvKUQKstnyai91VQbEHzLEg/A4773R0ojt5V9eTVS9oPclC1
         Me3w==
X-Gm-Message-State: AOAM530LFY68YIeC06ZvKSObp5K48dCVtPUT5NIf/9ErPpQcKs82ICAm
        E+uK88mQD/OBess2HAXwSh8=
X-Google-Smtp-Source: ABdhPJxWu8PET0Xeg4a4DYFoUox3vh4Pr9ltZJrO80YLfC1turllo9awo7iaZ1HQVKzb+IlTaakZug==
X-Received: by 2002:aa7:db8f:: with SMTP id u15mr16932304edt.47.1637543045425;
        Sun, 21 Nov 2021 17:04:05 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id c8sm3208684edu.60.2021.11.21.17.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:04:05 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2 7/9] net: dsa: qca8k: add support for port fast aging
Date:   Mon, 22 Nov 2021 02:03:11 +0100
Message-Id: <20211122010313.24944-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122010313.24944-1-ansuelsmth@gmail.com>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch supports fast aging by flushing any rule in the ARL
table for a specific port.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 11 +++++++++++
 drivers/net/dsa/qca8k.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 57ba387a4aa1..1ff951b6fe07 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1776,6 +1776,16 @@ qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 			   QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
 }
 
+static void
+qca8k_port_fast_age(struct dsa_switch *ds, int port)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	mutex_lock(&priv->reg_mutex);
+	qca8k_fdb_access(priv, QCA8K_FDB_FLUSH_PORT, port);
+	mutex_unlock(&priv->reg_mutex);
+}
+
 static int
 qca8k_port_enable(struct dsa_switch *ds, int port,
 		  struct phy_device *phy)
@@ -1984,6 +1994,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_stp_state_set	= qca8k_port_stp_state_set,
 	.port_bridge_join	= qca8k_port_bridge_join,
 	.port_bridge_leave	= qca8k_port_bridge_leave,
+	.port_fast_age		= qca8k_port_fast_age,
 	.port_fdb_add		= qca8k_port_fdb_add,
 	.port_fdb_del		= qca8k_port_fdb_del,
 	.port_fdb_dump		= qca8k_port_fdb_dump,
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 91c94dfc9789..a533b8cf143b 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -262,6 +262,7 @@ enum qca8k_fdb_cmd {
 	QCA8K_FDB_FLUSH	= 1,
 	QCA8K_FDB_LOAD = 2,
 	QCA8K_FDB_PURGE = 3,
+	QCA8K_FDB_FLUSH_PORT = 5,
 	QCA8K_FDB_NEXT = 6,
 	QCA8K_FDB_SEARCH = 7,
 };
-- 
2.32.0

