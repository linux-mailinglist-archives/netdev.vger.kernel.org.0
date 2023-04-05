Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E271A6D8484
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 19:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjDERGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 13:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbjDERFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 13:05:03 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3F96A4B
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 10:04:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWUY6KaPfBbJBqnUBiJjatedHo1sU5rYbHszG8B81eAJixNbjqoFFls2HLXOGCT8AyKQacfbZYmbjCmVcJwV1yftF1PQGdaSVyeebV5DVuWzh5KsmEGlRMNXVoXz3XIOnTXbrk/KxqEdQQ+7cbmdFiGPk2kObhaBeHkSHzcLhfTlu7xaK/+Z6F6u01TyG0aYYoVAXVRMJ4hLzzW/ybSBAjlp/mXLOgzrQB+KhbT44cTJW5syaoL6N978YCaE0LCI4x/BOuRTZbvNG2TCIlhAIixCx7mrFFI7Vy4rr+6vw/ITwnVIAgo4U0I5wT4hAWkHsFlnfAme4/EW8avSpL5wrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T+x7+6eS2S7nRNOTStfTLQssIo9TjoH5IemzT6kky0I=;
 b=AEqWh1JK6u0huSRHtM7IzkTscgjYfBa2T6rWjS6zJ+FEyKmjMf9bXlbCn1V+cy5ozUMXGt9PCTyz+8qimEutFs5OplTdG3yTZVkABcxjAALkyc/bc1WIbasX+7QyCagyV3CpFjE7wAik/Vt+rP/b9iBx3zn5whqgyxyPIlqKjxUZgGvDZhrxhkP/Y0WZmgwCbYbP8N+7/fORHr/Oqkh9zyIRSreEWhHUiPVEaq4nK+VdA7Aqpatd6FWAo8SJDKA/xaC3xZQ38yb32vVMbjdE+5uRpxj19UCNhIadvVKJGiBATYj1vHhwYxZnozzraSdspMpgIqln4vI3DLxgLCBQRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+x7+6eS2S7nRNOTStfTLQssIo9TjoH5IemzT6kky0I=;
 b=cvD+wBTlLu0Imf3zJMODOwDAsaWDEsUU5YRm4sw7L2Ytjj9AIOC2tC4xuMLIOyiUGr0fAyqu20hS1usB2GQYrGMKprrYlCcwQhWd4rG8YPw9xDGK0rPtsd96x4hQSsXqI9qSd7aSWvOFHkjSFA74wTLc8UKmLuwHAoYjhvdjYeoiH2NfSQFtVxk0sHFNcr6PJC9O2p3tHAVaEBDLnyPDl7g5WDgG3Hs3GsbkPWM9GSGaWS6D+wc0mOQRY6xmkK1yLyicuL1Ae1W3CUnaTedH39RoRFYWWjh04jme1HDUCABGE9g4WwCTwh2Q/agXx5WCimCTaKQnc8HwgXDK9Kj/YA==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by CH0PR12MB5332.namprd12.prod.outlook.com (2603:10b6:610:d7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 17:04:43 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::2789:effe:233e:cc9e]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::2789:effe:233e:cc9e%9]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 17:04:43 +0000
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "hawk@kernel.org" <hawk@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>
Subject: Re: [RFC net-next 1/2] page_pool: allow caching from safely localized
 NAPI
Thread-Topic: [RFC net-next 1/2] page_pool: allow caching from safely
 localized NAPI
Thread-Index: AQHZY4rF1fM8mIADykKF5InmX6+dOK8ZUr4AgABhtICAAAcIgIAAHFWAgAMiiAA=
Date:   Wed, 5 Apr 2023 17:04:43 +0000
Message-ID: <3da1da0972c6c6af1fd4db2e4227043fab78e37f.camel@nvidia.com>
References: <20230331043906.3015706-1-kuba@kernel.org>
         <ZCqZVNvhjLqBh2cv@hera> <20230403080545.390f51ce@kernel.org>
         <CAC_iWjJiTddh7cKo-18LGGE+XQS_H8B5ieXLW6+uSq6uBNPnDw@mail.gmail.com>
         <20230403101219.59a83043@kernel.org>
In-Reply-To: <20230403101219.59a83043@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|CH0PR12MB5332:EE_
x-ms-office365-filtering-correlation-id: 3ba5626b-1e34-4871-5444-08db35f7d9ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v7/WYJ52skEtZivKHYAKQUvb3wiTJnKAlG1eT5W2PXtgeZERlYFphM4fK8EYa4IsXHflBPVDjNRY/NrQKAfAJ5Aw4AAHg+j4k8q7GaCqG1qTh6Z/342TNT1x6M52ltCrF/tgpcsWHcOA5h1ruUDp3s1Nm7td8dfFawDDCVjmm6pTSPUGgL8u8F4SH82xPW9j+MWVIUGgBbt6kSFofphj/jhSR+FLNYcvmYvsE1lGL4/V71BgSidc1DMI25KbfeFJo8ZWCKoaBONhv9aEW4xiEoPLMxrbzi3PMKLa0MM0rjMjjfJdJ9ABeRhJRP3YdR/4F3UWKGX/QPiOSIt8oUWUDMhKbyAIlG2KnpOWljzZt2IV4I0pZtKNlYK36jjDFXd525DTQvBvp5zqUPS7NVQ2+Rp/xkmRYweUtBg0AmsYBgnGJYqbjAvQWYvyQVC9KFRBVuD3o5wE3mvoCSyFd6IOp1eeRnWv4cYaMNY3h4u8A6BJz/KQDenI2Jtfd29p0rnKlU3sykN4QGtcpD1s0k5pZhGNREckFtKWUWE5bE64yMXV5y036qourf0brcl9ypDYHtPJAW2JRQWXcDJCmTpP5ONEnJKtfr8LPMOuA72wbEFdwmIKfWd1BrkjZ41H0cAY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199021)(122000001)(76116006)(66476007)(91956017)(8676002)(64756008)(4326008)(66946007)(478600001)(41300700001)(66446008)(66556008)(316002)(8936002)(54906003)(38100700002)(5660300002)(6916009)(83380400001)(186003)(71200400001)(2616005)(6486002)(6506007)(6512007)(86362001)(36756003)(2906002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1J0WFZqTHNFSDBMTXdEdktQTnhvdDcvd1podTdiS0xOa3ZTNHlJWS9xNlVR?=
 =?utf-8?B?dUZxOTM4QmRnZDl5eGFraGpuRmVRT0RTZUZWRVB2aStuOGN5R09iUThQRXNU?=
 =?utf-8?B?L1loVnJVcVJuU29OT3M1bm9RR2p6d0RiZll5SDhzby9oZlo5T2psTU16RGpW?=
 =?utf-8?B?eEplejMxRHc3SnRzY2lnd1JvSlJ3cnp1aGlpTEVKM2hMTW9uNm9GSENWUHhG?=
 =?utf-8?B?SFhjTGNrNUJ1czlRRUxJS0xZby9KRzZmdWtaMm5mZTJucDhQSGpHZlZKcnpz?=
 =?utf-8?B?TTRDVzNWK3doVmsybnlmWjhxRjdhSWJNU3NINFBJbVplcnFoWXNSYVVueEt4?=
 =?utf-8?B?SEtpUVFmQktZcFZTQ2dWalhrLzI3ZTMxV3JtdG8weE9WdXZCWUM3ejNXVGJ2?=
 =?utf-8?B?ejl2aDZpMld2YWw2Y3JNc0pVQnhPaTFtV1hUR0wwK0dNMjFRQ1lnbUw5WWNq?=
 =?utf-8?B?Y08rY0o4Z1JBZkZNNG9TcFNORHRKM2oxM1JBNlh6MVN3NGpIL00rYzRCak9G?=
 =?utf-8?B?Zm5qZWdpbWRwQ0ZiQnVJRlZGRy9oOUJnREpxb3FKc3NhbzMwTWNLamFJVExM?=
 =?utf-8?B?MlQrOGtYM0lIZmhmNmNwaCswUUtIb21jVExqQTFXZmE3SHVxMHY2RnoyM3B3?=
 =?utf-8?B?UTkzMTVLUnU2WjRiREhleDYwWTBJWWo2SGl0cUxTNTgvclVGNmdwa2FqTUhu?=
 =?utf-8?B?bHRpK2JJQ2tkZjVEQ00rTkNSWllRcXU2RUQvN0xhek0yVU1Hb0x2UlBHSDlw?=
 =?utf-8?B?L1NQcjlFNjdPUXRvcGx1OGQ1d25WSHNkU1VUTWhpRWRpeTZSTUZpWG9yL2NF?=
 =?utf-8?B?Z1o2THU3aHJuSW01L05Dc1FHTm5xY3kvQTdpa1d6UmlCdC84LzdXRnJPWGZD?=
 =?utf-8?B?bElUaExzaHUra2RFMTZ4OW54QTRCYzhEdHN1V2k1ekhneDA3SlR0WDhKZms1?=
 =?utf-8?B?eGhCZVpjRWNHTDlTSlNNZytGbUxaVkVMQ0g2S2xVWWROSW5wNlpMR3IyV0x0?=
 =?utf-8?B?QjJLV3FoS290bWUvd3F3WndlN0l3dCtReEtGSThlWDBUVjU3TmxXR1MwWjBY?=
 =?utf-8?B?ZSsrbWwvRGZqUlUycm5paXR1UDkyK0NGdHZVNm00NnBMS21uRzBwNG1tT05R?=
 =?utf-8?B?cDBVd3Vxbk1zbzhtcVM2WER3SjdkSSt5S3BROXppU0pidEpVSnEwM2lXV0dj?=
 =?utf-8?B?NmUyM1JnTTl0UjZ5d21keTQxUnN1NG1QTVBTWks5UWxIM3NFSFVyZVljQTlF?=
 =?utf-8?B?MnNqaHRZTWtlZCsrVzMvZFpYUTBlZEtlcjAzVTVFUnV1aFg5L2IxaFJpaUli?=
 =?utf-8?B?cGlSN0d4U0R6TDQrQ2dYV0h6RU1XYVI3bmU5cmx3Nk9aSG8xYzc4aFc2b3pX?=
 =?utf-8?B?ZXJ3OTUwZUUxOHhTK1ErTFV0UGkySkwydEJKZThxeUcwWVN5Qk1QbFZ6OWN1?=
 =?utf-8?B?RTVyN3J1cFFhbFVxOGszVENKMTFZMDZuWmt3bVhNUHJ1ajNVWHNEMEJZeTFQ?=
 =?utf-8?B?VDVJZ09scWllbTFXb1k5RFRBWjhiTmlvcTRhcjBXVjJBc21BY2wyeXdtcVQz?=
 =?utf-8?B?K0FFNkhWUUZNcDlMbmFkNVRxdHF4d00za2poNUhhTDVCMUVaelhCemw4M2Zl?=
 =?utf-8?B?ZzFkSnc1d1d1K2wwaGZMVUJLaDNpeXdRYWhsSlBDSTZ0bmJUa1VPcnVja3Ns?=
 =?utf-8?B?YmJ4Ukg2YXUwMzdacEFsa2IzaXlOdEdYektXNUZNY2E5M1VMNE5LVE1sTU90?=
 =?utf-8?B?T0JxKytTb0J4U0ZHSERiTUlxa08xZEJGNjAva2dBb0RqQ1JkWVhnaG51NHlT?=
 =?utf-8?B?bEkyb25hMExWdmsrTjdESGhjWHpLMENaM3FTY3NyRjFnN1BSSjdpSUl3bjJx?=
 =?utf-8?B?eTdvZGdVWDIxODVYY2llSDlQQVJpdk5iSlhCdGlIMHZFckZxUWtnU3pjQWto?=
 =?utf-8?B?L1NMTEZhTXFKWi9PVHFlS040Y1pJVWw2dnV3aDBGNFJPRVplK0xLUlFHQnpo?=
 =?utf-8?B?VkNZVUVzV0QrbVIxTUZyNlB4NS84Vkt4T1J4T2NZalRGTDNaTDUwck1DcFMr?=
 =?utf-8?B?dXJ5VEtNdVFpWXJuNy9XVTR3b1BkU080bVZWY2ZsLzlTNnRjVE03Zm90UVR4?=
 =?utf-8?B?dDQ5ZkhKT0oyaFNxNENyblhqQnF3L2dCTFFnaG5mR0ZwV2FsUFZSVEZ6SSt5?=
 =?utf-8?Q?+MCB6M8pEVw2fp1Vu6tc5ULN91FfmpZrVBj0tt2pL5Rf?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A2D07199C382C48B7F667AFDC8ABB5C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5565.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ba5626b-1e34-4871-5444-08db35f7d9ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 17:04:43.2369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XD/CVCtFYi2yAHanDUOW8BmaALnFH5O7SNesfONP0Z3XkrnlveE9zs9j1Jp4EgTyCx/hvOtW/m1cErEcabjD+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5332
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIzLTA0LTAzIGF0IDEwOjEyIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCAzIEFwciAyMDIzIDE4OjMwOjU1ICswMzAwIElsaWFzIEFwYWxvZGltYXMgd3Jv
dGU6DQo+ID4gPiBNZWFuaW5nIGluIHBhZ2VfcG9vbF9yZXR1cm5fc2tiX3BhZ2UoKSBvciBhbGwg
dGhlIHdheSBmcm9tDQo+ID4gPiBuYXBpX2NvbnN1bWVfc2tiKCk/IFRoZSBmb3JtZXIgZG9lcyBp
bmRlZWQgc291bmRzIGxpa2UgYSBnb29kDQo+ID4gPiBpZGVhIcKgIA0KPiA+IA0KPiA+IHBhZ2Vf
cG9vbF9yZXR1cm5fc2tiX3BhZ2UoKSAoYW5kIG1heWJlIHBhZ2VfcG9vbF9wdXRfZnVsbF9wYWdl
KCkpLg0KPiA+IEZXSVcgd2UgY29tcGxldGVseSBhZ3JlZSBvbiBuYXBpX2NvbnN1bWVfc2tiKCku
wqAgV2UgYXJlIHRyeWluZyB0bw0KPiA+IGtlZXANCj4gPiBwYWdlX3Bvb2wgYW5kIHRoZSBuZXQg
bGF5ZXIgYXMgZGlzam9pbnQgYXMgcG9zc2libGUuwqAgVGhlIG9ubHkNCj4gPiBwb2ludA0KPiA+
IHdlICdwb2xsdXRlJyBuZXR3b3JraW5nIGNvZGUgaXMgdGhlIHJlY3ljbGUgYml0IGNoZWNraW5n
IGFuZCB3ZSdkDQo+ID4gcHJlZmVyIGtlZXBpbmcgaXQgbGlrZSB0aGF0DQo+IA0KPiBBY2ssIE9U
T0ggcGx1bWJpbmcgdGhydSB0aGUgYnVkZ2V0IGFyZ3VtZW50IHdpdGhpbiBuZXRkZXYgY29kZSBz
aG91bGQNCj4gbm90IGJlIGEgbWFqb3IgcmVmYWN0b3JpbmcuIFNvIG1heWJlIEkgc2hvdWxkIGRv
IHRoYXQgYWZ0ZXIgYWxsLg0KPiANCj4gT3RoZXJ3aXNlIHdlIGhhdmUgdHdvIGRpZmZlcmVudCBj
b25kaXRpb25zIC0gbmV0ZGV2IG9ubHkgcmVjeWNsZXMNCj4gc2ticw0KPiBiYXNlZCBvbiB0aGUg
TkFQSSBidWRnZXQgIT0gMCwgYnV0IHBhZ2UgcG9vbCB3aWxsIGFzc3VtZSB0aGF0DQo+IGluX3Nv
ZnRpcnEoKSAmJiAhaW5faGFyZGlycSgpIGlzIGFsd2F5cyBzYWZlLg0KPiANCj4gVGhlIGxhdHRl
ciBpcyBzYWZlLCBJIHRoaW5rLCB1bmxlc3Mgc29tZW9uZSBhZGRzIGEgcHJpbnQgaGFsZiB3YXkN
Cj4gdGhydQ0KPiB0aGUgY2FjaGUgdXBkYXRlLi4uIGJ1dCB0aGVuIGl0J3MgYWxzbyBzYWZlIGlu
IE5BUEkgc2tiIHJlY3ljbGluZywNCj4gc28gbmFwaV9jb25zdW1lX3NrYigpIHNob3VsZCBzdG9w
IHRha2luZyB0aGUgYnVkZ2V0IGFuZCBqdXN0IGxvb2sNCj4gYXQgcHJlZW1wdCBmbGFncy4uLg0K
PiANCj4gVG8gbWFrZSB0aGUgY29ycmVjdG5lc3Mgb2J2aW91cywgZm9yIG5vdywgSSB0aGluayBJ
IHdpbGwgcmVmYWN0b3IgDQo+IHRoZSBuZXRkZXYgY29kZSB0byBwYXNzIGEgImluIE5BUEkgcG9s
bCIgYm9vbCB0bw0KPiBwYWdlX3Bvb2xfcmV0dXJuX3NrYl9wYWdlKCksIGFuZCBhZGQgYSBXQVJO
X09OKCFzb2Z0aXJxIHx8IGhhcmRpcnEpLg0KPiANCj4gTGV0J3Mgc2VlIGhvdyB0aGUgY29kZSBl
bmRzIHVwIGxvb2tpbmcsIEknbGwgc2VuZCBpdCBhcyBSRkN2MiByYXRoZXINCj4gdGhhbiBQQVRD
SCB0byBtYWtlIGl0IGNsZWFyIEknbSBub3Qgc3VyZSBpdCdzIG9rYXkgd2l0aCB5b3UgOikNCg0K
V293LCB0aGFua3MgZm9yIHBpY2tpbmcgdGhpcyB1cCBzbyBmYXN0IQ0KDQpBZnRlciBlbmFibGlu
ZyB0aGlzIGluIHRoZSBtbHg1IGRyaXZlciwgdGhlcmUgaXMgYWxyZWFkeSBpbXByb3ZlZA0KcGFn
ZV9wb29sIGNhY2hlIHVzYWdlIGZvciBvdXIgdGVzdCB3aXRoIHRoZSBhcHBsaWNhdGlvbiBydW5u
aW5nIG9uIHRoZQ0Kc2FtZSBDUFUgd2l0aCB0aGUgcmVjZWl2ZSBxdWV1ZSBOQVBJICgwIC0+IDk4
ICUgY2FjaGUgdXNhZ2UpLg0KDQpMb29raW5nIGZvcndhcmQgdG8gdGhlIHYyLg0K
