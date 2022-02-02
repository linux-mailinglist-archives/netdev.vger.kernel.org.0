Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E5B4A68F7
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243135AbiBBAEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243110AbiBBAER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:04:17 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA4FC06173B;
        Tue,  1 Feb 2022 16:04:16 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id p7so37891411edc.12;
        Tue, 01 Feb 2022 16:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z9VGchsPoiNssfykfKpnr6kDcC1pZ+R5aD7drdmLAPA=;
        b=KM9JOsJ3pWyyciBhOdnBGiUF9l0FW4I1jbD85meOFBdc9aqV2Y18RVwTeUNn3U66R/
         dyLqheEMv8LQ00yPSQxuZ2ifLxDkCKaY7bEf8TqSwgnf097W+dU53XeBQnYr9A2S7q24
         PmFhu/rmLw99oaB4V9mfc1ZplPkwE5tyivdu/QwaMG/CSG6Fsr94xW+gSaAmdpErYrwr
         s9iyC7C4YPIAQF4tXn8sTzo9LfI841/WON3nwjdiPgt62vTeZ+jPVvE+gAEoJKP6hEMv
         tTq4v6LZN48jxEFfGnFncCWgcU9BUEp2+mWZ1aRMsPJbST/bBAY53TXjMVvJnpYhzuE4
         2EnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z9VGchsPoiNssfykfKpnr6kDcC1pZ+R5aD7drdmLAPA=;
        b=lFvz7uZ1oGbSQ0n9PLANFvdfMUteUmM9Ts5vnsjdNBY0rytNZf4YnlB1oOi+XW4Xxj
         5g/Xs3p0cuwhltXaGnTU+2Q5R6unOHB6azL2c7Qx7eylE8wHwpmM11BsSTzwAMYMgUie
         XeZZesOjSmRkr8hLhFrZ0CFyyamWetDIJs46WDwbq+PHTpFFdqcAcinnXlufEHZpXdbU
         KHcfKk7XTvS/GslXthPcxdklXyYcDvPXmXpQQ8N1oWeYKSzndqYYMXu1jACbvVRPsDq7
         i95MzYKJf4iny130M1jCekalQJU+dISSelO3D8U//9nQG+Mw/xA4be5+Q9MfLtFMswOH
         Txjg==
X-Gm-Message-State: AOAM533zuvwkLZp8k0LRHPYQUsksynNV83W/sVMAPGkvTxjM/YNf2rF1
        0NGRy0ziP37xcLGAM3ZkbpQ=
X-Google-Smtp-Source: ABdhPJz+5joJ7I4Seo3Ebr8vtIviOmthgO16WXP1vN5/rD94n8BkNhbI04od638o9PXUrdLOXKRxXw==
X-Received: by 2002:a05:6402:190d:: with SMTP id e13mr28068962edz.38.1643760255449;
        Tue, 01 Feb 2022 16:04:15 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id n3sm3590451ejr.6.2022.02.01.16.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:04:15 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v8 05/16] net: dsa: tag_qca: enable promisc_on_master flag
Date:   Wed,  2 Feb 2022 01:03:24 +0100
Message-Id: <20220202000335.19296-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220202000335.19296-1-ansuelsmth@gmail.com>
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethernet MDIO packets are non-standard and DSA master expects the first
6 octets to be the MAC DA. To address these kind of packet, enable
promisc_on_master flag for the tagger.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/tag_qca.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 34e565e00ece..f8df49d5956f 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -68,6 +68,7 @@ static const struct dsa_device_ops qca_netdev_ops = {
 	.xmit	= qca_tag_xmit,
 	.rcv	= qca_tag_rcv,
 	.needed_headroom = QCA_HDR_LEN,
+	.promisc_on_master = true,
 };
 
 MODULE_LICENSE("GPL");
-- 
2.33.1

