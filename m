Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8236F3B6AAF
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237878AbhF1WD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 18:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbhF1WDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 18:03:07 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C5FC061766
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:37 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id i5so28291400eds.1
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8q4kkEQ6fmMwH2vZZgk3RBl2nTpfC/5pzFbK/qkE2Zg=;
        b=BDTbf4Rqjae5preCqMBM7V+YWwVpfVYwi+WnxouCpz++sQZoDjzPVmFs3DFVNWCreR
         OubOX7aohHbe4wl/SMaiEHPVJ/ZeizVRw/RSU9J7KqjOARLnPSmMK0wRTvF3IyslHU8A
         UPCfc7K/MqOmdv5Uxkl6nwM67CSHI6YrNIexqFUxLfIrVS7+rtp6Oul8aB/Wxz88E+DO
         U7BwoIVrslfrJdp4ov55V1erSJIyZoWIUXbjCzzlV2UZ2cpF9ALlv6+iWqOKF3h3WZrz
         r8ah9hI7hms6ahWb335CDRQMZDBbUeZhKgEXlelg6AuJZQJXKwqNLY8qD6KCNIo66EiR
         P3xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8q4kkEQ6fmMwH2vZZgk3RBl2nTpfC/5pzFbK/qkE2Zg=;
        b=duaAy98gfXDNeW4mt7jrXsLvv+N0j2JH43ob7ZU3HAyTOW2CyFWxD1mJqolKD+3hr6
         KCivU+IpBXrU5M6XqBieXxZI6XVbKTse8QEt+Cefg5qnejNBCSB43sEdtzyTEGLQs7zn
         mv7L5u/xEBwpBdBVtgo238a8RjRHISZuttfUVsy9T1vLjgGAQa5l22/Fm6yJUqp4/2eR
         0HyOicba2V4KJ1V8N4tItYwQ0Go2Dis+uBj243vHmmNwdRHC+RIMroX5r4wsLIrw/3Dk
         aL/T5+8snijUfpZcm/n7qCYKHM2kV7IimBUeN+A3v0ThLSyPsMxN05RiwVdYfhTAFF/J
         Gf2A==
X-Gm-Message-State: AOAM532fJOXPpk2bQmbmhBXPbSBcCyKM1t3CvFBIyW1esvKboJ89GeNi
        mkZ7DK3z+6f8obD0LjJDwusprCbhJKw=
X-Google-Smtp-Source: ABdhPJwe98lPcer4uCXqZ7SLbwBhOk0wY5ovwmoEWEsNnCqHQGRP7dfBzhLKn/SIp/ILBIDsh9CZwg==
X-Received: by 2002:a05:6402:58:: with SMTP id f24mr18417864edu.234.1624917636125;
        Mon, 28 Jun 2021 15:00:36 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id dn7sm10146615edb.29.2021.06.28.15.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 15:00:35 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 02/14] net: bridge: allow br_fdb_replay to be called for the bridge device
Date:   Tue, 29 Jun 2021 00:59:59 +0300
Message-Id: <20210628220011.1910096-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628220011.1910096-1-olteanv@gmail.com>
References: <20210628220011.1910096-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When a port joins a bridge which already has local FDB entries pointing
to the bridge device itself, we would like to offload those, so allow
the "dev" argument to be equal to the bridge too. The code already does
what we need in that case.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 0296d737a519..5a92bec02bbc 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -754,7 +754,8 @@ int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
 	unsigned long action;
 	int err = 0;
 
-	if (!netif_is_bridge_master(br_dev) || !netif_is_bridge_port(dev))
+	if (!netif_is_bridge_master(br_dev) ||
+	    (!netif_is_bridge_port(dev) && !netif_is_bridge_master(dev)))
 		return -EINVAL;
 
 	br = netdev_priv(br_dev);
-- 
2.25.1

