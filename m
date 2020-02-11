Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF995159C4C
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 23:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbgBKWgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 17:36:03 -0500
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:38926
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727646AbgBKWgC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 17:36:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auaHGKK0q+zdTx/nU39d1n+benG9sek8WdZwCVVUm0n8Hx0fb/2cgRAWn7uL5DT+zo8b8ky2YPS9pJpL71ic6mwbkI/2Vb2UBkA4k6RSjlvLQ718f2X8CuPuyu9B434NKMYzFFAyJzMO+B6yeZpRVh/GuOtqOcpeRm7cGAP9LvatXmaZzatRBIvqn0rkYO9P47XQeR6Td9OBhaw9AQSAsfj88OF8Kyfocu31CsURszFcO5pw1QQUs648Y93CM7zI4PhVP3ZZ+F3MS5s9ICNnzSQ+QxCV0GaJtRDjbDT0ILnAD5NxZEZUI+KcbS/M0YlFytVNLwuIaGo5ysyfIq5ZtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxX/AaGsVuf+5vsEyPJnI+1Z6D/Eh2FMtiWgWeszc/E=;
 b=UvswDn0yv3mCKilKGYS6tmQjYSCDpddkdCRmkuggWAUSQPHw3w0L1yNQ06A5i9yYm6wLtiLtDYDqB6F1raYZxFd5neLemzO7J7aiHIjcrEW2BSUbed4x1CsV2/AY+5Afa+5Jw1nzoXJcwFcX2dOJLer3ReUPdqmGidrmbtprJ4l/5cYXMMZiM3B0AJBlQoAFfCl3TlbtlEJNGg4Sjc9oV6ySxdIfnnpQV+H0thJCePS5VfJ0ETl2egdMQ/SUu5sEiRFDfEgh0PHfhUWkQa1KEw1UsbXGIlaOtcKBepM2cYPm4Ec4nAD4cMhee95xSuyvcfysvetv3sIvQajyW7386Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxX/AaGsVuf+5vsEyPJnI+1Z6D/Eh2FMtiWgWeszc/E=;
 b=qlsAel2BRgdQ6Psvnr9FKx0OXHq+GIK77eapbHtYi7RzTL043WPaZDlARhUrh0kzS+nglUCXArQd1CM3OtN0T3x1Htst1DkuagrE8ZFVBNLKgCsmJ30q8YLDgbK4cI1aRB4G96hIrV/O9J34T8dslLJzBa2j9jYwy/Jxri3vQ1w=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4383.eurprd05.prod.outlook.com (52.133.14.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Tue, 11 Feb 2020 22:35:47 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 22:35:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 05/13] net/mlx5e: Support dump callback in RX reporter
Date:   Tue, 11 Feb 2020 14:32:46 -0800
Message-Id: <20200211223254.101641-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211223254.101641-1-saeedm@mellanox.com>
References: <20200211223254.101641-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Tue, 11 Feb 2020 22:35:45 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 79007fa0-1394-45ce-0ab2-08d7af42bd17
X-MS-TrafficTypeDiagnostic: VI1PR05MB4383:|VI1PR05MB4383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB43835AD8D620707E0FB14443BE180@VI1PR05MB4383.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(189003)(199004)(110136005)(36756003)(5660300002)(478600001)(81156014)(6512007)(54906003)(1076003)(8936002)(2616005)(8676002)(81166006)(956004)(2906002)(6506007)(30864003)(316002)(4326008)(66476007)(66556008)(52116002)(107886003)(6486002)(86362001)(66946007)(16526019)(26005)(186003)(54420400002)(505234006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4383;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pAeoY0adDGwMX5ZzokXRRnemZ9lgjX6P98yf42LoRiLOYO7mJVALOF8uHL+VGCzQCUnpKJXkYs/YtBtaOBeQmyhUfr0XMj+qoE2+mQ6a6usVcDO1Szs3srBXdW1J1/H5LtsTdN5+K41cvMHgeW1BSnGsujayi0oEFcIaWXE92OMFOvqC+ZsLQgzZ0lFjeT16HjdzOGSRFI0umLiw3kAZRQZsPimnNjgPCG4Chy7+1OszZXyfFAjvasR7pP2PYDjKUcPKPoYVMU9R2NAlufvT6Q/a1Rox9PDGVURhy0fvsvSnd/dXMlPP67wU9DfWOkkKIJbnkcvSzL9M6lakBQ7jr6C9yzcGy2DS9eBCR2an2o4UgRtwxIfSKnIi1sPz0mHJjZrVOpNPiKQY1pH0fVYQY1qbN7VGo2hbvJ7QYHumBV52YhwZjy0+OWkZ+YD8u0R8oRMytTExhgcGS/YZsI0Qox8stTNrVIhcM46vaFNYpVQSda1GMY4+F3Ha63A6Lep5QkMOj17F2Z5Y0lLoX0VKKwzShCHvNncn6dgJtYpmCS52XIuIdx5IhRJUcJ5O7Fve
X-MS-Exchange-AntiSpam-MessageData: yLR5aITGgLmvJMOBoYNhjFeK8a/vFD/ZRTD8aUADHyCDvPML/y1xw6MtUo7cu5XBuBTQ5wCf3Mj60zAp8y2XO+m/IMf8YrJnJHTiHGl7lMvNmcCUUKQbn0zuViVKmMmJpJHGgO5MtG2eUQl2h9wZWQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79007fa0-1394-45ce-0ab2-08d7af42bd17
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 22:35:47.3439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tB5FTf/GHn9vAzXIi08KMnarfw+SZxE+2iJY+IgC0yLwo/cG2JYSwD18VvJffOHsYWUBnyq25OrUx37PLdHqWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add support for SQ's FW dump on RX reporter's events. Use Resource dump
API to retrieve the relevant data: RX slice, RQ dump, RX buffer and
ICOSQ dump (depends on the error). Wrap it in formatted messages and
store the binary output in devlink core.

Example:
$ devlink health dump show pci/0000:00:0b.0 reporter rx
RX Slice:
   data:
     00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
     22 01 00 00 00 00 ad de 00 00 00 00 00 00 00 00
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
     ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
     00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
     22 01 00 00 00 00 ad de 00 00 00 00 00 00 00 00
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
     ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
     00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
  RQs:
    RQ:
      rqn: 1512
      data:
        00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
        22 01 00 00 00 00 ad de 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
        22 01 00 00 00 00 ad de 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
    RQ:
      rqn: 1517
      data:
        00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
        22 01 00 00 00 00 ad de 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
        22 01 00 00 00 00 ad de 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de

$ devlink health dump show pci/0000:00:0b.0 reporter rx -jp
{
    "RX Slice": {
    	"data":[ 0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,2,1,0,0,0,0,128,0,1,0,0,0,0,173,222]
    },
    "RQs": [ {
            "RQ": {
                "index": 1512,
                "data": [ 0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,2,1,0,0,0,0,128,0,1,0,0,0,0,173,222]
            }
        },{
            "RQ": {
                "index": 1517,
                "data": [ 0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,2,1,0,0,0,0,128,0,1,0,0,0,0,173]
            }
        } ]
}

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en/reporter_rx.c       | 183 ++++++++++++++++++
 1 file changed, 183 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index cfa6941fca6b..9599fdd620a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -330,6 +330,185 @@ static int mlx5e_rx_reporter_diagnose(struct devlink_health_reporter *reporter,
 	return err;
 }
 
+static int mlx5e_rx_reporter_dump_icosq(struct mlx5e_priv *priv, struct devlink_fmsg *fmsg,
+					void *ctx)
+{
+	struct mlx5e_txqsq *icosq = ctx;
+	struct mlx5_rsc_key key = {};
+	int err;
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		return 0;
+
+	err = mlx5e_reporter_named_obj_nest_start(fmsg, "SX Slice");
+	if (err)
+		return err;
+
+	key.size = PAGE_SIZE;
+	key.rsc = MLX5_SGMT_TYPE_SX_SLICE_ALL;
+	err = mlx5e_health_rsc_fmsg_dump(priv, &key, fmsg);
+	if (err)
+		return err;
+
+	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err = mlx5e_reporter_named_obj_nest_start(fmsg, "ICOSQ");
+	if (err)
+		return err;
+
+	err = mlx5e_reporter_named_obj_nest_start(fmsg, "QPC");
+	if (err)
+		return err;
+
+	key.rsc = MLX5_SGMT_TYPE_FULL_QPC;
+	key.index1 = icosq->sqn;
+	key.num_of_obj1 = 1;
+
+	err = mlx5e_health_rsc_fmsg_dump(priv, &key, fmsg);
+	if (err)
+		return err;
+
+	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err = mlx5e_reporter_named_obj_nest_start(fmsg, "send_buff");
+	if (err)
+		return err;
+
+	key.rsc = MLX5_SGMT_TYPE_SND_BUFF;
+	key.num_of_obj2 = MLX5_RSC_DUMP_ALL;
+
+	err = mlx5e_health_rsc_fmsg_dump(priv, &key, fmsg);
+	if (err)
+		return err;
+
+	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return mlx5e_reporter_named_obj_nest_end(fmsg);
+}
+
+static int mlx5e_rx_reporter_dump_rq(struct mlx5e_priv *priv, struct devlink_fmsg *fmsg,
+				     void *ctx)
+{
+	struct mlx5_rsc_key key = {};
+	struct mlx5e_rq *rq = ctx;
+	int err;
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		return 0;
+
+	err = mlx5e_reporter_named_obj_nest_start(fmsg, "RX Slice");
+	if (err)
+		return err;
+
+	key.size = PAGE_SIZE;
+	key.rsc = MLX5_SGMT_TYPE_RX_SLICE_ALL;
+	err = mlx5e_health_rsc_fmsg_dump(priv, &key, fmsg);
+	if (err)
+		return err;
+
+	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err = mlx5e_reporter_named_obj_nest_start(fmsg, "RQ");
+	if (err)
+		return err;
+
+	err = mlx5e_reporter_named_obj_nest_start(fmsg, "QPC");
+	if (err)
+		return err;
+
+	key.rsc = MLX5_SGMT_TYPE_FULL_QPC;
+	key.index1 = rq->rqn;
+	key.num_of_obj1 = 1;
+
+	err = mlx5e_health_rsc_fmsg_dump(priv, &key, fmsg);
+	if (err)
+		return err;
+
+	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err = mlx5e_reporter_named_obj_nest_start(fmsg, "receive_buff");
+	if (err)
+		return err;
+
+	key.rsc = MLX5_SGMT_TYPE_RCV_BUFF;
+	key.num_of_obj2 = MLX5_RSC_DUMP_ALL;
+	err = mlx5e_health_rsc_fmsg_dump(priv, &key, fmsg);
+	if (err)
+		return err;
+
+	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return mlx5e_reporter_named_obj_nest_end(fmsg);
+}
+
+static int mlx5e_rx_reporter_dump_all_rqs(struct mlx5e_priv *priv,
+					  struct devlink_fmsg *fmsg)
+{
+	struct mlx5_rsc_key key = {};
+	int i, err;
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		return 0;
+
+	err = mlx5e_reporter_named_obj_nest_start(fmsg, "RX Slice");
+	if (err)
+		return err;
+
+	key.size = PAGE_SIZE;
+	key.rsc = MLX5_SGMT_TYPE_RX_SLICE_ALL;
+	err = mlx5e_health_rsc_fmsg_dump(priv, &key, fmsg);
+	if (err)
+		return err;
+
+	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "RQs");
+	if (err)
+		return err;
+
+	for (i = 0; i < priv->channels.num; i++) {
+		struct mlx5e_rq *rq = &priv->channels.c[i]->rq;
+
+		err = mlx5e_health_queue_dump(priv, fmsg, rq->rqn, "RQ");
+		if (err)
+			return err;
+	}
+
+	return devlink_fmsg_arr_pair_nest_end(fmsg);
+}
+
+static int mlx5e_rx_reporter_dump_from_ctx(struct mlx5e_priv *priv,
+					   struct mlx5e_err_ctx *err_ctx,
+					   struct devlink_fmsg *fmsg)
+{
+	return err_ctx->dump(priv, fmsg, err_ctx->ctx);
+}
+
+static int mlx5e_rx_reporter_dump(struct devlink_health_reporter *reporter,
+				  struct devlink_fmsg *fmsg, void *context,
+				  struct netlink_ext_ack *extack)
+{
+	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
+	struct mlx5e_err_ctx *err_ctx = context;
+
+	return err_ctx ? mlx5e_rx_reporter_dump_from_ctx(priv, err_ctx, fmsg) :
+			 mlx5e_rx_reporter_dump_all_rqs(priv, fmsg);
+}
+
 void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
 {
 	struct mlx5e_icosq *icosq = &rq->channel->icosq;
@@ -339,6 +518,7 @@ void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
 
 	err_ctx.ctx = rq;
 	err_ctx.recover = mlx5e_rx_reporter_timeout_recover;
+	err_ctx.dump = mlx5e_rx_reporter_dump_rq;
 	sprintf(err_str, "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x%x\n",
 		icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
 
@@ -353,6 +533,7 @@ void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq)
 
 	err_ctx.ctx = rq;
 	err_ctx.recover = mlx5e_rx_reporter_err_rq_cqe_recover;
+	err_ctx.dump = mlx5e_rx_reporter_dump_rq;
 	sprintf(err_str, "ERR CQE on RQ: 0x%x", rq->rqn);
 
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
@@ -366,6 +547,7 @@ void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq)
 
 	err_ctx.ctx = icosq;
 	err_ctx.recover = mlx5e_rx_reporter_err_icosq_cqe_recover;
+	err_ctx.dump = mlx5e_rx_reporter_dump_icosq;
 	sprintf(err_str, "ERR CQE on ICOSQ: 0x%x", icosq->sqn);
 
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
@@ -375,6 +557,7 @@ static const struct devlink_health_reporter_ops mlx5_rx_reporter_ops = {
 	.name = "rx",
 	.recover = mlx5e_rx_reporter_recover,
 	.diagnose = mlx5e_rx_reporter_diagnose,
+	.dump = mlx5e_rx_reporter_dump,
 };
 
 #define MLX5E_REPORTER_RX_GRACEFUL_PERIOD 500
-- 
2.24.1

