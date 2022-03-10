Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F044D3E2A
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiCJAaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239014AbiCJAaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:30:10 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1502124C06
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:29:10 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id 9so3414229pll.6
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 16:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5aBQM8wNOxbvrRsNnfmdlVwJl6wi5pr+JOyZvAg1e78=;
        b=YPeJg+k1doW8vNKoauDbXfMjhgO5Z8OwUla/0LhkAHe5WWMRbm55wJnyQr41d6VSA+
         mbexW2XXWfbWj/EGVa89wTzoMJiA+5ac9iokB+UvXoJnLjUMtdhm04IKeZCGyJ624TQd
         Nel2M0VPMhSABW0nhP7thjCW+rLaOV2pMtvUqRW2eUdfHhYCNGcLAiEJhH1Yb45Z94Lx
         f/MP5TFRGg+ATyOfgglkH0NBJEBal/Ffg9yw6y5cGgfhEoYCP4LJk702JVf+/3Fso6qc
         t0ZV0kSDOnZWI3VGlGh5AzMws++1Q5i6MMoqtAM1DXxOWkTzXxjN8xMbdTBM142xZ6/s
         Y9sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5aBQM8wNOxbvrRsNnfmdlVwJl6wi5pr+JOyZvAg1e78=;
        b=8OG8sHnb+C6M8j6OybqctCW99kLjvZCIL6OG+UiivdRgOP8lpKjHM7Q7/F/zNjjdPK
         KyRX8hxToXQm5FGzOF11OUc2y72eUZitB3ns2K/GCtVklSlZlIZSOZawG5HvgVVx/2TI
         V2D/FJxL1jCu5aaoHeTu3kIYA80I144fSX6d7xGCmX3o5lSQNz2vwJ/sLpxzBtU6siAO
         GdGrHkBkIbwrxJvJ/k3uzNCBpexS/kFItwngchv9M/XJ+KaxH8HGTbUnhMZrp5sFs51c
         Ufz5fUAQ9I7OTsWcl+4eHjOmVE5e8dk+fOO8ibkCUObJnbtTiaqowhP93phF5izP3H1/
         Hu1Q==
X-Gm-Message-State: AOAM531+tVVw7+xeKp36OvulLzEKkLF4jjrVT9tgHkeX7P5eWXuoZPrX
        G9/ruTzsIRSWw2U4QSNGezWZrIVywXM=
X-Google-Smtp-Source: ABdhPJzS1VkyGmFkVHDRXNRDaswbkp98mqGuSZCR1i7mRCS2OTt27irfIJzEKVvkVeHriX9EfmcYHQ==
X-Received: by 2002:a17:90a:6508:b0:1be:d59c:1f10 with SMTP id i8-20020a17090a650800b001bed59c1f10mr2140976pjj.229.1646872150266;
        Wed, 09 Mar 2022 16:29:10 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id nv4-20020a17090b1b4400b001bf64a39579sm7557660pjb.4.2022.03.09.16.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 16:29:09 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v3 net-next 10/14] bonding: update dev->tso_ipv6_max_size
Date:   Wed,  9 Mar 2022 16:28:42 -0800
Message-Id: <20220310002846.460907-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310002846.460907-1-eric.dumazet@gmail.com>
References: <20220310002846.460907-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

Use the minimal value found in the set of lower devices.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/bonding/bond_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 55e0ba2a163d0d9c17fdaf47a49d7a2190959651..357188c1f00e6e3919740adb6369d75712fc4e64 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1420,6 +1420,7 @@ static void bond_compute_features(struct bonding *bond)
 	struct slave *slave;
 	unsigned short max_hard_header_len = ETH_HLEN;
 	unsigned int gso_max_size = GSO_MAX_SIZE;
+	unsigned int tso_ipv6_max_size = ~0U;
 	u16 gso_max_segs = GSO_MAX_SEGS;
 
 	if (!bond_has_slaves(bond))
@@ -1450,6 +1451,7 @@ static void bond_compute_features(struct bonding *bond)
 			max_hard_header_len = slave->dev->hard_header_len;
 
 		gso_max_size = min(gso_max_size, slave->dev->gso_max_size);
+		tso_ipv6_max_size = min(tso_ipv6_max_size, slave->dev->tso_ipv6_max_size);
 		gso_max_segs = min(gso_max_segs, slave->dev->gso_max_segs);
 	}
 	bond_dev->hard_header_len = max_hard_header_len;
@@ -1465,6 +1467,7 @@ static void bond_compute_features(struct bonding *bond)
 	bond_dev->mpls_features = mpls_features;
 	netif_set_gso_max_segs(bond_dev, gso_max_segs);
 	netif_set_gso_max_size(bond_dev, gso_max_size);
+	netif_set_tso_ipv6_max_size(bond_dev, tso_ipv6_max_size);
 
 	bond_dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
 	if ((bond_dev->priv_flags & IFF_XMIT_DST_RELEASE_PERM) &&
-- 
2.35.1.616.g0bdcbb4464-goog

