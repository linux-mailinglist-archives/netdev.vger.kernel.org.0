Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 209AFB8B24
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 08:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394924AbfITGec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 02:34:32 -0400
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:50818
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394916AbfITGeb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 02:34:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JxV5WPWi00wPjap6Tpdi+R74u4GflT3kosSSVps8+d6x8xGB0iyCcKzC/zh5DqG5I0My3YXTzbRO7G+/D6A+V6VmmTGI/erltbXc2IurJmh6Pdxr2orp6OpJtRHyTAXiJzE0NjbR4rvrLfNTnsOKOqVP1ulD8tVIcY7xHdn0FISB5tlkl9n15dXVuH4vp49/fsLay/hkU8WoFP2o+0CZPFQH5K2FJiyl05dnrEm6a8YHdex3LW/HOBnwQKMcQiujycPFtex9dO/WtS/PjbmHucM46aQsKGOD/f5b21THflb6C5Bw6Pt2dTqrAkOOxAJijXZkPyUw3i21ZjAXlJgOkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqfPkmKBsOo86V14ogn5xAijq4th6OGcyXsTEEVAanA=;
 b=VFfy8wPj10bXktk16b2iGwY1gPleTmYNd4LNoT9VZR3d3Fyv5B7pvH1mE7JqrHW5QUY6oGBhGAfcpdH3J62Npb9AgPdugXKr8/+0+VnGmfSEuI1Lq8191jETQg4W4oZD5IGF7iZ9ZYEXZIfVnFy3Su2RrtljcgwPjU56KF5M2Cuh4WlboYB2Rh38C7Ab38Wm4g1ZNZsfUXxWFyusXKgDsM2m9Fx1FIwQ6E85JvY+P7JqHfS0gJoLJiumO6gQa3NbRjK7VAqD+a+ttijWV8sUm3UK8TRH/0nuX+eUH6AQupsgYPihY62soDI0/lVsUcarkHmrWj+6DhoLbeJDGf/vcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqfPkmKBsOo86V14ogn5xAijq4th6OGcyXsTEEVAanA=;
 b=mvOiap4vlRDCm8Icz41sTYpkhd3PxF7Z1kIuYuBq6HSOjUC9BF2KhK99a01wuRiFr3JEb/aAYqAQ3AAAg3doJ+yZptconH8Hp8kRrtZe15FVylI/MFw3Ck9kCKf2GE2DKssE/bFt6EFsGCiOWaoAndl79F0Rj/T6JoP8gcrBiyA=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5581.eurprd05.prod.outlook.com (20.177.202.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Fri, 20 Sep 2019 06:34:28 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d%6]) with mapi id 15.20.2284.009; Fri, 20 Sep 2019
 06:34:28 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net v2 1/3] net: sched: sch_htb: don't call qdisc_put()
 while holding tree lock
Thread-Topic: [PATCH net v2 1/3] net: sched: sch_htb: don't call qdisc_put()
 while holding tree lock
Thread-Index: AQHVbybmLrkbH92keUamoXeL+bDx06czmsEAgACB1YA=
Date:   Fri, 20 Sep 2019 06:34:28 +0000
Message-ID: <vbfsgorzdam.fsf@mellanox.com>
References: <20190919201438.2383-1-vladbu@mellanox.com>
 <20190919201438.2383-2-vladbu@mellanox.com>
 <66e68933-a553-e078-b92b-6f629c740328@gmail.com>
In-Reply-To: <66e68933-a553-e078-b92b-6f629c740328@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0102.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::18) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26996a11-8203-4327-15b6-08d73d949626
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5581;
x-ms-traffictypediagnostic: VI1PR05MB5581:|VI1PR05MB5581:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5581A901C3CA1E926FCBC775AD880@VI1PR05MB5581.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(189003)(199004)(486006)(36756003)(11346002)(446003)(229853002)(3846002)(6436002)(6116002)(476003)(2616005)(86362001)(478600001)(8676002)(54906003)(7736002)(2906002)(66446008)(66946007)(305945005)(66066001)(66476007)(66556008)(64756008)(81156014)(14444005)(81166006)(256004)(71200400001)(71190400001)(25786009)(4326008)(6916009)(316002)(26005)(186003)(6486002)(52116002)(102836004)(76176011)(5660300002)(53546011)(6512007)(6506007)(99286004)(386003)(8936002)(14454004)(6246003)(4226003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5581;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: E2dgkzyj9p4E3BSZ0q8SleepgztMNBlsiNM0MgyV1iSchPaSRIc/9DyJgfxRLyfxrJ07jPkMrZJ6NDTjSPHtiFBHeW88NPm5RmU0I1A6A3v+2XlZ95bsfbQv1vr4EbVmSVd1wyRz7WY5ikrbY2DnR9YTmA8uOMqte3xM3myEloqvUhNKJx/nDAqR4JdM6aYer89g3HrQa+U8H3u0OkIFt3HQ2QjdZh+vr8dPl3uDZ4A+mp+02JJLsFx92+/bBPRaJXVicDqstEYAm09WydBWDCfNS9uQZNI2u/L3583VkEtLmcvcoE47AsspX6z/YXy5RosWLnfP0zBm4I+xRKq4yMF50aLZ8ah9TjVID8whlP/fzKzfcPGGxndzYePIy5tVsfcOsNt7IeC3cDA5Okmqgbe8WQArTb4WoAFy7U2cYG4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26996a11-8203-4327-15b6-08d73d949626
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 06:34:28.3244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GyrNMpjYJkKr/ZSxi8cZkVlcLvqQz/92wt8yMzXXCVojGGnOh4+6lV9RxhuXCjd2+EDUEyAx2Q9WqNUIda0EbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5581
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 20 Sep 2019 at 01:49, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On 9/19/19 1:14 PM, Vlad Buslov wrote:
>> Recent changes that removed rtnl dependency from rules update path of tc
>> also made tcf_block_put() function sleeping. This function is called fro=
m
>> ops->destroy() of several Qdisc implementations, which in turn is called=
 by
>> qdisc_put(). Some Qdiscs call qdisc_put() while holding sch tree spinloc=
k,
>> which results sleeping-while-atomic BUG.
>>
>
>
> Note that calling qdisc_put() while holding sch tree lock can also
> trigger deadlocks.
>
> For example sch_pie.c has a del_timer_sync() in pie_destroy(),
> while the pie_timer() timer handler acquires the root_lock.
>
> (there are other cases like that, SFQ for example)

These and other examples of sleeping calls in cls APIs used by
tcf_block_put() that I described in one of my previous emails make me
think that putting might_sleep() at the beginning of qdisc_put() would
be a good idea, instead of waiting for syzbot to find correct
combination to trigger a crash.
