Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED445578FD3
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiGSBak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiGSBai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:30:38 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::700])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C96201BC
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 18:30:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pw1JhwmjyH1P5aZe2xS3a9tZTj5bM+KpYyojjso2mrZffVbQ4/O3wfUwsL1WZAKEF2UflW7TFVqD9foMltg+9cU9/qRbJMC3Om4idBMZKf7PjMkmKIRSc867z9Dyh7uRooGAA+bHWgaD2YHSSSESB/8vfCDOP/Zmfu7NbNguJht6wcYi12JFUHu8XK9rgY+DNxdFroo5mLiYrpE3ywDKZPUgX0Bfjz/FlL+JW51aHJMNAcHpmyhOW3VyJLhYJcHQk13PdjDIuec8jnGoPAfeJ+Zdju6ZE/STJXMkWGqFz06u830yu+/jsYxWgGQ9M02kqhIOX0Eb7lGlXaEGHlJhIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cMK2bstQ0BdzJkaCVJEJ1N9d5sHBEoV3cSJggPJNVUU=;
 b=NZ1QoHhdZ1Ht93mimum5y1eHidRqedYVAQU5EcCEBPPbD4BVkn+avb/H3BL0A7G8XS20yR8yCtRHtUaR6PSN/VOkSgveP2/M7NewlfSHBZa+XmjthTCEY9Tznj8ptEgmN22Sd8ro40VSAIW4hfjLcK2C4Oqk3KwGq5VPDEuAfj3ZUjh/CM2uKGDRrEauMIWto1Vc4WSXgYaiz5Fgao+PgVqiQoxL4+F8phC8u3mbTFx0vtV3docdum1TCiBipi3XCY0VFtynZW9CpgkQ9X83kRf4A9zVZS7LQUAQOoHREtOB+pJ5+Ho4kk9qtlpBLzi3rK5e7i9u+X66Wi6IaMBhcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMK2bstQ0BdzJkaCVJEJ1N9d5sHBEoV3cSJggPJNVUU=;
 b=m8eXAVEs67feXQi9s+17wuil3pmnoEXgMbSH8ZvNGqGi8T9RfVOtwebu4Y1U+8p/hzQeIqgLobNfJVuoWJqD2JkLms96kXAgReRuTyzHAe1I1cf9Dyl7FMoUq5bRbVOkk6nxzA793222RcqPZRgBUR82tk7zM0HhkiRIO54oiMg=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by BN6PR13MB1204.namprd13.prod.outlook.com (2603:10b6:404:21::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.16; Tue, 19 Jul
 2022 01:30:33 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::3069:6dd2:38fe:8d5a]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::3069:6dd2:38fe:8d5a%7]) with mapi id 15.20.5417.013; Tue, 19 Jul 2022
 01:30:33 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Oz Shlomo <ozsh@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Simon Horman <simon.horman@corigine.com>,
        Roi Dayan <roid@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net] net/sched: cls_api: Fix flow action initialization
Thread-Topic: [PATCH net] net/sched: cls_api: Fix flow action initialization
Thread-Index: AQHYmbc9rrQNroyesEyXZ6wTDwhxF62DWJUggAC3xQCAANhlYA==
Date:   Tue, 19 Jul 2022 01:30:32 +0000
Message-ID: <DM5PR1301MB21727F4E19924E41FCE39790E78F9@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20220717082532.25802-1-ozsh@nvidia.com>
 <DM5PR1301MB2172BA76D9BAEADF9A40D11CE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <6230396c-afef-c110-3432-d212d2bd77c9@nvidia.com>
In-Reply-To: <6230396c-afef-c110-3432-d212d2bd77c9@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28d7672e-3428-4031-0051-08da692645fa
x-ms-traffictypediagnostic: BN6PR13MB1204:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sP/bvdNLfO+UT1kEk8IEgARzDnXnsxK8vKV4XYyvApyG1WSETgb1OItG8acaWDD8yIPAsNZuAn/CEShWS9OPVBUeU5hckvwaokAEJn0QbmOz31OiNmN1nZ9S7lOtUTVUom0jAdc53DP+Y8i0N/GnZGaRviwnXaXvvU9Jw/4hJvzEt85dmdqSohtk6S2+w54hWG2GZAGAHz6HolrhWLgsq1vp0+LO5qfv6kavKbFaoQWUSROv/uQsp2E4VF5IuM+Wjx7e7OYXiTecuo61u9gmtPlo+rHxMEHWWKm0OsLD6YhLYx2+3q0Il9NYhLE1oN3RLnHLUrglgGtgjn+ffpkr8IIZtJJWQXvf4OdGsmXQktmUKBNoJt2wwpsqWZDQEXkAq02pnYhnOkJ++iFjsbgUQzqObZVLtEjKJV8AF+7okwNTEyTshyQoOxc9lmfyvSK5kIg851gjC8dMSoy68YTV3zifYJanhZ7OhVnoDLnihrXdyHAzI8m7KvLC2rJZ5c720MWuYrqGIsCJbA0fRgvpFEyDFdvZ7mqBCqNhevGCiAcUGGKeGPUHJrw+At3PnCZ/FrOE9TKkr3c7Abkg6bW90NqrMDMLICm+VESgTtTi0vntAKZkIL0ApQ5Yg/w3RJyp2CYYag7ZbsuoiGj7pWCzVk6YKt1xIMnBMdk+mAvH9fXamDyRboVUPpSmqNw70rhj0EKhWV33pwKGJJsPdm9xmnqRfKj7DzRW67C7E+Oo5ZII03N+5NfxOVeY01Phkc0sJo5eyzcFVdybqwijza5GkG0wmdapNJTZv0DwGJM0dpSVF5n67jZ7Z6svdsdQ/2QvSsqxlt0pFQFXWrucnouPspojXJ1Mse3/TMlSY434ipM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39830400003)(346002)(136003)(376002)(366004)(396003)(55016003)(122000001)(316002)(38070700005)(186003)(83380400001)(38100700002)(478600001)(52536014)(5660300002)(33656002)(76116006)(71200400001)(8676002)(66556008)(66476007)(41300700001)(66446008)(64756008)(66946007)(4326008)(2906002)(9686003)(86362001)(110136005)(54906003)(53546011)(8936002)(44832011)(6506007)(26005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXFSWTVaK0ZjSDgzWkNTeWxZM1Q3OS9uZWdVTTFkMzl4ckkySDBFT0lsUTVP?=
 =?utf-8?B?MG9GMnUxd1dHelRmVFA4SEkrL1BWQWNtOWVQRU5LQVJKcHgwOGE0dVNydUtB?=
 =?utf-8?B?M1NwSTNpK1RSSmg2UU16a0F6cld6MUhDRGdXVGVPa1lOSUdrWENFQm9aSTdw?=
 =?utf-8?B?dDRoeXNmblpUV0hSUlh0SXdadDVvMW5Vd1czWjZGWklvcWZpS090RDNqaVFM?=
 =?utf-8?B?ZUs0alVKRVN0THV6dEhWd0c2SWFTRTVhbHg2dlNyN1hGb2JIMVZLWGdsdENF?=
 =?utf-8?B?UEJBVHRnTW92UHd2d1ZUY1pocE5QV2l6WjhYSWlXV1lad0tPOU1CdGVGSU9u?=
 =?utf-8?B?YlZwRU5RQnMzczJnTGtpZ3FaOEY3dmhpUjlTUU03TFpVWm56d2hFL1g1bGV3?=
 =?utf-8?B?RWkvNFdvaVJQRlg3Q2ljS1ZOVmJjNkhORy8zTFZUWFBmbnZrZU4wbXdGTVEz?=
 =?utf-8?B?UGF0MEtzQU1oMXNuRzJaQUliUnFic1U4RWQzaElObUVzczMwU0tsaHJNLzdk?=
 =?utf-8?B?ZnhqaThHdGhPZ3dwcDE2TVRJM2ZUZ3ROZyttWVppS2MvZW1FNzJ1QmUrZTBs?=
 =?utf-8?B?Q0NlQTJBbnhuM1l4YW1IdmgzaFRmbUZHVW1BRGIyLzVMSlJvNnVLNEdMZmJZ?=
 =?utf-8?B?bzRjdVRYZU9LQksxUFlzbGYrVWlBd0ZVZmdhbDhDTEd4ZEtnOXhrVUZycUV0?=
 =?utf-8?B?aTAyVXlmOTZEL0hzMmpsUkVOeGJycVJjbmpDbEdrN0dhMHpUd3V0S1FzbVVX?=
 =?utf-8?B?YVNOb2FUR0diRTg1eE1QWVZGMSthY0dXc3RlTEJFaEZHRGR2Uy9BWDc5UUlK?=
 =?utf-8?B?TEU0R25ybWZJakhHUmV0emx1OXdoOFFGWGlVN1lVRDNSVEVqL0FOc3dpMEpT?=
 =?utf-8?B?bnE4ODdJSnQ2MlJmcmNGbGRic2U4anh2K3BwYTBNdzcrSkZCc09sL1hzdktK?=
 =?utf-8?B?V1Urd1FIcTJONVdpN3BSdDFKdG1zY1NYSGV0RnRUZldwS2s1VXYvY0trT2Fq?=
 =?utf-8?B?UkQ4NlpqUzRCYzREbTgyOHVXRnovUlpNU1R4QjAwUkFLRlZJbkNFZjNzRkln?=
 =?utf-8?B?MHpFMmhVUHFxaEpuRW80RnpFWFpWaFpZMDV5eFhPOGNzYUxVd05KZWxJUDZ1?=
 =?utf-8?B?TFFBNkZacjFaUWhWTTRFcVU1SkNYVGVUM2FwK1VjaGdlYWo2Sk1ud09HL01D?=
 =?utf-8?B?L1l2clBRRGorRUJoQTB6cWF2dHA1OU9DbFJYZzMvdnZHaU4yK0JUQ2RvUk1T?=
 =?utf-8?B?YXFiWEw5MnZwci9VeWpMMDVxVWJjeEhuaU1aM1dGZmtDajZMQ1NYanA5b2tp?=
 =?utf-8?B?R2thVkJQSEp2TUdDRWVNN1hzamc3dmY5SWpjSzhCbGVidjNlSHFBT0YzbzA4?=
 =?utf-8?B?aXhhT0tHOGFUSW85NGQzTmp0QUVuM095bzI1TXRpUk02UGY2ZGcrQmw3bC9p?=
 =?utf-8?B?THU1MUlmT1hNaDlWVWdGY09LcnpUY2VMcmhYMnAzc3pIVTJ1OTliSTJMM2JG?=
 =?utf-8?B?ckJzWkc2UVVPTW5qa0JUUStoMi9HZGh5WFFGSjZNRlc5eS9JdWRRMzhvVDZV?=
 =?utf-8?B?RXMwakVVRWtnd09keHIwRVlpOGJJOFUvU1ZEUlNlTVlBSXJnOHQ5bEF5TDVq?=
 =?utf-8?B?L21XQ3Q3UzZnTEJkeGhvQnNvSkhQUUtEUW9BSk1GQXlMSDNJeGNPdW9lTnAv?=
 =?utf-8?B?VVQ0WGtsaDlCeWt4Vi9KeklxSm9iY1NGYUZEN3VSY0F2cFo1eTloNjhYeUp0?=
 =?utf-8?B?bkdZbTJ3Vk9NU0VxQjBDNS9ta2ZzWDZxa3kxbWlITVdrQm9JQnZNVVp6THZV?=
 =?utf-8?B?ZEgycTVpTlF1bnFteWJOek5DbDJVaGVJVEY4cVk3MkpKUHAzN0FQYVF3QWZC?=
 =?utf-8?B?TnBNbkdYZE4reFh3M29BaW1keE1oNGRXamZEU2V6NjhhNWdub1pzNnNaelQ3?=
 =?utf-8?B?NHdka2lMSWYzQ0VCcGEwTFJrZi9ZL3dlNk9DSVZWOFZrUWZTK3R5SkVlSnpw?=
 =?utf-8?B?MWc0SWg0YS83Tis1NllibDZNNlMzUlR2WFBsSXo1eVFjTmpoL1hHWjlBYUNS?=
 =?utf-8?B?dzAxSEJFK25BZnU4SW85clpPRXhTMXVLREZtSjJ0UWNtS2Y1Snd1T2orU2da?=
 =?utf-8?Q?VFXR5joNHLPn+KJf4bEYG5oDJ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28d7672e-3428-4031-0051-08da692645fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 01:30:32.9875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PUyt2E6rpdmHZDB/gYiK2iWB6kTX0htEVjWzHSc17D8bHh4KqCok37+e1iGfQIH0Xk7U4MipTNlq5JeBV2OHZTI6DP95FFk9IH9ahYMHhTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB1204
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT3o6DQpPbiBKdWx5IDE4LCAyMDIyIDg6MjkgUE0sIE96IFNobG9tbyB3cm90ZToNCj5PbiA3
LzE4LzIwMjIgNDo0MCBBTSwgQmFvd2VuIFpoZW5nIHdyb3RlOg0KPj4gT24gU3VuZGF5LCBKdWx5
IDE3LCAyMDIyIDQ6MjYgUE0sIE96IFNobG9tbyB3cm90ZToNCj4+PiBTdWJqZWN0OiBbUEFUQ0gg
bmV0XSBuZXQvc2NoZWQ6IGNsc19hcGk6IEZpeCBmbG93IGFjdGlvbg0KPj4+IGluaXRpYWxpemF0
aW9uDQo+Pj4NCj4+PiBUaGUgY2l0ZWQgY29tbWl0IHJlZmFjdG9yZWQgdGhlIGZsb3cgYWN0aW9u
IGluaXRpYWxpemF0aW9uIHNlcXVlbmNlDQo+Pj4gdG8gdXNlIGFuIGludGVyZmFjZSBtZXRob2Qg
d2hlbiB0cmFuc2xhdGluZyB0YyBhY3Rpb24gaW5zdGFuY2VzIHRvIGZsb3cNCj5vZmZsb2FkIG9i
amVjdHMuDQo+Pj4gVGhlIHJlZmFjdG9yZWQgdmVyc2lvbiBza2lwcyB0aGUgaW5pdGlhbGl6YXRp
b24gb2YgdGhlIGdlbmVyaWMgZmxvdw0KPj4+IGFjdGlvbiBhdHRyaWJ1dGVzIGZvciB0YyBhY3Rp
b25zLCBzdWNoIGFzIHBlZGl0LCB0aGF0IGFsbG9jYXRlIG1vcmUNCj4+PiB0aGFuIG9uZSBvZmZs
b2FkIGVudHJ5LiBUaGlzIGNhbiBjYXVzZSBwb3RlbnRpYWwgaXNzdWVzIGZvciBkcml2ZXJzIG1h
cHBpbmcNCj5mbG93IGFjdGlvbiBpZHMuDQo+Pj4NCj4+PiBQb3B1bGF0ZSB0aGUgZ2VuZXJpYyBm
bG93IGFjdGlvbiBmaWVsZHMgZm9yIGFsbCB0aGUgZmxvdyBhY3Rpb24gZW50cmllcy4NCj4+Pg0K
Pj4+IEZpeGVzOiBjNTRlMWQ5MjBmMDQgKCJmbG93X29mZmxvYWQ6IGFkZCBvcHMgdG8gdGNfYWN0
aW9uX29wcyBmb3IgZmxvdw0KPj4+IGFjdGlvbg0KPj4+IHNldHVwIikNCj4+PiBTaWduZWQtb2Zm
LWJ5OiBPeiBTaGxvbW8gPG96c2hAbnZpZGlhLmNvbT4NCj4+PiBSZXZpZXdlZC1ieTogUm9pIERh
eWFuIDxyb2lkQG52aWRpYS5jb20+DQo+Pj4gLS0tDQo+Pj4gbmV0L3NjaGVkL2Nsc19hcGkuYyB8
IDE3ICsrKysrKysrKysrKystLS0tDQo+Pj4gMSBmaWxlIGNoYW5nZWQsIDEzIGluc2VydGlvbnMo
KyksIDQgZGVsZXRpb25zKC0pDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvbmV0L3NjaGVkL2Nsc19h
cGkuYyBiL25ldC9zY2hlZC9jbHNfYXBpLmMgaW5kZXgNCj4+PiA5YmI0ZDNkY2M5OTQuLmQwN2Mw
NDA5NjU2MCAxMDA2NDQNCj4+PiAtLS0gYS9uZXQvc2NoZWQvY2xzX2FwaS5jDQo+Pj4gKysrIGIv
bmV0L3NjaGVkL2Nsc19hcGkuYw0KPj4+IEBAIC0zNTMzLDcgKzM1MzMsNyBAQCBpbnQgdGNfc2V0
dXBfYWN0aW9uKHN0cnVjdCBmbG93X2FjdGlvbg0KPipmbG93X2FjdGlvbiwNCj4+PiAJCSAgICBz
dHJ1Y3QgdGNfYWN0aW9uICphY3Rpb25zW10sDQo+Pj4gCQkgICAgc3RydWN0IG5ldGxpbmtfZXh0
X2FjayAqZXh0YWNrKSB7DQo+Pj4gLQlpbnQgaSwgaiwgaW5kZXgsIGVyciA9IDA7DQo+Pj4gKwlp
bnQgaSwgaiwgaywgaW5kZXgsIGVyciA9IDA7DQo+Pj4gCXN0cnVjdCB0Y19hY3Rpb24gKmFjdDsN
Cj4+Pg0KPj4+IAlCVUlMRF9CVUdfT04oVENBX0FDVF9IV19TVEFUU19BTlkgIT0NCj5GTE9XX0FD
VElPTl9IV19TVEFUU19BTlkpOyBAQA0KPj4+IC0zNTU3LDEwICszNTU3LDE5IEBAIGludCB0Y19z
ZXR1cF9hY3Rpb24oc3RydWN0IGZsb3dfYWN0aW9uDQo+Pj4gKmZsb3dfYWN0aW9uLA0KPj4+IAkJ
ZW50cnktPmh3X2luZGV4ID0gYWN0LT50Y2ZhX2luZGV4Ow0KPj4+IAkJaW5kZXggPSAwOw0KPj4+
IAkJZXJyID0gdGNfc2V0dXBfb2ZmbG9hZF9hY3QoYWN0LCBlbnRyeSwgJmluZGV4LCBleHRhY2sp
Ow0KPj4+IC0JCWlmICghZXJyKQ0KPj4+IC0JCQlqICs9IGluZGV4Ow0KPj4+IC0JCWVsc2UNCj4+
PiArCQlpZiAoZXJyKQ0KPj4+IAkJCWdvdG8gZXJyX291dF9sb2NrZWQ7DQo+Pj4gKw0KPj4+ICsJ
CS8qIGluaXRpYWxpemUgdGhlIGdlbmVyaWMgcGFyYW1ldGVycyBmb3IgYWN0aW9ucyB0aGF0DQo+
Pj4gKwkJICogYWxsb2NhdGUgbW9yZSB0aGFuIG9uZSBvZmZsb2FkIGVudHJ5IHBlciB0YyBhY3Rp
b24NCj4+PiArCQkgKi8NCj4+PiArCQlmb3IgKGsgPSAxOyBrIDwgaW5kZXggOyBrKyspIHsNCj4+
PiArCQkJZW50cnlba10uaHdfc3RhdHMgPSB0Y19hY3RfaHdfc3RhdHMoYWN0LT5od19zdGF0cyk7
DQo+Pj4gKwkJCWVudHJ5W2tdLmh3X2luZGV4ID0gYWN0LT50Y2ZhX2luZGV4Ow0KPj4gVGhhbmtz
IE96IGZvciBicmluZ2luZyB0aGlzIGNoYW5nZSB0byB1cywgSSB0aGluayBpdCBtYWtlcyBzZW5z
ZSBmb3IgdXMgd2hlbg0KPnRoZSBwZWRpdCBhY3Rpb24gaXMgb2ZmbG9hZGVkIGFzIGEgc2luZ2xl
IGFjdGlvbi4NCj4+IEp1c3QgYSB0aW55IGFkdmljZSBmb3IgeW91ciByZWZlcmVuY2UsIG1heWJl
IHdlIGNhbiBzdGFydCBhc3NpZ25tZW50IGZyb20gaw0KPj0gMCBhbmQgZGVsZXRlIHRoZSBmaXJz
dCBlbnRyeSBhc3NpZ25tZW50IGFib3ZlLCB0aGVuIHdlIHdpbGwgcHV0IGFsbCB0aGUNCj5nZW5l
cmFsIGFzc2lnbm1lbnQgaW4gdGhpcyBsb29wLCBpdCB3aWxsIGJlIG1vcmUgY2xlYW4sIFdEWVQ/
DQo+DQo+SWYgd2UgZG8gdGhhdCB0aGVuIHRoZSBod19zdGF0cyBhbmQgaHdfaW5kZXggcGFyYW1l
dGVycyB3aWxsIG5vdCBiZQ0KPmF2YWlsYWJsZSB0byB0aGUgb2ZmbG9hZF9hY3Rfc2V0dXAgbWV0
aG9kLg0KPkFGQUlVIG5vIHRjIGFjdGlvbiBhY3R1YWxseSB1c2VzIHRoZXNlIHZhbHVlcyAoc28g
cG9zc2libHkgbm8NCj5yZWdyZXNzaW9uKSBidXQgcGVyaGFwcyBpdCBpcyBiZXR0ZXIgdG8gbGVh
dmUgdGhlbSBpbml0aWFsaXplZC4NCnRoYW5rcyBmb3IgY2xhcmlmeSBhYm91dCB0aGlzLCBmb3Ig
dGhlIHVzZSBvZiBod19pbmRleCBhbmQgaHdfc3RhdHMgaW4gdGNfc2V0dXBfb2ZmbG9hZF9hY3Qs
IHNpbmNlIHdlIHBhc3MgdGhlIGFjdCB0byBmdW5jdGlvbiwgSSB0aGluayB3ZSBjYW4gZ2V0IHBh
cmFtZXRlcnMgZnJvbSBhY3QgaWYgdGhleSBhcmUgbmVlZGVkLiANCldoYXQgaXMgeW91ciBvcGlu
aW9uPw0KPg0KPg0KPg0KPj4+ICsJCX0NCj4+PiArDQo+Pj4gKwkJaiArPSBpbmRleDsNCj4+PiAr
DQo+Pj4gCQlzcGluX3VubG9ja19iaCgmYWN0LT50Y2ZhX2xvY2spOw0KPj4+IAl9DQo+Pj4NCj4+
PiAtLQ0KPj4+IDEuOC4zLjENCj4+DQo=
