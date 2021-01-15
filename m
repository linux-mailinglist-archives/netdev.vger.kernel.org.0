Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8406F2F7718
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 12:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731902AbhAOLAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 06:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731857AbhAOLAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 06:00:15 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD0EC0613D3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 02:58:59 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id x23so9889878lji.7
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 02:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=P/5aS8gJj3dfjW9XIfekkH69iyj2GIlu+ecLYJbsOdc=;
        b=Ekt78+PA9jbH24bKh3oWiUQdSbDxlvUzaz1jiCZFveErPFh+xmrMtF8M+KQIABqzoz
         kOCw7vA2VHVhLRj+ruBC3FHBYMpu2OS4B9NtsrfxLS9aHLAVQv1K+qdtJSN1+yrO8qjL
         SwJHNlN3bjWrMVy7YXtCYbnZIXD2L6Z7X04NXoRixB3zkR3oSsXfnhsE36wircmJPWLE
         H4lUpnXldK6m0XWpvpbkt1U1D11j3GVfy8UoxRr/W9R6XSPgG8msj+mwmB3FO21ZMUCv
         aLFZUQ/jLLlDUqMNrygrFLY9d7q8u/QVpfNiBTaXFlHHPvOzKBtNZMQYpQDORJRcp0Ic
         guxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=P/5aS8gJj3dfjW9XIfekkH69iyj2GIlu+ecLYJbsOdc=;
        b=Tt7yZ3En1W91aIaVMBdVMDOLNoAsv+gXhRBoBPSlon2ozfzx+et1f83OWT6IEIu43t
         Enfj3ozRQDiREKVp9qlFHlMcCpxv176iS4iPtz3uyIsYBiv6P6CB8pIonTNy7XMJiKpL
         7aItEpVE5zakzNbc00Lqj/um+0X1pTW4IgQLyHL0Cb3tsEcNytrIF6clpoMH3fOOqlAh
         4rhR0JHRQMzMyj9C9MOZWmNyJ4c1Q8PSaj25TCRxcUZo/l5RKDDyIO9ztVxOKKAKFnKI
         u3QtQJbyrGG8tg1YVdBSWhdFhRGfqUPOYpd1oxCE2AcJPhSLKd+XXfd7vRw20aX0Qecm
         8TIg==
X-Gm-Message-State: AOAM530j3NfS06rDXoKB20nXdWubbdpahd0kuNvOnz2SvgfpyJyjcYam
        1W30s8YaoPZ+kxBG08V/TmVAiw==
X-Google-Smtp-Source: ABdhPJxZBPHvqdKLSDfwQnx5pbCxP3Vp8fFUzAI+grfcRE7zRrk8vemAGOgmPjmmXKqJ7ugHK078GQ==
X-Received: by 2002:a2e:a484:: with SMTP id h4mr5370066lji.276.1610708338244;
        Fri, 15 Jan 2021 02:58:58 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p3sm756510lfu.271.2021.01.15.02.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 02:58:57 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Only allow LAG offload on supported hardware
Date:   Fri, 15 Jan 2021 11:58:34 +0100
Message-Id: <20210115105834.559-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210115105834.559-1-tobias@waldekranz.com>
References: <20210115105834.559-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are chips that do have Global 2 registers, and therefore trunk
mapping/mask tables are not available. Additionally Global 2 register
support is build-time optional, so we have to make sure that it is
compiled in.

Fixes: 57e661aae6a8 ("net: dsa: mv88e6xxx: Link aggregation support")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++++
 drivers/net/dsa/mv88e6xxx/chip.h | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index dcb1726b68cc..c48d166c2a70 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5385,9 +5385,13 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 				      struct net_device *lag,
 				      struct netdev_lag_upper_info *info)
 {
+	struct mv88e6xxx_chip *chip = ds->priv;
 	struct dsa_port *dp;
 	int id, members = 0;
 
+	if (!mv88e6xxx_has_lag(chip))
+		return false;
+
 	id = dsa_lag_id(ds->dst, lag);
 	if (id < 0 || id >= ds->num_lag_ids)
 		return false;
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 3543055bcb51..333b4fab5aa2 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -662,6 +662,15 @@ static inline bool mv88e6xxx_has_pvt(struct mv88e6xxx_chip *chip)
 	return chip->info->pvt;
 }
 
+static inline bool mv88e6xxx_has_lag(struct mv88e6xxx_chip *chip)
+{
+#if (defined(CONFIG_NET_DSA_MV88E6XXX_GLOBAL2))
+	return chip->info->global2_addr != 0;
+#else
+	return false;
+#endif
+}
+
 static inline unsigned int mv88e6xxx_num_databases(struct mv88e6xxx_chip *chip)
 {
 	return chip->info->num_databases;
-- 
2.17.1

