Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A580411515A
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 14:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbfLFNvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 08:51:10 -0500
Received: from mail-eopbgr40079.outbound.protection.outlook.com ([40.107.4.79]:42670
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726171AbfLFNvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Dec 2019 08:51:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHg1iTcJ8hE8yVFdUaum05CarMqVazuUuyMTPej+1DK0c5mBsCNcGrs8zJt2Vz3FJcG6dxxrOWp4UqX400kuSf2u6onCzTiAwnTob5NzqXKAswzdi9tXahFPyS/5S9zdxNhTZhtSXpAain0MUvNJO+hCwilPOhwF50qQkUaQVrjMCLMbSg9LHBvfeqEumkp75WT/gnUAWveifpfeVXWwj16vjTC5+5Fmb4yTzGljIUtZwmjnJRfnNdWEaMC727Hgqpf5Zr79DfvAqzzfD+6EC59qiG/pQglFbWtEe8VPvExjaOVJ2wzkVIKfjOd6WqV6DseO4S0ev9nKzOlnBmaiMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ni6/r3I/kYeJ1xZrE1f8I7dDQetDE0sXfLslT+l5RPo=;
 b=hzOjsy2VFPcQHV4I/5j8Rw6u01qf7DTnMSX1bg1jlWYMuNgilT4msbRtxVa2qIanbbeFTGL6qVKmRXUEgeYp9IxXcGMVA7dF1jvY4HvxLzG0IbPQeEPUFOh6/CB7TdqS0OhfMyaumd1JO3olX4aSuoe+h2M3X25hkPUIpHimAYxoldwTnD6OVvxhr5s/F4a6oEuvDwjiREpJz8uVNWBfuyA0Bbu7x8kjeoMKdFBvehuj1BhaPrh1iM/lGsC3v1GlkIM3/UgMeOYFXhRQWHRnOSpDp6MfsZb2qnJBAqG8cU7SwCW2S3mdFO/3FAjgw7tyuDHEa4q8XUcrmvT13CEdDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ni6/r3I/kYeJ1xZrE1f8I7dDQetDE0sXfLslT+l5RPo=;
 b=dmQURtLhMbeu29rAO+pplnxJZQDOlg6/FFrj20jH0zk5dLY59rQKvQZAbGkD8TcmTP+T8eBbo3XATduzQvz1bUs3uS1HW8M8RKZerOhV3NxS+9zmE8J+bqZa/3QffkjIzyRnblNpgkcxXU31RVnGeCIRpAfVuzAo+cWrVwT3YOc=
Received: from DBBPR05MB6522.eurprd05.prod.outlook.com (20.179.40.143) by
 DBBPR05MB6348.eurprd05.prod.outlook.com (20.179.44.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Fri, 6 Dec 2019 13:51:06 +0000
Received: from DBBPR05MB6522.eurprd05.prod.outlook.com
 ([fe80::15f9:a1bb:26aa:6260]) by DBBPR05MB6522.eurprd05.prod.outlook.com
 ([fe80::15f9:a1bb:26aa:6260%7]) with mapi id 15.20.2516.017; Fri, 6 Dec 2019
 13:51:06 +0000
From:   Vladyslav Tarasiuk <vladyslavt@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Subject: [PATCH] mqprio: Fix out-of-bounds access in mqprio_dump
Thread-Topic: [PATCH] mqprio: Fix out-of-bounds access in mqprio_dump
Thread-Index: AQHVrDw0nzgUP6McokGfVewmJvt9ZA==
Date:   Fri, 6 Dec 2019 13:51:05 +0000
Message-ID: <20191206134905.2495-1-vladyslavt@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR07CA0126.eurprd07.prod.outlook.com
 (2603:10a6:207:8::12) To DBBPR05MB6522.eurprd05.prod.outlook.com
 (2603:10a6:10:c2::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladyslavt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3ad18002-0666-4374-1ab7-08d77a535711
x-ms-traffictypediagnostic: DBBPR05MB6348:|DBBPR05MB6348:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR05MB63481844D83112D0A5CBE7F4BF5F0@DBBPR05MB6348.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0243E5FD68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(189003)(199004)(66446008)(66556008)(66476007)(66946007)(52116002)(64756008)(2616005)(107886003)(99286004)(54906003)(5660300002)(8676002)(4326008)(316002)(2906002)(6916009)(26005)(478600001)(1730700003)(102836004)(81166006)(81156014)(6506007)(305945005)(186003)(6512007)(6486002)(50226002)(71200400001)(5640700003)(1076003)(36756003)(8936002)(71190400001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6348;H:DBBPR05MB6522.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xEGvRN+dRjVMBxqM24pnEsggqDO2ATeLhcDUmnpe6fg0CTuehwQN/nicaQZwQ/ty7C51vXR8Te8fOgMgadMumXJGfTSujWD6zD77MAD6NFIXXVHQehEaC09BuX0tjLLlW+MdG9ltnXVRKtuphvu1l3A8+ZXO0wvwxAB6BsOBS418npWMleexCPcRzSURot/UQ+9+QTUqrl0CN+ikQPWO/bNhEQelpVC3PoNJzWcpQYkj9DSsUjwwVGce/VF0eQm2duGVOyVSRVWm/1CQll8xJxmk4WiBa3y1R2vX9qyCQm7OUS50rlluIbJa1Moepyk6vrRjHDxqaaEQvqDXFYCDEpStBjChO/2DHjhtAdlOUAowzTwsBK0Wog9KmWsTj/UxLY/tK+gff50JmvxHch0C3C/SarAD21ikG2XmHbfDvXjOsVkdY0jnduZW/cxdy7FU
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ad18002-0666-4374-1ab7-08d77a535711
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2019 13:51:06.0036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jsob4NxqgET0DsU1js5rjwNqdK64KiEMAXGInaLdwQRsKzhPVRc3Gl29Zz1EhbGfS9lJEHkxjVYqnDkR+m/tOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6348
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When user runs a command like
tc qdisc add dev eth1 root mqprio
KASAN stack-out-of-bounds warning is emitted.
Currently, NLA_ALIGN macro used in mqprio_dump provides too large
buffer size as argument for nla_put and memcpy down the call stack.
The flow looks like this:
1. nla_put expects exact object size as an argument;
2. Later it provides this size to memcpy;
3. To calculate correct padding for SKB, nla_put applies NLA_ALIGN
   macro itself.

Therefore, NLA_ALIGN should not be applied to the nla_put parameter.
Otherwise it will lead to out-of-bounds memory access in memcpy.

Fixes: 4e8b86c06269 ("mqprio: Introduce new hardware offload mode and shape=
r in mqprio")
Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
---
 net/sched/sch_mqprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 46980b8d66c5..b137c3afd1e7 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -433,7 +433,7 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buf=
f *skb)
 		opt.offset[tc] =3D dev->tc_to_txq[tc].offset;
 	}
=20
-	if (nla_put(skb, TCA_OPTIONS, NLA_ALIGN(sizeof(opt)), &opt))
+	if (nla_put(skb, TCA_OPTIONS, sizeof(opt), &opt))
 		goto nla_put_failure;
=20
 	if ((priv->flags & TC_MQPRIO_F_MODE) &&
--=20
2.17.1

