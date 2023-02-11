Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CCF6933CF
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 21:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjBKUw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 15:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBKUw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 15:52:27 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2041.outbound.protection.outlook.com [40.107.13.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DDD18141;
        Sat, 11 Feb 2023 12:52:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9YJObGl9Wr9MZm/KAQ7Qg9hcKEdp/YYU6h2slPG7pnKr2W6LL2xVji/EshqyQ4Kwk3hE6WJgVs60TrlsHaqas1WLmb9eya9Ri7R3fZFVaJx1LAi96kqzJReNKAqQHsArRbj1t6W/ghqpVAgZgI9Zy29o/IhSGHdfT2BekciNiV7UNRGC0CnVXo+jTUQTbULREvR87GlUqR/mIS0Zr/TVEd3NTCZ68u3On19fzDYmZHMsP3y+3+gpwY5/5HE18itdRoIzfr60x0ESNPxYghxoWZwTkxEPeUFyXxeg8flSMqoky5dVfHASUuOfMP3eZou02k+RXoq77j0aZZcJ/6inw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qpldaFkFvcH/JgAaYNwPw7h0uDmTyPqI4J8KnIcK898=;
 b=YGn4Y/e4yWCV7A93UZZR6ueKhHCLVsAUkBE4caFUeP9oM4ihPWan+oTeTv1yr/E8z4scs0kpKcxB8KW8unIsBzLU/AOufMs/dmV7Z0/Ef/MVEDSK/EcwUUs3x0qiUAxDBw6tzUjIT30uTmAAO8sEys74ZjNBbJZmjw/gqiy/HzXbcpq5yc6ZeSaVGyT3NKh6+rVRnF9gsrF8RJedzh0Y/bkW2xF5nw7lvIcaHeGKL9RoSeJckyILnLjFTUVMm9H8deMmck4FiJY7tDDiEeyQiib8yFKBLcL7pRrzrZet3BhkoLoxuaEwcUiYJxOIZ+18MvlLoCNrVwo/lATRKqKE0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=routerhints.com; dmarc=pass action=none
 header.from=routerhints.com; dkim=pass header.d=routerhints.com; arc=none
Received: from VE1PR04MB7454.eurprd04.prod.outlook.com (2603:10a6:800:1a8::7)
 by PA4PR04MB9415.eurprd04.prod.outlook.com (2603:10a6:102:2aa::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Sat, 11 Feb
 2023 20:52:21 +0000
Received: from VE1PR04MB7454.eurprd04.prod.outlook.com
 ([fe80::e4a3:a727:5246:a5cd]) by VE1PR04MB7454.eurprd04.prod.outlook.com
 ([fe80::e4a3:a727:5246:a5cd%7]) with mapi id 15.20.6086.022; Sat, 11 Feb 2023
 20:52:20 +0000
From:   Richard van Schagen <richard@routerhints.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "arinc9.unal@gmail.com" <arinc9.unal@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "erkin.bozoglu@xeront.com" <erkin.bozoglu@xeront.com>
Subject: Re: [PATCH net] net: dsa: mt7530: fix CPU flooding and do not set CPU
 association
Thread-Topic: [PATCH net] net: dsa: mt7530: fix CPU flooding and do not set
 CPU association
Thread-Index: AQHZPXUtwlTBO97XWk+mTURzlKAX667IhG73gAG2EYA=
Date:   Sat, 11 Feb 2023 20:52:20 +0000
Message-ID: <829A471E-D1FB-4DC0-95FF-481A73E6E8E7@routerhints.com>
References: <20230210172822.12960-1-richard@routerhints.com>
 <20230210172822.12960-1-richard@routerhints.com>
 <20230210184409.e6ueolfdsmhqfph5@skbuf>
In-Reply-To: <20230210184409.e6ueolfdsmhqfph5@skbuf>
Accept-Language: nl-NL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=routerhints.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VE1PR04MB7454:EE_|PA4PR04MB9415:EE_
x-ms-office365-filtering-correlation-id: 0d9714c8-a13f-46b8-dcc1-08db0c71de76
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h3o61rXmWvGKjlota3UwsN2BkVE/AfZe+FhPMbFb/T4VgNhoNCe1cI4P1QGBML9if4B+lZbt9FQVkXCy8bP0/Ua1rb4mVUm/D3EGahCmNLJzylXlcLs5X+dhFluvy/Yo3x6yhCQxmz3kRXGijq+FW2Rx8NhWDxydt84l9iDl/iGTBpyJTjP3yiTW6E4cqZTmqOouAOI54msHlYNyTlsP0zOa2yIMLdbhMwvRIuRDh8N8jp0kid3WglNhy1dLGGC2uUuTNBbJ8dtQIvMqU7R0lcPa3XUiOwUCqleNdHINI9QFubDnMFGCGKO5Ez9i2KM+KtOcivE60kVWojVyFqdA2cJtaVkabr/6YQMnzmt+M/Conr4Y/PPXrWsPN6bKGirNhGz+68NWk4NOHAFV1s4dAXaYfYfFugjss7D7WmQapJGUN1Dz7DAFQP8oV0RqLuvzCNCKxAhwSlmuqy3+0/fYI/+lH6SX6BuTo2J4Bnfkg8xVcX0G3tDttBn+8AvX9g5eNJW2GD3YBO4Ji7Y3+jm5/D7ptpGQ+5z83oOhesxPDoiBTxOzCkv1+ZD/yGFzzVJESRwkU9gsHo2n63ps4rXYYOB0ZwLRTq51TMnsSwKWwaElYKLjZVu2bOEjwBwBuPSmWAcPy5dXXjIxa3zgcXXg3qXJZkqJ9Y4ZmKB/+vIqLW+RRlV0D3iLHVRh2ce9hPiSsE1GzNMmnx7BaImJHucpFRnudxZ/xKJ5aSMUgXCN/uM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7454.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(39830400003)(136003)(346002)(376002)(451199018)(76116006)(91956017)(316002)(66946007)(66446008)(54906003)(66556008)(4326008)(8676002)(41300700001)(6916009)(66476007)(8936002)(5660300002)(64756008)(7416002)(38070700005)(36756003)(33656002)(122000001)(86362001)(38100700002)(53546011)(6506007)(186003)(6512007)(71200400001)(66574015)(2906002)(478600001)(83380400001)(6486002)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWR6K1IrVG1ycWV0VFRWOEZvTmZRSHovSUhER3JjVkovdUhwQ3dMSWN1bkt3?=
 =?utf-8?B?OHM2MTJSeHBpOGJ6UmtXNnk0M3djVXRDN1lhemlUNVFwUWUxOWZITU1mNm42?=
 =?utf-8?B?RnJGQktZNHA5Rk9Ed0RNZW1oTXMwL3A3eXRKRTZBZlAzd1M5UDlBdzQ0V0hz?=
 =?utf-8?B?bTBSRXhqaTZ0THF5TjdJYnp3RzdTa2xMTkFnVWUyWWFUcWczd3o0ZjVhWjVD?=
 =?utf-8?B?ZDUyWmpWdE52UVR4eFJ5dzJVR1E3ZjZobWRUdXVyV00wckNIRGlwUE1RTWlD?=
 =?utf-8?B?OTJMMkhueG9nU3NhSWx0WDFZeXZhNFZHazQ3WVdNYTI4VjhVMEZ6ZnlEUjZj?=
 =?utf-8?B?emtFWTlkVWEzWmIwNHVCOXNNR3JqT3hoaTVweC9OdnlUOFZCNk5vaEZxZXFG?=
 =?utf-8?B?ZmRNT0dQZytHd3Jlemtyd2NENG41TkhZTkU5YzFORTRYMmlieGdKVEpNdnFw?=
 =?utf-8?B?SzNENG9wM0ZTSlE3Mnl1OUNaNENNT1VDWG5RYjQ1TnEwVlhITzdKKzFQcE0y?=
 =?utf-8?B?WXpldDR4aU9YNzRlWkhOZ09XZnlmeWU0SkUwQ0ZpSzVYKzBIdWtVR1BwcVRz?=
 =?utf-8?B?WjBadU5keHp2K1JrbHJxQzVaTE1kcDVjcCtMZUh0ejNyODRiVnBQNjhSSThj?=
 =?utf-8?B?RDNuWmdqYXVMTzFSdWRqN21SRURpZVZxWTRDT20zS25BUmZqVnNnVlF4WUhp?=
 =?utf-8?B?R1FnN0o4YXN6MFRoa2lDb21ybzd0djZIbHVSbUhHdUkxeCtsS2pSNGxTZFJm?=
 =?utf-8?B?SVpURGlyZTI1MWxzL3JIVGdWWk9ON2xwcUZZb1MybjhLVEZzUk9xYURtMTNr?=
 =?utf-8?B?WE9FOTJoNGUwMXV3bHduSmlHZGNFVlhydzJSNXV0ZFNYQzk4TDR3RWwvNXp6?=
 =?utf-8?B?cDJ3M0dwckFJam90QktQd2E2YnBKS09tWkJwSkRGOGk5ejh6dzN0MVd0QUFK?=
 =?utf-8?B?Q1pqNk53SHRzZlp4bFg0K09pdW9jSzI0UkZvTnRRTWVES1RhWWxxbFdFVlRY?=
 =?utf-8?B?aTlFSkNQNmJ2NTdGallYQk5NYTR2OXllbXVOMzZzdE15czhid0lTRkl3U1hh?=
 =?utf-8?B?NWtiZ3BzUGJ6RnpjN2JYSVV5RnZXRG1NaWNhbUtyN09wcWo0aEtLZVRMczNS?=
 =?utf-8?B?Zzlwc2lnUFNaNmlCZnBtWGpnTkREdjVraHpWbWtKSFNqMm0zcEttOGJ4WG5Q?=
 =?utf-8?B?elc4RThNenZVOEMwS0lSaUU0alZuK2F6UWhaOGFuV1pEUmgzY0pyaEptT25i?=
 =?utf-8?B?S3ZWSTlTc0wzdGVwb3NnTmxqdHM5YllkUUhUaENxWHVRVzFPYjBwWGZ0VHUz?=
 =?utf-8?B?TTVIL2ZFNXVWeWJ4dzJrdHg1WFJHanlFNm50b3FCT3dzMnlSUCs3M0hHOCtP?=
 =?utf-8?B?VHM3OGFkRnA5NDF2Sjd2TUl5RXYxcisrYWlqRlV6M1B4YjFOajJycDRlL0pK?=
 =?utf-8?B?Wk90ZENqVjVaYlZDRStWZW0rRXFNZUsxZlAwU2dCU2wwRGtoNEUrS1pTZzZU?=
 =?utf-8?B?WndERFM2MVBYMXRLZXhjb09mLzlyV0swdEliU2RjQjBIY2JFTzhDcmJBT3Zs?=
 =?utf-8?B?WGVMYlVFK3k5TmFHVFl5c20yVEpJSjFwUnFsN2R4MklSUkVPQS94ZXBrNThB?=
 =?utf-8?B?YlB1Qy9SYlovczZTWEdJVTA1enJmNGUwQXRuZStrTkZVeE13WGhuWGZYbXMz?=
 =?utf-8?B?cE5iUmdZV216MVE4ZDJab2U5SjFLTWVidlJkL3kxUjlidWEzNWpIT01rSkpW?=
 =?utf-8?B?aUFxeTRaN1ZMZmlGam1aV3dQUmRkc0Q1Nm1VYitxOHhQZFhVTWNLRS9QeDJN?=
 =?utf-8?B?UjRUZi9iNDV4dzM3enRUQkN4RG5CblNIeTgweHpEcHAyaG11UXVPNnhzcEFG?=
 =?utf-8?B?bVJyVmFrZXNBeVpLOFlkRDNMYzZRT1FhOVM5d2drNHlYZ3lJWTB4M2dUWE1y?=
 =?utf-8?B?NWJScUR5V1VvdCtEN2c2bWROS0U0ZDhvMnlTZldRdm9iamtDVFlsWTRXazcz?=
 =?utf-8?B?MkZzZkphbHpsYjhlMmc5T3VkNmJSMmppUzNFeEZiTjc3cTJZWkJqN2VEZi9E?=
 =?utf-8?B?YTg5ZXdVSEY3TGkwa3Y5SHBhaUtvWkVsNEh0aUtYdW43blZZbkp2clNvdnhh?=
 =?utf-8?B?UGh4ZUwwT2FCV2UwZ2pPTWR6K1MrN3BUb3J3blF6N1BtR2RjckttNStJdU1Y?=
 =?utf-8?B?RFBrQ3Q4ZVk5L1FrZUhhb1BKaEZTKy9lZ0E4dTFsK0Y0MVpRZklsT25vNnBp?=
 =?utf-8?B?aVZHc0JsanBqaGkySFU2c2lzVTVnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <29289AED7BEC8E448C4D18048EA38577@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: routerhints.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7454.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d9714c8-a13f-46b8-dcc1-08db0c71de76
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2023 20:52:20.5602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 28838f2d-4c9a-459e-ada0-2a4216caa4fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k+NJJEI11c5RV5iwVzIEJlUuvRcRUR2OSTxEO9AguvEmycW52EJYco5NzPdQUhA3Guhzm9ltsrsEC8coEE7Liw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9415
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMTAgRmViIDIwMjMsIGF0IDE5OjQ0LCBWbGFkaW1pciBPbHRlYW4gPG9sdGVhbnZA
Z21haWwuY29tPiB3cm90ZToNCj4gDQo+IEhpLA0KPiANCj4gT24gRnJpLCBGZWIgMTAsIDIwMjMg
YXQgMDg6Mjg6MjNQTSArMDMwMCwgYXJpbmM5LnVuYWxAZ21haWwuY29tIHdyb3RlOg0KPj4gRnJv
bTogUmljaGFyZCB2YW4gU2NoYWdlbiA8cmljaGFyZEByb3V0ZXJoaW50cy5jb20+DQo+PiANCj4+
IFRoZSBvcmlnaW5hbCBjb2RlIG9ubHkgZW5hYmxlcyBmbG9vZGluZyBvbiBDUFUgcG9ydCwgb24g
cG9ydCA2LCBzaW5jZQ0KPj4gdGhhdCdzIHRoZSBsYXN0IG9uZSBzZXQgdXAuIEluIGRvaW5nIHNv
LCBpdCByZW1vdmVzIGZsb29kaW5nIG9uIHBvcnQgNSwNCj4+IHdoaWNoIG1hZGUgc28gdGhhdCwg
aW4gb3JkZXIgdG8gY29tbXVuaWNhdGUgcHJvcGVybHkgb3ZlciBwb3J0IDUsIGEgZnJhbWUNCj4+
IGhhZCB0byBiZSBzZW50IGZyb20gYSB1c2VyIHBvcnQgdG8gdGhlIERTQSBtYXN0ZXIuIEZpeCB0
aGlzLg0KPiANCj4gU2VwYXJhdGUgcGF0Y2ggZm9yIHRoaXMuIEkgZG9uJ3QgdW5kZXJzdGFuZCB0
aGUgY29ycmVsYXRpb24gd2l0aCB0aGUNCj4gb3RoZXIgcGFydCBiZWxvdy4NCg0KV2lsbCBkbywg
YW5kIHRoZXJlIGlzbuKAmXQuIEZsb29kaW5nIGJlY2FtZSBldmlkZW50IG5vdyB3ZSBjYW4gdXNl
IGl0IGF0IDJuZCBDUFUuDQoNCj4gRldJVywgdGhlIHByb2JsZW0gY2FuIGFsc28gYmUgc29sdmVk
IHNpbWlsYXIgdG8gOGQ1Zjc5NTRiN2M4ICgibmV0OiBkc2E6DQo+IGZlbGl4OiBicmVhayBhdCBm
aXJzdCBDUFUgcG9ydCBkdXJpbmcgaW5pdCBhbmQgdGVhcmRvd24iKSwgYW5kIGJvdGggQ1BVDQo+
IHBvcnRzIGNvdWxkIGJlIGFkZGVkIHRvIHRoZSBmbG9vZGluZyBtYXNrIG9ubHkgYXMgcGFydCBv
ZiB0aGUgIm11bHRpcGxlDQo+IENQVSBwb3J0cyIgZmVhdHVyZS4gV2hlbiBhIG11bHRpcGxlIENQ
VSBwb3J0cyBkZXZpY2UgdHJlZSBpcyB1c2VkIHdpdGggYQ0KPiBrZXJuZWwgY2FwYWJsZSBvZiBh
IHNpbmdsZSBDUFUgcG9ydCwgeW91ciBwYXRjaCBlbmFibGVzIGZsb29kaW5nIHRvd2FyZHMNCj4g
dGhlIHNlY29uZCBDUFUgcG9ydCwgd2hpY2ggd2lsbCBuZXZlciBiZSB1c2VkIChvciB1cCkuIE5v
dCBzdXJlIGlmIHlvdQ0KPiB3YW50IHRoYXQuDQoNClNvIGJhc2ljYWxseSB0aGF0IG1lYW5zIHRo
ZSB3cm9uZyBEVFMgd2l0aCBhIGtlcm5lbD8gSXNu4oCZdCB0aGF0IHNpbWlsYXIgdG8gdGhlIHdy
b25nIERUUyANCmZvciBhIGRldmljZT8gUG9ydCA1IC8gR01BQzEgY2FuIGJlIHVzZWQgYXMgPGV0
aHBoeTA+LCA8ZXRocGh5ND4sIGV4dGVybmFsIHBoeSBvbiBwb3J0IDUuDQplLmcuIFNQRiBwb3J0
IG9uIHBvcnQgNSwgb3IgdXNlZCBhcyBzZWNvbmQgQ1BVIHBvcnQuIE5vdCBzdXJlIGhvdyB3ZSBj
b3VsZCBwcmV2ZW50IHRoYXQ/DQoNCkZvciBub3cgSSB3b3VsZCBsaWtlIHRvIGtlZXAgdGhlIGxv
Z2ljIGFzLWlzOiBpdGVyYXRlIG92ZXIgYWxsIGRzYS1wb3J0cyBhbmQgd2hlbiBpdHMgYSBDUFUg
cG9ydA0KRW5hYmxlIGZsb29kaW5nIG9uIHRoYXQgcG9ydC4gTm90IHVzZWQgKG9yIHVwKSBpcyB0
aGUgZGVmYXVsdCBldmVuIHdoZW4gdXNpbmcgbXVsdGlwbGUgZHNhIGNwdXMuDQpGb3IgdGhpcyB3
ZSBhZGRlZCB0aGUgLmNoYW5nZV9tYXN0ZXIuIE5vIGZsb29kaW5nIHdpbGwgdGFrZSBwbGFjZSB1
bnRpbCB3ZSBhY3R1YWxseSBjb25uZWN0IGEgdXNlcg0KcG9ydCB0byB0aGUgY3B1LiANCg0KPj4g
DQo+PiBTaW5jZSBDUFUtPnBvcnQgaXMgZm9yY2VkIHZpYSB0aGUgRFNBIHRhZywgY29ubmVjdGlu
ZyBDUFUgdG8gYWxsIHVzZXIgcG9ydHMNCj4+IG9mIHRoZSBzd2l0Y2ggYnJlYWtzIGNvbW11bmlj
YXRpb24gb3ZlciBWTEFOIHRhZ2dlZCBmcmFtZXMuDQo+IA0KPiBIZXJlLCBJIHVuZGVyc3RhbmQg
YWxtb3N0IG5vdGhpbmcgZnJvbSB0aGlzIHBocmFzZS4NCj4gDQo+ICJDUFUtPnBvcnQiIG1lYW5z
ICJhc3NvY2lhdGlvbiBiZXR3ZWVuIHVzZXIgcG9ydCBhbmQgQ1BVIHBvcnQiPw0KPiANCj4gWW91
J3JlIHNheWluZyB0aGF0IGFzc29jaWF0aW9uIGlzIGZvcmNlZCB0aHJvdWdoIHRoZSBEU0EgdGFn
PyBEZXRhaWxzPw0KPiBXaG8gb3Igd2hhdCBpcyB0aGUgRFNBIHRhZz8gT3IgYXJlIHlvdSBzYXlp
bmcgdGhhdCBwYWNrZXRzIHRyYW5zbWl0dGVkDQo+IGJ5IHRhZ19tdGsuYyBhcmUgYWx3YXlzIHNl
bnQgYXMgY29udHJvbCBwbGFuZSwgYW5kIHdpbGwgcmVhY2ggYW4gZWdyZXNzDQo+IHBvcnQgcmVn
YXJkbGVzcyBvZiB0aGUgcG9ydCBtYXRyaXggb2YgdGhlIENQVSBwb3J0Pw0KPiANCg0KV2hlbiB1
c2luZyBlaXRoZXIgYSDigJxGb3JjZSBQb3J04oCdIGluIHRoZSBETUEgZGVzY3JpcHRvciAod2hp
Y2ggd29ya3MgYWx3YXlzIGJ1dCB3ZSBkb27igJl0IHVzZSkgT1INCndoZW4gd2UgYXJlIGZvcmNp
bmcgYSBQb3J0IGluIHRoZSBTcGVjaWFsIFRhZyAocHJvdmlkZWQgdGhhdOKAmXMgZW5hYmxlZCkg
d2UgYWx3YXlzIGJ5cGFzcyBhbnkgcmVzdHJpY3Rpb24NCmJldHdlZW4gdGhlIENQVSBhbmQgdGhl
IFVzZXIgcG9ydC4gDQoNCj4gIkNvbm5lY3RpbmcgQ1BVIHRvIGFsbCB1c2VyIHBvcnRzIiBtZWFu
cyBhc3NpZ25pbmcgUENSX01BVFJJWChkc2FfdXNlcl9wb3J0cygpKQ0KPiB0byB0aGUgcG9ydCBt
YXRyaXggb2YgdGhlIENQVSBwb3J0LCB5ZXM/IFdoeSB3b3VsZCB0aGF0IGJyZWFrIGNvbW11bmlj
YXRpb24NCj4gZm9yIFZMQU4tdGFnZ2VkIHRyYWZmaWMgKGFuZCB3aGF0IGlzIHRoZSBzb3VyY2Ug
YW5kIGRlc3RpbmF0aW9uIG9mIHRoYXQNCj4gdHJhZmZpYyk/DQo+IA0KPj4gVGhlcmVmb3JlLCBy
ZW1vdmUgdGhlIGNvZGUgdGhhdCBzZXRzIENQVSBhc3NvY2F0aW9uLg0KPj4gVGhpcyB3YXksIHRo
ZSBDUFUgcmV2ZXJ0cyB0byBub3QgYmVpbmcgY29ubmVjdGVkIHRvIGFueSBwb3J0IGFzIHNvb24N
Cj4+IGFzICIucG9ydF9lbmFibGUiIGlzIGNhbGxlZC4NCj4gDQo+IFBhcnRseSB0byBibGFtZSBt
YXkgYmUgdGhlIHBvb3IgcGhyYXNpbmcgaGVyZS4gQUZBSUNTLCB0aGUgcG9ydCBtYXRyaXgNCj4g
b2YgdGhlIENQVSBwb3J0IHJlbWFpbnMgMCB0aHJvdWdob3V0IHRoZSBsaWZldGltZSBvZiB0aGUg
ZHJpdmVyLiBXaHkNCj4gbWVudGlvbiAiLnBvcnRfZW5hYmxlIj8gVGhhdCBoYW5kbGVzIHRoZSB1
c2VyIC0+IENQVSBkaXJlY3Rpb24sIG5vdCB0aGUNCj4gQ1BVIC0+IHVzZXIgZGlyZWN0aW9uLg0K
PiANCkluIC5wb3J0X2VuYWJsZSB3ZSBhbHNvIGdldCB0byDigJxlbmFibGXigJ0gYW55IENQVSBw
b3J0LiBVbnRpbCBub3cgd2UgZGlkbuKAmXQNCmp1c3QgcmV0dXJuIDAgbGlrZSBvdGhlciBkcml2
ZXJzLiBJbnN0ZWFkIG9uIGVtcHR5IHByaXYtPnBvcnRbY3B1XS5wbSB3YXMgdXNlZC4NClNvIHdl
IGNvbm5lY3QgQUxMIHVzZXJzIHBvcnRzIHRvIHRoZSBDUFUgd2hlbiB3ZSBjYWxsIGNwdV9lbmFi
bGUsIGFuZCBjbGVhcg0KdGhhdCB3aGVuIC5wb3J0X2VuYWJsZSBpcyBjYWxsZWQuIFNvIHJlbW92
ZSBib3RoLiBEb27igJl0IGNvbm5lY3QgYW55dGhpbmcgZHVyaW5nDQpDcHUgZW5hYmxlIGFuZCBh
ZGQgYSBjaGVjayBmb3IgdXNlci1wb3J0Lg0KDQo+PiANCj4+IFsgYXJpbmMudW5hbEBhcmluYzku
Y29tOiBXcm90ZSBzdWJqZWN0IGFuZCBjaGFuZ2Vsb2cgXQ0KPj4gDQo+PiBUZXN0ZWQtYnk6IEFy
xLFuw6cgw5xOQUwgPGFyaW5jLnVuYWxAYXJpbmM5LmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IFJp
Y2hhcmQgdmFuIFNjaGFnZW4gPHJpY2hhcmRAcm91dGVyaGludHMuY29tPg0KPj4gU2lnbmVkLW9m
Zi1ieTogQXLEsW7DpyDDnE5BTCA8YXJpbmMudW5hbEBhcmluYzkuY29tPg0KPiANCj4gTWlzc2lu
ZyBGaXhlczogdGFncyBmb3IgcGF0Y2hlcyBzZW50IHRvICJuZXQiLiBNdWx0aXBsZSBwcm9ibGVt
cyA9Pg0KPiBtdWx0aXBsZSBwYXRjaGVzLg0KPiANCg0KV2lsbCBzZXBhcmF0ZSB0aGUgZml4ZXMg
dG8gbXVsdGlwbGUgcGF0Y2hlcy4NCiANCj4+IC0tLQ0KPj4gZHJpdmVycy9uZXQvZHNhL210NzUz
MC5jIHwgMTcgKysrKysrKystLS0tLS0tLS0NCj4+IDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlv
bnMoKyksIDkgZGVsZXRpb25zKC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9k
c2EvbXQ3NTMwLmMgYi9kcml2ZXJzL25ldC9kc2EvbXQ3NTMwLmMNCj4+IGluZGV4IDNhMTUwMTVi
YzQwOS4uYjVhZDRiNGZjMDBjIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL210NzUz
MC5jDQo+PiArKysgYi9kcml2ZXJzL25ldC9kc2EvbXQ3NTMwLmMNCj4+IEBAIC05OTcsNiArOTk3
LDcgQEAgbXQ3NTN4X2NwdV9wb3J0X2VuYWJsZShzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBw
b3J0KQ0KPj4gew0KPj4gc3RydWN0IG10NzUzMF9wcml2ICpwcml2ID0gZHMtPnByaXY7DQo+PiBp
bnQgcmV0Ow0KPj4gKyB1MzIgdmFsOw0KPj4gDQo+PiAvKiBTZXR1cCBtYXggY2FwYWJpbGl0eSBv
ZiBDUFUgcG9ydCBhdCBmaXJzdCAqLw0KPj4gaWYgKHByaXYtPmluZm8tPmNwdV9wb3J0X2NvbmZp
Zykgew0KPj4gQEAgLTEwMDksMjAgKzEwMTAsMTUgQEAgbXQ3NTN4X2NwdV9wb3J0X2VuYWJsZShz
dHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0KQ0KPj4gbXQ3NTMwX3dyaXRlKHByaXYsIE1U
NzUzMF9QVkNfUChwb3J0KSwNCj4+ICAgICAgUE9SVF9TUEVDX1RBRyk7DQo+PiANCj4+IC0gLyog
RGlzYWJsZSBmbG9vZGluZyBieSBkZWZhdWx0ICovDQo+PiAtIG10NzUzMF9ybXcocHJpdiwgTVQ3
NTMwX01GQywgQkNfRkZQX01BU0sgfCBVTk1fRkZQX01BU0sgfCBVTlVfRkZQX01BU0ssDQo+PiAt
ICAgIEJDX0ZGUChCSVQocG9ydCkpIHwgVU5NX0ZGUChCSVQocG9ydCkpIHwgVU5VX0ZGUChCSVQo
cG9ydCkpKTsNCj4+ICsgLyogRW5hYmxlIGZsb29kaW5nIG9uIENQVSAqLw0KPj4gKyB2YWwgPSBt
dDc1MzBfcmVhZChwcml2LCBNVDc1MzBfTUZDKTsNCj4+ICsgdmFsIHw9IEJDX0ZGUChCSVQocG9y
dCkpIHwgVU5NX0ZGUChCSVQocG9ydCkpIHwgVU5VX0ZGUChCSVQocG9ydCkpOw0KPj4gKyBtdDc1
MzBfd3JpdGUocHJpdiwgTVQ3NTMwX01GQywgdmFsKTsNCj4+IA0KPj4gLyogU2V0IENQVSBwb3J0
IG51bWJlciAqLw0KPj4gaWYgKHByaXYtPmlkID09IElEX01UNzYyMSkNCj4+IG10NzUzMF9ybXco
cHJpdiwgTVQ3NTMwX01GQywgQ1BVX01BU0ssIENQVV9FTiB8IENQVV9QT1JUKHBvcnQpKTsNCj4+
IA0KPj4gLSAvKiBDUFUgcG9ydCBnZXRzIGNvbm5lY3RlZCB0byBhbGwgdXNlciBwb3J0cyBvZg0K
Pj4gLSAgKiB0aGUgc3dpdGNoLg0KPj4gLSAgKi8NCj4+IC0gbXQ3NTMwX3dyaXRlKHByaXYsIE1U
NzUzMF9QQ1JfUChwb3J0KSwNCj4+IC0gICAgICBQQ1JfTUFUUklYKGRzYV91c2VyX3BvcnRzKHBy
aXYtPmRzKSkpOw0KPj4gLQ0KPj4gLyogU2V0IHRvIGZhbGxiYWNrIG1vZGUgZm9yIGluZGVwZW5k
ZW50IFZMQU4gbGVhcm5pbmcgKi8NCj4+IG10NzUzMF9ybXcocHJpdiwgTVQ3NTMwX1BDUl9QKHBv
cnQpLCBQQ1JfUE9SVF9WTEFOX01BU0ssDQo+PiAgICBNVDc1MzBfUE9SVF9GQUxMQkFDS19NT0RF
KTsNCj4+IEBAIC0yMjA0LDYgKzIyMDAsOSBAQCBtdDc1MzBfc2V0dXAoc3RydWN0IGRzYV9zd2l0
Y2ggKmRzKQ0KPj4gDQo+PiBwcml2LT5wNl9pbnRlcmZhY2UgPSBQSFlfSU5URVJGQUNFX01PREVf
TkE7DQo+PiANCj4+ICsgLyogRGlzYWJsZSBmbG9vZGluZyBieSBkZWZhdWx0ICovDQo+PiArIG10
NzUzMF9ybXcocHJpdiwgTVQ3NTMwX01GQywgQkNfRkZQX01BU0sgfCBVTk1fRkZQX01BU0sgfCBV
TlVfRkZQX01BU0ssIDApOw0KPj4gKw0KPiANCj4gU2hvdWxkbid0IG10NzUzMV9zZXR1cCgpIGhh
dmUgdGhpcyB0b28/DQo+IA0KPj4gLyogRW5hYmxlIGFuZCByZXNldCBNSUIgY291bnRlcnMgKi8N
Cj4+IG10NzUzMF9taWJfcmVzZXQoZHMpOw0KPj4gDQo+PiAtLSANCj4+IDIuMzcuMg0KDQoNCg==
