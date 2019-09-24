Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABB0BD1FB
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 20:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437301AbfIXSpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 14:45:42 -0400
Received: from mail-eopbgr150117.outbound.protection.outlook.com ([40.107.15.117]:30949
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390679AbfIXSpm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 14:45:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7KoiophkT0Iipz0/pehmMSOxR1VNgVLZdZjbbQGvdllKnz93h642D2pU/wPDtFSPZqkgjuqpqlmaMRHWw0DTudUq8RjfLE64WY8gjxZxq5pzrAFxAGvfoRVh1QIKppluDG4UbLC24hgfmjV0wA5AbleJroN8gy7aLl/lae6PbW+PFB5tr6f2rbs1G3x6ZSvhXt3taiTLuQh0Jm3zClggajAZ/mXYXPsnkoh114vIm7dNDpMDP8wvHMafvztCSvpukgztnLJk6ynh/i9BP+J0fOFCKYjJ3zN+PTWOkVXjcvgeLKAE1Y13qxWZ2HhS/QICSJ0RQwti2hzLr4PsEatOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3izBidAxn+vMjw5NYV2o7GWThZ/wGRpYi2HLmt9714=;
 b=J09/WXb3rNBfJ1ijT0WfDrpy1DTZzzUCCXK0fbOe0hx0Q6eDpalyn9c6f0BXGuzD+I41WgVnIkPl+e1bldfMlwpNoPQaP5vClQqIrwdMSyDE8f6Uw/OZfBAp0o+aoEi9CBcFxJ3SmWlFdxhOIREMg3TF+82IBtQFnAj+457l6Hg0Y/2vW08emr1oBpV1D5UnIK/SIgGt9XCZh+nYSzQLhb3cVjLnIm54fC8f+La+IQ4Suyt2tOEUDZgTbWMZvqosAi4cwPQJ08ISAMLKF1na4w0UFs8PSarh0GPpy5YCeqPbOIccJ3ziFz2pJv7pWykUF50fWiNLkjnt/sIgm254LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3izBidAxn+vMjw5NYV2o7GWThZ/wGRpYi2HLmt9714=;
 b=QCPl+ZB1R0bKSFO0oUN9f/5yd0ubaSGBadEn7VNiSjpF7+XpivjF3F2x2nD+RYQz8t3MKt2/s8fXnrp+rnCxHpE1luXZIyXLHN8bEWZ6Sdw0MlwPc0d/s749uwm20MLehETp4KRN7iPR+PCW5SITygD9Y1/+r0a3dzOmlz2X7+0=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2847.eurprd07.prod.outlook.com (10.173.70.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Tue, 24 Sep 2019 18:45:38 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1%8]) with mapi id 15.20.2305.013; Tue, 24 Sep 2019
 18:45:38 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] can: rx-offload: continue on error
Thread-Topic: [PATCH 1/7] can: rx-offload: continue on error
Thread-Index: AQHVcwhCgRg367Eiu0mUgNTGybynuQ==
Date:   Tue, 24 Sep 2019 18:45:38 +0000
Message-ID: <20190924184437.10607-2-jhofstee@victronenergy.com>
References: <20190924184437.10607-1-jhofstee@victronenergy.com>
In-Reply-To: <20190924184437.10607-1-jhofstee@victronenergy.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:1c01:3bc5:4e00:c415:8ca2:43df:451e]
x-clientproxiedby: AM0PR05CA0062.eurprd05.prod.outlook.com
 (2603:10a6:208:be::39) To VI1PR0701MB2623.eurprd07.prod.outlook.com
 (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 831b48af-d289-4e34-e504-08d7411f646d
x-ms-traffictypediagnostic: VI1PR0701MB2847:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0701MB28477A5A9A9DA7CFD6843FB3C0840@VI1PR0701MB2847.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(39850400004)(346002)(136003)(396003)(189003)(199004)(81156014)(86362001)(2906002)(2351001)(14454004)(305945005)(478600001)(8676002)(2501003)(36756003)(7736002)(6116002)(25786009)(8936002)(50226002)(81166006)(46003)(76176011)(11346002)(66476007)(6506007)(6916009)(446003)(102836004)(186003)(2616005)(4744005)(1076003)(6486002)(66946007)(64756008)(486006)(476003)(66556008)(66446008)(5660300002)(54906003)(71200400001)(71190400001)(14444005)(5640700003)(6436002)(52116002)(386003)(4326008)(256004)(316002)(99286004)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2847;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rnzeSONcOL3+zeHGHhT9JawLaAVOBUb/S2kKw6de6dI2c9enh7ynOJ8Tiu5V73brF/p7B1rZH6hFuhkAuqZawM/8Qz2ce1tzWwI1GDIPZ2M2d0+dfQjjaGqE5UZn+el4msRvxhfQw8hdGjqGspZeYmJAVCmXM66yFzkjA8kNfI8hZK3+kIspc7w7/Dpjp/quyYurV3+sY0XTUFLAJmGRUoMEgpyujwIJYFwuXUS+/y+B3U3NCvjmzNVsWsc7hrdI9iSU7mgkhsd7XFiHxemFd2f1rWB30roW9eqquyoKS6893I1MBlWMYnzLjl5bqU2kaBospgE6oHfGTPsI57rLZM0vxZynW8C5+nFgBE+vjZNvA2VOFbZoXLhrB0CCuDQlKJDV1X8utGtBrizP21OG7TAHgwPV9PooxWsQuU/ajEk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 831b48af-d289-4e34-e504-08d7411f646d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 18:45:38.3318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uxXy8/7x37aT6eP0T5EBgFj6tz6+6POZNJ+6CJyl1nUEJp03O9/RyFIajJPCgAWpUkMwDStu5KVn+5vUl6aySWjABMlOOAHsFmshx5P64tA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2847
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While can_rx_offload_offload_one will call mailbox_read to discard
the mailbox in case of an error, can_rx_offload_irq_offload_timestamp
bails out in the error case. Since it is typically called from a while
loop, all message will eventually be discarded. So lets continue on
error instead to discard them directly.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
---
 drivers/net/can/rx-offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index e6a668ee7730..39df41280e2d 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -158,7 +158,7 @@ int can_rx_offload_irq_offload_timestamp(struct can_rx_=
offload *offload, u64 pen
=20
 		skb =3D can_rx_offload_offload_one(offload, i);
 		if (!skb)
-			break;
+			continue;
=20
 		__skb_queue_add_sort(&skb_queue, skb, can_rx_offload_compare);
 	}
--=20
2.17.1

