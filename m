Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20062351809
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 19:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbhDARn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:43:27 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55968 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234783AbhDARkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:40:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 131CPLb0019081;
        Thu, 1 Apr 2021 05:33:13 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by mx0b-0016f401.pphosted.com with ESMTP id 37n28jjdft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Apr 2021 05:33:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoiIEPjU8pLeWzplxwQSu1bwyeoN04yQjwb5bhp7IEfPwO1RCVHLiKsGyJC5Rs95QZSkmDvTseQGulg5j0uWVpNYb99hv9QrPODTtv6m4GrrmWENWsryDHxtzFQv3vnDfCEqcSq7ZJHtvocCcsRMWoiHB4XMpZTrwgRv67LUlODikrTJ63pW2tjqzgqCSDFwWEyNf2ji60aBL3wMuLJilk0Meeis70Yr50PKIPZ1y72jCssTh0F2Au6QnUsEIxEiaVLko4noCEORu8tDCXx4ak+ZnCSLC5ZwLlnovGOazpCLDE0QHJOZZ5OTiJLkxVad4A2MK2JvrzU0nYSe8AZS2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1TVQ7QPpvQI7UcBcB0q8sllCJWRPqSXHtPl3gCY6W34=;
 b=mA59UO19r0m8fgvLj74WjExvONUGs5RJi0KuXr2v8ruhFHh+DBXxxXbrEAanatidqrgXTtfrlrblXzgDi8/afK/1SScjxzquppZyCa+iIHNtdFPK09sKQ2/Pz+4T5eH1VuabE9KPUUReJdrdEDENEC9qfh+2un7VE7NuS9cNwj716b8zhtz53RUuZfEysy3E/YhtOn0kZDdsjIEj/b6+JrHP/PVfww5r0rVyLJIDY0C5qEMMIsUpFPPRYnZV8Hjrs1JsMQLqL/qiHC1+g6UTyNO1t/7s9mP4S3R2NJR+/wXSXB1VqIIqqkTQS3GCmbJsvkqi1NiqNGng+QmKG5nz/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1TVQ7QPpvQI7UcBcB0q8sllCJWRPqSXHtPl3gCY6W34=;
 b=WxS/NPUWiWsyVfhomhngde8xyYUQgT6+GR3A1yDSb1C2Jp1KoO7yYlYs1iQswRe/IbK1R0CrMplDO9oyshe6dSSzZZiDCSN04AODprUUmS1G9/Wz6dpysJW/q8tH9LGj7r1yXrNNcToR0YWFOymrBaSCSbgz65bkSTXI41KAiA4=
Received: from CO6PR18MB4417.namprd18.prod.outlook.com (2603:10b6:5:354::9) by
 CO6PR18MB4434.namprd18.prod.outlook.com (2603:10b6:5:35d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Thu, 1 Apr 2021 12:33:12 +0000
Received: from CO6PR18MB4417.namprd18.prod.outlook.com
 ([fe80::515f:df55:c195:592c]) by CO6PR18MB4417.namprd18.prod.outlook.com
 ([fe80::515f:df55:c195:592c%7]) with mapi id 15.20.3999.029; Thu, 1 Apr 2021
 12:33:11 +0000
From:   Kostya Porotchkin <kostap@marvell.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Re: linux-next: Tree for Mar 31
 (drivers/phy/marvell/phy-mvebu-cp110-utmi.o)
Thread-Topic: Re: linux-next: Tree for Mar 31
 (drivers/phy/marvell/phy-mvebu-cp110-utmi.o)
Thread-Index: Adcm8pRrFWnR3zXuSdSD++QJWH4WSQ==
Date:   Thu, 1 Apr 2021 12:33:11 +0000
Message-ID: <CO6PR18MB4417A9BE44A8879928B0D0A7CA7B9@CO6PR18MB4417.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [5.29.56.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1730f5b9-eeac-40b9-45ed-08d8f50a500f
x-ms-traffictypediagnostic: CO6PR18MB4434:
x-microsoft-antispam-prvs: <CO6PR18MB4434D7670C7FA3364117EE2CCA7B9@CO6PR18MB4434.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gSR+BBwFg0sGvDH3IYzF31XejN52KbFO9gajySqy4hixN4Z4xOc/0d0oqwc1n5dZOVdRjCCuykVM4IfnUSF1B8w37mgHQGCv+fLSP0hcaY9u4yFAUszjNQLvUCCR7Fv2aTLPRreH2RpfgOmJb3dOZZwE7OJp5rGtEuu+xcFdqYzq8KIH5BNPH9uLbvnKKb6/T7lBvFUcIlwGBSBsWzLoR8AKkKLv5BjwtbUr0l/9m0uaLMJhaSFqbtu8B9OAyPSMDJ8uYcf0EVg1wjuRhT5kA2M4AwInYoW9ixfL1FJ1Yml87U/J/2/8U3oZZXoLjZj9Sz9nhTpKxZmNSEM1lK9246QL2wUJa8K2HTyKNLsK5+3NWwwh3I86kYATYKr7SYFbutAeUbzo3N7DbJbYrep4mk5BmW66T9B8Nfu1stR9fjqLm6d/gwRIE6NvsO2IBzFbSS1zdUYANfvAIibTA2TkrheYMKFRz0bU5q1B1koVFzNxmNHZ+ETp4YB9XaSeYDE8/ZdgijgdrGMM/yH0SS8Kwiiw/9/vQ0DH7mXAIh4P2LHPgjyYiNurbMwkKyLNpRZV8DVm8YDX9jjCRHYMRKTjsqii0PGrFjdsYPEoCDJDb9VwpN7BTmsfzLCMNPbg6fmT4SCVw4G3xov0Aa5NKziFFgCEhpRFWUQODKYpb/9aSUk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4417.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(66476007)(83380400001)(6506007)(64756008)(66556008)(53546011)(2906002)(66946007)(71200400001)(186003)(316002)(54906003)(86362001)(66446008)(33656002)(76116006)(110136005)(7696005)(55016002)(52536014)(5660300002)(8936002)(38100700001)(4744005)(478600001)(8676002)(4326008)(26005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Z3hvSzhPbUZ3K3gweC81VklrNzZpRnRsUkV5OXZxSnNmQUZ6VHVmRWpOSzFq?=
 =?utf-8?B?YUwrM2VSeEozSWd0enRBUUY0NDlRMzVDaXVpenpXZFVkN0lXY0IydngrY1li?=
 =?utf-8?B?NDdzQ2NjOWhOMENsN0ZwYlA4UkVSY3hqRWsvekFwRXMzWCtsZzJnU2s0Y1ZB?=
 =?utf-8?B?RHI0T1FRYllPNW9PVlNZdEJsWmdGQ1N6S2FqcENPVEdLdHRPWjlWMkxSTGEz?=
 =?utf-8?B?RzZRSGdvU0taR2cwSzBzTndKNm9nM0VldHBkTWIzLy9JNkIvZTlMQ0hvOEh4?=
 =?utf-8?B?K1pPbEJJdk9Pak5GWG0zbUoyK3JXOGtHSDRsS0NRUlUyR0RuRUhESWtvdWhF?=
 =?utf-8?B?T2N6YlZ6czJEVktFd0NvWXhvaGNueTF2by9GU2VpSVBqdk9KZUcxYXV4K3Zh?=
 =?utf-8?B?Ky8wTnd6RTYrZ3lDQ3BPbkpHRm9CRENzSFBqeG5oTVBuRGdKNkgxYnhnOGg4?=
 =?utf-8?B?Y3I4L3VqaHdRV2s0NmVvSlFucEZKclFuWW1JMEhlQzRKU3JTQnYvejMraER4?=
 =?utf-8?B?QVZNZGxqSFgwNDlUVURMbERab0cxWXA1SytNcWd5cFNJZFl4ZVFkSk5wejhL?=
 =?utf-8?B?SGpPbXRaekNFSFJSZ3Z0NXNvOWRpQlZCV09rek1Wekc1bmlMdmRYbnNyV1RB?=
 =?utf-8?B?aG5VUW9EVkptVFp1NWxCajJGL1dhRUZEMWNpbXZ6VnlyQnMzZ1l3REZPVTlD?=
 =?utf-8?B?VmhwVXpVc1dndVRrV25IWmRidnlCOGo1UTRPTUw5bXQ2TFNtZ1k5YTRRbWU4?=
 =?utf-8?B?U2cwb0hWZ2ZqODNwSi9UMTQ1MUN6OUNnczd5TUprNzZEUTVSY29OWDhKQ3FF?=
 =?utf-8?B?L3B3SmRGNDlYUGNQakZWSzk1a2o3L3A4T0ovVVpScmhHU2pWNzdpRnJTOHZ6?=
 =?utf-8?B?RGs1OUU0RUV0NnN6cTh4d2lNQnpYajFKSEhXMEZhUkMwWnhYd3NZU2pNWEJL?=
 =?utf-8?B?Q0dkQ0lwTDdpcTNQbTRIUE81SSsrblRiNG45RGxGL05XSnlUcHVFckcweksx?=
 =?utf-8?B?MHJWaXl1ekcxRDBtL0puQ2drS2NpdHQ4RFhGallDeFE3TEI3RE9NVHpnY0JT?=
 =?utf-8?B?bDZheXgzTjdWS256SXRicjZ4emF3UEw1aXBBMDQ1eVpZYnR6eFEyT3ExeENL?=
 =?utf-8?B?c25aSW9rVnpyUjJldU84d3I5Z1phSnlpZlY1bzZaSExLRXh5am40VTA2b3Bv?=
 =?utf-8?B?YzZxZnd2bVR2TDg1Q3N5YTlFWURMU05GUEFIbVhpbmFSV0VldWhsWXJnMnp0?=
 =?utf-8?B?aytRRGdJMkJtL0draC8wbm9Ia0VnYmFicnFEcHZzZWJGckpxaURLTzNQcHpO?=
 =?utf-8?B?U2JYcHJ1L3JkR245TjhPUkl0cUp2aThHek45b1JjVkxHRWp1U3kwS3ZSb1Rz?=
 =?utf-8?B?RzhscEtVTGpKcm83dEViMGFpbEZyQmpJS0p6SytHSlJpK0RWd0hCbzdnRGI0?=
 =?utf-8?B?Zmk1NFNEaktiaWQvdzlsa04wUmpXODhWRnF5WDM1bG1HTE5yV2ozYm9RNEZs?=
 =?utf-8?B?YlIvL2E5RzErZlBabFU4aFBIWlovL01YZ1NyMWJHWHpqcG5zSVlTbk1jUXpE?=
 =?utf-8?B?M3F1K3VORldjUDMydmxFaXdDUFErNEdUdDg0ZTFpWTI4SEduS3NSYWtGeTRO?=
 =?utf-8?B?cUhUTVVaV2JVNHcvclgra0NHZ3lrajZ6Um9nOXo5M09pbVdzYVBLaUtUdmdN?=
 =?utf-8?B?WE5xaUx1c1dHcktwMytDSnJDRUFpZE1wdEdCTTBxdGR5MkRabmg0QzNTa01w?=
 =?utf-8?Q?DCjb+0yQWfCmgaBcZk=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4417.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1730f5b9-eeac-40b9-45ed-08d8f50a500f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2021 12:33:11.0379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AS/pve7Q1G8hCoUU92zNjopr/Cuwcf+pdSdJ7eJq8HoyyHgoBk4ppWy4rzJ7i0/SSlUM063DRl8tgz7HFeQguA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB4434
X-Proofpoint-GUID: zO3F7QqKCm4U2D3VGA6Pwa9scFDmepL0
X-Proofpoint-ORIG-GUID: zO3F7QqKCm4U2D3VGA6Pwa9scFDmepL0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-01_05:2021-03-31,2021-04-01 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksIFJhbmR5LA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJhbmR5
IER1bmxhcCA8cmR1bmxhcEBpbmZyYWRlYWQub3JnPg0KPiBTZW50OiBXZWRuZXNkYXksIE1hcmNo
IDMxLCAyMDIxIDE4OjI4DQo+IFRvOiBTdGVwaGVuIFJvdGh3ZWxsIDxzZnJAY2FuYi5hdXVnLm9y
Zy5hdT47IExpbnV4IE5leHQgTWFpbGluZyBMaXN0IDxsaW51eC0NCj4gbmV4dEB2Z2VyLmtlcm5l
bC5vcmc+DQo+IENjOiBMaW51eCBLZXJuZWwgTWFpbGluZyBMaXN0IDxsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnPjsgS29zdHlhDQo+IFBvcm90Y2hraW4gPGtvc3RhcEBtYXJ2ZWxsLmNvbT47
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogW0VYVF0gUmU6IGxpbnV4LW5leHQ6
IFRyZWUgZm9yIE1hciAzMSAoZHJpdmVycy9waHkvbWFydmVsbC9waHktbXZlYnUtDQo+IGNwMTEw
LXV0bWkubykNCj4gDQoNCg0KPiANCj4gb24gaTM4NjoNCj4gDQo+IGxkOiBkcml2ZXJzL3BoeS9t
YXJ2ZWxsL3BoeS1tdmVidS1jcDExMC11dG1pLm86IGluIGZ1bmN0aW9uDQo+IGBtdmVidV9jcDEx
MF91dG1pX3BoeV9wcm9iZSc6DQo+IHBoeS1tdmVidS1jcDExMC11dG1pLmM6KC50ZXh0KzB4MTUy
KTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0bw0KPiBgb2ZfdXNiX2dldF9kcl9tb2RlX2J5X3BoeScN
Cj4gDQpbS1BdIFRoaXMgZHJpdmVyIGRlcGVuZHMgb24gQVJDSF9NVkVCVSAoYXJtNjQpLg0KSG93
IGl0IGhhcHBlbnMgdGhhdCBpdCBpcyBpbmNsdWRlZCBpbiBpMzg2IGJ1aWxkcz8NCg0KUmVnYXJk
cw0KS29zdGENCj4gDQo+IEZ1bGwgcmFuZGNvbmZpZyBmaWxlIGlzIGF0dGFjaGVkLg0KPiANCj4g
LS0NCj4gflJhbmR5DQo+IFJlcG9ydGVkLWJ5OiBSYW5keSBEdW5sYXAgPHJkdW5sYXBAaW5mcmFk
ZWFkLm9yZz4NCg==
