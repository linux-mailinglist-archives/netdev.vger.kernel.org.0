Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9D25B80EE
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 07:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiINFaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 01:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiINFat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 01:30:49 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F666BCC7
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 22:30:48 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id f9so22692593lfr.3
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 22:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ygTxP1R89jRodLSMaZ5umXgwdbn+zdw9an2P2JOV6+Q=;
        b=cZ+pG4oMpIrDnJrpl6Q1F04mJ6QXxMPibEoMiqLXeHwPrakHah1/UM8zm/kFlirQWh
         3goilBvGJq0hEPCKf/24kkz9sJ5eMB4JmymaXLqovSqy6zKfK1M023Mme3nSwFiLwlly
         N3rc3VpSan61Mi8QsDzqVWY2Tfz0NDwUmMscpiqZ1Oe2BR/pL41oKV5VXUrdVhEz+pv8
         TclnhD1t3lgy1sieVX/yeDJFYvCl29SjPPgpJqFz/pI4xD8be4jOgkSW8oeqvPbgUhE9
         rMJBMR7yYtrd4GJScQ4LaO8rB8giE1gatKf2y2dKRuxGE4p7NzqIPsDjq0T/+oSNm/nT
         +1Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ygTxP1R89jRodLSMaZ5umXgwdbn+zdw9an2P2JOV6+Q=;
        b=iRV7qhuyeg3nYOdfDNlPWET7xdBgrz9QyFERV+A1e0O7THsOyipTXWS2QRWRPsGJy6
         ObcG3DlhFJVPpW5ujocM/5rhFIEX/jBIYW2zA6X+WZi05gdJ2UH9QTeVgxZIGu7H4xmp
         P8FTSiWDGR1vfMgfO7cZ/4tEf7jwYQmxJVMEtq2Zp0NJoCJ4+bqBU31JgrTkKdAB3yfM
         kKgs2xBXbyvJ08IoQnGfurqhCKFoPWKuLN0EBmhjK5PdWH7ewJH4Ic/mjeg6AEDQS5UH
         VOW1Xr/VTiL72c8S2v08x2o/MdxvZrOsar3RWbezKHYK+8F/+q9dEa0aZo4V/stmIogk
         bfCQ==
X-Gm-Message-State: ACgBeo1vH0O22L1fe9j4qX7a0lHzOufEC36U9+YxgZLmytrFdo2LkOuy
        G0e9rkQDlvdshwpL4/ZY5FtEsrUaVML7LdlN
X-Google-Smtp-Source: AA6agR4jwL8c9QZFluZWGW/jcabZWBT/CWX+N5r45MZJ6jEcr90C06kgu29Igp0NtRjZxDcl3QPl3Q==
X-Received: by 2002:ac2:5ece:0:b0:497:acb3:a6f5 with SMTP id d14-20020ac25ece000000b00497acb3a6f5mr10999073lfq.112.1663133446077;
        Tue, 13 Sep 2022 22:30:46 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id f16-20020a05651c03d000b0026c297a9e11sm53814ljp.133.2022.09.13.22.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 22:30:45 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next v11 2/6] net: dsa: Add convenience functions for frame handling
Date:   Wed, 14 Sep 2022 07:30:37 +0200
Message-Id: <20220914053041.1615876-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220914053041.1615876-1-mattias.forsblad@gmail.com>
References: <20220914053041.1615876-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add common control functions for drivers that need
to send and wait for control frames.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 include/net/dsa.h | 11 +++++++++++
 net/dsa/dsa.c     | 17 +++++++++++++++++
 net/dsa/dsa2.c    |  2 ++
 3 files changed, 30 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f2ce12860546..08f3fff5f4df 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -495,6 +495,8 @@ struct dsa_switch {
 	unsigned int		max_num_bridges;
 
 	unsigned int		num_ports;
+
+	struct completion	inband_done;
 };
 
 static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
@@ -1390,6 +1392,15 @@ void dsa_tag_drivers_register(struct dsa_tag_driver *dsa_tag_driver_array[],
 void dsa_tag_drivers_unregister(struct dsa_tag_driver *dsa_tag_driver_array[],
 				unsigned int count);
 
+int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
+			 struct completion *completion, unsigned long timeout);
+
+static inline void dsa_switch_inband_complete(struct dsa_switch *ds, struct completion *completion)
+{
+	/* Custom completion? */
+	complete(completion ?: &ds->inband_done);
+}
+
 #define dsa_tag_driver_module_drivers(__dsa_tag_drivers_array, __count)	\
 static int __init dsa_tag_driver_module_init(void)			\
 {									\
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index be7b320cda76..ad870494d68b 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -324,6 +324,23 @@ int dsa_switch_resume(struct dsa_switch *ds)
 EXPORT_SYMBOL_GPL(dsa_switch_resume);
 #endif
 
+int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
+			 struct completion *completion, unsigned long timeout)
+{
+	struct completion *com;
+
+	/* Custom completion? */
+	com = completion ? : &ds->inband_done;
+
+	reinit_completion(com);
+
+	if (skb)
+		dev_queue_xmit(skb);
+
+	return wait_for_completion_timeout(com, msecs_to_jiffies(timeout));
+}
+EXPORT_SYMBOL_GPL(dsa_switch_inband_tx);
+
 static struct packet_type dsa_pack_type __read_mostly = {
 	.type	= cpu_to_be16(ETH_P_XDSA),
 	.func	= dsa_switch_rcv,
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index ed56c7a554b8..a048a6200789 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -874,6 +874,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	if (ds->setup)
 		return 0;
 
+	init_completion(&ds->inband_done);
+
 	/* Initialize ds->phys_mii_mask before registering the slave MDIO bus
 	 * driver and before ops->setup() has run, since the switch drivers and
 	 * the slave MDIO bus driver rely on these values for probing PHY
-- 
2.25.1

