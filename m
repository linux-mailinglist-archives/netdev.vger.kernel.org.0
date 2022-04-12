Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BD34FE26F
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355660AbiDLN3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356721AbiDLN2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:28:06 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84534C43B
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:12 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id u15so18665895ejf.11
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TL0c+Hs+0lBMqasciNPJrqUQXbgHwj7xsTQadVbU8KQ=;
        b=fY8ffGGtVbY8dJ+Pum0CRcGC6YXlMA0rkvpKenc11A5lffG+COmeo74YILwokEYNvW
         d1Jx0PgylqFD4fV5MaNcX1juwMsHgexHsy7vDHJMCPwI3vRaP6xsOj465eqv0jtWe8KH
         u4h0rjzKIx3u7t+TaIAywVpqeK+YJBsOtvXRUgfwDlp7b7a/9XOO0GSva/rMjzighPeu
         V5i0lVbjZjETVDO0wGUfaziUHKTXKfS9bIXTOctcHBTBwZXgFgPRu3IReq6b/xidMfx8
         KIPxBTcpUNm0OqFC6HVpVsAEwsDOljp3IGAI2GI3+goo5lB3RjUhowNGg2JP4J+jD0Z5
         MePg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TL0c+Hs+0lBMqasciNPJrqUQXbgHwj7xsTQadVbU8KQ=;
        b=LM9ZXd+JCPhxsI9YsAdlptAnItj9N7hsAxzN92ZUEzkGfE5eDB4/9joswm8UBQzXeh
         lY9Xd6evceTrI3cRgYOw5u7aEjYna3X5hM85McMEAYX5gVQo9i/lI3jIjoRgNshZxl6b
         bRZVVwsbwfdACBIGPTZQRrBXP8KyLwxhcskTkluWGe9dZdEcCW1C0TOmjlz7L7YsXPwg
         U7YR3DwX6OVA1chzrXY/XYDlsfHE1PPXiDqh7uN1ZSkxtF6Aw6cCbRLR9HnNNbEHuaHC
         Bg2Lq1TOgVeEcrNAb2h6BdX5HKnGYiFp5vlwiY27cH4gU7Qrwnagfg33Gn3JBxP3VU8B
         ckqw==
X-Gm-Message-State: AOAM532NWBdwlKcINgf8yV0xD9TBwEGmhsm6rvRDFOqgmUlQD0KP9pLC
        K4yFslbToaCRgsgKzvRwvSPOF1hvaXC4o9Zz
X-Google-Smtp-Source: ABdhPJw4d1MUchQXlkpHba8s2U9YZk+Af7ZipghYtclXLY7NwNHQ2H1zZ2Up8/8wRrhrAhLwekPOMg==
X-Received: by 2002:a17:906:37cd:b0:6e0:bdb6:f309 with SMTP id o13-20020a17090637cd00b006e0bdb6f309mr34510105ejc.394.1649769790535;
        Tue, 12 Apr 2022 06:23:10 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id z16-20020a17090665d000b006e8789e8cedsm3771301ejn.204.2022.04.12.06.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 06:23:10 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v3 2/8] net: add ndo_fdb_del_bulk
Date:   Tue, 12 Apr 2022 16:22:39 +0300
Message-Id: <20220412132245.2148794-3-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412132245.2148794-1-razor@blackwall.org>
References: <20220412132245.2148794-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new netdev op called ndo_fdb_del_bulk, it will be later used for
driver-specific bulk delete implementation dispatched from rtnetlink. The
first user will be the bridge, we need it to signal to rtnetlink from
the driver that we support bulk delete operation (NLM_F_BULK).

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/linux/netdevice.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 28ea4f8269d4..a602f29365b0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1260,6 +1260,10 @@ struct netdev_net_notifier {
  *		      struct net_device *dev,
  *		      const unsigned char *addr, u16 vid)
  *	Deletes the FDB entry from dev coresponding to addr.
+ * int (*ndo_fdb_del_bulk)(struct ndmsg *ndm, struct nlattr *tb[],
+ *			   struct net_device *dev,
+ *			   u16 vid,
+ *			   struct netlink_ext_ack *extack);
  * int (*ndo_fdb_dump)(struct sk_buff *skb, struct netlink_callback *cb,
  *		       struct net_device *dev, struct net_device *filter_dev,
  *		       int *idx)
@@ -1510,6 +1514,11 @@ struct net_device_ops {
 					       struct net_device *dev,
 					       const unsigned char *addr,
 					       u16 vid);
+	int			(*ndo_fdb_del_bulk)(struct ndmsg *ndm,
+						    struct nlattr *tb[],
+						    struct net_device *dev,
+						    u16 vid,
+						    struct netlink_ext_ack *extack);
 	int			(*ndo_fdb_dump)(struct sk_buff *skb,
 						struct netlink_callback *cb,
 						struct net_device *dev,
-- 
2.35.1

