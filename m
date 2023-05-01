Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2946F3095
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 14:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbjEAL7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 07:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjEAL7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 07:59:47 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2082.outbound.protection.outlook.com [40.107.6.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286EA129;
        Mon,  1 May 2023 04:59:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GN6Os+00qLif2JOWPdPo54A8Nzc3W2dwJFaxTa/HqlbgekDWJKiK7u//Qd897A8V0TdN0MKDHuUcPM6JssaWs/p3AK1It35TOH2zqfO46NAIL9LjM8taKDk7EoRO7el9ZGrVG+HWssCqllGQ+ngrd/KzU0hXCk+EpWXMrWwO6qiezaXW4fT5s2zshb0UsBDVgbEAVyEF67qrcOJ+bR3d6o8F7MasJIeHqTU4UNMJIpDMmMgxpL5qjZ4Qpukpaw3Nu+Sn67xgM5Y2K88pXGxdhCUkQxvebKvCIqdJN/mzvEGI0ZpVWSbmPKHVg9SRYWUGZ4dkGl28t01VncvJT63ZGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pqOVRqqDdvT6gC3OjktoZVYtazR0wqxZGlCjS/tZAPA=;
 b=B7uBdnxvFoH0j9pJYbgvuCfGCm4yQfcWQBw6dQLl78LW529rMwPa7whlRaLqn3m34a1mVWQGKtydQYaZgKNt7819QdhW4Hg5Hhlt28S9CHJxuMJwDCyK3OGfoNOyh1SQd2KMiLTDbEnNTJ73lxIawpqyQ8YoOVJr5Sc7f3XFjepXwt/kEuABkShaF+piV9gCrFrofIuAkGggmQlEXiVL0HvOgRcKp7w4WEuKg24xsqnM1dhobVc6KI+/JjKQmpNuXbyOR6dehnaanN1D1wPxPD3giicx2WGle+GmoWh1yZo8zUwaKM8gzOcXT6/H5TAdZsW8wqvmVWwBCwn+oRCiOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqOVRqqDdvT6gC3OjktoZVYtazR0wqxZGlCjS/tZAPA=;
 b=X9nx1TCwX/V+dPL2rqetO1OjOAg1x8K6M0bNQWDXEnYwP4o7dyijfZOKZEWuZdsxaoObRjf4UzfNIyK7h1k8Rpd0aExloSA+vlQ1C7jCi+nI0ureDMINYbeHLx/jnJh/ulEWO+EBg4IRIwXOQob75MDHRTaW6bQ5ejOyo+tcqnQ=
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by AM8PR04MB7330.eurprd04.prod.outlook.com (2603:10a6:20b:1c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 11:59:42 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::a5ea:bc1c:6fa6:8106]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::a5ea:bc1c:6fa6:8106%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 11:59:42 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>
Subject: Re: [RFC PATCH net 2/3] virtio-net: allow usage of vrings smaller
 than MAX_SKB_FRAGS + 2
Thread-Topic: [RFC PATCH net 2/3] virtio-net: allow usage of vrings smaller
 than MAX_SKB_FRAGS + 2
Thread-Index: AQHZe2XXxDQ9u/7pQUe+LxobnBX4G69D4sMAgABG2xSAAQzMAIAAF+VB
Date:   Mon, 1 May 2023 11:59:42 +0000
Message-ID: <AM0PR04MB4723AA2ABCE91928BE735DEBD46E9@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
 <20230430131518.2708471-3-alvaro.karsz@solid-run.com>
 <20230430093009-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723043772ACAF516D6BFA79D4699@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230501061401-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230501061401-mutt-send-email-mst@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB4723:EE_|AM8PR04MB7330:EE_
x-ms-office365-filtering-correlation-id: 5d432eca-c2c4-4fab-14b7-08db4a3b8c9d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E2ok5GL9fOUTRulVySZgLlEe13oCrhUQ5MeM5UOa5UPta5n1eX8KKE1Z9GM1qmADdRGWhotKoQIMl9rk6as0KIc30Kdmxu2NKbrhlL+tfgXm6QVZyMeIWy/qLo/eLjeiHiU2FTRIQzhDrfc15BTOYmzhdnq43rttiGocEcyfRZrzCQ5NYi70AoLcqjvcAo5qT9OUuCpJZzgB/gE/3Z52ReqHcdLpeCBHruy+4fXy9PZ81Y5rhHKQHKj2Px0UpELBQfhX3Iw3848YNHYXriK+yxTZ+EcX0gegXt/G8dG+tO907Tv1BbkbVa1+jJ5lno1isyEA2Dt1ijkh4ceq+I/ZupIKPhEbsA6nUEC3BFgI8epMqeT0FJRDOgknJYSGtRVntcHDkD1QgzP4aLOsQyTvnDD1S568GW0nmU0mSaJ2v/ej5HHIk+fCTID/B00cAX3S9emDTD1KrE5AZmBvZj51F70MLeuvV5Lu4S7vq4SPbRbnAPSN9aRjkgiwKtvebY2FVj/68QCE1faTUDjM63ovvnGudyTt2Z/FdN9Oh6KYU/5nkzVSmtc5+wo9iQ+Z1eT/cfDu/GUMj9u97uSZemQHTM8l2BaXZzWQkZt9jL9fT6F3DMYHA8Ghb5TN8UYhqtN/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(366004)(39840400004)(396003)(451199021)(86362001)(33656002)(38100700002)(38070700005)(122000001)(44832011)(8676002)(52536014)(7416002)(5660300002)(66946007)(66476007)(66556008)(4326008)(91956017)(76116006)(8936002)(66446008)(316002)(6916009)(41300700001)(64756008)(55016003)(2906002)(4744005)(83380400001)(71200400001)(7696005)(54906003)(478600001)(26005)(186003)(6506007)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?NPtkR0gJK4593LfiluqVvgtCyB9aCR8s/IDIYf8eloXmSuhaAYnIJrT1kv?=
 =?iso-8859-1?Q?RTAygOOfaRg6lF53Y3980rsFWkNEAqlCfOOS+98DIB5W+lY8vh29OCbKBB?=
 =?iso-8859-1?Q?BY+0MYhQIIK19g24Cyfy3jWRp4UaZody7+aoyLTfBC1taDUPVms+E0W2lY?=
 =?iso-8859-1?Q?LjRCCjeAMASH/aI4h8uJg0SuuRPbyfALE/E1BTjTWN7QwQYyjYi0S/BMty?=
 =?iso-8859-1?Q?W+qxeKODX0Mwm+5xceKBm7ZuqqvfBwwp2vRYMbOYVjJq7sgLilqPEROlUU?=
 =?iso-8859-1?Q?orBNup9Px7A13DNFMLDHq7C7XXQApcCdKsa52OpjtGXcck8FyUOs4ZJXk4?=
 =?iso-8859-1?Q?03rGRqSZWSshBL4AM4kGPqBsvNHXPryWbDjPOairrSZ2ygwElVxs1s0QQd?=
 =?iso-8859-1?Q?fuZxaWy7m7SfBet6lGOj0PfmenYBccubxSZ853+rLno9KQl0VeSsnHWz1w?=
 =?iso-8859-1?Q?xqd1Mc2WSHSYMuTJN/GJS5D/FVFPSd2It5Fhmn2aD/hiLHrZJmBsj+uAWh?=
 =?iso-8859-1?Q?/Mo5aM/9OfQzwb8DkMRL50WwEJgVsc3ObIr57Bt9uTy9gUI1uVPxN35ILA?=
 =?iso-8859-1?Q?MRu/AkmA9PVwqJkQsfh2NfVlbyiLtoQEmsTpvG5lz3dKwLwVQZZ2mgiuon?=
 =?iso-8859-1?Q?sdlRvTmEORCRs89xmzX9Dhg74jRlZC4Ehd4ieN18R0VstHZGSl34a3uCm2?=
 =?iso-8859-1?Q?2JR65o/pTS9eyI54ZqLoyesT+XWOhaLWKJns0jQXULizmAPANP3SeJhKp1?=
 =?iso-8859-1?Q?Bs630vf8ICmGKtplUmjN6irFuV6Xgt54033qer7YtFdS0Teem7oTRvI7Hl?=
 =?iso-8859-1?Q?T2tnCTLWPhusEkoPfBtHElnq06f1TtfcH1Rf3FcTGOy29sebqQGc6WJvv2?=
 =?iso-8859-1?Q?KJKXP0b+MGf3S/TQR7a5um5/QXjYA8WSsNJI4KeH4cTYUTHd0KYOpqg+4q?=
 =?iso-8859-1?Q?HrNDUysUrWGQigqWGwX7/SnDo3bvGjhZgLVH49F3kzEryK4cYJDWuJ8q+B?=
 =?iso-8859-1?Q?ln24E19it05r8d5MACZV9XgAGiPHlPOiamlx/Ybl8djrGWN363QMTBalWq?=
 =?iso-8859-1?Q?DwrcmQs5/HCj/GbSKK54lEwV7nVOIqWsWlx8ot7pqKQBUXB9FTFAoPEKlN?=
 =?iso-8859-1?Q?Z0fZCGXeHq3msIwh/Deuhd+Y+plEJbMIkBjHI0aMCviZPvDHWUv1p5Kbl5?=
 =?iso-8859-1?Q?C2CKJwu5u+SfiMdnyllazG4Q68VKIzPDiJDmrJvlE5LCPUcHF+UzkHQwqF?=
 =?iso-8859-1?Q?OZK1CsMpyMuBTKGBSfF/NRHNEcUbK1+umjdMCRV84LC5O0xYBE/hQSGmv/?=
 =?iso-8859-1?Q?LUSmHodD6F2oljLH/awYmoHX0OSv4WtMXkQN3fqc4eat/23UwFKberPEQi?=
 =?iso-8859-1?Q?HlF0MIkw/N7oPDLe0ieC/OyS0Un3InpfTMO1af4/i5KT+JZCz8lRp36ukO?=
 =?iso-8859-1?Q?arNDc71j82Ey5pbgVEp1vtJJpJ0XglQKUeoY5xI1twhfWwYM+SGPaSlD1X?=
 =?iso-8859-1?Q?fPQ0P8fkBgDdBo2mgJlZ6t5so+kHUUG0y5S1TB4S9k5cd8gq09tswQGmA1?=
 =?iso-8859-1?Q?H3/iL4u0v6HqTbcegj4m+c6YnuExJEExFU8uasswZCFdmSyqgSh6Fd/qYX?=
 =?iso-8859-1?Q?0SSBJvOTyiUD/WvONJZsEkTwCtJQj9jCM4?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d432eca-c2c4-4fab-14b7-08db4a3b8c9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2023 11:59:42.5387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NhtGWMA7HgYRVWJqJoOpWBqSUeW/OdByZeZP8CRvbTPmZCXy8Un/W+6wtlm+Z/RI14dZRc9QaB5aQ2GwsDOVxNb1G9j/JIGrKzLM2LI1Z4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7330
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> First up to 4k should not be a problem. Even jumbo frames e.g. 9k=0A=
> is highly likely to succeed. And a probe time which is often boot=0A=
> even 64k isn't a problem ...=0A=
> =0A=
> Hmm. We could allocate large buffers at probe time. Reuse them and=0A=
> copy data over.=0A=
> =0A=
> IOW reusing  GOOD_COPY_LEN flow for this case.  Not yet sure how I feel=
=0A=
> about this. OTOH it removes the need for the whole feature blocking=0A=
> approach, does it not?=0A=
> WDYT?=0A=
> =0A=
=0A=
It could work..=0A=
=0A=
In order to remove completely the feature blocking approach, we'll need to =
let the control commands fail (as you mentioned in the other patch).=0A=
I'm not sure I like it, it means many warnings from virtnet..=0A=
And it means accepting features that we know for sure that are not going to=
 work.=0A=
