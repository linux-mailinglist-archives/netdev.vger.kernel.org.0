Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBBB54CF18
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 18:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347315AbiFOQzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346397AbiFOQzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:55:35 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80119.outbound.protection.outlook.com [40.107.8.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E37A4DF46;
        Wed, 15 Jun 2022 09:55:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixaNIDMQtHyaocLy/Guoix176DK6rjefk9uVGggc9eMph8PSf1gka27yKIZMJQxOcOSlhwTnVEXvPyrwVX1YSXchrZ6VNBNaFDfQXt6M3qYJlX4ozm/f/KDh6nt+GaEuOEpbNu5FSDdJbzUJ9JwSJ9jbp0e1JRFyw0NI6Z+KqjYdyfoyOfnGHOdwIF7hXL33Le8vyonBkM6sa0naaPZ3/iyihyQ+d6BNWLJ56yT/xJMY7C4BDTVGKq6fTpCSj8bWd7njedrTzdM5OZBrReXYmNc/UGwKhG17d7e7XFMsEpAl+d5WWzDs3P3gnlbo24kVIH1nxvUNfvqWDBvVIMvwcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gI7Gr1Zu/SsHVsOGId4egRV0OPFScPCp6ejTml7U6zo=;
 b=Zknn7UZQfW2DHs2Tr4ywCuurHNFCJJAzP9aPMVQwiQm3kvaFISb186TFmIaMx/xgkFJsHdC28rgCIYfxi+O8W+5uwcli86EVOFoSfeAuehEgW2jwFfGhygdqttiVoD4uQiVhvC8OCKzFE7sjTaKbWXOSNvkZrbCVHbhLMvFkjdRt/M7KP2ZZ9PSmVXAamVYzybH8CzWDgpT7PPVigxADYkzOrxiy2uKIU87rCis1/y3Mpd/xI6rmMqhcgS5y55u2EnDzn69DkEDcgStohTV0ShrBJz+Z23uiNaj9VYYeP/hsgrD4NyeBplE3zPVOhX8iJGObw56odwe0TVvMGcdZUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gI7Gr1Zu/SsHVsOGId4egRV0OPFScPCp6ejTml7U6zo=;
 b=a2RFUutElrm2dhi5YiyJK82ymIl8Raghfs4O7GwU05SHYfkaQBsXeKU93PHCjJFra5AORHpR2yzD5BLaOIJPPUfiOeSaCOkp5gr+R0oi02h9Bn0akXCcA8QiqI7O4NpkrIhTWa9CBKafKIpBd8S1hZNKpkaAFNOTXUx9eZfqDMM=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by VI1PR03MB4399.eurprd03.prod.outlook.com (2603:10a6:803:55::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.22; Wed, 15 Jun
 2022 16:55:30 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111%7]) with mapi id 15.20.5332.014; Wed, 15 Jun 2022
 16:55:30 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "hauke@hauke-m.de" <hauke@hauke-m.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/5] net: dsa: realtek: rtl8365mb: improve
 handling of PHY modes
Thread-Topic: [PATCH net-next v2 0/5] net: dsa: realtek: rtl8365mb: improve
 handling of PHY modes
Thread-Index: AQHYfOA9w1RozZJmDEqQhUTFY9YeGK1Qt66A
Date:   Wed, 15 Jun 2022 16:55:29 +0000
Message-ID: <20220615165529.3g6aqwdpwxqhs6nj@bang-olufsen.dk>
References: <20220610153829.446516-1-alvin@pqrs.dk>
In-Reply-To: <20220610153829.446516-1-alvin@pqrs.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49e7e019-3a0c-4e9d-f4f6-08da4eefdade
x-ms-traffictypediagnostic: VI1PR03MB4399:EE_
x-microsoft-antispam-prvs: <VI1PR03MB4399DDA039DE11593A322E1783AD9@VI1PR03MB4399.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AIUZt2t7sIl6I0bn1MC/GmnbwJIIu5iD+t596NQJ3ArSUk5Pi90a3P1fUSBqxWFHKhyeWPxODVbtM08k+O+J+sL0Sd6geu0rNo6XXtAcsY5/el0X8SGLP6RhErzUwTmHn53Q/hCP14iC5ul5jn65Nawo55lOyV2M6kCf43DZhwrvOq+0eVVCxg0wvLg++EGHuBU8Wc+dshB9s62xUKB8J1m36TCHIeNoxTKsqNvesP4MfduT+LAwEi5Y6IRTsn78HdSI0PJngE9W7B9aDJTJMT7hdsep16lif6farZxNF1w+cmtKNJ+aoFNU2GauL3KmEKW9/92X2u4hZRbGv574rQ1a+5UTf8atwDnkpDqtHxYlZaI/OfeJ7pStUpkb9PYh4BpYYCuU8OY0e8rg41WNweBOFflRE6snZPVpdCYeKnjVkoTY+aRzqZ8WnJ870SLkYMsRj0xd1QaurjelSThXXjKYTcBdN1L9oIGhuciXDpSoji1KlUSdVXCAg8wmgJwbPuQ5lk/pBJMhyZPEOtM2fxtVPLqn8bCH+z5wbULEZbAoqz4KSzmkpHIQXvja/pxRspunNcnVxA0iROR/OK573Pdwz6qnKV3dE0y/wydvuNKMwkwbRN7rxjDV9aBrqyjuDnqUuEM7nP7YtfqDPVeYVGc+ULCtqryBq1hiKMeUAG8CNM8Ae2rfpT5PIG/8wjE6CKlqYn2b0bjMqHhbbzwsiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(66446008)(66476007)(66556008)(66946007)(76116006)(64756008)(86362001)(5660300002)(6512007)(85182001)(85202003)(83380400001)(8676002)(38070700005)(26005)(66574015)(4326008)(2906002)(7416002)(91956017)(36756003)(2616005)(38100700002)(316002)(1076003)(508600001)(54906003)(122000001)(6506007)(110136005)(8936002)(71200400001)(6486002)(186003)(8976002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2g2VTJ6RHlxOU8vNWl6Qm1wSzNHU2tVWXNtWVJlWm11amZqcXVjNjRJY1lZ?=
 =?utf-8?B?NC9XZkUvdVRoaFRYcGhNMWFwb0c0R2gyTTFselRhbDFZRVRDbVVobTBLK3lF?=
 =?utf-8?B?NHM0YVVxRm83S245Ny9MdnNaY2R0c0pERmM4VDRxRi9TNmRiNVphYUh4cmxx?=
 =?utf-8?B?RmdHWWw0R2ZkTktBNVFwY2tkRXgzZ1Uva3pTMnRwOGFUZGhJRFF1RG91bzhm?=
 =?utf-8?B?VnAxd3U2VG9UTFBFdUJib1BKMFdxMC9PNXp6ejNWOTV6Y1dyaVM1NW5sb25R?=
 =?utf-8?B?V2RsTG5ZOWt3ZjVQSlA5cUJHcngvYjBuSWpzc2N3NWRzdEgwY2ZNcGlzZUJH?=
 =?utf-8?B?OWRHV0VRQksxV0tNQVJ6OFVVVi9yL1p6VlVlNDlUWnZ6dVRsTEZqSExOUDI3?=
 =?utf-8?B?eTliSWNXaXZ5blVYQnVoSEloaE04WTJyMVh0bndsdUtYYmlWdytoWWg3MWVU?=
 =?utf-8?B?Yk5aTThSODhLb0tYbEplaWVRM1Q1cE5qeUZicVA1VG5sVlJyMjNRMWl3ZXd4?=
 =?utf-8?B?bW1GVDd5cTBocjNpT3NWWWF5MTZMbU1uVE5Bblh2VU1qb0UzUGdFS0VmbDk4?=
 =?utf-8?B?Q2svY0dxNkRjV1VTMkgzMG5sS3h3K0ZBaC9VR1V6WWdTM0Jhd1BJQUJFKzdj?=
 =?utf-8?B?YXd6TUFnaForWXFEdm9sRlB3TC9QMFlPbFhNZk8zdTdLcDVuKytBUjhwZWh0?=
 =?utf-8?B?MzNSeWc1dGhVUUo1aXF2VmlCaHU3bXdXbnFLaFowdjBPYm9IQ1ozVXlGeVlL?=
 =?utf-8?B?c0VLUUhGelY5UWEycEoxYU0veURIb3B6TWludW1Lc09oM2lMTjVUY09EMEN6?=
 =?utf-8?B?MER4Y2Z6ZkR1RGp4bUFFRWJFand2MU53cHBlY0JCcS8yTnBGUVZjUHRVa1la?=
 =?utf-8?B?SklaRjJQZ3hNTGJoL0lzVE5udkJLSk9wbitkbkVvODh5SXZiWGtNL3VBMFZ2?=
 =?utf-8?B?OVpRRmlENThqVXBjcTB1WTZEOVJGNWcxWk9kb1pRdkF6K1FNUmZXWldmd0VX?=
 =?utf-8?B?U1Vjd0ZpWEdYZERMUFk2dlQ1SkpISHFyYndjVGxaZGZDYWJaWnp5aExpc29W?=
 =?utf-8?B?ZnkwTGZ6cFFULzhvblZmdFRjU3hwUkl0NG4zTjEzd2IzODZGTEQrVkd4Vkcw?=
 =?utf-8?B?T1NWdzFWaHhtV2h1VUlINHk2NlhjK2NNdXR5Z0JIN2g3TVRrTkJFblZTOFdS?=
 =?utf-8?B?ZDNONzRKT1B3dkJIdFpEWnBPcWZBQjUwUHFtMWoweEZVUWt1TTAxK3NTOFNi?=
 =?utf-8?B?T3FjQXRpVC9iV2lGc3BBZGFiU0lkQW5wTEI2K2Q1ZEJST09TYXBreVliVFlF?=
 =?utf-8?B?VEdLQU15Z252YTVWUlVhbjJvamIxKzN3MXl2Sm1VdmtjME42NHJGWXVqVDhW?=
 =?utf-8?B?VWxiSnMvZzROQzNEU3N5MWo2bGZOOGRqVENZUTc4SVBMQVEwTXJJbVYxWlV0?=
 =?utf-8?B?OTdIcmhxRzlJU0IrbytLWmw4aWxNRmlWUDRFajRJVE9pRXR4bDdsQXJmazBW?=
 =?utf-8?B?VmloN1dTY1lkYjdJUnNSVzMvSVlUbStCUHhvZjgyTlU5NUJhcGkvWUFLSXFW?=
 =?utf-8?B?S1huT0diaE56MFp0MG1iQ0thaGFzK3IxaVUweldTS0ZzR2ZpeVNRSmtDcGh0?=
 =?utf-8?B?Zk5QOXhNS1ZUc25INWhENEU5cGpScnM5Q2I3NFhDRklxNjl4QzZMSlJaMjJa?=
 =?utf-8?B?bUpPUmNRQldTcmNOR2xDNDFRbVlhTmZQSE8vM2wxQ0oxUUhudmt0Umt0WE4y?=
 =?utf-8?B?K0xSdUJXOC9rRXQ3dnpXeVNQbmtINDZFNjBzWW5TZFBWUjhNK25KOTdLbHdJ?=
 =?utf-8?B?enMrdHVVSnhEY3JVeG9oblRwQTFRcGFHeURybHovUjBjL2dJUnA4TDRobys1?=
 =?utf-8?B?dEh2Y2FzdXF6WndVNVprcDd2RFF4WUUzaVpsYkp6d3ZJbzFZeHBRbURLQWxZ?=
 =?utf-8?B?cjdIU0l6cEthcHdjaCtlSlV5ZWUySGJhN2JDU1hFeUdWNGJkVjBSZkNucWZ2?=
 =?utf-8?B?UEYrS1ZRbUcwLzZhQ1FmczRSK2llMi9uVDg5RDBmeGpva3NNeDdyWDJURk12?=
 =?utf-8?B?cDdFWTcrQko0VnkzOTdRNmxNMnZoSUtSZVhyNFJvMEJUcmdnYUt2QmxpUW9J?=
 =?utf-8?B?TG85ekN6U0xEUTRZaHlrYTN1SWlxWXRXNGZxeEE4WEUxTkZkRzhXVDk1eDcv?=
 =?utf-8?B?aEFMV3JFcjhPNHZKMFJTNEp6SjF2bjdLcFNNbkNQMG1VN3Y5SE40b2MrKzRs?=
 =?utf-8?B?bWQ3RmJ6dDRXcVB5NmpLVjZscTlZNHE1TEp2R0ZrazF1NitraEp0bSsvZzdI?=
 =?utf-8?B?SmpGK3hCTVVBZzJQR2czT1R1YUFDTm12ekw2SVd2b1Y0ZW1raFY0aW1MYld3?=
 =?utf-8?Q?GQgtF7y0V9qlR2jI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0FDCD62C16EF284F911DDB437361A478@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49e7e019-3a0c-4e9d-f4f6-08da4eefdade
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2022 16:55:30.2229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MjFjeyEhEb16WEQxUNl7/KfZq73OZMJLwpxukn2YC3I3Tjv4hh/BZbOiOEGduAm7VYfdp/YFsuICXR36o/KT4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB4399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGF2aWQsIEpha3ViLCB0aGlzIHNlcmllcyBpcyBtYXJrZWQgQ2hhbmdlcyBSZXF1ZXN0ZWQgb24g
cGF0Y2h3b3JrLCBidXQgSSBoYXZlDQphZGRyZXNzZWQgYWxsIHRoZSBjb21tZW50cy4gRG8geW91
IHdhbnQgbWUgdG8gcmVzZW5kPw0KDQpLaW5kIHJlZ2FyZHMsDQpBbHZpbg0KDQpPbiBGcmksIEp1
biAxMCwgMjAyMiBhdCAwNTozODoyNFBNICswMjAwLCBBbHZpbiDFoGlwcmFnYSB3cm90ZToNCj4g
RnJvbTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1vbHVmc2VuLmRrPg0KPiANCj4gVGhpcyBz
ZXJpZXMgaW50cm9kdWNlcyBzb21lIG1pbm9yIGNsZWFudXAgb2YgdGhlIGRyaXZlciBhbmQgaW1w
cm92ZXMgdGhlDQo+IGhhbmRsaW5nIG9mIFBIWSBpbnRlcmZhY2UgbW9kZXMgdG8gYnJlYWsgdGhl
IGFzc3VtcHRpb24gdGhhdCBDUFUgcG9ydHMNCj4gYXJlIGFsd2F5cyBvdmVyIGFuIGV4dGVybmFs
IGludGVyZmFjZSwgYW5kIHRoZSBhc3N1bXB0aW9uIHRoYXQgdXNlcg0KPiBwb3J0cyBhcmUgYWx3
YXlzIHVzaW5nIGFuIGludGVybmFsIFBIWS4NCj4gDQo+IENoYW5nZXMgdjEgLT4gdjI6DQo+IA0K
PiAgLSBwYXRjaGVzIDEtNDogbm8gY29kZSBjaGFuZ2UNCj4gDQo+ICAtIGFkZCBMdWl6JyByZXZp
ZXdlZC1ieSB0byBzb21lIG9mIHRoZSBwYXRjaGVzDQo+IA0KPiAgLSBwYXRjaCA1OiBwdXQgdGhl
IGNoaXBfaW5mb3MgaW50byBhIHN0YXRpYyBhcnJheSBhbmQgZ2V0IHJpZCBvZiB0aGUNCj4gICAg
c3dpdGNoIGluIHRoZSBkZXRlY3QgZnVuY3Rpb247IGFsc28gcmVtb3ZlIHRoZSBtYWNyb3MgZm9y
IHZhcmlvdXMNCj4gICAgY2hpcCBJRC92ZXJzaW9ucyBhbmQgZW1iZWQgdGhlbSBkaXJlY3RseSBp
bnRvIHRoZSBhcnJheQ0KPiANCj4gIC0gcGF0Y2ggNTogdXNlIGFycmF5IG9mIHNpemUgMyByYXRo
ZXIgdGhhbiBmbGV4aWJsZSBhcnJheSBmb3IgZXh0aW50cw0KPiAgICBpbiB0aGUgY2hpcF9pbmZv
IHN0cnVjdDsgZ2NjIGNvbXBsYWluZWQgYWJvdXQgaW5pdGlhbGl6YXRpb24gb2YNCj4gICAgZmxl
eGlibGUgYXJyYXkgbWVtYmVycyBpbiBhIG5lc3RlZCBjb250ZXh0LCBhbmQgYW55d2F5LCB3ZSBr
bm93IHRoYXQNCj4gICAgdGhlIG1heCBudW1iZXIgb2YgZXh0ZXJuYWwgaW50ZXJmYWNlcyBpcyAz
DQo+IA0KPiBBbHZpbiDFoGlwcmFnYSAoNSk6DQo+ICAgbmV0OiBkc2E6IHJlYWx0ZWs6IHJ0bDgz
NjVtYjogcmVuYW1lIG1hY3JvIFJUTDgzNjdSQiAtPiBSVEw4MzY3UkJfVkINCj4gICBuZXQ6IGRz
YTogcmVhbHRlazogcnRsODM2NW1iOiByZW1vdmUgcG9ydF9tYXNrIHByaXZhdGUgZGF0YSBtZW1i
ZXINCj4gICBuZXQ6IGRzYTogcmVhbHRlazogcnRsODM2NW1iOiBjb3JyZWN0IHRoZSBtYXggbnVt
YmVyIG9mIHBvcnRzDQo+ICAgbmV0OiBkc2E6IHJlYWx0ZWs6IHJ0bDgzNjVtYjogcmVtb3ZlIGxl
YXJuX2xpbWl0X21heCBwcml2YXRlIGRhdGENCj4gICAgIG1lbWJlcg0KPiAgIG5ldDogZHNhOiBy
ZWFsdGVrOiBydGw4MzY1bWI6IGhhbmRsZSBQSFkgaW50ZXJmYWNlIG1vZGVzIGNvcnJlY3RseQ0K
PiANCj4gIGRyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jIHwgMjk5ICsrKysrKysr
KysrKysrKystLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxNzcgaW5zZXJ0aW9ucygr
KSwgMTIyIGRlbGV0aW9ucygtKQ0KPiANCj4gLS0gDQo+IDIuMzYuMQ0KPg==
