Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAA04A823D
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 11:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350068AbiBCKRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 05:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350053AbiBCKRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 05:17:08 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4E5C06173E
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 02:17:08 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id r7so1563328wmq.5
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 02:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=F2YhX5ZJBnxNe89ks74s5Pzt0pqk3KIaw4rsT0A7OK8=;
        b=6oT4NnlQmKCWvtO0py114RV1BTQ+uSu/vnDWC0vARI/gQnJXBBJH/E0cxYPJMWtoJK
         p0u3NKD2okTugpKwW8j6rAEusfYzE8SPso0xjGMXoykl0FI8HoKl5cabCaREpTyyjpgj
         rc0L2nzn6VqSEzuNMWPwScTqx53UenUWp3WZa/idMjZHI2lljLub5N3hUt+usXjPuxs0
         2l62+kE1WD3AN6pxqxuJjiTQ8tFrSUnDWU/nb4JpnL092emGwT/SZx/ilMHDNYdzGg8o
         94nZd5ZVJzu3KQOpHaKhwO1gXGAp2Lo+wvT8jKNvPn00RwkZTvVUtU2yOasCXElo4PlA
         XzSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=F2YhX5ZJBnxNe89ks74s5Pzt0pqk3KIaw4rsT0A7OK8=;
        b=WZaRRcQ1GveVYe7B5Qx3ZWhZjwS2kNBPkel0/m/lNAaPPxQ6af1dktascLQTm7z8YK
         4zct8uKzK2GefIxn241GWFu/qLrbahi4FBxCKm2wjzlHagzgS0Ct5E+mgF+mQAj2Lt7S
         RjMPi3vCRb57c6tusPysmC7sqV7Xu9KdJypj+AhfF+Ze8ZHySGmNXYDEBIu41ZM6fddZ
         A5vFYXX6GsDeGBO3Uz0Hiw0VEABUj4oSotmn/ko43dY1/VjOH5pBKfGtUNfGOTlfJ6rc
         NRSPmievpoFOWPlr/DWtwNczFte51CtQRJgC2hHkcU5c5GqEJymMnE0ZX6gjOHSXVhPh
         kBAw==
X-Gm-Message-State: AOAM531n9fWdzbyRaSgd41KgTRDDsjzTXLjmxeZpVElUbdPACqhyHKIa
        zIMIpi0C7h886xrM4il2Gh+bFA==
X-Google-Smtp-Source: ABdhPJw3WusF3iZcaWVaf+XwwZ49VD60N0jO6QaMCtWR3KGun0zcS4d9VG3SH3RySbw41V/hsZIw5g==
X-Received: by 2002:a1c:7416:: with SMTP id p22mr9805283wmc.30.1643883426691;
        Thu, 03 Feb 2022 02:17:06 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g6sm19017148wrq.97.2022.02.03.02.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 02:17:06 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 3/5] net: dsa: mv88e6xxx: Enable port policy support on 6097
Date:   Thu,  3 Feb 2022 11:16:55 +0100
Message-Id: <20220203101657.990241-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220203101657.990241-1-tobias@waldekranz.com>
References: <20220203101657.990241-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This chip has support for the same per-port policy actions found in
later versions of LinkStreet devices.

Fixes: f3a2cd326e44 ("net: dsa: mv88e6xxx: introduce .port_set_policy")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7f02ec502e71..99151ba6f545 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3652,6 +3652,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.port_sync_link = mv88e6185_port_sync_link,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
 	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
-- 
2.25.1

