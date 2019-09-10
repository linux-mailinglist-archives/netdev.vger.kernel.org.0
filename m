Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8567AAF2AC
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 23:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfIJVqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 17:46:10 -0400
Received: from mail-eopbgr60054.outbound.protection.outlook.com ([40.107.6.54]:37381
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726208AbfIJVqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 17:46:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3cPTMfp0HqlKa5NiAQNqIJDlsfbkz7AQg0ZxwQt+pY21JKPdPQNZvXbF9OZ7dncc14tLemmhXJBqh2NItkfCUVNsV6533WujOZrPmdNUVIdJ6pKmH9Jn8Y0xWS06s8n0yT3pPlvP6F2ntf0GOTWyRZBmLlvJNMNjjxsx0AmevjxZAKqhh9LY/gbXg/fGsVUAheqzcO7n3y//nwANDxtaY9dwu6E9bLARSnRd7n/cj13F8oK1aUUB9Xp6ehw3DoSLbBxiBoYmXBnq4BO8Fzeaii6DwF9RCdk6JL6t9gGBHl4qk8ddWpnAs6iKf1MzMPOrD6L0sKpprTqHswI7owj0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXMGX4rewH6TJ98TvqGgbprZpiAPJYbHguA98Yt4lMs=;
 b=KdUCOJtBU9KX3LOTEbR2yKcotUDFADuNEIN13WRhuy/7OKgeghZAOsZFnIWkzJrfTTwWgLSLGGVnnR0K2s0klq5pOhoYB9GOVtbXuSc9fFg302BnsiudYwZ6s6bPWWekybs8ZQ0REdltaduwOhGRk5NGGZuZoU0pK8MuRA68WeHHfIPLJTxrprUrR3R/HM91evfVcGqqgW2s9ZEzAyLCoPxZZS677M3gqmnK8NrTV3lBJ03lotBx+pkdF+bFmCazT/XOBFltzu8N5txMeHz2QHpzViMzJaS/bm32XQsS1fpvdAIIiD3HmH3leZEBpzM87x+sUqGkzyFs3fOPqfD+5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXMGX4rewH6TJ98TvqGgbprZpiAPJYbHguA98Yt4lMs=;
 b=RD5zL2uL5u+eP1+A0XM/UzZxmZEe4zqlF7+w9KEPhtZ44EFb1fehjtEf/6vwnC8x7uUGFTQMqRe4vF0NnBXTEDy9G58PT9B06Bl/A/oxDNb1ekElsUGM9Ac0etZtXoqjkaSpnlSxzC4mOHFRcjQ5pvmuR41JU72+2W/Wsf791Fo=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2598.eurprd05.prod.outlook.com (10.168.77.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Tue, 10 Sep 2019 21:46:02 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43%12]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 21:46:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [net-next 3/3] net/mlx5: FWTrace, Reduce stack usage
Thread-Topic: [net-next 3/3] net/mlx5: FWTrace, Reduce stack usage
Thread-Index: AQHVaCEkm9aV8vmSSUi6ytnyjnhl8Q==
Date:   Tue, 10 Sep 2019 21:46:02 +0000
Message-ID: <20190910214542.8433-4-saeedm@mellanox.com>
References: <20190910214542.8433-1-saeedm@mellanox.com>
In-Reply-To: <20190910214542.8433-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::35) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9cc9c096-4b83-40e9-c34d-08d736384655
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2598;
x-ms-traffictypediagnostic: DB6PR0501MB2598:|DB6PR0501MB2598:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB259888ACF9CC1794C8541758BEB60@DB6PR0501MB2598.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(189003)(199004)(81166006)(102836004)(6916009)(5660300002)(8936002)(14444005)(256004)(6486002)(50226002)(76176011)(6116002)(7736002)(99286004)(14454004)(36756003)(305945005)(4326008)(52116002)(6436002)(3846002)(6506007)(386003)(8676002)(476003)(66066001)(53936002)(11346002)(6512007)(446003)(2616005)(478600001)(64756008)(81156014)(486006)(1076003)(26005)(25786009)(86362001)(66946007)(66476007)(71190400001)(316002)(66556008)(54906003)(71200400001)(2906002)(66446008)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2598;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: J/kZgUrb1rDI4iTGU9B5h58KmmDbhUKoRK2mXcq+6IoEJzCFhjq/TCZMxgMSylmsMp6eg+j1kSDl9cjVSbhHSA6iBc/hraRcH8N1DobMNhqTQ6S4h9Z91DcG74Sl/B1AbqLMSlhfqmF+a9i64nTHmrzYucpD/XwPXywCgy1XLW2RnoY09gFYOHNJ5poZ0pNKhfnNGxPsQfaarrO9Phr8629kbhPK9jpV70ZOu9NJ3jP70OAJvs81+8zRNFgJFMkw7guc6CMGgMdrT2Zffn6CHSLSWtnPRF5icYf+/bUKrFSbo4lMMYra7qOuLtTaEicnOaF7VB9VkD+twyZ5f+Jop7UJLFw2I7y4g06o1mUKufXw0q4xld+YU3M3yj4QAIVfVENV/cuMEAvSZpP9UWwnfv4Wodd5md7AtQCEbQU3NfA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cc9c096-4b83-40e9-c34d-08d736384655
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 21:46:02.6037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ejWc1sFP3VF7QiMjzhGpthh5gi4GmqMpWOSdZV3j6ju6C5cICFo/eRHK8C3+6QR0LE2R9UfWWqILIHPaUF30fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2598
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark mlx5_tracer_print_trace as noinline as the function only uses 512
bytes on the stack to avoid the following build warning:

drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c:660:13: error: sta=
ck frame size of 1032 bytes in function 'mlx5_fw_tracer_handle_traces' [-We=
rror,-Wframe-larger-than=3D]

Fixes: 70dd6fdb8987 ("net/mlx5: FW tracer, parse traces and kernel tracing =
support")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 2011eaf15cc5..94d7b69a95c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -553,9 +553,10 @@ static void mlx5_fw_tracer_save_trace(struct mlx5_fw_t=
racer *tracer,
 	mutex_unlock(&tracer->st_arr.lock);
 }
=20
-static void mlx5_tracer_print_trace(struct tracer_string_format *str_frmt,
-				    struct mlx5_core_dev *dev,
-				    u64 trace_timestamp)
+static noinline
+void mlx5_tracer_print_trace(struct tracer_string_format *str_frmt,
+			     struct mlx5_core_dev *dev,
+			     u64 trace_timestamp)
 {
 	char	tmp[512];
=20
--=20
2.21.0

