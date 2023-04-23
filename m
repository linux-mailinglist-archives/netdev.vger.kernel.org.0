Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A6F6EC08D
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 16:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjDWOvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 10:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjDWOvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 10:51:10 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EBA1700
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 07:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1682261449; x=1713797449;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OsOsTh+zgSAkolWg1uziqSdqMnERI9MyUhCblKCj9os=;
  b=d7os/PXfy6qXsyWVuQQSi7v50DUZkRT/WmJ4R0/muBvypGXaNrsEa3hE
   yewLbYDf7OKGSol++TT6AcOzYUMHOV7x8ruCKKGcCsCtOlNv8I5gW79al
   AEfTvj2wVwq+L9IG3AEifb1+dXL74b54B/DVtYHq6NlX3x1CzduaBBFnk
   U=;
X-IronPort-AV: E=Sophos;i="5.99,220,1677542400"; 
   d="scan'208";a="317383793"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-47cc8a4c.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 14:50:46 +0000
Received: from EX19D017EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-47cc8a4c.us-east-1.amazon.com (Postfix) with ESMTPS id D886F160CBC;
        Sun, 23 Apr 2023 14:50:44 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D017EUA001.ant.amazon.com (10.252.50.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Sun, 23 Apr 2023 14:50:43 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.178) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Sun, 23 Apr 2023 14:50:33 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>,
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
Subject: [PATCH v2 ethtool-next 2/2] ethtool: Add support for configuring tx-push-buf-len
Date:   Sun, 23 Apr 2023 17:49:48 +0300
Message-ID: <20230423144948.650717-3-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230423144948.650717-1-shayagr@amazon.com>
References: <20230423144948.650717-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.178]
X-ClientProxiedBy: EX19D045UWC004.ant.amazon.com (10.13.139.203) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 ethtool.8.in           |  5 +++++
 ethtool.c              |  1 +
 netlink/desc-ethtool.c |  2 ++
 netlink/rings.c        | 38 ++++++++++++++++++++++++--------------
 4 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/ethtool.8.in b/ethtool.8.in
index 3672e44..f068258 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -202,6 +202,7 @@ ethtool \- query or control network driver and hardware settings
 .BN cqe\-size
 .BN tx\-push
 .BN rx\-push
+.BN tx\-push\-buf\-len
 .HP
 .B ethtool \-i|\-\-driver
 .I devname
@@ -625,6 +626,10 @@ Specifies whether TX push should be enabled.
 .TP
 .BI rx\-push \ on|off
 Specifies whether RX push should be enabled.
+.TP
+.BI tx\-push\-buf\-len \ N
+Specifies the maximum number of bytes of a transmitted packet a driver can push
+directly to the underlying device
 .RE
 .TP
 .B \-i \-\-driver
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
-- 
2.25.1

