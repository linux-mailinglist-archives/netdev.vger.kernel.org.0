Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA779633B62
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbiKVLbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbiKVLad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:30:33 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2132.outbound.protection.outlook.com [40.107.114.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD205DB84;
        Tue, 22 Nov 2022 03:24:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmtm7jDJAUt1kylKcX//Sw6YhA1YzH4OqNnXpI2heoYaOLmwxLq/V3xnesLlW8qr+L6GObbX2LmuBE3MzUCJW/jYK+Uuc2ceYnwsoLWLSQHh/SGHvMK+1PCLYUwM8//rizEJuKwbSBZI/HTJm4CX1QtcG+Gjy9dBeIFiRuP7VKmqVPGDBukzy0874+F+atp0SWWucvxXBJSE+AoI/bHg9a/AmwKPhA9vQVtJK/cgxe2QjWdKFGCHJPD60m2hG+SQbR4S0wln8M/KCOP0HNvUr8XniNrPt7dpPvdi4IgPHIKsPRt7Xrk+b6wE/Rgp3/NBmpIAciRJTHVKOwbONKOjTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cAPhASMsKtSRn4sZcQrSYVGunlxzyaJoEwp0Q/qDtBI=;
 b=UERsmPP7TWHkUHp+4YkXJ446mYPSIMvmzDOkRNNFvWYeWNU0IHSgyriiEwFtJ1cEzcYv8bTtRDIMKucdzLSmstBZLGjsDiWwce2jZNdSgQz4xWEHFYiIYNrGu7gXRLPtNrEkcFofv3Dx67ujOJa8b/8cbQmSiijq2Qv/tQhqf7q/nYSy9uWZoK+WNJ7Y7ILOopweMW7kFgPlGm6kqXPzghDpF+HfLIfnE80DIJe/lohy61bOK9sCoyCv6biCG6Pj6RMLUS1EO01/TeZhq9Atm0Twv/AEjiwFg2MfTqw+TtPlgCVDxZ2l+TeQx2agfqtvHm4vTrmTYDTBrsWVToQfVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAPhASMsKtSRn4sZcQrSYVGunlxzyaJoEwp0Q/qDtBI=;
 b=CADWc1mpqldpuD8Dz7LPhrYV6oCV2UCrviS7nkcGDU0wGtWAwHxRIANYXtVgm0MKvas5XOxV+5le6D+7NMzf/aMDWPm2xIjtH77ux+RcX0l/tbGlO8N/a+u56pOKik8W6jjy48umMvLBo6owEyPaLjvL06hOfRJ117Prd8QK61w=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB6242.jpnprd01.prod.outlook.com (2603:1096:604:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 11:24:07 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::2cfb:38d2:d52e:c8a3]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::2cfb:38d2:d52e:c8a3%5]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 11:24:07 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "s.shtylyov@omp.ru" <s.shtylyov@omp.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] crypto: ccree - Fix section mismatch due to
 cc_debugfs_global_fini()
Thread-Topic: [PATCH -next] crypto: ccree - Fix section mismatch due to
 cc_debugfs_global_fini()
Thread-Index: AQHY/h9YRqPtEOJ6KEqblHhGr76hl65KRCAAgACI0XA=
Date:   Tue, 22 Nov 2022 11:24:07 +0000
Message-ID: <OS0PR01MB59224447AE5AB1A04567EBF2860D9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221122030542.23920-1-yuehaibing@huawei.com>
 <e3a466e7-5c5d-1288-9918-982edf597c24@huawei.com>
In-Reply-To: <e3a466e7-5c5d-1288-9918-982edf597c24@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OS3PR01MB6242:EE_
x-ms-office365-filtering-correlation-id: f3b5fbc4-5def-4fbe-5487-08dacc7c11ce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3jOO3iIuDG6ZyA6JT58C8EJMYKFBuKnFJiI95IHYwCzojEM3MwqXEKBzScN0AsplOr7W0o12N68ZVaVRB5kL0DdNCEBRQKmHKM9U2zc6uH6Dw0Bqj6pkF5P6IR/WNXQRoxpLSOSocwWvqwW8D8Db2zZvojhfAZRRIBfbB0trpQ6FydoJDG7BCA2kouQpwExIMycp9fTJZLIClPeg1EYQUXysf56k77mspZwF0kHtQ10EpZyGBdkarLvwObpAJBsw8BCZYTLZysPiA6ezNxBehB3jkmU9tmts7G/YpEuGaPhd3pd06u+DjujoR/Z3vcjylq11QEipfPmkhiqoJdjT6aqCBN8r16+eTp1Y5VgONxioPu/mkFvfz8VwSWwLp1Qr/2qRlUpO9wR9pRTI6fDufUjWQsBBqnbxAwQTUAV3Yyxlpt/AXM4WwTLwLrRV15XExZD9lGQ9ymNeifmZLHIrT6NTAJxG/nZyd03bKyW8ppcDox+BGvIaDKzv58U0z/uLRGuVByGFrGX6fcLoZj+JYiQPPzDqCNPzV2TYI9VN3w18OzrC0dunEVsvC4YomkvS4fwTbetwMprb9xSrRJ5Ng1zT56n5ZURwxUOoj9b676hJMw2Y18Oi/R/EJJFd+KLYpjSknPscz08K3sDCBQrz5/1coyvrFYXi/0O0PCjT/V6ohB+unwkTpGdUaAvsuGb/ua31brwirRvvNqaWqohjxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(451199015)(122000001)(38100700002)(86362001)(6506007)(8676002)(33656002)(38070700005)(7696005)(53546011)(26005)(186003)(5660300002)(71200400001)(9686003)(316002)(66446008)(76116006)(64756008)(66946007)(110136005)(54906003)(66476007)(478600001)(4326008)(52536014)(83380400001)(66556008)(8936002)(2906002)(41300700001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1BMMUpoRisrSXVyNE82QkJkMHVjVFgvVit3SUdRdE1BUm9DVEZES2MxVGhD?=
 =?utf-8?B?UnV4akM0U1d0M0lwa2d4clovYjhEaTBoSDBYdXk4VWZKd1dxSnV1cTJuK3hV?=
 =?utf-8?B?TzdEeE8vanRKY0I3Q01KZEZ0b3BraVZLOGNVbG5XalNzQ0FFTTRaZDhHZXpU?=
 =?utf-8?B?SzhHV05NNkRJZHEzRW4zbG9UMzVEQ2xjVk9GckhadVVmNVdzYkNrdU9OalhY?=
 =?utf-8?B?ZjZKcjdXdTc3Y3JGOUlvUE9yeldNMVZHWVo3QmQrYkNmVU9NbkNoUmdGMkRJ?=
 =?utf-8?B?MDhoSnhtbHU3VnBrelFQU3ZRN1ZKYlRLa1YvZVNLTElHd1JGRUFvSXRBakVI?=
 =?utf-8?B?OUNLallGQ2NQb0F6bkNTbjRJMkZqNXNwTzVYRm9MbkJKTDBrdlBGak1qY0ZD?=
 =?utf-8?B?OE0xR2pIQVJBK0YwUkdpQ1IzVUx6VnZCWlROc0FmUkJ2KytDTldVNTVUakJj?=
 =?utf-8?B?Z1FpNWRBSXVPWVZsaEdPT09xdlZHaHVUYTIyc0hiT3Bic01FU2k4bGRqNUZt?=
 =?utf-8?B?NDZsa0NRZ0JSaGhMd1BVdWxpclduUG85VkhMeURpU04zUm1Zb0d2cXVLODZS?=
 =?utf-8?B?Vm5kcGRWUFlxTUtIWXFJQnB6R1FFL29CKzhycTNVMlJwU1pQTGZYeHB3R2Ny?=
 =?utf-8?B?ekhCQktIUG1uS3pQcitSS3BzQ0k0TUkyUWY3Rk1zU3VkNkVxNmJ3dGVEQXN5?=
 =?utf-8?B?OXpFY0M5T004b3FZK3RydWg1RXB4cDM5Y0tLVFV3aGNLWDJybVU3UUhlVGh0?=
 =?utf-8?B?VlRncnpUWGVIa2VlSFJSY1JtZlc3eUVpN3p1UzBIWTBEUmIzdGo2dzNXY2hr?=
 =?utf-8?B?ZGk5VTdudDByOGVyNVZkVUtUVHQrcFhvM25uNWhSZDZ1bTdlSVByNFE2djJ3?=
 =?utf-8?B?KzVmMjlrQ2FCbGhpNzZaRXRoVFZYcnY3bGgzWmMwR1ZtaFdXZE9NWmtJTXJG?=
 =?utf-8?B?bnhUNFJ6S0p1OWJ1YkdvMStwK2h5TDRKcDJEYXlTcjFnMmJhUmZGK0Vjd2o4?=
 =?utf-8?B?YVRPbXJxRU95MmxKNkZXUFpjc2phQ3hFd29ZVWFkZDcySHpBa3psRzExVDRk?=
 =?utf-8?B?eHJEdEVhaTMxWktXZXZUenlMNWpZU08xREVBTE1GZEdiOEMvRE9DOG5LdHRq?=
 =?utf-8?B?eXZVM0Q4RXllNUJkNUpVVGU1d1dmTklZMG02NnFjWTQ3SEwvT0JyaGRaa0VF?=
 =?utf-8?B?aERQaUxyWGFZSlZ6cnh4RVhpRXNzeis2K0lMWC9aQWJQa2x4aGdXeFhyeURX?=
 =?utf-8?B?RDUvWW1idE50eXJwTEEveU5RYzhYcGdTWGtCVjFxM3ZUanE5SHZTempYdkF0?=
 =?utf-8?B?VkQzWGttSVpWQm5COVF2bVdTbTVxSTZyZlRjU1RHRXlkUVZlalMzZkVlY2Jn?=
 =?utf-8?B?M1E1Qzh0c1poMkF1dVZQd1lOQ2ZncXE2TXhIc2Zrb1F5NFpPMmFFSkQ5eE9N?=
 =?utf-8?B?WWVCTnRHNjBybVJKQlpGMHlLTE5FWkdzSG0yb2ZhVGRDZ0dMVkdmNzNYNHlK?=
 =?utf-8?B?ckRUZkN1NG1ESEFPclhtQk9aMDk5bXQya0FoeE1lQmtTcklmQWFwZHcrYjJ0?=
 =?utf-8?B?Z3EydmRJR214N2tzQlRGZ1AxZWhab2doSnk1aTJ3YVdtUEpUWGtIYzNWeTF1?=
 =?utf-8?B?REZETXp4cTBIcVZvUDRYcXVSY014ZDloYm5PNnRVRzJyM205SkJnQWpEaWdj?=
 =?utf-8?B?dFJZWjdFT2MwSDJQVVpkNU5SMnE0OUQ0WHNLbm5rWnRqZDNScHp1U09yUTVv?=
 =?utf-8?B?Ykw0VXo1ZlIzREpyVTIvek5rOU02bjk4TkxpQ1VZejBhaEloU1NOS3dxWmlq?=
 =?utf-8?B?cC95L1BTYWZaeWkvOWVYd0VnN0YzUkp6aGNPTEVkWmx2Mk9iNTJJM1JLZFpM?=
 =?utf-8?B?VVZpcksydERuZVhUcmJBZDh4UnZaTW1XWitwZ24raUxJYWNudG5HRGwwNkVD?=
 =?utf-8?B?S1UrZmxLZ2h4QXBzZHlHbXJEQ2ptb01HKzJQL29qQ0tNREpOWDI2ajVMM2NX?=
 =?utf-8?B?bS9lNGppdFFWcTFpeFhQYlU2SU1iYkc0bUdldFFxREREY2RSSGxvQTVGKy9h?=
 =?utf-8?B?RUE5c1pHcTNza0JTMHdwK2hYS010dzZ4RVBHUUo2OG8zam9pK1p6bndkS1Zx?=
 =?utf-8?B?MG40cS9WbmdrYnBDaWQ3dEN2em0rcXk2QnE3MDU3aHA3UFpVS2dYZFR2Yjlm?=
 =?utf-8?B?TVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3b5fbc4-5def-4fbe-5487-08dacc7c11ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2022 11:24:07.2936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z/VYlXAPEVKb/lLlQcTcuyWH0cQlMrEzh5P8BdJqFVpQthX6eKOv5cnJIfVs1GXy0Sk7xwhMqv4kTRsyjgCbLDlsYCfh/FaWinAU9uPFM0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6242
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1BBVENIIC1uZXh0XSBjcnlwdG86IGNjcmVlIC0gRml4IHNlY3Rpb24g
bWlzbWF0Y2ggZHVlIHRvDQo+IGNjX2RlYnVnZnNfZ2xvYmFsX2ZpbmkoKQ0KPiANCj4gU29ycnnv
vIwgUGxzIGlnbm9yZSB0aGlzLg0KDQpUaGlzIGlzIHJlYWwgaXNzdWUsIHJpZ2h0Pw0KDQoiV0FS
TklORzogbW9kcG9zdDogZHJpdmVycy9jcnlwdG8vY2NyZWUvY2NyZWUubzogc2VjdGlvbiBtaXNt
YXRjaCBpbg0KcmVmZXJlbmNlOiBpbml0X21vZHVsZSAoc2VjdGlvbjogLmluaXQudGV4dCkgLT4g
Y2NfZGVidWdmc19nbG9iYWxfZmluaQ0KKHNlY3Rpb246IC5leGl0LnRleHQpIg0KDQoNCkxvb2tz
IGxpa2UgdGhlIGNvbW1pdHRlciBvZiB0aGUgcGF0Y2ggd2l0aG91dCBidWlsZGluZyBzdWJtaXR0
ZWQgdGhlIHBhdGNoLg0KNGYxYzU5NmRmNzA2ICgiY3J5cHRvOiBjY3JlZSAtIFJlbW92ZSBkZWJ1
Z2ZzIHdoZW4gcGxhdGZvcm1fZHJpdmVyX3JlZ2lzdGVyIGZhaWxlZCIpDQoNCkNoZWVycywNCkJp
anUNCg0KDQo+IA0KPiBPbiAyMDIyLzExLzIyIDExOjA1LCBZdWVIYWliaW5nIHdyb3RlOg0KPiA+
IGNjX2RlYnVnZnNfZ2xvYmFsX2ZpbmkoKSBpcyBtYXJrZWQgd2l0aCBfX2V4aXQgbm93LCBob3dl
dmVyIGl0IGlzIHVzZWQNCj4gPiBpbiBfX2luaXQgY2NyZWVfaW5pdCgpIGZvciBjbGVhbnVwLiBS
ZW1vdmUgdGhlIF9fZXhpdCBhbm5vdGF0aW9uIHRvDQo+ID4gZml4IGJ1aWxkIHdhcm5pbmc6DQo+
ID4NCj4gPiBXQVJOSU5HOiBtb2Rwb3N0OiBkcml2ZXJzL2NyeXB0by9jY3JlZS9jY3JlZS5vOiBz
ZWN0aW9uIG1pc21hdGNoIGluDQo+ID4gcmVmZXJlbmNlOiBpbml0X21vZHVsZSAoc2VjdGlvbjog
LmluaXQudGV4dCkgLT4gY2NfZGVidWdmc19nbG9iYWxfZmluaQ0KPiA+IChzZWN0aW9uOiAuZXhp
dC50ZXh0KQ0KPiA+DQo+ID4gRml4ZXM6IDRmMWM1OTZkZjcwNiAoImNyeXB0bzogY2NyZWUgLSBS
ZW1vdmUgZGVidWdmcyB3aGVuDQo+ID4gcGxhdGZvcm1fZHJpdmVyX3JlZ2lzdGVyIGZhaWxlZCIp
DQo+ID4gU2lnbmVkLW9mZi1ieTogWXVlSGFpYmluZyA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPg0K
PiA+IC0tLQ0KPiA+ICBkcml2ZXJzL2NyeXB0by9jY3JlZS9jY19kZWJ1Z2ZzLmMgfCAyICstDQo+
ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NjcmVlL2NjX2RlYnVnZnMuYw0KPiA+IGIv
ZHJpdmVycy9jcnlwdG8vY2NyZWUvY2NfZGVidWdmcy5jDQo+ID4gaW5kZXggNzA4Mzc2NzYwMmZj
Li44ZjAwOGYwMjRmOGYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NyZWUvY2Nf
ZGVidWdmcy5jDQo+ID4gKysrIGIvZHJpdmVycy9jcnlwdG8vY2NyZWUvY2NfZGVidWdmcy5jDQo+
ID4gQEAgLTU1LDcgKzU1LDcgQEAgdm9pZCBfX2luaXQgY2NfZGVidWdmc19nbG9iYWxfaW5pdCh2
b2lkKQ0KPiA+ICAJY2NfZGVidWdmc19kaXIgPSBkZWJ1Z2ZzX2NyZWF0ZV9kaXIoImNjcmVlIiwg
TlVMTCk7ICB9DQo+ID4NCj4gPiAtdm9pZCBfX2V4aXQgY2NfZGVidWdmc19nbG9iYWxfZmluaSh2
b2lkKQ0KPiA+ICt2b2lkIGNjX2RlYnVnZnNfZ2xvYmFsX2Zpbmkodm9pZCkNCj4gPiAgew0KPiA+
ICAJZGVidWdmc19yZW1vdmUoY2NfZGVidWdmc19kaXIpOw0KPiA+ICB9DQo=
