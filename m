Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9E52074F9
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 15:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391176AbgFXNzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 09:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391147AbgFXNzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 09:55:37 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFCBC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 06:55:36 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id w6so2541043ejq.6
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 06:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nRXeeiV+6AMwWIyfD4fOnxbB2s57MwV62kv3aXCdeZ8=;
        b=OrR6ZmFivkqv6TpRFwerxWZYuSe/2Y6T3rie0tNjthdCYD6QoSp93fzCiyJGLCkJom
         HqlyEKo8J5G69Gh8QEwZ94R63OclK7DmLrnGGlhPQ0Ozu6Apt8PPczN6cNsgizWwPDGi
         2dksBL4xw6Be75jayZUFaQNerWSXqknA6HK3K5BjUt+mMBGlYzsqqVCH6YeLXaM2Cnip
         22jmuzXMHwcybOnvVVQ9lcFdruJOdHjpqvvLZ2+yE73HgeEoWGNaS8rDe2zfZYDbWcrF
         AxDFWucv3CGLQfRnrTp941xrA5W8LmqO/BMM1aFVljm7hpULDzRUZ6uo05ih58X1PEq6
         lwoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nRXeeiV+6AMwWIyfD4fOnxbB2s57MwV62kv3aXCdeZ8=;
        b=mVmidLfX5+ytOSJkGs7/P3EbtQ+7UDI2pYx38upAHJ5Kv9rZvuAPweti0wbkCN2Tr6
         cqvCpoKzY9lHppGVjTFZB1RhfAE6AaSW3np0IJUkkk7uUBwR8+dZqNxPShgxD5aG2iks
         PKiJx3yRiJKg8qyce5dawVTDyrFkAZAX7OfP9v128uJjUwsBCXS/I3SedFgrRf7p5xNM
         N/MH/fnugFnoD23fOhtDrS0hKZM7T/LoIfSJjlz1mQl8It7D0XT9UqPgVmZPUnMV4TW2
         SNLZsQ6tkeQIdR+7YerkO6yd3sq5gQYmjtw3mU80d4Yb9iIalqhPNVY9qYopeue4dp9J
         198w==
X-Gm-Message-State: AOAM531EVXPf53PPhPQL7FrGG2PnTi2J5mXau3FFCGoZY0zzHaGOdD1y
        pxPNHcaHUhtkqy+Yg6NaaU/g1eZb
X-Google-Smtp-Source: ABdhPJwcSGmjz2U63xQqnQNPUC+xfiKk9Wwt41JEK1hTo3sOwabh8cDfb/Hi+RoovMNcxb3gutlzLQ==
X-Received: by 2002:a17:906:58c:: with SMTP id 12mr20195325ejn.311.1593006935387;
        Wed, 24 Jun 2020 06:55:35 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id j5sm17756649edk.53.2020.06.24.06.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 06:55:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        po.liu@nxp.com, xiaoliang.yang_1@nxp.com, kuba@kernel.org
Subject: [PATCH net 3/4] net: dsa: sja1105: recalculate gating subschedule after deleting tc-gate rules
Date:   Wed, 24 Jun 2020 16:54:46 +0300
Message-Id: <20200624135447.3261002-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624135447.3261002-1-olteanv@gmail.com>
References: <20200624135447.3261002-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently, tas_data->enabled would remain true even after deleting all
tc-gate rules from the switch ports, which would cause the
sja1105_tas_state_machine to get unnecessarily scheduled.

Also, if there were any errors which would prevent the hardware from
enabling the gating schedule, the sja1105_tas_state_machine would
continuously detect and print that, spamming the kernel log, even if the
rules were subsequently deleted.

The rules themselves are _not_ active, because sja1105_init_scheduling
does enough of a job to not install the gating schedule in the static
config. But the virtual link rules themselves are still present.

So call the functions that remove the tc-gate configuration from
priv->tas_data.gating_cfg, so that tas_data->enabled can be set to
false, and sja1105_tas_state_machine will stop from being scheduled.

Fixes: 834f8933d5dd ("net: dsa: sja1105: implement tc-gate using time-triggered virtual links")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index 936b14cbb45d..8524e15fdc4f 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -550,10 +550,18 @@ int sja1105_vl_delete(struct sja1105_private *priv, int port,
 		kfree(rule);
 	}
 
+	rc = sja1105_compose_gating_subschedule(priv, extack);
+	if (rc)
+		return rc;
+
 	rc = sja1105_init_virtual_links(priv, extack);
 	if (rc)
 		return rc;
 
+	rc = sja1105_init_scheduling(priv);
+	if (rc < 0)
+		return rc;
+
 	return sja1105_static_config_reload(priv, SJA1105_VIRTUAL_LINKS);
 }
 
-- 
2.25.1

