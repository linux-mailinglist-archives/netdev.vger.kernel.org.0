Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFE8103AAA
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbfKTNF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:05:27 -0500
Received: from mail-eopbgr50050.outbound.protection.outlook.com ([40.107.5.50]:61262
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727794AbfKTNFX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 08:05:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z1pNvNXLFtPLQdR0JM+BmaWk8rg00aY+WPZ1J3iaGXVYM9AXWJiCnupDHBeNoyJkb/UaABuOjIKMOzZhcg62iA+hJw0b5Ls0HhIwowNhYOgMgeBDTUbsAEVz8QE2zr1hlyJIul2JbD7qcc5CjoWp5p+BR1xRhKS2aG+v4oDizuqU4KFkz0S5cqEZIOFSUyazqdaAtbIQoh3RuXdn1hGiZrJEQ2UXawbNyeD3aAs4vfAZHUt1miLY/rYqtBCqE81zdCusGYKjWZxZRQRyLGt+mGZVg67fT+W3X+zpva5vg6YGrCsZKQgB/Me211RXFQHRkH97MSud/Co1D2iLP3Brhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FvqzyUrexlRoMog7YZGIIcrktmfQOyD+g3rSkwfUO3w=;
 b=RhXLpTkFApHDAdDWQk9kQJ0tPxqXbstlNC25bc5oqo064Puu/LlR0Rk8vSWCjHpHd/J/FqVuqmuowaVnRd8uwoVFsHgUVmmlqyfsr1g8uSf50bB2Tp5wxyLP1WbCEW6dXbU8NDVvt131Wkkfg9JHae2Jq1wzUycxudrMWT0Ub3HFueUeT+0UoLA5pYNKT1kZTaDfEDBRT18fSHuQGyA2Ix51aDkBAC4GpvwHquC5nW9ffKy8VqHuHhpFC7EGNMHEA5jrDUYbieyRPKa5TmbxtgaLDPKIbbvn2OnE/kslXITJysNmyhXPsH5hNlr6H7DDMn+fdnFE6l++wBYmHupTqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FvqzyUrexlRoMog7YZGIIcrktmfQOyD+g3rSkwfUO3w=;
 b=oKfk5e0w4BLuJz8AI1D0ltUNUc5iPkKYk6/GACFaQr4f9qdygDc7FztPle8YYtTTFmnAZCwZ0vQKI5xZY6qtegP+4IxihFfWKyV6TlY0rhvhifF03H/e5Df2TOCARp4MqQM1tBU+nyCRWVKKnhSQOQDocoAc/Lj9/SPLfB4zo00=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2950.eurprd05.prod.outlook.com (10.172.246.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Wed, 20 Nov 2019 13:05:20 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 13:05:20 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [RFC PATCH 1/3] libnetlink: parse_rtattr_nested should allow
 NLA_F_NESTED flag
Thread-Topic: [RFC PATCH 1/3] libnetlink: parse_rtattr_nested should allow
 NLA_F_NESTED flag
Thread-Index: AQHVn6MpMO9+NvAJK0+B/o//yQYR4Q==
Date:   Wed, 20 Nov 2019 13:05:20 +0000
Message-ID: <20191120130519.17702-1-petrm@mellanox.com>
References: <cover.1574253236.git.petrm@mellanox.com>
In-Reply-To: <cover.1574253236.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: LO2P265CA0375.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::27) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 26229401-66aa-4e63-4a58-08d76dba4bca
x-ms-traffictypediagnostic: DB6PR0502MB2950:|DB6PR0502MB2950:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB2950C81958CCD157243571D9DB4F0@DB6PR0502MB2950.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:275;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(189003)(199004)(4744005)(52116002)(486006)(8936002)(2616005)(66066001)(256004)(14444005)(476003)(25786009)(6486002)(102836004)(6506007)(386003)(76176011)(81156014)(3846002)(316002)(6116002)(54906003)(2501003)(6436002)(26005)(66946007)(66476007)(66556008)(66446008)(64756008)(86362001)(5640700003)(5660300002)(6916009)(2906002)(11346002)(8676002)(71190400001)(1730700003)(2351001)(81166006)(446003)(1076003)(99286004)(478600001)(7736002)(6512007)(50226002)(36756003)(305945005)(4326008)(14454004)(186003)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2950;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yrmX6oe54iFrRJA4KMEmoPL952LbcKv2PC/XVdSxKKeoATFpjsCss6xbLhi2rgp+sRiZc0S7/zAfvufWfM9CafORHmiWBNdLpM40HBpIfD6TNSkwGRWeVWInDOWNIJn7E7nT7Nl/zP2nD8/Jag7zuDJMCwTCTJEfQIrJIFZnADqDKWLx87jy0hmRk+hFHlKe5RmVunQGUNJdrSKrq8vMi05cYi8kcl/cZFQnIPrjQCpcDJaS/OkOpeXjq4SkEyHLHPfyEPWyTqegHQfhhJi5ObupfW+q48Ynuq+K7FtIG8OqDb2bmxT17Yxw6OYhPIjM6x5jyy0f7HuM3kTJYm7cQFS66hYjNDTO1Y6whJvzUTnr+6UvEBXabN6E/uvzxFbyXB7fBqjmE3EG7R4ppoy2eDuRns0CRJTYITbsTwRdRsUrRNMSHatjaSD/Zsa1I8ta
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26229401-66aa-4e63-4a58-08d76dba4bca
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 13:05:20.1846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YYa3jou9L7wLy+QGznQpeiLfeCZAwa7oyJMh5U2cdyAftwT6HbH/5zqZCNFrM8wVXrUhoSHH/I31i21TcQjiMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2950
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In kernel commit 8cb081746c03 ("netlink: make validation more configurable
for future strictness"), Linux started implicitly flagging nests with
NLA_F_NESTED, unless the nest is created with nla_nest_start_noflag(). Have
libnetlink catch up by admitting the flag in the attribute.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 include/libnetlink.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index 8ebdc6d3..e27516f7 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -173,7 +173,8 @@ int rta_nest_end(struct rtattr *rta, struct rtattr *nes=
t);
 				    RTA_ALIGN((rta)->rta_len)))
=20
 #define parse_rtattr_nested(tb, max, rta) \
-	(parse_rtattr((tb), (max), RTA_DATA(rta), RTA_PAYLOAD(rta)))
+	(parse_rtattr_flags((tb), (max), RTA_DATA(rta), RTA_PAYLOAD(rta), \
+			    NLA_F_NESTED))
=20
 #define parse_rtattr_one_nested(type, rta) \
 	(parse_rtattr_one(type, RTA_DATA(rta), RTA_PAYLOAD(rta)))
--=20
2.20.1

