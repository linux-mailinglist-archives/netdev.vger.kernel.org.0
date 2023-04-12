Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073786DF8C1
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 16:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjDLOjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 10:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjDLOjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 10:39:31 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021022.outbound.protection.outlook.com [52.101.62.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57409901B;
        Wed, 12 Apr 2023 07:39:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qy8VWzgrRyge96q1QbTuofwfHt+lF/F4Lqbup0C3aFG5wKIouml0HpG6OcX600Ljl0PLMMh6YgZqJh5r13Begg8tzxMvX3YKIi4waz+x5UdE/XijhSJHzvaJdo4EL44jQvIfFO6QIZ6mACZfq4CX0IeAlDO4eJqB5KPgNFDyH9oC6dNWyNB81mYAC7M4Av0Ja7Am7XAYhk/49R0xhrp4LBTMtbZHrJG+ZlNiJnoVmWM6mSg4NxPm6EJl9hcQdA0rMrqHGRpUfzCd0tgHDUFesUtEROaKV+l+Dyw4OUneUHbxPzQCDBN7Xp1gUzVJKin1DtU7xvYt2uIiRdwLrBNoTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BTTOywkGOIy0dW8gti6QJ9nrTPoTTt8gZ1lPYx4fTJE=;
 b=YZ3Jcc3oncGbZjSxGWDgzBrnEQOa5XPcHWsEmOt6fD5ouHhtZkoPsTg7q4tj6DRvt5ZaArp4YCrrAdBq8p0gMriJAvKkL8/m/6f+axdkrD/oZ1wiA104Pv//H74OO1j6cNAY6jvhmYAjA1l3y2h4qdthQjFNvJV0knV5WLXd37DbHHgF7WUvKkGn8KvocixROaaY3Cx/qycGi5ohRwqXkvyCgpdA4DSxX8LIC0bLg96pUOTcSWj1f9JFoGyaHuIKVR3YX9aJMakAIrhjniHF2lH3nFPYXnfE0njFIfXsO100wfYDMuYiUApnyBMJdpyv6oM8wH9zmLtvOLQ3nYSLog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BTTOywkGOIy0dW8gti6QJ9nrTPoTTt8gZ1lPYx4fTJE=;
 b=bcHxopXlcO0dwPwe2EIoJiqZwLEPNCkIEGhn2iD9Hh2vYjLz/pb0rC2NQ3CGKApLONfweIURYyKzscM8yZqrU0ZTLYYQrg9Pg1n2YpoZwfNgA+mwC9C3a1bnERblwU2HUa6a2QAmbWnYZzaZ3hAjA6R77ZX3tkwuwIG8qVufXyg=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by MN0PR21MB3051.namprd21.prod.outlook.com (2603:10b6:208:373::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.4; Wed, 12 Apr
 2023 14:38:51 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::969d:2908:c2e1:e787]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::969d:2908:c2e1:e787%7]) with mapi id 15.20.6319.004; Wed, 12 Apr 2023
 14:38:51 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2,net-next, 2/3] net: mana: Enable RX path to handle
 various MTU sizes
Thread-Topic: [PATCH V2,net-next, 2/3] net: mana: Enable RX path to handle
 various MTU sizes
Thread-Index: AQHZaZQkcgkpVgPJ60+8kTF9LVjEd68mwo+AgAEDFXA=
Date:   Wed, 12 Apr 2023 14:38:51 +0000
Message-ID: <PH7PR21MB311673452BE2DBDC345C56D1CA9B9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1680901196-20643-1-git-send-email-haiyangz@microsoft.com>
 <1680901196-20643-3-git-send-email-haiyangz@microsoft.com>
 <422e4a51-4cec-5772-70f5-1019789acd18@intel.com>
In-Reply-To: <422e4a51-4cec-5772-70f5-1019789acd18@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9b833f42-2e34-4449-8d5c-1a999715d209;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-12T14:38:08Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|MN0PR21MB3051:EE_
x-ms-office365-filtering-correlation-id: d3ecb5e9-2684-43c8-8327-08db3b63a269
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dlxeTvwZtK93Ucj5wbiektcXu5EXIADMRimMjJkreAgMfxQefNvA2nCCPtmietNL8cI3DQDJYVDWikyJJ8BYQn3Z+UdAvdBopcRZ+Ktr1UFk4hKt/o1ns9m6cjiSptH54BhWbI3rHHP1O5hPzRkVAKAcm8HngpsIvq2yPYO6uO4bktFQx5LgLZlCH3E7Fuka0k9qkX7hFbJdZmlBsVEqvfrMii2WTI871Fe2PGWvZKI1LfNdi4R/yhsC7PPLSE8U8ei3FQzWkc8cQ6ah2so5fjQssFSIX1DXMQHQcGuM8LfzZs9SkketX3sRC6eazrwLGwCbMl+VWGBhA97COEU3MPwVQANIigppZl3xN8WGBrhLCW00qK49/H73gYLB9sGIM875e8uIoFNxWubuSxyriC9+eKWBBQ0sAndq4mPG9nHA6YoKzltJWkK5R/EKsJAhiqMuf3sHotDvZ8aYHYYwmG8F+jDPHz7bCxWfakTXCoqU/WOzXlw7D0LGGv5Zl2Dk5/VcYNQd4PQpL493WLPxQJIKi53Ao2HjcLIN/6MYOIEhWXzccPYaq2WaHojale93Vjl9BRrCksgK1T0nEb9/P1OpenPaBY8recwtxBfUgyWysxUCctcYdzLQwjlFykASrW0LYJz8NxVVvTihOVJjGKKMsTrzHiOa4a309g3/NJI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199021)(5660300002)(54906003)(7416002)(10290500003)(478600001)(71200400001)(7696005)(786003)(8936002)(52536014)(316002)(41300700001)(26005)(110136005)(53546011)(66946007)(66446008)(4326008)(64756008)(66556008)(66476007)(8676002)(76116006)(6506007)(9686003)(2906002)(186003)(83380400001)(8990500004)(122000001)(82960400001)(82950400001)(55016003)(33656002)(86362001)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aUx5WWFlTjYrenVHT2NBUnJTNGNyNGVRRmFUNXpVOGhBOExWTEJ4azZxYkVq?=
 =?utf-8?B?VXIyd0sydWJJVHRJQmdNRitBTXZ5SEZ1ZnlrQ0lUV2l6dkdBNUZsUm5DcENz?=
 =?utf-8?B?VXA5ZFJNanRUUnIrKy8rcFZvUlBuR3d1NCtwS241Ni9HRkNET0hRTFRkb1pN?=
 =?utf-8?B?UG5KOTUwMXZDYzdRZlFCR0d3SEUxQ1g4bUtMdXc2dkJqRVpSYU1lYzNtZkI4?=
 =?utf-8?B?WnVjZEJuR2hKbkpHZGFKYlIwQllxb2pxSkpNUmZTWDJPNnV4eG9LQkl4Y2FP?=
 =?utf-8?B?TUtjMC9sY3FvVWwyREwyTnB6OFJIMS9zNVBmQ0l5L3B0TUZDOTdSMzZDeWpK?=
 =?utf-8?B?ZXN0MDI0a1EwOGIzT003SStHM3ZrejNRMnhhY1ZJYWp5ejkyZHJQMk55Z3Fh?=
 =?utf-8?B?anRRZXF0VTBtbzQ2Vi9Sc3QwZUgrSE44NUxPK3hDTkpia3pFMUFsQzZVbVJO?=
 =?utf-8?B?V2RFRUEyWEQ2UnIxZnRmbG9QSEdiTXA4Y2pkMVNpT1U5UFRYOWFQc0dQM2JE?=
 =?utf-8?B?cFNiMXVUNXhLQ25ITTIrbTZla3pBRmVuOENsTmo4U25aM2FnTnJYMEZxVWhm?=
 =?utf-8?B?YzJFaUVjTTZnZ2l2Y3pTQkIva1V0emNSeXFTTWRJdi9nVnlsdTJHRHowMlhV?=
 =?utf-8?B?VTlhUTRkUmgwM2NwdmovVGhmQXYzaGlKZmIwbi9CdklBM0hGaEdBNnBpSXVy?=
 =?utf-8?B?QVRBTWRPR1FOTi9zTFpQMXlkSHhUV1FMaGdjeEw1S0J2amptZkhOSWllMFhq?=
 =?utf-8?B?aG9MSEtwMEdsN3VSS1o2NHZ2N0dQZENRVVFXMkRRa1lhMUxMRUNEZzFHSCtM?=
 =?utf-8?B?TFRraUcvNUhRM2VqbXh6NXJRY2xLc3RnOElrZVlnOUljY0xHa0NHcVdxWk9O?=
 =?utf-8?B?L2Vyb0hhTE5MY3hHNDEwaG9NQjJqOEcxNXpoVUR2eHRpM3BpNU93M3ZNWVZR?=
 =?utf-8?B?MGpQKytEWUg5N0ZMZTBrQytLOEovcjY1ay9ZdFFjc21ZcGNBZVJzbklGL3hP?=
 =?utf-8?B?b3FaeFJQN3EwN1RuV04wTFBKNGN6WWZLWHdiV29JS0tBcmRkN3ZkbXdENEdX?=
 =?utf-8?B?Qkg1TkhVazRTM3I4N1B3a0VQWU1hMXRsRzdRWlBQdEE5azZSTW1iWTg2MytL?=
 =?utf-8?B?OGZYdFJjUFpFNzNscXp1KzdOdHBVeE02OHJ3Z1FQVE51anRPbGhTdENqU05Q?=
 =?utf-8?B?U1ZSVXpJQ2k0VytHL1QwU0w0TllaTWRmMUlGT2FjU0NhTC9uS0IxTEwzaTB4?=
 =?utf-8?B?RndZbU9MaGtEVWZsak1zNW5qeGl4S3ppUWtrLzNFMEc1RXRqTGs0bUVRRFoz?=
 =?utf-8?B?Tjd1cFFEZXo4c2RVWmg4bDlZUVQyeFBFY1kyR2lDSHc1SUhDV3lkTTdoaXpR?=
 =?utf-8?B?S0ZUQ3Q3TUh2WlhsQWExaE9waGQ0Y0pJbkJGNm9uaWNPait0dk8vOEVPdU15?=
 =?utf-8?B?UUZFa3JIWXg5T3Z3VnJ1N3V0Z0dEcVFDRVBMbkNZUGR0djJuSHg1VjJ1b0xQ?=
 =?utf-8?B?bDFnYzBFVXRvenN3VTlROU5Tc2lYUk4zamZQcnJsbkdKa3FyZ2YyMFZMM1Q1?=
 =?utf-8?B?bmtCdFZ1WlcvUURVNVRORmt3aVdaMWtWSFVQUEhFNTJERjFNVHZuZ1BSakRQ?=
 =?utf-8?B?bmw4QjhQWVUzU2ZPUmhuaGZuSHdLcm1SMi9xNWtEeVZsYXhSNlZwQVVMMVV2?=
 =?utf-8?B?aXBvVWJJdlR0ZktpSnF1c09RS0hBSXc4bm5WZWFyUlZ2UkVmL2NjUkpDeGhu?=
 =?utf-8?B?RDIvdVZUZ29BVUtpMW5KOGZPYUZyalBhNFlkaGdhVXF2K1UrVitvMkxPYk1y?=
 =?utf-8?B?YWgvb3doSE9uZTA3eE9kTTZDQmdOUitwSUJvNnJ6MWZ1MTYySG9Wc2VLcWdT?=
 =?utf-8?B?Y2ttS0x1TE4xNnNuZkZNM1N1U1BoZVFQbDVRMHpack9ocXFhNEpsUll4R2dj?=
 =?utf-8?B?b2pQcythMGpIQ0lPd2tyb0FBc1pJYWdkdkpxMDZHKzlhYlBPald0WXR2dXVk?=
 =?utf-8?B?MUVkMlorUlpjaXhNcURoZFQ5QkNrR291US9QUVFLZ3hjWG1ickJVWTJNdklJ?=
 =?utf-8?B?T3BoYUFHMXE4RUtLd0k2UzErd3ZSV3c0RGhGS2xFZWd6MG9qTFlHRzFpWUll?=
 =?utf-8?Q?9x3WetwxdnvyTH4wZgMPH33IV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3ecb5e9-2684-43c8-8327-08db3b63a269
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 14:38:51.5162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9oLWyUJkaMQcpOOeSJs6Xw5byyezuoBMQsgq9R5Gd6eP2zXc8c8cekA2GsDMbrGKbvlgjYRg6ZPrJ+wWR4dm9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3051
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFjb2IgS2VsbGVyIDxq
YWNvYi5lLmtlbGxlckBpbnRlbC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEFwcmlsIDExLCAyMDIz
IDc6MTEgUE0NCj4gVG86IEhhaXlhbmcgWmhhbmcgPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+OyBs
aW51eC1oeXBlcnZAdmdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+
IENjOiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPjsgS1kgU3Jpbml2YXNhbiA8a3lz
QG1pY3Jvc29mdC5jb20+Ow0KPiBQYXVsIFJvc3N3dXJtIDxwYXVscm9zQG1pY3Jvc29mdC5jb20+
OyBvbGFmQGFlcGZsZS5kZTsNCj4gdmt1em5ldHNAcmVkaGF0LmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldDsgd2VpLmxpdUBrZXJuZWwub3JnOw0KPiBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtl
cm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOw0KPiBsZW9uQGtlcm5lbC5vcmc7IExvbmcgTGkg
PGxvbmdsaUBtaWNyb3NvZnQuY29tPjsNCj4gc3NlbmdhckBsaW51eC5taWNyb3NvZnQuY29tOyBs
aW51eC1yZG1hQHZnZXIua2VybmVsLm9yZzsNCj4gZGFuaWVsQGlvZ2VhcmJveC5uZXQ7IGpvaG4u
ZmFzdGFiZW5kQGdtYWlsLmNvbTsgYnBmQHZnZXIua2VybmVsLm9yZzsNCj4gYXN0QGtlcm5lbC5v
cmc7IEFqYXkgU2hhcm1hIDxzaGFybWFhamF5QG1pY3Jvc29mdC5jb20+Ow0KPiBoYXdrQGtlcm5l
bC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRD
SCBWMixuZXQtbmV4dCwgMi8zXSBuZXQ6IG1hbmE6IEVuYWJsZSBSWCBwYXRoIHRvIGhhbmRsZQ0K
PiB2YXJpb3VzIE1UVSBzaXplcw0KPiANCj4gDQo+IA0KPiBPbiA0LzcvMjAyMyAxOjU5IFBNLCBI
YWl5YW5nIFpoYW5nIHdyb3RlOg0KPiA+IFVwZGF0ZSBSWCBkYXRhIHBhdGggdG8gYWxsb2NhdGUg
YW5kIHVzZSBSWCBxdWV1ZSBETUEgYnVmZmVycyB3aXRoDQo+ID4gcHJvcGVyIHNpemUgYmFzZWQg
b24gcG90ZW50aWFsbHkgdmFyaW91cyBNVFUgc2l6ZXMuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBIYWl5YW5nIFpoYW5nIDxoYWl5YW5nekBtaWNyb3NvZnQuY29tPg0KPiA+DQo+ID4gLS0tDQo+
ID4gVjI6DQo+ID4gUmVmZWN0b3JlZCB0byBtdWx0aXBsZSBwYXRjaGVzIGZvciByZWFkYWJpbGl0
eS4gU3VnZ2VzdGVkIGJ5IFl1bnNoZW5nIExpbi4NCj4gPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9taWNyb3NvZnQvbWFuYS9tYW5hX2VuLmMgfCAxODggKysrKysrKysrKyst
LS0tLS0NCj4gLQ0KPiA+ICBpbmNsdWRlL25ldC9tYW5hL21hbmEuaCAgICAgICAgICAgICAgICAg
ICAgICAgfCAgMTMgKy0NCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAxMjQgaW5zZXJ0aW9ucygrKSwg
NzcgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWljcm9zb2Z0L21hbmEvbWFuYV9lbi5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWlj
cm9zb2Z0L21hbmEvbWFuYV9lbi5jDQo+ID4gaW5kZXggMTEyYzY0MmRjODliLi5lNWQ1ZGVhNzYz
ZjIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9zb2Z0L21hbmEv
bWFuYV9lbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9zb2Z0L21hbmEv
bWFuYV9lbi5jDQo+ID4gQEAgLTExODUsMTAgKzExODUsMTAgQEAgc3RhdGljIHZvaWQgbWFuYV9w
b3N0X3BrdF9yeHEoc3RydWN0DQo+IG1hbmFfcnhxICpyeHEpDQo+ID4gIAlXQVJOX09OX09OQ0Uo
cmVjdl9idWZfb29iLT53cWVfaW5mLndxZV9zaXplX2luX2J1ICE9IDEpOw0KPiA+ICB9DQo+ID4N
Cj4gPiAtc3RhdGljIHN0cnVjdCBza19idWZmICptYW5hX2J1aWxkX3NrYih2b2lkICpidWZfdmEs
IHVpbnQgcGt0X2xlbiwNCj4gPiAtCQkJCSAgICAgIHN0cnVjdCB4ZHBfYnVmZiAqeGRwKQ0KPiA+
ICtzdGF0aWMgc3RydWN0IHNrX2J1ZmYgKm1hbmFfYnVpbGRfc2tiKHN0cnVjdCBtYW5hX3J4cSAq
cnhxLCB2b2lkICpidWZfdmEsDQo+ID4gKwkJCQkgICAgICB1aW50IHBrdF9sZW4sIHN0cnVjdCB4
ZHBfYnVmZiAqeGRwKQ0KPiA+ICB7DQo+ID4gLQlzdHJ1Y3Qgc2tfYnVmZiAqc2tiID0gbmFwaV9i
dWlsZF9za2IoYnVmX3ZhLCBQQUdFX1NJWkUpOw0KPiA+ICsJc3RydWN0IHNrX2J1ZmYgKnNrYiA9
IG5hcGlfYnVpbGRfc2tiKGJ1Zl92YSwgcnhxLT5hbGxvY19zaXplKTsNCj4gPg0KPiA+ICAJaWYg
KCFza2IpDQo+ID4gIAkJcmV0dXJuIE5VTEw7DQo+ID4gQEAgLTExOTYsMTEgKzExOTYsMTIgQEAg
c3RhdGljIHN0cnVjdCBza19idWZmICptYW5hX2J1aWxkX3NrYih2b2lkDQo+ICpidWZfdmEsIHVp
bnQgcGt0X2xlbiwNCj4gPiAgCWlmICh4ZHAtPmRhdGFfaGFyZF9zdGFydCkgew0KPiA+ICAJCXNr
Yl9yZXNlcnZlKHNrYiwgeGRwLT5kYXRhIC0geGRwLT5kYXRhX2hhcmRfc3RhcnQpOw0KPiA+ICAJ
CXNrYl9wdXQoc2tiLCB4ZHAtPmRhdGFfZW5kIC0geGRwLT5kYXRhKTsNCj4gPiAtCX0gZWxzZSB7
DQo+ID4gLQkJc2tiX3Jlc2VydmUoc2tiLCBYRFBfUEFDS0VUX0hFQURST09NKTsNCj4gPiAtCQlz
a2JfcHV0KHNrYiwgcGt0X2xlbik7DQo+ID4gKwkJcmV0dXJuIHNrYjsNCj4gPiAgCX0NCj4gPg0K
PiA+ICsJc2tiX3Jlc2VydmUoc2tiLCByeHEtPmhlYWRyb29tKTsNCj4gPiArCXNrYl9wdXQoc2ti
LCBwa3RfbGVuKTsNCj4gPiArDQo+ID4gIAlyZXR1cm4gc2tiOw0KPiA+ICB9DQo+ID4NCj4gPiBA
QCAtMTIzMyw3ICsxMjM0LDcgQEAgc3RhdGljIHZvaWQgbWFuYV9yeF9za2Iodm9pZCAqYnVmX3Zh
LCBzdHJ1Y3QNCj4gbWFuYV9yeGNvbXBfb29iICpjcWUsDQo+ID4gIAlpZiAoYWN0ICE9IFhEUF9Q
QVNTICYmIGFjdCAhPSBYRFBfVFgpDQo+ID4gIAkJZ290byBkcm9wX3hkcDsNCj4gPg0KPiA+IC0J
c2tiID0gbWFuYV9idWlsZF9za2IoYnVmX3ZhLCBwa3RfbGVuLCAmeGRwKTsNCj4gPiArCXNrYiA9
IG1hbmFfYnVpbGRfc2tiKHJ4cSwgYnVmX3ZhLCBwa3RfbGVuLCAmeGRwKTsNCj4gPg0KPiA+ICAJ
aWYgKCFza2IpDQo+ID4gIAkJZ290byBkcm9wOw0KPiA+IEBAIC0xMjgyLDE0ICsxMjgzLDcyIEBA
IHN0YXRpYyB2b2lkIG1hbmFfcnhfc2tiKHZvaWQgKmJ1Zl92YSwgc3RydWN0DQo+IG1hbmFfcnhj
b21wX29vYiAqY3FlLA0KPiA+ICAJdTY0X3N0YXRzX3VwZGF0ZV9lbmQoJnJ4X3N0YXRzLT5zeW5j
cCk7DQo+ID4NCj4gPiAgZHJvcDoNCj4gPiAtCVdBUk5fT05fT05DRShyeHEtPnhkcF9zYXZlX3Bh
Z2UpOw0KPiA+IC0JcnhxLT54ZHBfc2F2ZV9wYWdlID0gdmlydF90b19wYWdlKGJ1Zl92YSk7DQo+
ID4gKwlXQVJOX09OX09OQ0UocnhxLT54ZHBfc2F2ZV92YSk7DQo+ID4gKwkvKiBTYXZlIGZvciBy
ZXVzZSAqLw0KPiA+ICsJcnhxLT54ZHBfc2F2ZV92YSA9IGJ1Zl92YTsNCj4gPg0KPiA+ICAJKytu
ZGV2LT5zdGF0cy5yeF9kcm9wcGVkOw0KPiA+DQo+ID4gIAlyZXR1cm47DQo+ID4gIH0NCj4gPg0K
PiA+ICtzdGF0aWMgdm9pZCAqbWFuYV9nZXRfcnhmcmFnKHN0cnVjdCBtYW5hX3J4cSAqcnhxLCBz
dHJ1Y3QgZGV2aWNlICpkZXYsDQo+ID4gKwkJCSAgICAgZG1hX2FkZHJfdCAqZGEsIGJvb2wgaXNf
bmFwaSkNCj4gPiArew0KPiA+ICsJc3RydWN0IHBhZ2UgKnBhZ2U7DQo+ID4gKwl2b2lkICp2YTsN
Cj4gPiArDQo+ID4gKwkvKiBSZXVzZSBYRFAgZHJvcHBlZCBwYWdlIGlmIGF2YWlsYWJsZSAqLw0K
PiA+ICsJaWYgKHJ4cS0+eGRwX3NhdmVfdmEpIHsNCj4gPiArCQl2YSA9IHJ4cS0+eGRwX3NhdmVf
dmE7DQo+ID4gKwkJcnhxLT54ZHBfc2F2ZV92YSA9IE5VTEw7DQo+ID4gKwl9IGVsc2UgaWYgKHJ4
cS0+YWxsb2Nfc2l6ZSA+IFBBR0VfU0laRSkgew0KPiA+ICsJCWlmIChpc19uYXBpKQ0KPiA+ICsJ
CQl2YSA9IG5hcGlfYWxsb2NfZnJhZyhyeHEtPmFsbG9jX3NpemUpOw0KPiA+ICsJCWVsc2UNCj4g
PiArCQkJdmEgPSBuZXRkZXZfYWxsb2NfZnJhZyhyeHEtPmFsbG9jX3NpemUpOw0KPiA+ICsNCj4g
PiArCQlpZiAoIXZhKQ0KPiA+ICsJCQlyZXR1cm4gTlVMTDsNCj4gPiArCX0gZWxzZSB7DQo+ID4g
KwkJcGFnZSA9IGRldl9hbGxvY19wYWdlKCk7DQo+ID4gKwkJaWYgKCFwYWdlKQ0KPiA+ICsJCQly
ZXR1cm4gTlVMTDsNCj4gPiArDQo+ID4gKwkJdmEgPSBwYWdlX3RvX3ZpcnQocGFnZSk7DQo+ID4g
Kwl9DQo+ID4gKw0KPiA+ICsJKmRhID0gZG1hX21hcF9zaW5nbGUoZGV2LCB2YSArIHJ4cS0+aGVh
ZHJvb20sIHJ4cS0+ZGF0YXNpemUsDQo+ID4gKwkJCSAgICAgRE1BX0ZST01fREVWSUNFKTsNCj4g
PiArDQo+ID4gKwlpZiAoZG1hX21hcHBpbmdfZXJyb3IoZGV2LCAqZGEpKSB7DQo+ID4gKwkJcHV0
X3BhZ2UodmlydF90b19oZWFkX3BhZ2UodmEpKTsNCj4gPiArCQlyZXR1cm4gTlVMTDsNCj4gPiAr
CX0NCj4gPiArDQo+ID4gKwlyZXR1cm4gdmE7DQo+ID4gK30NCj4gPiArDQo+ID4gKy8qIEFsbG9j
YXRlIGZyYWcgZm9yIHJ4IGJ1ZmZlciwgYW5kIHNhdmUgdGhlIG9sZCBidWYgKi8NCj4gPiArc3Rh
dGljIHZvaWQgbWFuYV9yZWZpbGxfcnhvb2Ioc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3QgbWFu
YV9yeHEgKnJ4cSwNCj4gPiArCQkJICAgICAgc3RydWN0IG1hbmFfcmVjdl9idWZfb29iICpyeG9v
Yiwgdm9pZA0KPiAqKm9sZF9idWYpDQo+ID4gK3sNCj4gPiArCWRtYV9hZGRyX3QgZGE7DQo+ID4g
Kwl2b2lkICp2YTsNCj4gPiArDQo+ID4gKwl2YSA9IG1hbmFfZ2V0X3J4ZnJhZyhyeHEsIGRldiwg
JmRhLCB0cnVlKTsNCj4gPiArDQo+ID4gKwlpZiAoIXZhKQ0KPiA+ICsJCXJldHVybjsNCj4gPiAr
DQo+ID4gKwlkbWFfdW5tYXBfc2luZ2xlKGRldiwgcnhvb2ItPnNnbFswXS5hZGRyZXNzLCByeHEt
PmRhdGFzaXplLA0KPiA+ICsJCQkgRE1BX0ZST01fREVWSUNFKTsNCj4gPiArCSpvbGRfYnVmID0g
cnhvb2ItPmJ1Zl92YTsNCj4gPiArDQo+ID4gKwlyeG9vYi0+YnVmX3ZhID0gdmE7DQo+ID4gKwly
eG9vYi0+c2dsWzBdLmFkZHJlc3MgPSBkYTsNCj4gPiArfQ0KPiA+ICsNCj4gDQo+IFNvIHlvdSdy
ZSBwdWxsaW5nIG91dCB0aGVzZSBmdW5jdGlvbnMgZnJvbSB0aGUgY29kZSBiZWxvdywgd2hpY2gg
aXMNCj4gZ29vZCwgYnV0IGl0IG1ha2VzIGl0IGhhcmQgdG8gdGVsbCB3aGF0IGNvZGUgYWN0dWFs
bHkgY2hhbmdlZC4NCj4gDQo+ID4gIHN0YXRpYyB2b2lkIG1hbmFfcHJvY2Vzc19yeF9jcWUoc3Ry
dWN0IG1hbmFfcnhxICpyeHEsIHN0cnVjdCBtYW5hX2NxICpjcSwNCj4gPiAgCQkJCXN0cnVjdCBn
ZG1hX2NvbXAgKmNxZSkNCj4gPiAgew0KPiA+IEBAIC0xMjk5LDEwICsxMzU4LDggQEAgc3RhdGlj
IHZvaWQgbWFuYV9wcm9jZXNzX3J4X2NxZShzdHJ1Y3QNCj4gbWFuYV9yeHEgKnJ4cSwgc3RydWN0
IG1hbmFfY3EgKmNxLA0KPiA+ICAJc3RydWN0IG1hbmFfcmVjdl9idWZfb29iICpyeGJ1Zl9vb2I7
DQo+ID4gIAlzdHJ1Y3QgbWFuYV9wb3J0X2NvbnRleHQgKmFwYzsNCj4gPiAgCXN0cnVjdCBkZXZp
Y2UgKmRldiA9IGdjLT5kZXY7DQo+ID4gLQl2b2lkICpuZXdfYnVmLCAqb2xkX2J1ZjsNCj4gPiAt
CXN0cnVjdCBwYWdlICpuZXdfcGFnZTsNCj4gPiArCXZvaWQgKm9sZF9idWYgPSBOVUxMOw0KPiA+
ICAJdTMyIGN1cnIsIHBrdGxlbjsNCj4gPiAtCWRtYV9hZGRyX3QgZGE7DQo+ID4NCj4gPiAgCWFw
YyA9IG5ldGRldl9wcml2KG5kZXYpOw0KPiA+DQo+ID4gQEAgLTEzNDUsNDAgKzE0MDIsMTEgQEAg
c3RhdGljIHZvaWQgbWFuYV9wcm9jZXNzX3J4X2NxZShzdHJ1Y3QNCj4gbWFuYV9yeHEgKnJ4cSwg
c3RydWN0IG1hbmFfY3EgKmNxLA0KPiA+ICAJcnhidWZfb29iID0gJnJ4cS0+cnhfb29ic1tjdXJy
XTsNCj4gPiAgCVdBUk5fT05fT05DRShyeGJ1Zl9vb2ItPndxZV9pbmYud3FlX3NpemVfaW5fYnUg
IT0gMSk7DQo+ID4NCj4gPiAtCS8qIFJldXNlIFhEUCBkcm9wcGVkIHBhZ2UgaWYgYXZhaWxhYmxl
ICovDQo+ID4gLQlpZiAocnhxLT54ZHBfc2F2ZV9wYWdlKSB7DQo+ID4gLQkJbmV3X3BhZ2UgPSBy
eHEtPnhkcF9zYXZlX3BhZ2U7DQo+ID4gLQkJcnhxLT54ZHBfc2F2ZV9wYWdlID0gTlVMTDsNCj4g
PiAtCX0gZWxzZSB7DQo+ID4gLQkJbmV3X3BhZ2UgPSBhbGxvY19wYWdlKEdGUF9BVE9NSUMpOw0K
PiA+IC0JfQ0KPiA+IC0NCj4gPiAtCWlmIChuZXdfcGFnZSkgew0KPiA+IC0JCWRhID0gZG1hX21h
cF9wYWdlKGRldiwgbmV3X3BhZ2UsDQo+IFhEUF9QQUNLRVRfSEVBRFJPT00sIHJ4cS0+ZGF0YXNp
emUsDQo+ID4gLQkJCQkgIERNQV9GUk9NX0RFVklDRSk7DQo+ID4gLQ0KPiA+IC0JCWlmIChkbWFf
bWFwcGluZ19lcnJvcihkZXYsIGRhKSkgew0KPiA+IC0JCQlfX2ZyZWVfcGFnZShuZXdfcGFnZSk7
DQo+ID4gLQkJCW5ld19wYWdlID0gTlVMTDsNCj4gPiAtCQl9DQo+ID4gLQl9DQo+ID4gLQ0KPiA+
IC0JbmV3X2J1ZiA9IG5ld19wYWdlID8gcGFnZV90b192aXJ0KG5ld19wYWdlKSA6IE5VTEw7DQo+
ID4gLQ0KPiA+IC0JaWYgKG5ld19idWYpIHsNCj4gPiAtCQlkbWFfdW5tYXBfcGFnZShkZXYsIHJ4
YnVmX29vYi0+YnVmX2RtYV9hZGRyLCByeHEtDQo+ID5kYXRhc2l6ZSwNCj4gPiAtCQkJICAgICAg
IERNQV9GUk9NX0RFVklDRSk7DQo+ID4gLQ0KPiA+IC0JCW9sZF9idWYgPSByeGJ1Zl9vb2ItPmJ1
Zl92YTsNCj4gPiAtDQo+ID4gLQkJLyogcmVmcmVzaCB0aGUgcnhidWZfb29iIHdpdGggdGhlIG5l
dyBwYWdlICovDQo+ID4gLQkJcnhidWZfb29iLT5idWZfdmEgPSBuZXdfYnVmOw0KPiA+IC0JCXJ4
YnVmX29vYi0+YnVmX2RtYV9hZGRyID0gZGE7DQo+ID4gLQkJcnhidWZfb29iLT5zZ2xbMF0uYWRk
cmVzcyA9IHJ4YnVmX29vYi0+YnVmX2RtYV9hZGRyOw0KPiA+IC0JfSBlbHNlIHsNCj4gPiAtCQlv
bGRfYnVmID0gTlVMTDsgLyogZHJvcCB0aGUgcGFja2V0IGlmIG5vIG1lbW9yeSAqLw0KPiA+IC0J
fQ0KPiANCj4gQ291bGQgeW91IGRvIHRoaXMgc3BsaXQgaW50byBoZWxwZXIgZnVuY3Rpb25zIGZp
cnN0IGluIGEgc2VwYXJhdGUgY2hhbmdlDQo+IGJlZm9yZSBhZGRpbmcgc3VwcG9ydCBmb3IgaGFu
ZGxpbmcgdmFyaW91cyBNVFUgc2l6ZT8NCj4gDQo+IERvaW5nIGl0IHRoYXQgd2F5IHdvdWxkIG1h
a2UgaXQgbXVjaCBlYXNpZXIgdG8gcmV2aWV3IHdoYXQgYWN0dWFsbHkNCj4gY2hhbmdlcyBpbiB0
aGF0IGJsb2NrIG9mIGNvZGUuDQoNCldpbGwgZG8uDQoNClRoYW5rcywNCi0gSGFpeWFuZw0KDQo=
