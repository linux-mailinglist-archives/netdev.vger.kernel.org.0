Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1008A3B9E0D
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 11:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhGBJYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 05:24:36 -0400
Received: from mail-mw2nam10on2090.outbound.protection.outlook.com ([40.107.94.90]:15104
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230144AbhGBJYc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 05:24:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OS94JJncvdKgrjqWSIU9Uh2waV5R4cbpFkuqURLUcS8TYRhtWdd4QeJ95RNUWwIoDNNPtZ1oFHSqouLDkvhkgUFX0zorsFOSY02oMnJ5EC4hOzq4bOA0SmL709aTXB+3LYomvPwEVMpzwbj8amlgdZNzK80uaZGKslIJmEsXP0FtN9bhVh36MJ33GYBNNVzR6cW9grHwI89jprt6whLrWhTLNt4MgSXYQeturhjJJUtNiwnGAPamU0lEAINmSdyGq2HDTkSULGa7418gERfkNv8H/ThKefAmQffGnKSO5wHZo+SsBPwxxSvywfVcU2XIOkOMvdVWWl/AXte203vl/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mATodt02KL68nO/auP2ERKD88JslFSZZQ9MCkUeElSM=;
 b=Zn3bw4BgbxeTzbkTmuEay1mnTaM8G4sSFqIdtKP542GuhJND/MCmIvH17YMb1vy7MdGxZG+wda4dRMN1dYL14uH7Eo+RYy6Ds2X8GUkRYoo6jBxSkjAuC2AAVNx5i/juEbsKIIvG4cV2xBAw2laIq8bmCycIGoyRIvEOaZB+oWzSmERi+8WleXNNsU/8Xr6UsL7zO/F6fkoKebtRDWj2ZpLKAzQfpHjEMrjkDN6nDPDTOz6/16rpcQ4HXpbZVzii8d0gIc+Jlh+8ZkK8v2tDfhLV8fQGnWt0+T4qT0ew+EKnb2UeK1002sbKRwyw+6YVAXcY6Mur735WpYKxDUJG/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mATodt02KL68nO/auP2ERKD88JslFSZZQ9MCkUeElSM=;
 b=PgFLyRwOhw/8H8UyYI6nREHZmqtGB4iS3SEHdebkdkHvh5IHsMca6u6v2y/i2yRUB/jDwFjaIDfKy9XnlJFvlvmv/KDqvT6gO9PfGmxGyMer3c96N9xOQliq/ia7IU6jsDSEMXWS+X+qNCZ3FY1JBXIJWmd4kzjoik04/Ac7qtE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4987.namprd13.prod.outlook.com (2603:10b6:510:75::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.12; Fri, 2 Jul
 2021 09:21:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4308.012; Fri, 2 Jul 2021
 09:21:59 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net 0/2] small tc conntrack fixes
Date:   Fri,  2 Jul 2021 11:21:37 +0200
Message-Id: <20210702092139.25662-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0112.eurprd07.prod.outlook.com
 (2603:10a6:207:7::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM3PR07CA0112.eurprd07.prod.outlook.com (2603:10a6:207:7::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Fri, 2 Jul 2021 09:21:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f05c54b7-87ef-48a9-fcbb-08d93d3ad814
X-MS-TrafficTypeDiagnostic: PH0PR13MB4987:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB498797F5632DCEDAF8FADA71E81F9@PH0PR13MB4987.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1VD+arvS9r6GltUQU7D6n8aM6pjnjJRhlbhBUaDx+fRQPd3V1uXWln+2kL6BwdVFj+/4vIyngPBUPi8iAl6x9DJ6rZcTQyCPFPDYzVhJIt6TNXysT63K0DuEVXVXyl+AoU7OM/16xz/VTWYzlWTA8pkYSt503tbMoGJl1pdoKxplmk9k3SnkyfLVJ0vIK2O9nWMXDlUYSpmatNOZJFp2hzo9+h0653yJbWVJgNGxLTRn5SvF6miKqblfxjkPQPhrajghsiiyJp7CBPqVx/wSGd9j03OMKnZsRBs4+9+Zxtv9ZnkUcUIgFuf3ywxr7DKYns6JTw/N5NVPjJwjf5OBfZR6eXUQIWxkT/RKhEtr58ZAHeh3cQUo3ElWtOvKH0dGeaB/AL2qdRAC/hj46PPhG9EWY4YfxtjMAoGqvSUFF3z8JHU0N/upl57JkydtemuHqucuERlZYudDlpoi10+rub+si1tbISsnMzsgvO4uAmG73QTYo+7vWy+4FBZf8Z2UIQ/NUC6Xe9f6kvtfy/VwBmpJoY9X3EyMOS26RtvbdzDLKM/djQ5jN4TzDpi8IzRZfNyJrlikQ69EC8mhHKkqpfUrQECutnHEwmjQXx9I/djIne4wrIiCmh1DTHu5OKaKmOWYYa7X7e0mnGaLDjF0eA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(39830400003)(136003)(366004)(478600001)(36756003)(6666004)(38100700002)(54906003)(2616005)(110136005)(6506007)(2906002)(44832011)(52116002)(316002)(6512007)(107886003)(66476007)(66946007)(6486002)(186003)(4326008)(8936002)(8676002)(66556008)(4744005)(5660300002)(83380400001)(1076003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tZd7JNhgU4WG38yxzU05E9uYZzk9qw79OVDpZzJphDABU1Iklcc58h82NCtY?=
 =?us-ascii?Q?CZIYN4gRCZK9888BVmRHYBA/45Odkekj8Edon04yH/T4y4bPtaGlMccPGVdh?=
 =?us-ascii?Q?XGCEHENsBAX1LnAHvsY6ONiOAY2qe/p3AtJCmJ8WXoI9BaruA5a2lPpDD/pk?=
 =?us-ascii?Q?Gm2V7k1G5ABvMgyj+OebMezI0RJSiV2g2pdki6cag0m/UR0hApFscyj3lWZ7?=
 =?us-ascii?Q?eAKzVLPHjC4LU6GDS6P/jALRTOcbwLBXQru9Q62A5NejS4Cxv+EU++6mTf/a?=
 =?us-ascii?Q?5+KyzNy+wqlcdz4H9qbPs5wJw8k+y7HYQv6piJBwVXnPz61C930zeTaSt1V3?=
 =?us-ascii?Q?FyfDO0GHIjTWcFflORedCpe9JcVdQo8REZPhL7xfeJ8pW81HrEz6VZnYz6bE?=
 =?us-ascii?Q?K0qLLSUCIJYaZO5i+8EgbeR6cH10Vt2/FQ8fIuUvAAcwtcc1gQVqGCJf4cG0?=
 =?us-ascii?Q?lZ+pLuzDTvLvww0x/6BcBcDQYwgdounDwliqg0gqQeX3KucCitqnuQFRU3YU?=
 =?us-ascii?Q?St49DzLE6Mcp+Ne1o94rDHNkHD3okgsQuGgQkHuLY6hlQSxgD00n4TT5IxvT?=
 =?us-ascii?Q?Yy9iXotJ1fRNlpApaVQB4YVzSuTS/DPng+dmhfLM0Qjhl4eGNQJJKz9smnHI?=
 =?us-ascii?Q?7aIcuuGX8NRHnVWg/4LTl95OB2BzUqF27tVTi0utygZsnOQPf0jD1lMCIKiX?=
 =?us-ascii?Q?yJ31WWUeFRX8OdaPvBsPKLMNAHcztGPCWPh9VNlm6vDDJ8pY2xhskzKMWCB0?=
 =?us-ascii?Q?tLYhM55ODKDZOPSe/3Lg1P7aRRzfbSFtJu78wwe1++IozUYmSSN4IZ9IOCjX?=
 =?us-ascii?Q?uZEWYAx1VFvi+TWJiFEqRH67QhCe6RcKezICRhDrU0oMV8jDJzLhr3IDFcDm?=
 =?us-ascii?Q?RMtgy95zcVBO6B6ZBpHCn12mErPlO8SiyK0p0I0qtSVulvkRigGtUyMURO4O?=
 =?us-ascii?Q?uwkCKyHKB/Gh5qQSkt1umPG8mmPBDUQ87RPcyqz2KsUUAiBDfPhZKYjNlPBR?=
 =?us-ascii?Q?aNjY8+zv4U/V+mhVst7Tvvu46imjO3NvFvKy25S3z6uBAuFZ3HHcLLmwPbIj?=
 =?us-ascii?Q?+n74+aGeNvA5cawddsmLV33rA8p8PqVb7KSVdinDp5fcx4Q+1cFk3hhaYk94?=
 =?us-ascii?Q?7k182/Z5txBtEfztv8JkjohXX1YMJWdzpiG37T9/AgWpvhA8/WMK5Sl1LoxH?=
 =?us-ascii?Q?tMU5zSZSjg0uXGyauNkM/iU3gaxMWayf+kVdTZV1yF9wZ92hym25Z7Qc50+r?=
 =?us-ascii?Q?+THhMIRCzYr8gxljAOH8I/2LmFnqdUJoiT/rdqM8vAYjGiec8ElnMMwjFAr3?=
 =?us-ascii?Q?QAv/F0zUyXN+AXVekXUE3SZu8QQxAv0P7JCDhtxqe89Q0gr9K315Z0fFR4v0?=
 =?us-ascii?Q?ODtsB1CkY9yGUFskAtUhq3U1SYEH?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f05c54b7-87ef-48a9-fcbb-08d93d3ad814
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2021 09:21:59.4895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v1/iXZql8Kc6QvB/iyyUS3eU1J7/qI2PyLooKsgAjIDPjGqxGezrFAulEHuoEmhW7BGQsXPX+eyNq1dvWM8pqoKIDfstAKt9+y8MPlZsYI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4987
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Louis Peens says:

The first patch makes sure that any callbacks registered to
the ct->nf_tables table are cleaned up before freeing.

The second patch removes what was effectively a workaround
in the nfp driver because of the missing cleanup in patch 1.

Louis Peens (2):
  net/sched: act_ct: remove and free nf_table callbacks
  nfp: flower-ct: remove callback delete deadlock

 .../net/ethernet/netronome/nfp/flower/conntrack.c   | 13 -------------
 net/sched/act_ct.c                                  | 11 +++++++++++
 2 files changed, 11 insertions(+), 13 deletions(-)

-- 
2.20.1

