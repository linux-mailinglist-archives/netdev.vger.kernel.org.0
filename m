Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5F0B1938C5
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgCZGjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:39:08 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:8291
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727798AbgCZGjI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:39:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwxCh5yecj2U1HHwt3Pu3WDH+1fh6egO1RE2JFWQcP3DVnuRnOdo/ynYmftNqaDs7aZlL81IgVf0NZctmSps2qtnOTPywueVoOPjO49Gm86eKPv9kvCmP8Gam43r+xmiTUPLKNfVSef3xf96lXXO8Q84jod+KkVNOJSLqJ9f6QCoARg8zhT3+ZXD5Bx1jKXxx7uKxjuzkS+UUJZU9nFyfY3KzyOfZLm3w90rhNzu3ORs7dISSTZNgsIy4xjynXsmWiB1wVYnCw8EWOoOgVtfRhE1HT+vcy8TtZ3jjwCHJmquNwKMYuIypOA/zmCtDJIPuf03+rpIo8/u7fSszahMqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dohxoXvLlzC8pv7CnYdFJ/8PTUam/8+S4yyerFT85U=;
 b=kKHY3S8E9xzEbHzehaP6xCWsC4N4S0mkvuq3GmJP45Eo01udpEXIRgWo6J1a4v5/5lDDdV/fSuVnzJCRwkWMEnFTWv6udbkYBjWhJ+YlIDqhYMJi9I6E4Pc2MqSoSCv65aIQEzcfSn4utGCmKKxGoXt2Yp/b/IMjDAh/iZm4ZJcMSlr0jRv6hHkrukkitkflf4LhY/fD48hy0DCwp29LiBRmO65EzK4ULUHZmcHQBU8qZR30salwhN7+JpIDMzNN89xusJEVtSpXICINByOtsQmIHTLjxCNsF9RM0X5Xk0IuVpHBWXIoy9ugrI/mxT+ql/mMZKV6eBAo3chilXK4ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dohxoXvLlzC8pv7CnYdFJ/8PTUam/8+S4yyerFT85U=;
 b=EIzmgn0ARKiPNkiZ23n5S7RgvdUd/KDktDT+P/XLuiSwPXxI8zkBeouMViTnGZ/Pi3spVC3+1bfSPEZEJxlfx+FK6ddonARDuI3i+gw7yVLh72DFB+mX1CSvomXXMJb/zwhU7Da4Ahicm1UtoTFWrmo2TvJhXI3gicDjKmSivMw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:39:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:39:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/16] devlink: Rely on driver eswitch thread safety instead of devlink
Date:   Wed, 25 Mar 2020 23:38:06 -0700
Message-Id: <20200326063809.139919-14-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:39:00 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1e94b0f8-e924-4d57-29e3-08d7d1505f54
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6479DD10D8F4CD413771D0B7BECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(36756003)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e23v50j5/s/vXmXeL87DcxYIQcIo+BqfKy1KcGou3RTHNDgxAzr0zAAiAm5uQOmUstmhdNhuu8wuB0gZyYVCqDnBiNpgqhAzhRi0bUqgyVTVe6kESbwDzMeIFbmDJtvjkec0eKHnUSclPLDA0kFYXwcLFYqufKUN1jh4Ovs5gRyNsK49C+dkbCS+AJwN3mchi2zs2qfDDlOkHk4HTU2T0Fq2Ifpw4Lio85BwWy+Hf86S2sBDHn67vzXEbTW7iCSIchewGWMk4t2mfbW4TuPPIMQZqvvwknVfjN9R4adoZCCFg71ZZgf/xjKm7iN44ydqlc9ZRCBa98UFvd/qGuUu2UBKD2KMpK/x01cKoZwhGmFXj4dL9FqhjvFbPQyDpc+vtoRefqdCC/uiawBqfabLBijcG6acaD4Aru6DilQ6cBR/YiKR9fUquc5jVLE3rUI+xHRtrF9gijWHvWxLbilp1E5G3Tn4yRMzkFDZxwd/CtNUB5KN5Ion/kdAoYmWZTVZ
X-MS-Exchange-AntiSpam-MessageData: l3qZKPJElTdKXDbmS7MHYPQhqkeSJJJq9nqvgwI3XJkL4RxgGHAbhUA09dpe93E+Z6hWzxh4xfpj17bEhhMG7bKxUFyV1/lnzlu23XvARnanZoWrsrJXFklcbVK187aOPAiVOs85CppLfd3qtDTumg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e94b0f8-e924-4d57-29e3-08d7d1505f54
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:39:02.5473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iuP7rsCxjNTvFuxEGHh4XBhXAikGLSlczULmWgMoMaZ6G8/Q91uPcA7jjFmOO5Iz8DYC+fbtnSuhTZywP4Itug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

devlink_nl_cmd_eswitch_set_doit() doesn't hold devlink->lock mutex while
invoking driver callback. This is likely due to eswitch mode setting
involves adding/remove devlink ports, health reporters or
other devlink objects for a devlink device.

So it is driver responsiblity to ensure thread safe eswitch state
transition happening via either sriov legacy enablement or via devlink
eswitch set callback.

Therefore, get() callback should also be invoked without holding
devlink->lock mutex.
Vendor driver can use same internal lock which it uses during eswitch
mode set() callback.
This makes get() and set() implimentation symmetric in devlink core and
in vendor drivers.

Hence, remove holding devlink->lock mutex during eswitch get() callback.

Failing to do so results into below deadlock scenario when mlx5_core
driver is improved to handle eswitch mode set critical section invoked
by devlink and sriov sysfs interface in subsequent patch.

devlink_nl_cmd_eswitch_set_doit()
   mlx5_eswitch_mode_set()
     mutex_lock(esw->mode_lock) <- Lock A
     [...]
     register_devlink_port()
       mutex_lock(&devlink->lock); <- lock B

mutex_lock(&devlink->lock); <- lock B
devlink_nl_cmd_eswitch_get_doit()
   mlx5_eswitch_mode_get()
   mutex_lock(esw->mode_lock) <- Lock A

In subsequent patch, mlx5_core driver uses its internal lock during
get() and set() eswitch callbacks.

Other drivers have been inspected which returns either constant during
get operations or reads the value from already allocated structure.
Hence it is safe to remove the lock in get( ) callback and let vendor
driver handle it.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 net/core/devlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 73bb8fbe3393..a9036af7e002 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6187,7 +6187,8 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_eswitch_get_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
+				  DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_ESWITCH_SET,
-- 
2.25.1

