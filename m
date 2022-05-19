Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595B152CBE5
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 08:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbiESG1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 02:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiESG1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 02:27:02 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA22A9CF7B
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 23:26:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CM0japPtVkGZFWbGUK4GwRksOT7HzYgzK8k0SQPS2POALYRRG7FisNEde6CUwHEldKzETYaTw3IgDSqiJKppHY0nm4OIg2P4Lr7W1lG6NDkYW3r5RLRPwmLeuAsEMyivtLQeKjr7GZLAQKZ8ybN3Wauc+KGLhnBIXq4SwoDb6fUDeeVDbQ4ZaVt6I+GHColo9HuQPOOC/7PIDWF6wED7wYoqEsWjaaiuQT7TDfoLIIG7gPb9yCjPspIlmY91El6zsIsk32oCTvzUaG8YRljN3nVG3Ygit20SH75TrgiUychvzzpdhue2W7pjaL/uBZPRLq0d55maKVzNpAm2rxBOzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6EYuDm/9f/bSi66oO/mbTtreu9/7dhC+uCB4LUlI8J4=;
 b=NGyNNrDr1YKkxq4hsKy8t5kb+S8d0xjrtpTGYIDQcWdHdo/ZeEOEeXUFXmooFX6vdgHwDXj2vEee83FktbrtIhSfJYOe43pb5Z3jUj4aETUWsHpwH5kKM9eeIbeN/sQG3I93dcq1EA9jflgKdde4+heE09C2RiTklQCosGbTSQY1j9U0ydPrBi/B/xq4mG9JaX071cZ6IlN5OcUecsh01GSeEpXu63+1edWpw6Aj0BL7z9S/lVDOuwJzjV4iSdV5/odPJ0V8hq8AMzVpNDbaTK1DQ3UudlpqqtECAEmRYjtGq+3BKEPa8Xx0QlkJBrEfZhljfvTTYMil6eBOtBOlzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6EYuDm/9f/bSi66oO/mbTtreu9/7dhC+uCB4LUlI8J4=;
 b=EWzeNKZ6n7JT2q//rPJbWlB5J2Ukddmw0rRzZY1C5mGBeV5ezUc8Okj1Dvy178QcqoUqR5UtofVni3ZblEJD+hxM797lZZOwgC5V7MpINCWufnSMe7fIoQaes6ZXkFMhx5CazGk2RTfjDTsH73CinxanGoKydIkCIEwUcb5RE8sdcXkJnUY23xXSMsc3CX9QgIGcxuyhZM7M/yELHAbIpvBtB5BS+AwRz09Nn/ZIfxpFTrZR1BJ2YiVEr7fH3wd/NLw7hhJ0KcxJeSiEa6MPH/08zGtzydIssv+8bAV4zhnFdmN3481xNVdpZ+62wf07DlhoIOEa1pFFRrLb1d01fw==
Received: from PH0PR12MB5449.namprd12.prod.outlook.com (2603:10b6:510:e7::24)
 by DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Thu, 19 May
 2022 06:26:56 +0000
Received: from PH0PR12MB5449.namprd12.prod.outlook.com
 ([fe80::7161:44f:99c7:f506]) by PH0PR12MB5449.namprd12.prod.outlook.com
 ([fe80::7161:44f:99c7:f506%6]) with mapi id 15.20.5273.015; Thu, 19 May 2022
 06:26:55 +0000
From:   Lior Nahmanson <liorna@nvidia.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben Ishay <benishay@nvidia.com>
Subject: RE: [PATCH net-next v1 01/03] net/macsec: Add MACsec skb extension Tx
 Data path support
Thread-Topic: [PATCH net-next v1 01/03] net/macsec: Add MACsec skb extension
 Tx Data path support
Thread-Index: AQHYYrtrrd/1WczWZ0Gq/aDiRW6JHa0X2auAgA3tf2A=
Date:   Thu, 19 May 2022 06:26:55 +0000
Message-ID: <PH0PR12MB5449D3A9884E92733EF70E0ABFD09@PH0PR12MB5449.namprd12.prod.outlook.com>
References: <20220508090954.10864-1-liorna@nvidia.com>
         <20220508090954.10864-2-liorna@nvidia.com>
 <63c9efe216f6c4195f53b3c43b202eda2f0821d0.camel@redhat.com>
In-Reply-To: <63c9efe216f6c4195f53b3c43b202eda2f0821d0.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28b4b155-9500-4458-6702-08da39609229
x-ms-traffictypediagnostic: DM6PR12MB4235:EE_
x-microsoft-antispam-prvs: <DM6PR12MB423588AF03C710DD876E7FDFBFD09@DM6PR12MB4235.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: khLyLu+HRFecBjkAMdKIfOtjzG9jWGoon565OuHpNPyLP5Qqc1BqXMtItHCmQa0DNHhadrubLTlLv6l5EeRs32cERaRTYSdmJJUmzrqTNHp/isYQIkBITOjgLEM1TIpc+xVlQ27sCMEVcfe6X7hfd82DZIpRkzN0TVWGVjHK1sf1sHLRi674+kH+Yyi9DcwXw8eLFj8Ufr0BMmQF139PRmb9MLiQgaR3U2zWjnLSAm8/UhZMa96Pjp689f7BizY6x3SoQUCP9wTzt8bgMxHGnneAydTrbNv3TlLFcg70Mw0HdrKRc9VKarQzciGy/6yxjgaI8HhDOswmwafC1Lm+la+t7hff7DQew12r+PZgLxRRPvsaAKJAVDldJ8inAeGSi0/S0lNB0WEz4y/FlzjxlyeumHS6GOnFAJNYAMNrnG9/yaJss6flKjts3Y3bCqXs9TZLllGfPwjVTDy0Ss0UGiS9qV+sd47kGb6NoRuzdSCCJCsakhGGIjDSehV+AXbW6RMn/ahqqB8riBjDvLx92KNFOdnfn05ylvZBaBEdlkHA2Dp9v68Yvu3wUjSEp9oc+RMd7j4gFYUDNDJgT8aS5X5NIdtBUwmo0Wn9YeEsb2e+fPzaGsYD3eNCZVGGla5XWvgdNh6RjUS2yNL1fGuRrxK0ZLYYCJrd7lc+5KPCPk2mT49S0BKmYG3RVn6yqiqDT9qPOCnY+TYKI9PcmVkkaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5449.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(55016003)(83380400001)(107886003)(5660300002)(110136005)(54906003)(8676002)(4326008)(76116006)(33656002)(66556008)(66476007)(66446008)(508600001)(64756008)(186003)(66946007)(52536014)(38070700005)(316002)(38100700002)(53546011)(122000001)(7696005)(2906002)(6506007)(8936002)(71200400001)(26005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnI0WmZYUUpuVnNsRlhIM2djSiszOWFac1ppdnhjSXJJOTlaVlVBYVJyVUt2?=
 =?utf-8?B?WjdtYXlvU1ZVNnl0OXZGTzlwaDExcmI3aGJhSHhWQlRCOExGNEY5L0xkTmFl?=
 =?utf-8?B?T2JyVkt3SlNITFNwQ1duc21SaU03N2g0MHhuaUo3MFpNcCs3RFNLZ3ZRK3lO?=
 =?utf-8?B?ZUdEUHlnbWh3bE9ScWtRZjFpcm1iNmN6ZmpRQWtaZ3JHcFlnZ2NXbXg3YWlQ?=
 =?utf-8?B?MGF4ditDNjFPeUlwVjFINzJreE9WTmtkVGlvTklINjgxYTZDNzdOQ2dTSXg3?=
 =?utf-8?B?M1Bqc0xCY1lERlMwOTY3ODV4ZW5JcFMxdU5IZ1NweUZReDNGaTJLS3h1Umt2?=
 =?utf-8?B?VlQweFhHQWg5RkhmQXlOQ3VWVDJMNlpoZjBZaHZ3VUVCN2tjaVJ2QmxTdzBM?=
 =?utf-8?B?RWRMOWFNalcya2hMQWc1d2cwdGF1SFB3amlGckFTa0s1a2JHV3p5TU5GaVhQ?=
 =?utf-8?B?SWJGbFl4L2NvVmVHY0tuM2dkSUJQSDV2Y3dtbUptMmdNWmdrQlNrZDNTVjUz?=
 =?utf-8?B?YVBtdnZCcVZrVGU1blJVYTM4OGQxREsxYXAyU0w0cGVBUHVxWjk0dmNZckkz?=
 =?utf-8?B?RndvemgvdW82Tkg1aUlIVUUwNUNUZmU2aVRLSEZLdlVncDJnR0paOVhuMGsx?=
 =?utf-8?B?cnBoZUdqd1AxT1NpRUJpczJvRnhsamZMdit1WG5SeHNXdGVsVmFWR0VGNnpX?=
 =?utf-8?B?aU5oTWVrUXNOVnZkMGJxckl3MHF6SDQrRDk3SXRXVmtLWTl3Y01SS25LVWNO?=
 =?utf-8?B?L2g4Lzh5Q01YRkdTakE2dGpVZHJkc0hrMXJjUTFWM25IYmlTMUNzNDFiV0h5?=
 =?utf-8?B?MUtOdXIxcE4zMFNwNmF4SnBFZUhJL2kxNEx4VHA0Zkl6MjJjOHVrV3hGK0d6?=
 =?utf-8?B?Qmg2c2hRcUg4VWRBQm9rd0FwSUxGVjhZV0ZoaDJ6Z3hFNjJ6VzZzckdGUm9R?=
 =?utf-8?B?cGVhZ1lsRFFFcHBjNFdwUGVLbmExeXZuTFB2N1RGWXVjVHRaMHdzVTJkTTU5?=
 =?utf-8?B?Q1R4dW5kd0tuMkFmRWg4SmdFZStJNC9ydk1UdWRiWUcrNWt1TkMxSHNCaW1x?=
 =?utf-8?B?WndWTFJ2dWY4bTJheHBXYXF4REd1UExISFRrbTUwWUNsOEltV1lQNzZpYUFp?=
 =?utf-8?B?OHMvd043bXM2L1ZZb0RPQ0VKSWVHRlcwYTlGc1pOKytZbkpKdk4rYW1WRDBm?=
 =?utf-8?B?SGkzYzZXT3NtMTNXRS9QTTRrd2Y2SlZiWEhwQjdYZDZPRmwrMExja3d2cUFU?=
 =?utf-8?B?YTh4c3pLSjROKzhHSVdiVGJLMHBuWEVELysrcXlRZEsrb01tYjFPamk1ODZt?=
 =?utf-8?B?U0pwSTRSNEhpVU52bGVCQzBSZWVCL3M1WkVHUFd2cm4wWWg3ci9ZWWtJWTFj?=
 =?utf-8?B?dzZwL2VYbm5qQmhBZTZoZjh1ZzVYZmR1ajl2YTZIckNlTkFVMnNLNkdkYjZO?=
 =?utf-8?B?QW5sN09xQzJvNG9rWG80UUZhSzZaY003SDlvdlNiNDIvMWhXZzZCREtBV2VC?=
 =?utf-8?B?cFN0elBYRllTRDhtZ2ZYQVdIa1JEMGZxQ01MYVd1Ukw3TjF6ZXQxVUVZRUhP?=
 =?utf-8?B?MGthZVhpU2hpbmhHVFc2Q0RrZHZON1RiRnNZVUc5QS9TODdyTjJvNmh3R1Rh?=
 =?utf-8?B?U3FiSXZabGtoa2ZjdzVtS05rK3BkbkhQWEl6U3NkMk9YbU02dU5ENzZDbWZ4?=
 =?utf-8?B?OHRVV1Q0MHVTeG9uSDE3VDhucXcxalhyYllvQnEwQlZ2U0RYMDZpRDZuZzRy?=
 =?utf-8?B?VWlnY0tvZ1FBZUNoQ3pxQnh1NnVydGFTeExtWnJDTDhpb1doZHduQ0xCdnRY?=
 =?utf-8?B?L000VHpLSVlXNFFkaW50ZEJmcnptaE45QXVoWDRnbFhmYW5iRlBCOS9LUXhN?=
 =?utf-8?B?R0c5eWRPRkJGYjJQdzMyRHB5UFpibzArTi9EMEIrdTk0N0ZrWmdQUmYzc2xT?=
 =?utf-8?B?U2Y3UExCMVREVlI3Tis4UUVKQll6YUhiTXFTSXp5YTViRWUyM2k5N09yZEJn?=
 =?utf-8?B?bm4wQkltQ3doVlU1YUhMei8zaTZ1OUN4VUQ2OUsrYXZiamRMa0VTcEE1SUpH?=
 =?utf-8?B?WGhLQlBrTTA3S0dJQXZZakFsK2Y2b0ZIeEhHRnlhODlKb1FVWDNXbW5FdjB1?=
 =?utf-8?B?ams4MjN0bW5nV0VGSFcrb0NEd3h3M3dacEszckxxS2k0cUlGQ2FzZXFpOVlN?=
 =?utf-8?B?alVrRmYrRE9UOStNZHpHZ2lNV3hTMkc2VlM4ZHgwbVhORnBZbTkxdHFySXNr?=
 =?utf-8?B?OUUyZDhPckNQdkRrN3dpLzJrVEhSeVJ6VWtVSlVtL0JPaGYyc0dVZldVSGwy?=
 =?utf-8?Q?nVK0mueVltEliyrSmy?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5449.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28b4b155-9500-4458-6702-08da39609229
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 06:26:55.7708
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BIuy+i/HhV/auBvsesXkDt2DFe/2Phc/8AzBsmkTr5PQ3bFqOBbml07qpF0g88yK/yWiX9vLbUD65mcDTBrSEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4235
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQYW9sbyBBYmVuaSA8cGFiZW5p
QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIE1heSAxMCwgMjAyMiAxMjoyMyBQTQ0KPiBU
bzogTGlvciBOYWhtYW5zb24gPGxpb3JuYUBudmlkaWEuY29tPjsgZWR1bWF6ZXRAZ29vZ2xlLmNv
bTsNCj4ga3ViYUBrZXJuZWwub3JnDQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBuZXRkZXZA
dmdlci5rZXJuZWwub3JnOyBSYWVkIFNhbGVtDQo+IDxyYWVkc0BudmlkaWEuY29tPjsgSmlyaSBQ
aXJrbyA8amlyaUBudmlkaWEuY29tPjsgQmVuIEJlbiBJc2hheQ0KPiA8YmVuaXNoYXlAbnZpZGlh
LmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2MSAwMS8wM10gbmV0L21hY3Nl
YzogQWRkIE1BQ3NlYyBza2INCj4gZXh0ZW5zaW9uIFR4IERhdGEgcGF0aCBzdXBwb3J0DQo+IA0K
PiBFeHRlcm5hbCBlbWFpbDogVXNlIGNhdXRpb24gb3BlbmluZyBsaW5rcyBvciBhdHRhY2htZW50
cw0KPiANCj4gDQo+IE9uIFN1biwgMjAyMi0wNS0wOCBhdCAxMjowOSArMDMwMCwgTGlvciBOYWht
YW5zb24gd3JvdGU6DQo+ID4gSW4gdGhlIGN1cnJlbnQgTUFDc2VjIG9mZmxvYWQgaW1wbGVtZW50
YXRpb24sIE1BQ3NlYyBpbnRlcmZhY2VzIGFyZQ0KPiA+IHNoYXJpbmcgdGhlIHNhbWUgTUFDIGFk
ZHJlc3Mgb2YgdGhlaXIgcGFyZW50IGludGVyZmFjZSBieSBkZWZhdWx0Lg0KPiA+IFRoZXJlZm9y
ZSwgSFcgY2FuJ3QgZGlzdGluZ3Vpc2ggaWYgYSBwYWNrZXQgd2FzIHNlbnQgZnJvbSBNQUNzZWMN
Cj4gPiBpbnRlcmZhY2UgYW5kIG5lZWQgdG8gYmUgb2ZmbG9hZGVkIG9yIG5vdC4NCj4gPiBBbHNv
LCBpdCBjYW4ndCBkaXN0aW5ndWlzaCBmcm9tIHdoaWNoIE1BQ3NlYyBpbnRlcmZhY2UgaXQgd2Fz
IHNlbnQgaW4NCj4gPiBjYXNlIHRoZXJlIGFyZSBtdWx0aXBsZSBNQUNzZWMgaW50ZXJmYWNlIHdp
dGggdGhlIHNhbWUgTUFDIGFkZHJlc3MuDQo+ID4NCj4gPiBVc2VkIFNLQiBleHRlbnNpb24sIHNv
IFNXIGNhbiBtYXJrIGlmIGEgcGFja2V0IGlzIG5lZWRlZCB0byBiZQ0KPiA+IG9mZmxvYWRlZCBh
bmQgdXNlIHRoZSBTQ0ksIHdoaWNoIGlzIHVuaXF1ZSB2YWx1ZSBmb3IgZWFjaCBNQUNzZWMNCj4g
PiBpbnRlcmZhY2UsIHRvIG5vdGlmeSB0aGUgSFcgZnJvbSB3aGljaCBNQUNzZWMgaW50ZXJmYWNl
IHRoZSBwYWNrZXQgaXMNCj4gc2VudC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpb3IgTmFo
bWFuc29uIDxsaW9ybmFAbnZpZGlhLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogUmFlZCBTYWxlbSA8
cmFlZHNAbnZpZGlhLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogSmlyaSBQaXJrbyA8amlyaUBudmlk
aWEuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBCZW4gQmVuLUlzaGF5IDxiZW5pc2hheUBudmlkaWEu
Y29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9LY29uZmlnICAgIHwgMSArDQo+ID4gIGRy
aXZlcnMvbmV0L21hY3NlYy5jICAgfCA1ICsrKysrDQo+ID4gIGluY2x1ZGUvbGludXgvc2tidWZm
LmggfCAzICsrKw0KPiA+ICBpbmNsdWRlL25ldC9tYWNzZWMuaCAgIHwgNiArKysrKysNCj4gPiAg
bmV0L2NvcmUvc2tidWZmLmMgICAgICB8IDcgKysrKysrKw0KPiA+ICA1IGZpbGVzIGNoYW5nZWQs
IDIyIGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9LY29u
ZmlnIGIvZHJpdmVycy9uZXQvS2NvbmZpZyBpbmRleA0KPiA+IGIyYTRmOTk4YzE4MC4uNmM5YTk1
MGI3MDEwIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L0tjb25maWcNCj4gPiArKysgYi9k
cml2ZXJzL25ldC9LY29uZmlnDQo+ID4gQEAgLTMxMyw2ICszMTMsNyBAQCBjb25maWcgTUFDU0VD
DQo+ID4gICAgICAgc2VsZWN0IENSWVBUT19BRVMNCj4gPiAgICAgICBzZWxlY3QgQ1JZUFRPX0dD
TQ0KPiA+ICAgICAgIHNlbGVjdCBHUk9fQ0VMTFMNCj4gPiArICAgICBzZWxlY3QgU0tCX0VYVEVO
U0lPTlMNCj4gPiAgICAgICBoZWxwDQo+ID4gICAgICAgICAgTUFDc2VjIGlzIGFuIGVuY3J5cHRp
b24gc3RhbmRhcmQgZm9yIEV0aGVybmV0Lg0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L21hY3NlYy5jIGIvZHJpdmVycy9uZXQvbWFjc2VjLmMgaW5kZXgNCj4gPiA4MzJmMDlhYzA3
NWUuLjA5NjAzMzllMjQ0MiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9tYWNzZWMuYw0K
PiA+ICsrKyBiL2RyaXZlcnMvbmV0L21hY3NlYy5jDQo+ID4gQEAgLTMzNzcsNiArMzM3NywxMSBA
QCBzdGF0aWMgbmV0ZGV2X3R4X3QgbWFjc2VjX3N0YXJ0X3htaXQoc3RydWN0DQo+IHNrX2J1ZmYg
KnNrYiwNCj4gPiAgICAgICBpbnQgcmV0LCBsZW47DQo+ID4NCj4gPiAgICAgICBpZiAobWFjc2Vj
X2lzX29mZmxvYWRlZChuZXRkZXZfcHJpdihkZXYpKSkgew0KPiA+ICsgICAgICAgICAgICAgc3Ry
dWN0IG1hY3NlY19leHQgKnNlY2V4dCA9IHNrYl9leHRfYWRkKHNrYiwNCj4gPiArIFNLQl9FWFRf
TUFDU0VDKTsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICBzZWNleHQtPnNjaSA9IHNlY3ktPnNj
aTsNCj4gPiArICAgICAgICAgICAgIHNlY2V4dC0+b2ZmbG9hZGVkID0gdHJ1ZTsNCj4gPiArDQo+
ID4gICAgICAgICAgICAgICBza2ItPmRldiA9IG1hY3NlYy0+cmVhbF9kZXY7DQo+ID4gICAgICAg
ICAgICAgICByZXR1cm4gZGV2X3F1ZXVlX3htaXQoc2tiKTsNCj4gPiAgICAgICB9DQo+ID4gZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvc2tidWZmLmggYi9pbmNsdWRlL2xpbnV4L3NrYnVmZi5o
IGluZGV4DQo+ID4gODRkNzhkZjYwNDUzLi40ZWU3MWM3ODQ4YmYgMTAwNjQ0DQo+ID4gLS0tIGEv
aW5jbHVkZS9saW51eC9za2J1ZmYuaA0KPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvc2tidWZmLmgN
Cj4gPiBAQCAtNDU1Miw2ICs0NTUyLDkgQEAgZW51bSBza2JfZXh0X2lkIHsgICNlbmRpZiAgI2lm
DQo+ID4gSVNfRU5BQkxFRChDT05GSUdfTUNUUF9GTE9XUykNCj4gPiAgICAgICBTS0JfRVhUX01D
VFAsDQo+ID4gKyNlbmRpZg0KPiA+ICsjaWYgSVNfRU5BQkxFRChDT05GSUdfTUFDU0VDKQ0KPiA+
ICsgICAgIFNLQl9FWFRfTUFDU0VDLA0KPiA+ICAjZW5kaWYNCj4gPiAgICAgICBTS0JfRVhUX05V
TSwgLyogbXVzdCBiZSBsYXN0ICovDQo+ID4gIH07DQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUv
bmV0L21hY3NlYy5oIGIvaW5jbHVkZS9uZXQvbWFjc2VjLmggaW5kZXgNCj4gPiBkNmZhNmI5N2Y2
ZWYuLmZjYmNhOTYzYzA0ZCAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL25ldC9tYWNzZWMuaA0K
PiA+ICsrKyBiL2luY2x1ZGUvbmV0L21hY3NlYy5oDQo+ID4gQEAgLTIwLDYgKzIwLDEyIEBADQo+
ID4gIHR5cGVkZWYgdTY0IF9fYml0d2lzZSBzY2lfdDsNCj4gPiAgdHlwZWRlZiB1MzIgX19iaXR3
aXNlIHNzY2lfdDsNCj4gPg0KPiA+ICsvKiBNQUNzZWMgc2tfYnVmZiBleHRlbnNpb24gZGF0YSAq
Lw0KPiA+ICtzdHJ1Y3QgbWFjc2VjX2V4dCB7DQo+ID4gKyAgICAgc2NpX3Qgc2NpOw0KPiA+ICsg
ICAgIGJvb2wgb2ZmbG9hZGVkOw0KPiANCj4gSXQgbG9va3MgbGlrZSB0aGUgYm9vbCBpcyBub3Qg
dXNlZC9pdCdzIGFsd2F5cyB0cnVlIHdoZW4gdGhlIGV4dGVuc2lvbiBpcw0KPiBhdHRhY2hlZD8g
SWYgc28gaXQncyBiZXR0ZXIgdG8gZHJvcCBpdCBhbmQgdXNlIHRoZSBleHRlbnNpb24gcHJlc2Vu
Y2UgYXMgdGhlDQo+IGZsYWcuDQoNCkl0J3MgdHJ1ZSBmb3IgVHggYnV0IG5vdCBmb3IgUnguDQpU
aGUgYm9vbCBvZiB0aGUgZXh0ZW5zaW9uIGlzIGZhbHNlIGZvciBhbnkgdW4tTUFDc2VjIHBhY2tl
dCB0aGF0IGlzIHJlY2VpdmVkIGJ5IHRoZSBOSUMgd2hlbiB0aGUgTUFDc2VjIG9mZmxvYWQgaXMg
b24sDQp0aGUgTUFDc2VjIGxheWVyIHNob3VsZCB1c2UgdGhpcyBkYXRhIGFuZCBpZ25vcmUgdGhv
c2UgcGFja2V0cyBieSBmb3J3YXJkaW5nIHRoZW0gdG8gdGhlIHBhcmVudCBkZXZpY2UuDQoNCj4g
DQo+IEJUVyBoYXZlIHlvdSBjb25zaWRlcmVkIG90aGVyIG9wdGlvbnMgb3RoZXIgdGhlbiB0aGUg
c2tiIGV4dGVuc2lvbnM/DQo+IGUuZy4gY291bGQgeW91IHVzZSBza2JfbWV0YWRhdGEoKSBoZXJl
Pw0KDQpPdGhlciBzZWN1cml0eSBvZmZsb2FkIGxpa2UgSVBzZWMgb2ZmbG9hZCBpbXBsZW1lbnRl
ZCBpbiB0aGUgc2FtZSB3YXksDQpzbyBpdCBsb29rcyBsaWtlIHVzaW5nIFNLQiBleHRlbnNpb24g
aXMgdGhlIHByZWZlcmFibGUgYXBwcm9hY2ggZm9yIHN1Y2ggdXNlLWNhc2VzLg0KDQo+IA0KPiBP
dGhlcndpc2UgSSB0aGluayB5b3UgbmVlZCBleHBsaWNpdGx5IHRvIHRha2UgY2FyZSBvZiB0aGlz
IGV4dGVuc2lvbiBhdCB0aGUNCj4gR1JPIGxheWVyLCBzZWUgY29tbWl0IDg1NTBmZjhkOGM3NQ0K
DQpBY2ssIHdpbGwgYWRkIGl0Lg0KDQo+IA0KPiBUaGFua3MhDQo+IA0KPiBQYW9sbw0KDQp0aGFu
a3MgZm9yIHRoZSByZXZpZXcuDQphcG9sb2dpemUgZm9yIHRoZSBsYXRlIHJlc3BvbmQuDQoNCg==
