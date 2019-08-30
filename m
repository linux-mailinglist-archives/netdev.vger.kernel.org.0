Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F81A3661
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 14:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfH3MIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:08:42 -0400
Received: from mail-eopbgr770043.outbound.protection.outlook.com ([40.107.77.43]:57095
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728358AbfH3MIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:08:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFtB7ENdyBw7JDGnxDtG/InImbOmDLPGEgpg+gkhDqLYGixUaeE2+YHzVzMDSFKrDbyEXV62TfXwtxYWEQnyRksR9obTwzXZbG1lmU1iM6Ap1V3CC9xW/VxUm9Wzzutj4Ifrey7Xg0wsqmGlOF28n/oFz42PQuHVy/wZiLVeceuJNJOQznK8C4eoMgqyA9+1taCR+7zeVT1nqI9liYp9LMjI1lHmRipOSmNxR/T8b6YcJZgHrn0lYcHUob0Vy5mdfyetgX6a0eSh9YbtrH1l4YPUQzQaSXczKefHw0xID/dxuSYPI2JYhdfFzYnXAjShuHh9IyineofhphZLK0aVRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ufHx0CcxRCRq6tQhOihH1gbucJAgR8rpm/zJl1XThOM=;
 b=OxYagln04Im1Wd2FsBeNfwbxifdVka7DUU07GGzE+vMEma9mrbB0QYnbe22wCJ8QZRBup3ayQyAbn7cn9H2RLLO/Ec5AeEr0t4QO5lLPbx35Uoaqp9Ie24aGtKzSkn1ZXaRQx3HbEUGUgW1wUIO5eAHE7t0dMPVGuEmFXn3S5Pj3Yzyo2ECyviKW9QYjt4uwLoyM2kfE1jIttE2KWBTaM5n0RS/UzpaMlajnRi2lN588brd0iFv6J2A35/zx6tN5eKIka3rHnabrEabolIGIcFkwlWyqWirkto1TTwfXmQbFG8LX2umvF4L+ZciS01rUEblEcoh7xv8KR0jJX8txRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ufHx0CcxRCRq6tQhOihH1gbucJAgR8rpm/zJl1XThOM=;
 b=RH7lWWJtdvKYAgeazFp6elUPzRKU2lj7/zgAL5K+yhdUG0diIdkFZwoxHYDhp2g3afOCDw/SNIBQiXGy2cmYHGRJ9wrQDyXA4GPHwRNF+pLs54TOVmOAw4E6tz1kLoQ/GPXmWdI+81GWBH8osh3q7tzezspFXfIRyfE31egEf8k=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB1684.namprd11.prod.outlook.com (10.173.28.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.16; Fri, 30 Aug 2019 12:08:39 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5%3]) with mapi id 15.20.2220.013; Fri, 30 Aug 2019
 12:08:38 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>
Subject: [PATCH net 5/5] net: aquantia: fix out of memory condition on rx side
Thread-Topic: [PATCH net 5/5] net: aquantia: fix out of memory condition on rx
 side
Thread-Index: AQHVXyuoQEiPQtTL50mi6n4Lp9gLYQ==
Date:   Fri, 30 Aug 2019 12:08:38 +0000
Message-ID: <9514483a86bd29d882dc8b799167a85ecc5eddeb.1567163402.git.igor.russkikh@aquantia.com>
References: <cover.1567163402.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1567163402.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P195CA0012.EURP195.PROD.OUTLOOK.COM (2603:10a6:3:fd::22)
 To BN6PR11MB4081.namprd11.prod.outlook.com (2603:10b6:405:78::38)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f6daf0a-e07c-478b-fa7f-08d72d42ca83
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1684;
x-ms-traffictypediagnostic: BN6PR11MB1684:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1684B351CB227CCC79113AC898BD0@BN6PR11MB1684.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(39840400004)(366004)(396003)(199004)(189003)(2906002)(476003)(6916009)(76176011)(4326008)(50226002)(99286004)(6436002)(305945005)(186003)(26005)(36756003)(478600001)(316002)(6486002)(6506007)(54906003)(25786009)(8936002)(107886003)(44832011)(52116002)(2616005)(3846002)(14454004)(102836004)(386003)(86362001)(53936002)(81156014)(6116002)(5660300002)(8676002)(81166006)(7736002)(6512007)(11346002)(64756008)(66446008)(14444005)(256004)(66556008)(66476007)(66946007)(71190400001)(71200400001)(66066001)(486006)(446003)(118296001)(79990200002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1684;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iYk6eHMxumPmV/XeDdF0DDcCNd3MnRl3Ssv3oD2rgkz7SYn0724ICngZcN2+cPMTDHBzlCVqqTQuvQxGuOPhvQ6uUxa4vv6vaRVCk/UbeQaOcGRZPLzD3ATXHrF0/bQVxmbr+bT51iWjImg9qDyQdzLpmnxcS+F/aNGhD6N38vYkqOimCYkjtO1LdM7pQeB1jNfXmDaL5Kf/pUULsenfBrXh59cHQ3i4RjPp5p7uw8HlHg9VDIMn+neOB65Sog1fcM+uPLJJu+S/p+YLg4WcktgIhYTxRXiRh+FqLGDiLVawo+NACuuYvNYFT1XIKreQ5DDD1t84SND0N6sNO01AXfMqWbxFJlAZ9j1BK6GsDwQhIFEy8ItxE4W2hGKdVEIPh10cjW4V0ZRT3WAm73O8rKC+IL4BOLADPZQTfdZHEaYZ6gMiztX501LokFgTc3CQoT3Ijr+fSQe6C95xB3jRLQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f6daf0a-e07c-478b-fa7f-08d72d42ca83
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 12:08:38.8920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H8qpCpIWnmi9KCHlSRCOrO8AjZicmZK+bgNAbjC2iB5rObkEHUaYsCz1hQbneSj6LZRHbBWdrZV+qUquIWw48w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1684
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

On embedded environments with hard memory limits it is a normal although
rare case when skb can't be allocated on rx part under high traffic.

In such OOM cases napi_complete_done() was not called.
So the napi object became in an invalid state like it is "scheduled".
Kernel do not re-schedules the poll of that napi object.

Consequently, kernel can not remove that object the system hangs on
`ifconfig down` waiting for a poll.

We are fixing this by gracefully closing napi poll routine with correct
invocation of napi_complete_done.

This was reproduced with artificially failing the allocation of skb to
simulate an "out of memory" error case and check that traffic does
not get stuck.

Fixes: 970a2e9864b0 ("net: ethernet: aquantia: Vector operations")
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_vec.c
index 715685aa48c3..28892b8acd0e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -86,6 +86,7 @@ static int aq_vec_poll(struct napi_struct *napi, int budg=
et)
 			}
 		}
=20
+err_exit:
 		if (!was_tx_cleaned)
 			work_done =3D budget;
=20
@@ -95,7 +96,7 @@ static int aq_vec_poll(struct napi_struct *napi, int budg=
et)
 					1U << self->aq_ring_param.vec_idx);
 		}
 	}
-err_exit:
+
 	return work_done;
 }
=20
--=20
2.17.1

