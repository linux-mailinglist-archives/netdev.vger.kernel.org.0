Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6C01938BD
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgCZGis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:38:48 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:8291
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727683AbgCZGir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:38:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UDbIs4iWQhLvQnelTiew/H4AV4XRaA1N8WqsWjWDUqxQw2iPtJmsJOHfuYQzADHw5VdmV3SnBzcXbDpUHcqB1Kua7ocORP3sgwIhczvTdg80THbpJRu+0ZfGzAIA15UMdLAfMdNRygE9pGs7HWUXp32VqQOEiQ536zVVTDtd4jsxxIuO8UHkpH0eI1olcTqrHSgGpaznQi0UyhEacA5xPi1kmXnvTNv4U/mKSRp2uGAfmzHoEyvsVN2nLa2tniXOPvW3YVHLq5R/5gFAFQ7SdSJBWIeyv4VTuYqWYsyyd/UaQmIZJDKWaHr3eQK2r6jMgDR36zS3ZNtMKP5hn072tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/eYuAuQvb0z2T/l9iYZl06nFeeTjsjek/wezmh7KWjk=;
 b=dUzARtegJUOnfs1+Sej6R2icbKvr/f7/drcDnfIU84edTcv3Lhv0/slZlKOGcqeag8TPdsMO13Sy5v6IBRUbKanRNYGmEsFPX01m25BxYnlL0/UVha3M1LM9mOKpJCKwCIF7MvKAYThDjuJW/4fWZLjaqrSrRMKvyY6ostd0ytVlPwkvRBj41R+Oqb9IaMPx4Ex6v45UWuSY02tSsRiWBSK3Upw71e/YjdIg6oiih4GXDEui04hEF44Xr/YmAnOON+i1rM5i1Ko3OhZgEfVlWxj728nqOAQ1/vC6dZOyKnCHXhunRHeE9Sv1dhGy3rzJSeVHXqzs+1UBkBVG4iXPzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/eYuAuQvb0z2T/l9iYZl06nFeeTjsjek/wezmh7KWjk=;
 b=bz+XlOTXyjLhmoD/ENok9IPE88oCzvrDM4TPoZ3WKFwQ+6l9nma6DXDUwVovWyiYQPCQc0Rjv5Q+KV8mAqfkNc+rXk1f6xe3RsDMbfrJZvpmM0YxRXJs0Qlg/2gM8pukhsN4tr9qVBVk+oznDxJPSiQBEz3kyInAHFPwJ3ziwRE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:38:41 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:38:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/16] net/mlx5: E-Switch, free flow_group_in after creating the restore table
Date:   Wed, 25 Mar 2020 23:37:58 -0700
Message-Id: <20200326063809.139919-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326063809.139919-1-saeedm@mellanox.com>
References: <20200326063809.139919-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::33) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:38:39 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 03048f4b-2611-49c7-cc78-08d7d1505289
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6479DBA658B0BDBCD2BBD139BECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(36756003)(4744005)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(6666004)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qG6W4h9XJI6+wtj2S6zUJQCpd6E3ZwT+8i4rR69n3UbfHCjhGmo80Lft+mrD8kxJccjFrK5coj8HlyzekCXf817TqMrQrJNQdU//E66jNgfuAzLlq+JpYUYI13/76qh7v6etoxAttCYZNIHzWXgjHx2yBRJyqWzaqsMNJGkNm6EOHNAColKbiNQu3+HFejk5IQ5Usk3yWTW1jkBzSvj1W3ofMChR7i2ZkvjnNOwaNUSGg9tIq5oz2ZakTLljdg8V74rvGF5docnZUp43wdyQieXdOdRCoDKUUkcVHWTDeifnL4QE+Xk+sPRY6p/WTepydeEhgvZ+hYionMgIaqv20X3uuNGU+rqAFX6pofW0fSctPgXzEYo/LHA5fFiI+QrJw9HWAtOH6+BmsmxMR/4WC9OoCZ1CwjqMDblyzjTJRc8ff9BZcwXql7mT7xNqYVN1fzecRiKywgEpnvKmc0N+nEo40un5x92epyj9Ay3hRZP1Kwwg9x0Odp8iaoKsu+tJ
X-MS-Exchange-AntiSpam-MessageData: v60jNelzRhBIkzDraaQ3ANh9zUT49BJFNJKm3v5v7uY0Zv550jPlpMGUh1CTZqPh9nhpxQgdsXaZU5kAz3IZD51NQuX1mdvbcZWa5ULk5AaF23x/lzS2TaAGwndMZoZVtrX7r4iz/uXf+qdQ7BVpiA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03048f4b-2611-49c7-cc78-08d7d1505289
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:38:41.2153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 30fXxYifbuvu7QXQUec3YztiNC8Nple9V0zT5eWtu0O9PLcaaylXgtGd1G5QCQ5VobynpxuM7yEQFWfF1BEVBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

We allocate a temporary memory but forget to free it.

Fixes: 11b717d61526 ("net/mlx5: E-Switch, Get reg_c0 value on CQE")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index ca6ac3876a1f..088fb51123e2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1566,6 +1566,8 @@ static int esw_create_restore_table(struct mlx5_eswitch *esw)
 	esw->offloads.restore_group = g;
 	esw->offloads.restore_copy_hdr_id = mod_hdr;
 
+	kvfree(flow_group_in);
+
 	return 0;
 
 err_mod_hdr:
-- 
2.25.1

