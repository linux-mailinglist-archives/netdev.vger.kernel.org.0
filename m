Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C874583CD6
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbiG1LFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234621AbiG1LFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:05:21 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2066.outbound.protection.outlook.com [40.107.95.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCE565D1;
        Thu, 28 Jul 2022 04:05:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7DIyFkXReeKSBNwnqnK8cYZoC0lvYv5cg+S4cY1A6PPafhtJw2c2YoxEqLCMJFfQXV3/buASPOPaF/I/1cRttNvIxGUFs1gVrY5Hvlp8H2LLN3E5yNYlWNxDMBHSInlqA03b2OUctsL60qaWQa+UBTA78yqLVBjmXK46ddzv6nRLLzcqCW0XQJzCQ/vKIvcMIZACyQZjZlR/tWNPB4+UTPiP/tj0Z75MdhryqjXNS3nU3RrrHGJJrWi8C468uj9iYS7+HtEa/CPbMke7o2YURUsDDJNZu0JO8zD1fMxpzlZX/NZO+xZFsFN2sBjnKoCZHcYv0+BhN7V4ay5XPjkyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YtDjwjpVrbvKFpDB+R6fDJtb5E+a9kBmyEnS1jMbd7s=;
 b=Et9Q9xoNwwc56bTJN4mv6fUstu5PvBHR5haLR/QHE6oef8580TsR1Pjs/ZqO2ULW9QBuAxaxCWDueVCpT6Hl/M8u5QbNb+JE8q203CiYqJUdSI1AhJRfZ48OyjM+RTkjcLL6gLxIC8vgwLgW1BUgO/IRgYLsZ/Ld2gYg2pip11igklw68U4nUUtd/7twz2XRtdEJfnIrpP75pT0hunH4/pUcZKbzmdQsa6+bmVrY4MaO7b7huZeTGXL/Iw22ZLpsOSA0StSPfAZl2gVbgDLK2Nk4kLzNmN+puZel+n3ckjhfz5Lo6xFrsMvDBgzllTwgaRVj5Z0hv5hZE8uBEwFGNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtDjwjpVrbvKFpDB+R6fDJtb5E+a9kBmyEnS1jMbd7s=;
 b=bF0kg3dhLb8729NyXkIjeLiIWX5iouoN2u3bsLlzT4EKXkgmKuAEz4Usz99SHkTOi7no9W6cw9vcJnOBeW65DFhqv1S/FWPBzanBzV+/QL4RO47TRKBPIRktydYR1W55Y33DzntzYBSleRnBwn4uLg7Pc4yP98i8P9XpeluQdjY=
Received: from BYAPR12MB4773.namprd12.prod.outlook.com (2603:10b6:a03:109::17)
 by DM4PR12MB6661.namprd12.prod.outlook.com (2603:10b6:8:bb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Thu, 28 Jul
 2022 11:05:15 +0000
Received: from BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::444f:f2a:5b01:7ba6]) by BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::444f:f2a:5b01:7ba6%5]) with mapi id 15.20.5482.011; Thu, 28 Jul 2022
 11:05:15 +0000
From:   "Katakam, Harini" <harini.katakam@amd.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Harini Katakam <harini.katakam@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: RE: [PATCH v2 2/2] net: cdns,macb: use correct xlnx prefix for Xilinx
Thread-Topic: [PATCH v2 2/2] net: cdns,macb: use correct xlnx prefix for
 Xilinx
Thread-Index: AQHYoL5494SN+U7ICU2AmgSDHjXCj62Ta8OAgAA2NMA=
Date:   Thu, 28 Jul 2022 11:05:15 +0000
Message-ID: <BYAPR12MB4773F279A3C410046016D0279E969@BYAPR12MB4773.namprd12.prod.outlook.com>
References: <20220726070802.26579-1-krzysztof.kozlowski@linaro.org>
         <20220726070802.26579-2-krzysztof.kozlowski@linaro.org>
 <87d8327b85ae54e4c9d080d0ef6645eda6f92e98.camel@redhat.com>
In-Reply-To: <87d8327b85ae54e4c9d080d0ef6645eda6f92e98.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a99418d-9b96-44f4-a522-08da70890cf7
x-ms-traffictypediagnostic: DM4PR12MB6661:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KusykxfIWLcLpIaB6pp0M1WfkxKrRewXunf6be+PWOFZEiRlVcpmJBzc1sE1gRTTIM68RpR9XhYDyLNWyVDxx9/trMhbn4mYTbWd7cyTIOaFhJuEiC14K6s6HqdNkKJsL7gsEE9qWPvNe2WODXWykCdN8PA011UcbpVS3lVg8KRMS6K3eNSxjkPyZPPAiUENFhAMPcS0QUa9Eewkabxv/7z9DbtPT9TzCauZXEHt6D/Ni7mOH8gOY+JIF1/SN8dD/Cx5So1+m+uXic43b28UAkGvExcCv7BrO8pkSSEsMvm2mrHRJdjRcEpHrHvmlcuqMfquiPz+xVhne33h50xA7RhI8+OgUkhWy8g/QfY+yhMHVVTES1X+OuUmaPuLt4oR65dCQCnCB/FMvQu/BhxAsrnQQcKLamNUKSLDobio6LgHyiD09Eg6G4ClEKQk6eDsaU11DDKfhsE6AMK6lUeJSWYFbTGc2nIE/E1IcgW38Dj4ukGBeuc2kMOV8JMJeX4HL1ae6+D9aFp2uYGs7sIRYkNyDpch76920euzoFO4dbj5tXfq240yb+/70h6Ma9FLUxUv7MsMoTPPl8XKS5csd+3DZHCOA6kzBLRLGOH/36LjNOQ9ch68qErU1dOq2kQ5Y7+gtuFvF3PyB3GXBAhrH+tDY9Q83t7/D0ueU3L+wL8caCOoVB1YacG+b3/vFbQFHnkg8tj84QictMDZhjy+8MNlaYYJ1DinuWv6YpYjaHEmjHgBiysdJy8+ByKKkX3KU9jluhV6MLubeiV6dJuhtOfEUxpystHjqpR4j/76EAieyXfFk159Fk+52ThDUGqP0hqHaT3xp8lJcVGMmW8Tvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(316002)(71200400001)(54906003)(38070700005)(478600001)(33656002)(41300700001)(107886003)(83380400001)(6506007)(921005)(186003)(26005)(110136005)(55016003)(8676002)(5660300002)(53546011)(8936002)(9686003)(66476007)(86362001)(66946007)(64756008)(66556008)(66446008)(52536014)(76116006)(7416002)(122000001)(7696005)(4326008)(38100700002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VG92bjZHdzlHeG0wcU81aFo1RUJFVUt4ZWIxVmJoZFlOL01YZkJuMFV3dkJU?=
 =?utf-8?B?TzhKazZOVXNXL3dOZ3RHMm9NN2J1a3NhRVVjZisrRHZNNFBMUnZsUDZhVEtD?=
 =?utf-8?B?SUZ5bHpHWkNyT0NjeTEvSllWWmN3VzN2TDE1UEJxZ2JSSXR0U281amxTbVpC?=
 =?utf-8?B?Y05sUlJTMUJUcmx5VXUyanAyd3pMRXZDSjBISCtVYTB5c2lzaGxBWHNJVTJ1?=
 =?utf-8?B?cDY3anBRTlVwZU4xVmJUQzZWdTZvT2MvdGt5cUpsVDVCQ0ZvcHNHTFBIRko2?=
 =?utf-8?B?aGhKcmJSUk9nWGE0bUZDSjdQM2U4ZkM3NUkxTjlHQjJXdUhzN0c0ZlNLYTlr?=
 =?utf-8?B?NFJqV0VEWC94OE9lbVJRUzJxNlBnYS9lcThqaXVIcVJRQ29lQVluZ3E3Skc5?=
 =?utf-8?B?YTIwVkpqdjRtc3hVaTB3dnJ6elNPZEhCbHFYREpNK3I4Ky9UZGlrVFVrU0Zu?=
 =?utf-8?B?eTN3alhlRGlJcTNKOG1RL084a1F3RCtjS1lPeUZ1Y0JaVC9yRTUrOTJXMFRt?=
 =?utf-8?B?UjFsTE5Td1VCNnZPdEdnOWQ0T2ZKR0p0R0djTU9oQlMxZ1pSTlVxMlF2czBl?=
 =?utf-8?B?c3pFL2JhRlVJZGttdXBMU2Juc3lKNlMzVTlGcFRramhVL3ZVdUY2ajk2Tkpp?=
 =?utf-8?B?VHI5UkdIOVRrN0ZVZGI2WVBaUGU0WG1RWjc4b3FYUWE3akRhZFZOM1d6eUpr?=
 =?utf-8?B?ZDNUdExoMyswVWRPOXY3VEFTSU5uVWRpUlpWNlpLcDNub3RBMTZ2U284SlJy?=
 =?utf-8?B?TnpKM2dkSmFtZjJJT2Y1STFSbmQ1M2gxcHpHYjFvVnJYT2ZPTDI2QnZFTUsw?=
 =?utf-8?B?dUxwTlZ2VmVZU3UrZ05nczAzMDVEcFJhbjZZYjh1dmQzUCtPWE5RVU54MHpG?=
 =?utf-8?B?aUxYQ2M2MEZ4VHhIbkwxUzdPTTBiWERsd0FFdWpEUks0a3lILy83VGVzby9H?=
 =?utf-8?B?SnE2bURwVkJ0c1lsYnR6T1luMzZyTkMwMlBCeFI4cVVicnYxR3lER1NrSVFk?=
 =?utf-8?B?azNIQXlVaHBzejJxLzczOWJoNS9BSWcxT2dzSDJ4R0J5RVlHSFY2b01GQVhT?=
 =?utf-8?B?K3h5NEFFYTFZM0tiVHRzMlMyeXNYS1AwTE9VanZ2SWdES1QrMWtzcGxFVHdS?=
 =?utf-8?B?aDVBeUNQdU5BRnFjSjhEdXJKcFhTQW1teUJvekxuR2Rpb3VlNXg3Z2kyTXd5?=
 =?utf-8?B?UmlPeEFKUVhhZDh3YU5zd044UEMvS1liRXBxQUFoUjVKdUVSK3BleGI3QTdt?=
 =?utf-8?B?SGp5SFprMlZ0RmhHZnIwSjNiR1U2L2lxemVPTEhxNE1YYzl6eUJ0Wm5KZ0dr?=
 =?utf-8?B?eHh4MkJRQmE0WnJ0cTA2eFJpQnErM1V3TTZyeXZTTGRqRDJVQkQyM3JKZnE5?=
 =?utf-8?B?UlBSMnlvc1VHSGFnRm5zYjdIcndEVWhCdWhXKzlCeEF6eXRYTTdHZjlDQWhy?=
 =?utf-8?B?TnRLQm5xMGZKSlBBeGRsU1lsaDBDSW53WDlaWWhZbWVTWWFkTy9DYzVhSVRF?=
 =?utf-8?B?Vm96c29MVDErRHdXOGFkNllXVWJDYUNhWStuT1licDc3VHUrVUxzRElCdjFF?=
 =?utf-8?B?Q3lDajQwc1VDdGh6K3JIb3NOOEtvdXZYS3VwQW53RjdxcTlKTHNhZWZxUzdE?=
 =?utf-8?B?WU15bFNudjFDTjk1WURBTVdWM2dld1VQczJzb2h0eXplajR2S1prYVN4dnNp?=
 =?utf-8?B?d3dBdlJkMGpYQUJIRCs2TWZVV0NreHNsMWtrcU9ZNk1leFphcVpOQXFZWnZU?=
 =?utf-8?B?WlJvaWRqQmZyYjBoTVhaUUY3QW9aTzBqb08vMTZ3WURCM285ZHk0QUdneGt1?=
 =?utf-8?B?V0NLaDM4dDdEUm9rWmZhZ0QyQUE4MERjajgvYlFQWXFGd3VPQ0t6NzVtckVF?=
 =?utf-8?B?SCt2YmZKaXlIcm80bk1naVJhNW5PK3VGVWZUYzRVODhxQWJDWldDK041Z2dy?=
 =?utf-8?B?UGNDK0RmR0ROdENFamE0Qk85M3kvcTdycWlIT1BNZ0ZkakxVWUxkaDN0VDRl?=
 =?utf-8?B?b0dYWm5yL25NL21TdzBCRlBCUGFNQXhVdXhKNk15OW1WT0RjT05pbFJMS3Zz?=
 =?utf-8?B?VGt4cFFueTFUeWJqRmFaQkwrTzJWT2VOSlo5UDlvS2V3dFUvU0t3eUE3MUJK?=
 =?utf-8?Q?hu9Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a99418d-9b96-44f4-a522-08da70890cf7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2022 11:05:15.6108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wm4mOI4ot1zcA9KeKL2Bnvg1J/9Gg/p18dPSx/ClAjianu09tWm91nK5tURwVWGA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6661
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgS3J6eXN6dG9mLCBQYW9sbywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBG
cm9tOiBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBK
dWx5IDI4LCAyMDIyIDE6MjAgUE0NCj4gVG86IEtyenlzenRvZiBLb3psb3dza2kgPGtyenlzenRv
Zi5rb3psb3dza2lAbGluYXJvLm9yZz47IERhdmlkIFMuIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldD47IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IEpha3ViDQo+IEtp
Y2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBSb2IgSGVycmluZyA8cm9iaCtkdEBrZXJuZWwub3Jn
PjsgS3J6eXN6dG9mDQo+IEtvemxvd3NraSA8a3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8u
b3JnPjsgTmljb2xhcyBGZXJyZQ0KPiA8bmljb2xhcy5mZXJyZUBtaWNyb2NoaXAuY29tPjsgQ2xh
dWRpdSBCZXpuZWENCj4gPGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+OyBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnOw0KPiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZw0KPiBDYzogSGFyaW5pIEthdGFrYW0gPGhhcmluaS5rYXRha2FtQHhp
bGlueC5jb20+OyBSYWRoZXkgU2h5YW0gUGFuZGV5DQo+IDxyYWRoZXkuc2h5YW0ucGFuZGV5QHhp
bGlueC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjIgMi8yXSBuZXQ6IGNkbnMsbWFjYjog
dXNlIGNvcnJlY3QgeGxueCBwcmVmaXggZm9yIFhpbGlueA0KPiANCj4gQ0FVVElPTjogVGhpcyBt
ZXNzYWdlIGhhcyBvcmlnaW5hdGVkIGZyb20gYW4gRXh0ZXJuYWwgU291cmNlLiBQbGVhc2UgdXNl
DQo+IHByb3BlciBqdWRnbWVudCBhbmQgY2F1dGlvbiB3aGVuIG9wZW5pbmcgYXR0YWNobWVudHMs
IGNsaWNraW5nIGxpbmtzLCBvcg0KPiByZXNwb25kaW5nIHRvIHRoaXMgZW1haWwuDQo+IA0KPiAN
Cj4gSGVsbG8sDQo+IA0KPiBPbiBUdWUsIDIwMjItMDctMjYgYXQgMDk6MDggKzAyMDAsIEtyenlz
enRvZiBLb3psb3dza2kgd3JvdGU6DQo+ID4gVXNlIGNvcnJlY3QgdmVuZG9yIGZvciBYaWxpbngg
dmVyc2lvbnMgb2YgQ2FkZW5jZSBNQUNCL0dFTSBFdGhlcm5ldA0KPiA+IGNvbnRyb2xsZXIuICBU
aGUgVmVyc2FsIGNvbXBhdGlibGUgd2FzIG5vdCByZWxlYXNlZCwgc28gaXQgY2FuIGJlDQo+ID4g
Y2hhbmdlZC4NCj4gDQo+IEknbSBrZWVwaW5nIHRoaXMgaW4gUFcgYSBsaXR0bGUgZXh0cmEgdGlt
ZSB0byBhbGxvdyBmb3IgeGlsaW54J3MgcmV2aWV3Lg0KPiANCj4gQEhhcmluaSwgQFJhZGhleTog
Y291bGQgeW91IHBsZWFzZSBjb25maXJtIHRoZSBhYm92ZT8NCg0KVGhhbmtzLCB0aGlzIHdvcmtz
IGZvciB1cy4gRm9yIGJvdGggcGF0Y2hlczoNCkFja2VkLWJ5OiBIYXJpbmkgS2F0YWthbSA8aGFy
aW5pLmthdGFrYW1AYW1kLmNvbT4NCg0KUmVnYXJkcywNCkhhcmluaQ0KDQo=
