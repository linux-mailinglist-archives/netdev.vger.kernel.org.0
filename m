Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33A0534B72
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346755AbiEZIQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346001AbiEZIQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:16:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CE548305
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 01:16:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n3-20020a257203000000b0064f867fcfc0so991331ybc.15
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 01:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kqnLyT5BScBmxPie/jUOGEmzvdpZW3OfuWkwvvKbmIQ=;
        b=O8dwYlRm5myWtMCUjluMS06m9OQufbVTaL0SA/1SSpLb6Q1H1ZeyGd0a6SHjz/l2AC
         gRRr/WCLHTFyURFv63GZWekkODW7A8O4IB2yzQJWM+/K0NtEVu9a5tsIpy3YI44fV34Q
         uTpUGoCbwChTFA2pkNGTMrYZa0xzpaUUIVE8dYXjTIu+gHcpLFh+pcu5hZYghuiUoJm2
         ZKupDPbYJUcArPC1Umnaoqe/6Zgos/v0q8iU1hCEpHdc6TOgYFCUzgVDj2Q/pbkNtaXd
         2RxGcLTqBsnDUI0hj8KfYCR16HfmSlIsdyhfQgPBL+wYl36dau32BugaaSnT2tbIlwGz
         BC+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kqnLyT5BScBmxPie/jUOGEmzvdpZW3OfuWkwvvKbmIQ=;
        b=mANWt/wBKtB79GQBa5M0aKHfCR79eNAN7BVFWPrlgJoivIq4aeojjtKGFtTEaKy9u5
         TPlzy/fPqMy3S8L/ESe7vdGqu475UkPVtJG6m0qWHRrCI1foRP4ibPsv9BPmSpfaXgoe
         ksv71XiHWkIG7jKDf+LxkPmAXTigy8zl4VofZt+GXaLbIU+n25uOpBJh+5XYXg7lFVZm
         vGH7mq+Qp41J/Nwqwcv6qUok1hEhMTNjLYPIX+PpKA84SyRR7dPdR76FoIDPZ5jUYnoT
         NYNGaeECL6Smw3xe3R/3MBvTDlRap6Ijwx8NaOcBJ3Yt+6imb6cLeAtwLXKoOmBKh6TB
         nyfg==
X-Gm-Message-State: AOAM5338r/Fjh6OxYagb0Sb+f4MbmTMI75Jd9Mwku3fE0ElC/s7uwBdO
        ItcoaqHiNU51oJqr47FIimKD3Eu/hSTf+e0=
X-Google-Smtp-Source: ABdhPJz3E2nD3dyR5epKdpx7T0AcqAuln5UJYq6/LusJXLA9qDXoEEc3OI/BRFh9Q4xJz3OuN7NXxtEIzJwaSYI=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:ff1f:a3b7:b6de:d30f])
 (user=saravanak job=sendgmr) by 2002:a81:4fd4:0:b0:2ff:2c4c:a687 with SMTP id
 d203-20020a814fd4000000b002ff2c4ca687mr37158577ywb.500.1653552971096; Thu, 26
 May 2022 01:16:11 -0700 (PDT)
Date:   Thu, 26 May 2022 01:15:45 -0700
In-Reply-To: <20220526081550.1089805-1-saravanak@google.com>
Message-Id: <20220526081550.1089805-7-saravanak@google.com>
Mime-Version: 1.0
References: <20220526081550.1089805-1-saravanak@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [RFC PATCH v1 6/9] iommu/of: Delete usage of driver_deferred_probe_check_state()
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        John Stultz <jstultz@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that fw_devlink=on and fw_devlink.strict=1 by default and fw_devlink
supports iommu DT properties, the execution will never get to the point
where driver_deferred_probe_check_state() is called before the supplier
has probed successfully or before deferred probe timeout has expired.

So, delete the call and replace it with -ENODEV.

Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/iommu/of_iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
index 5696314ae69e..41f4eb005219 100644
--- a/drivers/iommu/of_iommu.c
+++ b/drivers/iommu/of_iommu.c
@@ -40,7 +40,7 @@ static int of_iommu_xlate(struct device *dev,
 	 * a proper probe-ordering dependency mechanism in future.
 	 */
 	if (!ops)
-		return driver_deferred_probe_check_state(dev);
+		return -ENODEV;
 
 	if (!try_module_get(ops->owner))
 		return -ENODEV;
-- 
2.36.1.124.g0e6072fb45-goog

