Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927254715F5
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhLKT6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbhLKT60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:58:26 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1397AC061751;
        Sat, 11 Dec 2021 11:58:26 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r11so39429988edd.9;
        Sat, 11 Dec 2021 11:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X4wMhrUN84KeHeknaHhQMPltoPDB0WqcvrysGGLndQ4=;
        b=Uf7GxC+79Ck+6+4Tyokz7vLSBYHQA24jdtjn7YUaEz5NZrzhyfaaDA1jHs+Zu6s/fo
         YyDVs5jLsBOLyo8Oc88unbyT0guDxrFwvl7i8gWOJ3sss5geJKjMN9F5vKxq+pCAdCW9
         UWNJmUsVV1TYCem4RbdDHF8usykEWJA34KSHPtslxLllxcfMdv+DF2M3vdL4ZeaoSwVR
         cVNnuqCTAN8droHv6TvfVODnq2yOUyY9t5WDW7rWT58Wtg1IsIA2O2iuBAXSQjJMNAUJ
         GgcSG3d1Hf9XtB5hDGqbImY68kAqc4/t30R9+pbSCTbgZA/tkPnaAZHMDK8fth6IEXqv
         xmcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X4wMhrUN84KeHeknaHhQMPltoPDB0WqcvrysGGLndQ4=;
        b=ogIIoATL3aBtl9eEAah9eORG4LRrex9Cd75mu42a2/mHjFBJ07WF6ejJ0Bniz+Qkl/
         PICeD3Io02yRFXiAQ3i4yQUHAiivCgFzqkdNUWVBtrLuab2oJ7kYpcxVNd6YLt3V1PNK
         UWIi1yb0bP7IqNr1U7ZPod8LbXgpRt8Gu26ycLmLb/F3T92ZkIJY/0CCM933bL147ddK
         m+8GaQTTgO+XeZzBHl/GcmwOfYFqRh98Mqs/idwsv5EKpb1PqUS6Z+z9GqRHhajBqsnb
         9dXM9LunMQoj2ynJgAJ1naYj5SJAMmafrInQdyb1JZkCk0/aNmf+DFSWo5DO9vVCwj22
         /Uvw==
X-Gm-Message-State: AOAM532HOY4RJavYXx5lDF6jCOUS1YJ58L4kMoKggViidDu33dAkEzNc
        KmQ6PjI/OqRmjPCRG1iTvko=
X-Google-Smtp-Source: ABdhPJzQjtBSUyNLY2dVrs8CdV4VT/0f4Kg+5lhLX3K8avHO9Kvtw2X1DkfxNrMQdc1nO0Sa+kguVA==
X-Received: by 2002:a17:906:4fcd:: with SMTP id i13mr33800652ejw.472.1639252704590;
        Sat, 11 Dec 2021 11:58:24 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id e15sm3581479edq.46.2021.12.11.11.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:58:24 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v4 10/15] net: dsa: tag_qca: add support for handling mdio Ethernet and MIB packet
Date:   Sat, 11 Dec 2021 20:57:53 +0100
Message-Id: <20211211195758.28962-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211195758.28962-1-ansuelsmth@gmail.com>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add connect/disconnect helper to assign private struct to the cpu port
dsa priv.
Add support for Ethernet mdio packet and MIB packet if the dsa driver
provide an handler to correctly parse and elaborate the data.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 net/dsa/tag_qca.c | 52 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index b91f9f1b2deb..7edc198fdb60 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -32,11 +32,15 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 {
+	struct dsa_port *dp = dev->dsa_ptr;
+	struct tag_qca_priv *priv;
 	u16  hdr, pk_type;
 	__be16 *phdr;
 	int port;
 	u8 ver;
 
+	priv = dp->ds->tagger_data;
+
 	if (unlikely(!pskb_may_pull(skb, QCA_HDR_LEN)))
 		return NULL;
 
@@ -51,9 +55,19 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	/* Get pk type */
 	pk_type = FIELD_GET(QCA_HDR_RECV_TYPE, hdr);
 
-	/* MDIO read/write packet */
-	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK)
+	/* Ethernet MDIO read/write packet */
+	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK) {
+		if (priv->rw_reg_ack_handler)
+			priv->rw_reg_ack_handler(dp, skb);
+		return NULL;
+	}
+
+	/* Ethernet MIB counter packet */
+	if (pk_type == QCA_HDR_RECV_TYPE_MIB) {
+		if (priv->mib_autocast_handler)
+			priv->mib_autocast_handler(dp, skb);
 		return NULL;
+	}
 
 	/* Remove QCA tag and recalculate checksum */
 	skb_pull_rcsum(skb, QCA_HDR_LEN);
@@ -69,9 +83,43 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	return skb;
 }
 
+static int qca_tag_connect(struct dsa_switch_tree *dst)
+{
+	struct tag_qca_priv *priv;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->ds->tagger_data)
+			continue;
+
+		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+		if (!priv)
+			return -ENOMEM;
+
+		dp->ds->tagger_data = priv;
+	}
+
+	return 0;
+}
+
+static void qca_tag_disconnect(struct dsa_switch_tree *dst)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->ds->tagger_data)
+			continue;
+
+		kfree(dp->ds->tagger_data);
+		dp->ds->tagger_data = NULL;
+	}
+}
+
 static const struct dsa_device_ops qca_netdev_ops = {
 	.name	= "qca",
 	.proto	= DSA_TAG_PROTO_QCA,
+	.connect = qca_tag_connect,
+	.disconnect = qca_tag_disconnect,
 	.xmit	= qca_tag_xmit,
 	.rcv	= qca_tag_rcv,
 	.needed_headroom = QCA_HDR_LEN,
-- 
2.32.0

