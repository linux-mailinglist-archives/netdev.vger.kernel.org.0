Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6B4561A3F
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 14:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbiF3MWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 08:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234781AbiF3MWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 08:22:31 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076B71FCE5
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 05:22:30 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id b19so10124781ljf.6
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 05:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=0lkVA7Cku63orBznDO6uziMhTVchdeWbatsMAplzxaQ=;
        b=j/HGQnPVRa1aLq+jK9YIafmetsueUbbAnrc3LwJphxAdQmlPvtNaBT4QIaasiSs63y
         qNIxddi/w+JiEKWc05ab3ySE5xVHWMjJXdS4iTYlWwS8wEulIYOS+wnilzyF6tEams0w
         fJZRLTUL2ixFrNQLmLbgEeOFyW+pi1Yb5+3Ttfc3pfA6watfLlJj9OagejodGdUQCL23
         rgV4/n68pPnhwVdjx0lAhpbxy7csDwp5bLCILWnZCS7mZ7wFYl4OWpeC/gn0pfnyBkMr
         v6UM740rtzJIR86RkWAMK49/2BqG/pePuESpczElAqsO62wo4ldJ+FYW00walJZXymGJ
         9RRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=0lkVA7Cku63orBznDO6uziMhTVchdeWbatsMAplzxaQ=;
        b=Vqcm2rnYxIiVOPuXrFHmtMF14DId+HnHVnCpURAp46ormkXlOcCM2krRVoTTkKJDjA
         4MMHCRpeptJFLi7RDhs7imTIyicxFhSdS/CIZHKZEQJNwNTDeXH/Gf1H9HdRp+b3vQps
         2VziTt5kfJF7pkBaM9MJMsj5a/s2A7tQDA3KvhKPi+9t3jc036qK9vVC3rvkmlAHsdIR
         KQuaVpTMdnmFg4fRDoMLc+p1+XLb5S++q48JRzakFe3pVWI1+q2A6WTUQixA47iUXkpQ
         5M+6e9+wAiFj8q7pOGIlU9b8XSAHbhyQQCxLAaEq00YOaG5hHhTZgPWM9wMryBnvKc7A
         nLOA==
X-Gm-Message-State: AJIora951hh5QLLmlbJjhuFzMynfQ/x1cY4kwxAxbWS4FqH7GxllDBXp
        jJq5sw0NKr1StVz0ZnWbC3Y=
X-Google-Smtp-Source: AGRyM1u8kDKYHuLcI0POCV7xNA48vUyMPNx4imReiT2pgmxcB9pDdosY9IEf2e8HTU4B/guH6o94tw==
X-Received: by 2002:a2e:9297:0:b0:25b:10de:a17b with SMTP id d23-20020a2e9297000000b0025b10dea17bmr4899958ljh.71.1656591748349;
        Thu, 30 Jun 2022 05:22:28 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w22-20020a2e9bd6000000b00253c8dfc4e4sm2532515ljj.101.2022.06.30.05.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 05:22:28 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: [PATCH net] net: sparx5: mdb add/del handle non-sparx5 devices
Date:   Thu, 30 Jun 2022 14:22:26 +0200
Message-Id: <20220630122226.316812-1-casper.casan@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

When adding/deleting mdb entries on other net_devices, eg., tap
interfaces, it should not crash.

Fixes: 3bacfccdcb2d

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 3429660cd2e5..5edc8b7176c8 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -396,6 +396,9 @@ static int sparx5_handle_port_mdb_add(struct net_device *dev,
 	u32 mact_entry;
 	int res, err;
 
+	if (!sparx5_netdevice_check(dev))
+		return -EOPNOTSUPP;
+
 	if (netif_is_bridge_master(v->obj.orig_dev)) {
 		sparx5_mact_learn(spx5, PGID_CPU, v->addr, v->vid);
 		return 0;
@@ -466,6 +469,9 @@ static int sparx5_handle_port_mdb_del(struct net_device *dev,
 	u32 mact_entry, res, pgid_entry[3];
 	int err;
 
+	if (!sparx5_netdevice_check(dev))
+		return -EOPNOTSUPP;
+
 	if (netif_is_bridge_master(v->obj.orig_dev)) {
 		sparx5_mact_forget(spx5, v->addr, v->vid);
 		return 0;
-- 
2.30.2

