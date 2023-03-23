Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8E06C716F
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbjCWUAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbjCWUAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:00:13 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D165B25BBB
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 13:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679601613; x=1711137613;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Glpju5v1160Q5YE+xKmsbGLBRnk3xQCL78S40FhmhiM=;
  b=LFIr4jJxtTkjBieF/TemW7YjYc8w/fp/wRKcwMWuEgW8mFLzdeBgbtaM
   arbPkDMa0frNgD3wMB7FKFtzNqqAv9PWEkvEWEYh7aLXRthjdycWdl4fW
   rnF1y+mAwluJ6Ul3SLxQGJJbrWK1GhZD8Ld9Z4L8dCBdu/ugu1YrnEsvz
   Y=;
X-IronPort-AV: E=Sophos;i="5.98,285,1673913600"; 
   d="scan'208";a="321946162"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-8a14c045.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 20:00:07 +0000
Received: from EX19D007EUA004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-8a14c045.us-west-2.amazon.com (Postfix) with ESMTPS id 9FC088A652;
        Thu, 23 Mar 2023 20:00:06 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D007EUA004.ant.amazon.com (10.252.50.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 23 Mar 2023 20:00:05 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.174) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 23 Mar 2023 19:59:55 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v8 net-next 1/7] netlink: Add a macro to set policy message with format string
Date:   Thu, 23 Mar 2023 21:59:17 +0200
Message-ID: <20230323195923.1731790-2-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230323195923.1731790-1-shayagr@amazon.com>
References: <20230323195923.1731790-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.174]
X-ClientProxiedBy: EX19D038UWC001.ant.amazon.com (10.13.139.213) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-10.0 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to NL_SET_ERR_MSG_FMT, add a macro which sets netlink policy
error message with a format string.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 include/linux/netlink.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 3e8743252167..3a55d6ef4dac 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -161,9 +161,22 @@ struct netlink_ext_ack {
 	}							\
 } while (0)
 
+#define NL_SET_ERR_MSG_ATTR_POL_FMT(extack, attr, pol, fmt, args...) do {	\
+	struct netlink_ext_ack *_extack = (extack);				\
+										\
+	if (_extack) {								\
+		NL_SET_ERR_MSG_FMT(_extack, fmt, ##args);			\
+		_extack->bad_attr = (attr);					\
+		_extack->policy = (pol);					\
+	}									\
+} while (0)
+
 #define NL_SET_ERR_MSG_ATTR(extack, attr, msg)		\
 	NL_SET_ERR_MSG_ATTR_POL(extack, attr, NULL, msg)
 
+#define NL_SET_ERR_MSG_ATTR_FMT(extack, attr, msg, args...) \
+	NL_SET_ERR_MSG_ATTR_POL_FMT(extack, attr, NULL, msg, ##args)
+
 #define NL_SET_ERR_ATTR_MISS(extack, nest, type)  do {	\
 	struct netlink_ext_ack *__extack = (extack);	\
 							\
-- 
2.25.1

