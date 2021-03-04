Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDB532D14A
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 11:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239124AbhCDK6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 05:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239108AbhCDK5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 05:57:51 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE19C061756
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 02:57:10 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id t1so4220418eds.7
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 02:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pQ4KuXKq+h5JJFMeS5vHSPBcL1PmMm3BpnDVmyXcVY0=;
        b=FGl2JiIQ+Jy2bJkf63XLNZrBWVRZPW//jMvDlyD9qHdllcmE7eleV+IkbZlm05T2yP
         EQG2LXV3aIh91rQMu1cbffNTLalhr5vIhqO1Od9UJvOgpDLiUUTZgy+fYgfdbNuRX+2o
         t7bFahAE9ML5ZGqkINc9g/RKGg1yy+gzGp+3ywawqIECt2zO3k2NYF3tGV46m+BtPqnJ
         SeX6KI9BftD1hIR5r1JZG4BUd/c83Lm70rXmgiKKrsSYoxdVPK4jF0gMT+NDdyEchGI/
         ld1Li5Ih7XLbwT7PrNX5wdPvSaOQmJ2vz1ifJT6c7rBHJ720xFRxn7SktyaO6F6voXOF
         PLeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pQ4KuXKq+h5JJFMeS5vHSPBcL1PmMm3BpnDVmyXcVY0=;
        b=gu9HaPgSPviR6VNRqB8XX7RSX3J+tKYfHfN/XUCa4E9BnSEuluCJg2deP7Danw51T0
         yTFuuQcrlEhU6/55kEB6CT6Vpw7OB3U2YfL2RlpJAwdbUF/tezaPSiLYnxtjLkQIoFcj
         bBkfk0UizPxZNBUxp5aCB/zGDO9PtEejde6d/e4EB7DjXbfhIZSnXsa/RMlds8O04xV0
         vQk/m82wCPodeRaJZWkxiq0vySckjIT645fn9SPVAuuECY3nuO9j5V5XcOxiVcdmDaEV
         J4sGEHlp+6/KKSjridAgngFhK/Z7Q5tsf4fISInozZyltXp2M/+MEJFzN0Z/UbvOcVzJ
         CCew==
X-Gm-Message-State: AOAM533XCsWCk825RSvDhznnqoNPJlj0SqDjfcHNtnxCA4nv3feEMuSh
        6/aJjp07HvAAPhIZM7c8kDpgO8caf9A=
X-Google-Smtp-Source: ABdhPJzRsGnTswrWg7oMxrAegIjKsqwbCCNjoZEAHcrke1no6zTznUJx2kYlstiQRxrN7HwSjp7HNg==
X-Received: by 2002:a50:fd83:: with SMTP id o3mr3766444edt.90.1614855429755;
        Thu, 04 Mar 2021 02:57:09 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id mc2sm19857824ejb.115.2021.03.04.02.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 02:57:09 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 2/2] net: dsa: sja1105: fix ucast/bcast flooding always remaining enabled
Date:   Thu,  4 Mar 2021 12:56:54 +0200
Message-Id: <20210304105654.873554-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210304105654.873554-1-olteanv@gmail.com>
References: <20210304105654.873554-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In the blamed patch I managed to introduce a bug while moving code
around: the same logic is applied to the ucast_egress_floods and
bcast_egress_floods variables both on the "if" and the "else" branches.

This is clearly an unintended change compared to how the code used to be
prior to that bugfix, so restore it.

Fixes: 7f7ccdea8c73 ("net: dsa: sja1105: fix leakage of flooded frames outside bridging domain")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index c1982615c631..51ea104c63bb 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3369,14 +3369,14 @@ static int sja1105_port_ucast_bcast_flood(struct sja1105_private *priv, int to,
 		if (flags.val & BR_FLOOD)
 			priv->ucast_egress_floods |= BIT(to);
 		else
-			priv->ucast_egress_floods |= BIT(to);
+			priv->ucast_egress_floods &= ~BIT(to);
 	}
 
 	if (flags.mask & BR_BCAST_FLOOD) {
 		if (flags.val & BR_BCAST_FLOOD)
 			priv->bcast_egress_floods |= BIT(to);
 		else
-			priv->bcast_egress_floods |= BIT(to);
+			priv->bcast_egress_floods &= ~BIT(to);
 	}
 
 	return sja1105_manage_flood_domains(priv);
-- 
2.25.1

