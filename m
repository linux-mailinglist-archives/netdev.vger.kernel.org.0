Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F232534FA5
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 14:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347390AbiEZMyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 08:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239665AbiEZMyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 08:54:35 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1272C675;
        Thu, 26 May 2022 05:54:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7W/ybh3X59KKLwLBhbQHAS4xg7Ey7DvUAGoRFiL2r4mMFbAEXTUnG0RiqPAFSn+VOcbSnlKLE13sQ2/ze0Fla2+zm0kgfU9OrFOEUQkchQJbrDorfk6L6xJzfJCeuFD2IZFl16mKTfBw6xswhVcg8v4dgf586OgRkH5iIHutQl+qICEDistdcwtb9odKmFdKboEFZUIO1nz4s+a2vELTrBXnPpj0XSpZT4KJl/6+Tf2JF3Iny9fzpuvZJIHQx7vAtb+ap7Z5SOwu+KZcvhrSHuoQvqYIiSiULyDcmrnlbxyu5FsrpKyFyi5Aq1t/q2gdp+mKPFTadMfGq1mKQoGMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LgjMUgX4uJpo/CuL3o0VRlaIb6bfjBl8kmjrQ+OjpnE=;
 b=NKcydte8luTZU/88gjTedTjE9HtMg2yDN7nvfXQ0Uy3VGEFWQ+vhRG4OkIUAvMTBsthUBUAoss/3LDww1DakSSXMHFXacUpMD7aTw7JMFt4klOctl9fZCDpKwR05ElIVxy+KUmx6wDvsyWbbMw2cBeaQBzioC9Be+wx2al2Ilzja0S9rWQNcqvrtigc13rP3txuot638mrJLwDDpuwlh10Jn690IcRXNW2fhVMckGy+LG+8R8rZd8OyI9BMD119uSKlCm3zQARTQRmVE7/U/ufYu2h7M0rnhQU3EdbIz+LOACvB1AIYY5XvvBf5cB9Y4/XZhpk5hT2CwXICsEcLL/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgjMUgX4uJpo/CuL3o0VRlaIb6bfjBl8kmjrQ+OjpnE=;
 b=Mq9yJSgK0m1z3+Ll+DY+N3gczsAjpBmbUnAEXayUNH0Ojw5F4WOqqTSdDq1qsZk9XZYEi/ppjIBcuXReORM5MxH2prZiPWKKfeeBxcaIfZw/J/cNjnKgHFGn65FHO45NZIulWBDHybTSI4BTuD8lncG1mIUzjgkyL38YLBpxoU3k0JNumkfMcls8awu50cD29yEVrdNkqYSXz8VvKEvnvGjdcRik3l5G/u+0yizFFJSP+1FLUxlwZDSbSxyrhKZNGghFtXME/B8ggZgROOjsZ0LPnKdxl0uSEahkeINVnxnFFrxrQFHlwfSxDNy1nmdKwKihMY89cpunqXakl37l1g==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by LV2PR12MB5750.namprd12.prod.outlook.com (2603:10b6:408:17e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 26 May
 2022 12:54:32 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::489d:7d33:3194:b854]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::489d:7d33:3194:b854%3]) with mapi id 15.20.5293.013; Thu, 26 May 2022
 12:54:32 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "martinh@xilinx.com" <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "tanuj.kamde@amd.com" <tanuj.kamde@amd.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Subject: RE: [PATCH v4 0/4] Implement vdpasim stop operation
Thread-Topic: [PATCH v4 0/4] Implement vdpasim stop operation
Thread-Index: AQHYcP5BrBz66eonZEeOxjwIzt98aa0xHKkw
Date:   Thu, 26 May 2022 12:54:32 +0000
Message-ID: <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220526124338.36247-1-eperezma@redhat.com>
In-Reply-To: <20220526124338.36247-1-eperezma@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba865296-b730-43ed-5383-08da3f16e13d
x-ms-traffictypediagnostic: LV2PR12MB5750:EE_
x-microsoft-antispam-prvs: <LV2PR12MB575093E795114441AEEADD7CDCD99@LV2PR12MB5750.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jHWa0JS1QF3ZxSh+IMaZtFAZn4RtdiowosYQIwBAUrIlxvKe/lV+7vJsvGrQeq0mrJFPXA48ud/fpxXVSmLiGtWINCk0LadykjPm5l9juNgqKRFGazkDpRhYkhMNTaxjbqyxhm/wDyJ5mikf4SZIB/mmjRHPLLpAHngp9qR5ly7SeUojl/FbLlK2ZJJ9cgqPwDVIjMuo+M6eMnpvLRyoBsAK0iBuQ0GjY5xsrnyjFbPPl2nZ8VRpaWkQJmaQ69rOTZF97My4ukAfok6MQfK59bFMLCfcfejFCfZx8D2JyU40KQScpafl9IoG+EVEUas0S5dlit9YnP5jdvAPs4lcSBH4SrK1kymd1CDFkW7VTEWXQbt6Bkoz3hSSZarWhlnxDsr+H7l+uDn7D/JdYiBiDnXHKyfh3sE0/wMC1/QwFlc3Pq1aMOE3ZHOyKsyM8ka4Y+BeW0i6NKOupOZWguqlAIkf1R1ahsNKnJJx66Xa1HpKBiptxxLbgMFN6snNFi1zDJPnzXYiq/YBeoGegZPkSkUh0CeMOyH4f1YrF+bFrhd4LSsoQlca+tZpdXyCNTgDNC+c7+vhW22bMXvkC6ORIAXGrVF2LyN81Svm8stboMJCnx01kt1ukUenLIlsSkVvS0V8hRHAb2vUvuACPFDIOSYlGVKC3f9I0bm7Z8olFNEqGQJSl8edmp2sMebXnrWS0szeNlCPS2xpohNJO5s1iw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(66574015)(83380400001)(110136005)(316002)(66556008)(66446008)(66946007)(66476007)(64756008)(76116006)(54906003)(122000001)(38100700002)(33656002)(7416002)(8936002)(5660300002)(4326008)(52536014)(55016003)(8676002)(508600001)(71200400001)(38070700005)(186003)(9686003)(86362001)(6506007)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bVd0eTNMNmpXK0ZFNXlDYWVpb1BmUDA5Q2JFZ05PWWJ6azBuQWQ4cWFOaEJ3?=
 =?utf-8?B?cTl0QnYveGVMaXUwaUNla3h1ZWxjbFhGZVF6RG1NdE5ndlFpT3pYeTZGc09X?=
 =?utf-8?B?dzZoWGRTWCs0U3FLUFZxT0g0ZHREOC9GbjVLeTFHeVRyenAzMjRJS2tmYUd6?=
 =?utf-8?B?RjV0WHdIUUhORU5ab3hsYzRZbEE5MXl2K1NEQ1V2L1NqYkZIUU5MeDNza1JD?=
 =?utf-8?B?djkybDZ4WDFuZFZrSHh1UVNaRzErNmdkMXdKdlBLbXRUbUdOUUI3by9UVVdW?=
 =?utf-8?B?TkZwazBsVytBTGJPNUhCZE9JZmREZ2svODhaQy9CN3RZVUhVV0FjM0dxcTJX?=
 =?utf-8?B?cFduMGpaMGxVL2NzN1pCK3U3NHMxTnV1N0VLem5FMjhTaWwxVjFsS1Nmb2tp?=
 =?utf-8?B?QWk0UEZ4TThjZ09OWlE5SktGcFhiU056RVNVVVF2TW1nYVplclU3S1Z3K2NO?=
 =?utf-8?B?cWxJS2ZzSHgyTFdGMzlBN2dGYmJRQnJwaTRRbVZJcU5qNE1XbEM5WTVoeHQv?=
 =?utf-8?B?T3JGbWZhLytNcjlpeUlhRnhCeVVqUUNBeloxemtrZCtWakZkeDdTd0todWdh?=
 =?utf-8?B?Q2hLQkdSY0hMeDNkYUQraXBjTVlvNjJiQVg3RG5jVFVDT3VndHl4eTZWZ00v?=
 =?utf-8?B?ekxtYzFXaEloVG8zb1BHV284MU1xQ3BpZlpDSWlWOUY2aHdscDdvdFZBdDI2?=
 =?utf-8?B?TXltSlFtTkdacU9xbkZPN1M0SU82Z1pVNWRWbkI4NUgwcUcwVmdPUWRaNEdq?=
 =?utf-8?B?WjBFUXZxV2djVW9KaitOcktxTW0yT2p3d2JSc3FRWUxySGo5b0d1a3EzSkcx?=
 =?utf-8?B?clpVdHJCWVk4Ym43WmtXVWZUNXVuRExVS2JQWTQyUVo4UTNyWXBKQ3NBd1lq?=
 =?utf-8?B?OUpZM2dadUxiSWY0NVgzb0wrZUloSE8ybGE5Znk0NmljUzl5MEdVbTEzUEZo?=
 =?utf-8?B?MHhhT0IrVG1rR29IMVo5akgwWDllUGkxYnlMZmF1L2RmNno3UzBWMlU0YW5o?=
 =?utf-8?B?M2t2VkJFNWU1MjliSUlsam1NOWdaR1Vod2xQd1BPb0NMR3l5OUkvMnVzOTB3?=
 =?utf-8?B?L3lBOHhXbURUQ21XcGE0NGxEMXgyM3BlWUFhOG45bzludkRFZHJuWWRTdTBY?=
 =?utf-8?B?ZG9kcEc1S2ZtTHM0Si9CR1VESThaVkFPVnhicEdHUzdMMEpHaEIxQkhqS2xv?=
 =?utf-8?B?NzgrZWNkTHN3TTNmN0JYWkFvVXd3WHU4NXREMTFTYnBYVWdtV2JwbzZDdmFS?=
 =?utf-8?B?aDVvZWRYUUlyOFhZQ0NPQ3VBTDI4cGRtVUdIRXBGWkNMdXMwVE10TFVQd2d5?=
 =?utf-8?B?LzVzbnN0WS9vVXFRSkFEdlViaklrcG5WZW5NM1V1Q0E2cVhGZEwvUkZjeWJs?=
 =?utf-8?B?ZG1ydytrNEF6c2dDSWNQV2NZdzhhNlR1ZHQxNVNYTDBsdWJKVktWcXhQSUdH?=
 =?utf-8?B?K0N4UXNKcjRiakUxdDJGV2JxOEkxR2dvWDdyL3NoWGJhNUplNlBlSU0xV0VW?=
 =?utf-8?B?eFFOcE1oSTVjNU9qdGw3M0xWZ3NJVEVwbEs4OUFvZ1MrVmFlcUltNjd1a2xq?=
 =?utf-8?B?T1RtYW9IeUI4QW9BV3E2SmNnbDJZckxwdGhUNVpSdFpwRjRWcDdxQnFaeWdp?=
 =?utf-8?B?bHNCUUpyNU1SZmpqL042YVFNcFBzVWVydXQrdkVqMWlOZ3dHVG1NNUUvZ2Na?=
 =?utf-8?B?NnZ5dVVveTVJZ3paQmYwdFdBUWlxMFBid21MaTh4UzZlUUQ4R21xUW9WUHVr?=
 =?utf-8?B?TnY1dWJkMysxRHMxOVRKaGtGNHVBV3NYTk5FQTlsc3ZFL2FzWVhsSkdSRVdD?=
 =?utf-8?B?RjB2UzRtK0k5aVBveTQ0c0JaYmRYdTVlT3NlekR0aW0zRlJ0QytXV0RteTZo?=
 =?utf-8?B?d0dLdXlSNUd5VFVsN2VwL0JzdGRVOW9KVDhOTTQrVW5VSU9CcXdLOXhFVjd2?=
 =?utf-8?B?NVVsYU1BbTJ2R3IwSXdrdExGUE9hWGFGWTFjbld6NEp4UjEvYmJmZHoxa2dY?=
 =?utf-8?B?dkp5eFhwN01yQ00vSHZJNGtUZUlSdXJ3WnN2Y2ZuRkxiNm9GcEtxbzVlbjBX?=
 =?utf-8?B?Q1hHOGpCcTRwMS8xbHJoQUhScVpZc3c1VEZnakRsVVgzL2preTIyR1NKQ3Rs?=
 =?utf-8?B?Wk1uazg4U2pLZUx6Qk44R0NqTzI0UWI5MUNTTVRrbElOcmlZVGFHZnJHbFNI?=
 =?utf-8?B?M1ovMlVpYlFvaXZneWZiek9KelNVNXhvOU5VNTF4RUt1eWt3S0JucEttdFNl?=
 =?utf-8?B?S0hyMkx3ejNSL2V6T2tybTFVTzQ2MFRGcldjbStwSGJJeGVTczRZeEo3ck1U?=
 =?utf-8?B?L0VGblR2QWxZRGNuWmFxRVhiYmkxbXJZK1U1ZVRRKzRlM2J4dUZvRGhKOWUx?=
 =?utf-8?Q?qTnqsYvdlzO/ih94h/bojm3NWs1o5aKCeG9dvz/fbwJwU?=
x-ms-exchange-antispam-messagedata-1: 6xu3VRms5jwUMA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba865296-b730-43ed-5383-08da3f16e13d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2022 12:54:32.6444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WWDT2jE/Uplj0D72bDfvzC2cHM+80BtJ107K+WRVhp7zlGD2Ascm4s0mfrtZIQ6mha1eHjNB/YlBewXm7suMSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5750
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRXVnZW5pbyBQw6lyZXogPGVwZXJlem1hQHJlZGhhdC5jb20+DQo+IFNlbnQ6
IFRodXJzZGF5LCBNYXkgMjYsIDIwMjIgODo0NCBBTQ0KDQo+IEltcGxlbWVudCBzdG9wIG9wZXJh
dGlvbiBmb3IgdmRwYV9zaW0gZGV2aWNlcywgc28gdmhvc3QtdmRwYSB3aWxsIG9mZmVyDQo+IA0K
PiB0aGF0IGJhY2tlbmQgZmVhdHVyZSBhbmQgdXNlcnNwYWNlIGNhbiBlZmZlY3RpdmVseSBzdG9w
IHRoZSBkZXZpY2UuDQo+IA0KPiANCj4gDQo+IFRoaXMgaXMgYSBtdXN0IGJlZm9yZSBnZXQgdmly
dHF1ZXVlIGluZGV4ZXMgKGJhc2UpIGZvciBsaXZlIG1pZ3JhdGlvbiwNCj4gDQo+IHNpbmNlIHRo
ZSBkZXZpY2UgY291bGQgbW9kaWZ5IHRoZW0gYWZ0ZXIgdXNlcmxhbmQgZ2V0cyB0aGVtLiBUaGVy
ZSBhcmUNCj4gDQo+IGluZGl2aWR1YWwgd2F5cyB0byBwZXJmb3JtIHRoYXQgYWN0aW9uIGZvciBz
b21lIGRldmljZXMNCj4gDQo+IChWSE9TVF9ORVRfU0VUX0JBQ0tFTkQsIFZIT1NUX1ZTT0NLX1NF
VF9SVU5OSU5HLCAuLi4pIGJ1dCB0aGVyZQ0KPiB3YXMgbm8NCj4gDQo+IHdheSB0byBwZXJmb3Jt
IGl0IGZvciBhbnkgdmhvc3QgZGV2aWNlIChhbmQsIGluIHBhcnRpY3VsYXIsIHZob3N0LXZkcGEp
Lg0KPiANCj4gDQo+IA0KPiBBZnRlciB0aGUgcmV0dXJuIG9mIGlvY3RsIHdpdGggc3RvcCAhPSAw
LCB0aGUgZGV2aWNlIE1VU1QgZmluaXNoIGFueQ0KPiANCj4gcGVuZGluZyBvcGVyYXRpb25zIGxp
a2UgaW4gZmxpZ2h0IHJlcXVlc3RzLiBJdCBtdXN0IGFsc28gcHJlc2VydmUgYWxsDQo+IA0KPiB0
aGUgbmVjZXNzYXJ5IHN0YXRlICh0aGUgdmlydHF1ZXVlIHZyaW5nIGJhc2UgcGx1cyB0aGUgcG9z
c2libGUgZGV2aWNlDQo+IA0KPiBzcGVjaWZpYyBzdGF0ZXMpIHRoYXQgaXMgcmVxdWlyZWQgZm9y
IHJlc3RvcmluZyBpbiB0aGUgZnV0dXJlLiBUaGUNCj4gDQo+IGRldmljZSBtdXN0IG5vdCBjaGFu
Z2UgaXRzIGNvbmZpZ3VyYXRpb24gYWZ0ZXIgdGhhdCBwb2ludC4NCj4gDQo+IA0KPiANCj4gQWZ0
ZXIgdGhlIHJldHVybiBvZiBpb2N0bCB3aXRoIHN0b3AgPT0gMCwgdGhlIGRldmljZSBjYW4gY29u
dGludWUNCj4gDQo+IHByb2Nlc3NpbmcgYnVmZmVycyBhcyBsb25nIGFzIHR5cGljYWwgY29uZGl0
aW9ucyBhcmUgbWV0ICh2cSBpcyBlbmFibGVkLA0KPiANCj4gRFJJVkVSX09LIHN0YXR1cyBiaXQg
aXMgZW5hYmxlZCwgZXRjKS4NCg0KSnVzdCB0byBiZSBjbGVhciwgd2UgYXJlIGFkZGluZyB2ZHBh
IGxldmVsIG5ldyBpb2N0bCgpIHRoYXQgZG9lc27igJl0IG1hcCB0byBhbnkgbWVjaGFuaXNtIGlu
IHRoZSB2aXJ0aW8gc3BlYy4NCg0KV2h5IGNhbid0IHdlIHVzZSB0aGlzIGlvY3RsKCkgdG8gaW5k
aWNhdGUgZHJpdmVyIHRvIHN0YXJ0L3N0b3AgdGhlIGRldmljZSBpbnN0ZWFkIG9mIGRyaXZpbmcg
aXQgdGhyb3VnaCB0aGUgZHJpdmVyX29rPw0KVGhpcyBpcyBpbiB0aGUgY29udGV4dCBvZiBvdGhl
ciBkaXNjdXNzaW9uIHdlIGhhZCBpbiB0aGUgTE0gc2VyaWVzLg0K
