Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB3251F6AA
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiEIIM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 04:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238946AbiEIIKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 04:10:22 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2124.outbound.protection.outlook.com [40.107.113.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C301A29F4;
        Mon,  9 May 2022 01:06:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=csiRL0Mc2a54JS0JSkFlCCSG90whm/H6wcm8YRjaa++VvF7ChP2BJwc9Wv9Mcxb6eHcvbUjL+M/wc66DX3cMpsuRSVvZB5VqVDBmMLXF/bJEQTsFMPrJV3xrPWg9LozGOGY3xcOPnDnbG7oHgPMywP6NH/Dotb2+dWEIZOXOeOJ3b/4+oJi/BUcbPQQdZjZHgcF7Cbxuyk7TX4qxPLuyS2c1PFCWS2VMC4HaCgA8QEcjYPVj9foEX6v1ZUuuvwBP7ZXYyKEo2QItvscpaX9xuhJiRIw5e9YES+9LZbK7qk4yEjLvfOoeEBbutrIWUq+a647JXV33JTnuKYHBUV+u9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UZpPuch57HolDOz4Fd//l0rXDa+zk8mNfurpBh+X2x8=;
 b=IVqEkho0TtqQ62JicX0POoYJrkxYMclxOYmbm1FAPYZbIbZcOmovNFer+EVsWluOeI/IKwwnxaGLh7IW3nSJ3LwmzlVKEUZf5hF2XgLtozM/ZlELp7YsQZCAHW7ryboleNrQIVBbPIvESu66dVvUE5LOoi8HQ5bgLuiWJs4jwUxOeBmJewNpefZwChKrW5Ov2gbsU7ZBkbse9na2KiYHf82MyRr2PLr9F6cG6+m3Sb1tXgfKdqZuLp0VhYJJT9ItH4i0EVjuYYvk+CoNhx/BElSELYIuiRcTzzqE0dMXNl4mDdlHqN17vKX9OZT45R/vlZDNQrAsw0WYWvmqbkIEog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZpPuch57HolDOz4Fd//l0rXDa+zk8mNfurpBh+X2x8=;
 b=YcesTrHcw39kasYIHHY44XGpNNr4W0eExxWCnoBve+Ag3tWYKf75rP8VkbYYDIFMBaS/hsR/sXsK7ttgugrcUaFZvkUy0wc54ilkdOv5KlB84J8EG72Z7uvshAMNKavbQpiSanx6TzK9Iefo/QESfJ9SiOhIXsba4uORUHjF12o=
Received: from TYYPR01MB7086.jpnprd01.prod.outlook.com (2603:1096:400:de::11)
 by TY1PR01MB1497.jpnprd01.prod.outlook.com (2603:1096:403:5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Mon, 9 May
 2022 08:00:04 +0000
Received: from TYYPR01MB7086.jpnprd01.prod.outlook.com
 ([fe80::e180:5c8b:8ddf:7244]) by TYYPR01MB7086.jpnprd01.prod.outlook.com
 ([fe80::e180:5c8b:8ddf:7244%7]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 08:00:04 +0000
From:   Phil Edworthy <phil.edworthy@renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
CC:     Biju Das <biju.das.jz@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 5/9] ravb: Support separate Line0 (Desc), Line1 (Err) and
 Line2 (Mgmt) irqs
Thread-Topic: [PATCH 5/9] ravb: Support separate Line0 (Desc), Line1 (Err) and
 Line2 (Mgmt) irqs
Thread-Index: AQHYX8cgVuYFAmLQlU6bZk72FbKjSK0QsHsAgAV7UfA=
Date:   Mon, 9 May 2022 08:00:03 +0000
Message-ID: <TYYPR01MB708621F60F440B8A62E72AC3F5C69@TYYPR01MB7086.jpnprd01.prod.outlook.com>
References: <20220504145454.71287-1-phil.edworthy@renesas.com>
 <20220504145454.71287-6-phil.edworthy@renesas.com>
 <80099a39-5727-85fd-1988-01cef8793cc2@omp.ru>
In-Reply-To: <80099a39-5727-85fd-1988-01cef8793cc2@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fff5509-ff3d-4896-17e0-08da3191ecd2
x-ms-traffictypediagnostic: TY1PR01MB1497:EE_
x-microsoft-antispam-prvs: <TY1PR01MB149772A7C8BBA74703337348F5C69@TY1PR01MB1497.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CM5D94wz3tfCgBmN/V4nTx8+2Q5NB1RgGyR1xZYU9b82OjOcfyq6FO8UqGhyGJslJNetjIQGbm2RTEI8DYDPBC1nSoQNoPw2E/AzIYEzsDv921Jb2T5w14WecU7AlGLMrIOYk/qMkSVqk8i1COT3p7pC8dNBk1ErlszbdSfNrFIFF9poHXDHud6RhCR1uKM/l6fQp8me0lEd68HCoVoB/UlzKzyd5s2z4xrNNaBscwHBspA6vjqUb2U4Sx1ZuMKN7o8fnekC+iSaiKTHDwwFPPrHmQe3+M7oe1MOG0qcA55VhziflEzWoRHp7ZgoClXB3weVSxKJWezGMYzDaChfL9toi3s/cc/gRBGP0H/eqsPklm7DDiiSXm2ELHUrKg1lEqboPcdLYHIFf1xnbhlWPmYResbyzPZF9zY85tM0ZTJH0vrF+VwYPAozeCcqR7wxgsj9n2xAVAFKQd6vPiaCnXZCpyTtZvCZnqb8KwCjcbHqgaZcKVUoR61jLI6d2fEry6VzqdLiITywr8KW6vE5opu8EuGY4qrIGZjXWa2XJ4jHV1cfD+a+lg9zMGN5JFfKmpqSXjGK+5RzbHh0uxqyiPuCQ7+9LXVeLC7gRr7FNNaUxZKBBip7vk8SJTccLjvmisHca0VX9gyKr/9PmQQqq0DO/ofIcyhqEZMBh1H06qh2zlmingG6be4sB6rYUMkRxhdw00WquVgnudJgV71Hsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYYPR01MB7086.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(186003)(9686003)(86362001)(38070700005)(54906003)(83380400001)(110136005)(508600001)(71200400001)(7696005)(53546011)(26005)(6506007)(316002)(122000001)(8936002)(55016003)(2906002)(66946007)(66476007)(64756008)(66556008)(8676002)(66446008)(76116006)(4326008)(33656002)(52536014)(44832011)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TlZBQWMrRElqclhQbWlxZEZvR0lWblUzVm9nNFVqa2JJQXR3ckhRR2FvQldJ?=
 =?utf-8?B?SU9HQ0M0YkRadmFzcHhlWXhYTDhCYnh3azlKcHIwVDdBZk1UQUUzUDJ2Sk1U?=
 =?utf-8?B?SmFhZzlCaVlJWDZHL3dMTjMvVlFMV0wvNGF5MnFzc2FXMm1QODdwMDdSeGNY?=
 =?utf-8?B?djFIb3lzd05OKzdJVGdjWUkzQW05dFlJTlVPUDBpb2UxbHludWhvS1VRNUZj?=
 =?utf-8?B?M3p2Yk5heGRiWnVlMitWN29FMkFxcDZFQi83djhlYjJhV1BrRXovU1dhcVhL?=
 =?utf-8?B?bHExMTB4dVhVQVptemtvN2pKd2Y2STNzYXFvb28yZnJYZUtNZkYrQ3V3N1pq?=
 =?utf-8?B?cGFuTXVheTRuVjNRdWxCN1dLUkRoWGhZUVdFWmtoYUdETHkvMFpmVi9EekFX?=
 =?utf-8?B?OG8xQzZEMksxS2NrWnAyelo0K095RzFBU2RRcUJBdU04emNlWHBjQ3pkVWVR?=
 =?utf-8?B?UzZaK0ZvOFdXS0NJaWFCU0NSdTljR1h4amtWdEdURGFQTWVZak11TGZPTFlH?=
 =?utf-8?B?Z00zU25mVUZTVWI4MEt3R2kvNE9DeWVuWklHd2xVeGEzdzc1Nk85UzkvTzhp?=
 =?utf-8?B?alBmRFZPc01uUGl6SGR6QmFaS0s3VWYvMVo4K2M2TFE4cG80Y2RiVlRFckpG?=
 =?utf-8?B?MFFYbWZ0eXBsMHB4Y2NLeVpkeEw4VXg4K0V2VE5selovVExEekJnMXRVVUlO?=
 =?utf-8?B?SnhWN1duQWJHMVI1SC8vNnNxNWhFQnFSTUt5OGRXVDIycWxvWXhmVzg0Nk5i?=
 =?utf-8?B?VzEzSWU3Ymt2OFZFakRVS1A5LzVXTkJLUVZrWjdDTVJ4NkRMcU43SEo3VHUv?=
 =?utf-8?B?YllvcVlMV25BdkxycFg0NGp4b2ppOVhxaWVBYndBUXYzVFZJSWZ2OEplODJG?=
 =?utf-8?B?cWtFeFRmejNtNWsxeDdQcFNQWUQxcGJxR0lZaFo2WXpPRWRVRkhSWjJwc0ZC?=
 =?utf-8?B?b3c2Qml1a2lkVitZc0pxL05MeVRISFJDblhWZWEwYW5lNUlGOGk3aEJkTnRK?=
 =?utf-8?B?VUs3TjJXY1BpamVpaW9WbnhycGx4Zjd2TkQxcEtPTldwc05BOElwMHhmQzFv?=
 =?utf-8?B?R3orUk5wbDNVZ05rUjRDdzlsRjdnRktSa3RVWXVJMjZFTTMrQ3FiUmdXUy91?=
 =?utf-8?B?NjE4bHFDWmE3elZrM09LUlFvYlRKSzdrZzQ2cEgzV3FRZGpURXFLWm14UlFs?=
 =?utf-8?B?YVNWQ3p3ckNFOC9STkRtTG5kYVVEMUwwOXNlWVB5YTdTRE9oNTBHaVhxV3FO?=
 =?utf-8?B?QlJubi9rOWRwMTlSR2FyVEM1U2RXQ0NkdU9icWdDNWpicW1uS1R3L1l5c0ZE?=
 =?utf-8?B?ZkVkVWtEQkVIL1JNa3I0TktKUjd3VTRtQUVFc0dGaGdBOHJkRlRERUxpYmZh?=
 =?utf-8?B?YWY0b0VQcWVmcTB5M2dlZ2hzT0RhdHc1cnlyL3h2aU5TWkRyVXpuZFRBNEov?=
 =?utf-8?B?dUFvV2VtcS9ySFBkMUREWWg5eW0ya05UMFovV3dlQUZlOUVmWGpRL2hvdkhQ?=
 =?utf-8?B?QXpkK2VuZHRMNGdqTHRTUklqQi9hWUYvQXdwTTB3akhnWmV5SGRUTzI0VW4r?=
 =?utf-8?B?WEVTZHhBVmNPQ2xhbnZvcDlrdVpBOXI0S3RrQXNnL3U4SVAvSFFuV0JqYXAr?=
 =?utf-8?B?MWpvWHh1SndIMjJFS2tVaXFwa2thT3FRMlhNWHdYdWZMZU9VMmc4cElQVWoz?=
 =?utf-8?B?QVhpNGVFS25UWjlCSWNBZDNERmdNbFhsNjhYV3BsY0hGWENqeFFJUENjQ1FY?=
 =?utf-8?B?WHRoRnBlY0taRzdQdUtDRjd4aE9qKzJlWUphaS9HV2YvN2xqdXc3NVFkSVBR?=
 =?utf-8?B?QWlpSDdGRStQanI2RVdZaWJENmwwaTg5ZGRsTWxkVjIrdTlabWpGTHI4V3I3?=
 =?utf-8?B?dSs2dEN0VWVWTUwyVUNJcUI2akFmWjFiUGt5YkNkTG1qRTYrRnRyQjVXbDdO?=
 =?utf-8?B?VjR0SWh6NzVhK1RoeWRQSWliM3BMc3I4cXZlcVhtS1NMR0xJcmJRQjk2d29j?=
 =?utf-8?B?b2hoZnBoQi9jWC90SlVmNlU3L0hYem5KRmlHOHR4b2Q2RjNMU3Y0dG1qbGh3?=
 =?utf-8?B?NWszaTMvSUZBaGNsMjgyNVpaTUhIWk9YTEZCVUo1VkovTWRqUjNPVCtSYkw0?=
 =?utf-8?B?Ym92ZkpKQjBaTUpoMnFmY3VXVC91UEhHWkhRS0hMMTBFWU1sL2dFUS93WHVm?=
 =?utf-8?B?M3dhaHM0SEU1UFFleHN5cGNsTjZ0SFpvZ0ZNM3pXektiQllmVFBYenJEV2Rx?=
 =?utf-8?B?dE1BMFY2Mm5CVllOVng1R3pLRHpFeEZqOTFhdVpPUkZJUWRYbUVmSXVDTmQw?=
 =?utf-8?B?aVJtLzBXVDJWUGQ3L1FlUkZJL3RaclBNVmpyT1lxQnRCKzZCZlJaZzFFaG5D?=
 =?utf-8?Q?jMhfhRepOZ5Hk7Jc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYYPR01MB7086.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fff5509-ff3d-4896-17e0-08da3191ecd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 08:00:03.9400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BEL2gicTTanu+GXoEkqO8DlGvrU7G5zEaet4xgP1UwqpEycaytreoj0Rql6nHgIVsXndKLvcrINcuNfGl85ltgYEs/64+QKuJAba6y+23Ik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PR01MB1497
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQpPbiAwNSBNYXkgMjAyMiAyMDo0MSBTZXJnZXkgU2h0eWx5b3Ygd3JvdGU6
DQo+IE9uIDUvNC8yMiA1OjU0IFBNLCBQaGlsIEVkd29ydGh5IHdyb3RlOg0KPiANCj4gPiBSLUNh
ciBoYXMgYSBjb21iaW5lZCBpbnRlcnJ1cHQgbGluZSwgY2gyMiA9IExpbmUwX0RpQSB8IExpbmUx
X0EgfA0KPiBMaW5lMl9BLg0KPiANCj4gICAgUi1DYXIgZ2VuMywgeW91IG1lYW4/IEJlY2F1c2Ug
Ui1DYXIgZ2VuMiBoYXMgc2luZ2xlIElSUS4uLg0KPiANCj4gPiBSWi9WMk0gaGFzIHNlcGFyYXRl
IGludGVycnVwdCBsaW5lcyBmb3IgZWFjaCBvZiB0aGVzZSwgc28gYWRkIGENCj4gPiBmZWF0dXJl
IHRoYXQgYWxsb3dzIHRoZSBkcml2ZXIgdG8gZ2V0IHRoZXNlIGludGVycnVwdHMgYW5kIGNhbGwg
dGhlDQo+IGNvbW1vbiBoYW5kbGVyLg0KPiA+DQo+ID4gV2Uga2VlcCB0aGUgImNoMjIiIG5hbWUg
Zm9yIExpbmUwX0RpQSBhbmQgImNoMjQiIGZvciBMaW5lMyBpbnRlcnJ1cHRzDQo+ID4gdG8ga2Vl
cCB0aGUgY29kZSBzaW1wbGUuDQo+IA0KPiAgICBOb3Qgc3VyZSBJIGFncmVlIHdpdGggc3VjaCBz
aW1wbGlmaWNhdGlvbiAtLSBhdCBsZWFzdCBhYm91dCAiY2gyMiIuLi4NCk9rLCBJIGNhbiBjaGFu
Z2UgaXQuDQoNCg0KPiA+IFNpZ25lZC1vZmYtYnk6IFBoaWwgRWR3b3J0aHkgPHBoaWwuZWR3b3J0
aHlAcmVuZXNhcy5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBi
cC5yZW5lc2FzLmNvbT4NCj4gDQo+IFsuLi5dDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBpbmRleCBkMGI5Njg4MDc0Y2EuLmYxMmEyM2I5YzM5
MSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFp
bi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0K
PiBbLi4uXQ0KPiA+IEBAIC0yMTY3LDYgKzIxODQsMTAgQEAgc3RhdGljIGludCByYXZiX2Nsb3Nl
KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQ0KPiA+ICAJCWZyZWVfaXJxKHByaXYtPnJ4X2lycXNb
UkFWQl9CRV0sIG5kZXYpOw0KPiA+ICAJCWZyZWVfaXJxKHByaXYtPmVtYWNfaXJxLCBuZGV2KTsN
Cj4gPiAgCX0NCj4gPiArCWlmIChpbmZvLT5lcnJfbWdtdF9pcnFzKSB7DQo+ID4gKwkJZnJlZV9p
cnEocHJpdi0+ZXJyYV9pcnEsIG5kZXYpOw0KPiA+ICsJCWZyZWVfaXJxKHByaXYtPm1nbXRhX2ly
cSwgbmRldik7DQo+ID4gKwl9DQo+IA0KPiAgICBTaG91bGRuJ3QgdGhpcyBiZSB1bmRlcjoNCj4g
DQo+IAlpZiAoaW5mby0+bXVsdGlfaXJxcykgew0KPiANCj4gYWJvdmU/DQpDYW4gZG8sIHRob3Vn
aCBJIGd1ZXNzIHdlIGNvdWxkIGFsc28gaGF2ZSBkZXZpY2VzIGluIHRoZSBmdXR1cmUgdGhhdA0K
aGF2ZSBzZXBhcmF0ZSBlcnIgYW5kIG1nbXQgaW50ZXJydXB0cywgYnV0IG5vdCB1c2UgdGhlIG11
bHRpcGxlIGNoYW5uZWwNCmludGVycnVwdHMuDQpJJ20gZWFzeSBlaXRoZXIgd2F5Lg0KDQo+ID4g
IAlmcmVlX2lycShuZGV2LT5pcnEsIG5kZXYpOw0KPiA+DQo+ID4gIAlpZiAoaW5mby0+bmNfcXVl
dWVzKQ0KPiA+IEBAIC0yNjY1LDYgKzI2ODYsMjIgQEAgc3RhdGljIGludCByYXZiX3Byb2JlKHN0
cnVjdCBwbGF0Zm9ybV9kZXZpY2UNCj4gKnBkZXYpDQo+ID4gIAkJfQ0KPiA+ICAJfQ0KPiA+DQo+
ID4gKwlpZiAoaW5mby0+ZXJyX21nbXRfaXJxcykgew0KPiA+ICsJCWlycSA9IHBsYXRmb3JtX2dl
dF9pcnFfYnluYW1lKHBkZXYsICJlcnJfYSIpOw0KPiA+ICsJCWlmIChpcnEgPCAwKSB7DQo+ID4g
KwkJCWVycm9yID0gaXJxOw0KPiA+ICsJCQlnb3RvIG91dF9yZWxlYXNlOw0KPiA+ICsJCX0NCj4g
PiArCQlwcml2LT5lcnJhX2lycSA9IGlycTsNCj4gPiArDQo+ID4gKwkJaXJxID0gcGxhdGZvcm1f
Z2V0X2lycV9ieW5hbWUocGRldiwgIm1nbXRfYSIpOw0KPiA+ICsJCWlmIChpcnEgPCAwKSB7DQo+
ID4gKwkJCWVycm9yID0gaXJxOw0KPiA+ICsJCQlnb3RvIG91dF9yZWxlYXNlOw0KPiA+ICsJCX0N
Cj4gPiArCQlwcml2LT5tZ210YV9pcnEgPSBpcnE7DQo+ID4gKwl9DQo+ID4gKw0KPiANCj4gICAg
U2FtZSBoZXJlLi4uDQo+IA0KPiA+ICAJcHJpdi0+Y2xrID0gZGV2bV9jbGtfZ2V0KCZwZGV2LT5k
ZXYsIE5VTEwpOw0KPiA+ICAJaWYgKElTX0VSUihwcml2LT5jbGspKSB7DQo+ID4gIAkJZXJyb3Ig
PSBQVFJfRVJSKHByaXYtPmNsayk7DQoNCg0KVGhhbmtzDQpQaGlsDQo=
