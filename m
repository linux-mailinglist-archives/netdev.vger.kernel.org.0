Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2526AEF8A
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjCGSYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbjCGSXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:23:47 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2079.outbound.protection.outlook.com [40.107.8.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08657360BB;
        Tue,  7 Mar 2023 10:19:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cK/kAIgJBfadtf8WC6mI1hd/OTmK0n+MJC3yAbTUL4+abKioO5bVefgXZ2+Q1LOB0XsEMI2LFM9R3s4oaDhoqNsxf1Bp24VUZIudz57P8tCbQrzPkaMsMOCkfTpkcYoxsbma0Tz5JeKKK8HtRILaTqaH4nsrcK3djVTMcUi8TBABQiy1O5iTYoGlsUCk3LdSJsAWN47gYI6Jow2ayUFl9R8XJ6ILeLSRRGvMr8Q0gMqwYJwlGnU6TGaxKhnDsbsnS/LpHKkmNmIKq8e6dA+tKekApkgaJUAmjgVb5xDUXKwnXCU4F4jv+FzVdUins8z1hdflXBG7QE8u6BYsmwsDrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NH1pEiiATjFTFyDl6uFrpLZAbu5ZR8OIwSx3nPFU1k4=;
 b=EZteO5dtH+4uaNt1tretu8A6ZEYU3RRkI01xviIHezDLXpCziBw6cz0dEUK2Vj8DgZPbg2hsn4wWfEBKewTgaDxDEweL49tZSw/w41MwRNTqgiM923qGxT3fSmVP/wpG5yhnSsqsQGp0TEL2Z9aoIey7SMKkoEkqE6ncBZtm6M8rWuhvjyxxKR/UdvkgR4cGXrqkjpDHCHVGESPkOUQ8lm0mW1hT0jHdUtFPheiRdW4X8fR5P6Rpo67hACeycMQ3jDONg24tqz2HAz0A47e01OXikJvnGb7rIWHIRkokkcutXtGOMpH8sOq/WbT8bebi55qsUhNGHC/tIssR+DSScA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NH1pEiiATjFTFyDl6uFrpLZAbu5ZR8OIwSx3nPFU1k4=;
 b=gO73r4LgPIUuoL0Ygp4bPhTAXQYVLkXxN9/nRKwOwt/5eYHgeoPKeAsjgY3QDF4cr78bhIUrpegswUbBO2Io7jtgR05X66tPJNhcQ6xNPWj3DK/XmJT7HcmDNg8aE592neVzWd/GZmLdKOL7sST4Ys2Ujt6T8o/1wui1VFu7kHHw+ee/nObDlqZDcgoMiZ495dQBkpbvmRsRCqcN1bsQL1POv6KE6dYVB7bDP/1RRMxSqbIDJhafVphCQycPEofhchuCfw/QV21btY1+kWEhVT8hrpOgK3sYSS9s9uWB3GRQcQcrHBed3x9jm+3gadXqoDodRZxPv+snS15UXu4ifA==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by AM9PR08MB6018.eurprd08.prod.outlook.com (2603:10a6:20b:2df::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 18:19:06 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80%6]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 18:19:06 +0000
From:   Ken Sloat <ken.s@variscite.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>
CC:     "noname.nuno@gmail.com" <noname.nuno@gmail.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ken Sloat <ken.s@variscite.com>
Subject: RE: [PATCH v2 2/2] dt-bindings: net: adin: Document bindings for fast
 link down disable
Thread-Topic: [PATCH v2 2/2] dt-bindings: net: adin: Document bindings for
 fast link down disable
Thread-Index: AQHZS6WmxBanjkfcjUqlkph1yg+i+q7nM2SAgAh2gYA=
Date:   Tue, 7 Mar 2023 18:19:06 +0000
Message-ID: <DU0PR08MB9003C9BD97B4055BE1EEDB0CECB79@DU0PR08MB9003.eurprd08.prod.outlook.com>
References: <20230228144056.2246114-1-ken.s@variscite.com>
 <20230228184956.2309584-1-ken.s@variscite.com>
 <20230228184956.2309584-2-ken.s@variscite.com>
 <9a540967-c1a6-b9df-a662-b8a729d7d64b@kernel.org>
In-Reply-To: <9a540967-c1a6-b9df-a662-b8a729d7d64b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR08MB9003:EE_|AM9PR08MB6018:EE_
x-ms-office365-filtering-correlation-id: a631aa5b-5706-49e7-3699-08db1f387017
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 232kYN+0x5PZkKlE+9X0PSN9lDaGafKkv8IdTfvy8MLaS6JcSYOhAA9HeSbG1BvxzrSkcpt2Cwx2FY7m0CbdPC/uW3s8MYlR5811r1Dp9IL/i/uCFdOXzA63QuU0SCk2aHXxIn63jmiZrylYUQmWNEl6G7yoQ9gqGRjzRfLmRmr3c90rqnPfZgDp9vW63aTzIZT0M2wxQKC89Tcet/bH7VIWk2mkYl4+mgyQ2msChcDVGOTeGBSwTIOUIRT9JJeheODpIkHLcRC7YH7MAXo1XmM40KynHXOnujbJnpyhZPQKJphlFwNtPfveE/tRh7LPKsFEPlh3tKzery9DXoQHk2UhEsTxbgZVNIL1i1qlPQ6k1gxqyeOKajSNxyLbZk5tonGqlL5TCHi73EOl/xVZyIJt9pR5sDIP40BqrkZ1fiiRIEFDx/KZggJCzuainCQgBJ4u7Fd1bNngZBrqliLxYbt0+784+VhAuexqumGCWXCF2IXOSr4HSgGzEehw4YUr47/6X5BxBzDyTJrDv1Lj8moR9RCQCe9tdLJuN6/7CsvxpNJNWIlstaUkk7dUQ8CeDykcfJ3e5DOwO6nXrGOvjU4bhDKYuEfAX3RDotPP9kqDkXS+2i5I7NCbfuygLK+7FNgVuUymHkbZvRZfv+EDu1f6hv2K3hQDDlGbLD2mXcWtau90x05wq5/aU8t+5n7bw8RUs9ch6CsPgD/e8VZ51Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(39840400004)(136003)(346002)(366004)(451199018)(6506007)(53546011)(107886003)(83380400001)(38070700005)(33656002)(86362001)(122000001)(186003)(38100700002)(9686003)(26005)(41300700001)(55016003)(66946007)(66556008)(66476007)(66446008)(6916009)(8676002)(4326008)(2906002)(64756008)(52536014)(7416002)(5660300002)(54906003)(8936002)(76116006)(7696005)(478600001)(71200400001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjJQZ1I5R1RBVjVRTVlPeElnL3F2aVQ2bklsNndZMHcvclA1eVF6MWV2MWlL?=
 =?utf-8?B?ZDVCUkdGeTh4RmVkVlUwTHRPV0hYc2crM2ZQZm5wemhDaXFpU0pvNDN6Wm8r?=
 =?utf-8?B?a0JOL2JRSUpWcVNsbUJ2Nm15N0ZXVkhRL0JabWZkSkVZaUNrWnZrRDhIdFVN?=
 =?utf-8?B?cTNRT2ZmTDUxSndzT3k4citRVVByOFByUjJvSy9JdEQ3cjhVeGtYaHNtTlVn?=
 =?utf-8?B?OHl5Tk5oL2pBY3RhSDhObXhXNmpDRW4yTGxDdDU0Yk1saGJxQ1JaY3JKSy9k?=
 =?utf-8?B?R0loejhUYThCMHlBbG93ZCtwSm0wRXp1QUhDRjhGUDVkU21iSlRhZUpOcFlR?=
 =?utf-8?B?Nk1KcGwxYXhyTlR2M21Xd3RpdTF0WGxZYUc3YUo1RHdDb1ZpT2JHQWsreHJ2?=
 =?utf-8?B?WUIzZnBZbkxpTmw1UHB4WTM1bkJuKzBHYUUxRFZlSUxxUnQyUGRiOTlvSEVC?=
 =?utf-8?B?ck01SCttVDk0S0c4NE5CcFRtcisvUEp2RFdEZW1FZm8zWFY2NElGc3I4NEtX?=
 =?utf-8?B?dWNTR2VTaFdnbER3emoxamhJck9rNE1aK292ZU5SVEFZckpEMHAzRVo2ZTkv?=
 =?utf-8?B?emFXSVRLZGtsRUxzd3cvTE45RGV4VWQ3N010T0J2NXV2aDY1aWd3V0wrUkZJ?=
 =?utf-8?B?MDVXRjBLdVdTMmNEZE5WNkx6K2VkV2FOeDN5ekNPeFE1VlMwSjVUM1dyKzZ6?=
 =?utf-8?B?cGpocTRCVWVUa2hMdlJjL3pJMkdXTGQvaElKSytYZ0dPWjVEZVRHRlExV2xH?=
 =?utf-8?B?VmVLdWxYbktucnRlMUpPMFZjZHFJMUVGM1Vyblc2U0NZNHovOXhrMEd0ZWhZ?=
 =?utf-8?B?RFRqYlpDZ0FaUzQ1M1lqNk1WTXdPalI4MGFJZk1NaXJZNDRMU2VaU21GRHVY?=
 =?utf-8?B?b3pwcml5Y2NGZmU5YlBBNStWNmt5NEEyWjFnTURLUGgzdGdWQUwzVTFmakxt?=
 =?utf-8?B?ZUg4d2FNUzdFSmhhMlFEai9hYmh3dkNvd0pKbTN4UElOWUlCV2N3Qng2bTlL?=
 =?utf-8?B?Q2pQaFVsZmJwMFdlaTVvYkRIdTk2eXhXemsxem40bGs5UkNnb1pNTUdaZDEx?=
 =?utf-8?B?cU1adk1Rc1RtV1VEQ0o5S1YxaUJScFptaUJzbDNSVHFpa0lwajYybUhtQ3Zi?=
 =?utf-8?B?em05MU8rTGk1V2FxTENuY1kyVEY1VHkyZEYxWmxhK01jMEMrdWJzUklLcWVk?=
 =?utf-8?B?azFMRGVsK0g0ZDdlTDEzemNYWUpkRlk2RVZ2aERPT3JSY3dlY25VdWRvNjd5?=
 =?utf-8?B?N0pRY1AzdHJFWWpVbFJRT2ZwdldDUzYwT2hqSHgrcW1ZT3lZUko5b2t4N2ZG?=
 =?utf-8?B?T2NNYnlXdTJad2lhL3RDaFJuT281WEpLbXJydFhjRk5lU011VE1rdU9VOHZO?=
 =?utf-8?B?RUUwQXlvNndiTFh0UDNjT2wyTzhRMnBMUnB5bFk2MU5BQ0ZtMDNMditnTkR2?=
 =?utf-8?B?R3NqK2lsOGFOWVdUUzlOazVic2dnUUxhSHdjNGdOdUV1SjJadzYzS1BFWU8r?=
 =?utf-8?B?eWtiQmtmeGNhSk9RMHh5M0hGeEFjZ29sY0RSVDBtRk1iOEdTOGlvZjd4YmMy?=
 =?utf-8?B?TGltNDZsQVh2L3Q4UzcxUHNVTWdmaTRDYWxOalU4VVlMVGpwRXJMZkYzamJT?=
 =?utf-8?B?ck5hbDdESUxTcm9HcTZQdWJLVGxkZ09MYW9nU29HRFBsY1N4WW4zaDdOaHd6?=
 =?utf-8?B?SE5DWTBnSjFJMXZaSUN6dTlTeVdvMnRnQUx0bS9WTFV5a2t2UFNPVmxmQ2M3?=
 =?utf-8?B?V2VWZEhTQXJ4c1RMTXJ2b0xhV2VTckV0MUdDeTBadTBnZEFoWVZWbjVYVlBG?=
 =?utf-8?B?Q05DMXkxbGJvSUxmV0pHeHduMmE2SUpFc2pyTmlEL3FiRXk0ckpqSkVJWUpF?=
 =?utf-8?B?Z201S3pCb2VTZk45d3VrdjE3RFVHTUNJT2RGQUdJWllOVDV0K2c0akFYczFE?=
 =?utf-8?B?Zlc1K1NLYUd6WVlKUlBSemFEcmlWRStjWGgvWW5hVUQ4Rk1GSjlHbE42Mm8w?=
 =?utf-8?B?cTF2cmtrS2h3K2UwbjIvblZjQk5PV2lCTVh5TDVRNXZXY21zN2lwYjdlNGRX?=
 =?utf-8?B?bzluTnc4a1oxR3VzaU4zTmtXWjZjVFBTSUdrWjRYclAwb0k2MCtwQlRwdkdo?=
 =?utf-8?Q?SGsJ6tV8yIFWL6mUAbv3MCOf1?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a631aa5b-5706-49e7-3699-08db1f387017
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2023 18:19:06.2100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RmoQp1E4+h3CwWOVjvc93mTENZ1kn+klfwR1nDxz5SM7yWSaPugcFWHq6pVycB60t+/TVX8Uxcb9SCMiT9B5TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6018
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgS3J6eXN6dG9mLA0KDQpUaGFua3MgZm9yIHlvdXIgcmVwbHkgYW5kIHNvcnJ5IGZvciB0aGUg
bGF0ZSByZXNwb25zZS4NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBL
cnp5c3p0b2YgS296bG93c2tpIDxrcnprQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IFRodXJzZGF5LCBN
YXJjaCAyLCAyMDIzIDI6MDAgQU0NCj4gVG86IEtlbiBTbG9hdCA8a2VuLnNAdmFyaXNjaXRlLmNv
bT4NCj4gQ2M6IG5vbmFtZS5udW5vQGdtYWlsLmNvbTsgcGFiZW5pQHJlZGhhdC5jb207DQo+IGVk
dW1hemV0QGdvb2dsZS5jb207IE1pY2hhZWwgSGVubmVyaWNoDQo+IDxtaWNoYWVsLmhlbm5lcmlj
aEBhbmFsb2cuY29tPjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsNCj4g
SmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IFJvYiBIZXJyaW5nIDxyb2JoK2R0QGtl
cm5lbC5vcmc+Ow0KPiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBIZWluZXIgS2FsbHdl
aXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPjsNCj4gUnVzc2VsbCBLaW5nIDxsaW51eEBhcm1saW51
eC5vcmcudWs+OyBBbGV4YW5kcnUgVGFjaGljaQ0KPiA8YWxleGFuZHJ1LnRhY2hpY2lAYW5hbG9n
LmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGRldmljZXRyZWVAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
djIgMi8yXSBkdC1iaW5kaW5nczogbmV0OiBhZGluOiBEb2N1bWVudCBiaW5kaW5ncyBmb3INCj4g
ZmFzdCBsaW5rIGRvd24gZGlzYWJsZQ0KPiANCj4gT24gMjgvMDIvMjAyMyAxOTo0OSwgS2VuIFNs
b2F0IHdyb3RlOg0KPiA+IFRoZSBBREkgUEhZIGNvbnRhaW5zIGEgZmVhdHVyZSBjb21tb25seSBr
bm93biBhcyAiRmFzdCBMaW5rIERvd24iIGFuZA0KPiA+IGNhbGxlZCAiRW5oYW5jZWQgTGluayBE
ZXRlY3Rpb24iIGJ5IEFESS4gVGhpcyBmZWF0dXJlIGlzIGVuYWJsZWQgYnkNCj4gPiBkZWZhdWx0
IGFuZCBwcm92aWRlcyBlYXJsaWVyIGRldGVjdGlvbiBvZiBsaW5rIGxvc3MgaW4gY2VydGFpbg0K
PiA+IHNpdHVhdGlvbnMuDQo+ID4NCj4gDQo+IFBsZWFzZSB1c2Ugc2NyaXB0cy9nZXRfbWFpbnRh
aW5lcnMucGwgdG8gZ2V0IGEgbGlzdCBvZiBuZWNlc3NhcnkgcGVvcGxlIGFuZA0KPiBsaXN0cyB0
byBDQy4gIEl0IG1pZ2h0IGhhcHBlbiwgdGhhdCBjb21tYW5kIHdoZW4gcnVuIG9uIGFuIG9sZGVy
IGtlcm5lbCwNCj4gZ2l2ZXMgeW91IG91dGRhdGVkIGVudHJpZXMuICBUaGVyZWZvcmUgcGxlYXNl
IGJlIHN1cmUgeW91IGJhc2UgeW91ciBwYXRjaGVzDQo+IG9uIHJlY2VudCBMaW51eCBrZXJuZWwu
DQo+IA0KDQpVbmRlcnN0b29kDQoNCj4gPiBEb2N1bWVudCB0aGUgbmV3IG9wdGlvbmFsIGZsYWdz
ICJhZGksZGlzYWJsZS1mYXN0LWRvd24tMTAwMGJhc2UtdCIgYW5kDQo+ID4gImFkaSxkaXNhYmxl
LWZhc3QtZG93bi0xMDBiYXNlLXR4IiB3aGljaCBkaXNhYmxlIHRoZSAiRmFzdCBMaW5rIERvd24i
DQo+ID4gZmVhdHVyZSBpbiB0aGUgQURJIFBIWS4NCj4gDQo+IFlvdSBkaWQgbm90IGV4cGxhaW4g
d2h5IGRvIHlvdSBuZWVkIGl0Lg0KDQpNeSB0aG91Z2h0cyB3ZXJlIHRoaXMgd2FzIGV4cGxhaW5l
ZCBpbiB0aGUgZmVhdHVyZSBwYXRjaCBhbmQgc28gd2FzIHJlZHVuZGFudCBoZXJlIHdoaWNoIGlz
IHdoeSBJIGdhdmUgYSBicmllZiBzdW1tYXJ5LCBidXQgaWYgdGhlIG5vcm0gaXMgdG8gZHVwbGlj
YXRlIHRoaXMgaW5mb3JtYXRpb24gSSBjYW4gY2VydGFpbmx5IGRvIHRoYXQuDQoNCj4gDQo+ID4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBLZW4gU2xvYXQgPGtlbi5zQHZhcmlzY2l0ZS5jb20+DQo+ID4g
LS0tDQo+IA0KPiBEb24ndCBhdHRhY2ggeW91ciBuZXcgcGF0Y2hzZXRzIHRvIHlvdXIgb2xkIHRo
cmVhZHMuIEl0IGJ1cmllcyB0aGVtIGRlZXAgYW5kDQo+IG1ha2UgdXNhZ2Ugb2Ygb3VyIHRvb2xz
IGRpZmZpY3VsdC4NCj4gDQpJIGFkZGVkIHRoZSBpbi1yZXBseS10byBpZCBpbiBnaXQgc2VuZC1l
bWFpbCBhcyBJIHRob3VnaHQgdGhpcyB3YXMgdGhlIG5vcm0gYnV0IEkgd2lsbCBub3QgZG8gdGhp
cyBpbiB0aGUgZnV0dXJlLCBzb3JyeS4NCg0KPiANCj4gPiAgRG9jdW1lbnRhdGlvbi9kZXZpY2V0
cmVlL2JpbmRpbmdzL25ldC9hZGksYWRpbi55YW1sIHwgMTIgKysrKysrKysrKysrDQo+ID4gIDEg
ZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvRG9j
dW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9hZGksYWRpbi55YW1sDQo+ID4gYi9E
b2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2FkaSxhZGluLnlhbWwNCj4gPiBp
bmRleCA2NGVjMWVjNzFjY2QuLjkyM2JhZmYyNmMzZSAxMDA2NDQNCj4gPiAtLS0gYS9Eb2N1bWVu
dGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2FkaSxhZGluLnlhbWwNCj4gPiArKysgYi9E
b2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2FkaSxhZGluLnlhbWwNCj4gPiBA
QCAtNTIsNiArNTIsMTggQEAgcHJvcGVydGllczoNCj4gPiAgICAgIGRlc2NyaXB0aW9uOiBFbmFi
bGUgMjVNSHogcmVmZXJlbmNlIGNsb2NrIG91dHB1dCBvbiBDTEsyNV9SRUYgcGluLg0KPiA+ICAg
ICAgdHlwZTogYm9vbGVhbg0KPiA+DQo+ID4gKyAgYWRpLGRpc2FibGUtZmFzdC1kb3duLTEwMDBi
YXNlLXQ6DQo+ID4gKyAgICAkcmVmOiAvc2NoZW1hcy90eXBlcy55YW1sI2RlZmluaXRpb25zL2Zs
YWcNCj4gPiArICAgIGRlc2NyaXB0aW9uOiB8DQo+ID4gKyAgICAgIElmIHNldCwgZGlzYWJsZXMg
YW55IEFESSBmYXN0IGxpbmsgZG93biAoIkVuaGFuY2VkIExpbmsgRGV0ZWN0aW9uIikNCj4gPiAr
ICAgICAgZnVuY3Rpb24gYml0cyBmb3IgMTAwMGJhc2UtdCBpbnRlcmZhY2VzLg0KPiANCj4gQW5k
IHdoeSBkaXNhYmxpbmcgaXQgcGVyIGJvYXJkIHNob3VsZCBiZSBhIHByb3BlcnR5IG9mIERUPw0K
PiANClRoYXQgc2VlbWVkIGxpa2UgYSBsb2dpY2FsIHBsYWNlIHRvIGFsbG93IG92ZXJyaWRlIG9u
IGJvYXJkcyB3aGVyZSBpdCBpcyB1bmRlc2lyZWQuIFdvdWxkIHlvdSBzYXkgdGhhdCBwcm9wZXJ0
aWVzIHN1Y2ggYXMgdGhpcyBzaG91bGQgaW5zdGVhZCBiZSBjdXN0b20gUEhZIHR1bmFibGVzLCB3
aGljaCBtYXkgcmVxdWlyZSBwYXRjaGluZyBvZiBldGh0b29sIGFzIHdlbGw/DQoNCj4gQmVzdCBy
ZWdhcmRzLA0KPiBLcnp5c3p0b2YNCg0KU2luY2VyZWx5LA0KS2VuIFNsb2F0DQoNCg==
