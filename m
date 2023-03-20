Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435756C1338
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 14:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjCTN0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 09:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCTN0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 09:26:31 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE861B567
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 06:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679318790; x=1710854790;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eF0lhh/WDguKNw67MW2qwtBQ9s98s9AQJa+a0Zwkvyw=;
  b=aHPebm1rHhprbAQX9mmAew1aDAgakpmXrphT3rcrmyE8Um2zVIPHbSaR
   8Io5h/On+hYn1gEEgO6MvMFsFIAFd5dHgFPdOoDWGBzuelAgyoOy5WDKr
   il2eP8RFpoNUUG+6QJqHif52Uw5Hh7nmqOarPgr7sKCjTEEYp8aezf7v+
   M=;
X-IronPort-AV: E=Sophos;i="5.98,274,1673913600"; 
   d="scan'208";a="1114315193"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 13:26:16 +0000
Received: from EX19D001EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com (Postfix) with ESMTPS id D18C3A0DBE;
        Mon, 20 Mar 2023 13:26:12 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D001EUA004.ant.amazon.com (10.252.50.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Mon, 20 Mar 2023 13:26:11 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.172) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Mon, 20 Mar 2023 13:26:01 +0000
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
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Jie Wang" <wangjie125@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v6 net-next 1/7] netlink: Add a macro to set policy message with format string
Date:   Mon, 20 Mar 2023 15:25:17 +0200
Message-ID: <20230320132523.3203254-2-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230320132523.3203254-1-shayagr@amazon.com>
References: <20230320132523.3203254-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.172]
X-ClientProxiedBy: EX19D038UWC003.ant.amazon.com (10.13.139.209) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
index 3e8743252167..2ca76ec1fc33 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -161,9 +161,22 @@ struct netlink_ext_ack {
 	}							\
 } while (0)
 
+#define NL_SET_ERR_MSG_ATTR_POL_FMT(extack, attr, pol, fmt, args...) do {	\
+	struct netlink_ext_ack *__extack = (extack);				\
+										\
+	if (__extack) {								\
+		NL_SET_ERR_MSG_FMT(extack, fmt, ##args);			\
+		__extack->bad_attr = (attr);					\
+		__extack->policy = (pol);					\
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

