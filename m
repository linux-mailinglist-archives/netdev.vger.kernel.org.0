Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC186E7AC0
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 15:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbjDSNae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 09:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbjDSNac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:30:32 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2124.outbound.protection.outlook.com [40.107.21.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18565589;
        Wed, 19 Apr 2023 06:30:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKVfdSbp2npjjHxutpu4mPODDLeQfLniV8rY1A2C53Ky3/SERRpBmdp+1BnFYvMubXKWHEuCED0uuq7H8s7rcFoH6ryTyCUBNvSxnkPN42tEWxXrYg37hJeM4w7+d8WGXCRG/pZJ0xdFLJ7cpobFveZGyiSL/ea4w9wwM3mg4V/BFJgQoGK9lL2KKPpwePaL1r5+6hCkn6zC5t22lfIphRy3sHdm9OOOD8i5IJ5nXp9caUYIYB7WF1y0Jes+NJ7pvCbbRj3wKthh8/rQM5JKI+nwyOpGK36OzWDD8VKzMEmwhCPg/dwEgn/zBZEU55gdmNWhdsp48uG9/FhW7JC9FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sd0tklg9Zs7ISEL7fy4Gs1GBBogg7IcsKpu09BHT9o8=;
 b=FRuTtSOP7BdJKVE5Xp6enrnQXc/DoOnSjh/buyWNd7UB9YRSlHKP3ra7xQRZneH9p6Y4XuFlWC2Sd+5z4zSWSpc2XbhIJ4j+iHaLMXCxv0DcAhEkdbwlLs5N9fyvwFYCrvdZ7PZv+4G/MdD3/5WwORISTNP02TXIRjNZIIFFzzx/K8gmuLWIuzJT2o1EfUe/Wo6SFscR7sbNIiSjMrmRTGMxhDpUJRGi0AlMdUgh0vC7AqZ3Okgjak7hqJBHzueC7AGdFMerNFfO02MJ415GoKymUb3CA9B3nFiWL+dg4nbYSB7MezXRjTsp/dXuFMJLNVD9x53L0C9ZyssW7cD8rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siklu.com; dmarc=pass action=none header.from=siklu.com;
 dkim=pass header.d=siklu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siklu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sd0tklg9Zs7ISEL7fy4Gs1GBBogg7IcsKpu09BHT9o8=;
 b=sGjS+Blvggol+SvKDf3F31L7LgxhMkwen+7XSVx37lNzHwfuqf7NlUlOaDDIiIHrzAfqXDDwxIdEwg/+pzQyP9gbeS2rXRhxMfTHSB03VyUWYpPJGxl7uJe4RaCky4GGGDUQdvbVK03r1GjU9KysGiYKS+3lxC6dRm8AySGe8IY=
Received: from VI1PR0102MB3117.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:5::17) by PA4PR01MB7503.eurprd01.prod.exchangelabs.com
 (2603:10a6:102:d2::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 13:30:18 +0000
Received: from VI1PR0102MB3117.eurprd01.prod.exchangelabs.com
 ([fe80::f14c:b1e2:dfe1:93a1]) by
 VI1PR0102MB3117.eurprd01.prod.exchangelabs.com
 ([fe80::f14c:b1e2:dfe1:93a1%2]) with mapi id 15.20.6319.020; Wed, 19 Apr 2023
 13:30:18 +0000
From:   Shmuel Hazan <shmuel.h@siklu.com>
To:     "mw@semihalf.com" <mw@semihalf.com>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: net: mvpp2: tai: add extts support
Thread-Topic: net: mvpp2: tai: add extts support
Thread-Index: AQHZcl08VbuZJYaZv0223WxSEd1JRa8yoWEA
Date:   Wed, 19 Apr 2023 13:30:18 +0000
Message-ID: <5e62fb37d7118b5b1de68d0d2d961a6408c0f299.camel@siklu.com>
References: <20230417160151.1617256-1-shmuel.h@siklu.com>
         <CAPv3WKey+AXGvXwYTWA5R4ZROB5v0afDZVXr4cbPwS7O_WFh+Q@mail.gmail.com>
In-Reply-To: <CAPv3WKey+AXGvXwYTWA5R4ZROB5v0afDZVXr4cbPwS7O_WFh+Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siklu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR0102MB3117:EE_|PA4PR01MB7503:EE_
x-ms-office365-filtering-correlation-id: 0f8efacf-5236-4723-0f9a-08db40da379f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NC5No6DO3W6m5wAG3sJZcPeDQLw6Gjj7bFJXAJDbcJjXska+mLwO8LESpmF7JeXJzgcilWZfnlW9UOyAnxKdt2IparPDtFH2TjLnun7SMN0AvqRVkVZIxxhO2v+Z583jXqvkVpY562YrhrGCgmimq5jnTunGjoCRCZCGTM3zqDmVy3o5JGyxoO6GYjAp3ww0pwJ+u8j2qdTc45EkB6C/bilOq9SO518oIcFUEAQpYO75AvtCSolDbza2oPHtpqGobbP/g0dN++2hI77totdW4J7ArKFkZgmA5OXKzyqIrVml062lyeFdX0u8KAdAw6qDAMjHRKT8pn7+KYepuPJmZUCSAgiPKy99ThiKMKKkWW/UQqck69Y4je2JlZc0anzj4HV40l4h2hDJHOcivQOQZ5CiSP/4cvZaFqxL5PNMRisFMUHyWlY0jK2dR17wmHY354BXwH2NfGgDYz//Ji5D7mdkpF3PCdZPw1cF/N+Ivm8ftYQu++6YS7wqYjtrQaruzrvChDTbbZ39Claa1ug7F/goW/yFcsWf3nxaii9s6Py4RnA9H2KKh11FQlBV/kBXJBYK1t+CxDSluo8kflgJddRToicYQWljuWUbjkxUSiy4OwOCeebQsRKRTUZtaw0/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0102MB3117.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(136003)(396003)(39850400004)(451199021)(5660300002)(7416002)(8676002)(8936002)(41300700001)(76116006)(316002)(4326008)(66446008)(66946007)(66556008)(66476007)(64756008)(6916009)(2906002)(91956017)(54906003)(86362001)(478600001)(6486002)(38070700005)(6506007)(186003)(38100700002)(122000001)(6512007)(71200400001)(83380400001)(2616005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RDBMQ010WEF5UFk4M0dzbmh1cDRQR1FKZWowbDB6b1VBSTZONW9ZTVdWNGVH?=
 =?utf-8?B?cWJBZ2RrUVZZUU9TYzZINHBnT213RUV2VDYvR24rZnkxamNDaERqSTVLL0pB?=
 =?utf-8?B?dGplUWp2TmdNMzhVc1p6N2lTeTc0TDNHSWFMYWp3R2NLTGZOdm05UURKZjB4?=
 =?utf-8?B?dXZNaExyK2h6N05aVDhDbllGWmkrQW9NRUt4SFE5TVpQalo5MWJ2ZWROK2tu?=
 =?utf-8?B?UTM1NjdFKzBlcHdBT2pSSUNOczFubEluT250ZzZ5OEVuaE14WXFIQ2Z3cGJt?=
 =?utf-8?B?SUc2Wkt4UWZWNHlydHUxQWFVSVAvak5tcTdQckh3SjB1VU1CZzBqaUpXWkZY?=
 =?utf-8?B?c2d6S2w4QmNYcCtUTXFmclp5ckVRZmxBR0wzVW1jMnJ3QU1TT3VBaWh4MDR0?=
 =?utf-8?B?YklNcUwxS0x6ZEw3dUlBNU55UGwweC9PUGRBQVRkUktjeXltODZNU25IUnI4?=
 =?utf-8?B?N0JTS3kyL2k5NUZnMnBOWHYxTzBKMGVIdnp6QmtpSlJsdHhkQWZvUUNrWlM1?=
 =?utf-8?B?UjZVSmdJbWRkWVNPcUpZTjQ4aHJjTzdKSStRS1hOZ2s2YTBTOWxpcGdUNkw5?=
 =?utf-8?B?TE9aUDJvdWxBNXJjYUdSaDlqTlBLNVRVWXp2QXZqZXVKR1NQbjAxUnAvWStT?=
 =?utf-8?B?ZHI2QU44TGhENkhYZkpveFVaRGIzZlZZbXlETHMyTmhseitJZDlHRXArQUg1?=
 =?utf-8?B?WkdoakpPYXJHbFgwUzdYOXZnYmRhNjluUnlmL3R5eHJYN1M0M1ZLNmRFWnl0?=
 =?utf-8?B?YXRHdllOYmhJb05HWW0ySldwanJNcHVSVFp4NEdaZXV2V0lSdWtkNDMwUG11?=
 =?utf-8?B?bWhTOUZQR24vb1kwb1BRK2U0QzZ5VS9sMm1yNFJKelM1Wi9TYlJTZ0p1UDBK?=
 =?utf-8?B?U3U4OWlWSmVYZ0s2QVArWjIrWTBjZ25tMVRDNjJnL0pkbXhGTVJCZVFwWUdw?=
 =?utf-8?B?dzhwUWdhTVoxYWhzNlhuSmc5a3hrdmRFenAzblVTZ2IwaDRTeElrSk1YZmh1?=
 =?utf-8?B?blR6eHR3aHNLL2RqdkZhSmNuYlU4L25SUU9tTHZsUHFOdFVxNWczMnEvRWhE?=
 =?utf-8?B?YlhxWG9tbG5HNHZjb0lZUCtDV3F0YzZOcXduWU9ieDZZVHcrQ2NLTGJDS1Np?=
 =?utf-8?B?ZnI1eDVlS2hnQldSL1V6MUJCZ2xlbHlYQjJERlNVTG1heGkyZkxOaTNxNi9Y?=
 =?utf-8?B?L0ZzbEM1bUk0SFJOMERHN3NuLzE0ajYzQkNoK1ZnS1Y3b20wZ3VaZFdFdzIx?=
 =?utf-8?B?c3dtOWM5VGs2SURiQVZGYmx6Kzc2SStiMEpPMXRXNW9ua0c1dEYvUVdKdTdP?=
 =?utf-8?B?STRpRGdkL0VWQ3N3NWxSL1lsZFd3dFJ2cjJWVHVnQzBuSkdRVUx3cHVuVkh1?=
 =?utf-8?B?SWhMdmc1WjBDdm1RdUtQY21zQy82R05manZqT3F5UmNHdGQ3K2RuZG1pbWR4?=
 =?utf-8?B?SDVRL0d3dWZLS0R4QmNDUGZLelRxbm8vbWxmY0pRays5V0c1ZGE4OU82OGQr?=
 =?utf-8?B?RVdrY1pyZHVEK3djUDRJRjRRUExmNE1STjJyazYrdXRzdVhTUlA1NlVJbnBV?=
 =?utf-8?B?eU9iKzFKc2YvdWx4WU5jVlgxcWxFMjhZYjhXc1FGVXkvUktFWmNPQTlpeTNh?=
 =?utf-8?B?RXdPMk1VUHNLdnMzM3d6bVAwZ05xYTc1NmdQM0s0WWcvamYzYU1RZmJhcHFr?=
 =?utf-8?B?UlBKanpSQXZFTDZxWE5lRnlhVEgxWXROalRwNFFZQnBMMDJ6VzgrVkxjSEo3?=
 =?utf-8?B?c05VRkdkdlUxdE5SQW9PRk1wdUhFS2JqKzN1L1NvKzNrbUdJendMNUJ4ZGls?=
 =?utf-8?B?eHlwekdtanVMZXRWMkFYWlpTWVZOeUxZUklVSWkrRWRzZ25QbXJucEJzT3o4?=
 =?utf-8?B?MVVHTHh6M3dXQk82VnBjaHVDUmM3ZlJveGJ4bVdQKzRZUHpmYys2NnNjcUJj?=
 =?utf-8?B?LzNjOUFuNWh0UHR1UmJBM0pmYzZFTlkxUm5Od0pqUFZXdzArTjBnbkdSb0Jk?=
 =?utf-8?B?aHEwK1NmalIyYTdwMHZLWVB4Q0s4VzJCZFljTGZRTU1GNVdvZStXa1RTWmYr?=
 =?utf-8?B?M2R5OEQzMFNSMkc0cnlMa2QxbjB6NTB1ZHlQQnNIMXphUis2RWFRdXYzWk40?=
 =?utf-8?B?NjhHNFRRc1VXNzl5TFpydG5wQ1lEcUNKcDA2b0R5YWhNZmVJQThjcmNvQTBa?=
 =?utf-8?B?QTEzYjgzcFEzWW96ampMYkk3VEF6ZVZCQWtaa1FoUS9xbEZPZmQ1V2xrb2xo?=
 =?utf-8?B?K0R4aWl1MlF3bTNPWXJpcUw5ODVnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8002C157CEE9E42AAB337B508F7808D@eurprd01.prod.exchangelabs.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siklu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0102MB3117.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f8efacf-5236-4723-0f9a-08db40da379f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2023 13:30:18.3172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5841c751-3c9b-43ec-9fa0-b99dbfc9c988
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UGQiDQDqHW6SeT0ItRrta+Jcnneee/PlnHLE/8P9swTwg9xp7RcoMMn8cI54SuhtljOfB3zfcth0QC8YTQoIfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR01MB7503
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIzLTA0LTE5IGF0IDAzOjIwICswMjAwLCBNYXJjaW4gV29qdGFzIHdyb3RlOg0K
PiBDYXV0aW9uOiBUaGlzIGlzIGFuIGV4dGVybmFsIGVtYWlsLiBQbGVhc2UgdGFrZSBjYXJlIHdo
ZW4gY2xpY2tpbmcgbGlua3Mgb3Igb3BlbmluZyBhdHRhY2htZW50cy4NCj4gDQo+IA0KPiBIaSBT
aG11ZWwsDQo+IA0KPiBwb24uLCAxNyBrd2kgMjAyMyBvIDE4OjAzIFNobXVlbCBIYXphbiA8c2ht
dWVsLmhAc2lrbHUuY29tPiBuYXBpc2HFgihhKToNCj4gPiANCj4gPiBUaGlzIHBhdGNoIHNlcmll
cyBhZGRzIHN1cHBvcnQgZm9yIFBUUCBldmVudCBjYXB0dXJlIG9uIHRoZSBBcmFtZGENCj4gPiA4
MHgwLzcweDAuIFRoaXMgZmVhdHVyZSBpcyBtYWlubHkgdXNlZCBieSB0b29scyBsaW51eCB0czJw
aGMoMykgaW4gb3JkZXINCj4gPiB0byBzeW5jaHJvbml6ZSBhIHRpbWVzdGFtcGluZyB1bml0IChs
aWtlIHRoZSBtdnBwMidzIFRBSSkgYW5kIGEgc3lzdGVtDQo+ID4gRFBMTCBvbiB0aGUgc2FtZSBQ
Q0IuDQo+ID4gDQo+ID4gVGhlIHBhdGNoIHNlcmllcyBpbmNsdWRlcyAzIHBhdGNoZXM6IHRoZSBz
ZWNvbmQgb25lIGltcGxlbWVudHMgdGhlDQo+ID4gYWN0dWFsIGV4dHRzIGZ1bmN0aW9uLg0KPiA+
IA0KPiA+IA0KPiANCj4gVGhhbmsgeW91IGZvciB0aGUgcGF0Y2hlcy4gRm9yIHYzLCBjb3VsZCB5
b3UgcGxlYXNlIGdlbmVyYXRlIGEgY292ZXINCj4gbGV0dGVyIGFuZCBwcm9wZXJseSBudW1iZXIg
YWxsIHRoZSBwYXRjaGVzPyBQbGVhc2UgYWxzbyBsaXN0IHRoZQ0KPiBjaGFuZ2VzIGJldHdlZW4g
dGhlIHJldmlzaW9ucy4NCg0KDQpIaSBNYXJjaW4sIA0KDQpObyBwcm9ibGVtLiBUaGFua3MuIA0K
DQo+IA0KPiBXaGF0IHNldHVwL3Rvb2xpbmcgaXMgcmVxdWlyZWQgdG8gdmVyaWZ5IHRoZSBjaGFu
Z2VzPw0KDQpJbiB0byB0ZXN0IGl0LCB5b3UnbGwgbmVlZCBhbiBBcm1hZGEgODB4MC83MHgwLWJh
c2VkIFBDQiwgd2l0aCBhIFBQUw0KaW5wdXQgdGhhdCBnb2VzIHRvIGEgUFRQX1BVTFNFIHBpbiBh
bmQgYSBHUElPIHBpbi4gVGhlbiwgZGVmaW5lIHRoZQ0KZ3BpbyBwaW4gYXMgYSBwcHMtZ3BpbyBh
bmQgcnVuIHRzNHBoYyAoZnJvbSBsaW51eHB0cCkgYXMgZm9sbG93Og0KDQp0czJwaGMgLXMgL2Rl
di9wcHNYIC1jIC9kZXYvcHRwWQ0KDQpSZXBsYWNlIFggd2l0aCB0aGUgcmVsZXZhbnQgcHBzIGRl
dmljZSBJRCwgYW5kIFkgd2l0aCB0aGUgcHRwIGRldmljZQ0KdGhhdCBQVFBfUFVMU0UgaXMgY29u
bmVjdGVkIHRvIChDUDAgb3IgQ1AxKS4gDQoNCklmIGFueXRoaW5nIGdvZXMgd2VsbCwgeW91IHNo
b3VsZCBzZWUgdGhhdCB0czJwaGMgZ2V0cyB0byBhYm91dCB+MC0xDQpucyBvZiBvZmZzZXQgYmV0
d2VlbiB0aGUgY2xvY2tzLg0KDQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IE1hcmNpbg0KDQo=
