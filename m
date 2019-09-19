Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8E3B7584
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 10:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388111AbfISI4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 04:56:47 -0400
Received: from mail-eopbgr150041.outbound.protection.outlook.com ([40.107.15.41]:49286
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725887AbfISI4q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 04:56:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bqe6RgRZmHhkFYL3RZVQAIDs8HqZhZstvUcJIc/t+nexqPyRUZK1RDDLCbu/0RGdIaDiuU922e+w44wM74N0p5BuZBYNXkqH3o+07krkFe4YjJafNqgj2qzyBh5ce7vWau4d27IjIRIxhIaPnv1J7O1T2AmA8LBnjojicGnXwR9dbkVOLWfz8rXEdoO7m6oBzyi2n1mn1G3tsJehrz/D2TVxZ/iNabJilvCbU9WNh8tXX8dKGKwmMCa5MIBfc8Xr74xZPohBk4xy9kfs5VC7YisBNEefBLJYEhL5Idq1oOU+0mNDreVl/xYTTXQn++Cj59Z4GwsU+HFWWSoedAmpYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrXReV7uKCEzSlbnyMYpKr+re2ybvlTfNYcIoms4K9I=;
 b=flGuY6rE5X9WbOnTip3iObAPWCZVAjhZFbiHGL68CxtsJPhljciTdS0YzkqIFBRjfSqS1AsVRVnApm3hGY3kH+TaMttRHVDKe9L31MNfZSq43WMULSnf+jOB0/J0ESTbyoaS2c+6Ar6H6/q3XMoSwnuv+xRUbQsaIGpTRT6MZd56bQeCYoN++FjKJrC74weL/X7NY2s03v+XcGgB6QG/jLjZAMtbdI0hft1gudxDex1YHe0Ra9Up2reK/OIvgsyl/ATQ8XM9AJT7WVEN2s998WTSegENvdFvTmkA89eCk59yLa7rScb2W6cpVhcFeUDfAKXJurfY86Tv9r9vAIvVDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrXReV7uKCEzSlbnyMYpKr+re2ybvlTfNYcIoms4K9I=;
 b=R17LQrHHt6GGu9m+pQHJYFcmZi3MdCSxCIGP28gUqbsAxOitHYIGmfF+VRc7kqak6AVIzsj3WRq34isMmVbaZvzAFt1RGgwDubzJMWH/ihLBJai4CmuvcSD6Fx8eK4u9eLIZ4ADQ656ucSk4PM6pWu32KnbAJ/PhGG7Yc+/vLyo=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB3456.eurprd05.prod.outlook.com (10.170.239.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.21; Thu, 19 Sep 2019 08:56:43 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d%6]) with mapi id 15.20.2284.009; Thu, 19 Sep 2019
 08:56:43 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net 2/3] net: sched: multiq: don't call qdisc_put() while
 holding tree lock
Thread-Topic: [PATCH net 2/3] net: sched: multiq: don't call qdisc_put() while
 holding tree lock
Thread-Index: AQHVbfM2tAIeTAg96EO1D2Fq4LV40acyDL4AgACnqQA=
Date:   Thu, 19 Sep 2019 08:56:42 +0000
Message-ID: <vbfwoe4k6k7.fsf@mellanox.com>
References: <20190918073201.2320-1-vladbu@mellanox.com>
 <20190918073201.2320-3-vladbu@mellanox.com>
 <CAM_iQpV75h9npv2TbBMoRAMf+riPqJhAY2LaiVX-mrVGaUN-Kw@mail.gmail.com>
In-Reply-To: <CAM_iQpV75h9npv2TbBMoRAMf+riPqJhAY2LaiVX-mrVGaUN-Kw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0082.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::22) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [185.149.254.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b855b89e-fb6c-4d75-f073-08d73cdf4ae6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB3456;
x-ms-traffictypediagnostic: VI1PR05MB3456:|VI1PR05MB3456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3456DDBCD406CC11F196EC22AD890@VI1PR05MB3456.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(189003)(199004)(446003)(476003)(11346002)(486006)(2616005)(4326008)(71200400001)(66476007)(64756008)(66556008)(6246003)(316002)(54906003)(66446008)(5660300002)(81166006)(81156014)(8676002)(256004)(14444005)(6436002)(6512007)(71190400001)(86362001)(6486002)(229853002)(8936002)(36756003)(66066001)(478600001)(99286004)(305945005)(7736002)(3846002)(6116002)(2906002)(14454004)(102836004)(53546011)(6506007)(386003)(66946007)(186003)(26005)(6916009)(52116002)(25786009)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3456;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9fy+cCK4BSzbh1xg+Rx5esJ053MpW21yAEKyAkru0HEP54xwq/ntd2ZqXHRg1WtKRNn7s9Ke3+R/b1uJxXBFbRZ07/32TILm1QGz0qRrwCQd70ZL1n1KJtlxR+hHh+pyRztDScFownMq3G++fp1hNrTsU1VnBoAq4N7j5kfG/qBiGRnBUtz5V/UyrnpZpJgLFGmY6UCtP+Vqy6Ux+4G6ACljsLK1V2kGWhd7KGBTGX/qATXZ1eIs2pYiPmMrIO68rU3e+uEkKbQnMq3AV2QhV9DbVrqgMF+xEgg87qpL+r1SyXpIYWEaeRv+M2SEKfUmXwS7lkdtHzu50heeecKSdrnAJUIimw5cDvvRqvq+Rh7wILfe+lT3Tjb9RhW4EqxG40WpmzZ/T+J1SLL/e2Csb5h/+TpJTohlFpi4VPDL11M=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b855b89e-fb6c-4d75-f073-08d73cdf4ae6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 08:56:42.9815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FPSeiAtQ27W6SH6I/SJ8kt1YTvjJSDG7qKxve5sTLUDH2lWh6oW3oF3ESaGWnD7p50Jkl3+9I2HJ2a5+r9mE5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3456
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 19 Sep 2019 at 01:56, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Sep 18, 2019 at 12:32 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>> diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
>> index e1087746f6a2..4cfa9a7bd29e 100644
>> --- a/net/sched/sch_multiq.c
>> +++ b/net/sched/sch_multiq.c
>> @@ -187,18 +187,21 @@ static int multiq_tune(struct Qdisc *sch, struct n=
lattr *opt,
>>
>>         sch_tree_lock(sch);
>>         q->bands =3D qopt->bands;
>> +       sch_tree_unlock(sch);
>> +
>>         for (i =3D q->bands; i < q->max_bands; i++) {
>>                 if (q->queues[i] !=3D &noop_qdisc) {
>>                         struct Qdisc *child =3D q->queues[i];
>>
>> +                       sch_tree_lock(sch);
>>                         q->queues[i] =3D &noop_qdisc;
>>                         qdisc_tree_flush_backlog(child);
>> +                       sch_tree_unlock(sch);
>> +
>>                         qdisc_put(child);
>>                 }
>>         }
>
> Repeatedly acquiring and releasing a spinlock in a loop
> does not seem to be a good idea. Is it possible to save
> those qdisc pointers to an array or something similar?
>
> Thanks.

Sure. I implemented it the way I did because following loop in
multiq_tune() is implemented in exactly the same way: it repeatedly
acquires and releases sch tree lock for each new default Qdisc that it
creates.
