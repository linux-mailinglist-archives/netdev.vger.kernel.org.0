Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DB6626DBE
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 05:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiKME6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 23:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbiKME6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 23:58:16 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2053.outbound.protection.outlook.com [40.107.95.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A006E0C5;
        Sat, 12 Nov 2022 20:58:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NzHtCZDAGWvANitl0clw85ztqKZ36AZ8nfXON1P+d6n4ELBF8e9n0F7JmIftrWanJ/85PIsb8tB8DTgmySDsRySzej82ejfMVQ5eH8vl2CuaPQbowWcqXYZ2iGq+A3NNQrMZx+s4DxgoxcdHOaz0i9jn1ABU8He/WSe4RY1RKhNwqGFu6gKcbbmcg7o2+mzQEGh7s7bcwIUz5iPPnXnq9UCAFxMXzBP7l3uKUZWnnkXeudMOCdSpWeY+zPN0llucaES7t6law8cFcKXG3kUgYtt9VGfAVGHa501QmHwKbJLxRQb5KFmer984+DI/9BTlwMT2XHZ8DMnELFHlyB9lng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+j2AFp5DaTotZ+dk7atPGG5aNdhdEdOibkt8n/R+Y3g=;
 b=ewFmfu+8TN9YZAiY89x1j/LanpEMNi6XcIFm/i6463/5XkR130LzAYfMK95MEAf2A6IAHhHSe0H1/Rz4NzGDKbdPXQHIaX4hBOurM00w2m3kLN6ji0nrZD5grWYa4QcdIp1hEmeABWe53nOLw0+JXjaRhuWpHzxilKFGLcsYn/FN4OmpaIAuQ5ChQHxj93U/5rQJISalFlv76EzhryZfj5cmgxGPSPFc3x1p5tlHdfgMD/wNEwe0/zoLfVZejbmC3VoS50Cs+jc5qFjehVn/XlWh79DY/EmJ3KCrAzyPED9sMtUkXA0udcEo6URDX4Vul1p+DYSXfqZ7w7ZIXZr2Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+j2AFp5DaTotZ+dk7atPGG5aNdhdEdOibkt8n/R+Y3g=;
 b=nATbH5QqcAbUsjkd138nkyvgCkrIOl1tWqcOcU4wX50pqH+QlR6FV30BUwQoLHfhRQZ8qT7Iq3Vipdp7PnwHbhYfKXP/OCrjDRIsZRx/ujbV7uQtoJSmLOi28vPOBruUbB+tRushUbnqV7KaQSSFuBWiCrjf0oc+w5BGuEwP+ynaP/yMJ2B5zKKwwa5DK42AzsMLEsQyd6ATn5VbYiduLqX7NAznilHy0BmSGGgXTgyejZfagqzLUMHRAk3fq6zsMZyVQ7zxfwHu8YPUINf3GNG/lGwDll9xwxdBTrBZsDdYuEfsYzrRqhEjS/ZFtQXY4E8J5wOYdJrjVfy1HgyYeg==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by SA0PR12MB7003.namprd12.prod.outlook.com (2603:10b6:806:2c0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Sun, 13 Nov
 2022 04:58:11 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::d756:c945:3194:629e]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::d756:c945:3194:629e%9]) with mapi id 15.20.5813.017; Sun, 13 Nov 2022
 04:58:11 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Yanjun Zhu <yanjun.zhu@linux.dev>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "leon@kernel.org" <leon@kernel.org>,
        "zyjzyj2000@gmail.com" <zyjzyj2000@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Zhu Yanjun <yanjun.zhu@intel.com>
Subject: RE: [PATCHv2 0/6] Fix the problem that rxe can not work in net
Thread-Topic: [PATCHv2 0/6] Fix the problem that rxe can not work in net
Thread-Index: AQHY2NgsxqGsQT8SNkWIqw44pMlMnK4V5FKAgCNW14CAAA/sEIAAAUYAgAM41mA=
Date:   Sun, 13 Nov 2022 04:58:11 +0000
Message-ID: <PH0PR12MB548101B6A19568A3E1FBD50ADC029@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20221006085921.1323148-1-yanjun.zhu@linux.dev>
 <204f1ef4-77b1-7d4b-4953-00a99ce83be4@linux.dev>
 <25767d73-c7fc-4831-4a45-337764430fe7@linux.dev>
 <PH0PR12MB54811610FD9F157330606BB7DC009@PH0PR12MB5481.namprd12.prod.outlook.com>
 <ef09ae0a-ad22-8791-a972-ea33e16011ba@linux.dev>
In-Reply-To: <ef09ae0a-ad22-8791-a972-ea33e16011ba@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|SA0PR12MB7003:EE_
x-ms-office365-filtering-correlation-id: 54ed06ef-3562-4f02-0899-08dac533a9fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MEv6P2w8G+h5PvSYIcx8HDNkx22gc00XmsG4KvWIdIdHeGXNAROaX35RzCI6o2pzXHa9kpcXnOO645xmwsb1AAAM7nRoY36nzRXIiB57GvVBnBy1cSzWOmic7CuzkoG4WIIrekgfe1ZDqeIxiQ9Z4Oa83pjt+qENjAz5oDioa1UHwMOoO9bevy+HioNw4N3fPf8t1hEdQYptUWnz8TN3UZqyyDAOZ57diVDMr4JBGc5ro7dMJ7+7Ebg+T8lGPgZbYIm/T9EDNyGVY/SVwGB4gzkPcke8pss2aRcqEyfopVN0pE4/45KXblrM45Y40R8STThgWR2kgWxiMBqflz5cCXPK7mkwya7EAtNKvwItzbLBFxodDdtj4ZCovobElfV/snVSPbHpHXAa1C/kN/NtzlREzeSWBMURtN2vvnHtmkUF3sIpd0MEEkgJQ+G5Doy1+a30Z0jPX63diw59Mm3omAHatqMkSael7CY88Ygs/dt+aIqsbObZcdzkmF7AigErF/HBpW2ixdGLo8MgqE+F6E6uHGpBscw/jvD8M7XG8STXKhMkPAj451cd2+Z5lBmSe6oglm0ZM8eIHXVUzbH2wnyQi4Jl+NaTZgHZyV3gZSi9cUJW1ifrbyN0NFEVKy8HUeRBVAvSaWubN5ZNw0EJc8YilXlllaoQwK1SMi+u7ZaGxdv+FITaqtB3QaAKYxMUlB3OWil2kNEK0CwteuxklrOuTLm1RnvibMU0zXyP/+5aNeiJZfVX+1FBKeazTjiqxufnAbFyZR0GhbLzJnnwTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(84040400005)(451199015)(66446008)(76116006)(66946007)(66556008)(66476007)(64756008)(38100700002)(122000001)(52536014)(2906002)(38070700005)(8936002)(8676002)(4326008)(5660300002)(83380400001)(41300700001)(71200400001)(478600001)(9686003)(33656002)(7696005)(6506007)(26005)(110136005)(186003)(316002)(86362001)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3RwUjRBOERlTEJock1VbzhkY1VoWXBTbE1jZC9UNm5WS0JJbFJSWkg2RzlN?=
 =?utf-8?B?OXliSXBaTDBlc0R0dmRIRmQzMmR0dVFtMXdESUd5M3RyVzhCdXdnK1hXMjQz?=
 =?utf-8?B?TThPc0tES0lwVGRmTStHVUlPZWpXcmtJUklkQng0S2Y0bHE0UlBmWE13cXFu?=
 =?utf-8?B?VUt2OW1LSm1vVTFGUmlabmNUNmZ5aTg4RTY1amRzQkpBUnRLZ3VLNTVCeXVs?=
 =?utf-8?B?MjN6Z0UwK2tNakwyK3h5LzRhbGIzRThsTjl2TWFubFJXcnBpUmdRb3RmamFB?=
 =?utf-8?B?Mm93eTVmTTR2LzhuenkyVnpHQXAybnk5VG8xSU93cWFMRnE0OWN3SXVoQ3dS?=
 =?utf-8?B?ZTNpVU1icFE1UFFJUGJCWjVwVm5ZTVFqOGtnbTQ1UGRlblhodVhuZnVHYXFY?=
 =?utf-8?B?dDhidGdyQTQyaWxGbXJrT3V3VVhWMk9TWnY5UzFid2VhVTBKZ25vckNxRnM2?=
 =?utf-8?B?elJGa3NHNlZyL2IxSFhsNmNJRXBvdEpldkhQb2NvemFLR2YyWHVYNk9uLzBJ?=
 =?utf-8?B?ZU1kRGQxbFJ4MEZPdFN0a2Zia3VGVXZEUlo0aHJMUEdIL2FrUUJQZ0NuSFM0?=
 =?utf-8?B?Tm96R3Y4YWk5ME5vd3FhaSswK3Y0bTVoc3BqVlJZNUtxMmdheGMrUnBCcnZR?=
 =?utf-8?B?N3lPOGNtQWY2TmMycTB1ZjUxWXkySHJXQ29uN2k4dEdQWkd6YmNJU1BDcFBo?=
 =?utf-8?B?TFJ5OG9ZRk81ZU1FY0Z1NjV2aWY4Y1YvL2JHak4zUHJ0Z1Bvd2UxVnlrWXc4?=
 =?utf-8?B?VFNHaHJibjhzREY0S0s5LzdqOHdUNHptaUQ3L3lKNjE2cnpLNE9uNWE2MkJ0?=
 =?utf-8?B?enYyMjBsVU9VdGJmbkI0dDZMMk5QaE40L2xGVE5HVHk2QzFESDJ5Z1ZEZGVE?=
 =?utf-8?B?Zzk3SmhJTklDRkxYQUxrWDMxbXhxV1lNdlBTMmVGNms3VFdlMWNYNVFMbVFz?=
 =?utf-8?B?N1MybnRiMHNQRzVEZkZuQ0JiVWJLTnNuenhXd1JJVkZ3c0VSRkJFVS94NmEy?=
 =?utf-8?B?ekl4bzVGemNOdW9DTzZQSm1ieHVzVGhTYjNuQkEwQ2N2YVM2NkppOERKR2h4?=
 =?utf-8?B?cjFaamlONlQvd0JuQjNCMERNVXREaGVuanhibENDZTZ4V0ZzczlyV2poTW4x?=
 =?utf-8?B?RXFCMUJGRjhSOFJtdUdrVEd3RjVqaUhzYTY2TDVMVmJIeEpaUVQvVFM5UXhO?=
 =?utf-8?B?UDY5UEVFMmNmSzdMTkpXS2h5b24rMkVVd1VvR0FYL2hRTDY2Ujg1SDgzUlQ0?=
 =?utf-8?B?NHkxb1NGMFlESVBidC9PRHF1TC9HSGFlTU1BSktJZC9qYUdad1NsL3pWUlZu?=
 =?utf-8?B?ZG9rRHBYZXY5bXF4VVJNNmI2QVZQMktGWmh3ZmRPUHMzRk9jc2k0S3VMMlh0?=
 =?utf-8?B?VXhrNlo5emdZNGNuY3Y5cnhQQnRqYzB6MnI4UzdRZEh3elJjajFLS2pVTUpO?=
 =?utf-8?B?Z2E5YkxtMHppQXN5OTJLZzdNMit4c2NJcm44dHVvdjJ2ZW50RDdTY2ZYYm02?=
 =?utf-8?B?ZGFmZlQrZDZCbVc0N09USmFjU1dUZUFBMC9NZkUySTNIbUs5V05MSGxIUUtt?=
 =?utf-8?B?ZEFSUHZDYlhkR3ZKYmRoTktBd3g3ZDlZVDhlczUrSnFqZzZhQUdRS1V5ZmlL?=
 =?utf-8?B?ZDZ6UlFPSmlOK0djckl3dDlsNEdPdC90OFBTZ1ZNc2dWSnZ5L2ZWd0tXdjQ2?=
 =?utf-8?B?eG5SYmdRZmQrUlpMTE5nRVdIQm12aDN2ZndqZlpnRGNuY245N09adE9LRk9W?=
 =?utf-8?B?TU5aT2dFVnBTMWswRVh5NkYvc054Z0FhcGMvV1dWY3kvR1NqWGZyUzdvQlZB?=
 =?utf-8?B?a1VVK01JWk9pL01lWDV3WjhUT1k3YVJ4Z0FXZzkrM1o0V3hiZWQwSkViVy9L?=
 =?utf-8?B?czdsajNxOGtkSnJ6VTBQcndlNXViUjA2amRFNVFENlpwdHdDODA0TS96NWFY?=
 =?utf-8?B?UGVLTkNUQlB6Z29Kdk9rY1k2OExGWHpRc3Y5dHpqSDJ5TmNyeEp2U04rcEI1?=
 =?utf-8?B?Vm9Wdjl0M25FOHF4RDNBc0Q2OGNJVVcxR1hySmszWlRhVVQ1RW1mK2lNRmRj?=
 =?utf-8?B?RXpTeVZYMDliNmJvc1BTV0VRcnJoSmg4cU1mZ1FOU2dTZFlMRU1XcjF4RWov?=
 =?utf-8?Q?aav0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54ed06ef-3562-4f02-0899-08dac533a9fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2022 04:58:11.2061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LUbFIF86pq1Q/FTCJdyEh1ihYoT8sJEOTnRhORX3elUxB9ptucDlHsKzugZDBytc0MgF+pc4tNfjnPY8XJE7cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7003
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgWWFuanVuLA0KDQo+IEZyb206IFlhbmp1biBaaHUgPHlhbmp1bi56aHVAbGludXguZGV2Pg0K
PiBTZW50OiBUaHVyc2RheSwgTm92ZW1iZXIgMTAsIDIwMjIgMTA6MzggUE0NCj4gDQo+IA0KPiDl
nKggMjAyMi8xMS8xMSAxMTozNSwgUGFyYXYgUGFuZGl0IOWGmemBkzoNCj4gPj4gRnJvbTogWWFu
anVuIFpodSA8eWFuanVuLnpodUBsaW51eC5kZXY+DQo+ID4+IFNlbnQ6IFRodXJzZGF5LCBOb3Zl
bWJlciAxMCwgMjAyMiA5OjM3IFBNDQo+ID4NCj4gPj4gQ2FuIHlvdSBoZWxwIHRvIHJldmlldyB0
aGVzZSBwYXRjaGVzPw0KPiA+IEkgd2lsbCB0cnkgdG8gcmV2aWV3IGl0IGJlZm9yZSAxM3RoLg0K
DQpJIGRpZCBhIGJyaWVmIHJldmlldyBvZiBwYXRjaCBzZXQuDQpJIGRpZG7igJl0IGdvIGxpbmUg
YnkgbGluZSBmb3IgZWFjaCBwYXRjaDsgaGVuY2UgSSBnaXZlIGx1bXBlZCBjb21tZW50cyBoZXJl
IGZvciBvdmVyYWxsIHNlcmllcy4NCg0KMS4gQWRkIGV4YW1wbGUgYW5kIHRlc3QgcmVzdWx0cyBp
biBiZWxvdyB0ZXN0IGZsb3cgaW4gZXhjbHVzaXZlIG1vZGUgaW4gY292ZXIgbGV0dGVyLg0KICAg
IyBpcCBuZXRucyBleGVjIG5ldDEgcmRtYSBsaW5rIGFkZCByeGUxIHR5cGUgcnhlIG5ldGRldiBl
bm8zDQogICAjIGlwIG5ldG5zIGRlbCBuZXQwDQogICBWZXJpZnkgdGhhdCByZG1hIGRldmljZSBy
eGUxIGlzIGRlbGV0ZWQuDQoNCjIuIFVzYWdlIG9mIGRldl9uZXQoKSBpbiByeGVfc2V0dXBfdWRw
X3R1bm5lbCgpIGlzIHVuc2FmZS4NCiAgIFRoaXMgaXMgYmVjYXVzZSB3aGVuIHJ4ZV9zZXR1cF91
ZHBfdHVubmVsKCkgaXMgZXhlY3V0ZWQsIG5ldCBucyBvZiBuZXRkZXYgY2FuIGNoYW5nZS4gDQog
ICBUaGlzIG5lZWRzIHRvIGJlIHN5bmNocm9uaXplZCB3aXRoIHBlciBuZXQgbm90aWZpZXIgcmVn
aXN0ZXJfcGVybmV0X3N1YnN5cygpIG9mIGV4aXQgb3IgZXhpdF9iYXRjaC4NCiAgIFRoaXMgbm90
aWZpZXJzIGNhbGxiYWNrIHNob3VsZCBiZSBhZGRlZCB0byByeGUgbW9kdWxlLg0KDQozLiBZb3Ug
bmVlZCB0byBzZXQgYmluZF9pZmluZGV4IG9mIHVkcCBjb25maWcgdG8gdGhlIG5ldGRldiBnaXZl
biBpbiBuZXdsaW5rIGluIHJ4ZV9zZXR1cF91ZHBfdHVubmVsLg0KICAgU2hvdWxkIGJlIGEgc2Vw
YXJhdGUgcHJlLXBhdGNoIHRvIGVuc3VyZSB0aGF0IGNsb3NlIGFuZCByaWdodCByZWxhdGlvbiB0
byB1ZHAgc29ja2V0IHdpdGggbmV0ZGV2IGluIGEgZ2l2ZW4gbmV0bnMuDQoNCjQuIFJlYXJyYW5n
ZSBzZXJpZXMgdG8gaW1wbGVtZW50IGRlbGV0ZSBsaW5rIGFzIHNlcGFyYXRlIHNlcmllcyBmcm9t
IG5ldCBucyBzZWN1cmluZyBzZXJpZXMuDQpUaGV5IGFyZSB1bnJlbGF0ZWQuIEN1cnJlbnQgZGVs
aW5rIHNlcmllcyBtYXkgaGF2ZSB1c2UgYWZ0ZXIgZnJlZSBhY2Nlc3Nlcy4gVGhvc2UgbmVlZHMg
dG8gYmUgZ3VhcmRlZCBpbiBsaWtlbHkgbGFyZ2VyIHNlcmllcy4NCg0KNS4gdWRwIHR1bm5lbCBt
dXN0IHNodXRkb3duIHN5bmNocm9ub3VzbHkgd2hlbiByZG1hIGxpbmsgZGVsIGlzIGRvbmUuDQog
ICBUaGlzIG1lYW5zIGFueSBuZXcgcGFja2V0IGFycml2aW5nIGFmdGVyIHRoaXMgcG9pbnQsIHdp
bGwgYmUgZHJvcHBlZC4NCiAgIEFueSBleGlzdGluZyBwYWNrZXQgaGFuZGxpbmcgcHJlc2VudCBp
cyBmbHVzaGVkLg0KICAgRnJvbSB5b3VyIGNvdmVyIGxldHRlciBkZXNjcmlwdGlvbiwgaXQgYXBw
ZWFycyB0aGF0IHNvY2sgZGVsZXRpb24gaXMgcmVmY291bnQgYmFzZWQgYW5kIGFib3ZlIHNlbWFu
dGljcyBpcyBub3QgZW5zdXJlZC4NCg0KNi4gSW4gcGF0Y2ggNSwgcnhlX2dldF9kZXZfZnJvbV9u
ZXQoKSBjYW4gcmV0dXJuIE5VTEwsIGhlbmNlIGxfc2s2IGNoZWNrIGNhbiBiZSB1bnNhZmUuIFBs
ZWFzZSBhZGQgY2hlY2sgZm9yIHJkZXYgbnVsbCBiZWZvcmUgcmRldi0+bF9zazYgY2hlY2suDQoN
CjcuIEluIHBhdGNoIDUsIEkgZGlkbid0IGZ1bGx5IGluc3BlY3QsIGJ1dCBzZWVtcyBsaWtlIGNh
bGwgdG8gcnhlX2ZpbmRfcm91dGU0KCkgaXMgbm90IHJjdSBzYWZlLiANCkhlbmNlLCBleHRlbnNp
b24gb2YgZGV2X25ldCgpIGluIHJ4ZV9maW5kX3JvdXRlNCgpIGRvZXNuJ3QgbG9vayBzZWN1cmUu
DQpBY2Nlc3Npbmcgc29ja19uZXQoKSBpcyBtb3JlIGFjY3VyYXRlLCBiZWNhdXNlIGF0IHRoaXMg
bGF5ZXIsIGl0IGlzIHByb2Nlc3NpbmcgcGFja2V0cyBhdCBzb2NrZXQgbGF5ZXIuDQo=
