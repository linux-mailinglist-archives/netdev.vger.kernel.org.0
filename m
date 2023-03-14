Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2006B915A
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjCNLQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjCNLQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:16:14 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6171EFD3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:15:39 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l7-20020a05600c4f0700b003e79fa98ce1so9856300wmq.2
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678792535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8qdi5DYkWNcl00VQwbC1lrjXnlwp6lTm4HWlXkyW1hw=;
        b=ziVdP8AsPWAuDSgsRXyLcLCAbopj661LrYf5uMQman/U9BU7cfHO1P4VchIjmTd7IU
         Mr3lKo5LraYTekNXucv7sB3e+YRNaZTl01rxyZouYRz/JeZrKjb5pEvI53fMA1mMtneY
         CdJDO//SPJz1QtRWm851dHXGl7nSHU7DJ/IaadTpQNHtbZMhXR0ubOSIGYHMQbyTjdYv
         g0eFL+Up1rH/eYB9PdNaYqQ3hUpU4SHrhh2L1GJ1EaINO7JV7bvRmyLxygujRwbC9F4o
         RvTgiaM96m+3CvB8/8g9AfkU4D34ZgWsf6ZZ8lIEsYweKMiiDJ25bJVI0YVAttB8gC3m
         +faQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678792535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8qdi5DYkWNcl00VQwbC1lrjXnlwp6lTm4HWlXkyW1hw=;
        b=TzU/JQ91TZvrqoVPa1hfA64ytGDkZWOdMhO9RULfxjJS3yt835HcPe1JDvycryhEcu
         9ajNFaiiBK2v72vJqC0L1lq3ktN01EFh87N+TFpPOdImR+8k0ZTr3mEs+YBIP9s0zoCZ
         QccoAgL4dtN2zwT9STcPW2OsM/ZHNAu1JQRK/TFw6xgFSq6RY4X/vQK4RG6HSHgSLon5
         fyAVt+X6q8SY51bv/TegYdMsGDBMhtsIQlZ3liuDhPxChJvD1zGPwNixLCjQtBzeGsHl
         5MnmALVS355via7UEwWtCgbVKav5SbJXqgQIthqDzZWC5S9pKlYOgPkkJhVW8fEgzfAh
         Eh8A==
X-Gm-Message-State: AO0yUKUBvsYX0KaPt470UCKgfKadkZYQ4esviIwCHxI9LfxzzE0D/VER
        gF0WcQJ5jnco7tkLOVqT7aLxtJDD5H3IarlIRsE=
X-Google-Smtp-Source: AK7set/CqRF1OT8hGO7wAfgvB7bngB4zPZI0LQG4XaGp3KcH42MUymVxIU02qPVPUlsz632esRgjqg==
X-Received: by 2002:a7b:c053:0:b0:3eb:f59f:6daf with SMTP id u19-20020a7bc053000000b003ebf59f6dafmr13440302wmc.34.1678792535003;
        Tue, 14 Mar 2023 04:15:35 -0700 (PDT)
Received: from debil.. (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id t15-20020a05600c2f8f00b003e1fee8baacsm2442323wmn.25.2023.03.14.04.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 04:15:34 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     monis@voltaire.com, syoshida@redhat.com, j.vosburgh@gmail.com,
        andy@greyhouse.net, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net v2 1/4] bonding: add bond_ether_setup helper
Date:   Tue, 14 Mar 2023 13:14:23 +0200
Message-Id: <20230314111426.1254998-2-razor@blackwall.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314111426.1254998-1-razor@blackwall.org>
References: <20230314111426.1254998-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bond_ether_setup helper which will be used in the following patches
to fix all ether_setup() calls in the bonding driver. It takes care of both
IFF_MASTER and IFF_SLAVE flags, the former is always restored and the
latter only if it was set.

Fixes: e36b9d16c6a6d ("bonding: clean muticast addresses when device changes type")
Fixes: 7d5cd2ce5292 ("bonding: correctly handle bonding type change on enslave failure")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 drivers/net/bonding/bond_main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 00646aa315c3..d41024ad2c18 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1775,6 +1775,18 @@ void bond_lower_state_changed(struct slave *slave)
 		slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
 } while (0)
 
+/* ether_setup() resets bond_dev's flags so we always have to restore
+ * IFF_MASTER, and only restore IFF_SLAVE if it was set
+ */
+static void bond_ether_setup(struct net_device *bond_dev)
+{
+	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
+
+	ether_setup(bond_dev);
+	bond_dev->flags |= IFF_MASTER | slave_flag;
+	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+}
+
 /* enslave device <slave> to bond device <master> */
 int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		 struct netlink_ext_ack *extack)
-- 
2.39.2

