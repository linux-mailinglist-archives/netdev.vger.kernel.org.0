Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C02C107ACA
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKVWmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:42:32 -0500
Received: from mail-eopbgr00044.outbound.protection.outlook.com ([40.107.0.44]:48709
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727269AbfKVWmc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 17:42:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWGJK52AwX4qg7R3vXMjysRWoIUHzfQBDx6neHObAz6twDPVLSBwCIx5yNqj60Jdr4ejXMRmU6RcFPdoYWz7V0WE2lenHH1d+7Xo/pYEntqkiKEE4Y6pBdECBUKpl+BivdOxXGGEiKGeq7hlqajtioaxBQtz+5bU1vbZNHShhkimWylzNyr+Ca0pa0PRUNvRlu3PlEBIUht/H/CrPRBnxnBtb65mkTNiKlq29xy5iCEogZ+bbHDdhG+HmEnqks5wr+xSwsFsFwwH64JrFyGFYk93Wi/zs5niO+ydhWl7ywtwtpdG1wbEKRwf0bT2MWRWp68Fb8XfPmsWEnUP5W59LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60kHCgVZe6c2kjm85a09MvAs7Oeg4xcNCULXqIllHUA=;
 b=VHHedoqv9ZodshLlmp3Q77ZhQRXSxvAZz1txqATmDgD2h0ZrRIRsoY1s+mQYgM2JXFs9Q1NF/edUwJQvz4OALPFKyzhlvgvOLCl9124C89Ifz5RtwFzd1kjkjlUoP7U/URv0pC2PAPz8lTTd7bDExxUOTKlVhS9MKQyaFKVgLmgmYZbukfwsUqx+DG4o5wdIOoR/UWwTCzRA/5vDOh4xkaYsY0e85J/yW0R9YX6seuoBof/0gVqa3eEFmwP8Y7rxJb8ToOQtjgBz/qI3YLyGQuDmueUQvK7yMq8wfhfIf/2d+Jvvfi7PO9pBy8eyKjdqHnaqT5pQ2SVwsGFSk+ldtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60kHCgVZe6c2kjm85a09MvAs7Oeg4xcNCULXqIllHUA=;
 b=koZ/jVEbJOpiDDW9m7fEY0asnAIfiAKSh04UO7zv7LtJm5LFWNRHpTY8+Uro3/kCf+yIURVTGJeMxfIKm/11eFAiFfA9yEYcaF6RGb0jf8AzB4/4RbLmEcb9MzPa3ksNVIVvmOPJS6UkmMOuJ5nx63ZpQtyJvaQUWRlKWlfYLnU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6718.eurprd05.prod.outlook.com (10.186.162.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 22:41:47 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 22:41:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH V2 net-next 1/6] netlink: Convert extack msg to a formattable
 buffer
Thread-Topic: [PATCH V2 net-next 1/6] netlink: Convert extack msg to a
 formattable buffer
Thread-Index: AQHVoYYFLiIobYES3Umik1b3xPm7DQ==
Date:   Fri, 22 Nov 2019 22:41:47 +0000
Message-ID: <20191122224126.24847-2-saeedm@mellanox.com>
References: <20191122224126.24847-1-saeedm@mellanox.com>
In-Reply-To: <20191122224126.24847-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR16CA0008.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 620d7ae9-8ed7-4268-9e37-08d76f9d2811
x-ms-traffictypediagnostic: VI1PR05MB6718:|VI1PR05MB6718:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB67189E2A7FEABBEC19C7C7EFBE490@VI1PR05MB6718.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(189003)(199004)(14454004)(66946007)(64756008)(66556008)(1076003)(66066001)(66476007)(4326008)(6486002)(66446008)(14444005)(8936002)(6512007)(6916009)(7736002)(6506007)(26005)(256004)(305945005)(386003)(186003)(3846002)(102836004)(6116002)(11346002)(2616005)(446003)(107886003)(2906002)(478600001)(99286004)(8676002)(25786009)(52116002)(81156014)(36756003)(81166006)(76176011)(316002)(6436002)(54906003)(86362001)(50226002)(5660300002)(71190400001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6718;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M+/1VLNcfCbSfm41vhy0hAHO839LNdGRlQZJzA+VLq0FS+pw1kORfJi4W2daULpx1V2n53xxw15pfFjwh9tc7aklKFlsLd1H1MWLgIHqm9G2NAQP7Nz0Ey6iQmjmz0kn5wkwzRzt6vIkuJHKOnZcHIciQeDCb8UUOy92T9WE9gIPV6hNXQgoVF3U/NokhIZLd8BZCbiEP6DZ9f0Rc6G06sh2H9wooJUplJqLKkBjF+c/aFTn0GGhCZ3ARTX4U0P0JhsnOvJSCWRTf/J1c808Wy7xLwMj87L2CrgTdYiLpAcGaqxxN06FxAFmwSZeeD65/nIJWkyUcg9uoxTslAvUgGmhLg6946Pq3CZJuyQUUF0zmUxo3noTs9JhOtbm/D/evxFwEqvMmczuYBkUegZZXn6+OmmEAie9bfEwMmthMkeHikvAsyiLiC9zbMFAt5Nv
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 620d7ae9-8ed7-4268-9e37-08d76f9d2811
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 22:41:47.0645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kcQlRWznB35SXzMgb4H8aLclXIppqO3qKIY24PL0MdIRHRTKPbZNxQoGzC17Y83jMMIvINcIngpT6bfjR/yA/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6718
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

