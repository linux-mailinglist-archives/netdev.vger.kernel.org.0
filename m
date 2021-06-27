Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6231A3B539A
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhF0OMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhF0OMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:12:49 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BD1C061767
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:24 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id v20so5862918eji.10
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8q4kkEQ6fmMwH2vZZgk3RBl2nTpfC/5pzFbK/qkE2Zg=;
        b=LKHo6ZiULmz/l65Cvr7GoMQRoCII+8+ilHzKaWJgV8sw9JRIfDVitA6h/CYVQ9dSMW
         9f4jyrLXG3HyIhSJYjGScdJw5IDvr1K2yIMSAs82+I2M/lA1CW6Ek0Qk4oHCDcTwqhXj
         7S8qZwDj2qXwvAq2JqkzAdDbFXQCqEmNk2GKWOJt6t6z4MEPOgI+5achVrZDuzejw6I2
         fJww1FiLgp3fUfgier4lqlrxZLAYmio34Vcb8CRnFHmAUV8QKX9a8n8DkllmKzL6SRZs
         OE5js6SH0U6nvxwfLQwnDOSp5Hofjys1UIkujacw19G+a6qXpZG1pkyQRZzq5eEfzG8u
         b8zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8q4kkEQ6fmMwH2vZZgk3RBl2nTpfC/5pzFbK/qkE2Zg=;
        b=CXcCIj6xB54vPCm9kZF7c7thcxQfLP97qcmFSJF9clcVll0sxui2alsIFDtNLfM4k2
         td+8OSRPSLwBi+0di39NlmBRrrPKVRqqZ2nSQs+6UiuH9vOkhd45SCBXbSSyFnSkq0bj
         aMe9d91QdnPZSnqMv5NisPabnyvl9bMnIlG1AyP3rnolRFB2AD8kEPsArddUs2dey98i
         pSSK1gV8TRJBN+SkrbBuodrkxuqcqIPHt1s/zmORpzk475gJftupM066K7QoQE/3rC1s
         r8Luwdvk951dbEOMohAfo/QjI56rSaeWaZC3VmrlJMvms7mICPgHGIM+NngZtngoxQO1
         lJZg==
X-Gm-Message-State: AOAM531eQNVmfyDrx2PrH7ZRkwAnCt3fNTIBAoBmcAZXaKmav8vENmI5
        65odDd20GPN8j8wP0dfHSlMfqbvoa0Y=
X-Google-Smtp-Source: ABdhPJy1yXmYav1eQE2ylei6tLip05VVqEtl18Y89SPLX9cJPSt0WdoxrVi+LqOIrRC8YTo7y3psxg==
X-Received: by 2002:a17:906:52d5:: with SMTP id w21mr20535468ejn.490.1624803022836;
        Sun, 27 Jun 2021 07:10:22 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7857389edu.49.2021.06.27.07.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:10:22 -0700 (PDT)
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
Subject: [RFC PATCH v3 net-next 02/15] net: bridge: allow br_fdb_replay to be called for the bridge device
Date:   Sun, 27 Jun 2021 17:10:00 +0300
Message-Id: <20210627141013.1273942-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627141013.1273942-1-olteanv@gmail.com>
References: <20210627141013.1273942-1-olteanv@gmail.com>
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

