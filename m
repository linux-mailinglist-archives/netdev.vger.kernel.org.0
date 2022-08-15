Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3980B592CD2
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiHOIvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 04:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiHOIvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 04:51:37 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60080.outbound.protection.outlook.com [40.107.6.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22AC9205FD;
        Mon, 15 Aug 2022 01:51:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Edp+/eAZnGQvFtP2PrPJKk4H1rQYPBpjHIQBLucqjSOaQiLQqxjzLwnqI1L1S8a+cB4nhqENw+C4xPffm6Rds9gAXBYKiuzN+MQIwkWRS13z7X+fOqv+7L0ei1NK0y5Xq1hExCt0hIwa8unG8p+UTijhE7R7Zfwco5K5eE8ScqpzKVkWCw3QIH/IvOs0rE6sZuPB61b4Fx/YcpNrfYOw+ioxg1ySv4bNs1Ur1HCym52L4eSfpRhn5oAcU5N1oHyyarOo+agDDY7y3nAGWeB/I7laR18ELq+pywObuZEiADO/wI2jynIjATKAF6mhgAtnP2yYLVBDGh56sQ38A7P03Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbWNfxGUxzZz6e5hwADQsa3/kNrsqdjF0RNbBMWJmTU=;
 b=FdBd8XCKSJeGYdae0OMIyAS+/mVASvw9RnA0ZUjyncnZRtMy+BwSgJ4dV4S8+GaJIf7+lIqPKbBm7jDRXl5qy0jTREiP2hj+N0VK9UKx6yLuK6XJVooRaFkixN4AH2FEtNfhmznAr3NodvkDoR+JNTIopWh7q5Q2FzxUMNlQlILRweV0DljSiiHrN8U8lT7HCDyl3HLG3RSRSC7+PUxI6Z2bmpqav6v5Wx+k5pT/6uHii0B9n2xtGDMLrHCbhw/DvWlTsz7n9DQo/9HyU0Ol2bAj7XjV3gXfNVjcm+QdUn/zCaQ6Zh0B+cuwVxFj8u1YDicqr3UR0eorcazxPwUIAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wbWNfxGUxzZz6e5hwADQsa3/kNrsqdjF0RNbBMWJmTU=;
 b=fErRr4MJ3TYbWfyO6aU4XS1fZAqvUTRnIJtykPE4JH+JhyEgBsJ6TSXKLMi1tImdQOqpDg/165r6J3fQEifJiN5EGYaDaKtv41M8nQYaTckZtcwPb+wIMVi3oWOubYm8cM4B3LMSVyKIyZxBHysroTZVHONBsCeM1cqZ0ie5864=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM6PR0402MB3320.eurprd04.prod.outlook.com (2603:10a6:209:5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Mon, 15 Aug
 2022 08:51:33 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Mon, 15 Aug 2022
 08:51:32 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/2] dt: ar803x: Document disable-hibernation property
Thread-Topic: [PATCH net 1/2] dt: ar803x: Document disable-hibernation
 property
Thread-Index: AQHYrhiZCawC+L8jOkCFO9wn08ratK2q3dcAgAAUXICAAC4fAIAEgI/g
Date:   Mon, 15 Aug 2022 08:51:32 +0000
Message-ID: <DB9PR04MB8106851412412A65DF0A6F5388689@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220812145009.1229094-1-wei.fang@nxp.com>
 <20220812145009.1229094-2-wei.fang@nxp.com>
 <0cd22a17-3171-b572-65fb-e9d3def60133@linaro.org>
 <DB9PR04MB81060AF4890DEA9E2378940288679@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <14cf568e-d7ee-886e-5122-69b2e58b8717@linaro.org>
In-Reply-To: <14cf568e-d7ee-886e-5122-69b2e58b8717@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 917d6955-53ba-4ad9-99eb-08da7e9b5a6d
x-ms-traffictypediagnostic: AM6PR0402MB3320:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fv1mpfH2H4PuxnmOq7sCw9Xv4AiqY9+B8POboAYLmw9YfBjfnvkt2uq2Gk2FzMJ+Ji6GNoBE95QLCBw/rY184ne2R+rq1mH7x/8B3HLpeVSPBwF35hQzOXc0ZKUAGSVun6hnf6VTp/CanBJxrhVEgwQE27QMiorpv8RnH2FDpiD490fayn144OwQyPt7zZFfCmKO3T9YjTHRuYMg0OI7xafr9hDReae1jwUEMHZapk5PKahUsJOHlbEk+h9a5aRiIPeJs7M9BkfCJXpAqUSnNVoWGEp+sxYw70P2jxE/FKJJHX+YLznEGqg+lCDzCupfTUgJgzOIyioC9FFfQwtqfIrh8F/KIWAC2Ttz2iij3h01Lqd1pcI4AQ06owq7iwpk15JoSTn02SviIILnmAyVkjN6u4UynSHpE1WO3uvvcNET984o9w2rxwn+Ih3iIv7NKYmPPB3sXfu3jTBNpuBEwcZesye9sIugYiiTqapCWmTYMERvmjhBPmCUXPhSBwxafcRMJbd3giMAgs4DPevHOQvzQnIGIkoP2drZjc6KySTbgH82Z+avaE0iEDQyFpJaHV9LY3Y9glvS/RGA2KHj0ehM0JTi+WJpwJg0e5xmWARscqNlySnDet5T47TyakqOv8aeiCWzhcysF1eTZi6ZhRUhIFFXZtRzAnTu6Fw7wvEEnvgf+oCAFugjTkh6vXBJxqsCqbRxf5qO+0DTrHFJZtMRCKeSIB1jvO4Zh5n2WTtlnaznL/Gh9SbOeMO1Rv1YuQl+ezqhcfPRrr06ZmRXAbvl6/8k3ab3RzImC2pQ5kvfBeFMDsEWPFXNytFTi36momEVHEslcxhl2zeQG5sorw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(7416002)(110136005)(2906002)(6506007)(7696005)(86362001)(53546011)(26005)(44832011)(9686003)(83380400001)(316002)(5660300002)(186003)(8676002)(478600001)(8936002)(71200400001)(33656002)(52536014)(122000001)(921005)(66556008)(41300700001)(66476007)(66446008)(64756008)(55016003)(38070700005)(66946007)(76116006)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXFWdzQ5bGExSG1hS1c1NmlZVXZ1dXRLRFJpdnNoQkRqaFhxZGxaRGpBckN3?=
 =?utf-8?B?aFlra0dhNnM3a0RpSmp4aE1RRHhBd3JPWGZKd1lrSjJ4STgvNWpsQXlsRVA0?=
 =?utf-8?B?R3FROStOdTdVWnZBVHkycTljempGVGw5OFp2QkNyOUZSUG9nNVlUWEpZNHl2?=
 =?utf-8?B?MkR1VVk1MmtHbTZKRHFmcWJacmNTdkMwY2RNeE1GRFI1WmRMVE9WZjRwNlJl?=
 =?utf-8?B?R2U2ZGlPdnZyb0tBWSsyUjRKQlVLVVR3dm8rcjIvZDEzanlTQ1BiM2pUdmJj?=
 =?utf-8?B?YzZjZE9wYVN6a3ZuVkdyTU1ueWtGbmVSTG9SbTVLQy8rQWxLT3U5Rnd4R2J3?=
 =?utf-8?B?MjVhaTNma3NteXFONFFIUjR0cXVuQ29NemRMVysvSGlQZFJlWGF6bkFVcVNk?=
 =?utf-8?B?S2RHY2VhZnZSSW9neGFnZHVnNVBheWpPdWtiSjNySTBRVnZQWFNsUEFyR3R1?=
 =?utf-8?B?UTNqYkd5Nlp3cHZMQ3FwT1QrOGVFaXZzYVBFUU9XZzBydFppUk4xMXkyaTFU?=
 =?utf-8?B?QUVzVC9kb1h1a0p5YllTNjJTVTQvUzBtbWQ5TEhhbjFUaUdibW5zazZEeVpW?=
 =?utf-8?B?T1MzRzBLdm5KZVpyRWVubE90ZHYySEVpNUxhRDVFNVRmczJKMmNHblpLN2Vh?=
 =?utf-8?B?b2NjSUYvZXdJenlwYzM5MHRuYkcwZ04xVHZldS85cHhxWm96Z2tiQUM1U0FK?=
 =?utf-8?B?Znh0L3pjT0JhN1hBUmQ2VGVVZWVkdkovZHFSYno4czBXcVJrekFQOWlNQW81?=
 =?utf-8?B?Skl0STlnTjV2eWYxMlYyTkFEMG5pdEVqY21jczJLQzVCbjhyRk9ndno3bTJK?=
 =?utf-8?B?VnVJamtDWk5XaUJ6MkFHU3dwSHJpV2pzWEdSSzZ4b0ZrWDF1UHBJVG5HQ1ho?=
 =?utf-8?B?VzRHaEJKU2FQOXJMaVI1Umd1SXk3VEZNcCtOODJjU0xhSDgrNlYyTnM4UDNG?=
 =?utf-8?B?SzQyWmFIcmQ2MktBdjVFQUM0aSs4bzZYTjBQMWdtRDhCcHlwVnNoclppTGpi?=
 =?utf-8?B?ZjVyaTEzY3R2QVp1TWdOMlFwajArZkR4OE5lUUh4Y1hEZDdwaTIzMjhUclR6?=
 =?utf-8?B?NVRRNjRWWHBLRENqUTNjbkxLS0VDa3VpSTVyYko1ckZHc3QwU204RHZxa1VM?=
 =?utf-8?B?TVVlYkUrQ29ic3RRVDc5ZUxIRzIxR0VoZm4rM25iV2FTNUVRTWpxZDhkNURs?=
 =?utf-8?B?ZEI5NkJSVXBNL3VhSldTR2FNamx2U3ArN3hScmNsdkhvaTZXdzUyV3RTQUU2?=
 =?utf-8?B?MmprMGkybTBqRFVOQ3RpWlN1bFcyby9oRzBIblhENG5yTGJlY0orekl1T2pk?=
 =?utf-8?B?M3ZtRm9Td05sUWdYa3FjR3hnUFhzY0FiZnorYm5kQWVHeHBTcXc0Ukh1eWMx?=
 =?utf-8?B?Wmh3RnlML1dQYnF3ZVJ6dDBnY3M3cFFHNkNMVXBRK2N1YmFhWXNGamRTSDZK?=
 =?utf-8?B?dWduNFBnUDRyS0N5cVRHWlVVVUp6aHFxc2UzcmJGMTNsNnp0dVpGQkg0KzRV?=
 =?utf-8?B?SnBYVTM3WjEyalBFLy8xQTBmSnJ3NllhNUVOWEhSeDE4QU1TbEs3UUdaMkpp?=
 =?utf-8?B?OElMUzFKUlg2VXJxbGR3MFhkL0hQZmxTb3NMWGlJbjc3NWtsSjJzTUtxdzVq?=
 =?utf-8?B?NFQwRlh1MVg0MG55RnFLTXQxNUZCWjBsV0xOalR0bTA0QmhXV2lzQnNkQWFy?=
 =?utf-8?B?TTJUMDY4d2toNVYzckZqQ0FOMlRaT0d1R3lVVHVZTnNvV1dIakk2V3VlWUVN?=
 =?utf-8?B?SzNYcHBKNGdZNWxGZkdoOHBiWjhBNzRPUndTUnI1bkZkeE54TGZFSmtDcEcy?=
 =?utf-8?B?SjdhTDNON3BBNVF3TTlHSVBJMlRTQ0JOMmp0R01sM1J4d3Y4VGs4WlhIUVEz?=
 =?utf-8?B?SG5HMUhMdHpNU0Z3Z25NUEFEaXlIVWVlNjZHQUVyaHhMU2wyVWpjSllOZmo5?=
 =?utf-8?B?WUJJeWRQbDM1UmdYUmg1cFRieUxTQW5BcWNzK3FrU0hsSWd4S21sNU5vWnRB?=
 =?utf-8?B?b09iZnNXdk9YU25GbE1CT1ZaNUdUUVJFb1BmdmtFQ0h2dlAybkh4RkFseDA2?=
 =?utf-8?B?dVYyMm0ycTYzSHMyR0sybytUYmwxdEhZK2gyUjh5T2sxVTlwMkhLd3BHNmdm?=
 =?utf-8?Q?58cE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 917d6955-53ba-4ad9-99eb-08da7e9b5a6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2022 08:51:32.8040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ky0dzQUXXTtsxWXLzEnwFIPKAS1DeMdiW6QPhui+HM8Wso0Z1vDQjR8Toev0H9259gKyRY0V8N5mGVN8l5onbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3320
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTZW50OiAyMDIy5bm0OOac
iDEy5pelIDE5OjI2DQo+IFRvOiBXZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT47IGFuZHJld0Bs
dW5uLmNoOyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsNCj4gbGludXhAYXJtbGludXgub3JnLnVrOyBk
YXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpldEBnb29nbGUuY29tOw0KPiBrdWJhQGtlcm5lbC5v
cmc7IHBhYmVuaUByZWRoYXQuY29tOyByb2JoK2R0QGtlcm5lbC5vcmc7DQo+IGtyenlzenRvZi5r
b3psb3dza2krZHRAbGluYXJvLm9yZzsgZi5mYWluZWxsaUBnbWFpbC5jb207DQo+IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0IDEvMl0gZHQ6IGFy
ODAzeDogRG9jdW1lbnQgZGlzYWJsZS1oaWJlcm5hdGlvbg0KPiBwcm9wZXJ0eQ0KPiANCj4gT24g
MTIvMDgvMjAyMiAxMjowMiwgV2VpIEZhbmcgd3JvdGU6DQo+ID4NCj4gPg0KPiA+PiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBLcnp5c3p0b2YgS296bG93c2tpIDxrcnp5
c3p0b2Yua296bG93c2tpQGxpbmFyby5vcmc+DQo+ID4+IFNlbnQ6IDIwMjLlubQ45pyIMTLml6Ug
MTU6MjgNCj4gPj4gVG86IFdlaSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPjsgYW5kcmV3QGx1bm4u
Y2g7DQo+ID4+IGhrYWxsd2VpdDFAZ21haWwuY29tOyBsaW51eEBhcm1saW51eC5vcmcudWs7IGRh
dmVtQGRhdmVtbG9mdC5uZXQ7DQo+ID4+IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVs
Lm9yZzsgcGFiZW5pQHJlZGhhdC5jb207DQo+ID4+IHJvYmgrZHRAa2VybmVsLm9yZzsga3J6eXN6
dG9mLmtvemxvd3NraStkdEBsaW5hcm8ub3JnOw0KPiA+PiBmLmZhaW5lbGxpQGdtYWlsLmNvbTsg
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gPj4gZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4gU3ViamVjdDogUmU6IFtQQVRDSCBu
ZXQgMS8yXSBkdDogYXI4MDN4OiBEb2N1bWVudCBkaXNhYmxlLWhpYmVybmF0aW9uDQo+ID4+IHBy
b3BlcnR5DQo+ID4+DQo+ID4+IE9uIDEyLzA4LzIwMjIgMTc6NTAsIHdlaS5mYW5nQG54cC5jb20g
d3JvdGU6DQo+ID4+PiBGcm9tOiBXZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gPj4+DQo+
ID4+DQo+ID4+IFBsZWFzZSB1c2Ugc3ViamVjdCBwcmVmaXggbWF0Y2hpbmcgc3Vic3lzdGVtLg0K
PiA+Pg0KPiA+IE9rLCBJJ2xsIGFkZCB0aGUgc3ViamVjdCBwcmVmaXguDQo+ID4NCj4gPj4+IFRo
ZSBoaWJlcm5hdGlvbiBtb2RlIG9mIEF0aGVyb3MgQVI4MDN4IFBIWXMgaXMgZGVmYXVsdCBlbmFi
bGVkLg0KPiA+Pj4gV2hlbiB0aGUgY2FibGUgaXMgdW5wbHVnZ2VkLCB0aGUgUEhZIHdpbGwgZW50
ZXIgaGliZXJuYXRpb24gbW9kZSBhbmQNCj4gPj4+IHRoZSBQSFkgY2xvY2sgZG9lcyBkb3duLiBG
b3Igc29tZSBNQUNzLCBpdCBuZWVkcyB0aGUgY2xvY2sgdG8NCj4gPj4+IHN1cHBvcnQgaXQncyBs
b2dpYy4gRm9yIGluc3RhbmNlLCBzdG1tYWMgbmVlZHMgdGhlIFBIWSBpbnB1dHMgY2xvY2sNCj4g
Pj4+IGlzIHByZXNlbnQgZm9yIHNvZnR3YXJlIHJlc2V0IGNvbXBsZXRpb24uIFRoZXJlZm9yZSwg
SXQgaXMNCj4gPj4+IHJlYXNvbmFibGUgdG8gYWRkIGEgRFQgcHJvcGVydHkgdG8gZGlzYWJsZSBo
aWJlcm5hdGlvbiBtb2RlLg0KPiA+Pj4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IFdlaSBGYW5nIDx3
ZWkuZmFuZ0BueHAuY29tPg0KPiA+Pj4gLS0tDQo+ID4+PiAgRG9jdW1lbnRhdGlvbi9kZXZpY2V0
cmVlL2JpbmRpbmdzL25ldC9xY2EsYXI4MDN4LnlhbWwgfCA2ICsrKysrKw0KPiA+Pj4gIDEgZmls
ZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKykNCj4gPj4+DQo+ID4+PiBkaWZmIC0tZ2l0IGEvRG9j
dW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9xY2EsYXI4MDN4LnlhbWwNCj4gPj4+
IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9xY2EsYXI4MDN4LnlhbWwN
Cj4gPj4+IGluZGV4IGIzZDQwMTNiN2NhNi4uZDA4NDMxZDc5YjgzIDEwMDY0NA0KPiA+Pj4gLS0t
IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9xY2EsYXI4MDN4LnlhbWwN
Cj4gPj4+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvcWNhLGFy
ODAzeC55YW1sDQo+ID4+PiBAQCAtNDAsNiArNDAsMTIgQEAgcHJvcGVydGllczoNCj4gPj4+ICAg
ICAgICBPbmx5IHN1cHBvcnRlZCBvbiB0aGUgQVI4MDMxLg0KPiA+Pj4gICAgICB0eXBlOiBib29s
ZWFuDQo+ID4+Pg0KPiA+Pj4gKyAgcWNhLGRpc2FibGUtaGliZXJuYXRpb246DQo+ID4+PiArICAg
IGRlc2NyaXB0aW9uOiB8DQo+ID4+PiArICAgIElmIHNldCwgdGhlIFBIWSB3aWxsIG5vdCBlbnRl
ciBoaWJlcm5hdGlvbiBtb2RlIHdoZW4gdGhlIGNhYmxlIGlzDQo+ID4+PiArICAgIHVucGx1Z2dl
ZC4NCj4gPj4NCj4gPj4gV3JvbmcgaW5kZW50YXRpb24uIERpZCB5b3UgdGVzdCB0aGUgYmluZGlu
Z3M/DQo+ID4+DQo+ID4gU29ycnksIEkganVzdCBjaGVja2VkIHRoZSBwYXRjaCBhbmQgZm9yZ290
IHRvIGNoZWNrIHRoZSBkdC1iaW5kaW5ncy4NCj4gPg0KPiA+PiBVbmZvcnR1bmF0ZWx5IHRoZSBw
cm9wZXJ0eSBkZXNjcmliZXMgZHJpdmVyIGJlaGF2aW9yIG5vdCBoYXJkd2FyZSwgc28NCj4gPj4g
aXQgaXMgbm90IHN1aXRhYmxlIGZvciBEVC4gSW5zdGVhZCBkZXNjcmliZSB0aGUgaGFyZHdhcmUN
Cj4gPj4gY2hhcmFjdGVyaXN0aWNzL2ZlYXR1cmVzL2J1Z3MvY29uc3RyYWludHMuIE5vdCBkcml2
ZXIgYmVoYXZpb3IuIEJvdGgNCj4gPj4gaW4gcHJvcGVydHkgbmFtZSBhbmQgcHJvcGVydHkgZGVz
Y3JpcHRpb24uDQo+ID4+DQo+ID4gVGhhbmtzIGZvciB5b3VyIHJldmlldyBhbmQgZmVlZGJhY2su
IEFjdHVhbGx5LCB0aGUgaGliZXJuYXRpb24gbW9kZSBpcyBhDQo+IGZlYXR1cmUgb2YgaGFyZHdh
cmUsIEkgd2lsbCBtb2RpZnkgdGhlIHByb3BlcnR5IG5hbWUgYW5kIGRlc2NyaXB0aW9uIHRvIGJl
DQo+IG1vcmUgaW4gbGluZSB3aXRoIHRoZSByZXF1aXJlbWVudHMgb2YgdGhlIERUIHByb3BlcnR5
Lg0KPiANCj4gaGliZXJuYXRpb24gaXMgYSBmZWF0dXJlLCBidXQgJ2Rpc2FibGUtaGliZXJuYXRp
b24nIGlzIG5vdC4gRFRTIGRlc2NyaWJlcyB0aGUNCj4gaGFyZHdhcmUsIG5vdCBwb2xpY3kgb3Ig
ZHJpdmVyIGJlamh2aW9yLiBXaHkgZGlzYWJsaW5nIGhpYmVybmF0aW9uIGlzIGEgcHJvcGVydHkN
Cj4gb2YgaGFyZHdhcmU/IEhvdyB5b3UgZGVzY3JpYmVkLCBpdCdzIG5vdCwgdGhlcmVmb3JlIGVp
dGhlciBwcm9wZXJ0eSBpcyBub3QgZm9yDQo+IERUIG9yIGl0IGhhcyB0byBiZSBwaHJhc2VkIGNv
cnJlY3RseSB0byBkZXNjcmliZSB0aGUgaGFyZHdhcmUuDQo+IA0KU29ycnksIEknbSBhIGxpdHRs
ZSBjb25mdXNlZC4gSGliZXJuYXRpb24gbW9kZSBpcyBhIGZlYXR1cmUgb2YgUEhZIGhhcmR3YXJl
LCB0aGUNCm1vZGUgZGVmYXVsdHMgdG8gYmUgZW5hYmxlZC4gV2UgY2FuIGNvbmZpZ3VyZSBpdCBl
bmFibGVkIG9yIG5vdCB0aHJvdWdoIHRoZQ0KcmVnaXN0ZXIgd2hpY2ggdGhlIFBIWSBwcm92aWRl
ZC4gTm93IHNvbWUgTUFDcyBuZWVkIHRoZSBQSFkgY2xvY2tzIGFsd2F5cw0Kb3V0cHV0IGEgdmFs
aWQgY2xvY2sgc28gdGhhdCBNQUNzIGNhbiBvcGVyYXRlIGNvcnJlY3RseS4gQW5kIEkgYWRkIHRo
ZSBwcm9wZXJ0eQ0KdG8gZGlzYWJsZSBoaWJlcm5hdGlvbiBtb2RlIHRvIGF2b2lkIHRoaXMgY2Fz
ZS4gQW5kIEkgbm90aWNlZCB0aGF0IHRoZXJlIGFyZSANCnNvbWUgc2ltaWxhciBwcm9wZXJ0aWVz
IGV4aXN0ZWQgaW4gdGhlIHFjYSxhcjgwM3gseWFtbCwgc3VjaCBhcw0KInFjYSxkaXNhYmxlLXNt
YXJ0ZWVlIiBhbmQgInFjYSxrZWVwLXBsbC1lbmFibGVkIi4gU28gd2h5IGNhbid0IEkgdXNlIHRo
ZQ0KInFjYSxkaXNhYmxlLWhpYmVybmF0aW9uIiBwcm9wZXJ0eT8gSG93IHNob3VsZCBJIGRvPyAN
Cg0KDQo+IEJlc3QgcmVnYXJkcywNCj4gS3J6eXN6dG9mDQo=
