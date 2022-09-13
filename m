Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0CF5B6BD3
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 12:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiIMKnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 06:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiIMKnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 06:43:37 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF785E338
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 03:43:35 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id r20so1638311ljj.0
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 03:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ygTxP1R89jRodLSMaZ5umXgwdbn+zdw9an2P2JOV6+Q=;
        b=YuQeszK+YlFNyRJz1qqimkEw6qXRamJ/zHVESAJ2UTA/JMXyv7lGyYkOzJiK4WmFoC
         0SBlsp3zDmrV71raLwNScBTcPZM14Tr8/lPs0I+zdZE/D/qogSClM6SIhCNqjge2UhI2
         EgSxY4OS2drZ5Fib7lers9yVvWYIGDBrWoRD8VGhuR3dVNhdBhyP082Z6MHRDymh6Q7a
         kZxPEcNAj03KxtTNx8r4IjfPFqsHLLFzmykP8mQBdbaY/IF+Rkkv7tkYPvlQ+Pw/OhiO
         FY/gKFso7BcM3NZD/cMoXAFi4HATHsFIEzxHRvvfH163llzmaL80Vj7/p1FzwYER8aKp
         PEgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ygTxP1R89jRodLSMaZ5umXgwdbn+zdw9an2P2JOV6+Q=;
        b=VTBu+SIckQh4JCTOSMH0VnYLzR0ixkkfbWRqDxG1FWZ7yVEW0vkOQBtZxjot5Aflt8
         qbMrBunHit7qVVjuszmk0Fwzxtsgecul9rurwGSpDW+7f2wtguw/fBatfLvpLgiH+5BX
         ISKZ4vkfoDJWSGIbysOVXx6T/dvlliAVAbD1wPW6MM9oHsxAlo6N9LcYDG1olQWxvxxz
         eLJayGMKyC3kjcuR6xcPX/LBLU6J19Qr1qUGtNLXNhdg6FJkr/QRTL+Pa8Yx6wBzhpzk
         glGkmjdgQ0t2seHwwdo+WnUwZSJO4Bt/U3vDw92uPJX+CX+WsuuEcW6R++Je0r9unD8r
         yY4g==
X-Gm-Message-State: ACgBeo2Tb6GMwUgkdamBf+5LRFaNFAUB2tOxApBZcXc/2iNnTFGsa9V7
        aU1issDZERu0vCKd5bQzT+D/WOAFu5IXBrIX
X-Google-Smtp-Source: AA6agR6QZvijUhG2foC6l80vwNr4OdXSTjlu2sl9uDPRD62JFLXkTQPFBEL5Vd7nVdQVQiKnIJOdZQ==
X-Received: by 2002:a2e:b24f:0:b0:26b:a653:1e3b with SMTP id n15-20020a2eb24f000000b0026ba6531e3bmr7260143ljm.382.1663065813195;
        Tue, 13 Sep 2022 03:43:33 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id i2-20020a2ea362000000b0026bf27c7056sm1018946ljn.67.2022.09.13.03.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 03:43:32 -0700 (PDT)
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
Subject: [PATCH net-next v10 2/6] net: dsa: Add convenience functions for frame handling
Date:   Tue, 13 Sep 2022 12:43:16 +0200
Message-Id: <20220913104320.471673-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220913104320.471673-1-mattias.forsblad@gmail.com>
References: <20220913104320.471673-1-mattias.forsblad@gmail.com>
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

