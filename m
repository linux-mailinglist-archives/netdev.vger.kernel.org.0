Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E2FB8B09
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 08:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394876AbfITG1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 02:27:36 -0400
Received: from mail-eopbgr150083.outbound.protection.outlook.com ([40.107.15.83]:35143
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389579AbfITG1f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 02:27:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOSSbbt4sH3hzBCLu1SpSnjVJCyz/g2K9hQ9g1Ugu507jP3MyFiKdQpt4nhE4R7+a0YbsQSQkABdhqlLbiF9cg3ymzJadLIi1h+8qqZgqmlvEY36Hn8qsRVUjaW7GbRDL3MA5mnPR8kAHUQ6EoUnbr0Df5S/vyEE7B88QZukL3Hv1BBRORsBOscfYcC8xElyPVQ/arurAYczCjJgdDzmYyMU0VlfEtFT5MXaOyr66f8bWN+aIHXK9zFHc33YZNHjiDuBGXk2iQf8ueshfHQbJwkaeP3YP2LwcbLZY/keU0EaYTFi5NBiUuhyXHznpBprJu1orNk7ciG/8DPckIZABg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8PvDXiirNeHHrLBCkXiSa3OU+woBbsTImqAsbQnPoN0=;
 b=XIMOSB0szjRgEVeZEgEduH80NFDyW3g73RaNvvM7H504ZhM6d10agDucm/3oFydHEYX0Nl3ctznEfSnA42KflCsKrv46wfOrDOkzu/6Fvi8freZvb2BlfMRRsBivaR8QbPssryDywVJauD1k+WsF4XhUeG7+lHBl4dPbKFTXtdPg4axGclqTS8GzPCqWJcs7i1cZL2+kYAyP7l39dKyxLjEq2uAqyyLqltYuFa5H21yIIXBVreFzv+gkKKEGdPGgxK4HyYgTjFeb/Q/GwvPYeVJeo/Wn/qzG5RauqKGk36T6ML8op29Zy438+D2PZWmGBx9NayndTMIYr9F76avdAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8PvDXiirNeHHrLBCkXiSa3OU+woBbsTImqAsbQnPoN0=;
 b=Bvkicb9FltHJ59RtxS+lmWUc0v/uvy9idm0PuXdrP2l21hiZYg0yiDFom8kKuUz3pZ8G/vzSCRYye0Z4Q4B0fxQ0FG1xoxibzXe+otS2ehxCvToos7zkFhjeHA7cAZ2UHSeeT+h+yuDK6ynJXSTs6BDQ1B+bz/g+UHoWelt8H1k=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5581.eurprd05.prod.outlook.com (20.177.202.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Fri, 20 Sep 2019 06:27:27 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d%6]) with mapi id 15.20.2284.009; Fri, 20 Sep 2019
 06:27:27 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net v2 1/3] net: sched: sch_htb: don't call qdisc_put()
 while holding tree lock
Thread-Topic: [PATCH net v2 1/3] net: sched: sch_htb: don't call qdisc_put()
 while holding tree lock
Thread-Index: AQHVbybmLrkbH92keUamoXeL+bDx06czwKsAgABZ1gA=
Date:   Fri, 20 Sep 2019 06:27:26 +0000
Message-ID: <vbfv9tnzdnb.fsf@mellanox.com>
References: <20190919201438.2383-1-vladbu@mellanox.com>
 <20190919201438.2383-2-vladbu@mellanox.com>
 <CAM_iQpWREfLQX6VSqLw_xTm8WkNBZ8_adGWE5PpTnVQVDBWPvw@mail.gmail.com>
In-Reply-To: <CAM_iQpWREfLQX6VSqLw_xTm8WkNBZ8_adGWE5PpTnVQVDBWPvw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0469.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::25) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7bb5450-32ce-4baf-3f92-08d73d939ac9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5581;
x-ms-traffictypediagnostic: VI1PR05MB5581:|VI1PR05MB5581:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB558175B0958A7C64A2BE3BABAD880@VI1PR05MB5581.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(189003)(199004)(186003)(76176011)(102836004)(52116002)(6486002)(6916009)(4326008)(25786009)(71190400001)(71200400001)(26005)(316002)(6246003)(99286004)(386003)(6506007)(6512007)(53546011)(5660300002)(4744005)(14454004)(8936002)(2616005)(476003)(86362001)(229853002)(446003)(3846002)(486006)(36756003)(11346002)(6116002)(6436002)(81166006)(14444005)(81156014)(64756008)(66556008)(66476007)(256004)(54906003)(2906002)(7736002)(478600001)(8676002)(66066001)(305945005)(66446008)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5581;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kFkMC3ajYYNNYfYlnRi0znThduqOnY4bdUOPdh4S0WhdHyfpREQBobwiONVUHGXY3p2odKsG+Mw7sTxzihjw2Uxmrd4PLb5Sn9gEFX+g634BpY0djWehhjcuzpI+r/plr3lH0RSs+5+IFVxYDfrsBUZ/vM//f9Xq6oDMD1tKjRIAhkskocPSuEMfxvRGgtb/e7wJBU/9zZwZ2s8Gsu+zN/n0GNGa2fQbjhL/u9kgqliDWRHJ+3FKAV9r1G5MzMKPcry6xrhjLg59+6exsizEipMFDSVLoBBIQpdPg86IPIwUxhLMPR8o8JEA32KAOmph1df0Q14NwDhQIAFQt/tHIDJu9coRvtNroSV8+D+OmaJ/sx9tkO5aKHTjZ0wdhJnv78z5NQu2I0C7ZMpF3MW1NKUhLNs94on6087kNYUfIEo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7bb5450-32ce-4baf-3f92-08d73d939ac9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 06:27:27.0137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 907rTSYsp/10z2e5erJP9XV5V5GfLqxy0uFZ6o5aWvSS5SaBxTqLd1shY3Mt1guWdwhJ7S1qoReb8n83mvgI7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5581
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 20 Sep 2019 at 04:05, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Thu, Sep 19, 2019 at 1:14 PM Vlad Buslov <vladbu@mellanox.com> wrote:
>> Notes:
>>     Changes V1 -> V2:
>>
>>     - Extend sch API with new qdisc_put_empty() function that has same
>>       implementation as regular qdisc_put() but skips parts that reset q=
disc
>>       and free all packet buffers from gso_skb and skb_bad_txq queues.
>
> I don't understand why you need a new API here, as long as qdisc_reset()
> gets called before releasing sch tree lock, the ->reset() inside qdisc_pu=
t(),
> after releasing sch tree lock, should be a nop, right?

Yes, but I wanted to make it explicit, so anyone else looking at the
code of those Qdiscs would know that manual reset with appropriate
locking is required. And it didn't require much new code because
qdisc_put() and qidsc_put_empty() just reuse same __qdisc_put(). I'll
revert it back, if you suggest that original approach is better.
