Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D25E20F186
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 11:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731941AbgF3JYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 05:24:53 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:21154
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731810AbgF3JYw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 05:24:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0q3RNVcwIQ/XU04iwdepf7M5yxoeC8X2ICIB+uw86X+gVglG6wXXRF0nJWSTHXytFUSj6z2Xg90jozSlAkkMcr5PLtuj7LnW+4nRuAVP8W4pI1pNeN7FQTulQhU9BiCISmtWFI1DDB7k4hmci7CmXjXF1RkkEUlPaH20mzx94wM+wKvUvfhrG6lZj+Je4mkGHcMISzkhHyLfvXciDttjFoyJqw75BW0TyU+GiRa3uk6XB1v25s+P+toc4L7kpdbJB6Ci1Zda/4e+AnoxDgIftsMvEzxLIB2sAVXXuEWwoRHtmGuEYGDCL8isCMUYjdoBCqpxn68V213weMmKJPQVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=draxkPE8kLDEA/7Jru9hLV8Rk/y575zkCvmEYpw4yRk=;
 b=BdSJbkMRJIAF25XkGHntMK1sVow1O7u2BxbD7Udq9OD/jjXOS4gDJkkmsCK3q0CEgvIyiTfZeW+5zxLQldmpjMG5POBRIk8DoDuC1qhQC2bIVjvayUDNHGvn33h09/N0ct/nL9DIKHa228IDEBN07YJqQfsTmeTf6567YVr6g1SyR/Gm0qCu/CY35RzyKk4U9XoJoHp7vpTfXLP1txNKsDcQV1gOCoXtdHZOBQK+n/oXawwTDqC+MO7Deyyfegoh6fSoy/2fJrLwayxToN5Y0twqEKfeer2KA3XNsdi5L2VBXo+/ltp/jtvW8nlZq8ClRQTG4Wr7gCEqhQ2lvFMGpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=draxkPE8kLDEA/7Jru9hLV8Rk/y575zkCvmEYpw4yRk=;
 b=af1L5VPzANRygZlc9iV1EljPL1a28aloMpDxh6THekjWXrMCUaV5CoJfSFIZjrLa3M6AJFRLqDygZGG93puQfCMZx5Md1zv5WGAbdFiVx/IVt52RvfuvACZtbANXyIoO1hzhWbugbLq8xGKR/NvcTfAePyM6qtm+6/DBJY67LcQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR05MB4450.eurprd05.prod.outlook.com
 (2603:10a6:208:61::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Tue, 30 Jun
 2020 09:24:41 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2534:ddc7:1744:fea9]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2534:ddc7:1744:fea9%7]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 09:24:41 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, davem@davemloft.net, o.rempel@pengutronix.de,
        andrew@lunn.ch, f.fainelli@gmail.com, jacob.e.keller@intel.com,
        mlxsw@mellanox.com, Amit Cohen <amitc@mellanox.com>
Subject: [PATCH ethtool 3/3] netlink: settings: expand linkstate_reply_cb() to support link extended state
Date:   Tue, 30 Jun 2020 12:24:12 +0300
Message-Id: <20200630092412.11432-4-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200630092412.11432-1-amitc@mellanox.com>
References: <20200630092412.11432-1-amitc@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0044.eurprd03.prod.outlook.com (2603:10a6:208::21)
 To AM0PR0502MB3826.eurprd05.prod.outlook.com (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR03CA0044.eurprd03.prod.outlook.com (2603:10a6:208::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 30 Jun 2020 09:24:40 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b9a336ea-509d-4cdc-9484-08d81cd76b1f
X-MS-TrafficTypeDiagnostic: AM0PR05MB4450:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB44504FF33C48621B4E2E45E2D76F0@AM0PR05MB4450.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:605;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7cOl3uhaF7W42OPfjQsFbcPY/OG9SBnHi9b4pIUAawmUonrXB9R79O41OYqy14gxG5+7k2+qWkfIeojAqfYcws/BEhmL30NLKBz0VjAUTh5X7Ye+Wzm4kPWyM/k6jbayGuR6mT5FnFhdM1W1mdJcQBcSUNHMZgMwbDP2iqeCx2dpaOJgkgDMjeKVupqPa2OIWuT0LBNDDjIjTvKhoCHv8z+SNhSKI0DqGkI7NGd9VC6V9RB2aZvZ/GsCbMti/+IxDVffkAGYXa4K2Vx2GDDtZuyZeSRkOdu0TjItQmi2cvT4ROSFroomAljBXNi1ddkgZaWKuUrbqCUDGVJNnhjpTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(52116002)(478600001)(2616005)(956004)(4326008)(2906002)(5660300002)(8936002)(316002)(6512007)(6916009)(66476007)(66556008)(8676002)(66946007)(6666004)(107886003)(86362001)(26005)(6506007)(186003)(83380400001)(36756003)(6486002)(1076003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uz39bqdG805el6lknooNRlAvM8LR/6lbmI1Z29ofdq+vFcQSLaq37gDfZolOTrWfQI8/H6fj4Wq/zxqg6VtLf+30SfDuECKvHvRmteiVnbBK5+1X2E86nxHsB4ufwLRABhVOhr3Mt4lWNlIeXKYzFXiQw2+JMMUBPCEsyvnOOjezRuViXjPEG9WesjXh33/6V4GNlSspqRUQTwmQ9oaC1G+tRP4qPv4SL7m5spgPb3dCVsGdaQ6utUdYw+Qfo+y0K8w3UCxmbXLIpaWzjR4cj+TLjqDMDdKucXrniA1zoyeu2gmZ1SWRf+M5w/I+7yLS1OMl9m79M6kOe77zliJNv/GoTsW453cH9A0Nx5wXNCvKlyGfH3SG6wnk187nbJXvs3JpVqascaEPbL2ZxN1WVhWdxlGIri2ydmLcu120kxGZctO0ZHTyI8cLWc1dqoAUHlnpAfx3f3HM3ouWTMJENJohpIec26p3sgBHakcnKAw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9a336ea-509d-4cdc-9484-08d81cd76b1f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0502MB3826.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 09:24:41.6131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JU4688LJ0RSD/8F7hgHm/OJGQ9wKaqji1qsygCLGmAkOX48/JufNas0/z+3zG/rRL8xSHyXKsua/lxBPbL5daQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4450
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print extended state in addition to link state.

In case that extended state is not provided, print state only.
If extended substate is provided in addition to the extended state,
print it also.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
---
 netlink/settings.c | 59 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 56 insertions(+), 3 deletions(-)

diff --git a/netlink/settings.c b/netlink/settings.c
index 35ba2f5..a4d1908 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -604,6 +604,57 @@ int linkinfo_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	return MNL_CB_OK;
 }
 
+int linkstate_link_ext_substate_print(const struct nlattr *tb[],
+				      struct nl_context *nlctx, uint8_t link_val,
+				      uint8_t link_ext_state_val,
+				      const char *link_ext_state_str)
+{
+	uint8_t link_ext_substate_val;
+	const char *link_ext_substate_str;
+
+	if (!tb[ETHTOOL_A_LINKSTATE_EXT_SUBSTATE])
+		return -ENODATA;
+
+	link_ext_substate_val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKSTATE_EXT_SUBSTATE]);
+
+	link_ext_substate_str = link_ext_substate_get(link_ext_state_val, link_ext_substate_val);
+	if (!link_ext_substate_str)
+		return -ENODATA;
+
+	print_banner(nlctx);
+	printf("\tLink detected: %s (%s, %s)\n", link_val ? "yes" : "no",
+	       link_ext_state_str, link_ext_substate_str);
+
+	return 0;
+}
+
+int linkstate_link_ext_state_print(const struct nlattr *tb[],
+				   struct nl_context *nlctx, uint8_t link_val)
+{
+	uint8_t link_ext_state_val;
+	const char *link_ext_state_str;
+	int ret;
+
+	if (!tb[ETHTOOL_A_LINKSTATE_EXT_STATE])
+		return -ENODATA;
+
+	link_ext_state_val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKSTATE_EXT_STATE]);
+
+	link_ext_state_str = link_ext_state_get(link_ext_state_val);
+	if (!link_ext_state_str)
+		return -ENODATA;
+
+	ret = linkstate_link_ext_substate_print(tb, nlctx, link_val, link_ext_state_val,
+						link_ext_state_str);
+	if (ret < 0) {
+		print_banner(nlctx);
+		printf("\tLink detected: %s (%s)\n", link_val ? "yes" : "no",
+		       link_ext_state_str);
+	}
+
+	return 0;
+}
+
 int linkstate_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 {
 	const struct nlattr *tb[ETHTOOL_A_LINKSTATE_MAX + 1] = {};
@@ -622,9 +673,11 @@ int linkstate_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 
 	if (tb[ETHTOOL_A_LINKSTATE_LINK]) {
 		uint8_t val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKSTATE_LINK]);
-
-		print_banner(nlctx);
-		printf("\tLink detected: %s\n", val ? "yes" : "no");
+		ret = linkstate_link_ext_state_print(tb, nlctx, val);
+		if (ret < 0) {
+			print_banner(nlctx);
+			printf("\tLink detected: %s\n", val ? "yes" : "no");
+		}
 	}
 
 	if (tb[ETHTOOL_A_LINKSTATE_SQI]) {
-- 
2.20.1

