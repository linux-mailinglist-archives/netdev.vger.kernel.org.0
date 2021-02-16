Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2BD31CA0A
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 12:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhBPLn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 06:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbhBPLmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 06:42:17 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE102C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 03:41:27 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id lu16so1124688ejb.9
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 03:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KBldjOvO17ApSk77FiyWF1LuIv96yzQ18hN9HI7B+qQ=;
        b=cwSGtJo1lUPn7cm0zHQv+ZPeaUnLl/7F7WgHBWMiWPWSuVFhhqfOEQuc/Wyg96jxVG
         gDRQ41iSq8YJ8vv44TZcb+uTbtyVXIcoecFfidV+Rzqm58UNgvWicpMgbYoCUK8eCMcc
         VA2hXA54kdmGe/pPgEtWooeqZMm0ATu4BHp28szo1lFC8qGSQ4Tv+7YQYyZtjGIlfKcH
         zAg93/Clrzqnbtv/eBv9LFr7eZE/iE3118+zMN+KPCO/vrxLiS0tpNyCOrHXVR6fMpNF
         Dps2EEUVtpAWnP0jwZzPaharBsAyRf5i4QUq3zT9D0fDRzsdDu4KeJtTM4BO+1rnkcDu
         1bsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KBldjOvO17ApSk77FiyWF1LuIv96yzQ18hN9HI7B+qQ=;
        b=OzxOMdWjEcCu8zhVOlTrJ2It53dtdNfMTcVgGIlixoOQKpARCFPPQ6DKSK5ppzMQYd
         HqyEgdy27++DqzKEH7cXg4D/2wvCZa2Bm3D+8fXuFbyf28o+CYp8P3QqKYLFQABV0tfM
         brb+CwX5deAnf6HRLRGk118yEfcLC6La/KyWnpcpsUNdoAlez+1RtmOcInlvnwzBDG2a
         biegAQ/fJS5+UAO7PWUYYXMBxahb8ajB7bIrJ6gT5PNNNgrz+GrWjXRy9meOJhHdftPf
         XAt64ieXzfhDm8SqZ6aU3+UgRFKGMKjWnp87Om/E4YtxXG9WZgd4U6cJ9dyQ52p5NBOi
         bdvA==
X-Gm-Message-State: AOAM530OcV12GvjDr3XwAoISMSPx27G+8CJzHXpGCehcPmfRL2uHGrjo
        KpsMUrYnc6DtZiUt9xtyv8A=
X-Google-Smtp-Source: ABdhPJy6kdxo19VDJlCDzDdBhRCqDWWV6wCMgfJ9BCR3/pp5YtlNnTLSo3/iyKIMYWLjlNfzfQ5H8w==
X-Received: by 2002:a17:907:1629:: with SMTP id hb41mr19356402ejc.197.1613475686610;
        Tue, 16 Feb 2021 03:41:26 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id kb25sm13287397ejc.19.2021.02.16.03.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 03:41:26 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH RESEND net-next 1/2] net: dsa: sja1105: fix configuration of source address learning
Date:   Tue, 16 Feb 2021 13:41:18 +0200
Message-Id: <20210216114119.2856299-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210216114119.2856299-1-olteanv@gmail.com>
References: <20210216114119.2856299-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Due to a mistake, the driver always sets the address learning flag to
the previously stored value, and not to the currently configured one.
The bug is visible only in standalone ports mode, because when the port
is bridged, the issue is masked by .port_stp_state_set which overwrites
the address learning state to the proper value.

Fixes: 4d9423549501 ("net: dsa: sja1105: offload bridge port flags to device")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1dad94540cc9..3d3e2794655d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3282,7 +3282,7 @@ static int sja1105_port_set_learning(struct sja1105_private *priv, int port,
 
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
-	mac[port].dyn_learn = !!(priv->learn_ena & BIT(port));
+	mac[port].dyn_learn = enabled;
 
 	rc = sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG, port,
 					  &mac[port], true);
-- 
2.25.1

