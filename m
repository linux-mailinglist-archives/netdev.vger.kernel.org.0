Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E95365FCE
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 20:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhDTSyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 14:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbhDTSx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 14:53:56 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8CDC06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 11:53:23 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j5so37795400wrn.4
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 11:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=Fxq2aNWBDYlMt+0mMqLEmNM0lcL+eKFxYY/03Xq4jh0=;
        b=dVHmV8ocG3grGmzUQT7NNT2VE8XJFkvP5btnDjkChmcHqt6/OL88FgLvoaMkBLekms
         KozqsrQq/GFKakTPFP+KMJhi/zWdjZ6DIaZn4Q5defxUH+SW9HtbxikpMMMAXwBhguoo
         Pu4CCiTVAE6g39qOOv0dV4SfA9+g7VQhLDg/Ru7Hls54qu4Trs9zEtbwOF8jTltBOZmi
         HTBCIgx5sPWqdqu3uJzQ/qfx4Cy1qXZ79Gp/nLXg7igL3DJh+Kahd39Haw4GZ64NriwP
         Ah6xX/UE3EqaOmZcg3f4286TeJKDrOlTz3anN4Qh8M3FQf4A9GW33N4iPL6rWYxlnZLO
         zPUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=Fxq2aNWBDYlMt+0mMqLEmNM0lcL+eKFxYY/03Xq4jh0=;
        b=eEbwrJpuVwIj89JlpcKfdWJwsAVsPKEhzeKbPvuDRIzYLhKwsd58iLLiRo1kGr/Uvx
         4FEDCUwbjXbqBG7A/hvYEsTYMLYGx0odgyyb1cBMrnqTaO4p0DnNvCK6hzE2TPlw6y7V
         cLbqcwH+ot7oqh/j7RNShhz4WQnMYdBYjrDkcM4GkpqfpdlopgJAOuEScVpKfsklz65p
         vYF2onwL7t1xXONWaaVkUFsvMj3RMe25PnMcOi4Oydti540lyovJu9XbqX7ndRsqbXYH
         JBbex1EyGhiXcpBW33jmjDdFvFm2vLvBFVajyuvHHDRAYoMy0HM3p5Zz+cPEA6SGauB8
         XPiQ==
X-Gm-Message-State: AOAM533I0mE8eHVROSrXAkawlevL6I+8ejyoyfewM2IhujHZ9o0ZZ8To
        VvI1x2rtwLDi0nki79n6yqlz7Q==
X-Google-Smtp-Source: ABdhPJzk9BmaHK+BNCLyXzO7h+BWPmSCoQxj7SMI1cSTt85d4cb/oOk1KDXDA3scRVXcp+9jgZ7/tg==
X-Received: by 2002:adf:b1d3:: with SMTP id r19mr23051006wra.97.1618944802683;
        Tue, 20 Apr 2021 11:53:22 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id f7sm25897402wrp.48.2021.04.20.11.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 11:53:22 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v3 net-next 2/5] net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
Date:   Tue, 20 Apr 2021 20:53:08 +0200
Message-Id: <20210420185311.899183-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210420185311.899183-1-tobias@waldekranz.com>
References: <20210420185311.899183-1-tobias@waldekranz.com>
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
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 39 ++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 3e8b914aaf37..be0bb79de553 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5550,6 +5550,44 @@ static enum dsa_tag_protocol mv88e6xxx_get_tag_protocol(struct dsa_switch *ds,
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
@@ -6012,6 +6050,7 @@ static int mv88e6xxx_crosschip_lag_leave(struct dsa_switch *ds, int sw_index,
 
 static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
+	.change_tag_protocol	= mv88e6xxx_change_tag_protocol,
 	.setup			= mv88e6xxx_setup,
 	.teardown		= mv88e6xxx_teardown,
 	.phylink_validate	= mv88e6xxx_validate,
-- 
2.25.1

