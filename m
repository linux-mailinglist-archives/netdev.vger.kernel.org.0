Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7655F1333
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbiI3UIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbiI3UIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:08:00 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140043.outbound.protection.outlook.com [40.107.14.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923DF1730EA;
        Fri, 30 Sep 2022 13:07:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKUtrsA+fG8/7Q8XnLCWEvaTa6kSyZAkFlheXtDLc5R/GH9RShLop+Drj336ptU+FSkMCD1lIdm5fV25BDJkz+A7aeVZK8B90Vj3JC/mLU/8TCs/bYIHOev2ueRhVhGSx90zqVybWzjXpj6uaHiP1LcSHVlpfHkgss1skgUE6PaIKKO5iD3eWJORBy8OwnfpUJjm57bg1ppR5PpVkMpGC5BrY56m+2EfQgCGASarF5maE6In00hjwh1Vr8bweGd7xg5tjQNlKtjF9LypdGsAjfXknoEvBS09p55omsSCaMcPgcYeAQ+jcb/S3LYATGNB1AD/bvPU66Jl/PCAlggHrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EMrsfw9TMAHA7nzU5P6Y2jA/KkdPqu7WYre1EenGHF8=;
 b=nJkpFT3Hfj9+Vw7bVBnPGfXg3B7LHHSedIF7khVJ8W08eDKb6xezWNh67chZAx8zsdi+uda/Q8R5HBUMuVax8//6VFgoDKQ1CbC1dZuKdfvhjEkL3uaJWcL5tdWAesO+NuFhxsVP9HyjXldOg6BtGJkVCclWgyCSGSkDjT3snI8Ul3bmUusxme/pg7310xyKyDeiN+aKAHB7sUDXDgZULu6QDabKKGeD84lSKKZAfdqdvKAtY91YqpN6R47SKSJgXte4n3eT+COcPr9S+IyZujXERYa6kmabSkidG/HcExCQqfFJFIefOEMNU9Qej6dGsVYUHv+/FClIn9cF/UPN1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EMrsfw9TMAHA7nzU5P6Y2jA/KkdPqu7WYre1EenGHF8=;
 b=qLu4zRKnyUovmnxOlHzd/tyzWxm1rLOD7lgPT6j56K4qD4742P3yj1HYYLA33MxdKWT4ED/svu3pNiiqxT26rHAsGulalZsjPKVeMaDke6ThcbkxmiRNa+tzhHYqRjQQAzdE8KvkNSyWgzQpltVHCUANRRT6cxx8gpxYEDW7X2c=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PA4PR04MB8064.eurprd04.prod.outlook.com (2603:10a6:102:cf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 20:07:55 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f%9]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 20:07:55 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH 1/1] net: fec: using page pool to manage RX
 buffers
Thread-Topic: [EXT] Re: [PATCH 1/1] net: fec: using page pool to manage RX
 buffers
Thread-Index: AQHY1QQs3moef3i30kelaD3cHlhvbK34Zc4AgAAAZbA=
Date:   Fri, 30 Sep 2022 20:07:55 +0000
Message-ID: <PAXPR04MB91850A034871650CB6C4F86D89569@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20220930193751.1249054-1-shenwei.wang@nxp.com>
 <YzdL7EbnULEA75/s@lunn.ch>
In-Reply-To: <YzdL7EbnULEA75/s@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|PA4PR04MB8064:EE_
x-ms-office365-filtering-correlation-id: ade864d7-cfd5-4a5f-7958-08daa31f765f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BjCUn6Pw6gmFnERSwgJsiKsnym3rNOTrUZu/BHKwRGPc/SYvKOnX+YvASb+jXI0McpIa9r9uMbLMJlcrHy0BYKGI5AN5/huxWNyDcRtFn/r1hTMK5GPdO09k86LSm+KEa00KINLqRgTh4TqBSlzls7YVxn2PcHzf2Dh6hV3/fnRyo05+cbnUOZqF+NhPSUzc1h9oqlwXKDF/+QRaawJOGPGRYUvL+DbcgbuZswaV8bXSuu7c2W2UmLZ0wU7Lr3FlAfGMiALuNBw/Kc8t9Ehrt1CxV5LW0NYiiG++JtSTgNHZwuAgNL/gNSs34dVDLdrR9ekXIuzeSh3zDE7tF34GYNXQ0yU+e2xPbOUQTvoU8AFlnrqwKksfaOoi/5GkBTQ3hu/my5QfvCPAD9R4PS1kd+XQL6s8za59WBz5zdQVrUYNvlcHg01d/8IarT0Ilu4LRpDnBK34/2ZgmGn3Z6z/c8KhTu9oapUonzqQ6LkRI587RQ2E63Fuz+8lYdHAKwiRRpQlTstj8Tf4WiUJMG6b2Lxh7rL58SxmKR8ztnsRm+gOV9LhPQXuZh42ry340xhjD24LBTw7YRQ0CXAfO8PjpfgXwI97oyaPnPi5ABrv769mUuTFr+o8srTCxzmc+rTe0wDCepVwYzy7sf2i8g3XVybtWFmLAwhZKVggXoC4uBlhqxnAvp9YciGTA0k/kL2egi8eDoPUEFM30ILMtD/Rd+jWmRA1hWOFriS6ZUYplH4hOGlFX/o8jgtOOp9PXfNB3daIcvdQf6vgtgd9hVReCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(83380400001)(478600001)(55016003)(71200400001)(38070700005)(66476007)(26005)(52536014)(33656002)(8936002)(2906002)(38100700002)(7416002)(186003)(4744005)(5660300002)(44832011)(316002)(41300700001)(66446008)(8676002)(66556008)(66946007)(55236004)(53546011)(64756008)(86362001)(4326008)(76116006)(9686003)(54906003)(6916009)(6506007)(7696005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LHbYUp7h1an/JdLcgEDF9KGXWk/t+2w5AopwVejqy3xHHUn4QBzSNldWjk4L?=
 =?us-ascii?Q?Rj05NLbtvdUAFTljlGAFvUQ8EqpadyUlsaHIg3H39kHb+5eJrD5IQ5SUZhrU?=
 =?us-ascii?Q?26tBpyFM0UJjwNnYcNB+KVBQukfyMjohxONDJU0W2VPJeBBZWRctS8L2KV2V?=
 =?us-ascii?Q?Sj/k2HVMGehMxor392U4fX3MzPyrQbXjOgBYNqYlo85nYsoS1qMdazqyrxm4?=
 =?us-ascii?Q?gknHIHwXLAIHhOIn8S7BYL8sN5VjJ9npPWnaqH1Ek+JriB4CdRW83LpCJzq7?=
 =?us-ascii?Q?R1SBW6ayZvrdcdcb7gfa7Wq0mrBfytEI3EEouFfPsrULd9MJztMv+Co74xU1?=
 =?us-ascii?Q?LjI9bj7rIFFwkXLLkv9NGsLSRI9/Vcu5+JdmliO9zkg7XCbcSYimO4mYz2pS?=
 =?us-ascii?Q?YK2FjnLaC0N6aLPdGVX8KAT3dQv35z2aoGBu2ohU6g5IaO/MS2APAEjVVRU/?=
 =?us-ascii?Q?dHTw3sXKWOjS1hIfQWdMjW1znljwCsSWNfjWt1996xgbPFbdXk6PGBt0Lb8F?=
 =?us-ascii?Q?NnpPTSkUQfxHQqP0vltaEJczHc3Xm21mscYpIBJNZn2XUlJoIjgX3zTv+M4d?=
 =?us-ascii?Q?Di+Zv0K95cOLsM92/1VK33t269MIIV1DhhbzNLvEK6rbZMhreHVVp9wLWOsj?=
 =?us-ascii?Q?PA9lvOEi2+CcxCX6rX0tm/kaovhqSD3t+jFB1NpwxS2T5hLEgeXnG44TUYtQ?=
 =?us-ascii?Q?Rz/W9Y4jpfaxzwAzKTnt8RKK6V1tFp2PhRXYgF5MKh++ZuK2gYdeDWeyzylN?=
 =?us-ascii?Q?iavShQRUAzA9iCzU+WXyWN4V8+acbKFrmvChAosc0B9jgZ/05QiSY2ZEij9B?=
 =?us-ascii?Q?Nyj7s3yf9MUjxHQpPs880YiWHqqCBkKC6hh10uOGTDI0vsmN79g/3W7OUQUU?=
 =?us-ascii?Q?T2Mqnhg7WsE4HieUwVzUnK8VnZa4ubE6GB9JG1aD8w7REA87Gkt8AE/++e6m?=
 =?us-ascii?Q?khHmYplY6YRwR37BVRNwUcEsLZI8zLlcqNxI3dEWlfy/77v0vNiqAZ7gg5ff?=
 =?us-ascii?Q?70Liy2luNzxQBE1Y55RxWCw5UuHEc1LSM+jjjwpf1WebWiZi3JU4sLsj1p/8?=
 =?us-ascii?Q?nxu+0CBmBswA0Lwwb4IycoX4n4zoOOQ4BoDI43at7ZCma9DWYfJKaPN6YmBm?=
 =?us-ascii?Q?zczkDIDsekSypvEdyIM9zngW/bT4fWweYA0ZYq9+gV7Gvx+pZVsIO/A8ftnM?=
 =?us-ascii?Q?JQZw0XxaMbkZnLbuuHD+h1tmdPeaLw5XT4r0frMM443/Cui5TvKJ5yHGKmiE?=
 =?us-ascii?Q?rV+YSqkqyVDSVc4fvMIlLoRaWf6PEmvujFJNahZ1CIKNPI6Tp4id6tzyrxdW?=
 =?us-ascii?Q?231Ys4BmHepnArXUfRkYE6DH4AHWMGzPwP9GEZqUCEBRq5L4xDy+CqLkGZ6p?=
 =?us-ascii?Q?ZlSrpjpzefnUZ1zZyeR7lLkXWAFfAwpLjemIeTxNyMQ5+2oBkIww7vCjRGao?=
 =?us-ascii?Q?b35w/y3GNOzqXHrep9dxjyMk8EHr3LJ2/8E1eeuXm5PF5qfbsEKlzpp9eW5K?=
 =?us-ascii?Q?hUfOWz09IIdomPJxIsy40KCz9Dh3/XYSDbKjJ1iyeWJLFmqvMAmireiT8+WD?=
 =?us-ascii?Q?h9z6ctThB0gvTnuZwkzyhiKWd/WAvUE68RvB+JyG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ade864d7-cfd5-4a5f-7958-08daa31f765f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2022 20:07:55.1003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YjKCElEI6TXoEPYBdTK1fnlXOopfeHlNZkp5VRVWCI8VgdqTICmqNdTPR38MeQDXZXBDOJ/3x37J0SdmWVx91w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB8064
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, September 30, 2022 3:05 PM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: David S . Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann
> <daniel@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>; John
> Fastabend <john.fastabend@gmail.com>; Wei Fang <wei.fang@nxp.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: [EXT] Re: [PATCH 1/1] net: fec: using page pool to manage RX buf=
fers
>=20
> Caution: EXT Email
>=20
> > -static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff=
 **skb,
> > -                            struct bufdesc *bdp, u32 length, bool swap=
)
> > +static bool __maybe_unused
> > +fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
> > +                struct bufdesc *bdp, u32 length, bool swap)
> >  {
>=20
> Why add __maybe_unused? If its not used, remove it. We don't leave dead
> functions in the code.
>=20

I was thinking to remove them by a separate patch once the page pool soluti=
on is accepted.

Regards,
Shenwei

>      Andrew
