Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B8051D78A
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 14:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391760AbiEFM21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 08:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243253AbiEFM20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 08:28:26 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2049.outbound.protection.outlook.com [40.107.20.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A742727CC2;
        Fri,  6 May 2022 05:24:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uch0+nDOctfbl+VTR4+uytASh6vfGsyIdZYrPAF5rrTAiFOGpYogtVWnWssfAWqSgzvfGohffXz0+eFIWFP2w8l69PEnjUIKAOaUSZGXSMindcPygqSvfMjgy7+YjdFsKZmggABCVhtfYb8ZK4CUNn3aOfowMIjGzHLZOrbKKLJ1XgIe1OX0MmXz5Ix2kaQquxuMR29pa0zwNYdoX8+2Z/g9Ge4oo9dpA9UwhsJ1MD9oRTMPhyJU9aVgYGHoVhCI6Tc4KvBxIr0TdZUy+oUEJM+E164ON05wrvNbw1TlAh2QdSW7FNiqsDrWjrmtLQYR7QsEEWH2Uu43Ii4EgghJVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/DNNEG9w79SLmG1iRWmhvoACmnqRfBycL0f4ZI8CwM=;
 b=hm2CbrfoCrp3Jwxql4I45rZVV6o6fvjDfjj3XWxYJGhH1afbvoPq866w4QRG7zHzKCT2RRkiMDzu8KQwQYPXyDpAVc2FtA947RZtkMO7T058eh5wLxSDphjRoZ5DcMT71KuqQDqupcOPoc0YQXUaoSx/RwozIxYBCt77JX93vzQsbjuTamvDY7wBjBWt+fNtPC2hfrhnlcmiy6wlW6qCCpCV0x9GFRi5NiPYNgedh/no7o9EELikY00ttm+HYNDHx6NVEYFY+m8gr/hYfKoatGq8Zta1dtSIV2f0B6wpOYD64BzwFK4puX6jkPBGdqKFog8Z36aLPNicWaLeJDyINg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/DNNEG9w79SLmG1iRWmhvoACmnqRfBycL0f4ZI8CwM=;
 b=epR5D3HQSBaalJfzhgGoQRjAmFSMktH068Du93D3mpSmsLfcpudD7DU6xjwdTlIUt/y9lXgm6qMUavDzki+to09rDlt2QyhaIJpT07zNSaGFZgEGeFTrLlwcYswI2a24GqVtNg/X0SIzJjir5qG98J8L4c4kp3lnP+UZU8mdx7k=
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com (2603:10a6:803:29::11)
 by HE1PR0701MB2841.eurprd07.prod.outlook.com (2603:10a6:3:4e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Fri, 6 May
 2022 12:24:37 +0000
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::d4db:2044:5514:6d25]) by VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::d4db:2044:5514:6d25%7]) with mapi id 15.20.5206.025; Fri, 6 May 2022
 12:24:37 +0000
From:   Ferenc Fejes <ferenc.fejes@ericsson.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>
Subject: Re: [PATCH v2 net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
Thread-Topic: [PATCH v2 net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
Thread-Index: AQHYYR3WrsP3fgIutUOWZHiGk9ZeJK0Rv+sAgAAGWAA=
Date:   Fri, 6 May 2022 12:24:37 +0000
Message-ID: <c2730450-1f2b-8cb9-d56c-6bb8a35f0267@ericsson.com>
References: <20220501112953.3298973-1-vladimir.oltean@nxp.com>
 <302dc1fb-18aa-1640-dfc7-6a3a7bc6d834@ericsson.com>
 <20220506120153.yfnnnwplumcilvoj@skbuf>
In-Reply-To: <20220506120153.yfnnnwplumcilvoj@skbuf>
Accept-Language: hu-HU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ericsson.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2546a4e-d7de-4844-a18f-08da2f5b62bd
x-ms-traffictypediagnostic: HE1PR0701MB2841:EE_
x-microsoft-antispam-prvs: <HE1PR0701MB2841C26F6F4D08C531BF05F8E1C59@HE1PR0701MB2841.eurprd07.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xtv/tYitJWUv/DZ5W4FahFxKsuK921NloaBdlBUdcXDzjpBn/Gtqs8dCECbB6ZhRdK4n+09+4aQQr6kGk2wKBjqI5ojtatYOIc+8PsoDN3hwSU0kQKf47EDgPIaTPbC5lCDzozMk4zyNuHD/G+BAxaUDzbfZcOZavkqtu+SL18ylygxVDLZaqZZ72geIMXJzvMZQoc3Vc8u5CkO0fqHJ0A+YaGse91VNFd98wY1rKXqiE1vVaY+PQe/wkPQyeEqPCA953UvMumGBwilQZVEN8XU2EWe9e25lW8rDwCXsbqszFcQMqy/UfWTUwSXf8meZaOFMqrAKD/gnjvQ7H8BiOtKMfyZgRwE9WhkVrb54NQOaY07QPAcBIj97U5KryfWQODQhpgAM0oeCTUXVLGnfS/duifvjQyRT6MO1VbggzqNgk/q9wZBJAxxPP6XycI10IZCBpHl6VRmGazVTcLus9jfIuwHv1B4Z/5jSmFuDpc9sn0PvHFzfsH477Cr8MFLrfVBWW3y718qp11gmDXqJIp3if33R6Hrlpc/Lxsyj5nu5kQHrk8PF+OfyyznxIiStLZcHv3gaXJAQWBeCfbvzTzyUxIc38tz0LuXSnFHnh137xgdKKr+4HAoPOpkbAppaIhSF8Ei1HJ/1wm2bGDTk57s1p0DxXLAkH7lc7S4lybtmhUIjIf/VndTiwjE3s3VKkCiKyebUds7lpBxG7zrwz64CvX6jchuyf0WcjaNKr/ClnpTTEPZN3HW3ZqEMySZM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR07MB4080.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(71200400001)(186003)(31686004)(2616005)(83380400001)(26005)(91956017)(6506007)(6512007)(6486002)(508600001)(4744005)(7416002)(8676002)(82960400001)(2906002)(4326008)(6916009)(54906003)(66476007)(64756008)(66446008)(66556008)(316002)(76116006)(66946007)(38070700005)(38100700002)(5660300002)(44832011)(8936002)(86362001)(31696002)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MVpzNWpqa2ZFbW9LTVBSZzYwSjEvOEphUXptTlNuVG50K2hHcHIwNFkrMmZR?=
 =?utf-8?B?RWJ6MURiMlpEVzh6SkNpNDd3SG9pZzR6RngvMXZ0dGtqbzBSME16NERyWnNs?=
 =?utf-8?B?MHdVanpXL1diME1pMlJuWXZMNGRVTWNmc2VwZlFnZ21SZFRVeDJXRFlyc0o4?=
 =?utf-8?B?VnhCRnFTcitxVmh5Ync5d2NUUkwrdzh0K3R5dGZFYXh0a2N5YWdBa1FaeHRO?=
 =?utf-8?B?dXFoV2FPTU9iN0hXeERoSERNWGw4R2hjT0NrditKRUgzWGUwNzhEbTJHczcz?=
 =?utf-8?B?NXVBYXNkVE02c01kUlZvTW53c1lTMjBsNXpPNDlFNlBpRVlYaER5TzcyYVRq?=
 =?utf-8?B?QktzWFVFb3llU1V6c3FUdG5iMVp4cmFJT0VKWGl5N2lVcGg2cjI2Z0haaTlH?=
 =?utf-8?B?Mit6MmhySU1qQkNVR1dJWHM1eUZoY2JjM3UwMW1WVTN0V0lHZEhwRk41em5z?=
 =?utf-8?B?dEJWVGxQeHV6cUhrTGxETkhVT1dYMXcrOUxTaXdqSjUvc2RhL2pVNTlYRWxi?=
 =?utf-8?B?eWI5Q3crZ3FtOXhJSEt5OGlNbVF2TitaSHJBNUF2Y2VDN0NadnZQcVlIRzhv?=
 =?utf-8?B?VU50UDhUdXpIbUUyNzZScnkrSTkwZUhzNHozNU1MODcyeTZ1clZhR0FRK0VT?=
 =?utf-8?B?U3JmU2kyUFIvd2R4U2lhVTNMc1JzM0JicGJDb3RJcUoxd3RGSG1wUHcvOEM3?=
 =?utf-8?B?d204ai8rclFwNkVVbCtDdEdHRG5mMkpwUVZra0JHZFhQdHpnbkNXQVZhR1RS?=
 =?utf-8?B?Qm16Nyt1bVpJeVRFekF5QUtmcjg3b2hYcjV4RTI5Z1J0aUgwbkowM2xEekdv?=
 =?utf-8?B?ZFY4VnZ5b1QzelhRZ2d1S0svTkFaMnJ4dDYxYjJDMmVtbTZCNHY3VTFuYVhl?=
 =?utf-8?B?OVQ0ZXdBTlNjYlJWQjBuamVGczdaN2RnMW94eDEyZFlXOEZhRmR1Rm5lVWVN?=
 =?utf-8?B?QWZlUndpVDFCL0ZvTG9IQUw2UVdsenc4S0RxSDZydDFVTmU3YTVkWFh1OXFG?=
 =?utf-8?B?eEp2K0M3N1FDL0FvcWpKbDJGRTJUbC9Kczg3MDIvVlAyMDZjQkJldXRIRmZ1?=
 =?utf-8?B?K0h3elpaeDZxb2pERU1idHNBMEdUaDBsR28rclVUWGRYUjF3cGZqWVRlWWNt?=
 =?utf-8?B?L1Bxa3hnT3BoMUJvbnRGRmUwSnBUem1uYm5tekgxaXlhVDRFTlFKcTVjWlND?=
 =?utf-8?B?UXBnVXBaaWFCaUJpclBRWThYcFRVNjhYcjFuV1hBOUhiOFUrRlozbVZ5N216?=
 =?utf-8?B?dmFENlJjNXdnSytzY3J1K0tsM2pPTm5INkNUYXJzOHpSODBYbmhkYTNycWZt?=
 =?utf-8?B?ZTJDeno5SHBFQXh1Y25TdWVsQ0tBZzUzemJnWHoyS3E5SUwxWHQzNDFVOU9K?=
 =?utf-8?B?QkUzOXczSDR1S0NYS0hEMXZ1M0lFTlZmdWR3K29OYk5Ycjl5bCs0VTFaeS9X?=
 =?utf-8?B?bjErcy8rVGdvUHRGSnlrQTkveEwzekdmYmwySTFHQ2hycVUxa1kwOXJDK3d6?=
 =?utf-8?B?ek1jYUorbnVEQWRjY1RQQ0JWcW5pMXlSbzhYRnJsM2VtTjZZRS9nbk9qS0xF?=
 =?utf-8?B?UkN3VFJ0b0JNeTc3QnQ0OUh3Q2psd2xwbS9DN05wUnc0NitWS29ULzhGb0hY?=
 =?utf-8?B?cVFSWkRKTXdQSlFNZWpuZE1UWndOY01BcVllRzdSejdUZmRNTEtqRU9pbXNa?=
 =?utf-8?B?ajBmblBQOW9SaWdrRVdBci9jZi9UcUV4STZ1U0ZGRU1EYncvYVZITG1QZ2Vp?=
 =?utf-8?B?OUJJVU0rVis3QXVsR0tLY1lCZ2k5amJSUkFQVlVvVmRrS3p2YzlkMmdrZlhY?=
 =?utf-8?B?WVRXd1lNZ3VrUlRJOFJ4WmI3Z3psZDRHc0VvdTBIdG10N01jby95RjdzUHBJ?=
 =?utf-8?B?SWZsaGk3RTN1VTNKa1hwVUc5VVRVemFuRTlKTEdQME9GQS8yZ0FvYllDRWkv?=
 =?utf-8?B?VWs4NlFQU0RnMC9Jd3ZOYmdtZ1lFN05nTW9yeEExT3RPa3lMajB6WTFoTEdV?=
 =?utf-8?B?M3JNb3NIdEtKUEJ3dWtSdUdFbEFJQ29Panp2dDkzS011TDYwWndabUVneUdm?=
 =?utf-8?B?MmtpNmlXaVMwT05jSjAvM0lUWW1PVU5kU1VLeHN2b29RN0xiZXBqeFlobWJQ?=
 =?utf-8?B?K0phb2poSGJJTVpIOVN3TTFOb2lPZWx3eFVwWW51SDlFU01nZHpmdUJBK0xE?=
 =?utf-8?B?TTBCTm5YTG1BcjFocDZoYzJBOEtHQnpyb3VReEFZZ3FJb1VEMmE3K1NqdzBp?=
 =?utf-8?B?Z3NscVRoajNud2RtRUcxalVWYzlFNGdPTVFXL1lFcS9MTTlQbFF4NmdKUURE?=
 =?utf-8?B?alJhNzlQMWh2OTZZeVQvekdxRms4dVp1R2pGYktxdzgreHRMdW00M0dzaFA4?=
 =?utf-8?Q?l/rIfijE66LibM3E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A167DB36B1A7814BBEA30752210B6C6E@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR07MB4080.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2546a4e-d7de-4844-a18f-08da2f5b62bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2022 12:24:37.1002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t266KXNjG2skLzvIJGmbwwZg1W9IO2f5hafQUktW3VgzxPGfhVg2pieCkeAPL+IFlISPBm/5vv44f4KbLNzeg8n6xhdduVf1vubi7z/qrPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0701MB2841
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIhDQoNCk9uIDIwMjIuIDA1LiAwNi4gMTQ6MDEsIFZsYWRpbWlyIE9sdGVhbiB3
cm90ZToNCj4gSGkgRmVyZW5jLA0KPg0KPiBPbiBGcmksIE1heSAwNiwgMjAyMiBhdCAwNzo0OTo0
MEFNICswMDAwLCBGZXJlbmMgRmVqZXMgd3JvdGU6DQo+IFRoaXMgaXMgY29ycmVjdC4gSSBoYXZl
IGJlZW4gdGVzdGluZyBvbmx5IHdpdGggdGhlIG9mZmxvYWRlZCB0Yy1nYXRlDQo+IGFjdGlvbiBz
byBJIGRpZCBub3Qgbm90aWNlIHRoYXQgdGhlIHNvZnR3YXJlIGRvZXMgbm90IGFjdCB1cG9uIHRo
ZSBpcHYuDQo+IFlvdXIgcHJvcG9zYWwgc291bmRzIHN0cmFpZ2h0Zm9yd2FyZCBlbm91Z2guIENh
cmUgdG8gc2VuZCBhIGJ1ZyBmaXggcGF0Y2g/DQoNClVuZm9ydHVuYXRlbHkgSSBjYW50LCBvdXIg
Y29tcGFueSBwb2xpY3kgZG9lcyBub3QgYWxsb3cgZGlyZWN0IA0Kb3Blbi1zb3VyY2UgY29udHJp
YnV0aW9ucyA6LSgNCg0KSG93ZXZlciBJIHdvdWxkIGJlIG1vcmUgdGhhbiBoYXBweSBpZiB5b3Ug
Y2FuIGZpeCBpdC4NCg0KVGhhbmtzLA0KRmVyZW5jDQo=
