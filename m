Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D775ECCD5
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbiI0T1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiI0T1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:27:40 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80052.outbound.protection.outlook.com [40.107.8.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D0F7C1EE
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 12:27:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CSN5E8mmMxCIe5TnZuDoAtF1cjYXWnNhqLqfzvKOiT9HfDXgV0jX/hY3P/YFIAg4D2zqycrIb+2J1deQI6GKsgyK7HHfpcMC6zRd+FWps6gu7hHe1irLyBDjxRyLAQR+Zb9PhbmVQqn2sLib1m64J2AvSKc3o0KV/dfVEGySpKJ+0Fq+G8lyuarAICkQwjrZ8Gni9GO0CLldL4ssdC/xhwD5Q21YcNf7W04jXxck6UUx+eqP9ZwDEUV6URDgaqnOW4VzWPMJU8+AvdKMmOi7W1vaGCHVeDofZ4xZhMuKdz6KkEe5nGrv9ZLHacHlsbNsC5qADO6nsOtKG9qQPAruTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wqziD7SXeTsYMxZotNnRsEjjIhQ6lHtMqTu6j85WyYY=;
 b=Mo5u5JpU1VqhGqdjRsOiCcOhpjrLmEMyiV7LDImfa98qNKjYLyI7WObcwRMPZeIYJy8rz8CeCXv7g4z8Zw+TbKfMuTcNgf2snSTOur2WIMOyi7pwN+OtGdoP8gnslyZyH+k64pci5QvbtZ5cSy1TjA/Mogl4VBsY4bDuLBtKCzeudIGLGQECP5Ypr49rw5UVCJ9QW1VvPLpZ28vkxlUWlJrEQILKd3XbDgzKGpE6zVsaHWWbRfursj+MP9ukJrCzdzQJSX5jiDkxegrcKGLYWg7g5V67D1FnrTUD8c4MoUn94u20C9WC44zovKiSiNqoZHGJOXVWYrGvA5y0KHiWxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqziD7SXeTsYMxZotNnRsEjjIhQ6lHtMqTu6j85WyYY=;
 b=mva+LqoM99MmyRZIJ0O/V/Nnj0DI/u5K2TVFlHvILOfvpiyh1eWOb57oHswwNKlAc8CvdqiKVfd6+9K3//v60jg9j12X4RN9XHOjFF2vT7GRjqYhyDPkpHoEvVhwcK7Q1FnL8q5kPrlZp4tgsBsldGNQFjsr/kNlQ2zGtlYJ0So=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7227.eurprd04.prod.outlook.com (2603:10a6:102:82::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Tue, 27 Sep
 2022 19:27:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 19:27:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH net-next 5/5] net: dsa: felix: update init_regmap to be
 string-based
Thread-Topic: [PATCH net-next 5/5] net: dsa: felix: update init_regmap to be
 string-based
Thread-Index: AQHY0qWGhrKC364LZUm2XB6TiwwJFK3zqRoA
Date:   Tue, 27 Sep 2022 19:27:36 +0000
Message-ID: <20220927192736.l7dgadcyazyvkpmr@skbuf>
References: <20220927191521.1578084-1-vladimir.oltean@nxp.com>
 <20220927191521.1578084-6-vladimir.oltean@nxp.com>
In-Reply-To: <20220927191521.1578084-6-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PR3PR04MB7227:EE_
x-ms-office365-filtering-correlation-id: ea492dad-99ef-4016-ec77-08daa0be55cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xf/96p/ibW5OrKnolFvN9atpaAbdbEh9kSgcbR/PUD4KDvMv1+iZ6txvTfXDxBNV+X8tWLkYgXjP3g5OYtI/8Hgmw7v9MJscdt2IWSSWjF7ubqef66yAt4LMO9BH+WZmOr9W2i72Wga/vdRioYQ3wHb3bT6Zg+dXkFVQGppQJeGxhyy5MMlhryFx7UUnvWneHelRpoLt7rSwwHl9Jp7HqFp0QIu+E8a08W3Fp3of2IXWL2Qr5oeYsgELRo4afe8DFHj1+lvgv8X0ZITwRCYsElem9/T11P5+peaMG3R8RqCTFm6dMX70v7JOr/eZvRO9ZK1TT03uPznXUvzzZyBJaP3FE+4t69NOpOqOW04aUt8hQq8ZuQOZkRt2kr1A5zsq23UG3OwTCfqmQs0Xrkoq0IWrue22svQAP8zK2kGdNtvD2panwaNeqzMTsFEto7mOiWJzMZaL+uXciXtP9eD1G7/3QnYdO9DBAs+ffbQxLO/dvjtS7EPykzVhGDnWpi9mA28JIQuf6ZKl6OtXCY5DFwpNvkHuY1CS6vQQDz6aNlHlZnOtmdu/m/g3QrrlFyeAu/sY/dGoXty1z7WbbfVjt4GiWr6R9+gr9HZFQE7jVfGhMIeoxYsWsn5W0ozRQA0xkePYRJZHZGeEKK1iJQz9txsof18hC+T3hYa1y585Gq8XexG5yAkQXK+3XYbzlygvSzaUGvutkw9XgJIDzkALlP9YUQq4J7N6BNVPeU9eRmXvgjfcX248QCFaTPhu1zjCFm6t+BnpVK9Vx9Q4LbGaow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199015)(478600001)(6486002)(71200400001)(8676002)(4326008)(66476007)(66446008)(64756008)(186003)(66556008)(9686003)(66946007)(33716001)(54906003)(6512007)(122000001)(91956017)(2906002)(7416002)(5660300002)(76116006)(6506007)(6916009)(316002)(26005)(1076003)(8936002)(83380400001)(86362001)(38070700005)(4744005)(44832011)(15650500001)(41300700001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tmgH0Rg5yh73+TIT7YdtRJBAGm4daqGeUPYn315L1oXAxRiH71Ou6iILFyvJ?=
 =?us-ascii?Q?vu4ZB9EumasQVQ2JitTnUJntGlfs7hIbpEr8txZiwsqtDwjPeJfoUoZPB5mn?=
 =?us-ascii?Q?GXN6LUOINPkISRz+2RXzZ3IEHfVgoXOFLN9+ptVa9lF5PVyyd/rXhcWzJLhx?=
 =?us-ascii?Q?Cs/393PCJtyuzy9eJMSn4fIT0ZBirH8NAsdfmZZhLsJFeiDphNETd6WJEU2V?=
 =?us-ascii?Q?ySzbgcYqvOTarutizgFR8lafPYeKCRsGgQd/2mouBrFfCJ9HlMuqz38iye5N?=
 =?us-ascii?Q?b4Eks1TnEsnKDVf670u+FZm164vp6FXMP4aph+/f2AQRpM2UzJSyzJ8KTEDc?=
 =?us-ascii?Q?whSbIYnxyBC12c1uoctjiPmbIEdtVk8DH5w0rrUZ2Qf2E00L04dUJGYNfrT6?=
 =?us-ascii?Q?ru9zXr44IGcODQC3qIcdghK6/w1AbeRy/dBC0UiuJ34p4Y3NMdiiWGU8fMCc?=
 =?us-ascii?Q?j/GJx+6LM0ccdXL4oIE4yVlDMzFXm+YSIVpFe5cNIUX7xOxW22Kxp0UGEWta?=
 =?us-ascii?Q?BRKljug6cB76TzgmhNRYxECMLjiejqit2Lt9Dik2v8t1vaSQJjNE1fMrt4LS?=
 =?us-ascii?Q?bIR13hZZvluUzM39E2A+ROQ9JOZzBXgEIs7nT8arqyiyTVNw3diGHcbpxz9x?=
 =?us-ascii?Q?t1q5rGX3SyKkFZlbNcDHMnVdqetUGLIL8wRziJig4n9DfbxxS9bTOXsMC4qz?=
 =?us-ascii?Q?1Itk7opwXnJlBkS7qZvt3zJawLa0dEux+gFYnvIuFLSGBYuOvSksGQ3TUzQk?=
 =?us-ascii?Q?KeJvzFHG6d2va0aDBlljuLz98iOx910AFi8Q1jnOCIZVmKBLvNOp7jyhMVvd?=
 =?us-ascii?Q?A4rO3AaM8YTM6AdN5AU4MvjXiEnL4LXpAabJwZRkCxMDWBsqU65cTDf4G6h8?=
 =?us-ascii?Q?cBuu9AvYTHcBqXMjE+OSaJv2My0NXGQRpzCp/Ulso8K7OgDSrmAfcTnpiOZo?=
 =?us-ascii?Q?FyKaGRHhulRjG7D+VXtv+Evzs1j8GA1tdEGGlk4j5vrZlUxRS7botZtWZUXg?=
 =?us-ascii?Q?pACsD8/vnP5Oxt+VsnB+M91IpHtd/Zs23JADpOF5gvOG85A6kRChvRFXX1tQ?=
 =?us-ascii?Q?gZ4Dk907jaNlH0COIffqInBYJHGN/g3SX6Wq4pNbcawk7b/bXotNaL7WPJdt?=
 =?us-ascii?Q?85hmpmp4AU1kOk6CNMrGKNlQEPJ12t3UVyPaHQQiVqELl0BQgMxd7ArD9mQz?=
 =?us-ascii?Q?zy2S7h2T05Xeuz5X1yWso9mv895Y6kCR8s1tqA+pNJEx3Nmv9msSb82w6rAj?=
 =?us-ascii?Q?/ZVCiNCzDRsGDbsjqk6mkiiXWCuWBxrM7kjQaqeGo8V10KDDYermq0sf8dfc?=
 =?us-ascii?Q?XqT04IKCujwQRYbO9Hvx64925IGxzq2EaP6WpHgivFfgyWrGN56OL003oru3?=
 =?us-ascii?Q?UJnKEgyV9YDOrrHUYiqYemYpn2LrkmDThYSwHL/13vW8/iVIhjlAm+Xr7DXn?=
 =?us-ascii?Q?IDvgIAtNAYv2X6OnPZAfXlW988W1C3Z/xzoRukpTXEXvDkBoIXJQXOyxpA1Y?=
 =?us-ascii?Q?hcZo6XSjJjnBZGlcH/KdaDTnSAl48ogBUkV9Y3/a/f5dH79TzvSKFpaPwjFD?=
 =?us-ascii?Q?E9kvhpVd0GAJXLg2m3LJbkf7PMy4YISyfxpH4i0IUihP1hqRDPSDByK4/DlX?=
 =?us-ascii?Q?Eg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A5450604E1D18146A92837763A82162E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea492dad-99ef-4016-ec77-08daa0be55cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 19:27:36.9692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1AJCMalmkwfHcTX3uqvmpEGOAMWs2JL+aeBtayguXc/SRrY/Jlj/bwbMF3cEMWAegYYP2ofHAuH20nsv6SAplA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7227
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 10:15:20PM +0300, Vladimir Oltean wrote:
> Existing felix DSA drivers (vsc9959, vsc9953) are all switches that were
> integrated in NXP SoCs, which makes them a bit unusual compared to the
> usual Microchip branded Ocelot switches.

Damn, I did something stupid, I reworded the commit title for this, and
I didn't rm -rf the patch output folder first, so now this patch is a
duplicate of the other 5/5.

I know I'm going to get a lot of hate for reposting in a matter of
minutes, so I won't, but on the other hand, patchwork took the wrong
patch (this one) as part of the series, and the other one as "Untitled
series #681176". The code is the same, just the commit message differs.

Can that be fixed in post-production or something?=
