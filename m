Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6856B75B7
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 12:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjCMLQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 07:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbjCMLQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 07:16:10 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2059.outbound.protection.outlook.com [40.107.8.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CDF6423D
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 04:15:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mb/BdTTlDUUQq0r3drh0eprCQSzp0f0mKQGul4Etahdk2Cvs7xIO/BkZyaR6PiFVo8AzwOaUi8N7ywsdVGENoexDr8PieEpuofx8n8Kio4rH8phctHY0zjdSTQ3KpyrLGQAcD6TFAi7kRwNZ3u2SFDfqqbX5E3uQ5iZ8Jk1PNUZwCRIL6TJaa/5TdeNDqofwd5FpqND5pxM1hzKoFF2CPvvQY2i9tgx6wrxjiy2u+7I2wC8bHvEAy0ksFE8aG+rbMG7K06VHwX386NXEsA/4K+1iPxJA/ON9RIy/bDcxnXjGYutgugS/QVnh+BmwCCxKnuxTbmTeX2z+1svn59funQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dah/Y9mSKhdv6Ke/EUEeXY6dHVNuv1BXWnNm/e1bQ1s=;
 b=b1+PT4S2MiePZH+OCx8wAFJSQXdNL22k0gMf/fmCHmFUE9vBun+frY98rq3XseU0gfC/I4a9oMbzFD/R42ginkc4HZeL3DS+ot0Fc+zy4mb7MgLfz66Vjfhcd2BgGk3C4hdR0+9KTu2Alic/JFFy9lysY6w9nMkbxFN1hnsHt4T94j+Y+nKM/3tuqnsylItVAq2Z7GltMdSS2aXF6F6ku1g7xu6TfJeU/wHB/G4BQgvXFSvdHMjNsUVp9Qog2AsxT35j0v5Qyp40VsdwnYP7JxReWduuGKEjayq9h8OziHKb0t52nDS1qoL38DKje75yKGn0AhZbepLtoGtl+RdS3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dah/Y9mSKhdv6Ke/EUEeXY6dHVNuv1BXWnNm/e1bQ1s=;
 b=NFAslX0WF9cZFByDqoCwTYKymgLywh6p29DyWyYPO6v5w4w+IU6uoH6sODiAAvle1ZHhbcfA8FbLUJmc/I+VbNISxRJu7BwEGJgL4rdAIitlyuvsaY2V9Yuvqo5l4FRgvfgIuSkUE3d8Hz+zr+UpVuCvp3wh/kT4E+6QDYuOyP4=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by DBBPR04MB8025.eurprd04.prod.outlook.com (2603:10a6:10:1e4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 11:15:01 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::806:4eb3:88bd:1690]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::806:4eb3:88bd:1690%7]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 11:15:00 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
        <u.kleine-koenig@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Wei Fang <wei.fang@nxp.com>, Wolfram Sang <wsa@kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mark Brown <broonie@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH net-next 0/9] net: freescale: Convert to platform remove
 callback returning void
Thread-Topic: [PATCH net-next 0/9] net: freescale: Convert to platform remove
 callback returning void
Thread-Index: AQHZVZfP2pOxqcnBZECSsRJ6QLhDOa74jrZQ
Date:   Mon, 13 Mar 2023 11:15:00 +0000
Message-ID: <AM6PR04MB3976DCBAC08D8980294C328AECB99@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR04MB3976:EE_|DBBPR04MB8025:EE_
x-ms-office365-filtering-correlation-id: f4afcc90-5bcb-4bbe-ebda-08db23b42fed
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K93z6ryA/Hq07eA9rOCKFI0OPcsG3WpBP19la4ARfU4yLfGWuSuqRqEQBTUEw0lcPdh3chxKxjPvegY77GhcaO6siP0FysLl8kE2pAg33OYAWpLMKsaTPX8aeFoUGudcPor8pKhgvYG6Nb7Hbi43g2wiM1KPNQQTXHJ74urfsB0JchelW8gLvaybq3i2yDD0UM0qKHsXcssUklhvikmqridZsUKecwVIWwUFu3zCm89ULJAcaT5RvrlX90qzhPCkh/Bdp7SQdJhxERdrJ8cqkoYZFDxeOLJ7PYpMxHl9fTRZcKWGlsxsMvKo5zOOr48TX2Z9NZowy8libtQXsTkT7TmVTvT1rV3Fhzzks0FAFfTwkN/JCcRc0GMhBlVl4Du5Vl/3imxSnGVN5Z5LHm9WQiFqGx6s1W8rHdRH0n92Atn4G6k/AadZ3K+MvrWQ4dW145khDUHTvFD5OH85FHkGwZ0VBVdVwbwUcy6MoAfHWgkjdxIT/x4gSJzGHxUPL8YG4V9tJh1Y2mHIVeuXplj4qS04PknqPhD/w0AP/fgW6nSZl5r203TRI7wNBdzCKULDzHRo95gXOdk57I2/OfSrm8GYQx7uVYDb0uKywcYeqM/koc51IBkHNLpcafNH1FXyRS5aBD2ySySvmQ/s4nltUDPtQ33yZOE/Qo7brAgJW7NqDzb//X1Zj6pceXI9m6bf+EoYzIV32UNjjYczqT9NIWI0WvIQ+fkKouOJcE7IUk4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199018)(86362001)(33656002)(9686003)(41300700001)(186003)(26005)(6506007)(53546011)(55236004)(7416002)(5660300002)(4326008)(52536014)(8936002)(316002)(54906003)(55016003)(71200400001)(6636002)(478600001)(110136005)(8676002)(76116006)(66476007)(66556008)(64756008)(66446008)(7696005)(66946007)(122000001)(38070700005)(38100700002)(921005)(2906002)(44832011)(66574015)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UEZMYUxrUDFPRmlTWTY0T1B4WnJVSEpDeHFNRERHWnhxaGVJUGVjcU5McXZx?=
 =?utf-8?B?T01Yd3UvQ3A1WTMrcmZmazhyZWh4UEJzR0t6dVk0UVNSRTlzY0hBazFzRjN5?=
 =?utf-8?B?ZExkMFA4RlJxUEJPNWF1V1ZZZ2FHZW1LZVN0TWxmRHpJYWdFMmpPSkdyUjQw?=
 =?utf-8?B?OUhFQm44T0pyeXNLRDM4aHBlaGw5RVNxbmlQU2w0NzRrTXdrWDZodzNnRVU3?=
 =?utf-8?B?aUdYVWlzMTNqY1NuUWEwSVYvaW5ab0R2RGF2bmx4dTlFUTFiWmUvVm1idGh5?=
 =?utf-8?B?V3ZlS2NEb0doai9GL2g3bnFPMk1jcUc0c3ZpWVp1VUVhWkRuaHpteXRaM1lU?=
 =?utf-8?B?dVN6Z2xLRVlYODJSbXZlTng2TGIxNmxWazdpZUdvQnVQak5Md05lSk5NNFBS?=
 =?utf-8?B?N0RQQW9kN09ZaWYvd01PUDlPRlNYRlRiM3BERkhtd093ZTQ5U0NuTnVFUU15?=
 =?utf-8?B?RWhLRXR5VlNkNWU2ckhaMVZWUEE2Mys4RExhZXJwMkZBVk1WZW1jTjYxeDFw?=
 =?utf-8?B?UVFOT0pURnRiNjZTMlNrV0NhTWNSMnhaSGkxVmt2UTIvZmxoUk1jZXVmSmN5?=
 =?utf-8?B?VUdhc2plT2d0UjZnU0FzK2FDWC9GRnJvNGNDQ1FPY1hITHd2ZmdsWUdrQlFi?=
 =?utf-8?B?dWQwYWQycHZsLzNRRE56UVBwdWNEQ1MxQ3RzMXhSeUJuN1cvSGZhWkJ2Q0tv?=
 =?utf-8?B?ZEJPOUtmZy9qNUgvOGdxbk42RGsyaDhqTDJuZFFDdHpvMWNnMTZ0M0JsN1d1?=
 =?utf-8?B?NGMyZlMxQVBibnN2ZEcvN2FDZ2VZN29xQU02aEE3MmlNOFpGV2Y5d1JGbU5r?=
 =?utf-8?B?Vlg3ektDWWI2czdRQXZ4TUtueWtWT2h3elMxVTRtak4zS201aG50aTBQdmx2?=
 =?utf-8?B?MDIxQ1FZM2wrYVJVQ0NBRWJDQ093S3Z3UmlKeDNocWhKakY5LzB2aXNUM2ZG?=
 =?utf-8?B?NXZLVkxqOXo2Z01lTnNHelBWb0VMYUo0VDJmY3p4TC8rbHF4ZjNWUFdMQjln?=
 =?utf-8?B?S3BPS2J2UC85V1dINk1XN3kwSjUycTNWbXpRVFk4SWw2Zm8rT0ZFODBPbzhO?=
 =?utf-8?B?TlBHTlJPVTJUTkxEM2NaN1Z0MEJGcTVad3BPYlhLbmljYURPN1JEYmR1K2lp?=
 =?utf-8?B?VnFJbVhhVXRaMlIyOWc3d0trMEVrWGJXNmhDWXNTcEJaSE9nSzdzUW1SKzlo?=
 =?utf-8?B?SEpjVTlxYmRuMU5rSE9BRkVtNkR2bG5FWjJNYkpkQ2pFRUU5dGRMOTlUdi9v?=
 =?utf-8?B?VU53cklRVW9LOFJoMml3QXZ5d0oyMEJoVGlScDV0dzF4Q0VJbkFUeFhxUjZX?=
 =?utf-8?B?RStJSVhia2FuVXZPcVA2UERpNG1aUm9nQnNWajk4R21yREFTa0thUmVxSzI5?=
 =?utf-8?B?V09KdTd5Vmx2QVU1cGhORlZ0M3A3UjcweHNIa3dtbzBkeHJSV1V5NCs5ZUVH?=
 =?utf-8?B?K0hRd2Y0dUUvT21GeHEwOExQSzZLb1NxdE5veGJiKzVuRWZGWmZWR2djZWxj?=
 =?utf-8?B?VDArL2czOCtTQTFLdC9iYVdMNGJDRWpJOFVEeU9NRlRYL1NsVkVad09KenFQ?=
 =?utf-8?B?MjhwbUxKR1l3U29YWHg4UzY5NWxEcDFSaFNaSjVPWVpTVnB5c05kUExqMERN?=
 =?utf-8?B?dm1BWVNKV09XS0h6eWg3OVZGR1Q2aVhFNUxhdlFtb0xNbXZqZnR3VG9Nbjda?=
 =?utf-8?B?WUF5ZVNTUi9QcXBhNHlybzVEaW5lWHRvUWgrT1g4cnd4ZzNsdFJucXlKSDI3?=
 =?utf-8?B?Qk16RmFMUVBFaGhuQkVoVVg2VVZXUlBnRjlRNUQrS3p5SEx5S0NFbzJwWWJJ?=
 =?utf-8?B?aFhYa09MaTlsWVoxckdoZEpkbWRmMGNscis2Tmp3bjJzaVRKVmViaFYwd216?=
 =?utf-8?B?MngrNERuUFFKb01rNEFjMlZDdjFqam91TGhnWVA2dnZ1cXh3enVXUm1pU1Rq?=
 =?utf-8?B?WTFyeFQvZFhVN2J0T2hoL1ozRkRYYmJCTkdkUzBYR1l6L3lUbERsME1namc5?=
 =?utf-8?B?MVRCanNYUWJjNjdFdVBTTyswWHlPcnFZUGNXZEoxeEs5M3Z3aEZwdTcxT3Rh?=
 =?utf-8?B?QUNiZXdidG5QSWVJR3hMQ2REYnl4QkNLN3FUOUprdkYrNGVJcUYyQmRqSkFC?=
 =?utf-8?Q?1rQnFjSoGjwOpQ9343rFqzF4s?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4afcc90-5bcb-4bbe-ebda-08db23b42fed
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 11:15:00.7795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y2/AUKSBPx1IQguO3Jx605W8mztb8dergMDqWiI/lcFvpE2fdMngIzmxRk0mHhUKyK8R2nRA7b2yleqjeXQM2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB8025
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBVd2UgS2xlaW5lLUvDtm5pZyA8
dS5rbGVpbmUta29lbmlnQHBlbmd1dHJvbml4LmRlPg0KPiBTZW50OiAxMyBNYXJjaCAyMDIzIDEy
OjM3DQo+IFRvOiBNYWRhbGluIEJ1Y3VyIDxtYWRhbGluLmJ1Y3VyQG54cC5jb20+OyBEYXZpZCBT
LiBNaWxsZXINCj4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBFcmljIER1bWF6ZXQgPGVkdW1hemV0
QGdvb2dsZS5jb20+OyBKYWt1YiBLaWNpbnNraQ0KPiA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8g
QWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPjsgUnVzc2VsbCBLaW5nDQo+IDxsaW51eEBhcm1saW51
eC5vcmcudWs+OyBXZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT47IFdvbGZyYW0gU2FuZw0KPiA8
d3NhQGtlcm5lbC5vcmc+OyBDaHJpcyBQYWNraGFtIDxjaHJpcy5wYWNraGFtQGFsbGllZHRlbGVz
aXMuY28ubno+OyBBbmR5DQo+IFNoZXZjaGVua28gPGFuZHJpeS5zaGV2Y2hlbmtvQGxpbnV4Lmlu
dGVsLmNvbT47IERhbWllbiBMZSBNb2FsDQo+IDxkYW1pZW4ubGVtb2FsQG9wZW5zb3VyY2Uud2Rj
LmNvbT47IENocmlzdG9waGUgTGVyb3kNCj4gPGNocmlzdG9waGUubGVyb3lAY3Nncm91cC5ldT47
IE1pY2hhZWwgRWxsZXJtYW4gPG1wZUBlbGxlcm1hbi5pZC5hdT47DQo+IE1hcmsgQnJvd24gPGJy
b29uaWVAa2VybmVsLm9yZz47IE1hcmMgS2xlaW5lLUJ1ZGRlIDxta2xAcGVuZ3V0cm9uaXguZGU+
Ow0KPiBQYW50ZWxpcyBBbnRvbmlvdSA8cGFudGVsaXMuYW50b25pb3VAZ21haWwuY29tPjsgQ2xh
dWRpdSBNYW5vaWwNCj4gPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBMZW8gTGkgPGxlb3lhbmcu
bGlAbnhwLmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGtlcm5lbEBwZW5ndXRy
b25peC5kZTsgU2hlbndlaSBXYW5nDQo+IDxzaGVud2VpLndhbmdAbnhwLmNvbT47IENsYXJrIFdh
bmcgPHhpYW9uaW5nLndhbmdAbnhwLmNvbT47IGRsLWxpbnV4LWlteA0KPiA8bGludXgtaW14QG54
cC5jb20+OyBsaW51eHBwYy1kZXZAbGlzdHMub3psYWJzLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0gg
bmV0LW5leHQgMC85XSBuZXQ6IGZyZWVzY2FsZTogQ29udmVydCB0byBwbGF0Zm9ybSByZW1vdmUN
Cj4gY2FsbGJhY2sgcmV0dXJuaW5nIHZvaWQNCj4gDQo+IEhlbGxvLA0KPiANCj4gdGhpcyBwYXRj
aCBzZXQgY29udmVydHMgdGhlIHBsYXRmb3JtIGRyaXZlcnMgYmVsb3cNCj4gZHJpdmVycy9uZXQv
ZXRoZXJuZXQvZnJlZXNjYWxlIHRvIHRoZSAucmVtb3ZlX25ldygpIGNhbGxiYWNrLiBDb21wYXJl
ZCB0bw0KPiB0aGUNCj4gdHJhZGl0aW9uYWwgLnJlbW92ZSgpIHRoaXMgb25lIHJldHVybnMgdm9p
ZC4gVGhpcyBpcyBhIGdvb2QgdGhpbmcgYmVjYXVzZQ0KPiB0aGUNCj4gZHJpdmVyIGNvcmUgKG1v
c3RseSkgaWdub3JlcyB0aGUgcmV0dXJuIHZhbHVlIGFuZCBzdGlsbCByZW1vdmVzIHRoZQ0KPiBk
ZXZpY2UNCj4gYmluZGluZy4gVGhpcyBpcyBwYXJ0IG9mIGEgYmlnZ2VyIGVmZm9ydCB0byBjb252
ZXJ0IGFsbCAyMDAwKyBwbGF0Zm9ybQ0KPiBkcml2ZXJzIHRvIHRoaXMgbmV3IGNhbGxiYWNrIHRv
IGV2ZW50dWFsbHkgY2hhbmdlIC5yZW1vdmUoKSBpdHNlbGYgdG8NCj4gcmV0dXJuIHZvaWQuDQo+
IA0KPiBUaGUgZmlyc3QgdHdvIHBhdGNoZXMgaGVyZSBhcmUgcHJlcGFyYXRpb24sIHRoZSBmb2xs
b3dpbmcgcGF0Y2hlcw0KPiBhY3R1YWxseSBjb252ZXJ0IHRoZSBkcml2ZXJzLg0KPiANCj4gQmVz
dCByZWdhcmRzDQo+IFV3ZQ0KPiANCj4gVXdlIEtsZWluZS1Lw7ZuaWcgKDkpOg0KPiAgIG5ldDog
ZHBhYTogSW1wcm92ZSBlcnJvciByZXBvcnRpbmcNCj4gICBuZXQ6IGZlYzogRG9uJ3QgcmV0dXJu
IGVhcmx5IG9uIGVycm9yIGluIC5yZW1vdmUoKQ0KPiAgIG5ldDogZHBhYTogQ29udmVydCB0byBw
bGF0Zm9ybSByZW1vdmUgY2FsbGJhY2sgcmV0dXJuaW5nIHZvaWQNCj4gICBuZXQ6IGZlYzogQ29u
dmVydCB0byBwbGF0Zm9ybSByZW1vdmUgY2FsbGJhY2sgcmV0dXJuaW5nIHZvaWQNCj4gICBuZXQ6
IGZtYW46IENvbnZlcnQgdG8gcGxhdGZvcm0gcmVtb3ZlIGNhbGxiYWNrIHJldHVybmluZyB2b2lk
DQo+ICAgbmV0OiBmc19lbmV0OiBDb252ZXJ0IHRvIHBsYXRmb3JtIHJlbW92ZSBjYWxsYmFjayBy
ZXR1cm5pbmcgdm9pZA0KPiAgIG5ldDogZnNsX3BxX21kaW86IENvbnZlcnQgdG8gcGxhdGZvcm0g
cmVtb3ZlIGNhbGxiYWNrIHJldHVybmluZyB2b2lkDQo+ICAgbmV0OiBnaWFuZmFyOiBDb252ZXJ0
IHRvIHBsYXRmb3JtIHJlbW92ZSBjYWxsYmFjayByZXR1cm5pbmcgdm9pZA0KPiAgIG5ldDogdWNj
X2dldGg6IENvbnZlcnQgdG8gcGxhdGZvcm0gcmVtb3ZlIGNhbGxiYWNrIHJldHVybmluZyB2b2lk
DQo+IA0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEvZHBhYV9ldGguYyAg
ICAgICAgfCAgOCArKysrLS0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2Zl
Y19tYWluLmMgICAgICAgICAgICAgfCAxMSArKysrLS0tLS0tLQ0KPiAgZHJpdmVycy9uZXQvZXRo
ZXJuZXQvZnJlZXNjYWxlL2ZlY19tcGM1Mnh4LmMgICAgICAgICAgfCAgNiArKy0tLS0NCj4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbXBjNTJ4eF9waHkuYyAgICAgIHwgIDYg
KystLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZm1hbi9tYWMuYyAgICAg
ICAgICAgICB8ICA1ICsrLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZnNf
ZW5ldC9mc19lbmV0LW1haW4uYyB8ICA1ICsrLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9m
cmVlc2NhbGUvZnNfZW5ldC9taWktYml0YmFuZy5jICB8ICA2ICsrLS0tLQ0KPiAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZzX2VuZXQvbWlpLWZlYy5jICAgICAgfCAgNiArKy0tLS0N
Cj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mc2xfcHFfbWRpby5jICAgICAgICAg
IHwgIDYgKystLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZ2lhbmZhci5j
ICAgICAgICAgICAgICB8ICA2ICsrLS0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNj
YWxlL3VjY19nZXRoLmMgICAgICAgICAgICAgfCAgNiArKy0tLS0NCj4gIDExIGZpbGVzIGNoYW5n
ZWQsIDI2IGluc2VydGlvbnMoKyksIDQ1IGRlbGV0aW9ucygtKQ0KPiANCj4gYmFzZS1jb21taXQ6
IGZlMTVjMjZlZTI2ZWZhMTE3NDFhN2I2MzJlOWYyM2IwMWFjYTRjYzYNCj4gLS0NCj4gMi4zOS4x
DQoNCkZvciB0aGUgRk1hbiBhbmQgRFBBQSBkcml2ZXJzLA0KDQpBY2tlZC1ieTogTWFkYWxpbiBC
dWN1ciA8bWFkYWxpbi5idWN1ckBvc3MubnhwLmNvbT4NCg==
