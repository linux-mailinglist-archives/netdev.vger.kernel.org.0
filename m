Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9B636C83C
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 17:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237169AbhD0PFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 11:05:10 -0400
Received: from mail-dm6nam10on2137.outbound.protection.outlook.com ([40.107.93.137]:64311
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236510AbhD0PFI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 11:05:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LF8j+bSGH0X360RbG/9RxHWmllVzjtf1NplhtKJVYV6DchmCF5p7t4mOnCJczUAl7VTRU/LhHiM3N5ked88xE3cRANbMiArn4Fjzk16EJCKW313ukfjD8tEgRoWvPhjz/dmzapMdMw6BHYmWZjS+ZyxBOm6Qlwn0HwKlKrpq3aXqKLrCW9jj0bjXqhJRBgQ+fAkwGB8e4qpSAezk7hKI+K6P6aE6Dcju+iY2RAK+fixVWKwTERAC13ENZRb2VSRaq9tBIeiymGLw3Y3nPnPyaBo+Wq8ujdJRYd13XHeeVbhPl/Bq1IAak71drVkUPUorovs0GDV+hl3c9kFTUmkGJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQEf2ds4qL2kJAtoy+SEu32Aijb/yFUM+4XkOlUBe24=;
 b=hWtupXoOQTrSF6Jw2mioroXXxPbnUrJDXXmmVdi4owLTm8MR8Fg0jZiqWNQ9dJv+BH+OCPVQJtHUHX1nOTapUE6OaZSb5WT79UuzNydIUK59SQ4fRCvDkCBRas6Nkbb8z63kppDGhvoeeZwI8QnVo3wZjMa1irUXaXlCthocOKa4irGBEme8Et01SswBNWTvrJ0hz6s0Q8qP8Z/E2bqfNfQgJ+qZgDDC9JSd22ysKh/gnLUhYmT7AVg2/IpyIEvQ97qvY4csMr7h8+7fGwZZxPUMdgbtlFToCdQjWpedw2nViy30c9eQg1TMXV5E9+s9H0mDtGiX+XbHkUkPrLyMew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQEf2ds4qL2kJAtoy+SEu32Aijb/yFUM+4XkOlUBe24=;
 b=STRT74I11egeb+abBOwPEyjXbWgXpZtQ4RDOI9XFkJuuBt0FEzF/EpZyzOt6fLMVPKnBI2wJscZm2NUrIwjz36X6CWD9JBU6BmeXBcb4rJnv1PvHztqY37yPYZbZuQsnbpK52v5ERyyWEq0N0fOxo2GHzORZnTTcMncxdCUOvTQ=
Received: from CH2PR22MB2056.namprd22.prod.outlook.com (2603:10b6:610:5d::11)
 by CH2PR22MB1927.namprd22.prod.outlook.com (2603:10b6:610:88::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Tue, 27 Apr
 2021 15:04:24 +0000
Received: from CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::fd2f:cbcc:563b:aa4f]) by CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::fd2f:cbcc:563b:aa4f%5]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 15:04:24 +0000
From:   "Gong, Sishuai" <sishuai@purdue.edu>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "tparkin@katalix.com" <tparkin@katalix.com>,
        Matthias Schiffer <mschiffer@universe-factory.net>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: [PATCH] net: fix a concurrency bug in l2tp_tunnel_register()
Thread-Topic: [PATCH] net: fix a concurrency bug in l2tp_tunnel_register()
Thread-Index: AQHXO3ac64eM3ub0hEqWIjodPrdosg==
Date:   Tue, 27 Apr 2021 15:04:24 +0000
Message-ID: <1F82E994-8F0B-499F-BA1A-8F1B2EEF1BF2@purdue.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=purdue.edu;
x-originating-ip: [66.253.158.155]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26953e8b-d106-4062-0406-08d9098dbf02
x-ms-traffictypediagnostic: CH2PR22MB1927:
x-microsoft-antispam-prvs: <CH2PR22MB19279F4C23CDFB7A3234F84BDF419@CH2PR22MB1927.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: efWsn3+NjlZe6afWo/NsOEIeRVptsqqeFW15UnkIvImB8GJkxu0sSISGTBSI0Y1nyCA4mK500fmaH8g/hZD8iDLv+/TX7cwNe0ZF0K5amVvZqkxz9MCW4Ltu3O6+xirWjsm6THI1CSjFS2b5AkyxnLYSA8IyH7HReVEXp7HcLIut6jr9yIiuOu7v8iU6dTtqHg2ZYKp61eAaY7o3CTTu+y41oDC+8mKmk9gcc/QFu4/80UYrj/bAB4sayVjh2F4btohlroM9hi5ScPrmLE9aywmadoc3gRt7ODty4S5yvficaOgPnVp06hQ6Tm02luha0Q427QV+qlBATgaFpBGdsmB3WY8xjez/bsZqubxsd6MZv/Gs5AmXXd7PG3vJNHqULBVxuPR0MduhCoKNwtJmFS96hOfHcQ1x00/PJz7QH7G2f+EtoJSwvHGNCb/z5TeGKooHng/4R9x4P21phb5rQQ56RyQGVPmhXximrh/FMzEj96K+fC6F1ZRYBSi8wD4Sx8nW1RDNM+/iOnpb8ZsHVRqF6qNLUHF2ty1NNP/hymDRe0v8WUo7nz2sVun+p/EIdOrd+Mx6u6gUxGFiGh+He8uYTmWrTfemWKxjsXZCbxuX1mnYpIw5LP1wOMqMMKc8rUtKII0lyVLz90DsGRcJVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR22MB2056.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(376002)(366004)(346002)(71200400001)(478600001)(83380400001)(6506007)(5660300002)(186003)(2616005)(86362001)(66446008)(66556008)(64756008)(66476007)(76116006)(8936002)(66946007)(110136005)(6486002)(786003)(316002)(2906002)(8676002)(38100700002)(122000001)(36756003)(6512007)(33656002)(75432002)(4326008)(26005)(54906003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6ZTdwRd6RhhlVKOqNYCBQVn29PlvzrgWg3xtVo45qWMqoFEkYgHu/xkfuIvC?=
 =?us-ascii?Q?GexHEya7+y2y724AfmR1hobB5MgHe/swzGY8dc5vCIRI35PvLtFg26flo9ZO?=
 =?us-ascii?Q?doDv695xvLOXEAegNdIF4+T6FFkbpAE6LOhV1zYsXS+MEraCscnIt9WO3Wyn?=
 =?us-ascii?Q?Mh5lX2MFdUjdoVnpT5ameGknsTIad7SWpmeMrnCXGY/tbDdAJdUZOImMltQa?=
 =?us-ascii?Q?1qz7pDa/C8ugg/DENR2cSxJeWjrwXsAAxrvZN92KvuXuioWQmmufV21MYKIj?=
 =?us-ascii?Q?AHscQdr6YMCB6Mw74LMGozfHOrWbJRMrbILJRcamyZtmKLQ0JOXy7a96X69d?=
 =?us-ascii?Q?fqJUzkKwtoM1dGVU3UIyJrc2zjUREwHajT9Yd41u57OP0owFTxAgqvLRpO+k?=
 =?us-ascii?Q?weQUnjWrXaTjaFZ6nvoKBHz1EgFVq03DnVoe9G28zAm+uQGAwEYELFqKRX/R?=
 =?us-ascii?Q?FFys7Nmdw8aw+6bm4Ssbk9mIEuYV8AaU5luBZ0XqDBtZktIZKCwMsWyIvjeS?=
 =?us-ascii?Q?UAH51o37bHfuKjeMwaj2en9FCBFo1XJGy5aRF+SG6YtIahDKaoshiJPQ2fRJ?=
 =?us-ascii?Q?pUXOvXZatyd0bUxVSxFmvMuQDMy7UV0ES9aUf7jSsARyAuVOnDmT2586IfLN?=
 =?us-ascii?Q?NmNOo9uozhKuyppfYuVoJTiBidJSgruz7/M/LLNyF8lnA6j6sfJo3hFyO/Bs?=
 =?us-ascii?Q?2xZW7EmyG9GsQ4aK+49l1b9KPPgFyoGeYakLlwc/MzcbY8iDWj9VTCKpO5Il?=
 =?us-ascii?Q?/zamOKTvV5EK5Nsd/pIu6EgDqfzUcKNzmC9YovZIflgDuZbxU+0wbei/ij7K?=
 =?us-ascii?Q?gE/ThdHpWeasB1CVglA6aj03O/h6p/sBSp35zb7P9OK90T3pLq/jceuE4+hY?=
 =?us-ascii?Q?9WvJ9KoXYzT5TiHn0x5a5a5TxzWdzHbGHimhGSCkoRiZ3hSTe0ucBHAcJMDu?=
 =?us-ascii?Q?yoR514vqCpyXtmTg4NQ2jhf5+V7ulOcsKAn8xN9gjBohUVmVrlMdDxwZl8aW?=
 =?us-ascii?Q?EgFMoJHLxGoJdKcsKVWs7neS2/Z3OGBoZxi8v6c3daV4YCm4x+Bzl2l1nJLl?=
 =?us-ascii?Q?iM865Xf6hgU6eKpTjAuFEoDvE3tdf4igmlMfGCkeZxlDxhdsRSSVQ14HAMRC?=
 =?us-ascii?Q?xdwgAhvqhHetX4jITo6J0CTP933npRl2U//OYEwg+TwYdB6VYhALl4G6J3A/?=
 =?us-ascii?Q?oK/ZpKmpw6y0P5SmKAME3DB3gSZmSKcuuvZsxjRgo4PrQLnWq032ylGX2uj3?=
 =?us-ascii?Q?2D4JsRiQtwdIpXD8uWPxgEfzEOxu+4foJAvRxmhwDjlzKH2NMgGmG7IG1sxw?=
 =?us-ascii?Q?LbA5jbUcmF+dmvzzbd+wbMbQ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1D8215199FF60F4FBA62421209AB8F57@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR22MB2056.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26953e8b-d106-4062-0406-08d9098dbf02
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2021 15:04:24.8378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AcxvufqgTMBb4KxUGWCxkdAd4vkRZ4Uh0BOpUrw/jYbthSOOOIbvDSWTVQKfmfXJTYgw5NNK3reqsf1XYv/b2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR22MB1927
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp_tunnel_register() registers a tunnel without fully
initializing its attribute. This can allow another kernel thread
running l2tp_xmit_core() to access the uninitialized data and
then cause a kernel NULL pointer dereference error, as shown below.

Thread 1    Thread 2
//l2tp_tunnel_register()
list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
           //pppol2tp_connect()
           tunnel =3D l2tp_tunnel_get(sock_net(sk), info.tunnel_id);
           // Fetch the new tunnel
           ...
           //l2tp_xmit_core()
           struct sock *sk =3D tunnel->sock;
           ...
           bh_lock_sock(sk);
           //Null pointer error happens
tunnel->sock =3D sk;

Fix this bug by initializing tunnel->sock before adding the
tunnel into l2tp_tunnel_list.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Sishuai Gong <sishuai@purdue.edu>
Reported-by: Sishuai Gong <sishuai@purdue.edu>
---
net/l2tp/l2tp_core.c | 10 +++++-----
1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 203890e378cb..8eb805ee18d4 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1478,11 +1478,15 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel=
, struct net *net,
	tunnel->l2tp_net =3D net;
	pn =3D l2tp_pernet(net);

+	sk =3D sock->sk;
+	sock_hold(sk);
+	tunnel->sock =3D sk;
+
	spin_lock_bh(&pn->l2tp_tunnel_list_lock);
	list_for_each_entry(tunnel_walk, &pn->l2tp_tunnel_list, list) {
		if (tunnel_walk->tunnel_id =3D=3D tunnel->tunnel_id) {
			spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
-
+			sock_put(sk);
			ret =3D -EEXIST;
			goto err_sock;
		}
@@ -1490,10 +1494,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel,=
 struct net *net,
	list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
	spin_unlock_bh(&pn->l2tp_tunnel_list_lock);

-	sk =3D sock->sk;
-	sock_hold(sk);
-	tunnel->sock =3D sk;
-
	if (tunnel->encap =3D=3D L2TP_ENCAPTYPE_UDP) {
		struct udp_tunnel_sock_cfg udp_cfg =3D {
			.sk_user_data =3D tunnel,
--=20
2.17.1=
