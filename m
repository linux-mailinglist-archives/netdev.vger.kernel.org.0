Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0718B36059E
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhDOJ1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbhDOJ06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 05:26:58 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82CDC06138C
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 02:26:33 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id z13so21100008lfd.9
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 02:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=RNfoJIGZkQse3f3u/cX71QiPxHyPxyz9lWUP+SrS5CU=;
        b=aMNjttAG1ikqZGyrkhTzidfriWE0QgnrTmfIrPuY7EH4jH4iQee6otPPKz/SFtfmil
         zsVa8r1RvyVS6DhYzU46t1teYctfg/FfyGf0KsPDHIH5a7WIsrsvP+rK+idXYvqmH+F+
         BLIxGT5aUKbSJiC0eaSN+Tlfnezc+7PtroOliVYR/YBSIEJ4x4shsMyNCgkLwA73/iuo
         fkrZo/xZnqzBeaxgPdWBUVTw2GnTAbT5iyHFfciNVmuGmMUNRRij3mFuNpC6hdVb44rN
         zMOhrLAe9LPs2bN4RPpYa31E/12XPe7Z99B+kgzyYBwkUaXtf/9QGfLC8YWCJ/e0a7YM
         PNoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=RNfoJIGZkQse3f3u/cX71QiPxHyPxyz9lWUP+SrS5CU=;
        b=HO+2YjxR/Y2Jl4LyOeJFjhupRqOPA2qGZBbLMaikQzG7vLiJfdYP+x2LoGi+KlUUgt
         NlmrhxbBvyX1yUAbil27k6CFYCImYatUI7Cmfuajutn9pWaISYHqnBKm09mIBbi78oV1
         bHDcqDroLdDVXFJMeSq38KgX8Ezo3dhYWJs6K86FQ1jWJUd+KJxmiGP5Vw20goIo1dYD
         17wttVHuG2CjKsc+g6DxfGMDL+MmuFNT8e8IDwdc4PCXBCnVAWaw0GCwimP1a8ljnj/U
         1NSF4QCSO217WSNsTlpIP9EXJptoYlscB2df2DJtR8uqZt5va9MeDHEYxjWnutxoGC9M
         Mtrg==
X-Gm-Message-State: AOAM532i6Vxe8LygPbB/Ra5CGiP05CrOlFDP53jKNckdIMMyg+EGE0GE
        KOme5nETrvYTAzDwHSStUpoVnw==
X-Google-Smtp-Source: ABdhPJy/YbAwfmjLbJ3+FCCEwMTqREZ1OpagPoDF0ZKGmxTWDSB7KkXKj9CfItW4K75XcT5QcLwTmQ==
X-Received: by 2002:a19:ec04:: with SMTP id b4mr1876924lfa.141.1618478792295;
        Thu, 15 Apr 2021 02:26:32 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g4sm595557lfc.102.2021.04.15.02.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 02:26:31 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 net-next 2/5] net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
Date:   Thu, 15 Apr 2021 11:26:07 +0200
Message-Id: <20210415092610.953134-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210415092610.953134-1-tobias@waldekranz.com>
References: <20210415092610.953134-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For devices that supports both regular and Ethertyped DSA tags, allow
the user to change the protocol.

Additionally, because there are ethernet controllers that do not
handle regular DSA tags in all cases, also allow the protocol to be
changed on devices with undocumented support for EDSA. But, in those
cases, make sure to log the fact that an undocumented feature has been
enabled.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 39 ++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 09e3c47bf005..e9f79c9e9947 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5554,6 +5554,44 @@ static enum dsa_tag_protocol mv88e6xxx_get_tag_protocol(struct dsa_switch *ds,
 	return chip->tag_protocol;
 }
 
+static int mv88e6xxx_change_tag_protocol(struct dsa_switch *ds, int port,
+					 enum dsa_tag_protocol proto)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	enum dsa_tag_protocol old_protocol;
+	int err;
+
+	switch (proto) {
+	case DSA_TAG_PROTO_EDSA:
+		switch (chip->info->edsa_support) {
+		case MV88E6XXX_EDSA_UNSUPPORTED:
+			return -EPROTONOSUPPORT;
+		case MV88E6XXX_EDSA_UNDOCUMENTED:
+			dev_warn(chip->dev, "Relying on undocumented EDSA tagging behavior\n");
+			fallthrough;
+		case MV88E6XXX_EDSA_SUPPORTED:
+			break;
+		}
+		break;
+	case DSA_TAG_PROTO_DSA:
+		break;
+	default:
+		return -EPROTONOSUPPORT;
+	}
+
+	old_protocol = chip->tag_protocol;
+	chip->tag_protocol = proto;
+
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_setup_port_mode(chip, port);
+	mv88e6xxx_reg_unlock(chip);
+
+	if (err)
+		chip->tag_protocol = old_protocol;
+
+	return err;
+}
+
 static int mv88e6xxx_port_mdb_add(struct dsa_switch *ds, int port,
 				  const struct switchdev_obj_port_mdb *mdb)
 {
@@ -6016,6 +6054,7 @@ static int mv88e6xxx_crosschip_lag_leave(struct dsa_switch *ds, int sw_index,
 
 static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
+	.change_tag_protocol	= mv88e6xxx_change_tag_protocol,
 	.setup			= mv88e6xxx_setup,
 	.teardown		= mv88e6xxx_teardown,
 	.phylink_validate	= mv88e6xxx_validate,
-- 
2.25.1

