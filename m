Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CB52EBE58
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbhAFNMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:12:00 -0500
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:34081
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727021AbhAFNL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 08:11:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThcSYTMsJtnLkHwdCVBr7gTV6OLqQZib87j9t5s12HRKuyE5r2EfG6S6lU+CQQ9zKgl6HPx5tIza7vpML8asS1uTDk4sV3nb8SIQu5q4nWkx331prEV+K285X/4GbpOl0fVC55rq2kZC6qaGSxYhgAaF5sFTRaUZzC5Of9Fe3R6o/L7M/wtcuRyLooRnirWoYHJiLx9ng0smRz4PHoYG18At6uxJgAJ3mgb5y92Ifdy+vCnIFKXU9MuonvE71TNr6VX+oKmKNhXWS2l8RRx/xU+2zATISER1Rx8xaFC94Y0Oah7RpaB6LoWTUItbv2pAEDT5nevbwMNA3bx2BmzTVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmDDTKnkoVxrtptqjD+XybisdXQj6Iwe99e/N6xlS0Q=;
 b=SFpmy6QRU0dI9Ssu1AxvjePHgXmGbyD8zOOFOJZ1eREuwFtRu7k6Silca1/yXrei34O9SLplErxMFC55zBbw7SKRqtLhkvT4fL63YCu//3R3oaPu2wfa3pURw+dpDbzouAok49rb4+Ru2bu4Ru/6eEatVN9b04/CzdGKXxe1ZEIQzjVFxGTnTt45IRWtILrkWGuOXteLAZEhuY7Ni4wGg8LUzwqiWnl4fKOd/mndMeKRfjgf7TJWst7LxQmKGi40FnN/falD0BuElPhgoRh9nVa2CjCF44xskbcW2cB0yiGvqQmgOFZ7f175ZSuTVAkLZPOlk9Ni/RjpQI43gjPORg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmDDTKnkoVxrtptqjD+XybisdXQj6Iwe99e/N6xlS0Q=;
 b=WQvryR3C9FUmTJcvScpeAGpFigHAz8xVjOSKmRe8qHbzuuMyhBD3xV69Jwb4oh9s1G4cldQCYIPjqaE7iV+ti1SpKecMjO+EmepBTF6xD5BnkAEo/eCQzg8wbIjA9xm+QoWAncBy0yseUeJC7B6nJzHDe61A0S7epBHFUI8O+uA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6418.eurprd05.prod.outlook.com (2603:10a6:208:13e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 6 Jan
 2021 13:10:25 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 13:10:25 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, f.fainelli@gmail.com, kuba@kernel.org,
        andrew@lunn.ch, mlxsw@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH ethtool 3/5] netlink: settings: Expose the number of lanes in use
Date:   Wed,  6 Jan 2021 15:10:04 +0200
Message-Id: <20210106131006.2110613-4-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106131006.2110613-1-danieller@mellanox.com>
References: <20210106131006.2110613-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR06CA0138.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::31) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by VI1PR06CA0138.eurprd06.prod.outlook.com (2603:10a6:803:a0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 13:10:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c94d43db-443c-48d9-a4b2-08d8b2446eb2
X-MS-TrafficTypeDiagnostic: AM0PR05MB6418:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB6418D849112C00A55A644FC8D5D00@AM0PR05MB6418.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6fAzNs8rmrPsAavHRaQgCn40W4G3Sw8VgGhDQdrYHh5Dpq/lC8jOH/1PSIApEPHX9RmMZC3TyqHGs2D52dfmufXA18RJMuGqA7AHm9+Aj0A+ENm+eV3j3wDMaqwQY+hcD4ROsFD7/vgZID2Hooa7IdM/tJKYp8l9p3THxBthG0Xq7o3k3+g/x/GL8S/9aqcMyIHN1Qjt+B9iV0kmwnwn9IFatJMaoMfMdYOTvLdO3odBoqE3im9y3KqgkhB0+FPZn4sRs2gN2t0bV4KDWGIGmmxup6Ld9COCSBpHCztsxDsMrL+QlYBqLzzI7J3/H5Bz0N/nZQLMAvcKc6UMkIdc/MRk0Lp1aTX0kUF/IU81cbiaODXEI7HSyXKAgNQp2bgXNi88h7NHSsMlcqFHKC5i+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(26005)(8936002)(16526019)(186003)(6486002)(6512007)(316002)(6916009)(5660300002)(6666004)(4326008)(2906002)(6506007)(956004)(2616005)(86362001)(1076003)(8676002)(66946007)(478600001)(66556008)(66476007)(36756003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UnsPawc0Tv0XIFGoAn3lfYKwcnzRfmjJMhh1yqcf7BpN1D1Emmm5BJRjvwcM?=
 =?us-ascii?Q?xLSjgm7mIQIkRY0mmos+4/0QxY0VwGM2OH7MQKK/h4IFLTYFA/aULejYixeL?=
 =?us-ascii?Q?QOfPZR8f8j2h0PE291UY3Ee/Uoi0UThhlsY7sDIxLtu8ITXaRJEFGVk2kcoz?=
 =?us-ascii?Q?V2Dwff0Nr4KSWfst5j1djlQlIQi2mdQrHO2OQXP0YLKeJfKikAS5tN4HnzZo?=
 =?us-ascii?Q?9hficd6czSiwRcXxAPbOBFCEWjAAaICkJ6VzMob5MtzbI1RtYo/dzAaYGku3?=
 =?us-ascii?Q?cY/lKIBqGh7hJ8VmjVbFZweaDZO/QKngnHEUgUvawPL4LDyhvlyELo7d2uwD?=
 =?us-ascii?Q?Vo1TgkdK8M6mmAn6pec752axbNbYENj9LIypn6sx+HYM7AHdErw60YrYQRrH?=
 =?us-ascii?Q?5Mptdbb8ZmG1Yzy5bjFbFx1mojU6zH6HpnbpCU7ApE3CbT2OPMJH/2vRF8td?=
 =?us-ascii?Q?jVJIdPWOn4wcPgk+FDM6yjzBIpN6B7fkJ331leavkzcOT3Gzw6kOYn4BWKo4?=
 =?us-ascii?Q?pYPYIobZhI+V3d+URSduag0HFHV5cotITkR5wV/wKSR/rINDZvwW7FM/Dkfm?=
 =?us-ascii?Q?FO2/5SlQZmu+Z6O1p5GvDmoLsoKwAdRtRXYXbw3iUUbugdm53uF9PYWlwWHh?=
 =?us-ascii?Q?bYta2430tp91fPZCeNXIEyUQVEaPmc3d3zy4/tmQnhZiMHTdwOeaqJulQM8q?=
 =?us-ascii?Q?/kM1S1wx1vbwi5G7T4wjLt2H+jcVeARYqQREgzZsj0cyFYjNjT1IYQe6GAak?=
 =?us-ascii?Q?n76fAwG7tReZBxNDLj+iYOrffkEpVM1W6wAnk8mE5zVhpmqfpA64lc1TcLC3?=
 =?us-ascii?Q?ZeS9sG6ArRrqsSQNulTIuSUMW7TeDLnzWYXTg2sCGMdPfsdGtvXELy3ILfBE?=
 =?us-ascii?Q?Mp4BxYsD1WR2oo0r4wNsZrK6B8vocZSNSItOkWnuw3jTviy5pqPiE+hi5XFA?=
 =?us-ascii?Q?oKBsAchwqiLnol7fMIEoFyHrLcIMa/mRe5JxogYRCb+dqOFiEdY/gXyD3tlR?=
 =?us-ascii?Q?zY3p?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 13:10:25.6727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: c94d43db-443c-48d9-a4b2-08d8b2446eb2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YCIpbYMKOUrQpmKQ6gp1rQ5Jh1qIrR/NTyWv10CTW1CiiXklQTPpJygNfoJr4FcWEC2+6n57JG5YWC3F+jrrUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6418
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, the user does not have the information regarding how many lanes
are used when the link is up.

After adding a possibility to advertise or force a specific number of
lanes this information becomes helpful.

Expose the number of lanes in use if the information is passed from
kernel.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 netlink/settings.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/netlink/settings.c b/netlink/settings.c
index 6cb5d5b..13a080c 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -474,6 +474,15 @@ int linkmodes_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 		else
 			printf("\tSpeed: %uMb/s\n", val);
 	}
+	if (tb[ETHTOOL_A_LINKMODES_LANES]) {
+		uint32_t val = mnl_attr_get_u32(tb[ETHTOOL_A_LINKMODES_LANES]);
+
+		print_banner(nlctx);
+		if (val == 0 || val == (uint16_t)(-1) || val == (uint32_t)(-1))
+			printf("\tLanes: Unknown!\n");
+		else
+			printf("\tLanes: %u\n", val);
+	}
 	if (tb[ETHTOOL_A_LINKMODES_DUPLEX]) {
 		uint8_t val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKMODES_DUPLEX]);
 
-- 
2.26.2

