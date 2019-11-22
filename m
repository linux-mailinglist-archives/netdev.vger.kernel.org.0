Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA2EF107A3D
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfKVVvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:51:55 -0500
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:24062
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726089AbfKVVvy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 16:51:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GE5uZCR0ehfOPYfCKDCzmlvljXQg+V35K4NPLsigTqXTGQN7TjJIFtcbJI1N//APDjgCT1gc3ucn4HUe3crUTLqlXyKEknim9AMtBK6SJcFhrNjWbaysbtCbI8qjbjZlPgntZaNCeYbztVn/EHRnmV/hJONzAgK7KNso1m/g6LV6jfe5B8+KdPPGQvZlJQMWuvVHy0Jo1tu8RFUndJUz/96PuaeDwG1rGHZK0qoXHwSBEFmUZO9ZGQx6A5BB1GJTI7X7kBBTkvsXd4MqfAnnFLaWabPMgMSeHeH8okOdslSm1SLo1l5rYMSR8iRW6xFer7IRu6mFy7lJ5Folx2vqaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60kHCgVZe6c2kjm85a09MvAs7Oeg4xcNCULXqIllHUA=;
 b=U7P140IpCRrHebpth46dWRYRiyiodNv4j5VNqPPyXO8axsPI5nUTfB6Ia3bdoiTsHIzaCpm3Jd0LQVDFHtMy7zg555F0XJAN9wQTTfwp+QTjGTgfPaLQr699PO/uS46svfywcfSSr7zD63+EfH/koAhxlZAuBxU+vNPzKHQmz60AJBqXIGe6nFYU2kSfq9VFKutFojpapLceX9+iX+4z0G1zWExfT2md3FRinfoOgftWfHe+/ARTEjlPJVAzNqXyhB/AKlsKpnpf2QJtmnXozNu8bgoNBWrSs3ZSBn0UYgAaR/0Wpfz5xuOc+dOUXsbm9rdgfbW3ZmiF4GOnwT/YNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60kHCgVZe6c2kjm85a09MvAs7Oeg4xcNCULXqIllHUA=;
 b=AXoFE7Ugt4RHLCGEgU/2PCCiFbkV1EFmo3CtKs8TOItAMoaDfseKcp39vjGDC60ygDPzEOJieFos6oWd9uMQJ/kwmw/cn6qoo4ZUhRKs9YS6pjAR8G3X+DOJqFYEzia2OB6Cvuw1IiT50DKkgrn2EJPe9A376/jKuPQT5tnhTzo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5341.eurprd05.prod.outlook.com (20.178.8.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 21:51:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 21:51:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 1/6] netlink: Convert extack msg to a formattable
 buffer
Thread-Topic: [PATCH net-next 1/6] netlink: Convert extack msg to a
 formattable buffer
Thread-Index: AQHVoX8LEwXiTvITP0SQu2FBT+CiAw==
Date:   Fri, 22 Nov 2019 21:51:49 +0000
Message-ID: <20191122215111.21723-2-saeedm@mellanox.com>
References: <20191122215111.21723-1-saeedm@mellanox.com>
In-Reply-To: <20191122215111.21723-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 118b6e9e-8c11-4844-2290-08d76f962da6
x-ms-traffictypediagnostic: VI1PR05MB5341:|VI1PR05MB5341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5341D67B55110E831EF332CABE490@VI1PR05MB5341.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(189003)(199004)(107886003)(8676002)(386003)(6506007)(3846002)(36756003)(6512007)(26005)(478600001)(1076003)(316002)(66476007)(2906002)(6116002)(66556008)(64756008)(66446008)(71200400001)(71190400001)(99286004)(66946007)(66066001)(25786009)(4326008)(14444005)(256004)(54906003)(50226002)(102836004)(446003)(7736002)(186003)(305945005)(6436002)(6486002)(8936002)(76176011)(11346002)(52116002)(6916009)(14454004)(81156014)(5660300002)(81166006)(2616005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5341;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8TwbJqkmz0fSNHhOmmTvgkHFnKU5W1iiR2nZzOp/glKBuC2AitNC7vlf5iibCCYD7AP8pWPCr+vcrFhK4wl/RVzQ9IycgKvuSs0Nur4+Z/KU73Z47iJizV/pK8BOZKFIfGyNftLRM6ZGrZt2ARkkWlUvaPE4tksArwOSq/slM0qWprJsGY8LWLI9B2lZQjcJP5SnznBN0v55ztHUryEA0ZxG2N2mlyVZFrprhLrwLMWSIz6B3mFZDHeuvGkaretqsUWdvVh+SXdoZw7t9jlxd7tk7d9thBEJlAhNYFX9A3QhyIRX+J0Q9qM3VRQ3dt398fj6Wfw+TkBlBVm8+c+HUSTx1BWiDV80GLpqA1TPI+B4oQWYIfCRBZPUONECQ+LISRgymdN9sreO/46wxYaTAK+xtQrQesZXun5WhZ9zyrAuKDw/ybqdXxIfdZ7hFY75
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 118b6e9e-8c11-4844-2290-08d76f962da6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 21:51:49.9333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TGGgS4g/p0/vwrR0W1JW8Bi//RKIC++qh5M3JIHHlPIrcnUZUfL9iAWeipTkk8a5uuFwsvNf2oPUQD+anZ8kJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5341
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this patch the extack msg had to be a const char and didn't leave
much room for developers to report formattable and flexible messages.

All current usages are oneliner messages, hence, a buffer of size 128B
should be sufficient to replace the const char pointer.

This will allow future usages to provide formattable messages and more
flexible error reporting, without any impact on current users.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/linux/netlink.h | 27 ++++++++++++---------------
 lib/nlattr.c            |  2 +-
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 205fa7b1f07a..de9004da0288 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -62,6 +62,7 @@ netlink_kernel_create(struct net *net, int unit, struct n=
etlink_kernel_cfg *cfg)
=20
 /* this can be increased when necessary - don't expose to userland */
 #define NETLINK_MAX_COOKIE_LEN	20
+#define NL_EXTACK_MAX_MSG_SZ	128
=20
 /**
  * struct netlink_ext_ack - netlink extended ACK report struct
@@ -72,40 +73,36 @@ netlink_kernel_create(struct net *net, int unit, struct=
 netlink_kernel_cfg *cfg)
  * @cookie_len: actual cookie data length
  */
 struct netlink_ext_ack {
-	const char *_msg;
+	char _msg[NL_EXTACK_MAX_MSG_SZ];
 	const struct nlattr *bad_attr;
 	u8 cookie[NETLINK_MAX_COOKIE_LEN];
 	u8 cookie_len;
 };
=20
-/* Always use this macro, this allows later putting the
- * message into a separate section or such for things
- * like translation or listing all possible messages.
- * Currently string formatting is not supported (due
- * to the lack of an output buffer.)
- */
-#define NL_SET_ERR_MSG(extack, msg) do {		\
-	static const char __msg[] =3D msg;		\
+#define NL_MSG_FMT(extack, fmt, ...) \
+	WARN_ON(snprintf(extack->_msg, NL_EXTACK_MAX_MSG_SZ, fmt, ## __VA_ARGS__)=
 \
+		>=3D NL_EXTACK_MAX_MSG_SZ)
+
+#define NL_SET_ERR_MSG(extack, fmt, ...) do {		\
 	struct netlink_ext_ack *__extack =3D (extack);	\
 							\
 	if (__extack)					\
-		__extack->_msg =3D __msg;			\
+		NL_MSG_FMT(__extack, fmt, ## __VA_ARGS__); \
 } while (0)
=20
-#define NL_SET_ERR_MSG_MOD(extack, msg)			\
-	NL_SET_ERR_MSG((extack), KBUILD_MODNAME ": " msg)
+#define NL_SET_ERR_MSG_MOD(extack, fmt, ...)			\
+	NL_SET_ERR_MSG((extack), KBUILD_MODNAME ": " fmt, ## __VA_ARGS__)
=20
 #define NL_SET_BAD_ATTR(extack, attr) do {		\
 	if ((extack))					\
 		(extack)->bad_attr =3D (attr);		\
 } while (0)
=20
-#define NL_SET_ERR_MSG_ATTR(extack, attr, msg) do {	\
-	static const char __msg[] =3D msg;		\
+#define NL_SET_ERR_MSG_ATTR(extack, attr, fmt, ...) do {	\
 	struct netlink_ext_ack *__extack =3D (extack);	\
 							\
 	if (__extack) {					\
-		__extack->_msg =3D __msg;			\
+		NL_MSG_FMT(__extack, fmt, ## __VA_ARGS__); \
 		__extack->bad_attr =3D (attr);		\
 	}						\
 } while (0)
diff --git a/lib/nlattr.c b/lib/nlattr.c
index cace9b307781..2ce1d6b68ce8 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -208,7 +208,7 @@ static int validate_nla(const struct nlattr *nla, int m=
axtype,
 	case NLA_REJECT:
 		if (extack && pt->validation_data) {
 			NL_SET_BAD_ATTR(extack, nla);
-			extack->_msg =3D pt->validation_data;
+			NL_MSG_FMT(extack, pt->validation_data);
 			return -EINVAL;
 		}
 		err =3D -EINVAL;
--=20
2.21.0

