Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F25B4D41A5
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 15:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbfJKNp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 09:45:27 -0400
Received: from mail-eopbgr740048.outbound.protection.outlook.com ([40.107.74.48]:39328
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728198AbfJKNp0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 09:45:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GeEYuzBOD398aMhGQsmTmuQ7vZYp5AEzOE/5/UvlYi0pFOKyIZ/FXRpGLFRaR3abbzfGEIA6iTHSrjxzWIj15I6jWX+8DT5RyJTlVhosmWdff5ceBrcQ+doW6y+rHfBcGL1x9CIHOUzEKLeB5iquM08+TRImBtcX9224+oJpYgo/B1gRa78NF1XV0xAJF5FamHOcJwJqsLhF+5nFvR7a2ibeKLB/F1A82poi3Cdah+dMGIci5qtWpAvEgeU2uRwRdOWfQVT7rYXk88apLwdPSpPtaXSmA8P+qBcc5veZokafk4zGKksfWUNyIa5KLHTd/B6cbkh9/y6cNdEFoNSHhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WN+4ua9wVV7rVolW/Ua5tc/901+RVksG7RYMzx6/Kcc=;
 b=GyGVx1y65DU/WOgQn8jezGd5n/+C29GESLcX8/pePV9qdyFLrXhypIPL3X3FOjeqBq+olfDR6PTkrFvv0tFLaeV4GmFXmT9OHwnuUQyKOOsm/eN2pqbeq0In8By4vh3F31iOVUBsqJ16PToB2ppFXV4hNdaljV1NnUeVwcR1WpHc8Fwz2bj4kgkbdtR3C610qpBXBPFel5Q3BScscgLqhYO2cHI8JqehmnWzsr2Cy9WpmFheq9PDTx/x/nK3P1/xsWEXOqN5x0yZMvNGUFHD1QDFCEHgQ/8EKzg0XwyzyQ8gkJrU7C4APmq4+RICS/fcRRMYOh+h+JYynGxZY68vDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WN+4ua9wVV7rVolW/Ua5tc/901+RVksG7RYMzx6/Kcc=;
 b=OjXK4VJNZt2DATLmhYBpkdHmWwHik2bqOEGCII1WACb/CzKnJisUChJFfeMuA3dI/GOK3PFVg9HCDb9Zh6PRU0LBdQ6RDBWm8QoaZRUVBRS7DjOrdEXdpvYEdcUVAxpWwIn+DCyDuPIGD2GplmOh1KBaumHAucqp2mOYmHowpZc=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3587.namprd11.prod.outlook.com (20.178.221.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Fri, 11 Oct 2019 13:45:22 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.021; Fri, 11 Oct 2019
 13:45:22 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>
Subject: [PATCH v2 net 3/4] net: aquantia: do not pass lro session with
 invalid tcp checksum
Thread-Topic: [PATCH v2 net 3/4] net: aquantia: do not pass lro session with
 invalid tcp checksum
Thread-Index: AQHVgDogXvvquZLG/0GH/rN2j9Ukyw==
Date:   Fri, 11 Oct 2019 13:45:22 +0000
Message-ID: <3c9524eb0c683bade0261ac5f0e95069c42febc7.1570787323.git.igor.russkikh@aquantia.com>
References: <cover.1570787323.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1570787323.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0005.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::17)
 To BN8PR11MB3762.namprd11.prod.outlook.com (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6fb2c714-f0c2-49de-9421-08d74e514314
x-ms-traffictypediagnostic: BN8PR11MB3587:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3587488EB373BF5FD606541498970@BN8PR11MB3587.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:765;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(39850400004)(136003)(346002)(396003)(189003)(199004)(6916009)(66446008)(14454004)(76176011)(36756003)(64756008)(99286004)(118296001)(66476007)(446003)(11346002)(486006)(2351001)(52116002)(476003)(66946007)(66556008)(2501003)(305945005)(6506007)(44832011)(7736002)(386003)(5660300002)(86362001)(2616005)(66066001)(102836004)(26005)(508600001)(8676002)(81156014)(107886003)(316002)(71190400001)(81166006)(54906003)(1730700003)(4326008)(3846002)(6116002)(71200400001)(2906002)(14444005)(256004)(6486002)(5640700003)(50226002)(25786009)(6436002)(6512007)(186003)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3587;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pTStudDmp/pWgJR8iy4LHM5IsqS1hY7Xf5jZDYhUMuve63x2RFv4+4bkNSxsaGboIMdOMd8q7a4iyfefvQM83UImu33/mPx3LUs8cfNuhZDE/R3QMD7w5cx6pEUwaklYcf5OeYyXhqnhiQE0Sv+WQYqGhTylF1b1ELs+YLP7I7aSJobSls/uBTrFUuGFiX7t6My2ah1lhx/IsEzM5Iq+/3lqbgEQLlWV+2zq3a4/zINhWjwN6d6OejMywGTaeYAoDEnpYibUoyQLcoOgFfeAVF67O44PB/KihJzeEa98ghn+pQvhWrXtazrxERekpZgWX/WV9jvhCCzLkjd7Bv4z9L5JaS/aM+nijexy1PcCqLPhqHxPJ+Y45ZqIHNZnhjBbR/NQMc68wcSg2TosD5L08PuxuzsCkuioxLhr+cQSa2I=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fb2c714-f0c2-49de-9421-08d74e514314
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 13:45:22.3332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cC285dX/gXjBdCy6PPgRWFLTtWNQXnzQZwVYqVpDmhoO3483nJSYrvBp9PUI3+CReOm1s6m+EuvK1HjqluJfCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3587
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

Individual descriptors on LRO TCP session should be checked
for CRC errors. It was discovered that HW recalculates
L4 checksums on LRO session and does not break it up on bad L4
csum.

Thus, driver should aggregate HW LRO L4 statuses from all individual
buffers of LRO session and drop packet if one of the buffers has bad
L4 checksum.

Fixes: f38f1ee8aeb2 ("net: aquantia: check rx csum for all packets in LRO s=
ession")
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_ring.c
index 3901d7994ca1..76bdbe1596d6 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -313,6 +313,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 					break;
=20
 				buff->is_error |=3D buff_->is_error;
+				buff->is_cso_err |=3D buff_->is_cso_err;
=20
 			} while (!buff_->is_eop);
=20
@@ -320,7 +321,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 				err =3D 0;
 				goto err_exit;
 			}
-			if (buff->is_error) {
+			if (buff->is_error || buff->is_cso_err) {
 				buff_ =3D buff;
 				do {
 					next_ =3D buff_->next,
--=20
2.17.1

