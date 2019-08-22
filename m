Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851C299104
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 12:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387731AbfHVKio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 06:38:44 -0400
Received: from mail-eopbgr150093.outbound.protection.outlook.com ([40.107.15.93]:43513
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729113AbfHVKin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 06:38:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZAU4VMnHhMCRPijZc2jWJh8o7nPbeZOyQbxlPB5QIfBIFuYhtbcJrHWKer/QiH7/uVmlfbFTYjcjtI+8WR8v8CzVh9aivltkp/ESTGSdAHu/NoRGU6VnTgA087GtAet2CO+NxrQnA0hnOtmmmyB+n8qXi4pbM6hAsvrOZUqRu3E4rP5luV76FL3z1Tqj43xaTNv17WCWjFR3y94kf+hU0mrlrvxLYqdI4Bs3eSd1ENQu2ZkpKGjNlP06ArdTDsVhEqaGYjZ7faJuLZ3W8uGhqu/JQaHCZV0ZIvvv1NafNOeFCqai2jEIxJrD2oGBOu7ZHpCqomblx/mcAMW9IEX3zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3BDrPGq8OgdyzV7NoIJ7Bkk94TVQJ78YCY5Mc8tIuho=;
 b=h5Be/vVuS4fvxExU+TnEJNIcT7T/WiDY0//Yv0QjxDnpyx9DC9saOWW0fkdgVvOWmQhNqhMrOs9ouB8s7z0MGzuSzTrCxD1sQPFJV6qg3yIG2H4V7SIYdpi27jBbzc0f9KMSEFTcR4x+SYVV7sEgNlEHT7F6rZAK8hqFMEiJvOS2w0jSBnmidx1V4OAZG4DDSz3P5VydSm9ANlEhnQG6DPQnkg0aJwRw4u5ZJGFeK0fzgJapthoQmimTqnq4F2u3j/r+Nq1AcUcfIrQniNeS7tHAvgy/z6BCinSPBRX3gZ4D0iVOUzyBu1u0PQukebgbUl++GyalkDk0vUrLK/6E6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3BDrPGq8OgdyzV7NoIJ7Bkk94TVQJ78YCY5Mc8tIuho=;
 b=RvC7yquMi99OfdUc8gxWk7I5O1vg41GAs8WJKQaolWVEC3r5V8J7X3IEXufjMc48vAAVKF5eeLZv3W6adlCv5b+mjtCTM5uh8u9tNilBEqFhxIXdXuxf5BTD2jniyndDqm2mtIHAcuHzmPhOveEn64zt6FkIDVe2QzNzhPa5QgA=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB4032.eurprd08.prod.outlook.com (20.178.126.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 10:38:39 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 10:38:39 +0000
From:   Jan Dakinevich <jan.dakinevich@virtuozzo.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Denis Lunev <den@virtuozzo.com>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Jan Dakinevich <jan.dakinevich@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Kyeongdon Kim <kyeongdon.kim@lge.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH] af_unix: utilize skb's fragment list for sending large
 datagrams
Thread-Topic: [PATCH] af_unix: utilize skb's fragment list for sending large
 datagrams
Thread-Index: AQHVWNXCVy+NB8D6AkS8eOMw9lnGGQ==
Date:   Thu, 22 Aug 2019 10:38:39 +0000
Message-ID: <1566470311-4089-1-git-send-email-jan.dakinevich@virtuozzo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0102CA0052.eurprd01.prod.exchangelabs.com
 (2603:10a6:7:7d::29) To VI1PR08MB2782.eurprd08.prod.outlook.com
 (2603:10a6:802:19::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jan.dakinevich@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.1.4
x-originating-ip: [185.231.240.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64200d9f-8ab0-4f49-3f12-08d726ece50d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR08MB4032;
x-ms-traffictypediagnostic: VI1PR08MB4032:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB403272ABB4AE281CC6B361028AA50@VI1PR08MB4032.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(136003)(366004)(39830400003)(199004)(189003)(6116002)(102836004)(50226002)(71200400001)(36756003)(6486002)(86362001)(6436002)(386003)(2906002)(66556008)(64756008)(66476007)(66446008)(6512007)(26005)(2616005)(6506007)(186003)(7416002)(5640700003)(66946007)(71190400001)(476003)(2351001)(305945005)(54906003)(99286004)(316002)(66066001)(52116002)(486006)(53936002)(44832011)(25786009)(8936002)(8676002)(7736002)(81156014)(14454004)(256004)(14444005)(5660300002)(6916009)(81166006)(2501003)(3846002)(4326008)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB4032;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LD48Y+4verwTp27SR51ANMFtwTwhZIF3btJc7WohGadLSjKSIkUZ76LXKR1l6KvgezefXhzXMnrg4Oq9idXDCA0l2LLUWpCJ3VfRYtiqDRtL1und421l9V22/6DSSE9/7zSg7fgEf30VHyPXpJ+QfHzIbHj9h1gtZSO3h5KfQSZ+f0oSS5VG4H4EyMMat3UhbsR/7k2y6eH2A1O85NJnCUTXxVLZ31SpzXZfuAlxhUarU308AKR3oBhs9bRlFAv2a2Np7CptQiGRjxRXC+QUkR2DjG1cvjGEF6SmdutLFGJjtvqs9TgGPCT6w3/xLCeLFQKonAhdnlRveqzOJVWiS45xxh5fAU07VvhHIfZA1phVWMGZuWRZSly0+O8dDmp4Q22Z8+vXzuoJIQLwEjaAb7KQ6VfMvqh+WUB87wf4sxo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64200d9f-8ab0-4f49-3f12-08d726ece50d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 10:38:39.5760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EeqmZsZQyA1nPCLIJ0YIFbqEMtVNCFO+qu5o7/NxIn1h4Gp7Q/KeUpg+VYWmGza+Dne7L7YiwxBTfijowVzMEv3BR5c/m0PNoR8tXXqyeyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4032
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When somebody tries to send big datagram, kernel makes an attempt to
avoid high-order allocation placing it into both: skb's data buffer
and skb's paged part (->frag).

However, paged part can not exceed MAX_SKB_FRAGS * PAGE_SIZE, and large
datagram causes increasing skb's data buffer. Thus, if any user-space
program sets send buffer (by calling setsockopt(SO_SNDBUF, ...)) to
maximum allowed size (wmem_max) it becomes able to cause any amount
of uncontrolled high-order kernel allocations.

To avoid this, do not pass more then SKB_MAX_ALLOC for skb's data
buffer and make use of fragment list of skb (->frag_list) in addition
to paged part for huge datagrams.

Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
---
 net/unix/af_unix.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 67e87db..0c13937 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1580,7 +1580,9 @@ static int unix_dgram_sendmsg(struct socket *sock, st=
ruct msghdr *msg,
 	struct sk_buff *skb;
 	long timeo;
 	struct scm_cookie scm;
-	int data_len =3D 0;
+	unsigned long frag_len;
+	unsigned long paged_len;
+	unsigned long header_len;
 	int sk_locked;
=20
 	wait_for_unix_gc();
@@ -1613,27 +1615,41 @@ static int unix_dgram_sendmsg(struct socket *sock, =
struct msghdr *msg,
 	if (len > sk->sk_sndbuf - 32)
 		goto out;
=20
-	if (len > SKB_MAX_ALLOC) {
-		data_len =3D min_t(size_t,
-				 len - SKB_MAX_ALLOC,
-				 MAX_SKB_FRAGS * PAGE_SIZE);
-		data_len =3D PAGE_ALIGN(data_len);
+	BUILD_BUG_ON(SKB_MAX_ALLOC < PAGE_SIZE);
=20
-		BUILD_BUG_ON(SKB_MAX_ALLOC < PAGE_SIZE);
-	}
+	header_len =3D min(len, SKB_MAX_ALLOC);
+	paged_len =3D min(len - header_len, MAX_SKB_FRAGS * PAGE_SIZE);
+	frag_len =3D len - header_len - paged_len;
=20
-	skb =3D sock_alloc_send_pskb(sk, len - data_len, data_len,
+	skb =3D sock_alloc_send_pskb(sk, header_len, paged_len,
 				   msg->msg_flags & MSG_DONTWAIT, &err,
 				   PAGE_ALLOC_COSTLY_ORDER);
 	if (skb =3D=3D NULL)
 		goto out;
=20
+	while (frag_len) {
+		unsigned long size =3D min(SKB_MAX_ALLOC, frag_len);
+		struct sk_buff *frag;
+
+		frag =3D sock_alloc_send_pskb(sk, size, 0,
+					    msg->msg_flags & MSG_DONTWAIT,
+					    &err, 0);
+		if (!frag)
+			goto out_free;
+
+		skb_put(frag, size);
+		frag->next =3D skb_shinfo(skb)->frag_list;
+		skb_shinfo(skb)->frag_list =3D frag;
+
+		frag_len -=3D size;
+	}
+
 	err =3D unix_scm_to_skb(&scm, skb, true);
 	if (err < 0)
 		goto out_free;
=20
-	skb_put(skb, len - data_len);
-	skb->data_len =3D data_len;
+	skb_put(skb, header_len);
+	skb->data_len =3D len - header_len;
 	skb->len =3D len;
 	err =3D skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, len);
 	if (err)
--=20
2.1.4

