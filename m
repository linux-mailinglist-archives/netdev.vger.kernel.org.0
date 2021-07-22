Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC51F3D26DB
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 17:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbhGVO61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 10:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbhGVO60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 10:58:26 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0DFC061757
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 08:39:01 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id k4so6417413wrc.8
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 08:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=xKWVpmeE7nCr9GO1CeUwVdvi6hi4Bp29rr9QRyAA1Ww=;
        b=wDQQTWVK96UfIVUhX9vT1yuWJgVCA0E3PP6evwrTBKVqewB61BU0cfduNFdGIdQEB7
         GEG2PEYiROkYoqdlT3YNWdscMRZWGWC8xynFn/PXZbE2M4t2VdUFGSWEG2MofWDpphpX
         CJsFdNeYslebm704QB0cwoK3LwL+CxoidmO2grA9hmovkQNfhf9au5S2yYzFF2x4eQTK
         hXwsB2FOFa9YotKfxsj1gtfmu1H2XAUsOfeDFzvW2u5jV4RdbV2AN62QDq1U4WlHjyOH
         upK715wLs3//UZoDLWqt9xDH6HeHJo1fvwALukacT5ExgQfnSRBaUXq7yfgZRLuuGRlF
         aMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xKWVpmeE7nCr9GO1CeUwVdvi6hi4Bp29rr9QRyAA1Ww=;
        b=cPnXQqvLv+ESuZONKaM3Ce5vafD+kDZb32SiGIVd2m5h+gRiZZB0QYOCnho19YUT1p
         ehTIh4UZ5bN3jhMiiVr6HSNOBN2ZR40iuYab05hSokC/QEUv5agLJMlVhooq1wcfagB4
         YosclK/JUSfQLjGhK0RbJrZp6YqmWN4r/zBsCIgb7gDKyFOjIIuQ69GpBBX0pT/N+JVO
         C5uQ+GQsjoYEjuPhcVw7ttbi5zCei4C8S7oO+2EPMf1+/SzUUbFJKNB57JQX3KqywQtK
         Sh3v5zpdnYz+1UtltQ6w9w5ySrSQUo6bNiHJ8etnG2sywEVdO/YDhWWIMej8getPlEzb
         1O+Q==
X-Gm-Message-State: AOAM530f08ai8/Wk742QUrJy/6SJDMIsdMGXK8qwLnWDI6+YVwIUfgOW
        qd2GNBXoG0Yv/tIbd61HBOu3wd7cRfrp3Yjn
X-Google-Smtp-Source: ABdhPJxjJcgpSUFc5l78Q7/3RcnMfW1PaXqB+r4b6qeS8npADaEx0YzHcETMJr1z8O8VKfXYmqXypQ==
X-Received: by 2002:adf:e409:: with SMTP id g9mr654961wrm.66.1626968340078;
        Thu, 22 Jul 2021 08:39:00 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:69b5:b274:5cfc:ef2])
        by smtp.gmail.com with ESMTPSA id o7sm22969127wrs.52.2021.07.22.08.38.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Jul 2021 08:38:59 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] wwan: core: Fix missing RTM_NEWLINK event
Date:   Thu, 22 Jul 2021 17:49:24 +0200
Message-Id: <1626968964-17249-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By default there is no rtnetlink event generated when registering a
netdev with rtnl_link_ops until its rtnl_link_state is switched to
initialized (RTNL_LINK_INITIALIZED). This causes issues with user
tools like NetworkManager which relies on such event to manage links.

Fix that by setting link to initialized (via rtnl_configure_link).

Cc: stable@vger.kernel.org
Fixes: 88b710532e53 ("wwan: add interface creation support")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wwan/wwan_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 3e16c31..409caf4 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -866,6 +866,10 @@ static int wwan_rtnl_newlink(struct net *src_net, struct net_device *dev,
 	else
 		ret = register_netdevice(dev);
 
+	/* Link initialized, notify new link */
+	if (!ret)
+		rtnl_configure_link(dev, NULL);
+
 out:
 	/* release the reference */
 	put_device(&wwandev->dev);
-- 
2.7.4

