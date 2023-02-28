Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85A36A5B86
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 16:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjB1PSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 10:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjB1PSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 10:18:12 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2075.outbound.protection.outlook.com [40.107.247.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0973165AF;
        Tue, 28 Feb 2023 07:18:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ypbr+E/rmX8DilGy9WO4TH9+f6DCY5BZpKNkaOyfBu9wNE1Bz/C9q1SmHJ9nuFGgtyjZt8+2ui/ShDGxGszDr01dA1vmgoJ2exgODjYEXNm58on9Bly2nUgnCPxslgYGKu8hfdcwAfLBq7yAUBjVKSwcvIjiaQTOK4OBnPooHH8W36AT0b9pDuOXU+drQ4B2wu/NZLouNiq3Y11RtNt21wIs1o+EBnT5+FFx/DCPKT/O+BlIhcPo0TdrS4y9fHa4fe04dyVwS3++1ABRGTJxgpv6f570eZnvkpKFmdpozkR2mIToXBGy6ZerNEf4BnEfqUGMG0ZyU6KHsmUSKHfrlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBQMytuu09UStbzafgZ2HKv5F92FI6XViBhht1pKcqg=;
 b=UUqBjocZx/UCgzPsM1a3OZYUqTOlpG1GLxjY9nLSR/1YBmwNk6DLnSB1PdQdlJI18uFgnIq3wUm9f/suoQZ8Llljr+xX7yfOSrhN6p/ess+B38RwHYfcZOIcNUHsf9WamOjvR1pg9vzPOARDPnySKv4hrbfdx4QMgk2VhqgyVUL/4Z9E2IJg2pM9LF/BZs818ybZ2L9Y73Y7bdrcs7GF3JAx54MvSivvS0BifuFmwA+bJ8i5ayHqyUNU+yOwkGcPyG3Db0WmC0hshVXB0QbaOxL0S5zUpGbbXXS5ovtTmePrK9DQy6tRq8WMgfKjjh6bW5zLmGhO0YDV7jqnra+TEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBQMytuu09UStbzafgZ2HKv5F92FI6XViBhht1pKcqg=;
 b=g8UaaYvE+Wups/ZGhFRx1HeJe8zCoZlq10hUIpZPRXIlWAnXV9fIXQhqHxropee9+NeXdgGT8OSOXQeBy94H7yHdLAJgyM2a5k+w4PV9xU1FCU87Zol8uD9j8XxA/OyLIOWzgNaDSVHeNg7nMsTgNJ+V5L/LNIoZ1D2vnrupupX/X+mnTT9Lz76I7Y7Dor7/cSP32l0OpwqGKIGQykZQUW5aswSwhg9pq5nLmXSChyrEVXFQNrG42B/YQsnnqDe781CJKYjW2KJajtabi5M5ZUfw3fJzywl3iXp18Uz78/gv8Kr0CNQ2axWlzCB5zpZVLK6yl5m9fq6PrSLVrsA7Ew==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by DBBPR08MB5897.eurprd08.prod.outlook.com (2603:10a6:10:203::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 15:18:04 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80%7]) with mapi id 15.20.6134.025; Tue, 28 Feb 2023
 15:18:04 +0000
From:   Ken Sloat <ken.s@variscite.com>
To:     =?utf-8?B?TnVubyBTw6E=?= <noname.nuno@gmail.com>
CC:     Michael Hennerich <michael.hennerich@analog.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ken Sloat <ken.s@variscite.com>
Subject: RE: [PATCH v1] net: phy: adin: Add flags to disable enhanced link
 detection
Thread-Topic: [PATCH v1] net: phy: adin: Add flags to disable enhanced link
 detection
Thread-Index: AQHZS4L7Pv2IgKC+70qPmaRcnFBcv67kdloAgAABY5A=
Date:   Tue, 28 Feb 2023 15:18:03 +0000
Message-ID: <DU0PR08MB9003B45053D06C6B6805EF7BECAC9@DU0PR08MB9003.eurprd08.prod.outlook.com>
References: <20230228144056.2246114-1-ken.s@variscite.com>
 <f5920799e6b0b6b5321ca38eb3b28024dc1be81f.camel@gmail.com>
In-Reply-To: <f5920799e6b0b6b5321ca38eb3b28024dc1be81f.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR08MB9003:EE_|DBBPR08MB5897:EE_
x-ms-office365-filtering-correlation-id: fdf35f7b-6c63-4beb-afce-08db199efcca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k8GjXe2Tky+S/P+g6U3zXZDrzPH0UbxcNBDJOv1QCFLbcGeigLh8AxwU3SCFjC4CIPie5+4cgi3/hP9xRos7twCNZLcXE6I30PJh6A7R2arHS7qK5/y4I2G8wWaSt1gAnGiKRUAovbebLId+sJYrIb+8yH0O3S3/YJJ02rPko8pzrDnnGhWeGbnUZKwRLarsqxOaU+ntg8RPuLOmg+Np3BtJFioAgEAzhYDZhW5RIxHMgtsgy7gultP2PuExOesFs7Im8ZKXgBydTyZpHPk67I7lLFgLCkX4Rjs81LElHoacJnfrARRzr6dAIZTFjW7dDpdHamHjg4gaY4JCc2ifVAtv1Bg+V1YsdKS4Cwkwnq5K5yCGj2Hldp8/7cYpWWb803fKs4IeNY589sNDGjCctjHL2qTJJ7mD8umMpsScuMJ/545Bs/IqotpLS/Ql+T4a/baUhkHUYhiESlkjU5tSB/rdvR903pTyOfWSrktuXEyeMifztvuFkyxRcWhDvpBjkEAnG7BTDlIcl2o1kCbBz+L4mU/WOoXPNOEC23Ao2DJiVAYGSOp8dqo+W6phOKw2esKDLP/nG+M3kVHJQGOlAzLI8Rm13icpUQDXG1oUz0QIoAeR+BXcX6x3Iv21N9Gx4y1fCpyBw6LpZ5BiZI+fLim1Qfyq05ZCGrjUjOrZs9E9H0rlhFlZcCd6ahOO4CZ6TflZ0dLwYTRcLL+Og8rh0Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(39840400004)(136003)(366004)(346002)(451199018)(33656002)(83380400001)(53546011)(6506007)(107886003)(26005)(7696005)(41300700001)(9686003)(71200400001)(186003)(52536014)(66946007)(86362001)(2906002)(4326008)(64756008)(66556008)(8676002)(66476007)(76116006)(6916009)(66446008)(8936002)(5660300002)(38100700002)(55016003)(478600001)(122000001)(38070700005)(316002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1JmVnF5L0tLUDJVR1BEQmhlYzNyTWRJV0dMWnFtTWN2dUNxcnlZUm54My9k?=
 =?utf-8?B?VmQwbzdTWkYrWGZpS2o5WTVwcUVUWjFQdHo2cjQ4QmRRVlpQVzd5NXhiSzU0?=
 =?utf-8?B?U2hDN1hrL29EWEtIanhnZDFSczZVUS83SjNYaEx2aXMrZDlWWGl0SURab2hm?=
 =?utf-8?B?dzFVMUlWRVpIOVkxTERuTVpLcmYxbUhHSWc2MEZEbG1naWpmckFvU3EwdG5z?=
 =?utf-8?B?Y3IweXAxci92aThxZTZKSWE0cWpzbUtncnNJNTl0V09LNDVaQXAvd2NUcVM3?=
 =?utf-8?B?WlpoQ0NQVlI0eUdrUElGUWJCS0wvVHVqZlExallIN2lTTlBscmhFbUIwKzho?=
 =?utf-8?B?d2JVWXZZKzNrZlY2MVVIQ2ZqcEZlQ2s3dGdBTDFTTjgyZS9NeWdwZ0REQmgz?=
 =?utf-8?B?OFEzazg0Zkx1bDhJaGhkZGRqTmtYYk1Lbk96dnlrUy9Iamp4MU5Oa2drR0Nr?=
 =?utf-8?B?Wnl5akJyTU5MQThQdS9XUzdyUStYQlNuM2VkK0JmN28xRmhWWlBpR09yQ0lt?=
 =?utf-8?B?WDBIbkZ5dzdqbld4SlJPdEJwMWM5ZHlmbEJ0K04vaXJEcStBVGRCQzk2am9B?=
 =?utf-8?B?T3lBUDhTVU85RkJrYmhzWU1Bc0J6TExDeUpNK3VuY0J1YTlVMDQ3NWs4TnU5?=
 =?utf-8?B?NkZhaDlSN3pHS0FPSnh2ZGxnUklsaUg0Qm8wYUxZT2o4eTFGS3FUUDFldlMr?=
 =?utf-8?B?L0FMam5DKzAwaFc1VHJOUmdwME9YL1hXMWY0ZDFhTFJRSWp1VXk5THBDajlT?=
 =?utf-8?B?RmxIWFdGSGdjN2p0b1dNMDlBT1lGdUJoL3VkdEN6L0FnMFR5NUZzbW13RGxI?=
 =?utf-8?B?MGtSenpraUtSM3lmemE4Q0hnaFN1VHdlYXJjZC96WHBQTDgrTnZEdW1jZk05?=
 =?utf-8?B?L1hCY0pLTFNzWkIrYmtVMHFVTUM1ZnRkZDZkaWZPYkwzbGpFUGc5V0JPNlZr?=
 =?utf-8?B?QTNuMUMySEdSL2xJSGYvS29OUnk1SVdYSStvbHJjSHQ5WEFndkJsMmdnQjVH?=
 =?utf-8?B?cEtyK2tYaFMrMGRGOGJ3cVJlZ3RZNFJlYUZxanFxWFJ1dzE5d05qdnFYTjRM?=
 =?utf-8?B?VjJmdUVKK3JrMG05SUM4WHViWlFUMzlrNit6YWZNWWQ3Tm5PdTJFKzloU2NR?=
 =?utf-8?B?UG5YNmxsZUpyeWRsVXNnYW1LcVFvK0MvVWZDTGh5b3BqUTVaaXRxS0UxcGN0?=
 =?utf-8?B?RUJMdkJNMS9ZdlZMQnJoRGdjcUw0Z2NZNDUzODB1eDE0aVk0aDNBRTFuZG1T?=
 =?utf-8?B?VHFieWhFUlhVRzFua1oyT3NwMEIyZUNVeVBlY1ZSRXpzUUNpUEl2SzcvalJn?=
 =?utf-8?B?NG1RRzMzemVIQm1Nb1FVZEIwVWtsY2JCVUIxV1dreFlLcTBUUHoyMlVGU1BW?=
 =?utf-8?B?RFBOZ084YThiTmFHZThORU1YNXc5dUpyRk9LdlJqVlF3aHNod3BZOWpDVm9Y?=
 =?utf-8?B?bk5HYzdDeVRZUjBsc09haitVU1RNbkI5UC9QTjNWSHYrOWVCWm9mMk9sejBw?=
 =?utf-8?B?bFpsN1Jxd3RGZU91MXAwZGYzMjRRQjMzOTI4Qmtqc29IU09lMURsTERWZ05F?=
 =?utf-8?B?MlpKMWl3TXlwcVBab2Z3akY0WUVyUHlIRDBTR3Z6NkMrYnhjWVM5MFdiRjht?=
 =?utf-8?B?TnVUZ0xzVlNRakVuK2dLOE1vaHFQNUZxTm5yQU1kVWozVXplbEdmQllyVzdV?=
 =?utf-8?B?VkRjd0NJYnd4TGtVUHFDZi9TeVNmWjg5a3FpSG9Wci9jVENYelQ2TW9QSGRp?=
 =?utf-8?B?SzVOQVZMWW51K0JqT3g5azA2WGt1RzdSd2lYSU9jVkY1YVpIV1pZU2c1b3Vs?=
 =?utf-8?B?YW9lL1pwVm1qTVFOSmg4NWRvRXJQUEJMREZRUlF5OXhsdFpRYkh1SFhpYUp3?=
 =?utf-8?B?RjB0R0FNOEV0MXBDZTF3SG5HOUl2eXNEdE9RYlYxWks2VHpJRTBCREwxWjRU?=
 =?utf-8?B?REd4S3dFMzJpS1V1Zi9KZnpWUHgrbEZQMUIrcUtNcXBYUWpFRUx2RWJDL1NV?=
 =?utf-8?B?NXFpUzdkN0JmNHdLR2JQUE95RnFmb2hGU0ZSNHk1MWNqcFRRVHJndFFoUkgw?=
 =?utf-8?B?WU04OXVXOEE5T0IxZ2NjQ1N5dmdhUmdZMDlYU2NITGxwK0x2SzJXU2JGWXdV?=
 =?utf-8?Q?Gzlv6QNNIY6vubfNSJBOGD/nr?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdf35f7b-6c63-4beb-afce-08db199efcca
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 15:18:03.9569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xjrhNVXPVj0DXoV4fGylbta8UU/9x7nPyJCpOf4/jdgjwksSw7ad38BzziaM3uFgUl3IeSROJtmVHZ+I8stieA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB5897
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTnVubywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBOdW5vIFPD
oSA8bm9uYW1lLm51bm9AZ21haWwuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBGZWJydWFyeSAyOCwg
MjAyMyAxMDoxMCBBTQ0KPiBUbzogS2VuIFNsb2F0IDxrZW4uc0B2YXJpc2NpdGUuY29tPg0KPiBD
YzogTWljaGFlbCBIZW5uZXJpY2ggPG1pY2hhZWwuaGVubmVyaWNoQGFuYWxvZy5jb20+OyBBbmRy
ZXcgTHVubg0KPiA8YW5kcmV3QGx1bm4uY2g+OyBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFA
Z21haWwuY29tPjsgUnVzc2VsbCBLaW5nDQo+IDxsaW51eEBhcm1saW51eC5vcmcudWs+OyBEYXZp
ZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1Yg0KPiBLaWNpbnNraSA8a3Vi
YUBrZXJuZWwub3JnPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MV0gbmV0OiBwaHk6IGFkaW46
IEFkZCBmbGFncyB0byBkaXNhYmxlIGVuaGFuY2VkIGxpbmsNCj4gZGV0ZWN0aW9uDQo+IA0KPiBI
aSwNCj4gDQo+IFRoYW5rcyBmb3IgdGhlIHBhdGNoISBTb21lIGNvbW1lbnRzIGZyb20gbXkgc2lk
ZS4uLg0KPiANCj4gT24gVHVlLCAyMDIzLTAyLTI4IGF0IDA5OjQwIC0wNTAwLCBLZW4gU2xvYXQg
d3JvdGU6DQo+ID4gRW5oYW5jZWQgbGluayBkZXRlY3Rpb24gaXMgYW4gQURJIFBIWSBmZWF0dXJl
IHRoYXQgYWxsb3dzIGZvciBlYXJsaWVyDQo+ID4gZGV0ZWN0aW9uIG9mIGxpbmsgZG93biBpZiBj
ZXJ0YWluIHNpZ25hbCBjb25kaXRpb25zIGFyZSBtZXQuIFRoaXMNCj4gPiBmZWF0dXJlIGlzIGZv
ciB0aGUgbW9zdCBwYXJ0IGVuYWJsZWQgYnkgZGVmYXVsdCBvbiB0aGUgUEhZLiBUaGlzIGlzDQo+
ID4gbm90IHN1aXRhYmxlIGZvciBhbGwgYXBwbGljYXRpb25zIGFuZCBicmVha3MgdGhlIElFRUUg
c3RhbmRhcmQgYXMNCj4gPiBleHBsYWluZWQgaW4gdGhlIEFESSBkYXRhc2hlZXQuDQo+ID4NCj4g
PiBUbyBmaXggdGhpcywgYWRkIG92ZXJyaWRlIGZsYWdzIHRvIGRpc2FibGUgZW5oYW5jZWQgbGlu
ayBkZXRlY3Rpb24gZm9yDQo+ID4gMTAwMEJBU0UtVCBhbmQgMTAwQkFTRS1UWCByZXNwZWN0aXZl
bHkgYnkgY2xlYXJpbmcgYW55IHJlbGF0ZWQgZmVhdHVyZQ0KPiA+IGVuYWJsZSBiaXRzLg0KPiA+
DQo+ID4gVGhpcyBuZXcgZmVhdHVyZSB3YXMgdGVzdGVkIG9uIGFuIEFESU4xMzAwIGJ1dCBhY2Nv
cmRpbmcgdG8gdGhlDQo+ID4gZGF0YXNoZWV0IGFwcGxpZXMgZXF1YWxseSBmb3IgMTAwQkFTRS1U
WCBvbiB0aGUgQURJTjEyMDAuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBLZW4gU2xvYXQgPGtl
bi5zQHZhcmlzY2l0ZS5jb20+DQo+ID4gLS0tDQo+ID4gwqBkcml2ZXJzL25ldC9waHkvYWRpbi5j
IHwgMzgNCj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiDCoDEg
ZmlsZSBjaGFuZ2VkLCAzOCBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvcGh5L2FkaW4uYyBiL2RyaXZlcnMvbmV0L3BoeS9hZGluLmMgaW5kZXgNCj4gPiBk
YTY1MjE1ZDE5YmIuLjg4MDlmM2UwMzZhNCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9w
aHkvYWRpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvcGh5L2FkaW4uYw0KPiA+IEBAIC02OSw2
ICs2OSwxNSBAQA0KPiA+IMKgI2RlZmluZSBBRElOMTMwMF9FRUVfQ0FQX1JFR8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgMHg4MDAwDQo+ID4gwqAjZGVmaW5lIEFESU4xMzAw
X0VFRV9BRFZfUkVHwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAweDgwMDEN
Cj4gPiDCoCNkZWZpbmUgQURJTjEzMDBfRUVFX0xQQUJMRV9SRUfCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAweDgwMDINCj4gPiArI2RlZmluZSBBRElOMTMw
MF9GTERfRU5fUkVHwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAweDhFMjcgI2RlZmluZQ0KPiA+ICtBRElOMTMwMF9GTERfUENTX0VSUl8xMDBf
RU7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBCSVQoNykgI2RlZmluZQ0KPiA+
ICtBRElOMTMwMF9GTERfUENTX0VSUl8xMDAwX0VOwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoEJJVCg2KSAjZGVmaW5lDQo+ID4gK0FESU4xMzAwX0ZMRF9TTENSX09VVF9TVFVDS18x
MDBfRU7CoMKgwqBCSVQoNSkgI2RlZmluZQ0KPiA+ICtBRElOMTMwMF9GTERfU0xDUl9PVVRfU1RV
Q0tfMTAwMF9FTsKgwqBCSVQoNCkgI2RlZmluZQ0KPiA+ICtBRElOMTMwMF9GTERfU0xDUl9JTl9a
REVUXzEwMF9FTsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgQklUKDMpICNkZWZpbmUNCj4gPiAr
QURJTjEzMDBfRkxEX1NMQ1JfSU5fWkRFVF8xMDAwX0VOwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
QklUKDIpICNkZWZpbmUNCj4gPiArQURJTjEzMDBfRkxEX1NMQ1JfSU5fSU5WTERfMTAwX0VOwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgQklUKDEpICNkZWZpbmUNCj4gPiArQURJTjEzMDBfRkxEX1NM
Q1JfSU5fSU5WTERfMTAwMF9FTsKgwqDCoEJJVCgwKQ0KPiA+IMKgI2RlZmluZSBBRElOMTMwMF9D
TE9DS19TVE9QX1JFR8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoDB4OTQwMA0KPiA+IMKgI2RlZmluZSBBRElOMTMwMF9MUElfV0FLRV9FUlJfQ05UX1JFR8Kg
wqDCoMKgwqDCoMKgwqDCoMKgMHhhMDAwDQo+ID4NCj4gPiBAQCAtNTA4LDYgKzUxNywzMSBAQCBz
dGF0aWMgaW50IGFkaW5fY29uZmlnX2Nsa19vdXQoc3RydWN0IHBoeV9kZXZpY2UNCj4gPiAqcGh5
ZGV2KQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgQURJTjEzMDBfR0VfQ0xLX0NGR19NQVNLLCBzZWwpOw0KPiA+IMKgfQ0KPiA+
DQo+ID4gK3N0YXRpYyBpbnQgYWRpbl9jb25maWdfZmxkX2VuKHN0cnVjdCBwaHlfZGV2aWNlICpw
aHlkZXYpIHsNCj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgZGV2aWNlICpkZXYgPSAmcGh5ZGV2
LT5tZGlvLmRldjsNCj4gPiArwqDCoMKgwqDCoMKgwqBpbnQgcmVnOw0KPiA+ICsNCj4gPiArwqDC
oMKgwqDCoMKgwqByZWcgPSBwaHlfcmVhZF9tbWQocGh5ZGV2LCBNRElPX01NRF9WRU5EMSwNCj4g
PiBBRElOMTMwMF9GTERfRU5fUkVHKTsNCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAocmVnIDwgMCkN
Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHJlZzsNCj4gPiArDQo+
ID4gK8KgwqDCoMKgwqDCoMKgaWYgKGRldmljZV9wcm9wZXJ0eV9yZWFkX2Jvb2woZGV2LCAiYWRp
LGRpc2FibGUtZmxkLTEwMDBiYXNlLQ0KPiA+IHQiKSkNCj4gDQo+ICJhZGksZGlzYWJsZS1mbGQt
MTAwMGJhc2UtdHgiPw0KPiANCk5vIHRoYXQgd2FzIHB1cnBvc2VmdWwsIGl0J3MganVzdCAiVCIg
dGhpcyBQSFkgc3VwcG9ydHMgIjEwMDBCQVNFLVQiIGFuZCAiMTAwQkFTRS1UWCINCg0KPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZWcgJj0gfihBRElOMTMwMF9GTERfUENTX0VS
Ul8xMDAwX0VOIHwNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgQURJTjEzMDBfRkxEX1NMQ1JfT1VUX1NUVUNLXzEwMDBf
RU4NCj4gPiB8DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIEFESU4xMzAwX0ZMRF9TTENSX0lOX1pERVRfMTAwMF9FTiB8
DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIEFESU4xMzAwX0ZMRF9TTENSX0lOX0lOVkxEXzEwMDBfRU4pOw0KPiA+ICsN
Cj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoZGV2aWNlX3Byb3BlcnR5X3JlYWRfYm9vbChkZXYsICJh
ZGksZGlzYWJsZS1mbGQtMTAwYmFzZS0NCj4gPiB0eCIpKQ0KPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqByZWcgJj0gfihBRElOMTMwMF9GTERfUENTX0VSUl8xMDBfRU4gfA0KPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBBRElOMTMwMF9GTERfU0xDUl9PVVRfU1RVQ0tfMTAwX0VOIHwNCj4gPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
QURJTjEzMDBfRkxEX1NMQ1JfSU5fWkRFVF8xMDBfRU4gfA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBBRElOMTMwMF9G
TERfU0xDUl9JTl9JTlZMRF8xMDBfRU4pOw0KPiA+ICsNCj4gPiArwqDCoMKgwqDCoMKgwqByZXR1
cm4gcGh5X3dyaXRlX21tZChwaHlkZXYsIE1ESU9fTU1EX1ZFTkQxLA0KPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgQURJTjEzMDBfRkxE
X0VOX1JFRywgcmVnKTsNCj4gDQo+IG5pdDogWW91IGNvdWxkIHVzZSBwaHlfY2xlYXJfYml0c19t
bWQoKSB0byBzaW1wbGlmeSB0aGUgZnVuY3Rpb24gYSBiaXQuDQoNClRoYW5rcywgSSB3aWxsIGNo
ZWNrIG91dCB0aGF0IGZ1bmN0aW9uIGZvciB2Mi4NCg0KPiANCj4gDQo+IFlvdSBhbHNvIG5lZWQg
dG8gYWRkIHRoZXNlIG5ldyBwcm9wZXJ0aWVzIHRvOg0KPiANCj4gRG9jdW1lbnRhdGlvbi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL25ldC9hZGksYWRpbi55YW1sDQo+IA0KSSB3aWxsIHN1Ym1pdCB0aGUg
cGF0Y2ggSSBoYXZlIGZvciB0aGlzIGFzIHdlbGwgb24gdjIuDQoNCj4gDQo+IC0gTnVubyBTw6EN
Cg0KVGhhbmtzIQ0KDQpTaW5jZXJlbHksDQpLZW4gU2xvYXQNCg0K
