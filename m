Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F32526969
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383325AbiEMSe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383324AbiEMSeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:34:22 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627F55F8C2
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:20 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 137so8253196pgb.5
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VZhpx/FGEW1OaLwor8s7JhCvivBheRqqSUtOtvys+ZM=;
        b=a630ZBZz6gaETu6JWjteb1IKdVflHU4tGAJQJs8VZUut/mYy/h21Q6wNU7TB1QhA/J
         M6oI0nLCkuvxtaTzILonFpLCRfggQ+yS85Bd9qfr0MMFKNA952vulTEF0FjA6Ftw8s9q
         O97L1Zak7XCly3rr69FIT4bA7rWxpRi1SSNU3Auu5uaDYA5hOKDiQXV6F4VPQ5vUuuBI
         Tw4/JInILtN4ZVzgDKGDg454saVothHN46f1AmGmxh8EwnSp8XD4HGTAQAKS5h6jvx1u
         w/psxXdGyEGh+6b6kT7rfb6TJIcOEeQAkoa+/zeKaTLXMrv79dh4a9Rsrf2Q7KRfKqej
         kxvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VZhpx/FGEW1OaLwor8s7JhCvivBheRqqSUtOtvys+ZM=;
        b=0HeqRa1xkzpIM+9Hgce64etGndPLidk+jDVOrXZYE02ynSyl+ZcDkuxpc9qMQ5fTKT
         OBfbMRVOZQrDnY07yhevyCCO+Yh0EyDhXYXCsFAsl+vEDsm+HT5KQQPeiORbgnBts/Xh
         +WwiuReqv4z5YnGzMQqQ5Inflty38wVkF9oSf1PFsWOmFf/3rXBL+kCGAWa3A0CADGZX
         pbzVUoyS28l0LJHoAI+YdxTHBHEh3KGgKOQ27pEb1iJvKATwiQ+i2Hgfb6cnhhDOWMTR
         utiSOIbVuCfO1pAjO2tR7qdJwbFHEteYmibygnUyjXUzQoLHeZbTPmjGOEXQ3Cu3K3YF
         KAag==
X-Gm-Message-State: AOAM5309wPMm0jFxkmkF8XHAy493rd3D+BiBteCZsW1Ty2IKgxIce7HK
        ZyAsBU9+XJftd3gVj1oL16Y=
X-Google-Smtp-Source: ABdhPJy9ADgN39mNor6aCT1CNoIuYLmpA6b+xOhlU+vAryH2T6X4xQuAUTO7PMRuv0oPxXPA3Nu5DA==
X-Received: by 2002:a65:49c1:0:b0:3db:6979:ca6f with SMTP id t1-20020a6549c1000000b003db6979ca6fmr5034926pgs.76.1652466859949;
        Fri, 13 May 2022 11:34:19 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7842d000000b0050dc76281cesm2053566pfn.168.2022.05.13.11.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:34:19 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v7 net-next 03/13] net: limit GSO_MAX_SIZE to 524280 bytes
Date:   Fri, 13 May 2022 11:33:58 -0700
Message-Id: <20220513183408.686447-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513183408.686447-1-eric.dumazet@gmail.com>
References: <20220513183408.686447-1-eric.dumazet@gmail.com>
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

Make sure we will not overflow shinfo->gso_segs

Minimal TCP MSS size is 8 bytes, and shinfo->gso_segs
is a 16bit field.

TCP_MIN_GSO_SIZE is currently defined in include/net/tcp.h,
it seems cleaner to not bring tcp details into include/linux/netdevice.h

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Alexander Duyck <alexanderduyck@fb.com>
---
 include/linux/netdevice.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ce780e352f439afc9eec97fcf6e0a4cda5480331..fd38847d0dc7e2c985646ac427d0131995e9c827 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2272,14 +2272,17 @@ struct net_device {
 	const struct rtnl_link_ops *rtnl_link_ops;
 
 	/* for setting kernel sock attribute on TCP connection setup */
+#define GSO_MAX_SEGS		65535u
 #define GSO_LEGACY_MAX_SIZE	65536u
-#define GSO_MAX_SIZE		UINT_MAX
+/* TCP minimal MSS is 8 (TCP_MIN_GSO_SIZE),
+ * and shinfo->gso_segs is a 16bit field.
+ */
+#define GSO_MAX_SIZE		(8 * GSO_MAX_SEGS)
 
 	unsigned int		gso_max_size;
 #define TSO_LEGACY_MAX_SIZE	65536
 #define TSO_MAX_SIZE		UINT_MAX
 	unsigned int		tso_max_size;
-#define GSO_MAX_SEGS		65535
 	u16			gso_max_segs;
 #define TSO_MAX_SEGS		U16_MAX
 	u16			tso_max_segs;
-- 
2.36.0.550.gb090851708-goog

