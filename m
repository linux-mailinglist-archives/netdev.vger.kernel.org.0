Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4917B52BFA7
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239583AbiERPsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 11:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239534AbiERPsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 11:48:00 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7F4187059;
        Wed, 18 May 2022 08:47:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqrRdj/kznvIP4kD173OCUitQ8LAoKPdvK3jlvpw/uxeOx6odQWW+pxp0N0Pjyk1ZO2vWrUo80OwUihwJFlGFtRL0m4eWC3vrnf43+vn7/GFHDYi9sfBgc7Q7BD9VpujMRnhv3A0xWAmQZrMYmC9B65MaUOFwD1z0xqeuuu/ZOyuRmF1ow4OGyrOMf2xudriYH6YUuEl//i/0MStlUmp5b8SvaduPK+hMz5IjVIl0x4vZBVJrSBMFQw0Zt92ChNWHtRwfldbPXL2QhymFBsAUtbr5YALlhloQTrQtOOXskESsmFd0oOiGFaLASqaQoEfx8VkiH0afrpiTqtAoITLiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCCfNTr6mGiAOmNOj9t66ZDhAuSCzAvWbIx7AhVj+gw=;
 b=ngeMEokm2SJ3/mF8Fy+OsjkUwjOKWXbvkN6ImxZH6lZoIxfsspe3iEGPomhd8EsJOEvf2vdi9gZe0pK9wdSEXKhkoBZWEaxBEjh1jjR/XL+Ou8G0rExaIEWRx1I7YOYVOhLfm+hxBKRHxjxDq5WvUvhim9DVhTN6fnlPTdgVba53JlaR4FMtjiVDcfvEzIzSsfaGEs+TpNNAC0mj0IbGVlQ3pBvZ0OEtGeZhj8BJSHCig+7aI/pyL6B9ySJrEf+zaU38LCr6zAVO3eTsKFApwIGQb8ZZTA1b4jOesHCm71ryLkwxoAj1IBi6Mvy5MkiyXx70IIx6cJuSksa+zgMuCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCCfNTr6mGiAOmNOj9t66ZDhAuSCzAvWbIx7AhVj+gw=;
 b=iOyylhpRC+IR0ivS64gSa2XiObZEMma/eNNfhgTE7aytKSYwq87P8Mhrsvh1zGWbuu222RUbVV0fxX2DQ0BshiPQYhGCnWIKbzdzXa06G2UG38z/im7jJLlf2T86zDbCG82WUDkYCM9bMgQRAKIzGUflKfTNcYCEpRTu6UbfmaQ=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by SN6PR02MB4752.namprd02.prod.outlook.com (2603:10b6:805:8f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Wed, 18 May
 2022 15:47:53 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::94f0:32be:367b:1798]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::94f0:32be:367b:1798%7]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 15:47:53 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        Harini Katakam <harinik@xilinx.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        git <git@xilinx.com>
Subject: RE: [RFC net-next] dt-bindings: net: xilinx: document xilinx emaclite
 driver binding
Thread-Topic: [RFC net-next] dt-bindings: net: xilinx: document xilinx
 emaclite driver binding
Thread-Index: AQHYZh7/W5aBkbqlHkqbu5HcsW4/mq0cgV4AgAhO+ZA=
Date:   Wed, 18 May 2022 15:47:53 +0000
Message-ID: <SA1PR02MB856027DD26AAB5C38C345BBAC7D19@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <1652373596-5994-1-git-send-email-radhey.shyam.pandey@xilinx.com>
 <8b441f8f-7aa2-0fab-9b90-6618a1e8c899@linaro.org>
In-Reply-To: <8b441f8f-7aa2-0fab-9b90-6618a1e8c899@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a26a1026-f4bf-4fcd-ab12-08da38e5c52f
x-ms-traffictypediagnostic: SN6PR02MB4752:EE_
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-microsoft-antispam-prvs: <SN6PR02MB475216D31C1BFB1591CEA53CC7D19@SN6PR02MB4752.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KPb0Or1/JDZxJXMi+zw542CZKq+qLOD06XsRtyLApHxBm2pWZffoat2bsyxmPf6W/sejuRTMvINeEASx/MzFeRh9HFEG0+lb5rzvqUqBtje4r/+p5PjBILGrOk9CNvBeRM+vk3cEjixfUQES90oLQATMZKrTmLEiUCmoB9qdaDXQRncag6E+aaa5GY2igU3jY+hfA+Gi4TF5hzMVhGrG0blN5dBiO1+MMIgscY/ev2XO8o6lyHzN+r3VBUjU4NUC/x5MMof6ORinQBNd8NwewL9hCvGv5FzKBjuJTL9QNoRFFbA6HdkDsEHd/Io1zAWaOs/aCxiUUABZ1l5AzCLqPZaWeP0F2XXk6qoFAlgv4qBuenrvVZsUuv3IA926izfnLigEZe+PastlrxC798XWwaPVziSqso46xfl6G8TgzjLsAOjY1JacwcohxAk4m/d9WtASNL6x6m7iNhxDb1chyZEivOCQkGsLoqFeXizeCjJlf9afSlm0kaZo1fANUN/Ple1pVkSElRPIqokZVKfOYZHsc5dogIdGSTWHeLjQfP2ZM8D6vz4CE/vIMLBipkFwGl6TkgA6bvYsGfJFHzXOCf6SZHF+C5My8s/8OaRCjK0NNKW+ZTUk/VnTlaFerUjlthXsoCEzdO4oiqpvJqxZdnqHZv7PC2WZQ6NaBtnyxVPBfRUMvJus3lv+UcMTH85kMWtpsG4rkpDzrgGf0X5RdcuGODDbHypvr1DXm9A0NGQxRlFqMbZZDtVyKA+kWKLRFsIlbKSL+SwCb6wPj6FmpsglY+XC8k11RKl8JGVPd/DOk1lcVjpphgKuTowAw9n458EJHsFv+g9y7AxuztqtBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66446008)(64756008)(8676002)(38070700005)(186003)(66946007)(86362001)(4326008)(76116006)(8936002)(508600001)(53546011)(52536014)(71200400001)(110136005)(54906003)(55016003)(33656002)(5660300002)(66476007)(7416002)(38100700002)(7696005)(6636002)(2906002)(107886003)(316002)(83380400001)(122000001)(6506007)(966005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dndWS1llNEErNW5sWHIzSmVTZWhTbFR1eWtBZ29taUpIM3FaWlVwZGR6ZjNh?=
 =?utf-8?B?ZHRiVjcrTDVmZ29HZWdwZ0Y1SjJScGNHR2pCMlZzek45NTZyVkVhK2dwcEE2?=
 =?utf-8?B?cC83MExJaUk0SmZ3TnBkVmUzdzd3bUpGNmRLdzc0SkVoNlduUmh4NnJ3ZEdD?=
 =?utf-8?B?Z2g4ZVRWeG00anZkakgxczNuTGVqRm1yRFp1TThidlNxS2dBU2V4VDdNa2NR?=
 =?utf-8?B?RlludEdhcklMVDZ2TkRrc3p3UGpJWkRScENJSGNDYTI0TmpjeHlST2JENlNX?=
 =?utf-8?B?cksxR0g0RVVQNmRqNnVXNzlCUFJEZGE2TVorVllRVFdKOElnR2JGbDRSNEJS?=
 =?utf-8?B?eFdERngrbHNqMHN3b21UbnZJOGpmWG0xckxqL1prcmxtK3orTndZclZOL3RR?=
 =?utf-8?B?YVZ0YXBnQjZWaU84Sm04MEZLVWRHdFkzNFoySGxySjhZb2xoWTBCOWhvemdD?=
 =?utf-8?B?eFNZZE1Wa2lHTDdNQmNxd3V6SzJNNmpzdXczOHJuZ3JOR3Zaekx3VXR6ajdp?=
 =?utf-8?B?SnFSL2JTbjU4YUpGSlI0Tm93bWxzSGVyc2RqS2hCK0lEL1pBdG04WWhZYXZn?=
 =?utf-8?B?ZWl0ZHhQaHJ4UFJhcktoaVNYelM5MW5sY2NMbnoyVnRjRkxKZEV3S3VqQUNX?=
 =?utf-8?B?MTlWbmlQT3dNWEl6VUdhUnpBWFVRWlkyNDlhc245S1E1MDRTRVloOUsxaE5E?=
 =?utf-8?B?OHM3YSt0ZDB0citJQ05wczUxRzF5NHdqMjNkVmJzdEMvbEFiaXVHOWpnOVNj?=
 =?utf-8?B?WVZ6VXZIa2U4QlFRelBrWWxHMVJuMnZySlFydjM3dUtaS1FDM1dFZFNSMk1s?=
 =?utf-8?B?WlFZQ25aV1VZZC9XQk1RNHBEVU1oUzd2a080OTRyR3I3aHAzc09QZ2JvaDhL?=
 =?utf-8?B?WkZkWnBHL0FZMTFYL1pFSHFyZFdGTTZXNG80MjBlNG9VMlB2WVkyYXZjeitt?=
 =?utf-8?B?TkpYV0ZYS3AzZEtDRlN6RnB4U1B4NkxwamhOdzJSN1F6cG5XdTRqY0JxOTZa?=
 =?utf-8?B?aWg5cTV5Qy91T1pzUWF2bTkySkdkWDJvNzdkVjd1dnI2NGV2Yy9WdlZETEhz?=
 =?utf-8?B?Vk1BZS9DZzRiRUdrcnFUZVREMWdYVWdFVWkyR0NWaHFXS2h3R2VCLzRWcmI4?=
 =?utf-8?B?THZpOXJ5R2VQMUhUdmQrNDJidW5ZSDZvR3ZZaGVYNlc4d010TzJHTlFWUm9R?=
 =?utf-8?B?QUF6aW1EUno0a3N6T2xMR1pKaG9LOWhmSDFHVmdHNjlzeHpLelk0VDRFend4?=
 =?utf-8?B?VzVGMUo3K0RMbnlPaFlFUkhSSTJDdUJkRnRtb2pFeWhqclQxckhvTS9IVW1S?=
 =?utf-8?B?RTB5QXh4M0ZHZFk2VDFYQWNuMDlDNjc0T2MvZ3JTVEl5NnE5cm50ckp4Nkdm?=
 =?utf-8?B?VnRPNEVWY2xLR3Y5U05xM0s1WGNOZW9vRjJ1UFk1ekluMDUzWWg0c1ZGRVBw?=
 =?utf-8?B?OUFlVXc1ZVlXN1hhNTVmMEsrS2pPWmRTZm9kODFITW5uejlJNmt1eVR6L2xO?=
 =?utf-8?B?eEE0a0hxbGluRjNBcElNREhabHFIVVZRWXZMUC9VTVhMQ2g2eFNqVlJBbHZB?=
 =?utf-8?B?b0lGcXdHMG1pY0NBUEdLVk1rRVFVejJyakZXYkREUExVNVd1aWRacDNMd05U?=
 =?utf-8?B?eStDcmxSajNJN25FVjkzYWc2NEdWT3RYV1RKK0hKOEFpZXU0cjY4K3g0M0U5?=
 =?utf-8?B?cTE0NXYxS2RvNmZxQXZzVSt5Nk91b1krYzVsS0poNjVyS1hjSk1oK0ZNdlFi?=
 =?utf-8?B?MHhoNCtLRWhQeCtudlNvTlRuM2lycitIZlh3ci9RU0VNYmYvRE1jczhvUDEz?=
 =?utf-8?B?dTRueUl0TDFmQk9TNkQ3ZVBRbDlrUVVaMFJiU3ZpaWJsU0ZON0U3Y1dyUFNp?=
 =?utf-8?B?SjFIblBMeXVwa09odloySlZYNXJ0U01nZitWamVhejFRckNueWo2YjlhSmtO?=
 =?utf-8?B?SjFUUWovVktYUmpEU0o1VHJOTEVHM3VtdGRBUDZybEdzeUYwMUN1ZEw1ZFRt?=
 =?utf-8?B?SXcxWU1MY3dtSU50Mnh6OVNPeDZrVmFIclMyY0tNZFprb1JnRXhEQXdMbWtn?=
 =?utf-8?B?Vnk4MVlwSHNtK25KbGY3Q0pwWjE3YWFtQmQyZ1ZqN3VnM05TQ09IdnVIV2s1?=
 =?utf-8?B?S2ozY2phMzYyWmtrQnNUMGhUa0dHbDUwdU9WZnFkWS9HbDYwRGZ5Q0x1aXZz?=
 =?utf-8?B?U1p3eGN4SjZ6SXRPTjFGdjJiSkNsYUkzL2JnSkFyN2txUG16ZldUMWxwdEN2?=
 =?utf-8?B?SnV5TktVdDkzVDVnUnFEWm1jOW9lbENyT0pZUWRGemw1OGlWaUJ6bkNjMFBM?=
 =?utf-8?B?RGExU1hYWitGdk0xZU9DZjBOakdXWFl0QUluMExCaVA2ZGVJS2dhTlBobVlk?=
 =?utf-8?Q?jEklgXm1Q7eqD/9bMFoAs/sYsvncrizB+hEFdLe8k3t6E?=
x-ms-exchange-antispam-messagedata-1: YNU7KIfOubFUzQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a26a1026-f4bf-4fcd-ab12-08da38e5c52f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2022 15:47:53.2779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J70sFLAdlB3sqjP037lWcN1Ip/ZnR7nOQxI0HolG3HODZe4FHv4a4qE62R5fMutMhqNBmi24M/zNfkAhSHlR0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4752
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBLcnp5c3p0b2YgS296bG93c2tp
IDxrcnp5c3p0b2Yua296bG93c2tpQGxpbmFyby5vcmc+DQo+IFNlbnQ6IEZyaWRheSwgTWF5IDEz
LCAyMDIyIDI6MjMgUE0NCj4gVG86IFJhZGhleSBTaHlhbSBQYW5kZXkgPHJhZGhleXNAeGlsaW54
LmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFA
a2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5jb207DQo+IHJvYmgrZHRAa2VybmVsLm9yZzsga3J6
eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8ub3JnOyBIYXJpbmkgS2F0YWthbQ0KPiA8aGFyaW5p
a0B4aWxpbnguY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgZGV2aWNldHJlZUB2
Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBnaXQgPGdp
dEB4aWxpbnguY29tPg0KPiBTdWJqZWN0OiBSZTogW1JGQyBuZXQtbmV4dF0gZHQtYmluZGluZ3M6
IG5ldDogeGlsaW54OiBkb2N1bWVudCB4aWxpbnggZW1hY2xpdGUNCj4gZHJpdmVyIGJpbmRpbmcN
Cj4gDQo+IE9uIDEyLzA1LzIwMjIgMTg6MzksIFJhZGhleSBTaHlhbSBQYW5kZXkgd3JvdGU6DQo+
ID4gQWRkIGJhc2ljIGRlc2NyaXB0aW9uIGZvciB0aGUgeGlsaW54IGVtYWNsaXRlIGRyaXZlciBE
VCBiaW5kaW5ncy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFJhZGhleSBTaHlhbSBQYW5kZXkg
PHJhZGhleS5zaHlhbS5wYW5kZXlAeGlsaW54LmNvbT4NCj4gPiAtLS0NCj4gPiAgLi4uL2JpbmRp
bmdzL25ldC94bG54LGVtYWNsaXRlLnlhbWwgICAgICAgICAgIHwgNjAgKysrKysrKysrKysrKysr
KysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNjAgaW5zZXJ0aW9ucygrKQ0KPiA+ICBjcmVhdGUg
bW9kZSAxMDA2NDQNCj4gPiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3hs
bngsZW1hY2xpdGUueWFtbA0KPiANCj4gV2h5IGlzIHRoaXMgUkZDPyBEbyB5b3UgZXhwZWN0IERU
IG1haW50YWluZXJzIHJldmlldyBvciBub3Q/IE1heWJlIHRoZXJlIGlzDQo+IG5vIHBvaW50IGZv
ciB1cyB0byByZXZpZXcgc29tZXRoaW5nIHdoaWNoIGlzIG5vdCBnb2luZyB0byBiZSBhcHBsaWVk
Pw0KDQpJIGludGVudGlvbmFsbHkgbWFkZSBpdCBSRkMgc28gdGhhdCBhbGwgYXNwZWN0cyBhcmUg
cmV2aWV3ZWQgYXMgdGhpcyBkcml2ZXIgZGlkbid0DQpoYWQgYW4gZXhpc3RpbmcgYmluZGluZy4g
SSB3aWxsIHNlbmQgb3V0IG5leHQgdmVyc2lvbiB3aXRoIGJlbG93IGNvbW1lbnQgDQphZGRyZXNz
ZWQuIFRoYW5rcyENCj4gDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL25ldC94bG54LGVtYWNsaXRlLnlhbWwNCj4gPiBiL0RvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQveGxueCxlbWFjbGl0ZS55YW1sDQo+ID4gbmV3IGZp
bGUgbW9kZSAxMDA2NDQNCj4gPiBpbmRleCAwMDAwMDAwMDAwMDAuLmEzZTJhMGU4OWIyNA0KPiA+
IC0tLSAvZGV2L251bGwNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGlu
Z3MvbmV0L3hsbngsZW1hY2xpdGUueWFtbA0KPiA+IEBAIC0wLDAgKzEsNjAgQEANCj4gPiArIyBT
UERYLUxpY2Vuc2UtSWRlbnRpZmllcjogKEdQTC0yLjAtb25seSBPUiBCU0QtMi1DbGF1c2UpICVZ
QU1MIDEuMg0KPiA+ICstLS0NCj4gPiArJGlkOiBodHRwOi8vZGV2aWNldHJlZS5vcmcvc2NoZW1h
cy9uZXQveGxueCxlbWFjbGl0ZS55YW1sIw0KPiA+ICskc2NoZW1hOiBodHRwOi8vZGV2aWNldHJl
ZS5vcmcvbWV0YS1zY2hlbWFzL2NvcmUueWFtbCMNCj4gPiArDQo+ID4gK3RpdGxlOiBYaWxpbngg
RW1hY2xpdGUgRXRoZXJuZXQgY29udHJvbGxlcg0KPiA+ICsNCj4gPiArbWFpbnRhaW5lcnM6DQo+
ID4gKyAgLSBSYWRoZXkgU2h5YW0gUGFuZGV5IDxyYWRoZXkuc2h5YW0ucGFuZGV5QHhpbGlueC5j
b20+DQo+ID4gKyAgLSBIYXJpbmkgS2F0YWthbSA8aGFyaW5pLmthdGFrYW1AeGlsaW54LmNvbT4N
Cj4gPiArDQo+IA0KPiBZb3Ugc2hvdWxkIGluY2x1ZGUgZXRoZXJuZXQgY29udHJvbGxlciBzY2hl
bWEuDQo+IA0KPiA+ICtwcm9wZXJ0aWVzOg0KPiA+ICsgIGNvbXBhdGlibGU6DQo+ID4gKyAgICBl
bnVtOg0KPiA+ICsgICAgICAtIHhsbngsb3BiLWV0aGVybmV0bGl0ZS0xLjAxLmENCj4gPiArICAg
ICAgLSB4bG54LG9wYi1ldGhlcm5ldGxpdGUtMS4wMS5iDQo+ID4gKyAgICAgIC0geGxueCx4cHMt
ZXRoZXJuZXRsaXRlLTEuMDAuYQ0KPiA+ICsgICAgICAtIHhsbngseHBzLWV0aGVybmV0bGl0ZS0y
LjAwLmENCj4gPiArICAgICAgLSB4bG54LHhwcy1ldGhlcm5ldGxpdGUtMi4wMS5hDQo+ID4gKyAg
ICAgIC0geGxueCx4cHMtZXRoZXJuZXRsaXRlLTMuMDAuYQ0KPiA+ICsNCj4gPiArICByZWc6DQo+
ID4gKyAgICBtYXhJdGVtczogMQ0KPiA+ICsNCj4gPiArICBpbnRlcnJ1cHRzOg0KPiA+ICsgICAg
bWF4SXRlbXM6IDENCj4gPiArDQo+ID4gKyAgcGh5LWhhbmRsZTogdHJ1ZQ0KPiA+ICsNCj4gPiAr
ICBsb2NhbC1tYWMtYWRkcmVzczogdHJ1ZQ0KPiA+ICsNCj4gPiArICB4bG54LHR4LXBpbmctcG9u
ZzoNCj4gPiArICAgIHR5cGU6IGJvb2xlYW4NCj4gPiArICAgIGRlc2NyaXB0aW9uOiBoYXJkd2Fy
ZSBzdXBwb3J0cyB0eCBwaW5nIHBvbmcgYnVmZmVyLg0KPiA+ICsNCj4gPiArICB4bG54LHJ4LXBp
bmctcG9uZzoNCj4gPiArICAgIHR5cGU6IGJvb2xlYW4NCj4gPiArICAgIGRlc2NyaXB0aW9uOiBo
YXJkd2FyZSBzdXBwb3J0cyByeCBwaW5nIHBvbmcgYnVmZmVyLg0KPiA+ICsNCj4gPiArcmVxdWly
ZWQ6DQo+ID4gKyAgLSBjb21wYXRpYmxlDQo+ID4gKyAgLSByZWcNCj4gPiArICAtIGludGVycnVw
dHMNCj4gPiArICAtIHBoeS1oYW5kbGUNCj4gPiArDQo+ID4gK2FkZGl0aW9uYWxQcm9wZXJ0aWVz
OiBmYWxzZQ0KPiA+ICsNCj4gPiArZXhhbXBsZXM6DQo+ID4gKyAgLSB8DQo+ID4gKyAgICBheGlf
ZXRoZXJuZXRsaXRlXzE6IGV0aGVybmV0QDQwZTAwMDAwIHsNCj4gPiArICAgICAgICAgICAgY29t
cGF0aWJsZSA9ICJ4bG54LHhwcy1ldGhlcm5ldGxpdGUtMy4wMC5hIjsNCj4gDQo+IDQtc3BhY2Ug
aW5kZW50YXRpb24gZm9yIERUUywgcGxlYXNlLg0KPiANCj4gPiArICAgICAgICAgICAgaW50ZXJy
dXB0LXBhcmVudCA9IDwmYXhpX2ludGNfMT47DQo+ID4gKyAgICAgICAgICAgIGludGVycnVwdHMg
PSA8MSAwPjsNCj4gPiArICAgICAgICAgICAgbG9jYWwtbWFjLWFkZHJlc3MgPSBbMDAgMGEgMzUg
MDAgMDAgMDBdOw0KPiA+ICsgICAgICAgICAgICBwaHktaGFuZGxlID0gPCZwaHkwPjsNCj4gPiAr
ICAgICAgICAgICAgcmVnID0gPDB4NDBlMDAwMDAgMHgxMDAwMD47DQo+ID4gKyAgICAgICAgICAg
IHhsbngscngtcGluZy1wb25nOw0KPiA+ICsgICAgICAgICAgICB4bG54LHR4LXBpbmctcG9uZzsN
Cj4gPiArICAgIH07DQo+IA0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBLcnp5c3p0b2YNCg==
