Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2189676668
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 14:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjAUNHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 08:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjAUNHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 08:07:23 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2116.outbound.protection.outlook.com [40.107.247.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3CB29144;
        Sat, 21 Jan 2023 05:07:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUl8IK7SH1A6afxe/8cXMTL+1zfUtIfRZPcwGtLWjb4h+AriF69H74ZMj0x6FT3iK2T5rD4rY8uVHrMz/H+oep8I5yO26xu+jk1m8Ebxql8wb6Z5IwwdwLSJTgJQKyPgQpiVxh5jDBIifF8c4MwTTTHRkrGVexUnaP+Zu4M+CAXa+3pDbdMcnIyodeJWwUHCWIARjnGjTfKW0cwKTHJjajLIoUVHws0atuooyCTIsNqiEOH2gmgoVFIMzld+3sKj4BMP/fW5zxbzS8yddPGcipiug7wk750xVDVDacA+QjOCw4/Gj53THXbrK6owta6nB1ZcND4Xo3nrcbnuvS21kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJ1CmjNQgS4vIm1UyTdiuhXUEWMAjLtZSF0dHl182mk=;
 b=VMoLGvxYdRPzGqGG+0s/z6hQKK8BMx+Q3tJ0JUNHsnpsEbwqET51niNHDBKgqAuSX2Jr6/MrxPuw3jYjJxLjyX+gpCz1CNGS+Dt0YU31teeapFpE/iPnpnjgoo51jE+hh2yFrXh2whvvDDnHG6WyQeiS3qq1DAusW0FXzvwwXShAJFOW5dJniH3oma5dcjb+miBDcgv694DK8rE4oOgzQrIVX4fw5jDBAAGnuLWTvGFAvpY6WOa4k5YKbyaHcw/zPydq8y4SXgQHWZ2oouIMiv57+T/8gOETORkgVT8XJvZwMCdLqvCicGJMBWWsg0rPVqYJPbX6SaariTlmmMSCbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJ1CmjNQgS4vIm1UyTdiuhXUEWMAjLtZSF0dHl182mk=;
 b=k0P3UhZ0P2sRMwSiAeGROr+6SGMxLJZL0pGYQCucuTgYSsEkjs/acpZu/FmVBUoCLf48mD0ELR9jW4DeZalDLQ5Y3fAOyRlD2CGcxihgy1LffwTFyi4LwJJ973XVEkwooIoTjOskSTLMt8ImTVkajLm+CKJRI78bGLrXxgkislU=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB9PR03MB9876.eurprd03.prod.outlook.com (2603:10a6:10:3d0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Sat, 21 Jan
 2023 13:07:18 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::5ef0:4421:7bff:69eb]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::5ef0:4421:7bff:69eb%5]) with mapi id 15.20.6002.025; Sat, 21 Jan 2023
 13:07:18 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH next] wifi: nl80211: emit CMD_START_AP on multicast group
 when an AP is started
Thread-Topic: [PATCH next] wifi: nl80211: emit CMD_START_AP on multicast group
 when an AP is started
Thread-Index: AQHZC+LwUYhPDt3JRU2vrpjdOgYnSa6km2qAgAR/Y4A=
Date:   Sat, 21 Jan 2023 13:07:18 +0000
Message-ID: <20230121130717.l5ynezk4rug7fypb@bang-olufsen.dk>
References: <20221209152836.1667196-1-alvin@pqrs.dk>
 <c7eac35785bf672b3b9da45c41baa4149a632daa.camel@sipsolutions.net>
In-Reply-To: <c7eac35785bf672b3b9da45c41baa4149a632daa.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|DB9PR03MB9876:EE_
x-ms-office365-filtering-correlation-id: 68173b17-69f2-4938-7581-08dafbb06cdc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wQLWtnO+bw2kzy8/k8uRFWN7oE82HVH7utYJnQVPhA12DFOQIPqFdaNzNY0SiTDxkF2OQfo5plDllRP2PzlUi7I23ByZJhRi+F5msVXzkgS1JeWGsdjteqSryBY6J2M8O3TgA4UesV7UIb/uh1FQJwNfvF+Im2/Wa6iFZicC2NWfICemdS7nkDvLmY3P2XAf2oD9CF1792imj7rKdhGZQ2WF991uTJrJJGgvSpjyg88eeskRGcMwKjP6X5KEar8pfRP09oquCduIAc8PMKiyJZp6ruFCm4J8FlfY1hAVzeMMV7fV4K5LmaDuSQztbOpRQFjDN3U/6PorleRCZyOuTJFbAc/vZIp/jkUe31hE9ZbezjvPrTNyY4TfBppjBHMUuBamzGITltoWOqHl1P1JgYudvYg2davpllAzkGKJL5MIcjEvEikoF9Idpd4+koOOV4c9c1RgIcJlMaGrOgdDwPSkrUTGZcGk8P5uZJvd1dxksp04eZZoGHgXPWQ7BUTBrlDAB2GZkH8q75YpdtTa2bdEQbwEw3zBFVpDSMwf+BELJpMishdhJyHoClJX9AGz0kO62fEyfoJGtCeOGu09Kas6PawyC2hDmaWAUNGMeu36SnppDpGhVWYsG9fQQ5ZkpIT9vTSQZ+qJ0SJHJysgYYWuTggn9UlTOH9SkM07d4LosOEAjGdKsUCx1V7n/z0PSUFHVKIDzeDSzre6CD8vtw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(136003)(39850400004)(346002)(451199015)(316002)(122000001)(6506007)(38100700002)(54906003)(76116006)(2906002)(1076003)(64756008)(66446008)(91956017)(66476007)(2616005)(38070700005)(66946007)(66556008)(4326008)(478600001)(26005)(8676002)(6916009)(8936002)(186003)(71200400001)(6512007)(8976002)(5660300002)(85202003)(83380400001)(41300700001)(36756003)(86362001)(66574015)(85182001)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ckQwck1sSjFQTmxBZTBpYVFUWVVyK1l2cU9HZjhPRmJvSlQ5Tk9xZEhxOCtL?=
 =?utf-8?B?aEp3bER1UG5KN0dKMUgrbzRqWDcwNXJFeDhadm03bC9vZjBZQWppZWVweW1Q?=
 =?utf-8?B?WlNGU1pMY1Y2c0k3MWhySG9hZjZMaWgwaHpBWnNZWVV3TlRYQ3ZqcE9xVTM0?=
 =?utf-8?B?VTV4VHovOWVHWTQ3MHVqVnEwQnJieFhOQVBJZ2F6WGMwOWZkaXlFYjBQcXhT?=
 =?utf-8?B?VExyeWkxaVVXRXVLYnJscU5icU10YkVNMlBmMktMcVhrK2NBOEhjRG5tbXFO?=
 =?utf-8?B?c25YR1dzRVlCaFBISjUrYnJoRUc0YW10RTRCYlA0M3ZjdjNpVEFDbDl1a0RG?=
 =?utf-8?B?TCs1bllMbUt2bzVjbGdTSG05VEZTRjVLVVN6MzBqdzdZMnY2bWlSUEFNaU1B?=
 =?utf-8?B?M3ZYait3U1d5b0V4VFBuNit5dlM0dkJlL0ZGVFh0UGdCQXRBOEpYYTFuMElE?=
 =?utf-8?B?TTFvNHA2UVFsZGU1bG01OG9ac2tMUVdYR0xvRmQ4ZS90R0JFWlR2R1JWbUFl?=
 =?utf-8?B?R0ZjeHU5blNGc25FZ0pVUGRuUmw4Q01qWDA5dnJoWlF5ZjNOTjg3SE9Dc0th?=
 =?utf-8?B?cXlSejYzVDM3bUNhdmIrUXVhaUh5ekZJVFp3aXhOZEY2bVhDU0RZTE1uOWZ3?=
 =?utf-8?B?SkJiclF1QUJPS3R3U0VTNnUrQkR6SU1RZzJ0b1hGUVpHN0k5V2dZbmU5bGJr?=
 =?utf-8?B?QkVlSXYyYnBpbU5VY0R5a205bW84VGFYeWxWNVhLYXZIS0NYR1hPc2xoZmts?=
 =?utf-8?B?RGRZbWg3dElMVVRIRWgrdWRtSVZFRzdtOFI3eFRseUhNTzdza3ZsaHB2VjhZ?=
 =?utf-8?B?bkVZWDBaSGtYaVVjU0hwbWhCVjlkL2N4VHd5ZlZSVzN2Tk9VVncwR2xwcE1K?=
 =?utf-8?B?MGNYQTN4NGRpWENaZER0NUhkRFFYM1JIU2FMaWNVeXY4ZnA4eVZMME9SVmRL?=
 =?utf-8?B?eXlSYmN5Q0M5ZW5CZXk1TUhOVEtsSGs0b3c3NjlPekRzTGwweFd1TDhrOHdn?=
 =?utf-8?B?dVh1Zm9Sb2JGUEpGekJPc3hKcmJxSnRTRmxOYy9hVnBDMiszWC8yaG80NjVW?=
 =?utf-8?B?aVdiTDdObjErTUx6bE5MSGVXMkJ4M1dPU0grOHRSZUxJek1IaytwQzFNWU1T?=
 =?utf-8?B?ajh3bmlOYlVsNEwxNjcxNmJtdWoxaHljREZhVHNaMVgyYjdLQW5DUHhuS2Qy?=
 =?utf-8?B?SDI0WUphcHhkUzEwem1weFhSS1F6RTNqaVlLTFVpRjFHUkZTRGRuTVVOeHlJ?=
 =?utf-8?B?dVBJaHlJMU1vRnlCZUhVNXNScFdkYmwyN0VmbDR6Wko3UWdqakdpV25SSVFF?=
 =?utf-8?B?WXN5Q1ZXd1dLK2FnVGxnTG0wemZaR05veStJQzZDVWFEQWJIb1RreEE4Vzhs?=
 =?utf-8?B?aVdoU2J5MWpiTnptZUM2UDBJUWdSL3NGREtJeFliY3hpZU9rRE1aSzdLUVF2?=
 =?utf-8?B?OWxsbnFOcjM0QUlYVHlYWXplVEUyckcrYy9ZV2wwZjBoblFaclhCdThSVUJO?=
 =?utf-8?B?aUgrd1g5a0RsdjBmSFgrS3o3aitVU3Z3Y0p6UXZTODJIbVpYNk1GSGVjYlMz?=
 =?utf-8?B?Nmw2QzFOaytCaEp4TDNEbGV6SVFxY004QVVNdExvYkFLaThodW9iT2k2a0NJ?=
 =?utf-8?B?WW5uZldUc2dxR0drdmFMZ2tGeFdCOTZlRXB2MWVCbUdBUkhSMVV4em9Da0V6?=
 =?utf-8?B?a1hRcTNwVkI0aHQ3amd0QnFpd1dSc093a1dPeVRIWDRDRGNxelduTEZER1BF?=
 =?utf-8?B?NzV2K0s4WlhpYkYyelFyZCtLTzVCampzSlFQVFhBemtMcUVWckQvMkJBMWFz?=
 =?utf-8?B?TmwvTXpKeXl6NW1Gd08vN0F5cmxrS2k4YzV2RDVkUndibm14NGVmRitlN3k1?=
 =?utf-8?B?a2lVOXg1cjBUZG8rQnZ2NnN0My80ZU80STB0dG9weWdLdFRBSHBMZkNDLzR0?=
 =?utf-8?B?N2NtWENnQlpWSEdWOXRwcmZaR3hESnhTWDdRZTFnYjFhSWFEQjZuTVhiaWUw?=
 =?utf-8?B?WThMR2ZadGxHbXhLNS9xbzdBQnJEUGNzTUh6VEkyNWxhNTZKZEhjOGhOczdY?=
 =?utf-8?B?Z09WYWUyZUhwRDF4NC81KzZiNXlPd3Y3NTIrM2NBV0hNR2w1RkdkUDZaRGVU?=
 =?utf-8?B?S2VXemRBSy81UTZIaDRsYjBwRzZ1ZkFvS0F0WDUzOCsxd0h4dnlSamgwbVRF?=
 =?utf-8?B?ZHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8059FE88CDC86E4BBDBD3E78FCD980B8@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68173b17-69f2-4938-7581-08dafbb06cdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2023 13:07:18.5080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XgRxJ3OiKMlpWS42w/ijr8hVxPz/LFhWhcJoa2IKJIGbBFlQQw8zYof90AMQVEhxBo2WIUQrWeLaVXADNpsiyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB9876
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSm9oYW5uZXMsDQoNCk9uIFdlZCwgSmFuIDE4LCAyMDIzIGF0IDA1OjI2OjE5UE0gKzAxMDAs
IEpvaGFubmVzIEJlcmcgd3JvdGU6DQo+IE9uIEZyaSwgMjAyMi0xMi0wOSBhdCAxNjoyOCArMDEw
MCwgQWx2aW4gxaBpcHJhZ2Egd3JvdGU6DQo+ID4gDQo+ID4gVGhpcyBpcyBwcm9ibGVtYXRpYyBi
ZWNhdXNlIGl0IGlzIHBvc3NpYmxlIHRoYXQgdGhlIG5ldHdvcmsNCj4gPiBjb25maWd1cmF0aW9u
IHRoYXQgc2hvdWxkIGJlIGFwcGxpZWQgaXMgYSBmdW5jdGlvbiBvZiB0aGUgQVAncw0KPiA+IHBy
b3BlcnRpZXMgc3VjaCBhcyBTU0lEIChjZi4gU1NJRD0gaW4gc3lzdGVtZC5uZXR3b3JrKDUpKS4g
QXMNCj4gPiBpbGx1c3RyYXRlZCBpbiB0aGUgYWJvdmUgZGlhZ3JhbSwgaXQgbWF5IGJlIHRoYXQg
dGhlIEFQIHdpdGggU1NJRCAiYmFyIg0KPiA+IGVuZHMgdXAgYmVpbmcgY29uZmlndXJlZCBhcyB0
aG91Z2ggaXQgaGFkIFNTSUQgImZvbyIuDQo+ID4gDQo+IA0KPiBZb3UgbWlnaHQgbm90IGNhcmUg
aWYgeW91IHdhbnQgdGhlIFNTSUQsIGJ1dCBpdCBzdGlsbCBzZWVtcyB3cm9uZzoNCj4gDQo+ID4g
K3N0YXRpYyB2b2lkIG5sODAyMTFfc2VuZF9hcF9zdGFydGVkKHN0cnVjdCB3aXJlbGVzc19kZXYg
KndkZXYpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB3aXBoeSAqd2lwaHkgPSB3ZGV2LT53aXBoeTsN
Cj4gPiArCXN0cnVjdCBjZmc4MDIxMV9yZWdpc3RlcmVkX2RldmljZSAqcmRldiA9IHdpcGh5X3Rv
X3JkZXYod2lwaHkpOw0KPiA+ICsJc3RydWN0IHNrX2J1ZmYgKm1zZzsNCj4gPiArCXZvaWQgKmhk
cjsNCj4gPiArDQo+ID4gKwltc2cgPSBubG1zZ19uZXcoTkxNU0dfREVGQVVMVF9TSVpFLCBHRlBf
S0VSTkVMKTsNCj4gPiArCWlmICghbXNnKQ0KPiA+ICsJCXJldHVybjsNCj4gPiArDQo+ID4gKwlo
ZHIgPSBubDgwMjExaGRyX3B1dChtc2csIDAsIDAsIDAsIE5MODAyMTFfQ01EX1NUQVJUX0FQKTsN
Cj4gPiArCWlmICghaGRyKQ0KPiA+ICsJCWdvdG8gb3V0Ow0KPiA+ICsNCj4gPiArCWlmIChubGFf
cHV0X3UzMihtc2csIE5MODAyMTFfQVRUUl9XSVBIWSwgcmRldi0+d2lwaHlfaWR4KSB8fA0KPiA+
ICsJICAgIG5sYV9wdXRfdTMyKG1zZywgTkw4MDIxMV9BVFRSX0lGSU5ERVgsIHdkZXYtPm5ldGRl
di0+aWZpbmRleCkgfHwNCj4gPiArCSAgICBubGFfcHV0X3U2NF82NGJpdChtc2csIE5MODAyMTFf
QVRUUl9XREVWLCB3ZGV2X2lkKHdkZXYpLA0KPiA+ICsJCQkgICAgICBOTDgwMjExX0FUVFJfUEFE
KSB8fA0KPiA+ICsJICAgICh3ZGV2LT51LmFwLnNzaWRfbGVuICYmDQo+ID4gKwkgICAgIG5sYV9w
dXQobXNnLCBOTDgwMjExX0FUVFJfU1NJRCwgd2Rldi0+dS5hcC5zc2lkX2xlbiwNCj4gPiArCQkg
ICAgIHdkZXYtPnUuYXAuc3NpZCkpKQ0KPiA+ICsJCWdvdG8gb3V0Ow0KPiA+ICsNCj4gPiArCWdl
bmxtc2dfZW5kKG1zZywgaGRyKTsNCj4gPiArDQo+ID4gKwlnZW5sbXNnX211bHRpY2FzdF9uZXRu
cygmbmw4MDIxMV9mYW0sIHdpcGh5X25ldCh3aXBoeSksIG1zZywgMCwNCj4gPiArCQkJCU5MODAy
MTFfTUNHUlBfTUxNRSwgR0ZQX0tFUk5FTCk7DQo+ID4gKwlyZXR1cm47DQo+ID4gK291dDoNCj4g
PiArCW5sbXNnX2ZyZWUobXNnKTsNCj4gPiArfQ0KPiANCj4gVGhpcyBoYXMgbm8gaW5kaWNhdGlv
biBvZiB0aGUgbGluaywgYnV0IHdpdGggbXVsdGktbGluayB5b3UgY291bGQNCj4gYWN0dWFsbHkg
YmUgc2VuZGluZyB0aGlzIGV2ZW50IG11bHRpcGxlIHRpbWVzIHRvIHVzZXJzcGFjZSBvbiB0aGUg
c2FtZQ0KPiBuZXRkZXYuDQo+IA0KPiA+ICBzdGF0aWMgaW50IG5sODAyMTFfc3RhcnRfYXAoc3Ry
dWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IGdlbmxfaW5mbyAqaW5mbykNCj4gPiAgew0KPiA+ICAJ
c3RydWN0IGNmZzgwMjExX3JlZ2lzdGVyZWRfZGV2aWNlICpyZGV2ID0gaW5mby0+dXNlcl9wdHJb
MF07DQo+ID4gQEAgLTYwNTAsNiArNjA4Myw4IEBAIHN0YXRpYyBpbnQgbmw4MDIxMV9zdGFydF9h
cChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QgZ2VubF9pbmZvICppbmZvKQ0KPiA+ICANCj4g
PiAgCQlpZiAoaW5mby0+YXR0cnNbTkw4MDIxMV9BVFRSX1NPQ0tFVF9PV05FUl0pDQo+ID4gIAkJ
CXdkZXYtPmNvbm5fb3duZXJfbmxwb3J0aWQgPSBpbmZvLT5zbmRfcG9ydGlkOw0KPiA+ICsNCj4g
PiArCQlubDgwMjExX3NlbmRfYXBfc3RhcnRlZCh3ZGV2KTsNCj4gPiAgCX0NCj4gDQo+IGJlY2F1
c2UgdGhpcyBjYW4gYmUgY2FsbGVkIG11bHRpcGxlIHRpbWVzLCBvbmNlIGZvciBlYWNoIGxpbmsu
DQo+IA0KPiBTZWVtcyBsaWtlIHlvdSBzaG91bGQgaW5jbHVkZSB0aGUgbGluayBJRCBvciBzb21l
dGhpbmc/DQoNClRoYW5rcyBmb3IgeW91ciByZXZpZXcsIHlvdSBhcmUgcXVpdGUgcmlnaHQuIEkg
ZGlkbid0IGdpdmUgbXVjaCB0aG91Z2h0DQp0byBNTE8gYXMgSSBhbSBub3QgdG9vIGZhbWlsaWFy
IHdpdGggaXQuIElzIHNvbWV0aGluZyBsaWtlIHRoZSBiZWxvdw0Kd2hhdCB5b3UgYXJlIGxvb2tp
bmcgZm9yPw0KDQpTcGVha2luZyBvZiB3aGljaDogSSBkcmV3IGluc3BpcmF0aW9uIGZyb20gbmw4
MDIxMV9zZW5kX2FwX3N0b3BwZWQoKQ0Kd2hpY2ggc2VlIGFsc28gZG9lc24ndCBpbmNsdWRlIHRo
ZSBsaW5rIElELiBXb3VsZCB5b3UgbGlrZSBtZSB0byBpbmNsdWRlDQphIHNlY29uZCBwYXRjaCBp
biB2MiB3aGljaCBhZGRzIHRoZSBsaW5rIElEIHRvIHRoYXQgZnVuY3Rpb24gYWxvbmcgdGhlDQpz
YW1lIGxpbmVzPw0KDQpLaW5kIHJlZ2FyZHMsDQpBbHZpbg0KDQotLS0tLS0tLS0tLS0tLT44LS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KDQpkaWZmIC0tZ2l0IGEvbmV0L3dpcmVs
ZXNzL25sODAyMTEuYyBiL25ldC93aXJlbGVzcy9ubDgwMjExLmMNCmluZGV4IGJhNDk2NWYwMzVi
Mi4uNTcyMGZmY2JlY2M0IDEwMDY0NA0KLS0tIGEvbmV0L3dpcmVsZXNzL25sODAyMTEuYw0KKysr
IGIvbmV0L3dpcmVsZXNzL25sODAyMTEuYw0KQEAgLTU3NzAsNyArNTc3MCw3IEBAIHN0YXRpYyBi
b29sIG5sODAyMTFfdmFsaWRfYXV0aF90eXBlKHN0cnVjdCBjZmc4MDIxMV9yZWdpc3RlcmVkX2Rl
dmljZSAqcmRldiwNCiAgICAgICAgfQ0KIH0NCiANCi1zdGF0aWMgdm9pZCBubDgwMjExX3NlbmRf
YXBfc3RhcnRlZChzdHJ1Y3Qgd2lyZWxlc3NfZGV2ICp3ZGV2KQ0KK3N0YXRpYyB2b2lkIG5sODAy
MTFfc2VuZF9hcF9zdGFydGVkKHN0cnVjdCB3aXJlbGVzc19kZXYgKndkZXYsIHVuc2lnbmVkIGlu
dCBsaW5rX2lkKQ0KIHsNCiAgICAgICAgc3RydWN0IHdpcGh5ICp3aXBoeSA9IHdkZXYtPndpcGh5
Ow0KICAgICAgICBzdHJ1Y3QgY2ZnODAyMTFfcmVnaXN0ZXJlZF9kZXZpY2UgKnJkZXYgPSB3aXBo
eV90b19yZGV2KHdpcGh5KTsNCkBAIC01NzkxLDcgKzU3OTEsOSBAQCBzdGF0aWMgdm9pZCBubDgw
MjExX3NlbmRfYXBfc3RhcnRlZChzdHJ1Y3Qgd2lyZWxlc3NfZGV2ICp3ZGV2KQ0KICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgTkw4MDIxMV9BVFRSX1BBRCkgfHwNCiAgICAgICAgICAgICh3
ZGV2LT51LmFwLnNzaWRfbGVuICYmDQogICAgICAgICAgICAgbmxhX3B1dChtc2csIE5MODAyMTFf
QVRUUl9TU0lELCB3ZGV2LT51LmFwLnNzaWRfbGVuLA0KLSAgICAgICAgICAgICAgICAgICAgd2Rl
di0+dS5hcC5zc2lkKSkpDQorICAgICAgICAgICAgICAgICAgICB3ZGV2LT51LmFwLnNzaWQpKSB8
fA0KKyAgICAgICAgICAgKHdkZXYtPnZhbGlkX2xpbmtzICYmDQorICAgICAgICAgICAgbmxhX3B1
dF91OChtc2csIE5MODAyMTFfQVRUUl9NTE9fTElOS19JRCwgbGlua19pZCkpKQ0KICAgICAgICAg
ICAgICAgIGdvdG8gb3V0Ow0KIA0KICAgICAgICBnZW5sbXNnX2VuZChtc2csIGhkcik7DQpAQCAt
NjA4NCw3ICs2MDg2LDcgQEAgc3RhdGljIGludCBubDgwMjExX3N0YXJ0X2FwKHN0cnVjdCBza19i
dWZmICpza2IsIHN0cnVjdCBnZW5sX2luZm8gKmluZm8pDQogICAgICAgICAgICAgICAgaWYgKGlu
Zm8tPmF0dHJzW05MODAyMTFfQVRUUl9TT0NLRVRfT1dORVJdKQ0KICAgICAgICAgICAgICAgICAg
ICAgICAgd2Rldi0+Y29ubl9vd25lcl9ubHBvcnRpZCA9IGluZm8tPnNuZF9wb3J0aWQ7DQogDQot
ICAgICAgICAgICAgICAgbmw4MDIxMV9zZW5kX2FwX3N0YXJ0ZWQod2Rldik7DQorICAgICAgICAg
ICAgICAgbmw4MDIxMV9zZW5kX2FwX3N0YXJ0ZWQod2RldiwgbGlua19pZCk7DQogICAgICAgIH0N
CiBvdXRfdW5sb2NrOg0KICAgICAgICB3ZGV2X3VubG9jayh3ZGV2KTs=
