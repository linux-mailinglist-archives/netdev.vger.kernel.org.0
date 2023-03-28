Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9376CCC0F
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 23:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjC1VVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 17:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjC1VV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 17:21:29 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CAC211D
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 14:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680038488; x=1711574488;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zCQLbE/0e7am1guRcojycErNOj8G1AthkX4HxuYl4mU=;
  b=G9B99gOfJ2diP/vMBzwaZn/wgvrLD0VDCDOF48GewNKUYVKLEFKkPXXs
   wPszJqN14xmsGSEhrt7Xza49VcaXD0Sf1TLhQBIsYc5w41IVkhTQlpzQT
   01WI7ndd8kPxKpTyBFrf1azHugK2cRvdhn02jFvKPfKMxRAS7m9hOt0QC
   A=;
X-IronPort-AV: E=Sophos;i="5.98,297,1673913600"; 
   d="scan'208";a="314328333"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 21:21:26 +0000
Received: from EX19D020EUA003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com (Postfix) with ESMTPS id B7EDD8180D;
        Tue, 28 Mar 2023 21:21:22 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D020EUA003.ant.amazon.com (10.252.50.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 28 Mar 2023 21:21:21 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.176) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 28 Mar 2023 21:21:09 +0000
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
Subject: [PATCH v1 ethtool-next] ethtool: Add support for configuring tx-push-buf-len
Date:   Wed, 29 Mar 2023 00:20:41 +0300
Message-ID: <20230328212041.4191693-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.176]
X-ClientProxiedBy: EX19D046UWA003.ant.amazon.com (10.13.139.18) To
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

This attribute, which is part of ethtool's ring param configuration
allows the user to specify the maximum number of the packet's payload
that can be written directly to the device.

Example usage:
    # ethtool -G [interface] tx-push-buf-len [number of bytes]

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 ethtool.c                    |  1 +
 netlink/desc-ethtool.c       |  2 ++
 netlink/rings.c              | 38 +++++++++++++++++++++++-------------
 uapi/linux/ethtool_netlink.h |  2 ++
 4 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 6022a6e..ea79529 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5751,6 +5751,7 @@ static const struct option args[] = {
 			  "		[ cqe-size N ]\n"
 			  "		[ tx-push on|off ]\n"
 			  "		[ rx-push on|off ]\n"
+			  "		[ tx-push-buf-len N]\n"
 	},
 	{
 		.opts	= "-k|--show-features|--show-offload",
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index 2d8aa39..c79ba3a 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -159,6 +159,8 @@ static const struct pretty_nla_desc __rings_desc[] = {
 	NLATTR_DESC_U32(ETHTOOL_A_RINGS_CQE_SIZE),
 	NLATTR_DESC_BOOL(ETHTOOL_A_RINGS_TX_PUSH),
 	NLATTR_DESC_BOOL(ETHTOOL_A_RINGS_RX_PUSH),
+	NLATTR_DESC_U32(ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN),
+	NLATTR_DESC_U32(ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX),
 };
 
 static const struct pretty_nla_desc __channels_desc[] = {
diff --git a/netlink/rings.c b/netlink/rings.c
index 57bfb36..51d28c2 100644
--- a/netlink/rings.c
+++ b/netlink/rings.c
@@ -44,22 +44,26 @@ int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	print_string(PRINT_ANY, "ifname", "Ring parameters for %s:\n",
 		     nlctx->devname);
 	print_string(PRINT_FP, NULL, "Pre-set maximums:\n", NULL);
-	show_u32("rx-max", "RX:\t\t", tb[ETHTOOL_A_RINGS_RX_MAX]);
-	show_u32("rx-mini-max", "RX Mini:\t", tb[ETHTOOL_A_RINGS_RX_MINI_MAX]);
-	show_u32("rx-jumbo-max", "RX Jumbo:\t",
+	show_u32("rx-max", "RX:\t\t\t", tb[ETHTOOL_A_RINGS_RX_MAX]);
+	show_u32("rx-mini-max", "RX Mini:\t\t", tb[ETHTOOL_A_RINGS_RX_MINI_MAX]);
+	show_u32("rx-jumbo-max", "RX Jumbo:\t\t",
 		 tb[ETHTOOL_A_RINGS_RX_JUMBO_MAX]);
-	show_u32("tx-max", "TX:\t\t", tb[ETHTOOL_A_RINGS_TX_MAX]);
+	show_u32("tx-max", "TX:\t\t\t", tb[ETHTOOL_A_RINGS_TX_MAX]);
+	show_u32("tx-push-buff-max-len", "TX push buff len:\t",
+		 tb[ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX]);
 	print_string(PRINT_FP, NULL, "Current hardware settings:\n", NULL);
-	show_u32("rx", "RX:\t\t", tb[ETHTOOL_A_RINGS_RX]);
-	show_u32("rx-mini", "RX Mini:\t", tb[ETHTOOL_A_RINGS_RX_MINI]);
-	show_u32("rx-jumbo", "RX Jumbo:\t", tb[ETHTOOL_A_RINGS_RX_JUMBO]);
-	show_u32("tx", "TX:\t\t", tb[ETHTOOL_A_RINGS_TX]);
-	show_u32("rx-buf-len", "RX Buf Len:\t", tb[ETHTOOL_A_RINGS_RX_BUF_LEN]);
-	show_u32("cqe-size", "CQE Size:\t", tb[ETHTOOL_A_RINGS_CQE_SIZE]);
-	show_bool("tx-push", "TX Push:\t%s\n", tb[ETHTOOL_A_RINGS_TX_PUSH]);
-	show_bool("rx-push", "RX Push:\t%s\n", tb[ETHTOOL_A_RINGS_RX_PUSH]);
-
-	tcp_hds_fmt = "TCP data split:\t%s\n";
+	show_u32("rx", "RX:\t\t\t", tb[ETHTOOL_A_RINGS_RX]);
+	show_u32("rx-mini", "RX Mini:\t\t", tb[ETHTOOL_A_RINGS_RX_MINI]);
+	show_u32("rx-jumbo", "RX Jumbo:\t\t", tb[ETHTOOL_A_RINGS_RX_JUMBO]);
+	show_u32("tx", "TX:\t\t\t", tb[ETHTOOL_A_RINGS_TX]);
+	show_u32("rx-buf-len", "RX Buf Len:\t\t", tb[ETHTOOL_A_RINGS_RX_BUF_LEN]);
+	show_u32("cqe-size", "CQE Size:\t\t", tb[ETHTOOL_A_RINGS_CQE_SIZE]);
+	show_bool("tx-push", "TX Push:\t\t%s\n", tb[ETHTOOL_A_RINGS_TX_PUSH]);
+	show_bool("rx-push", "RX Push:\t\t%s\n", tb[ETHTOOL_A_RINGS_RX_PUSH]);
+	show_u32("tx-push-buf-len", "TX push buff len:\t",
+		 tb[ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN]);
+
+	tcp_hds_fmt = "TCP data split:\t\t%s\n";
 	tcp_hds_key = "tcp-data-split";
 	tcp_hds = tb[ETHTOOL_A_RINGS_TCP_DATA_SPLIT] ?
 		mnl_attr_get_u8(tb[ETHTOOL_A_RINGS_TCP_DATA_SPLIT]) : 0;
@@ -137,6 +141,12 @@ static const struct param_parser sring_params[] = {
 		.handler	= nl_parse_direct_u32,
 		.min_argc	= 1,
 	},
+	{
+		.arg		= "tx-push-buf-len",
+		.type		= ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
 	{
 		.arg            = "rx-buf-len",
 		.type           = ETHTOOL_A_RINGS_RX_BUF_LEN,
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index 13493c9..cd85de1 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -357,6 +357,8 @@ enum {
 	ETHTOOL_A_RINGS_CQE_SIZE,			/* u32 */
 	ETHTOOL_A_RINGS_TX_PUSH,			/* u8 */
 	ETHTOOL_A_RINGS_RX_PUSH,			/* u8 */
+	ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN,		/* u32 */
+	ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX,		/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_RINGS_CNT,
-- 
2.25.1

