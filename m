Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B1E5BF901
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 10:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiIUIXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 04:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiIUIXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 04:23:11 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760B3357FF;
        Wed, 21 Sep 2022 01:23:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fY7ejdTGKKlLsqNxm3a0pufCwmwXQgtWAdujPFyb55d5XKHMbQ3DudBacFptEf54kNauBzLvE4QUgdKa7sgroLY2nZnYmPoR6yaQsQUo8fT/UH9P0YFknz838VXwrxAMoQsa5w2kXatQ5pMhsHB93oEaL/DYyS7BfKP2bUmAFQyaLcxkhaWaYU4DpWzeSEW1o1K1URQB5z7i634bx1hq8WQiOpCTaF8D3WL4kKuoUKzfcia8utJaAW0f/be8FVBOEdIjKWkVXadN8EslFMKJyErnVJI62Szg2ZqoZ4aEWSZVP/iHPwY4ikbjXD+hukNBmJqzNUdPs0DW7/QE1qUmHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vMtK/J4xzfFuRERFJ0zn5YU17VV6V/9W41SoT1j2fL0=;
 b=bMFrw1tlJbF4VMElONnr+YnvpaCVZKDUyyOwJ9hh5n8REjlbudLvfMOxL6y59ghsjQ3dVpst99hhkqMe192a2gOj9WeZjNJEiexIjewBYPGTp1Mab5c51+Z8R9wWp7AbnrRkNwTI1Y/jttgHYY6uL2ul8um2IxTkEPpgQ8ySKIA0luylDZMHm29qYoeFs50afee8DTevoYMC+Y3mva+1ykCfrZnXNPHOmA3P3Gz6JwGrhfWix1mlqVtr8xBl70tkAnUuc3EQXyB2xU0CgZ3tYDKTXOf9Ebgv3uEdtnaqyL+i/URvM3Gq+uT3wRW8INm/XWE4q41rGNBuWZKKbQvDMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMtK/J4xzfFuRERFJ0zn5YU17VV6V/9W41SoT1j2fL0=;
 b=MPi+JefzcfpaVi9Ke6EIjdBQlToGWy6qqEmmF7t8UBrnHcSGhHmAVKVP5cIyd+MbdZBQMmvpwr4odTcWIyUcbcW4MKt7KQ2ckO6rdyKbXWsx5O0bdRK5iVKHDVLo6qKJ5HlxwP+739GK0/r4S5J2LmsbKI+3Razi6ur6wXRvn10=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by PH0PR12MB7096.namprd12.prod.outlook.com (2603:10b6:510:21d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 08:23:02 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::8193:5c0c:4da8:7aad]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::8193:5c0c:4da8:7aad%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 08:23:02 +0000
From:   "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Sarangi, Anirudha" <anirudha.sarangi@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>,
        "git@xilinx.com" <git@xilinx.com>, "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC V2 PATCH 2/3] dt-bindings: net: xilinx_axienet: Introduce
 dmaengine binding support
Thread-Topic: [RFC V2 PATCH 2/3] dt-bindings: net: xilinx_axienet: Introduce
 dmaengine binding support
Thread-Index: AQHYzLX80omvClF6lEGcjrTn7V6R463pgsQAgAAA2WA=
Date:   Wed, 21 Sep 2022 08:23:01 +0000
Message-ID: <MN0PR12MB5953B2E399B48AC410F4AC2DB74F9@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <20220920055703.13246-1-sarath.babu.naidu.gaddam@amd.com>
 <20220920055703.13246-3-sarath.babu.naidu.gaddam@amd.com>
 <d179f987-6d3b-449f-8f48-4ab0fff43227@linaro.org>
In-Reply-To: <d179f987-6d3b-449f-8f48-4ab0fff43227@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB5953:EE_|PH0PR12MB7096:EE_
x-ms-office365-filtering-correlation-id: edbbb5ec-ffa8-4958-7928-08da9baa7fe2
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U3ikN+n+DG1/4KqJ49FPvkwIVXrlC9jw+1s1Siw1Q2dFy5oNHjdeltYuA8lRiKbv6BOKtfX3VN9SHB22WGhHZAUAnAqjFyAqmYBVPxulWJT/qsHZxvDkAycLoXpAJ7t+7xVUurnfM8FXDmI3njJ9EqtUSCuhesEoFYy5aVrZGf16hK9HzGWj+sZabwuQa02UTQkrJmyLWPH58peklkZMt00lNKC163mwBo1+O6jPfoa1Vzfzhp02ofiiKsazOyk/NqrWHW5jbKhy4RMm+4rDc9lRhgrwtaSGWD00aV78+6K+wDDlrfY++FfkmOfWQAvmnPx7uawfLEBWUrItsJ8Rx5YJkVEBrRTbfXDzlcHS/jER7E25FMfqCqt0LiOlx5XH+Aoi/jknTaGwMYGD+tTUjIcSzuJRsQqB4daQqVp7iVYykU+nSdEK9KwYh5kjQ8WThY3+jV9OpON3S65VzVSWh10JLf7wIY1MLxg/o92iKBNi07MKui1pe8xAwHwmRFwUqG4jao2WKjZAVskNALGOirtDZHbx+OpplQhQ6SWVvwo9gosrfELA9PCTxW948i4m7S5CUujlK81YIKpuUKL467AjnuDyBVj+0Pq0kmfdWQgL+fBux0xu7YJulZokNxQUvCNlnKEyL5SyvEB7RjZH1kCaIxgNcYyZkPQvCND6f3RuAbQKB7xHT6mZrbE64kjgdC4Zjgc9rT83lB2K2F25X+sGkGPqt0U6BqiLJ5LeYBywc5tpBzfquNUZ/sMddMGoRUAllgdT4Olexn5g6EfQE2yzMuEUhFCfdLpxr/fuaKo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(451199015)(122000001)(38100700002)(921005)(38070700005)(2906002)(33656002)(478600001)(71200400001)(8676002)(8936002)(66946007)(66476007)(66556008)(64756008)(66446008)(4326008)(76116006)(54906003)(110136005)(316002)(52536014)(7416002)(5660300002)(9686003)(55016003)(41300700001)(6506007)(53546011)(7696005)(83380400001)(186003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TzY2RkpUaUtqczNOSjdiN1JtNHN2d2JwbmJnV0ExbW5Zek1CdzlhaVNPZWUw?=
 =?utf-8?B?QlFITURYNUFuYW9sSkZlZTcycTl5MmIwL2V6Z2dmTTNpei9EeHo1Z1ZCcjVN?=
 =?utf-8?B?NDZXMXkzejUzbzRBMDg4Qy9ObFBlZTdJN3F4Y2pTVlgxMGgzUlVPdUcxQ3gx?=
 =?utf-8?B?b0RiSklON3k0NzU5Mzh6dUZvOCtNVXlYR1NLWGxIQ3pydHdHTDNNU1BydXdN?=
 =?utf-8?B?MjFVdXhuZGNrMENiQnBzZThwei9FWStxeFRWbkVYRzBQSDlIWGhTdnoyZUMz?=
 =?utf-8?B?V28wUjFncUV5MFhnQk5pa29taGREVndyMnBPMU5XSjl5MFRLWEhhbHgzWHJy?=
 =?utf-8?B?YUR0ams4RlVPUHp2NU1JYllJU1U2M2x1SjFzSTVVcm9NVXhtSG55QVJTVG9O?=
 =?utf-8?B?Z3hGQWg1RTM4TGtyTityN1hPbExPNjZpNS9TcUhRcmFXV1pTNHF3WjdXRXZj?=
 =?utf-8?B?U000WGxJYWM1QWpIWmxONlJPN1h0NXNzeDM5am5HejZLYWxiYURmNWd0VEo3?=
 =?utf-8?B?WkU1elhxMDJacDZHMlhXVEcxb3VBazdONGk5QjR2ZSsycWkwL0pKMU01Nk1F?=
 =?utf-8?B?ek13ZDZhREI0Qi9nb3R2SDBrVWlZWkZSUGIvMTZVbCtHNy9LUnpmV0J6M1NX?=
 =?utf-8?B?VXZzSXh6VzhmRkJWMGJnWFUyNFd2dyszT2hWQU83ejZpZkVLdEgwWXZpZ1RX?=
 =?utf-8?B?NlBrbHh1T3RtMkY3U1R1NGZ1Qkw3THdJUE1qNC9LWVBNRVdyVGFsODdLNlFF?=
 =?utf-8?B?TlB5bFdaWmVRYkYrMWlXaGdkU2VJbFpGcEcxb2ljMWFPVk9vUXFvVFpJZm9z?=
 =?utf-8?B?cVNxSk5Fang1VkR5SWtKdVRPSjZ3bUZscmRacTRCNVhBYXBxR2tBK3BXWHNF?=
 =?utf-8?B?WmZNQ0ZmbC9kZ3B0R1ZTT2FGWllHZjZEdmI4NlMxZms1S2dJblhlaFRESjZm?=
 =?utf-8?B?eTV0M2hDMkgvT2s4a0dseE5oSTQ5bTk0bFBMeGJ1cStRaHNBNUtzNmxESDBo?=
 =?utf-8?B?WlBraFRhZ2o5YmY4U0dXcnFQOURVaWV6akZvOUFzdWVRSkY3cnQwbmZBQUE1?=
 =?utf-8?B?RFJWaHhRVnhkRzN2MXZpdFV0bG5FaVRQMEM5MEYxTUtDaXk5a29UU0orTi8v?=
 =?utf-8?B?eHBleXFVWitQNzBoMU5EdXVPbU1JQ0VjQU82MDRVZytBd0lhb0J5UTlJdWtG?=
 =?utf-8?B?ZGRzVTQvcEQ5bmJJUzF1RTMzcDhwcStRc00xenJCV1NvcFNJb054RHlvbkpH?=
 =?utf-8?B?YVFBUWdQVUt5M1JGNWZNbFd1VWRVTVVvS2Q4dlIzVldFRVpTZCs4Z2wyYXFR?=
 =?utf-8?B?TVFRSTlDT1hHZjFhUVZJZDlaVTYybjN3QkFTa2xmb0Z1UkpiT0NSblRMbHJY?=
 =?utf-8?B?dm5jTHNlVENmMDVPR1E0cExONmRTMS9Jd1I1V3dtKzVDRTFKNHFqbjk1bURF?=
 =?utf-8?B?QkoyNWhtRTdFVThtNitENEpTWklpSmtNZE1YWm50MGxOTTJpM3NsWXUxM3dN?=
 =?utf-8?B?aGZJRHJiVzBKejJhRjk5NVNqamhRcE94a3VWWnJDLytVYWwvRmRrcThLYmtT?=
 =?utf-8?B?L2k1U00yaXZIZnBSOHlodDd0NU5jWjZYVjNjQkhHVTRpS2lHMmVTNXVSWThq?=
 =?utf-8?B?QWc3R0hSVXUvaHp3NVRESkxRdC9teWpZeXAwbDBNRHNDRDFmRW16RytuTEtM?=
 =?utf-8?B?UW9FalVVSXFZRm55Myt1a0R5c1J2YnZKNmo2eENzaDR3TWJ5RkZwemlUNnA0?=
 =?utf-8?B?V1haS1h5bVAyNmJORk9ITklKVHlmUnVMTko3QVYzby9HY2pjRzlCTHBrRkFH?=
 =?utf-8?B?SFpzSzZOLzVzclZ1Rmd6dWthWVlRNkRuVXZpNkhHZWdvYkpMTEVqdjdwRW1N?=
 =?utf-8?B?ZUt0Nk5iUUdxS2l0Ni9JT0VORHdWYnJYRlZsbnpRaE9lOHd5Smd4YU4zR0RQ?=
 =?utf-8?B?MWlXY1lsYnVxeVZxZ2pQZnFWZ0E2NmhhUmRaRmU2dStOc1Y2K0o1Yi9CcGpy?=
 =?utf-8?B?KzRLekZaU1pTRFAvaVBGRFVmazZseDFic2ViSDhRQ0JBT0lYcXlCUTlYT0ph?=
 =?utf-8?B?V2llaWJ3Y25sU2lpVjFnVkVWQXQrZjlWMlQ1ZmNwaExUckpRb2gzQ3hUbytw?=
 =?utf-8?B?cW5hamJPNG9paXpLcEhXRzZlNlJOZFRlNFNuWCtMeHIxQXJUZzc4bzZ5WTVZ?=
 =?utf-8?Q?cYegYbBLtI4PsxphVajFyY0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edbbb5ec-ffa8-4958-7928-08da9baa7fe2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 08:23:01.8015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MRV8ycLSzG0UlVHNqVAf9/PwIGpDdOVEuN5aFqYGv6ZsHMbmZDqBLrg9muXbTXan
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7096
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBLcnp5c3p0b2YgS296bG93c2tp
IDxrcnp5c3p0b2Yua296bG93c2tpQGxpbmFyby5vcmc+DQo+IFNlbnQ6IFdlZG5lc2RheSwgU2Vw
dGVtYmVyIDIxLCAyMDIyIDE6MTUgUE0NCj4gVG86IEdhZGRhbSwgU2FyYXRoIEJhYnUgTmFpZHUg
PHNhcmF0aC5iYWJ1Lm5haWR1LmdhZGRhbUBhbWQuY29tPjsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOw0KPiBwYWJlbmlAcmVkaGF0
LmNvbTsgcm9iaCtkdEBrZXJuZWwub3JnOw0KPiBrcnp5c3p0b2Yua296bG93c2tpK2R0QGxpbmFy
by5vcmc7IGxpbnV4QGFybWxpbnV4Lm9yZy51aw0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFybS0NCj4ga2VybmVsQGxpc3Rz
LmluZnJhZGVhZC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IFNpbWVrLCBNaWNo
YWwNCj4gPG1pY2hhbC5zaW1la0BhbWQuY29tPjsgUGFuZGV5LCBSYWRoZXkgU2h5YW0NCj4gPHJh
ZGhleS5zaHlhbS5wYW5kZXlAYW1kLmNvbT47IFNhcmFuZ2ksIEFuaXJ1ZGhhDQo+IDxhbmlydWRo
YS5zYXJhbmdpQGFtZC5jb20+OyBLYXRha2FtLCBIYXJpbmkNCj4gPGhhcmluaS5rYXRha2FtQGFt
ZC5jb20+OyBnaXRAeGlsaW54LmNvbTsgZ2l0IChBTUQtWGlsaW54KQ0KPiA8Z2l0QGFtZC5jb20+
DQo+IFN1YmplY3Q6IFJlOiBbUkZDIFYyIFBBVENIIDIvM10gZHQtYmluZGluZ3M6IG5ldDogeGls
aW54X2F4aWVuZXQ6IEludHJvZHVjZQ0KPiBkbWFlbmdpbmUgYmluZGluZyBzdXBwb3J0DQo+IA0K
PiBPbiAyMC8wOS8yMDIyIDA3OjU3LCBTYXJhdGggQmFidSBOYWlkdSBHYWRkYW0gd3JvdGU6DQo+
ID4gRnJvbTogUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5LnNoeWFtLnBhbmRleUB4aWxpbngu
Y29tPg0KPiA+DQo+ID4gVGhlIGF4aWV0aGVybmV0IGRyaXZlciB3aWxsIG5vdyB1c2UgZG1hZW5n
aW5lIGZyYW1ld29yayB0byBjb21tdW5pY2F0ZQ0KPiA+IHdpdGggZG1hIGNvbnRyb2xsZXIgSVAg
aW5zdGVhZCBvZiBidWlsdC1pbiBkbWEgcHJvZ3JhbW1pbmcgc2VxdWVuY2UuDQo+ID4NCj4gPiBU
byByZXF1ZXN0IGRtYSB0cmFuc21pdCBhbmQgcmVjZWl2ZSBjaGFubmVscyB0aGUgYXhpZXRoZXJu
ZXQgZHJpdmVyDQo+ID4gdXNlcyBnZW5lcmljIGRtYXMsIGRtYS1uYW1lcyBwcm9wZXJ0aWVzLiBJ
dCBkZXByZWNhdGVzDQo+ID4gYXhpc3RyZWFtLWNvbm5lY3RlZCBwcm9wZXJ0eSwgcmVtb3ZlIGF4
aWRtYSByZWcgYW5kIGludGVycnVwdA0KPiA+IHByb3BlcnRpZXMgZnJvbSB0aGUgZXRoZXJuZXQg
bm9kZS4gSnVzdCB0byBoaWdobGlnaHQgdGhhdCB0aGVzZSBEVA0KPiA+IGNoYW5nZXMgYXJlIG5v
dCBiYWNrd2FyZCBjb21wYXRpYmxlIGR1ZSB0byBtYWpvciBkcml2ZXINCj4gPiByZXN0cnVjdHVy
aW5nL2NsZWFudXAgZG9uZSBpbiBhZG9wdGluZyB0aGUgZG1hZW5naW5lIGZyYW1ld29yay4NCj4g
Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IFJhZGhleSBTaHlhbSBQYW5kZXkgPHJhZGhleS5zaHlhbS5w
YW5kZXlAeGlsaW54LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXJhdGggQmFidSBOYWlkdSBH
YWRkYW0NCj4gPiA8c2FyYXRoLmJhYnUubmFpZHUuZ2FkZGFtQGFtZC5jb20+DQo+ID4gLS0tDQo+
ID4gQ2hhbmdlcyBpbiBWMjoNCj4gPiAtIE5vbmUuDQo+ID4gLS0tDQo+ID4gIC4uLi9kZXZpY2V0
cmVlL2JpbmRpbmdzL25ldC94bG54LGF4aWV0aGVybmV0LnlhbWwgIHwgICAzOSArKysrKysrKysr
KystLS0tLQ0KPiAtLS0NCj4gPiAgMSBmaWxlcyBjaGFuZ2VkLCAyMyBpbnNlcnRpb25zKCspLCAx
NiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQNCj4gPiBhL0RvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQveGxueCxheGlldGhlcm5ldC55YW1sDQo+ID4gYi9Eb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3hsbngsYXhpZXRoZXJuZXQueWFtbA0K
PiA+IGluZGV4IDc4MGVkZjMuLjFkYzE3MTkgMTAwNjQ0DQo+ID4gLS0tIGEvRG9jdW1lbnRhdGlv
bi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC94bG54LGF4aWV0aGVybmV0LnlhbWwNCj4gPiArKysg
Yi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3hsbngsYXhpZXRoZXJuZXQu
eWFtbA0KPiA+IEBAIC0xNCwxMCArMTQsOCBAQCBkZXNjcmlwdGlvbjogfA0KPiA+ICAgIG9mZmxv
YWRpbmcgVFgvUlggY2hlY2tzdW0gY2FsY3VsYXRpb24gb2ZmIHRoZSBwcm9jZXNzb3IuDQo+ID4N
Cj4gPiAgICBNYW5hZ2VtZW50IGNvbmZpZ3VyYXRpb24gaXMgZG9uZSB0aHJvdWdoIHRoZSBBWEkg
aW50ZXJmYWNlLCB3aGlsZQ0KPiA+IHBheWxvYWQgaXMNCj4gPiAtICBzZW50IGFuZCByZWNlaXZl
ZCB0aHJvdWdoIG1lYW5zIG9mIGFuIEFYSSBETUEgY29udHJvbGxlci4gVGhpcw0KPiA+IGRyaXZl
cg0KPiA+IC0gIGluY2x1ZGVzIHRoZSBETUEgZHJpdmVyIGNvZGUsIHNvIHRoaXMgZHJpdmVyIGlz
IGluY29tcGF0aWJsZSB3aXRoDQo+ID4gQVhJIERNQQ0KPiA+IC0gIGRyaXZlci4NCj4gPiAtDQo+
ID4gKyAgc2VudCBhbmQgcmVjZWl2ZWQgdGhyb3VnaCBtZWFucyBvZiBhbiBBWEkgRE1BIGNvbnRy
b2xsZXIgdXNpbmcNCj4gPiArIGRtYWVuZ2luZSAgZnJhbWV3b3JrLg0KPiA+DQo+ID4gIGFsbE9m
Og0KPiA+ICAgIC0gJHJlZjogImV0aGVybmV0LWNvbnRyb2xsZXIueWFtbCMiDQo+ID4gQEAgLTM2
LDE5ICszNCwxMyBAQCBwcm9wZXJ0aWVzOg0KPiA+DQo+ID4gICAgcmVnOg0KPiA+ICAgICAgZGVz
Y3JpcHRpb246DQo+ID4gLSAgICAgIEFkZHJlc3MgYW5kIGxlbmd0aCBvZiB0aGUgSU8gc3BhY2Us
IGFzIHdlbGwgYXMgdGhlIGFkZHJlc3MNCj4gPiAtICAgICAgYW5kIGxlbmd0aCBvZiB0aGUgQVhJ
IERNQSBjb250cm9sbGVyIElPIHNwYWNlLCB1bmxlc3MNCj4gPiAtICAgICAgYXhpc3RyZWFtLWNv
bm5lY3RlZCBpcyBzcGVjaWZpZWQsIGluIHdoaWNoIGNhc2UgdGhlIHJlZw0KPiA+IC0gICAgICBh
dHRyaWJ1dGUgb2YgdGhlIG5vZGUgcmVmZXJlbmNlZCBieSBpdCBpcyB1c2VkLg0KPiA+IC0gICAg
bWF4SXRlbXM6IDINCj4gPiArICAgICAgQWRkcmVzcyBhbmQgbGVuZ3RoIG9mIHRoZSBJTyBzcGFj
ZS4NCj4gPiArICAgIG1heEl0ZW1zOiAxDQo+ID4NCj4gPiAgICBpbnRlcnJ1cHRzOg0KPiA+ICAg
ICAgZGVzY3JpcHRpb246DQo+ID4gLSAgICAgIENhbiBwb2ludCB0byBhdCBtb3N0IDMgaW50ZXJy
dXB0cy4gVFggRE1BLCBSWCBETUEsIGFuZCBvcHRpb25hbGx5DQo+IEV0aGVybmV0DQo+ID4gLSAg
ICAgIGNvcmUuIElmIGF4aXN0cmVhbS1jb25uZWN0ZWQgaXMgc3BlY2lmaWVkLCB0aGUgVFgvUlgg
RE1BIGludGVycnVwdHMNCj4gc2hvdWxkDQo+ID4gLSAgICAgIGJlIG9uIHRoYXQgbm9kZSBpbnN0
ZWFkLCBhbmQgb25seSB0aGUgRXRoZXJuZXQgY29yZSBpbnRlcnJ1cHQgaXMNCj4gb3B0aW9uYWxs
eQ0KPiA+IC0gICAgICBzcGVjaWZpZWQgaGVyZS4NCj4gPiAtICAgIG1heEl0ZW1zOiAzDQo+ID4g
KyAgICAgIEV0aGVybmV0IGNvcmUgaW50ZXJydXB0Lg0KPiA+ICsgICAgbWF4SXRlbXM6IDENCj4g
Pg0KPiA+ICAgIHBoeS1oYW5kbGU6IHRydWUNCj4gPg0KPiA+IEBAIC0xMDksNiArMTAxLDcgQEAg
cHJvcGVydGllczoNCj4gPiAgICAgICAgZm9yIHRoZSBBWEkgRE1BIGNvbnRyb2xsZXIgdXNlZCBi
eSB0aGlzIGRldmljZS4gSWYgdGhpcyBpcyBzcGVjaWZpZWQsDQo+ID4gICAgICAgIHRoZSBETUEt
cmVsYXRlZCByZXNvdXJjZXMgZnJvbSB0aGF0IGRldmljZSAoRE1BIHJlZ2lzdGVycyBhbmQgRE1B
DQo+ID4gICAgICAgIFRYL1JYIGludGVycnVwdHMpIHJhdGhlciB0aGFuIHRoaXMgb25lIHdpbGwg
YmUgdXNlZC4NCj4gPiArICAgIGRlcHJlY2F0ZWQ6IHRydWUNCj4gPg0KPiA+ICAgIG1kaW86IHRy
dWUNCj4gPg0KPiA+IEBAIC0xMTgsMTIgKzExMSwyNCBAQCBwcm9wZXJ0aWVzOg0KPiA+ICAgICAg
ICBhbmQgInBoeS1oYW5kbGUiIHNob3VsZCBwb2ludCB0byBhbiBleHRlcm5hbCBQSFkgaWYgZXhp
c3RzLg0KPiA+ICAgICAgJHJlZjogL3NjaGVtYXMvdHlwZXMueWFtbCMvZGVmaW5pdGlvbnMvcGhh
bmRsZQ0KPiA+DQo+ID4gKyAgZG1hczoNCj4gPiArICAgIGl0ZW1zOg0KPiA+ICsgICAgICAtIGRl
c2NyaXB0aW9uOiBUWCBETUEgQ2hhbm5lbCBwaGFuZGxlIGFuZCBETUEgcmVxdWVzdCBsaW5lIG51
bWJlcg0KPiA+ICsgICAgICAtIGRlc2NyaXB0aW9uOiBSWCBETUEgQ2hhbm5lbCBwaGFuZGxlIGFu
ZCBETUEgcmVxdWVzdCBsaW5lDQo+ID4gKyBudW1iZXINCj4gPiArDQo+ID4gKyAgZG1hLW5hbWVz
Og0KPiA+ICsgICAgaXRlbXM6DQo+ID4gKyAgICAgIC0gY29uc3Q6IHR4X2NoYW4wDQo+ID4gKyAg
ICAgIC0gY29uc3Q6IHJ4X2NoYW4wDQo+ID4gKw0KPiA+ICByZXF1aXJlZDoNCj4gPiAgICAtIGNv
bXBhdGlibGUNCj4gPiAgICAtIGludGVycnVwdHMNCj4gPiAgICAtIHJlZw0KPiA+ICAgIC0geGxu
eCxyeG1lbQ0KPiA+ICAgIC0gcGh5LWhhbmRsZQ0KPiA+ICsgIC0gZG1hcw0KPiA+ICsgIC0gZG1h
LW5hbWVzDQo+ID4NCj4gPiAgYWRkaXRpb25hbFByb3BlcnRpZXM6IGZhbHNlDQo+ID4NCj4gPiBA
QCAtMTMyLDExICsxMzcsMTMgQEAgZXhhbXBsZXM6DQo+ID4gICAgICBheGlfZXRoZXJuZXRfZXRo
OiBldGhlcm5ldEA0MGMwMDAwMCB7DQo+ID4gICAgICAgIGNvbXBhdGlibGUgPSAieGxueCxheGkt
ZXRoZXJuZXQtMS4wMC5hIjsNCj4gPiAgICAgICAgaW50ZXJydXB0LXBhcmVudCA9IDwmbWljcm9i
bGF6ZV8wX2F4aV9pbnRjPjsNCj4gPiAtICAgICAgaW50ZXJydXB0cyA9IDwyPiwgPDA+LCA8MT47
DQo+ID4gKyAgICAgIGludGVycnVwdHMgPSA8MT47DQo+IA0KPiBUaGlzIGxvb2tzIGxpa2UgYW4g
QUJJIGJyZWFrLiBIb3cgZG8geW91IGhhbmRsZSBvbGQgRFRTPyBPaCB3YWl0Li4uIHlvdSBkbw0K
PiBub3QgaGFuZGxlIGl0IGF0IGFsbC4NCg0KWWVzLCB0aGlzIGlzIGFudGljaXBhdGVkIEFCSSBi
cmVhayBkdWUgdG8gbWFqb3IgY2hhbmdlcyBpbiBheGlldGhlcm5ldA0KZHJpdmVyIHdoaWxlIGFk
b3B0aW5nIHRvIGRtYWVuZ2luZSBmcmFtZXdvcmsuIFNhbWUgaXMgaGlnaGxpZ2h0ZWQNCmluIGNv
bW1pdCBkZXNjcmlwdGlvbiAtICJEVCBjaGFuZ2VzIGFyZSBub3QgYmFja3dhcmQgY29tcGF0aWJs
ZSANCmR1ZSB0byBtYWpvciBkcml2ZXIgcmVzdHJ1Y3R1cmluZy9jbGVhbnVwIGRvbmUgaW4gYWRv
cHRpbmcgdGhlIA0KZG1hZW5naW5lIGZyYW1ld29yayIuIA0KDQpTb21lIGJhY2tncm91bmQgLSBG
YWN0b3Igb3V0IEFYSSBETUEgY29kZSBpbnRvIHNlcGFyYXRlIGRyaXZlciB3YXMNCmEgVE9ETyBp
dGVtIChtZW50aW9uZWQgaW4gZHJpdmVyIGNoYW5nZWxvZykgYW5kIGlzIGJlaW5nIGRvbmUgYXMg
DQpwYXJ0IG9mIHRoaXMgc2VyaWVzLiBUaGUgRE1BIGNvZGUgaXMgcmVtb3ZlZCBmcm9tIGF4aWV0
aGVybmV0IGRyaXZlciANCmFuZCBldGhlcm5ldCBkcml2ZXIgbm93IG1ha2UgdXNlIG9mIGRtYWVu
Z2luZSBmcmFtZXdvcmsgdG8gDQpjb21tdW5pY2F0ZSB3aXRoIEFYSURNQSBJUC4NCg0KV2hlbiBE
TUEgY29kZSBpcyByZW1vdmVkIGZyb20gYXhpZXRoZXJuZXQgZHJpdmVyIHRoZXJlIGlzIGxpbWl0
YXRpb24NCnRvIHN1cHBvcnQgbGVnYWN5IERNQSByZXNvdXJjZXMgYmluZGluZy4gT25lIG9wdGlv
biBpcyB0byBpbmZvcm0NCnVzZXIgdG8gc3dpdGNoIHRvIG5ldyBiaW5kaW5nIHdoZW4gb2xkIERU
UyBpcyBkZXRlY3RlZD8gKGFuZCBhdCBzb21lDQpwb2ludCB3ZSBoYXZlIHRvIG1ha2UgdGhpcyB0
cmFuc2l0aW9uIGFuZCByZW1vdmUgZG1hIGNvZGUpLg0KUGxlYXNlIGxldCB1cyBrbm93IGlmIHRo
ZXJlIGFyZSBhbnkgb3RoZXIgYWx0ZXJuYXRpdmUgdG8gY29uc2lkZXI/DQoNCg==
