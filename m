Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F365E7F4D
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbiIWQJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbiIWQJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:09:49 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE5B20F55
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 09:09:48 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id b21so594641plz.7
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 09:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=6La/ZrLVDIwkTiZGZTY5yQVptb1YSZ1KGFP+6xkLsAk=;
        b=eBT+xH5bQ+RNRIzdpBkfC84rYHh2FkRdzsASqusz/ngjtV/mGUt4JzR+Lew8IEXcxc
         F/LiP9Axp8tgOjKFM0NQRdJnlLYP+bWCixKJqt8oBkTgHCRCpcidWIO6Z7RCKh6yEdsR
         mxpDJBm49X0KKdmk+tPGCNOGV+ZKjdE6cDmFqW1VUa/oVtrY0qaTu2G2dcU4yy2DBKdF
         nY5QnlFRYhcS3maD4vQB29zxSEWkCO7KnFjtCARiaTpw11gD3OwubapdA3mdlza7lC46
         SoHMeZ3PcJMoLJe3NIg1CJ+bvztVp4ocEjY5bw7xTWBRri51dyEWVhQG/TCRti2fCZaC
         ZScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=6La/ZrLVDIwkTiZGZTY5yQVptb1YSZ1KGFP+6xkLsAk=;
        b=xFDOXLJEiDn3dkedoCB6MwhpkUUUKIL6ogKtz2YcmXBFZM3+A9v0qymT3ME0p6LbgD
         pw5keeujdB46kcY3tJgckfT1a2Q32ECWtmgxH2hv/O68Ms9XmZz5Q1wvuZDASuZ7VUJ/
         fDfRg6wtP3hca5yGLVBU5AqlpeYOQUNjyqNO5UHr+l4FeFf1ZgXDl2/HJuJOQbGzrlOM
         YFpd+kzV111rZDA37XcoLuDLhHrc36AJ4dLAtGkd2wtZwpWgv/vC9v+s7201XS3lXbKK
         vFP5tL5ahk2PgVbIS+kye/hvlfbWyVHtOonIthrneb3wm81O76pydC5/mSIuEo7v6O9m
         JVlA==
X-Gm-Message-State: ACrzQf3TCzBwAe6gjRMcGzVkVPHvLekbviwoYvT7ptIvX90ztRrZv6wm
        BYuBtvdiiJaD4LT3sYLblw1XX1FF2+yYell6
X-Google-Smtp-Source: AMsMyM4wbrqs6RQQStqeOwK4pglTLMsgPqRunB0WMAmky+8ASG6rYALw078AEUdrJtCPqs31BTMa+w==
X-Received: by 2002:a17:90b:692:b0:203:6c21:b4aa with SMTP id m18-20020a17090b069200b002036c21b4aamr21448330pjz.227.1663949387737;
        Fri, 23 Sep 2022 09:09:47 -0700 (PDT)
Received: from kvm.. ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id g10-20020a656cca000000b004351358f056sm5718334pgw.85.2022.09.23.09.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 09:09:47 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     netdev@vger.kernel.org, simon.horman@corigine.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Cc:     skhan@linuxfoundation.org, Juhee Kang <claudiajkang@gmail.com>
Subject: [PATCH net-next 2/3] ethtool: use netdev_unregistering instead of open code
Date:   Sat, 24 Sep 2022 01:09:36 +0900
Message-Id: <20220923160937.1912-2-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923160937.1912-1-claudiajkang@gmail.com>
References: <20220923160937.1912-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The open code is defined as a helper function(netdev_unregistering)
on netdev.h, which the open code is dev->reg_state == NETREG_UNREGISTERING.
Thus, netdev_unregistering() replaces the open code. This patch doesn't
change logic.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 net/ethtool/netlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index f4e41a6e0163..835b13264b15 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -40,8 +40,7 @@ int ethnl_ops_begin(struct net_device *dev)
 	if (dev->dev.parent)
 		pm_runtime_get_sync(dev->dev.parent);
 
-	if (!netif_device_present(dev) ||
-	    dev->reg_state == NETREG_UNREGISTERING) {
+	if (!netif_device_present(dev) || netdev_unregistering(dev)) {
 		ret = -ENODEV;
 		goto err;
 	}
-- 
2.34.1

