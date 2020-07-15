Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D012220403
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 06:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgGOE3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 00:29:15 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:25072
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725772AbgGOE3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 00:29:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfhDeWg8WWPfPvdGXKFbBgTBVcTvOgl0SuveObdRrNJ0qqPTQN7cVn91OMFfIgYBe1ODITKavugo1h7bwldaQGZHiKnsAs+K1Sv/0ZKtp3Km1Qvzt3FclWYnjzZSsZi096kZYu2ojkiiK7Wu8MM6FS2KldomeWjJaLnXtfSlRyJxXOYcgXK/VIjj+IqrcEHzizwXzC9L6avFfJWII64Z4LPbbH8TY092B1gr0snbCARGDjx3dwoWLs8ZyJ3rgX+AucKy8hWZcly6EYbMXOpaG4HRENSdmDf0PdFce+fCLaTNc072Yoxtd8az+EBUo9bk/0e0GHbCa0ZYZ2fbRgZbwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4ZUAV7qLhKhMED9qBPXQCPLhu2ii3SvOi8rDuDuGAY=;
 b=CnfftTeli4QleG7gXYVOXHbOcKA0ZMfLyvsiqN+VJZhmtTF+pB0275whIMHjTzVZ5GX1jp3+wkHR5OsiujjcjWW0P8/e6owxn2Wa+8dqSDOxI8++AzEaxplJGkhVoqVfRnC3vbOmaR0dtovuGGeYU5s/vUbkmbFTuqDjrHbF9TZ2FDvo+yXQvRGYP/+3OptdHxXc5zEKLy1IZ/QoUrci3LE1OBOVbH+LICKo8WFZw2fX0Qkne2+P7/y5oVWzdkJoBzhNQ6Xc10mrhtout2q/V/PP3i9cZRacZt/HU6r4PsDOVgsk5tTkkBZD8FSi0eCQO2Ja/uNCL3BmIj9n3+YqqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4ZUAV7qLhKhMED9qBPXQCPLhu2ii3SvOi8rDuDuGAY=;
 b=W8staGxFTHGzo5OkLAmPaPI72TGWoNqGFMUZ7oBEzkYg5uF+03cPjkW3MrQ4zUXKyOReMGv4HLVRbdyGXuDzmnRFM/9uy4w870h4eDD00kih6iUBQa2gGRQM9aNpdVDK3HPYicqNgzY3sXI5xXbaKhQucVfINU2r3WiWHYWnfHs=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6655.eurprd05.prod.outlook.com (2603:10a6:800:131::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Wed, 15 Jul
 2020 04:29:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 04:29:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 4/4] net/mlx5: Enable count action for rules with allow action
Date:   Tue, 14 Jul 2020 21:28:35 -0700
Message-Id: <20200715042835.32851-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715042835.32851-1-saeedm@mellanox.com>
References: <20200715042835.32851-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0096.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0096.namprd07.prod.outlook.com (2603:10b6:a03:12b::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Wed, 15 Jul 2020 04:29:03 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 45de5cc4-cf44-4f4a-c472-08d828779bd1
X-MS-TrafficTypeDiagnostic: VI1PR05MB6655:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6655C757F4679C18DF222019BE7E0@VI1PR05MB6655.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AeAXfAhgPksaiet6tBJkJCEW9+AXJw3whvH//9loR9e3L1habMT/6RKxGR5MJpIelYl6BdPPHwhuF8bHaQ9h5OtK/gVsB2mdE0I0XW0EhSDX+nyFNSzRAGm9kvQMbMAPVpKP/hIIR/eJocMUF+eXTV65G1K5EeBRy4EifpODBu8KyUGrbbUvqfbq6eP+NtRYblOaNChaqfMn1IytZpM48DekyFaRfrfcZGHa9rCGRRhCXXuVQUge+Czv1mg8TTIYPyGfYS7o2YK20TijgFHGqfNGCOT37SVYpDmy5b12WD8D4e2UZIcD8BpP3Rba2+9ZetNnQoqBEmMJihRaNXbAzzqBqW9/qi04MbAGgAft2h/gOttU5+umT6SNjhzQDAEO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(6636002)(6512007)(2906002)(107886003)(1076003)(6506007)(8936002)(6486002)(4744005)(478600001)(52116002)(86362001)(110136005)(8676002)(5660300002)(6666004)(16526019)(956004)(66946007)(66476007)(316002)(36756003)(26005)(66556008)(450100002)(4326008)(54906003)(186003)(2616005)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Tz9WjFMeXLt2EIQPitfa4mlHmJIr2w0gdCu/fKoOWIFV2Czf7P/iwC4mOnwOMSZzL41Jn5ARPuVFYj2zvJmEkWRmeH5fjm0qjZo/h3STInWjFhZdBz3ZRTjs6OoOWu3sDuEY4fKeAVjNv42YJZL4W/9JHX/68kXkWq7T5eO50dXoLKqOYQFEvKhrpoctZWYkINdjImaQy37FZfmRPMM7YHQBcYy6q/DAQW6cpwU9rnGYTFz+kp1AD9AWg4rJpMqLOj5NLye9xknbTPFFG3KwxJG26S72ErMzg+cwHV6PSlovHqaE96iZn6J63HtbJfqx1FsEppOYxSHmzmJJA2tyE4FFQaAoy87IoO+dE4JkF2EHtEvrxKrZABNkJh2QibC027nlzv6ue3JIjTMtuD1c9sTA9OxKWr7R5LvMgQ/3BK0oyAvXRA/1QzoqQTTYhkItNFg/nqgzyTa4ZX/cX45OxHqFvoqiZRIaLz6zjeCN1GI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45de5cc4-cf44-4f4a-c472-08d828779bd1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 04:29:05.7247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qd8wXDMRBCTIZpLARN1fK/Lu5lWG0lMisW4y+DLWo1HP4W53UkZd3DKy1qpugjSV/MN1IYdcgbnlQin0MdR3aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6655
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Enable the creation of rules with allow and count actions.
This enables using counters on egress flow tables.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index e47a669839356..644fe4c2f0fa0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1598,6 +1598,7 @@ static struct mlx5_flow_handle *add_rule_fg(struct mlx5_flow_group *fg,
 static bool counter_is_valid(u32 action)
 {
 	return (action & (MLX5_FLOW_CONTEXT_ACTION_DROP |
+			  MLX5_FLOW_CONTEXT_ACTION_ALLOW |
 			  MLX5_FLOW_CONTEXT_ACTION_FWD_DEST));
 }
 
-- 
2.26.2

