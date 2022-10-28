Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B03E61093D
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 06:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJ1ERb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 00:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJ1ER3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 00:17:29 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2112.outbound.protection.outlook.com [40.107.114.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADEA140E52;
        Thu, 27 Oct 2022 21:17:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WnIYDCQjRW9eUl92io3qquYPhAYCNeKnVokzCqR+vH/Kh4F4CMUJPkzP6K3RNiPid59XM5PitbY/spMk9Rxpa/SPrFPqgwrWDwfGRHl0Lmmzt4EvO/ERMpJcpY2q9RqwIbo+wvbqxcOMOWe5wIMYZHEydLFq7fQKYgh0i8/710GGLQXFIQjOph37R7XhdSt9yH48G/vXq3jRc7D3pj5Ga7ssgO4nPLfVD7hg3QE1uIB7sB6oos98sxJ91Unt/c3j5IbDNBKC70iFDcPVwNnod1yzcCMjyrkCygoOFGQ9WPm496l2RZmgr2Um0U6aj1mPT20Nrf+PNlD8cKCE16fPCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZT2VRhtpszxPVyHyKYzdct0xdryUWY4NQfCmydokj0=;
 b=EUv0/o07VhZSDVWt1LrnWoOil1hTLdez8oQbm4iCD8nOiETDYzILd+nVqYtR8NPA+XCagSu3uJnYZMsIoXiepBecxQ+7shcXz7KaFnLcE9XQwj0XEZ5Z4TuvhAdkjXxnxxa1S5ZehflcQgF0ldE/1ft8SWETPxLVtjqUsBBCJx19m2u3NKjJDlzWPvO6D2tmSYMURFvQrAqBaMIkINZfoZz/hZLUVQ0as2OaqwTOPgr7LvVQcKrz71lHe01GMooVIOIBoTNdWJYUhcVMDYrqrkyrpLB6QxExfjBnbrG1AZKin3qOzDBkEOH8mSojIdHQbfw9T0i6Ira/o56c3i6iyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZT2VRhtpszxPVyHyKYzdct0xdryUWY4NQfCmydokj0=;
 b=f/RVQjH2wXbaWtyWy531PqzGIlDPGghMTm4F2IHeyHrTZ3icVQ2nMTjNs2+eMvoV6sptTTIwqhbJ3XNWG8KAXY8iw74o/D56Vsl50+EDW9VfdJ6TN1uLhLjFdTgQTtr8ywjxuW/K3EBqnW/LYfPCbUtQTbrENnaR0gse3qxE9JM=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYYPR01MB10611.jpnprd01.prod.outlook.com
 (2603:1096:400:30b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 04:17:25 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::e28a:8db5:ee6a:34a8]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::e28a:8db5:ee6a:34a8%9]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 04:17:24 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v5 1/3] dt-bindings: net: renesas: Document Renesas
 Ethernet Switch
Thread-Topic: [PATCH v5 1/3] dt-bindings: net: renesas: Document Renesas
 Ethernet Switch
Thread-Index: AQHY6gm+xBB6u4E/4Eus7e8xfQY/Cq4jBQaAgAAu59A=
Date:   Fri, 28 Oct 2022 04:17:24 +0000
Message-ID: <TYBPR01MB534186DAE4EE2599520865E4D8329@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221027134034.2343230-1-yoshihiro.shimoda.uh@renesas.com>
 <20221027134034.2343230-2-yoshihiro.shimoda.uh@renesas.com>
 <bb23a9e0-1264-702e-a646-8de5afedb23e@linaro.org>
In-Reply-To: <bb23a9e0-1264-702e-a646-8de5afedb23e@linaro.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYYPR01MB10611:EE_
x-ms-office365-filtering-correlation-id: 4d8ecb2c-b910-46c0-72a2-08dab89b514c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u6Q0+aBqZbjHy4jl65fjWJ2/vYMsAyyW/0PyEIsmqLXWRYXtVn+WkYUNTpPriOek3kTeA7aEoZm2QZpWV1zV0nygso7iwr7KpSasOb1PQrC2ceM6cgk3JBfD7gaQkPlRRg5xPh0go3lVbZuMhuhrIEqTg5rqyEcNlh2b7+1mAkO33pw/Oh0W4AFuJFU1t+OpzFewsd/tbqA0llZVGuZJ7pAfQmumDCmJ7PuUQSnvOWGts6pBVUwNDwHFrgv5jcBYPqDna9+1ngzhxWM+zw9yWU6AtZik6EFmGahBd34RjMQiC2Icux/72N0GDwYoxHYbwxNLARWIuyd7Ljduwt0gYTTVXRvjFYIchTNV5PWBdhKrgwbW0LNVcQoueYl6pqezN7uy5Ugohl6V4x7mxEpy2AyuIWlMYkdHj8A+5EJlVOeAyO4cqA+rC1aaF2xDUTNLqzRGy8Mjn3ZLhOUV9MWzH0vU9c0QbmcPVDLOBMauprmGWq2Y/bG/dHQm5WH/Hf68vwI9DGFHsRm8Syh2UbHFkfWcEmhISbtcx4oitG0qqyNCHsd+VXBxIa8i+lZiF/ZPg2GPAswqwrXocPkyi8+4dSdA0XuXK209ZGD+AayrDtXQWTQvQ0nx4B3PdQfSxIMfXAkJsP+ZCmYxYbflU/Q/sSS+vm7+BMUjfjdqAHxCBn2dON7E5j4lblJn/CRg5+nVSrI1zXsgYNsoOFzbD7K1WGiCk7nulCD7D8/eUnhX/z4sqPdr39p7i2QKVJu1YdQxuPDsPOUuHBJZcgj9kpv1/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199015)(66556008)(2906002)(71200400001)(66476007)(64756008)(66946007)(55016003)(110136005)(66446008)(54906003)(33656002)(316002)(8676002)(4326008)(122000001)(53546011)(52536014)(5660300002)(8936002)(7696005)(76116006)(7416002)(41300700001)(38100700002)(478600001)(86362001)(9686003)(83380400001)(38070700005)(186003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KzQ4QmNPQlJuUkdraDdlQ3RacEIwSEY2cFdmUFlQSm1MK2lkWG12YkNJaHpv?=
 =?utf-8?B?M2NjdXEyOTgyU1Q1L0pza3pyWitJa1lCSXArQTViRFhuRXpmck5remorUTJw?=
 =?utf-8?B?Mm13ditUQlIxY3Npd25qUWw3MkVaWnRkUUwzSmVnV3NKUnZwNTlSQnFIN3Za?=
 =?utf-8?B?aDdkdDQybXNPMThyTlJianVnak1ja2wxbXRmTkNDNjl0QTdyTXNFbGV2M0sx?=
 =?utf-8?B?TGFTbTlvVDhsMWhiUDZVSEs0akVuMUEwVTcvcnZCN0NSNDFQQUVIL0VsWUlK?=
 =?utf-8?B?YTFGVHNjYWNlei9VS3l3VFZrOTlnOVQwRDM1bVBVelZvamN5dWF3bWlhTWxF?=
 =?utf-8?B?TlMyQ2NETnFKSXgvUW81MjE2VlBoMFNuTEJHY2dBc21rS1lrYm1FU05Qd0NM?=
 =?utf-8?B?YW10SGRORTNVUTlqZnlCVjBlMDFXMlphMlVibkQyeWtmZlIyMWxYSXREU0hX?=
 =?utf-8?B?enlScU14clhIWkVlekpLZGIzWTRpcHI0Y0pFdmx4RnRRbjVHSEVLS3JkMDVB?=
 =?utf-8?B?Q2loaHVPZWpTZ3I1L01aOElWcTQ3MkFqakFyeFB2RW9yK2plMjE4NXJMcHhC?=
 =?utf-8?B?MXdQalFzRVRCd0FIVjg3MU83RGxMZU0xZGVwb0R6VXNHZHJYMXB2U1pGajdp?=
 =?utf-8?B?ZU0rTFg5Y3BEb1BLN1pxWGFKMjFZMC9iOUkzcTZxakZOVjh2VjVEdllNYkhl?=
 =?utf-8?B?dVZLa25iYXUvQTNkejRFUmhlWE5ZZys2THFsZTBGT3oyaVFsYXRMeDFhZTFB?=
 =?utf-8?B?cTJLeVNieU9saXZsaG1kSGVrdWVRTEpZM2ExS0ljRklqYnEyOXRIbEhBWTUr?=
 =?utf-8?B?QTdjWGU1MzNqSU9GUm1OMHVsUzFNQU53Y2JMU3AxWXRPK3E3aTNjeU9KQUZT?=
 =?utf-8?B?RlZvWDVyUHN0Nm53ZWpMRXBWY0pBRkUvNzIrOHEzK3p6dm5laFQwVitwRHZx?=
 =?utf-8?B?TFZ4aDZYa09FRUJFRGFBblZ1YUtlQ3lLQmR6UkFRMHZBNE13UHhhODRYamRp?=
 =?utf-8?B?YnBYWmhYUXhwcXFPR1dtdHhBMDl4WGMydVhxVTZhQ3JpQmxhNHJLVXRKUDVH?=
 =?utf-8?B?V0g3K0ZFZytUaWYvMFhIWk5IWkVjU0VoT095bUcwR2d3Yk94bk9qeWVzSnZh?=
 =?utf-8?B?N2VjaXEzdWJwV2JyVitDZzB6VTlkNEU0MFpreU9uUTdSbG56RUVmNk5kOTlD?=
 =?utf-8?B?SXlKTVc1TEQyNEg5QXBuK2UwQm03a0NCTU9oOTd5Z01VdzBvMzd4QTcxbzEv?=
 =?utf-8?B?UWNpNVlxemV2TlRaR2dWS2QwS3hCeXREOHVTY01kdVBvWGUvbHFmNGphSWt4?=
 =?utf-8?B?ZGZkZWxoUlVQR2tldGdBdjFzU2VDNlRIbGc2bUlhdTFsL2NocXQzVFE1aWQ1?=
 =?utf-8?B?NzRjbERQMFFZQUF5aTRrWi9WZnM0cU4yOE0wbXEzNTYrdjlwdWJnOTQyLzdV?=
 =?utf-8?B?K0pTYllHaFNYSEc0R0E0NTdpUmZCd3c5NmI2VUlFMS9icWd2a2w1aGNPTkha?=
 =?utf-8?B?OTZKdElRWEUrdEQ2TDkrMEE3enNDVnlRUnZHYkdZWG5NbE5qd0V5SFhJMjFo?=
 =?utf-8?B?VUtVYXZyV3NjZGdZY0hRZjVzdURxbWgrM0V5VDBXUzhGQ3MvVkZSa1lkeE9p?=
 =?utf-8?B?MmNmdXhhRlQzd1BuTWtQelpSb0dGcmthMWcrMlQvVUxmaDR1NTF1elgydkhN?=
 =?utf-8?B?dmdLL2JvdElYRkdkd3VyZnNZci9aOVQ1S3QxSE03Qjhaanc4RGk1MXJFWEhu?=
 =?utf-8?B?S3RkV2xsWmQvcGY3aVQxQ0RwMVBDb2R0eWxCdU1pclJMVm1DNlltWGJLbC9a?=
 =?utf-8?B?ZVB3UEoyc2h6N05Bd1pTb1B5MmNzblhhdEVqcVZ5SDZwcUp3K2JsS01ueWgr?=
 =?utf-8?B?TzJoVnVUWm56NkpLQXFiTTNiZy9DeGFhbEp5T2orNXJodUJnRkViNUZsek84?=
 =?utf-8?B?a0srUjJWUEVwUE4rRDVTL0Q5anh5WVcyTGlNUldSM2hmTS9GcVRwbHRBS1o2?=
 =?utf-8?B?ZS8rYjlEbFRMS3JsM2E3cG41WjlIc3pBcWU1R0VHMmNsdzlLQkFwczJWWmh0?=
 =?utf-8?B?NFBwOFVkcU9KVzlmcS9KUk5mVithR2wrdit0dU1iQ1E1ZXl1YVNUOGdXN29Y?=
 =?utf-8?B?R2JxTTJYZFpYclljNm5IT0g4cjJLN0gxRFFSdGlLa1VNTzRtOXhzQjl5dnFT?=
 =?utf-8?B?Uk9obGFRV21jd1ZQZHdoalVtZjRaSldvcFdUMnM0R2RaQWFkNXNsNm5GK2pB?=
 =?utf-8?B?TG9tUU9ZQXhPN3U3c1hDT2FLa1ZBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d8ecb2c-b910-46c0-72a2-08dab89b514c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 04:17:24.9284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MKElx+Ug0GjDSgOZkrIfKpsIFG2UaJdULBMGKxOCuCx0c6WCvoRxoEjdIeE5fsLP5vzmiDbR3fehPupdTpNckkYZK7JMCCUgHFiVkm//If7AxYJhQZ7hcOu8qQ6MmQ10
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB10611
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgS3J6eXN6dG9mLA0KDQo+IEZyb206IEtyenlzenRvZiBLb3psb3dza2ksIFNlbnQ6IEZyaWRh
eSwgT2N0b2JlciAyOCwgMjAyMiAxMDoyOCBBTQ0KPiANCj4gT24gMjcvMTAvMjAyMiAwOTo0MCwg
WW9zaGloaXJvIFNoaW1vZGEgd3JvdGU6DQo+ID4gRG9jdW1lbnQgUmVuZXNhcyBFdGhlcmVudCBT
d2l0Y2ggZm9yIFItQ2FyIFM0LTggKHI4YTc3OWYwKS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IFlvc2hpaGlybyBTaGltb2RhIDx5b3NoaWhpcm8uc2hpbW9kYS51aEByZW5lc2FzLmNvbT4NCj4g
PiAtLS0NCj4gDQo+ID4gKw0KPiA+ICsgIGV0aGVybmV0LXBvcnRzOg0KPiA+ICsgICAgdHlwZTog
b2JqZWN0DQo+ID4gKyAgICBhZGRpdGlvbmFsUHJvcGVydGllczogZmFsc2UNCj4gPiArDQo+ID4g
KyAgICBwcm9wZXJ0aWVzOg0KPiA+ICsgICAgICAnI2FkZHJlc3MtY2VsbHMnOg0KPiA+ICsgICAg
ICAgIGRlc2NyaXB0aW9uOiBQb3J0IG51bWJlciBvZiBFVEhBIChUU05BKS4NCj4gPiArICAgICAg
ICBjb25zdDogMQ0KPiA+ICsNCj4gPiArICAgICAgJyNzaXplLWNlbGxzJzoNCj4gPiArICAgICAg
ICBjb25zdDogMA0KPiA+ICsNCj4gPiArICAgIHBhdHRlcm5Qcm9wZXJ0aWVzOg0KPiA+ICsgICAg
ICAiXnBvcnRAWzAtOWEtZl0rJCI6DQo+ID4gKyAgICAgICAgdHlwZTogb2JqZWN0DQo+ID4gKyAg
ICAgICAgJHJlZjogL3NjaGVtYXMvbmV0L2V0aGVybmV0LWNvbnRyb2xsZXIueWFtbCMNCj4gPiAr
ICAgICAgICB1bmV2YWx1YXRlZFByb3BlcnRpZXM6IGZhbHNlDQo+ID4gKw0KPiA+ICsgICAgICAg
IHByb3BlcnRpZXM6DQo+ID4gKyAgICAgICAgICByZWc6DQo+ID4gKyAgICAgICAgICAgIGRlc2Ny
aXB0aW9uOg0KPiA+ICsgICAgICAgICAgICAgIFBvcnQgbnVtYmVyIG9mIEVUSEEgKFRTTkEpLg0K
PiANCj4gSSB0aGluayB5b3UgbmVlZCBoZXJlICJtYXhJdGVtczogMSIgYXMgbm8gc2NoZW1hIHNl
dHMgdGhlIGxpbWl0LiBJIGRpZA0KPiBub3Qgbm90aWNlIGl0IGJlZm9yZS4NCg0KSSBnb3QgaXQu
IEknbGwgYWRkIGl0IG9uIHY2Lg0KDQpCZXN0IHJlZ2FyZHMsDQpZb3NoaWhpcm8gU2hpbW9kYQ0K
DQo+ID4gKw0KPiA+ICsgICAgICAgICAgcGh5czoNCj4gPiArICAgICAgICAgICAgbWF4SXRlbXM6
IDENCj4gPiArICAgICAgICAgICAgZGVzY3JpcHRpb246DQo+ID4gKyAgICAgICAgICAgICAgUGhh
bmRsZSBvZiBhbiBFdGhlcm5ldCBTRVJERVMuDQo+ID4gKw0KPiANCj4gQmVzdCByZWdhcmRzLA0K
PiBLcnp5c3p0b2YNCg0K
