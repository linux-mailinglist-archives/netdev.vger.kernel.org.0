Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2377A67BA1B
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235923AbjAYTDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjAYTDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:03:19 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2131.outbound.protection.outlook.com [40.107.22.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049E52D70;
        Wed, 25 Jan 2023 11:03:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Luz2jqt/a/ggMOVB1gfPzEZUCZFFig1IiivxTXfjYqaiFjVinzIK00B7N/xni7i3zS6mUx0cbXa/MvioD4kC9oD/bACh+/ds3RNMziEU9TlY0HVnlXbE1OPwALc7vrtbppRGtmJOghfAo0FKAOZjXJGOB4VmRQe+ASGh9RJp01BJUheJGCNm95ssx/zNoN9B6Quib5arTu9JegLXpo5lUjpSHo2nfJDn4exT2m9eZ/oi5w007oYDGMb91huEqBZ6tXWxcgqHJYaqkuq/A7kmzDc5DyxCfAgFs7/NH+5ilpnaL75EIWhdMF/BJXU2CrrjcP0Lbv1UPHikNbbUU4ljUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPmrSWWIgRuFl3+xT2y894n+geVq/B0peW3W9znEFbg=;
 b=UdDSg6zNP9paFyJQgAswjTnCdnRAAOBFxlefxf+n1bFlYTzCydRr0HsokG0WyD+7H6jhHOmobwWkR+UPHbZbfYef9KxqdhCWgu1IAQ+fWQeNOJLaCLehJiBymtMHUfY+E1BhA2admF6Y8Bl0d2IPslvXGGMHc77mGojSPLUFurJdoIMt18yukUYp1hqoEuQP/vL4GoaG9QAw6uujFcjF5Dp4R0fgBV9GomM7xBZyEpCvOd+odjBsnPWSRiib65tZSEWYlmO8Ut9IJi1SAqn1VmH9CTkjMe5uz3G7K7x1+mgx0XbDXV+q7lK1HvOsxCKQJ/p9QICEaRg6ghG9xqaIkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPmrSWWIgRuFl3+xT2y894n+geVq/B0peW3W9znEFbg=;
 b=cv71Ptt7aXGg7ErrrR3KUomnTKxEuqNFD+blyOd7MPnfw6kvd4I5LeByz/n5/3xDSIeAVVeS/bEgGdC03Co3MtCFKrzLaQvf9ZFXhleq2+OnR/U0TlZgR8dNSaPmzoGRZaJIJf3eP8v991nQwbtkG/xr86jz1xDD5jM9Bqlngc8=
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by PAWP189MB2526.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:35e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 19:03:15 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%9]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 19:03:15 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: RE: [PATCH net 0/4] Netfilter fixes for net: manual merge
Thread-Topic: [PATCH net 0/4] Netfilter fixes for net: manual merge
Thread-Index: AQHZMJ1cTZVn5C9fnUe5jXTL+VxjU66vfUhg
Date:   Wed, 25 Jan 2023 19:03:14 +0000
Message-ID: <DBBP189MB14335036A7D41945AEF5043B95CE9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
References: <20230124183933.4752-1-pablo@netfilter.org>
 <d36076f3-6add-a442-6d4b-ead9f7ffff86@tessares.net>
In-Reply-To: <d36076f3-6add-a442-6d4b-ead9f7ffff86@tessares.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DBBP189MB1433:EE_|PAWP189MB2526:EE_
x-ms-office365-filtering-correlation-id: 75f1968b-31df-4661-3c31-08daff06cff7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 43x/NtMK+8Yk6bMO+3XBENCUBxXSOlcEc6XRriR81nbvC9C/ePYKrAhGu3eisO22bn4j6EolhTIhjcs795/iL5C22FUfkR0EMk7znincUratcVgCXqQIqlPM4xZOg7mCBopBSIm5C4Tx4BJMH/v6RknTp0OJA5pVu+xjhCrft/cWhKCJKtrduim3pIvaqdxMvAurnG2ywT8em5l55y0unB83ER7ty9btbTstxnsOvzX8eOLxkim2K4HYYi0zSsZEINmjJbWQ2gCWiUECTzXNNeBYP3bjg70538dpC8IDRzg/WG9jIlt4Hic324CU9oSqhUWRQLJrrHbj3ThycoIGRy2QZh5dDn7/DXxP9C/rMfuLjvWQ7WyzFYxPKbRvsrsX+MuZMl3eqiyGM6CgC/pfjxLiXERBSYgv7EmHy/rWIeatrxfZnmmXZ9i7OPpqciMDyhavTrFAD/Bv1fe3wILQiY5PNBB+BiNxujHfMKyY+oBomKdiNrj/Mxjb9oSB7M4AHYj1j+GGdHzd3ODnWqQzrIMvzkjUrk6IK8sxIRLi7llB0TLClnbr+9hqaXgrE6DdqZVmLIQP8M+YlIPG5FgAZjYpo7J1/7yyKustX0eeB/Q2hrqo9LTyYvPBWe/3Ytu/XPnFy3GQsxswVWJlWlF5JfhIFPupw9X+Bl9CZl2PMcFZlcu4ERmnlJgdNRhzIW4bBF7YtWnuPqSGNqx89kobcULjOH21mTW971USySC+F5HiS46b9S5urUNWH1Jwv+Ip
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(39840400004)(366004)(376002)(136003)(396003)(346002)(451199018)(86362001)(15974865002)(7696005)(33656002)(54906003)(66446008)(6506007)(966005)(316002)(8936002)(83380400001)(478600001)(9686003)(53546011)(8676002)(38100700002)(26005)(186003)(44832011)(38070700005)(52536014)(55016003)(2906002)(122000001)(5660300002)(66476007)(71200400001)(76116006)(64756008)(66556008)(66946007)(110136005)(4326008)(41300700001)(18886075002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?blpKWmRvRnRFUWpVdWVsdWZBT1VRRG9aOS95YmxES0tDb0RDSGtHcGc3TGxN?=
 =?utf-8?B?MVJOS1R4NVAyUWhwMDM1T1lFR0ROQzNqR2pMY3RyMSs1aVp1SFdHS0UydCtE?=
 =?utf-8?B?b1M0M2lValhYZmwyMG9ubTdVM0dDNzdpOHg1YXhyenNQTXh1S1IvOEZHNWMw?=
 =?utf-8?B?Yk5aZ0VqVElPem9ac1c5eHhCZnp4QVRSUjhnNnFQeFJkbjlRYkYzdkswY0pa?=
 =?utf-8?B?Z1RjcHBvSWxjT2o1NzhjZmlqWUhYWW5xMGJrV29EZkNkZmxCdk83Nm0vc3Az?=
 =?utf-8?B?MWFWelNvMmU1ZW5XZE1EUmZoVTJZc25VYkcvQVhRSEx3ajJVRzVNWDkzbm95?=
 =?utf-8?B?N1J3ZGFySmVXZC9zWmovMG45SUtybGNDVUZMV1Z4bUdRVE5SUzZ1Wmk2TndO?=
 =?utf-8?B?RzAvTU5tQVJjeHVqa1FlUGFvb2lZVGltS3BLckhTU1c3ZTNFaVJxS1FNNGt5?=
 =?utf-8?B?dmVxOFJwcDhDZzJ5T2J3Q1JmdTZKbUE0cVhLemdScUM4KzJJek1MR3UrVTBO?=
 =?utf-8?B?WGhXdDZ3clFPWGErZHUvWXFjL083LzN1MWZwanFJdkhQOVZrYkdhZ1BmVWU4?=
 =?utf-8?B?K0oxMjZkSkNQeUhwcFlmVjZDWXFUcGhTYXdqVllmU0RHaE5oQkZCZzhLWHgz?=
 =?utf-8?B?WENPQ1VyTzdRUCtQUE9QWUhpNDhRU1EwTDh2L3lWM0ZrNDhWamhuSTArUlZL?=
 =?utf-8?B?aVVXU0ozSFA4eVVKZXBNRkdPYW11dTRjcGdjRkpNcFhNTHo2eEdVZmVHWGJQ?=
 =?utf-8?B?cERMVk41eHZOcXB3b1BUb2xiZWF6QWhRUEJrRW5HOFRNRzFzR1pPUEdoeGhU?=
 =?utf-8?B?RVRwWFA5QzF4bjhJMFdJTmdkdEJ6MmNxTUpmdDRvdDJMUGlveFZ1QlpoUXlS?=
 =?utf-8?B?bDBkaDJsM3BYLzJVdGZXUFlXek5DcGUvMkFmaGxWaEpIdGVydWJwYitTRTdo?=
 =?utf-8?B?UFE4d3duSlJxVUR2azBJMlZkNmFSSzB4Y09pMndGbXg2N09XS2MxUjdlbGxS?=
 =?utf-8?B?MjlwUS9lVldZOEdIYTdtVVdxZ21aZE41ams3dmhtalFhalNlVnZEaUJtOHlN?=
 =?utf-8?B?L0dNSXZYZ3MwNlRLb0FnSm4xYXpYTm9EbUpUSnNHT0NqalF1bGZXWW5HTjQw?=
 =?utf-8?B?MDd6T3dIdmxCalVsK2dRQzhYNzNiMUc1VzRSYlYzMmxrTFo0ZSsyT0I3RXRi?=
 =?utf-8?B?MEZpeUpWLzVuUmJGbTdjdDdKb25XYnZremlsSGYxZVo3WVNvUkU3bTRkRzFU?=
 =?utf-8?B?QkZJNWtLTHcrQk9QM1MydjQwTnJSNWF6SXdRdnN0YnJkRExHQlBNQStFSlRX?=
 =?utf-8?B?OVRoUXpXRlA1TU94SmQyYzMwL296ZWQzeHVnK1hINDVBUlgxOU8zYXBGYlRs?=
 =?utf-8?B?YWhjYldGREtJNjgyNnE3bFNQS09neUNFam1oT2k2MWxJWXBXQ2E0UExSLzFW?=
 =?utf-8?B?WGtIYW9QRmY0anZsOFFuMzBEaW8wbkJMT04zQ3VUYVFUMytZcVUySmFRNFg1?=
 =?utf-8?B?TDE0MnN6WEdNelh0c3VvNFJEQVVDREkvUGg4b3NYb3pOeFY5cXpidHBKUFRV?=
 =?utf-8?B?cGh5bXZWL3gyZTBwaVVxR2E0c0tDeHh5eEY1WlVKYUs4Qy9Lcy8xZ051QmMr?=
 =?utf-8?B?blBtVW5razRhczRXSHliSE9HKzFkVHE0UG9wQ3VzdGltSEx3dzNkRmhEN2dz?=
 =?utf-8?B?dElob2g5UjBsTzdCaTVjZUdZd1I3ci9XR2xBdXlCOGZ4dElDUDBtQ0k5MGlm?=
 =?utf-8?B?VGwzZEZuQnYwSWhOeHcxa1J3aGtzdndKUExGWXp0MFdEeW5zdEkrWFdwbjdj?=
 =?utf-8?B?TVplaUU1WHZhcHdLYU5tWmg0L3dWNHM3V1ZMOWRXSFNiWVlwYVRoY0g2OU9k?=
 =?utf-8?B?cFNiQjkvSDloWjZwRUcvUlJDMmF6YmZ4MldJRDNkVGVrTkVvVmM3NGZ2dzE0?=
 =?utf-8?B?Q0NRejg3c2Z4bEJFa2NUQlh1TFpzQk9GMmwvMDNRTU1hWmpXa2hNT1czVlo4?=
 =?utf-8?B?bE4ycC9EejBRU21nMVZmWXZ5OEgyczMrOU5mQzYwS1RZaWYxVkVzdjVnUWJl?=
 =?utf-8?B?RnVZNk5jSHlreXNWVTNGc215eUZZQXhIV2dGQXArTTJsSDlKN1ZxdlYrcTBC?=
 =?utf-8?B?T2U3R2tTWXdFSzNIaFNsRzNXN20rTkJpV2dEYmVaQnRnOUlkUVBMakp5VE5B?=
 =?utf-8?B?S0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 75f1968b-31df-4661-3c31-08daff06cff7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2023 19:03:15.0007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6OOmBOu1vPLixg0uvNPjLSUmg7aui21j87Mx0rHgmPEnLfKem8CQ6Nfuz2Hfg6qeh5SLrPJbaKZ0d0WLvsj2MAnON98V/KFA/ENsAo7sk5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWP189MB2526
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXR0aGlldSBCYWVydHMgPG1h
dHRoaWV1LmJhZXJ0c0B0ZXNzYXJlcy5uZXQ+DQo+IFNlbnQ6IFdlZG5lc2RheSwgMjUgSmFudWFy
eSAyMDIzIDEwOjE0DQo+IFRvOiBQYWJsbyBOZWlyYSBBeXVzbyA8cGFibG9AbmV0ZmlsdGVyLm9y
Zz47IG5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IFNyaXJhbSBZYWduYXJhbWFu
IDxzcmlyYW0ueWFnbmFyYW1hbkBlc3QudGVjaD47IEZsb3JpYW4gV2VzdHBoYWwNCj4gPGZ3QHN0
cmxlbi5kZT4NCj4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IGt1YmFAa2VybmVsLm9yZzsNCj4gcGFiZW5pQHJlZGhhdC5jb207IGVkdW1hemV0QGdvb2ds
ZS5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQgMC80XSBOZXRmaWx0ZXIgZml4ZXMgZm9y
IG5ldDogbWFudWFsIG1lcmdlDQo+IA0KPiBIZWxsbywNCj4gDQo+IE9uIDI0LzAxLzIwMjMgMTk6
MzksIFBhYmxvIE5laXJhIEF5dXNvIHdyb3RlOg0KPiA+IEhpLA0KPiA+DQo+ID4gVGhlIGZvbGxv
d2luZyBwYXRjaHNldCBjb250YWlucyBOZXRmaWx0ZXIgZml4ZXMgZm9yIG5ldDoNCj4gDQo+ICgu
Li4pDQo+IA0KPiA+IFNyaXJhbSBZYWduYXJhbWFuICg0KToNCj4gPiAgICAgICBuZXRmaWx0ZXI6
IGNvbm50cmFjazogZml4IHZ0YWcgY2hlY2tzIGZvciBBQk9SVC9TSFVURE9XTl9DT01QTEVURQ0K
PiA+ICAgICAgIG5ldGZpbHRlcjogY29ubnRyYWNrOiBmaXggYnVnIGluIGZvcl9lYWNoX3NjdHBf
Y2h1bmsNCj4gPiAgICAgICBSZXZlcnQgIm5ldGZpbHRlcjogY29ubnRyYWNrOiBhZGQgc2N0cCBE
QVRBX1NFTlQgc3RhdGUiDQo+ID4gICAgICAgbmV0ZmlsdGVyOiBjb25udHJhY2s6IHVuaWZ5IGVz
dGFibGlzaGVkIHN0YXRlcyBmb3IgU0NUUCBwYXRocw0KPiANCj4gRllJLCB3ZSBnb3QgYSBzbWFs
bCBjb25mbGljdCB3aGVuIG1lcmdpbmcgLW5ldCBpbiBuZXQtbmV4dCBpbiB0aGUgTVBUQ1AgdHJl
ZQ0KPiBkdWUgdG8gdGhlIGxhc3QgdHdvIHBhdGNoZXMgYXBwbGllZCBpbiAtbmV0Og0KPiANCj4g
ICAxM2JkOWIzMWE5NjkgKCJSZXZlcnQgIm5ldGZpbHRlcjogY29ubnRyYWNrOiBhZGQgc2N0cCBE
QVRBX1NFTlQgc3RhdGUiIikNCj4gICBhNDRiNzY1MTQ4OWYgKCJuZXRmaWx0ZXI6IGNvbm50cmFj
azogdW5pZnkgZXN0YWJsaXNoZWQgc3RhdGVzIGZvciBTQ1RQDQo+IHBhdGhzIikNCj4gDQo+IGFu
ZCB0aGlzIG9uZSBmcm9tIG5ldC1uZXh0Og0KPiANCj4gICBmNzFjYjhmNDVkMDkgKCJuZXRmaWx0
ZXI6IGNvbm50cmFjazogc2N0cDogdXNlIG5mIGxvZyBpbmZyYXN0cnVjdHVyZSBmb3IgaW52YWxp
ZA0KPiBwYWNrZXRzIikNCg0KQWgsIHRoYXQncyBteSBiYWQuIEkgc2hvdWxkIGhhdmUgcHVzaGVk
IHRvIG5mLW5leHQvbmV0LW5leHQgaW5zdGVhZC4gDQpNYWludGFpbmVyczogSSBhbSBub3QgZnVs
bHkgYXdhcmUgb2Ygd2hhdCBuZWVkcyB0byBiZSBkb25lIGluIHRoaXMgY2FzZSwgcGxlYXNlIGFk
dmlzZS4NCg0KPiANCj4gVGhlIGNvbmZsaWN0IGhhcyBiZWVuIHJlc29sdmVkIG9uIG91ciBzaWRl
WzFdIGFuZCB0aGUgcmVzb2x1dGlvbiB3ZSBzdWdnZXN0IGlzDQo+IGF0dGFjaGVkIHRvIHRoaXMg
ZW1haWwuDQoNClRoZSBhdHRhY2hlZCBwYXRjaCBsb29rcyBmaW5lIHRvIG1lLg0KCQ0KPiANCj4g
Q2hlZXJzLA0KPiBNYXR0DQo+IA0KPiBbMV0gaHR0cHM6Ly9naXRodWIuY29tL211bHRpcGF0aC10
Y3AvbXB0Y3BfbmV0LW5leHQvY29tbWl0LzRlMmJjMDY2ZGFlNA0KPiAtLQ0KPiBUZXNzYXJlcyB8
IEJlbGdpdW0gfCBIeWJyaWQgQWNjZXNzIFNvbHV0aW9ucyB3d3cudGVzc2FyZXMubmV0DQo=
