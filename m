Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD99233486
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 16:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729480AbgG3OeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 10:34:04 -0400
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:36286
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727966AbgG3OeD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 10:34:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdeVw4AK/VYaxssdnEtQL0oDGEczdk6HtC16z9IxF9wL8Vg+qJKMzsh1Odht9/J2jZR9rjpcW5Z7KEBU9jfS8dPpZHxKJ2f6cHLWYpGqDbreepZhpBkqGwuk0HP5q9oiqYDG1uXFpTUS2ResxiSq6vt2jvbvYe1cLJQQY0ev6jhstoRCpAlIH1Eql3qFe0zFz9xSbcxaq0nz7Q0iIgLTv/yAmcxeSLYDO53r/sTVYRAkNTp+js+QrqPfXyjnIKuz/AWXEV/kGHR1WJ8ZktQivEs3MtcVT3U0E1ZoHq1FPlWtO86Yqe7cvRACXA4PSTeAxPZL7HSDcR9eft5Rg4AjHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhSq12D/3AJzKznLHF+6hapqqhXz/W3H9FwAdSVpmT0=;
 b=QM5oY4KJ8/rJXQXvNO/ucOYZ31qS9BkXuiVtKcSUmtSkFCCa32pBU3VEPSYPyaRxvw/QzBMXZzkObTx4QrD8AQkvPIh+wFCXl8MGbKW9FcNBOCzzhVzjm2s1TEsgfyRFe9gIBzIh3Rggc255qL9wAg9kUJ/PEOb8QP0CV9bUzP6HKBas4Q5F9yamg8NxJwYKG1Ixm1M/b31O5G1gowJ6OqxGBkZjHpwWLBX4yGSHpDdUR+14r66+x3wfdMJt2YnuLYPKgnQpQo8Y3OORgXdtY6Jz2UxDGZfArN0RcX9jAypDV2Lbmuq6mQ6NYcDt3JkOej6MBurTYu1b/M96mIGnpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhSq12D/3AJzKznLHF+6hapqqhXz/W3H9FwAdSVpmT0=;
 b=diGUy47WeMGh112CjNGJ3uWEpwioWJozjLIDPIpKwZotuPYyVVEH0p+PigBKsvrKwYCwOvgoqSlpddwv6jw/gJjKm2x+Ux9JOn3tdNTHEOKPKUwzbVlls0g0KmpfxP8jih28xx2HXLkk/DdjYY4knFLnGxdN/u1tTP8Vh1STx1s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB4419.eurprd05.prod.outlook.com (2603:10a6:208:5a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Thu, 30 Jul
 2020 14:33:58 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::6926:f23d:f184:4a8c]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::6926:f23d:f184:4a8c%7]) with mapi id 15.20.3239.019; Thu, 30 Jul 2020
 14:33:58 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [PATCH iproute2-next v2 1/2] devlink: Expose number of port lanes
Date:   Thu, 30 Jul 2020 17:33:17 +0300
Message-Id: <20200730143318.1203-2-danieller@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200730143318.1203-1-danieller@mellanox.com>
References: <20200730143318.1203-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0136.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::41) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (94.188.199.2) by AM0PR01CA0136.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18 via Frontend Transport; Thu, 30 Jul 2020 14:33:56 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7e974393-2871-4a37-c13d-08d834959828
X-MS-TrafficTypeDiagnostic: AM0PR05MB4419:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB44193C23A8AC1A21575EAF10D5710@AM0PR05MB4419.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sdXnCGMgMKe6ZNVV/olNBbylyP/YAw8soDzMr5K+qZwldtBdaeWNDmIBbVt0+crcGLAMyzOfy2wWeVmdbAYzgkgymcNDcylguzJxReVEM1PwY9hfJoIuPCUiGmckmsznMkM8Juw9zGomt6Ie6mXhS2ZFQCsPLkooUrNqiWiktz/V0O2kl1VAuwzzQMERMspQjqpMKZptabyXZ4upwi2QE0qKA6lzOOR0Cy1xyUB2oE+SF9HEM3NbqnJEnw+T8Lcc838ruXmfauZz27p4Mi90KXb56rG+Lw6C5UinvJdqqq7pttPBSd29lpl5FwK6AwRj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(2906002)(52116002)(2616005)(5660300002)(1076003)(956004)(16526019)(186003)(4326008)(26005)(6916009)(66476007)(66556008)(6506007)(66946007)(107886003)(6486002)(6666004)(478600001)(8936002)(86362001)(8676002)(6512007)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uewD/QTDlkY0eUGdcZ6rnbLLZjyTAZ1OApNAWGKKhfds7hisbO1OH/+So5U+IZ+gdcsu3yg0U0VeUyrxK8um+4ChnwhppCFQxJoOQ20SyssGYv8ZihhwnjcSjjO3p3dWlUM6uWNrBIwgrst0htSNS11YaTYaPP3LbTg32qGePHtEiQRw5ahpZcKPQ72wXQtRSQj82XcdSUD/43A9a9Ia3E4dzwUKnpAGvrSEDYeffbEKKWT1UD2qaUHvuLry323/OaFvICHyLLSipObDTLW5ClVV7i8H3CglMMx58HNrDcPQup3RG5DgJpBOJzxr9DxnGAse3LOMKnhlUoLEFLQ1U106jqiTs1ujxvmtgJT48Xib8EoK8aU0cRhjg0mG4JmmkLtnsXKVV/1RyJ48Tdax32WUnkWcvonbaOBwv2vgIyl7DmZU5AN09Ft9TBZ7pqgabeHbGpGOfiFyajYMYSsALyy6CFfJasIOesYmyaUH8vARb2Fm/7/bN2A8g9bkP7EuN3NXW5EvcrTtlhgFmkYGRJYukwO4UzNzPUtP7+zF++Xk0/BTBr5mO7FUG/RJl9H03Y/aJJiF7AyOi5FzCcZ+QDuf5F4mUlD2jqTAFgKabmO2LZh8Yru71rE9jB0Mq3Xnmly1d6Sb6btHJbo/KQM3Mw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e974393-2871-4a37-c13d-08d834959828
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 14:33:58.2853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L9FCSuoQ1bzE7jxrFSOy6WOQS8CSucNnCoxTfqebP5ki1SMlaDOgN3yEOGbzF1sydSnY3MUioqCiPBFQnT05Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4419
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new attribute that indicates the port's number of lanes to devlink port.

Expose the attribute to user space as RO value, for example:

$devlink port show swp1
pci/0000:03:00.0/61: type eth netdev swp1 flavour physical port 1 lanes 1

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
---
 devlink/devlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 7dbe9c7e..39bc1119 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -581,6 +581,7 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_PORT_NETDEV_IFINDEX] = MNL_TYPE_U32,
 	[DEVLINK_ATTR_PORT_NETDEV_NAME] = MNL_TYPE_NUL_STRING,
 	[DEVLINK_ATTR_PORT_IBDEV_NAME] = MNL_TYPE_NUL_STRING,
+	[DEVLINK_ATTR_PORT_LANES] = MNL_TYPE_U32,
 	[DEVLINK_ATTR_SB_INDEX] = MNL_TYPE_U32,
 	[DEVLINK_ATTR_SB_SIZE] = MNL_TYPE_U32,
 	[DEVLINK_ATTR_SB_INGRESS_POOL_COUNT] = MNL_TYPE_U16,
@@ -3423,6 +3424,10 @@ static void pr_out_port(struct dl *dl, struct nlattr **tb)
 	if (tb[DEVLINK_ATTR_PORT_SPLIT_GROUP])
 		print_uint(PRINT_ANY, "split_group", " split_group %u",
 			   mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_SPLIT_GROUP]));
+	if (tb[DEVLINK_ATTR_PORT_LANES])
+		print_uint(PRINT_ANY, "lanes", " lanes %u",
+			   mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_LANES]));
+
 	pr_out_port_function(dl, tb);
 	pr_out_port_handle_end(dl);
 }
-- 
2.20.1

