Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520774FF53A
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbiDMKy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235025AbiDMKyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:54:49 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD7C59A75
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:28 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id lc2so3061091ejb.12
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TL0c+Hs+0lBMqasciNPJrqUQXbgHwj7xsTQadVbU8KQ=;
        b=nOemDcgk5r0VlAKSVFNceh7dNh1uBqsIVQwLdnbY5q/cBVo39X4dUlRJlTF5Qurn5q
         beCBvCeRL3+X8pe82zI1Al4cih9Y1uHj/sGrCfUAsXLdvUCv/TtxUSowA6gLXCdpNxuu
         NCKs7HvTtrIGNAUO8Py93bu1fRsJudXEOetSGPOYkX5+1F+4PBVHk6rFkI8VXVX/FI77
         zwCvbLKIIUZ3P/O20X26/vZCjzvBNpcsvBzyoGvEFubC28twGcjOYklmqbo1c3nWNnWn
         DL8JBQfxeYKIv2kt/VoYHSLG9fyTrDdvcVo5/S7G/HkLGw7lii/TzM9CvGmZik9mWU4E
         7I2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TL0c+Hs+0lBMqasciNPJrqUQXbgHwj7xsTQadVbU8KQ=;
        b=Ytar79tnzBaKcG1fkQDhva7un1ClKeGu/Mrxmjh9ZIIYpxsEtGzBMySjTOmvPr70SM
         Mmlkqh4nBCfeO7Q7SxP03G41XdZMFjZvHsxP9v6JxOkedfJeUOdurHm9GsYzu2iSuBiA
         c1ZREBb2b72auVO2thIl83KKCHTA9DW323ZojfvWDzxxKE8/NXZ0kbSl9g0yc7hpuTdm
         3+HtY/qmS8Nm+qnSIzuadOFbrry4UCJGeHhxYipZBTO5D0U1UV6c9aEPNQzBcvnkrksY
         9o4Nema+Ptgw7qjzDVem8qsU7jyRYEljFroCdy6EevdFkBxHDlbQhzQufDL0w6NcHjgT
         H2JQ==
X-Gm-Message-State: AOAM5330WgXxk0evLOZDNAw/OlElGBjdyjI113dhW5UJo1fWZKK5TVRQ
        3kiG6kYe7slx7z+PKcENGi9umfpWSo6zx1ht
X-Google-Smtp-Source: ABdhPJy6jvymQpMk1zpC1tA/B0YcrpU0Rqtjf4DLdZuYidwvgZC+l358W5S3hhilB/yQeW4IN50uGA==
X-Received: by 2002:a17:907:2d20:b0:6e8:a4d3:3e91 with SMTP id gs32-20020a1709072d2000b006e8a4d33e91mr9121457ejc.475.1649847147170;
        Wed, 13 Apr 2022 03:52:27 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id v8-20020a1709063bc800b006e898cfd926sm2960952ejf.134.2022.04.13.03.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 03:52:26 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v4 06/12] net: add ndo_fdb_del_bulk
Date:   Wed, 13 Apr 2022 13:51:56 +0300
Message-Id: <20220413105202.2616106-7-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413105202.2616106-1-razor@blackwall.org>
References: <20220413105202.2616106-1-razor@blackwall.org>
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

