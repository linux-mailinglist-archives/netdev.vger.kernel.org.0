Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1933D3A1902
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239042AbhFIPSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:18:37 -0400
Received: from mail-am6eur05on2097.outbound.protection.outlook.com ([40.107.22.97]:56865
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238357AbhFIPSa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 11:18:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MK4b0bBTYJbJxYRdRG1q1SNMMyc6oHcMeY7iaDGk2j/vTrlSUT+1d9TNR3w2XU005No/Lcz84uFxH9yr/3UaCCFjeli7eZJOEOTZFSpsu/gju0kYFmnaGy6Eri9Y2F5WnlRYmYppAAKUuphWLbFkqaGV2IMhKZjPN+Irzuq3iKemkpHNq80KOYPjZtKLNmvDN/fmBX0gbCX+IbAsJXvXXrypKeDMvCBWOuiAxMuHh/iNn/sPttIdPgZA8gzijDw6EH7EzTOsTbAQ4vDEra5cOzMTADe6FR88KNXrNDZkNgJ0O9wwv4g/eZNuS/l9kCd0VMLfjYbLrJOmc8u/rqBRuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4enmdNU+t/tQghyp5y49qgpLNc+GCyqWWfDRf3tpc8=;
 b=EN+qCBK4+nLzx6S1oezgAvCMpyHtnabK3CYnEOpH3fis1ADXEIRL5SQH0NNOMAxGI9gdyicOjkE2/5gwYlqxm/vtwQXfIfUkkzupWQpiS/2QBsA4QGXDXkzao2UIlNW3LEoYEi63otIjUX6uaIg8desOzxUD3COSCsa27Lh53EQddaIR/6fTn7p1pubUEov6vJga3WA74nU//9/fBXw1p7ZQfyoSq72K9YUuD0kDWqzuPNgrBagXHibnp7lSSR2fk4nQzVEbFrQUqVYtAu4mMzL8eQiDoqYwQ/6/cygnsQqHBlZkwIqzyzTy7QzSgrjrZqZ53siUwvjN3PBuvGUd5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4enmdNU+t/tQghyp5y49qgpLNc+GCyqWWfDRf3tpc8=;
 b=kfccq7dG5s5FN1V1xr45M3LynD72RL1rxDhKpW4BEzLAG3jssae128qUKnZp5JXaMi1bpc8OeKPX22UbcZyPLEVKmYLazz+6zMTPddC59sN6VAB2fQGTKXmb2MaVZNMlyo3leoHwDLqARB1IrLQCVfmzl5aTWYVoDKbc41hFz9E=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1427.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 15:16:30 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 15:16:30 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/11] drivers: net: netdevsim: add devlink trap_drop_counter_get implementation
Date:   Wed,  9 Jun 2021 18:15:55 +0300
Message-Id: <20210609151602.29004-6-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
References: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR06CA0092.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::33) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0092.eurprd06.prod.outlook.com (2603:10a6:208:fa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 15:16:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 652e4925-9bcd-4c1e-7b74-08d92b598f5d
X-MS-TrafficTypeDiagnostic: AM9P190MB1427:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB1427A25BC937F01D209AE1DDE4369@AM9P190MB1427.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yoS2tmb9hxvW+ZwzLj3aaUJ63nXASUmFgZHMzrK2/kVmSLmQIhsylw5ibhlVBF0GaqscJW7Kf0C+7IY9rwzeOJxzeI2fs74v7wA28vWLoCFu7aoDJx/Fj82cTLDkJtdJJQZ0ShkmVbiT9cEe2Hm/KHhSuY5rbl5wcyPPGDQ0kOHkNuWS0xRKINXE+4OuNYGqvwYdjOVBilW9qxGd9QRkprTHSMI6cbI7/vL2AaEOYrghEC1Ft7QeavNyLHKMV8xaqny0Fwj601LUNn5v1Nc4CXKGzp1/IPR9aVFGIYkR1TyrjygjD7YQ7Gm1ws/RFSrUC9uA4gxinT+LkF7zcpnNbl3ZADJdNUwcRhuKLqrrxiZFriHamCtPNb8rW1xsWv7I6trpu9rjMoZRbFd9L5vGRPM4amziW5sstj6GC+QSbguOG4KwHzZMGKSBwqstTr0WnVYREGiB9+V0PMkgIw2eg/zM3LuGnFI4ckBZjnzYvgNiacVh34IuUkfiAwTvhkWEyml4dta5jaEGgO6kp5rvYHTZMNAWBQ5t89YGLTTgIC2vn5FiV6RmRN8xWWPBkIlJQvmgqvJ2Su/fLTusKtvipkEjs66JtIWhRW9JoWIkuX+wklHMu+yEI2NdUiSn07z8x91jsSAl9ZtpHTV6kyY7xvkl70pBdlO5ypu+Fq4X7qY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39830400003)(366004)(83380400001)(956004)(52116002)(2906002)(1076003)(186003)(66556008)(66946007)(16526019)(6506007)(2616005)(6486002)(6666004)(26005)(66476007)(38350700002)(8676002)(36756003)(86362001)(4326008)(5660300002)(478600001)(44832011)(6512007)(38100700002)(316002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Smrf5pglYX9lkcRm+l8V0Sqq83uojl+/7K8os55W8mNsUdJkpYzEGZVyA6Nn?=
 =?us-ascii?Q?eY05ezCQL1Fjh++oKjHrduWN07eZ0u4P3vJJmpetya5G9n9WHbXUsyO/xseM?=
 =?us-ascii?Q?CC/+9xwdaIp4e8izvHpBHX4kdq2qZJ2//ghWgQMYFnH3RYrCwSiHF4FaO8y2?=
 =?us-ascii?Q?tutsUulYGahS29PBXvE6QyiDdEGy+WZ1RwYui3182Nzx5NwTh5pQnsPFjn5r?=
 =?us-ascii?Q?CyQw7wWIsmJtYoOQho10E2M1JwTGkMO5Hrf2sMILivEpWn/dvdIqyc++IFbA?=
 =?us-ascii?Q?D9T6voGm4iw3xBA3JH5yH+LyG1LV6alY096fnSQ8p/kQEYPCJF6207KC7e+O?=
 =?us-ascii?Q?HwqJYSw1BdfzUQ49+3jNDGVQwomBwY6PpLiswcSnitYp/gljTw3kr588Cfny?=
 =?us-ascii?Q?aFtBG1fXYeswaCExz0kvO2sqg4rRsWnNCAbWsYWQfaVN9yFK5Pvu4QLwUnDU?=
 =?us-ascii?Q?FwNMQYvqRcuUr4TVCXxryTBOg/WJxZrU0XWTTBGFkJGFvjmwUm/fmmANaLx1?=
 =?us-ascii?Q?j9qwTFh1tYewaEEmuqvFRk4ydbiOuhzzKSr4cZODbRwOkp/plQQ2uhPLZXPH?=
 =?us-ascii?Q?QCUiW9Uq9Fg80NsSl8sL2T8N6d84upl0g+LyNVlo2Gyzp+VvDPg+rQVLhnLD?=
 =?us-ascii?Q?9Jtix8iPP+djj16szxjyCRO0weM5YGZUGwwNONiopaGVCmjfy58cnTG2iHkj?=
 =?us-ascii?Q?DHLikDbCuy7QfKA5DiAyPOsD4R6CltO2/d/arL4EIIAk2QsDmrHRpk55Itsd?=
 =?us-ascii?Q?RJ56pJNUuiz7Kt2ewJHPfPpxuTyqfT7a9TDrd8xbE5BhGHqAo1uDVOy7Hn6c?=
 =?us-ascii?Q?A8I/1E2gKSCfXOpWCb0PTD+Jw3yyYeeMn8ROXQo4CPjHNMB0BBsx1Ez0oFHk?=
 =?us-ascii?Q?dW4kaKExQ+AwAj80RU/zJ2hVgn3yEEHKDfErknleb0FLQa06R8pBu6WWvmYS?=
 =?us-ascii?Q?n7Iiju3zs8ufIlECVbCR1l2onHC4Xwr7yCY0noVALsZ0CKcYw3HHEG3/ba2/?=
 =?us-ascii?Q?cRWAmVMZFG1bWU73x7XkbmAknQw4rhA0KBLIIHwO9Dm+Smnyj07NsVYZQeVX?=
 =?us-ascii?Q?Wa9jbsGpAUnXPYfq+WGYcjwUgyKaVRb2ODlE5cT4NWu16OnZTGkLea1r/U5L?=
 =?us-ascii?Q?1q1R5b30fQPN42x14HGQFg0pf7JlkO2qV2a6+FBYF/+z+lDOKl0hTM/UW9PT?=
 =?us-ascii?Q?mzue/3xecCJ37F/1+ZMzSvOt5DuadYLZh/K+HYs/ohkd13K1B4bj/2Bdf31r?=
 =?us-ascii?Q?vK5GU5a5lW0TnQYFIrxSL0t5Ajv9EjzbPKYPXuvJQO/3TUB/UbxzAURiVMzr?=
 =?us-ascii?Q?iHiDmEZGZOUgWvWlXfjivKAk?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 652e4925-9bcd-4c1e-7b74-08d92b598f5d
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 15:16:30.7963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZBqxjFPBAQi5S5xeBAzJnl80A8ZNkB3n3s5dPC3Mq4iHcFc1xhMe5M74W8b2J8r5JqZNVHY65VjiWNRb1yLOHuR4LVQ8EFKbGU/GtIdNi0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1427
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever query statistics is issued for trap with DROP action,
devlink subsystem would also fill-in statistics 'dropped' field.
In case if device driver did't register callback for hard drop
statistics querying, 'dropped' field will be omitted and not filled.
Add trap_drop_counter_get callback implementation to the netdevsim.
Add new test cases for netdevsim, to test both the callback
functionality, as well as drop statistics alteration check.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 drivers/net/netdevsim/dev.c       | 22 ++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 6189a4c0d39e..87e039433312 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -231,6 +231,9 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	debugfs_create_bool("fail_trap_policer_counter_get", 0600,
 			    nsim_dev->ddir,
 			    &nsim_dev->fail_trap_policer_counter_get);
+	debugfs_create_bool("fail_trap_counter_get", 0600,
+			    nsim_dev->ddir,
+			    &nsim_dev->fail_trap_counter_get);
 	nsim_udp_tunnels_debugfs_create(nsim_dev);
 	return 0;
 }
@@ -416,6 +419,7 @@ struct nsim_trap_data {
 	struct delayed_work trap_report_dw;
 	struct nsim_trap_item *trap_items_arr;
 	u64 *trap_policers_cnt_arr;
+	u64 trap_pkt_cnt;
 	struct nsim_dev *nsim_dev;
 	spinlock_t trap_lock;	/* Protects trap_items_arr */
 };
@@ -892,6 +896,23 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
 	return 0;
 }
 
+static int
+nsim_dev_devlink_trap_hw_counter_get(struct devlink *devlink,
+				     const struct devlink_trap *trap,
+				     u64 *p_drops)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	u64 *cnt;
+
+	if (nsim_dev->fail_trap_counter_get)
+		return -EINVAL;
+
+	cnt = &nsim_dev->trap_data->trap_pkt_cnt;
+	*p_drops = (*cnt)++;
+
+	return 0;
+}
+
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT |
 					 DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
@@ -905,6 +926,7 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.trap_group_set = nsim_dev_devlink_trap_group_set,
 	.trap_policer_set = nsim_dev_devlink_trap_policer_set,
 	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
+	.trap_drop_counter_get = nsim_dev_devlink_trap_hw_counter_get,
 };
 
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 7ff24e03577b..db66a0e58792 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -236,6 +236,7 @@ struct nsim_dev {
 	bool fail_trap_group_set;
 	bool fail_trap_policer_set;
 	bool fail_trap_policer_counter_get;
+	bool fail_trap_counter_get;
 	struct {
 		struct udp_tunnel_nic_shared utn_shared;
 		u32 __ports[2][NSIM_UDP_TUNNEL_N_PORTS];
-- 
2.17.1

