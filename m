Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84FC3F834E
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 09:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240543AbhHZHq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 03:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240429AbhHZHqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 03:46:22 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62DAC0613CF
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 00:45:35 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id c63-20020a25e5420000b0290580b26e708aso2220192ybh.12
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 00:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YHIgrK6tAkKZGZR6Q2TwdOpVzreK8GCVzLPUG55+FFA=;
        b=rhStSsGxbaIR0MHB9CmSlbRSYrPUet7tGgyJ+OcOlMCUMLgbNQjDUbORc7FcHe1ros
         eyJjNPIteE6dcBbFrVV4sAG1CfkyctKtYXFUFJFjILiWA67roZgtqUY+kW//6sWFQBuL
         XJneAy7Kdqhg2gB58jMjQkZIStv8T7VXpY87t6vptrNXwrmktfKWgyxFIcrm88KDaTC2
         aAKaQZvxNsln4iUtVENNv4blcCIXXIYkyPCXiSrYsxpAC6a0evyoY0kjbsFKYs3rbNcx
         1GFyICXzmkbexbA2W7BfkCml5A0a+cfdXbMtdQMvqkdvurKKGhfD2RUL/jmX5CZ73WBN
         TKEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YHIgrK6tAkKZGZR6Q2TwdOpVzreK8GCVzLPUG55+FFA=;
        b=kC/0qQJ6OMA8j/2YPABN8Lkh3X0zCCZCnnIaDUIag4mHBZ1TX0NLUhr5UHisSm9gDo
         5MP0/80lD1Via9rM5rmktMmXx9GhFRU2tDHecbyCtkpqaVjTK5KLhmbmrTo9Kowhg5at
         tipQ1DWMwvALT8jx5vlIwts3b8XYXJd+oBr9vTf0V29QTbhELBrXNKdajQvyJiOdwVUh
         H2ALwMMkcRWnm/fCAvk6896BOox3oyrNnCp6mC2PBK5Ydof3nXB3YsBvBFQD6O69e1F5
         5NKA9bJib0G4EgFBYWMuKKYaR4/2zdHEMiQbbjipaHbS+HYYwxD1syfZx5YK+n4NM5BY
         0uVg==
X-Gm-Message-State: AOAM532oYqij88OvkhrQFjNSjQiLMHWylARnKX91lMFHbuka8M4KtdrW
        7Hgakqx6+GI9/elg2TpR855Ji7e+7XwFmGE=
X-Google-Smtp-Source: ABdhPJycNYDqto2n3MH4BgrRVXIGSmkVWlpLM27lpYHQFpoOpL13Ca6ZU3KzJ3Auys6ImZMCuoSNk0Dqns2CdFc=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:5b7b:56e7:63bf:9b3c])
 (user=saravanak job=sendgmr) by 2002:a25:5ed7:: with SMTP id
 s206mr3728540ybb.387.1629963935137; Thu, 26 Aug 2021 00:45:35 -0700 (PDT)
Date:   Thu, 26 Aug 2021 00:45:25 -0700
In-Reply-To: <20210826074526.825517-1-saravanak@google.com>
Message-Id: <20210826074526.825517-3-saravanak@google.com>
Mime-Version: 1.0
References: <20210826074526.825517-1-saravanak@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH v1 2/2] net: dsa: rtl8366rb: Quick fix to work with fw_devlink=on
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is just a quick fix to make this driver work with fw_devlink=on.
The proper fix might need a significant amount of rework of the driver
of the framework to use a component device model.

Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/net/dsa/realtek-smi-core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek-smi-core.c
index 8e49d4f85d48..f79c174f4954 100644
--- a/drivers/net/dsa/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek-smi-core.c
@@ -394,6 +394,13 @@ static int realtek_smi_probe(struct platform_device *pdev)
 	var = of_device_get_match_data(dev);
 	np = dev->of_node;
 
+	/* This driver assumes the child PHYs would be probed successfully
+	 * before this functions returns. That's not a valid assumption, but
+	 * let fw_devlink know so that this driver continues to function with
+	 * fw_devlink=on.
+	 */
+	np->fwnode.flags |= FWNODE_FLAG_BROKEN_PARENT;
+
 	smi = devm_kzalloc(dev, sizeof(*smi) + var->chip_data_sz, GFP_KERNEL);
 	if (!smi)
 		return -ENOMEM;
-- 
2.33.0.rc2.250.ged5fa647cd-goog

