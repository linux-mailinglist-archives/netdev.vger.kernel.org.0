Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A8E678C3B
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 00:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbjAWXrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 18:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbjAWXrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 18:47:46 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2121.outbound.protection.outlook.com [40.107.114.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAC930F1;
        Mon, 23 Jan 2023 15:47:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjIH8A/FTVPpl/ZV2SVZwmtK1rRcI9bYEQuCucLLMYwM7pbXL5WzVBb1T+uRiu9LizaOkhkpF74+7wTdfmvydDALl+ESRpCmAYNGTqwCsSCwUvr7mgr8Y4rFIdMQ9bQpugJ7BtXRXDuW5Z0RrMyKkIhkzDmTdldD59y4LQFQ62Smbyv0tafhlqSKKwCtSLfi2wpg3EsLltLpF7C9Mg8V1FapBz/yZs3+dT9gbK6HLQTuK8KFoFGyzpGlo9d3kx09XWycSluLtXXRYvR/8pd3qKbuxwTuXM2dOfNugUsMfoYubQWvZCwQdoesSdBiaa5VMDQQOl70JEqlosnkZiRNCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lOyF/YJpV6KTBNHcooFEsIec1pDHxlFdKcIdpgK/HRE=;
 b=c9Kmbscr+DBZe4sKZwkSONCbAcKtOwGj6B2vmxIayiTdhj2GtstHNQ+/wQTCV94rggK3i4/gWLx4T+Et9cI+aBqvgDP+8tOs2AaO8PKnzNQUwrZ3XnD8+ILF/ypVhCxEjMfcqFz0KKWAJmWnz7kmXrfHPv3wl8Lo+BiyIGfOKYZ3N4WjRoHl49fLnfGx4wVwV01ynoKnq76tj5EQbSsxrbc+ywJRhfMYsp+BBUA3lz75IjKkMBbQROuey6hA1UkjZbt8uO76/+xVAwuY4NFSj0rnTKk3QJEyw+yveslgx23smMqHBWr/BnanpJwWUcK3pYVyXVS3uErcYDgin6tjpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lOyF/YJpV6KTBNHcooFEsIec1pDHxlFdKcIdpgK/HRE=;
 b=RTxM9FkXzk5QisrN+8igOK1n3qGbfa6mJ7XSZniVqdrVzDlUG0oukv+GCQMqXaQqsr4/aZJrrwH1VszVpou0GxiQ563+Ar6bGec/JCpnpO854js+Jwv21te23PNsI1nJbSY0Q0n9JQEsioIw8aE2SP8XwqgADc8nzeRDxsKVVsM=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYWPR01MB9954.jpnprd01.prod.outlook.com
 (2603:1096:400:1e2::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 23:47:39 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18%8]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 23:47:39 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net v2 2/2] net: ravb: Fix possible hang if RIS2_QFF1
 happen
Thread-Topic: [PATCH net v2 2/2] net: ravb: Fix possible hang if RIS2_QFF1
 happen
Thread-Index: AQHZLyyHDwo2FUcU8UWgcUQfyoXHva6sZuqAgABEjGA=
Date:   Mon, 23 Jan 2023 23:47:39 +0000
Message-ID: <TYBPR01MB5341253256C610D4902F02C9D8C89@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230123131331.1425648-1-yoshihiro.shimoda.uh@renesas.com>
 <20230123131331.1425648-3-yoshihiro.shimoda.uh@renesas.com>
 <912f5eb3-2905-c394-3239-506f8bc9f764@omp.ru>
In-Reply-To: <912f5eb3-2905-c394-3239-506f8bc9f764@omp.ru>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYWPR01MB9954:EE_
x-ms-office365-filtering-correlation-id: 8e955123-0018-4c5b-cd80-08dafd9c369b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GS97n4FrQtyrKAiCROqfAT7T2MaQwsFyA26Vsggf51KjiEKJOu4EYM8ecs+Zy3jakrnJwgeXqHMoEPcVkOe7e7pDCPT71vqVYYVVvo1IJ/BQKrpkmWUy+afoKvSqcBvLRe+QHvlNKib+FqNXIErCdFRDEnNyjTV0+8ZLbr4KMbjOTS70ulF9i0nyXiH6UeoCOFn7in4hCF7KX1iU3KQpTIzdTqhlcHb73qp1eAXskr0Ws0SfB0zwjT+8bQ3FwQfRzTx0JiMALWUY8Dspw2GxhkP0SbuHBGRKE+nSJYt0pEgD7NgLeRq1jlC73UVWNGb1fRNJj8MLgo9hqk/xvMSHrYyPyaM37M8JHkF0o4wKvNM0yltOAQxYfKfAJcSOvjbkMqsqSVvZskHfIQpArja6dtxUNSD1brCIbaCn2mF/ejFDepLoeUdZcuiflwTNZ8oRzeUbO1/ndxy3ma0LX3mtFr9J+XXJPLA2n+RXvz5pYINFPIP1uUPgCRcDAe1lWC2R9dUPiAYf0X+7qAXmcAmKulBUdVLVDT1+o6YchwMOLJMQk1seJkKzEgdbySSAdolloPAXjBceZPf4cMzUqoDM2PM6ZsI2wgamnmKznHTlREzlfLyE4E27a8WOpu8wZj0jYcG5PnpbtHXqr+XyyMKGsHxhJLeK7sinSeXLXVCkj9yWTbFAUWBvx659ZY3/h9BrFBZ9BLWqrKykz4vkutr8MA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(451199015)(122000001)(33656002)(41300700001)(38100700002)(2906002)(86362001)(38070700005)(5660300002)(8936002)(4326008)(52536014)(66446008)(186003)(53546011)(8676002)(6506007)(55016003)(9686003)(64756008)(76116006)(66946007)(316002)(54906003)(66556008)(71200400001)(110136005)(478600001)(66476007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXlaTmE1K3RVNlR6d1JRV29LQzNjQU5UZUFOMEM2WWErSjVuVUZZZDdIaHdj?=
 =?utf-8?B?WnlrNzFSQ2xacm8wZjNVbWNHeGFkVlFlNVNJUWo2dElnSVJhUzNhVXgveDNl?=
 =?utf-8?B?Y3I1bnJaTWFXeUYyb1R5OVJSRHZKNENTUjdXRG5tYjBHZlpjaXRtRTB6Lzl6?=
 =?utf-8?B?MXc5djFSVnNvaVJrdXNtTUQvQVoxTzlaWG5HQXJvdk1pbDFCem5qNmxKaGZz?=
 =?utf-8?B?cFlQN0h4TC8wYmxKYmZNVDlrb2RzZVBsSXdMSUpHNXovbFk1MkxFK2hkbTN4?=
 =?utf-8?B?UjVGWmhRUGYrN2pLU2Y2REJKaTJXMTZ4WHZaWFYreWRrVXgxWGlQZXY3RHNk?=
 =?utf-8?B?L01sOEp6aEZybmh2WTVoOENuWlRsMzVCTUUzMkxrNzdrYVVuQzBHTG4xYTBC?=
 =?utf-8?B?UGNkbG12MnlkVGVwR3VuNWx3MnVpNytXMGZSSW40eVgrK3JJdjVqNGt3NVBt?=
 =?utf-8?B?UTJnWUR3RGEvNC9WWU5ZTldybmtvekRiRlRaMk1MMWJxWlFqMUJoZTY5VG5u?=
 =?utf-8?B?cGM3SGxaSmMvbExIS2ZJU0NDeVZJZUZaVVl1cE5mbjRxZFBRaWJuN0dsNFp4?=
 =?utf-8?B?K1NNdzhDalg3dFRaWUNtakFpSy9keWZ6Q2J2cXE0ak9lZk1QZEtaNEtCYm5Z?=
 =?utf-8?B?MXpxem5pcm8yTVYzQmNVSjE5ZTlkbmVWdGNvU3hocnRUOHppeGtsanFFSVJP?=
 =?utf-8?B?S0F0SExaTlpqUHoyS0gxODl5T01RUk95OEh6RG83STBWcVNQOEpLajEzdXF5?=
 =?utf-8?B?SkFLcGNCUXdWMWVWNExMRWhCZTA2N05Ka2k4L1I0TTExTnNpSW5HSk9aa09m?=
 =?utf-8?B?SUxBWkx0SEpJQnpUeXdYVWx6YjdJaVFwVW04WC85L3FVdkt5elNsWXV1N0dR?=
 =?utf-8?B?NTN0MnllM0t5ZXk4cWFtUmFndU5nZDNhMllOL0lmYWRJeGxubU81WjRGYmxU?=
 =?utf-8?B?TjYvU3U3ei95U1RPL21EdThUQjh3aXk4eDR2TEhvc3JET2NlYnJiY1hRR2lt?=
 =?utf-8?B?dXAwWHhXOFBFejBlUEZtZXlWOGFTZ24yQ1MxM1huck1CbWQzUzBZSVIvZlVz?=
 =?utf-8?B?ZFRxdm1OR1AzZzFobDRWK1RMS014YVgvV1RFNjFoS2krY2xhNlVLTXJEMUo1?=
 =?utf-8?B?QnR3bDBlRVhGMzliV29CTUZhUkJrTC9kNlh4MkwyeXh4THh2Z0tMaXFNV0dJ?=
 =?utf-8?B?dHNmKzUrQ2daS1ZmU3huTW02L1JrdlZjRC9PK2ZScWdSNFBGTUpWemtuME9J?=
 =?utf-8?B?clJ1MmZnNCtEWnJ2L0tWUmtMYi9Ucm9tMXlBL0FCL0EyWkEyaHprdHRDSUlS?=
 =?utf-8?B?WHVsUndOWTBCTEpLTjhqaDAvUmZpNkthWGRTVDlQMm5wV1BmTHlWZ0doZ3ph?=
 =?utf-8?B?R1NqVGV2UHI2bE4wTVdoa0Q0SEdEeHBIR3dhYkQxamtKZkQwL1hwWmtOOFp2?=
 =?utf-8?B?MW9NMFFXZ1ZoSktCOFRNMWhUdzNDV3FOVzdlK1JWVGpOeFl3RUpocmVIenpR?=
 =?utf-8?B?T2s0M3IyTytOU3NSNFJpRzFtWlNqOENIZFhtemQ3dkxiWnZPZi94Q0FYREt5?=
 =?utf-8?B?UE5YT2NvNFlHS1VFM1pJZitaNE5Nd0JwMEVQOExQQVp4VDFEYXhvaVJ6SmpW?=
 =?utf-8?B?YnJUdWhkQXk3M1lNWTJ4OW5oeWphb01XWFJEbmdrZ3A4TEFZSnZiUVEyYWhu?=
 =?utf-8?B?LzRQNmZMYmZaWUN2WmEza1E1U2RqN0NGSVZFYmVVQ2JBMHUwK2V6c3RPOUZp?=
 =?utf-8?B?QVo5UmhqeFdabU9BdDkzYVBLa3U0UnF2UEJxSlBBOWRFbElkYWtOeXNuelZB?=
 =?utf-8?B?YmVLelFOVkZkclNjWEdveDNqNnVNTXUwZk5NWmw2c05RblQ0M2Z3L1VkUHN4?=
 =?utf-8?B?Zjl2TGd3bUhEWlZaNktMRFlVbDV0VmxxU0MyNFhYYitaVzYzVnY1OG9UOFhn?=
 =?utf-8?B?Vno5YlBlRzErQ2crQUVSN1lPRTgwQlNWYS9vZkxkMVFjYUJtQTVkVzRSZHpN?=
 =?utf-8?B?eEMyMHBZYVpPRlpzRzk3RkJKQlpMZlhVenFmY1F5S3A2WS9xaE4xQUNXdGd0?=
 =?utf-8?B?a3dJVDFUN2V6VTl6SXZ5aWRHZEtsUGNXbWlDbUEwYytKNmxydlFUTmR4YUxi?=
 =?utf-8?B?OWdKU2RXSHJTTmxHbjhIZjZVaVdmTVJxclAvVFdBNEFuVUdVN3FsZCtWL2Q3?=
 =?utf-8?B?U053bU80YkZYUktjRE96Lzd1Y3A0Y0xVcnlDYngxYkFsd0hBMFBXOXYwdnc0?=
 =?utf-8?B?OXp5TnIvdXRnUS8rNWo2TERsY3F3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e955123-0018-4c5b-cd80-08dafd9c369b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 23:47:39.8627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1UkFspFDX8J3hykVZwj2XSMPb4Loz004xEYQJ2RzEK6hlq7MzG3fYFnyD8cAV1Dn7JNAXcumDu+a6bU1gGhQiQo8KkxOnxXHqU6i2I3WxeCw/DPc0V1tvVJmA62W3Y3k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9954
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8hDQoNCj4gRnJvbTogU2VyZ2V5IFNodHlseW92LCBTZW50OiBUdWVzZGF5LCBKYW51YXJ5
IDI0LCAyMDIzIDQ6NDEgQU0NCj4gDQo+IE9uIDEvMjMvMjMgNDoxMyBQTSwgWW9zaGloaXJvIFNo
aW1vZGEgd3JvdGU6DQo+IA0KPiA+IFNpbmNlIHRoaXMgZHJpdmVyIGVuYWJsZXMgdGhlIGludGVy
cnVwdCBieSBSSUMyX1FGRTEsIHRoaXMgZHJpdmVyDQo+ID4gc2hvdWxkIGNsZWFyIHRoZSBpbnRl
cnJ1cHQgZmxhZyBpZiBpdCBoYXBwZW5zLiBPdGhlcndpc2UsIHRoZSBpbnRlcnJ1cHQNCj4gPiBj
YXVzZXMgdG8gaGFuZyB0aGUgc3lzdGVtLg0KPiA+DQo+ID4gRml4ZXM6IGMxNTY2MzNmMTM1MyAo
IlJlbmVzYXMgRXRoZXJuZXQgQVZCIGRyaXZlciBwcm9wZXIiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6
IFlvc2hpaGlybyBTaGltb2RhIDx5b3NoaWhpcm8uc2hpbW9kYS51aEByZW5lc2FzLmNvbT4NCj4g
DQo+IFJldmlld2VkLWJ5OiBTZXJnZXkgU2h0eWx5b3YgPHMuc2h0eWx5b3ZAb21wLnJ1Pg0KDQpU
aGFuayB5b3UgZm9yIHlvdXIgcmV2aWV3IQ0KDQo+IFsuLi5dDQo+ID4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gaW5kZXggM2Y2MTEwMGMwMmY0Li4wZjU0ODQ5
YTM4MjMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZi
X21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWlu
LmMNCj4gPiBAQCAtMTEwMSwxNCArMTEwMSwxNCBAQCBzdGF0aWMgdm9pZCByYXZiX2Vycm9yX2lu
dGVycnVwdChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikNCj4gPiAgCXJhdmJfd3JpdGUobmRldiwg
fihFSVNfUUZTIHwgRUlTX1JFU0VSVkVEKSwgRUlTKTsNCj4gPiAgCWlmIChlaXMgJiBFSVNfUUZT
KSB7DQo+ID4gIAkJcmlzMiA9IHJhdmJfcmVhZChuZGV2LCBSSVMyKTsNCj4gPiAtCQlyYXZiX3dy
aXRlKG5kZXYsIH4oUklTMl9RRkYwIHwgUklTMl9SRkZGIHwgUklTMl9SRVNFUlZFRCksDQo+ID4g
KwkJcmF2Yl93cml0ZShuZGV2LCB+KFJJUzJfUUZGMCB8IFJJUzJfUUZGMSB8IFJJUzJfUkZGRiB8
IFJJUzJfUkVTRVJWRUQpLA0KPiA+ICAJCQkgICBSSVMyKTsNCj4gPg0KPiA+ICAJCS8qIFJlY2Vp
dmUgRGVzY3JpcHRvciBFbXB0eSBpbnQgKi8NCj4gPiAgCQlpZiAocmlzMiAmIFJJUzJfUUZGMCkN
Cj4gPiAgCQkJcHJpdi0+c3RhdHNbUkFWQl9CRV0ucnhfb3Zlcl9lcnJvcnMrKzsNCj4gPg0KPiA+
IC0JCSAgICAvKiBSZWNlaXZlIERlc2NyaXB0b3IgRW1wdHkgaW50ICovDQo+ID4gKwkJLyogUmVj
ZWl2ZSBEZXNjcmlwdG9yIEVtcHR5IGludCAqLw0KPiANCj4gICAgV2VsbCwgdGhhdCBzaG91bGQn
dmUgYmVlbiBub3RlZCBpbiB0aGUgY29tbWl0IGxvZy4uLg0KDQpPb3BzLiBJIHRoaW5rIHNvLiBT
bywgSSdsbCBzZW5kIHYzIHBhdGNoLg0KDQpCZXN0IHJlZ2FyZHMsDQpZb3NoaWhpcm8gU2hpbW9k
YQ0KDQo=
