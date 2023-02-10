Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D07F69296C
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 22:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbjBJVlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 16:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbjBJVlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 16:41:12 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2058.outbound.protection.outlook.com [40.107.247.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E3260D4D;
        Fri, 10 Feb 2023 13:41:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DTMJG5cIufUzIrqz5oYntTJzX/F0xkijDgEQc4gbtgQAygmlSZ2uQ41QdTXHVVDTqvR6fVyngJ16m1tlq41suaL81tcyFpIGFitblTAXP8PQT7GhdPi1tUfJW/vobomLmLQZneLn6QiqyATzghewkm9bxzjJnbSchz0mTJeONcJRkRnF1R8WDehMz2BL8EZuhu4Plu0coui1OuSrCLCCpxIhyfXlNpSOnieus5L1r/in678M6NuB1RkA2j1UyvYsivabiCmVB3FN7jk9f9hFab7DgzRnmYT52HbfRlP+lCRcRjKtGDhHTdiAQKTB1+6ryG4gVQV/JD0KfMVDFKMNSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gY4aKidi7rB0p7aQRp6Cns9RtBhZvCPPvmtcWJuXHNk=;
 b=idbtqHmAa8dqN2CUpoWISJsAwBqyv333blLLGSDDo8HbCPJ81X35q42KW8231u2cMXpXxynHQwpNGGG45jqUW9IfTJDTInBbl76rsfI31WPlvnSDC23iwAan122b7eV4JyqCC0/qrFU4HMwY6Y5mGWNDziELPfaVGfBv9CXZrQW2yeVHdt4sudUz/sxUiYAmJhX0N+vd7SftpVVxarzknQxN1XcJI20m41Y/CDGWj5Y0K8Z4i6KuPulV9SVmDUZPB0CAwyUyVqHMzitRhNBfRvgEgqAis/2rzXQR41//BTe6UrniN6axuq8VC9fE9K1DwTtpVLjHqu2ABSAfKPrMZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=routerhints.com; dmarc=pass action=none
 header.from=routerhints.com; dkim=pass header.d=routerhints.com; arc=none
Received: from VE1PR04MB7454.eurprd04.prod.outlook.com (2603:10a6:800:1a8::7)
 by DB8PR04MB7130.eurprd04.prod.outlook.com (2603:10a6:10:123::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 21:41:07 +0000
Received: from VE1PR04MB7454.eurprd04.prod.outlook.com
 ([fe80::e4a3:a727:5246:a5cd]) by VE1PR04MB7454.eurprd04.prod.outlook.com
 ([fe80::e4a3:a727:5246:a5cd%4]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 21:41:06 +0000
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
Subject: Re: [PATCH net-next] net: dsa: mt7530: add support for changing DSA
 master
Thread-Topic: [PATCH net-next] net: dsa: mt7530: add support for changing DSA
 master
Thread-Index: AQHZPXVMHgXeoBSa6k+E0Sw3LKA7S67Ih+DGgAAt6oA=
Date:   Fri, 10 Feb 2023 21:41:06 +0000
Message-ID: <42C4F87B-520A-4F43-924D-9CDA577B04C7@routerhints.com>
References: <20230210172942.13290-1-richard@routerhints.com>
 <20230210172942.13290-1-richard@routerhints.com>
 <20230210185629.gfbaibewnc5u3tgs@skbuf>
In-Reply-To: <20230210185629.gfbaibewnc5u3tgs@skbuf>
Accept-Language: nl-NL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=routerhints.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VE1PR04MB7454:EE_|DB8PR04MB7130:EE_
x-ms-office365-filtering-correlation-id: 992de93c-3d3f-4a6d-a52c-08db0baf840a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bzVU9IIgkbouIbC4r6Rf4BOYdeDYgTdM0SR5n/+PgxV4hXpeVBpg6YWcItllIpgxcidmDtiM5Dr/7AdfFnVCG3HrjBdaCb4nM8OtrrGAcfgI38o9gInChLv7GUHakNpIo8ZYbXzuwW8xhbV2E0UdFTZQLTQuo2MQeh0xois044x8xVHXMebL/s36xhHGh9zcN7vO9sGNCjHC2c6r+mgAQX9RfSdPstdmZz+DnnIkf8AWCuExt2NSON2SYjfogebWjIamlIjeIMf0wiwrMPxyXmQV4hYItA8j0vx3wJcQp7UIIjJVhNpufO1ThRUUKeoWRvlTJnCwWhg+TWiSA/mv4VSpmUTCD3/vgvdIz4aCATSiQl2VHyfQKIDFMuRmrLoRuEhEDVlqvvbDn5yJR9F9W+NnEMjywsuOxuWIMtr1WUE8tS0+iJUPsg+n5FyNy+c2NG3yB30uNWQCRxftsgpFMS7wfEOO9sftc4XsQ9671gDN2OeGm/ZLE1Ji22EDNKpCl8dKkBkSEo1P+FrXW7C0HsPJilUE4k6jezq7wbzM5uxSU2fODYLc6Zh+DVPLXL9YK8K/V47zUAP8MKMn9VfBLZCcsWbY78PsMoV+7+QwAf0qTmf66PWr+1Yu2PUrWZT5IYQZkk/lrXHzvu3meEWX8SpbcVPUZGDEsZf6kfRsn8DY4uomv+SNV/YOOVAGAws2H6oqMNDQOyZle3edT+aF9GdZIdmMJzuGrUl4dPRwKVI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7454.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39830400003)(366004)(346002)(136003)(396003)(451199018)(38100700002)(83380400001)(122000001)(6916009)(2906002)(86362001)(7416002)(8936002)(186003)(54906003)(71200400001)(6506007)(6512007)(53546011)(38070700005)(478600001)(316002)(6486002)(41300700001)(5660300002)(8676002)(64756008)(91956017)(66476007)(66946007)(66446008)(66556008)(76116006)(4326008)(33656002)(66574015)(36756003)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3E3WnlYSWdmUjdSYWJPUk91K05zWnFhY3J6Tm5sSkwwN21GQTJrSlcvUWFh?=
 =?utf-8?B?RjFkZWNNRmdFK0hHRlAzRTBwcmwxcnJqdEtQcU1Ea0g5VHM0citQYVRERnJ4?=
 =?utf-8?B?dWNtVzdiUFBoSW5oYWhySW00ekc0dUNjQk5yOGpUSTU4VlE1QWpRMm1yY2Fu?=
 =?utf-8?B?VCticStHcG8xV3NEVmdMQzIrc2ZTS3Myak8rVSsyZFdkRUlFK2tvYS9NZGpY?=
 =?utf-8?B?NUdFLytkdFFFVW5Bd1dWVHBFM2dhUU9vYzVCa0I3bVJZaHdTb1RrclQzSUFy?=
 =?utf-8?B?Ylk5Nk84K3J4aWYyK2hncURKWi9manc3SWNNNjJwcVJrbGhVK0w3VHRJZjdh?=
 =?utf-8?B?VE9BbEkzRG5VTkJMWWg5SURyL0lzQWtIY3Nha2ZISko4M0M4ZWJHV2k4cUhB?=
 =?utf-8?B?MU9UdEtkVnJvUWVoM0FiYjdMV3Fycy9WeEdkMUcvV3NpK1pFUXJzd01UQm41?=
 =?utf-8?B?MTNCYUZMOEFlOUpGQm1XS1JlVkhDLzBGOTh3WExyQWRwcTV4SG9NbHA5eVZS?=
 =?utf-8?B?ekJ4d3NuN21TTmdSekp4SkpIRlFVeUkwa0xHWjZkWStJZFVncjZRdUEwTWpG?=
 =?utf-8?B?K1JLblM4a3M1YkpkYStTcWxkaElzamliTnR3ekRvUys4bWpscmxHL0V6N1J6?=
 =?utf-8?B?OEcvblZreXZYNlRkOGtDWnJHcTdNMHN5OUVMcjkwb0kzZjhGNDR4TW51dXM3?=
 =?utf-8?B?NEp4Qjd5cHdicFdtMFFDZUZCNEI5MUE2K1ltU3RPa1VKTEdiSXlkcGZNRHow?=
 =?utf-8?B?SmxHNmVLOVoyUGl5VFVOcHp3UzcrN2dTL1UvejhTeVZzNmYvOU5rR2lDNXZH?=
 =?utf-8?B?YUNSZnpmdHhhRUxKZkRjZitpUTl6NFg1NUJHajgvYmdCckErbHg4bHhuL09F?=
 =?utf-8?B?QXRubzZobUcxMDRHU1l6cElTTERXTitCWThYY0lodmpwRzNhcFZXci9RN1Yr?=
 =?utf-8?B?cDRwMWxCSWJ1UzVHdm00UnA3SnNCbzl1RVJiNXpnSGxqQzVnYkZVWnBpOEZR?=
 =?utf-8?B?aE1XNFc5dFhMdEtSSHFLUHNUQzJBMTU5VWF6TGxtTXBFb0J0ZXRLcjBleUN4?=
 =?utf-8?B?cXEwSGJ4QjdVVHdQMHBqZklsVFkxbzhuYy9SUHpORTZMZGY4UXpqRE9sSlpE?=
 =?utf-8?B?d2xEdWZhUEg4RXJQaFFTUFpwTEl3RFZ4YytzM2hHM0xYT2VySWtUY0NId2JY?=
 =?utf-8?B?QmJhSUV0L2JDMVUzSHhvM2R5MVJFcE9NdlBCb0lveEp3UWxSampMZkhBaEs5?=
 =?utf-8?B?MVg2SzZuRllGbDF5NE16RHE5NHcrUmR6amdxekhvbXltYklvMW5lZ0RndVJa?=
 =?utf-8?B?VGtVdUFLK0lEVzJiL0RkS21IYW5hZ3VDT2k2YTZ5bmJWNUtyUGNOVEN1Mjhi?=
 =?utf-8?B?S0pXa1RoYkt2cmFTRWJKcG91UnhQa2o3YTg0azBhcU0rQjBadDJMcG94T1p3?=
 =?utf-8?B?cGlyUGhCenhNSE1FanRLSS93VkdOaG53SWJjTXlNSS9tOFNid2gweXJ4MGUx?=
 =?utf-8?B?ZlVleXpackNiNlcwQWJzckRIYzVidk9EMG9ZeERiVkxKYjFzVnBpcVdCbDdn?=
 =?utf-8?B?WUpVeFNtR0hIdU9hYWJUZGJZNmkxbFpHNUtEOU9CRUZmRmJjTUNGQkUxUGN5?=
 =?utf-8?B?UDhDNGhJS2J5c3pmRmw4dWFhUUdvK1EwUjlVQ2VuRy9NK1FQMlZIdWZkOWxH?=
 =?utf-8?B?R3pySm9vZ0M4UzhqUTVPaS8vbVp1L0dPb3E5SEhYMEZpYmJwWWpJcEdnN0dK?=
 =?utf-8?B?NGFJakhrbzd1WHR2N0VIeDNWdmZYbHc0ZmFSeHgyR0VpaHgrSUpnU1ZpSjl3?=
 =?utf-8?B?eHVVV0pCckVCQTZ6ZVhCc2NNcUhUckU1NXo5MTFtU2U5bFlFY05QMExDUlZQ?=
 =?utf-8?B?MGhtQUtuczRBS3ppYnFuZ1BkUkUzamFrZ1J2MHdtcktySWNLbi9NL0RHc0c4?=
 =?utf-8?B?RTlrNzVDVWZ4QSt2czIyUTh6SUx1Njd0aitFTmhCNmNXOGRZVUdFcXQrZHFj?=
 =?utf-8?B?bGxNdG1YbFUxaUxmTHFSMUZUaGVYUFpsYmZJVVBxNGtDRzZBS2dRTVdTV2Uy?=
 =?utf-8?B?QzMzVjc2Q2VLSXlBSHMvREVtbkhUK3pMU1ZSMm1EOHl2ekE2a2ZnZTFmV1lU?=
 =?utf-8?B?SE9vQ1Jhc2pGTDBKMVpuWFZjR1J5dzczdjZCcE1MRUdxbDFaODlRMmZPcU9Y?=
 =?utf-8?B?UlpkU1FZSnhtaWNMMG01KzR5SzFDYTRCdVFiU2xpeGd3cEpicWEwams2cjE3?=
 =?utf-8?B?SnhKR1RKeTJpeE5LZ0lQV2J6UUhRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D837AC1FBD56E145AC30236938EEC018@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: routerhints.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7454.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 992de93c-3d3f-4a6d-a52c-08db0baf840a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2023 21:41:06.5059
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 28838f2d-4c9a-459e-ada0-2a4216caa4fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QEFioJGm+eGoQGx5qnNJ42fY2KsC/j2mjgeBH5u0BB4Qoru1j1Hde6nG6y+vhzSFAIL+x91uZD/5g0ZVlCXo4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7130
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMTAgRmViIDIwMjMsIGF0IDE5OjU2LCBWbGFkaW1pciBPbHRlYW4gPG9sdGVhbnZA
Z21haWwuY29tPiB3cm90ZToNCj4gDQo+IE9uIEZyaSwgRmViIDEwLCAyMDIzIGF0IDA4OjI5OjQz
UE0gKzAzMDAsIGFyaW5jOS51bmFsQGdtYWlsLmNvbSB3cm90ZToNCj4+IEZyb206IFJpY2hhcmQg
dmFuIFNjaGFnZW4gPHJpY2hhcmRAcm91dGVyaGludHMuY29tPg0KPj4gDQo+PiBBZGQgc3VwcG9y
dCBmb3IgY2hhbmdpbmcgdGhlIG1hc3RlciBvZiBhIHBvcnQgb24gdGhlIE1UNzUzMCBEU0Egc3Vi
ZHJpdmVyLg0KPj4gDQo+PiBbIGFyaW5jLnVuYWxAYXJpbmM5LmNvbTogV3JvdGUgc3ViamVjdCBh
bmQgY2hhbmdlbG9nIF0NCj4+IA0KPj4gVGVzdGVkLWJ5OiBBcsSxbsOnIMOcTkFMIDxhcmluYy51
bmFsQGFyaW5jOS5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBSaWNoYXJkIHZhbiBTY2hhZ2VuIDxy
aWNoYXJkQHJvdXRlcmhpbnRzLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IEFyxLFuw6cgw5xOQUwg
PGFyaW5jLnVuYWxAYXJpbmM5LmNvbT4NCj4+IC0tLQ0KPj4gZHJpdmVycy9uZXQvZHNhL210NzUz
MC5jIHwgMzMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+PiAxIGZpbGUgY2hh
bmdlZCwgMzMgaW5zZXJ0aW9ucygrKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZHNhL210NzUzMC5jIGIvZHJpdmVycy9uZXQvZHNhL210NzUzMC5jDQo+PiBpbmRleCBiNWFkNGI0
ZmMwMGMuLjA0YmI0OTg2NDU0ZSAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9tdDc1
MzAuYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL210NzUzMC5jDQo+PiBAQCAtMTA3Miw2ICsx
MDcyLDM4IEBAIG10NzUzMF9wb3J0X2Rpc2FibGUoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQg
cG9ydCkNCj4+IG11dGV4X3VubG9jaygmcHJpdi0+cmVnX211dGV4KTsNCj4+IH0NCj4+IA0KPj4g
K3N0YXRpYyBpbnQNCj4+ICttdDc1MzBfcG9ydF9jaGFuZ2VfbWFzdGVyKHN0cnVjdCBkc2Ffc3dp
dGNoICpkcywgaW50IHBvcnQsDQo+PiArICAgICAgICBzdHJ1Y3QgbmV0X2RldmljZSAqbWFzdGVy
LA0KPj4gKyAgICAgICAgc3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrKQ0KPiANCj4gYWxp
Z25tZW50DQo+IA0KV2lsbCBmaXgNCg0KPj4gK3sNCj4+ICsgc3RydWN0IG10NzUzMF9wcml2ICpw
cml2ID0gZHMtPnByaXY7DQo+PiArIHN0cnVjdCBkc2FfcG9ydCAqZHAgPSBkc2FfdG9fcG9ydChk
cywgcG9ydCk7DQo+PiArIHN0cnVjdCBkc2FfcG9ydCAqY3B1X2RwID0gbWFzdGVyLT5kc2FfcHRy
Ow0KPj4gKyBpbnQgb2xkX2NwdSA9IGRwLT5jcHVfZHAtPmluZGV4Ow0KPj4gKyBpbnQgbmV3X2Nw
dSA9IGNwdV9kcC0+aW5kZXg7DQo+IA0KPiBJIGJlbGlldmUgeW91IG5lZWQgdG8gcmVqZWN0IExB
RyBEU0EgbWFzdGVycy4NCj4gDQoNCk5vdCBzdXJlIHdoYXQgeW91IG1lYW46IGhvdyBpcyB0aGlz
IGRpZmZlcmVudCBmcm9tIHRoZSBjaGFuZ2VfbWFzdGVyIGluIHRoZSBGZWxpeCBkcml2ZXIgd2hl
biB1c2luZyA4MDIxcSB0YWdzPw0KQnV0LiBDYW4gYWRkIGEgY2hlY2sgaWYgeW91IHByZWZlci4g
SXQgbWlnaHQgYmUgYSBnb29kIGlkZWEgYW55d2F5IHRvIGJlIGZ1dHVyZSBwcm9vZi4gVGhlIE1U
NzUzMSBoYXMgc3VwcG9ydCBmb3IgTEFHIGluIGh3Lg0KDQo+PiArDQo+PiArIG11dGV4X2xvY2so
JnByaXYtPnJlZ19tdXRleCk7DQo+PiArDQo+PiArIC8qIE1vdmUgb2xkIHRvIG5ldyBjcHUgb24g
VXNlciBwb3J0ICovDQo+PiArIHByaXYtPnBvcnRzW3BvcnRdLnBtICY9IH5QQ1JfTUFUUklYKEJJ
VChvbGRfY3B1KSk7DQo+PiArIHByaXYtPnBvcnRzW3BvcnRdLnBtIHw9IFBDUl9NQVRSSVgoQklU
KG5ld19jcHUpKTsNCj4+ICsNCj4+ICsgbXQ3NTMwX3Jtdyhwcml2LCBNVDc1MzBfUENSX1AocG9y
dCksIFBDUl9NQVRSSVhfTUFTSywNCj4+ICsgICAgcHJpdi0+cG9ydHNbcG9ydF0ucG0pOw0KPj4g
Kw0KPj4gKyAvKiBNb3ZlIHVzZXIgcG9ydCBmcm9tIG9sZCBjcHUgdG8gbmV3IGNwdSAqLw0KPj4g
KyBwcml2LT5wb3J0c1tvbGRfY3B1XS5wbSAmPSB+UENSX01BVFJJWChCSVQocG9ydCkpOw0KPj4g
KyBwcml2LT5wb3J0c1tuZXdfY3B1XS5wbSB8PSBQQ1JfTUFUUklYKEJJVChwb3J0KSk7DQo+PiAr
DQo+PiArIG10NzUzMF93cml0ZShwcml2LCBNVDc1MzBfUENSX1Aob2xkX2NwdSksIHByaXYtPnBv
cnRzW29sZF9jcHVdLnBtKTsNCj4+ICsgbXQ3NTMwX3dyaXRlKHByaXYsIE1UNzUzMF9QQ1JfUChu
ZXdfY3B1KSwgcHJpdi0+cG9ydHNbbmV3X2NwdV0ucG0pOw0KPiANCj4gLSB3aG8gd3JpdGVzIHRv
IHRoZSAicG0iIGZpZWxkIG9mIENQVSBwb3J0cz8NCg0KTm9ib2R5IGFjdHVhbGx5IHdyaXRlcyB0
byBjcHUucG0uIEkg4oCcZml4ZWTigJ0gdGhhdCwgYW5kIGRyb3BwZWQgdGhhdCBsYXRlci4gVGhp
cyBpcyBsZWZ0IG92ZXIuDQoNCj4gLSBob3cgZG9lcyB0aGlzIGxpbmUgdXAgd2l0aCB5b3VyIG90
aGVyIHBhdGNoIHdoaWNoIHNhaWQgKEFGQUlVKSB0aGF0DQo+ICB0aGUgcG9ydCBtYXRyaXggb2Yg
Q1BVIHBvcnRzIHNob3VsZCBiZSAwIGFuZCB0aGF0IHNob3VsZCBiZSBmaW5lPw0KDQpTaW5jZSBj
cHUucG0gd2FzIG5ldmVyIHVzZXIsIGFuZCBhbGwgdXNlciBwb3J0cyB3ZXJlIGFkZGVkIHdpdGhv
dXQgdXNpbmcgdGhpcyBmaWVsZCB3aGVuIGVuYWJsaW5nDQp0aGUgY3B1LCBJIGNoYW5nZWQgdGhh
dCB0byBhZGQgdXNlciBwb3J0cyBiZWxvbmdpbmcgdG8gdGhhdCBDUFUuIEFyaW5jIHJlcG9ydGVk
IHRoYXQgaXQgZGlkbuKAmXQgd29yay4NClNpbmNlIHRoZSBjcHUucG0gKGVtcHR5KSBpcyB3cml0
aW5nIGR1cmluZyBkc2FfZW5hYmxlX3BvcnQgYW5kIHRoYXQgd29ya2VkIChmb3IgYSBsb25nIHRp
bWUgYWxyZWFkeSkgdGhlIGNwdS5wbSBjYW4gYmUgZHJvcHBlZC4NCg0KPiAtIHJlYWQvbW9kaWZ5
L3dyaXRlIChybXcpIHVzaW5nIFBDUl9NQVRSSVhfTUFTSyByYXRoZXIgdGhhbiBtdDc1MzBfd3Jp
dGUoKS4NCj4gIFRoYXQgb3ZlcndyaXRlcyB0aGUgb3RoZXIgUENSIGZpZWxkcy4NCj4gDQoNCkdv
b2QgY2F0Y2guIFdpbGwgZml4Lg0KDQo+PiArDQo+PiArIG11dGV4X3VubG9jaygmcHJpdi0+cmVn
X211dGV4KTsNCj4+ICsNCj4+ICsgcmV0dXJuIDA7DQo+PiArfQ0KPj4gKw0KPj4gc3RhdGljIGlu
dA0KPj4gbXQ3NTMwX3BvcnRfY2hhbmdlX210dShzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBw
b3J0LCBpbnQgbmV3X210dSkNCj4+IHsNCj4+IEBAIC0zMTU3LDYgKzMxODksNyBAQCBzdGF0aWMg
Y29uc3Qgc3RydWN0IGRzYV9zd2l0Y2hfb3BzIG10NzUzMF9zd2l0Y2hfb3BzID0gew0KPj4gLnNl
dF9hZ2VpbmdfdGltZSA9IG10NzUzMF9zZXRfYWdlaW5nX3RpbWUsDQo+PiAucG9ydF9lbmFibGUg
PSBtdDc1MzBfcG9ydF9lbmFibGUsDQo+PiAucG9ydF9kaXNhYmxlID0gbXQ3NTMwX3BvcnRfZGlz
YWJsZSwNCj4+ICsgLnBvcnRfY2hhbmdlX21hc3RlciA9IG10NzUzMF9wb3J0X2NoYW5nZV9tYXN0
ZXIsDQo+PiAucG9ydF9jaGFuZ2VfbXR1ID0gbXQ3NTMwX3BvcnRfY2hhbmdlX210dSwNCj4+IC5w
b3J0X21heF9tdHUgPSBtdDc1MzBfcG9ydF9tYXhfbXR1LA0KPj4gLnBvcnRfc3RwX3N0YXRlX3Nl
dCA9IG10NzUzMF9zdHBfc3RhdGVfc2V0LA0KPj4gLS0gDQo+PiAyLjM3LjINCg0KDQo=
