Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E4532F745
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 01:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhCFA1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 19:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhCFA0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 19:26:53 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C052CC061760
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 16:26:52 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id q14so5298037ljp.4
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 16:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=oDoIk1yzAHwQSxAa8k8D9ltRoRL6h7whx75BifLj1Bw=;
        b=u00hw+kTzS/AHe1pmVGZTQ+ul8jF9q1N9DxAnRdkvoY85iiExN/IMuLA41QFAyGylm
         94gUZUsn7CRA8hS/KqW/QpIkQmKGsJwyXLhb7eg0AzqPYoOGWyDeE43w4pVs9InBKGN+
         9rn5KeYVYhtiAV8QpgPaokufsm+DEPKhn1dV3lXWeUch2ESrHzjX8vVnlNAL2w6D+z8R
         GP1U+N0FB7GqcFB1bJU+wFqOWTU6Gdb1uao5lQ+Er8DAZsdm32G8sAw4Yxu78wrOGGNW
         xI32EkX71xcWQ3IialtBEUdQNMfIYyVdZW7Luc9x4Rd5Fx/Tyu7vqAIheTNQ7kdTQwrP
         0tDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=oDoIk1yzAHwQSxAa8k8D9ltRoRL6h7whx75BifLj1Bw=;
        b=Re/pD0eXmlAful1gnP1pBHxvy99OQGtNHlHQixGg3rQx2cTP2d/5yuo2doQgPGBLa8
         Qk3KDcdznF+bkHLD3pvvo1BQcjqKOPbPo9eKMK9memwNPWSV5/1ggeaOPucwRBb40N/O
         JoHOPSEpKSLtXNdYXVf+wMg9Ezc281p/coQ9NV75yMsPI3y7uY7tHjXkYO9bswrkAS3m
         yJVeY5YA77NrrnFwaRHwy8kDWiJDKlrb5OHkEoO94vDnQtqwRbT9WdO2R18HtFL1xFFe
         Hm/LBJbM8GV/hOapjqruiK/9qn/++KgKjHetdvUK0pcRrXbHYRYsOdm3HB1u10nEu1s7
         jxkg==
X-Gm-Message-State: AOAM530nemBRE88ESbhJGpBfzFw2aqgkqMpIgL2Yvu8qEKKnFG51qgUp
        tEtoCnkWbZg5sWktsmp9CZYzcA==
X-Google-Smtp-Source: ABdhPJyxVMJ2oGfNTIJVz8xUSqcl/sXUx7+Dw68qHGxrZNjI5sf+pP4rQ0Fam89pQbCqgFQOA/MWCw==
X-Received: by 2002:a2e:320c:: with SMTP id y12mr6944754ljy.360.1614990411336;
        Fri, 05 Mar 2021 16:26:51 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id r5sm488678lfc.235.2021.03.05.16.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 16:26:50 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net 2/2] net: dsa: Always react to global bridge attribute changes
Date:   Sat,  6 Mar 2021 01:24:55 +0100
Message-Id: <20210306002455.1582593-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210306002455.1582593-1-tobias@waldekranz.com>
References: <20210306002455.1582593-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the second attempt to provide a fix for the issue described in
99b8202b179f, which was reverted in the previous commit.

When a change is made to some global bridge attribute, such as VLAN
filtering, accept events where orig_dev is the bridge master netdev.

Separate the validation of orig_dev based on whether the attribute in
question is global or per-port.

Fixes: 5696c8aedfcc ("net: dsa: Don't offload port attributes on standalone ports")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/slave.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 491e3761b5f4..63ee2cae4d8e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -278,8 +278,21 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int ret;
 
-	if (!dsa_port_offloads_netdev(dp, attr->orig_dev))
-		return -EOPNOTSUPP;
+	switch (attr->id) {
+	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
+	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
+	case SWITCHDEV_ATTR_ID_BRIDGE_MROUTER:
+		/* For global bridge settings, the originating device
+		 * may be the bridge itself.
+		 */
+		if (netif_is_bridge_master(attr->orig_dev))
+			break;
+
+		fallthrough;
+	default:
+		if (!dsa_port_offloads_netdev(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+	}
 
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
-- 
2.25.1

