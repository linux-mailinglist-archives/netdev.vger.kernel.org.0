Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F214A604F72
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiJSSRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbiJSSRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:17:02 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11020027.outbound.protection.outlook.com [52.101.51.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A401ACAB5;
        Wed, 19 Oct 2022 11:16:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rnf3hlLBYjyWKNwOjU/yDhxFcpqxS7WSbUhB/yTakRpo1o6Sm2Yx3Z6j+Eggk4rJuJAgoYypxEBhwVG/wtu/y+iGKBgTm3ZHiKYnFt6lt/E9vj4avIXCBGQP1Pgnn+IztRwD/lkpm0yxSwmzAVb6qz0gjPT++RQmhkxaNBfRpFUaJpjuBnnwBmurkkAMBYqUjxb4t4X7QDv+/HJeL8PcZOLW5xUWWKLELh6l9cziSnpsM3tJNISp6IouLcGbv+o2JENY3gnF3Zig67LnAANw8zsrSnBq+BqqYDjUhX8oMNEbu3aSCAFlrzGqED+NSaZqt0Sa00Onz4iuMon/2e+ENg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ud4CbnKMvbtHVbPgoiWb2a1rZtwDRVbhw9zO/rdFF+o=;
 b=UTe/2dDLepG8FmniVltVhlkeKHtUxvyVX4SDsmpR8wC67MNbYizxcZAIe8yGIUD9SCikJqWzOak4RhQkMFdESksJOF3kKTL4UGDW4DLzdh3/56GWvt09dXkQAU/JQ+xdWF0vja5V93AR90YG6lYJyv0H8XT3RDUCpYYl360L51Om/j+P8AOHfADWLdUMOAxNsvN46AsnVMkix4U+3KXzvqDcF22o03LgqstOC0RcQcrtxbSjImm/lS5SEUn5V4XuTi/pEfy6M2cNkbmlqmA3lz4voBsEK37f8tphEKp+t5yEGBScN2Qp2sM2Yp/2pIzBzjR4ocLC9toyGqKCQGJQ2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ud4CbnKMvbtHVbPgoiWb2a1rZtwDRVbhw9zO/rdFF+o=;
 b=YGHe7snTQBuJLJcwzAmXnEbgOaItN7VS149KtKCcssv1+VcfMTn09AwPiIBFHkZP9b7/DdmFLne2wRNQzVWs9SZIqvCQhCOEZRPbMroihCmsk5qgngk5Iq8vqvICJgPndIEKSgAqkSPD3LidhoFcmDCZZKiPwcJmFnikle8ssqI=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by DM4PR21MB3155.namprd21.prod.outlook.com (2603:10b6:8:67::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.17; Wed, 19 Oct 2022 18:16:54 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::7c3c:5968:72d6:3b5f]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::7c3c:5968:72d6:3b5f%9]) with mapi id 15.20.5769.004; Wed, 19 Oct 2022
 18:16:54 +0000
From:   Long Li <longli@microsoft.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v7 10/12] net: mana: Define data structures for allocating
 doorbell page from GDMA
Thread-Topic: [Patch v7 10/12] net: mana: Define data structures for
 allocating doorbell page from GDMA
Thread-Index: AQHY4l2anEXKSlj6vECuYw6HgRfzEq4U38mAgAEpVQA=
Date:   Wed, 19 Oct 2022 18:16:54 +0000
Message-ID: <PH7PR21MB32633B6902D7577C279C5368CE2B9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1666034441-15424-1-git-send-email-longli@linuxonhyperv.com>
 <1666034441-15424-11-git-send-email-longli@linuxonhyperv.com>
 <c60518c0-f486-db8e-230c-7d680b0c27e0@huawei.com>
In-Reply-To: <c60518c0-f486-db8e-230c-7d680b0c27e0@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=eb4c039d-8cdc-48df-b176-f2cad75f339c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-19T18:16:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|DM4PR21MB3155:EE_
x-ms-office365-filtering-correlation-id: 3d1dd93e-4b27-48e5-b84c-08dab1fe1a14
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +59wMRtRTLeHYQZH8H91HUXM7PpyvEOLEjN2psJ4+227iOz4EdbURhWi5J5SA0I9pDzI3FtKxVe6xm1/UhroohmfQOj1QkfzMz8cU4sLuafMU2b/Z7ozTCaBW49DuGefLmHXdNoPTJ9cOVY4mj3LOpe6d8qn1QdlUQi8HYzvOlyQABgLU9jO8kWzUAt2QzcI1h/WPFMl9I1kMxod6g0BcZk7YDclI9LzYf6kBooRnF4rnfz25YJTWgrERole37auPqXaIzVR2qRrilq8A4vxybPnJIXjb+tgshrPbA/M+g2nqotRdCn9qS/5cnuBNF/2U8rMHWsx1DS5Q1zfDYGFH0Qew5R7VZEm9lYzCsdsXg3PgqQxso0AQ3f4xQHVE6/TI+Fm0k4Tpau59IIidt0wr9MXxapWT0PEeGPysaqTSvSLAvfqakTRxd/7HX1uL2pSk36m+ln1b5yL5sr5u3Jiw3oMFGRnczQ2TfrkhYXYYb4AWZ684vVFbCB3PZpqKRR6x7nDWNdWtduHwZCvNJ3FeDROuCM1UcQZP/AuR/BmDbZvdo7POfbX9QNb0WVWGDt680dqn7wzTA4/gdhX867EHTD4/4SUi9EfpcZ/H4uAJ87fUmD+fJEE6XcPMQ29ojSGbXHR3YgWw/Ts0HpPJHnBSwniwxnNlp7qWfKcGdg1f8wusiawc1aKMjsk0IvPwxt/1WddV8d8U5Z6X2ZoX5nu4E1I2tZpUp9K0Lu6jZTBZReOZVqVguTWsOP1C6NkUoIcscTFHQXLngK6wFPMZtwM3v11OjIMhPN7OYIq+W3kd4kkfVa+5OAQEcMnseS0EVcBiD8pGVpLeLJDGjUdhYG5jw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(186003)(7696005)(26005)(9686003)(6506007)(7416002)(83380400001)(53546011)(8990500004)(55016003)(5660300002)(41300700001)(110136005)(10290500003)(478600001)(316002)(71200400001)(8936002)(52536014)(54906003)(76116006)(66476007)(4326008)(8676002)(66446008)(66556008)(66946007)(64756008)(6636002)(2906002)(86362001)(33656002)(82960400001)(122000001)(921005)(38070700005)(82950400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWg1VHphaDlIem52bU9LTWdqb0l0S2k2c21ubThwN3RpT2xoV3BIeFFrMWs3?=
 =?utf-8?B?RmFLOGpHTm1ieDNLQjRaNVBMV1I1dW5BMHR3RGVoWnRmSytoNUpjZHM2MW9K?=
 =?utf-8?B?ZHNnZ1dVSFY4bkdpZno1YkdMM3cyV2VrdlpTR0RraEV5Sm9mZ3k5dHhQUi9n?=
 =?utf-8?B?dmNuVzJYMDlDbk1iREl3WitKTWd3clRyVVRMWGFkZm4xUTdTT0xzRFNMVWFJ?=
 =?utf-8?B?L1dqMnB1eWwrZFR6MWRTRUNXakw3MVFqekFiMHlycHMxUlZjeW9kcGtVYkR5?=
 =?utf-8?B?V29jS0RoSjZXNDZsVXY5WXB5UGxBcnNPSlpraGxFb3QwWlJZVHNSMmRmd0tt?=
 =?utf-8?B?VjJMaWRML3lWZGRaUkZnQ3dpTzI1MExIM1BLRkdyUDltQzV6R29JKzN2b01l?=
 =?utf-8?B?YXJhd01ialFodlV3OUdBWGwxU2lZQkJHeTlkN1IvK29pZ1BpbnVXT3JiWHd5?=
 =?utf-8?B?VnRRMUJWNlJ4TzlwWFNqT2VYU1Z1TjlQaXp0NDZhK3hMRUFLeDQ1ejFHYzJ4?=
 =?utf-8?B?ZFBHV0RpVGNHUzBCUzYxWE1uNksxdlIrL2FVYlVjWDVtcGhLUlNYUy8vWUNz?=
 =?utf-8?B?aEVrYWhFSlJ4NW5EbHFZNGpiMDk4QXhqSlFiNzEwSVVSNEpKU0tjWnkwdzBq?=
 =?utf-8?B?bkJZaE1FdW1oZFlSWFdMWGJkcHJyaHJmRTRiajBpRi9xaGhWekZjLzBzSTFZ?=
 =?utf-8?B?dU9UQUZyLzhqeHl6dEFEV0tmWWhVWnZaenljM3VHMUIzamhscWNnT2hJWEhW?=
 =?utf-8?B?elVyV1psRmIrR2pmWjBTaUZ3WVFRSm1PM2JNMktRdlYwY2J5RWVpalNtWHdT?=
 =?utf-8?B?c2k0WkExd0xLQXNEWFNCL3F3NE1xc1I4T1hCM0hSb21ITkJpMG5seWw4VEdk?=
 =?utf-8?B?L3orcTBXemliM2RyRU1OZkI2UTdZMzBuNW5xZGpNUm53MUF3WGJWNURSUDU2?=
 =?utf-8?B?cFNWb0RVdFpkMkRLMy8zQUJKRTlVNXA2cFJkT2hoV1YrNktLckF5UFdZaElD?=
 =?utf-8?B?QkVveXI2VjNFTGhsYlhjZktQVjVBS1RETlNTbjZNM3ZyQm01eDR0KzFQMFBD?=
 =?utf-8?B?S0dIMjNWQ0hoVGorSXZ5QWhOT2tIQkxMN0Vld29EZjdFRmo0UnRVWVh6VXNz?=
 =?utf-8?B?YUlhdE9ucmx3YXF4Q0tDQW80MFpmTGZDVTBpekxMUythUlZlZzFWcVlFd2Nh?=
 =?utf-8?B?MUJxWjhWRGEvNlZmN3BvYUcrNDNNbGNvWW5ST2xOeXkwNjI0UHU1YVJuS3M4?=
 =?utf-8?B?L3VPeEx4UFJKRVN3eTlHZE1seURYWVo0Tnpid3ZQcTd2Q0s5YnArWXNVY25x?=
 =?utf-8?B?TTh1TzNuV3cvSzkwSzlYTlZFcU9MTS90Q29QYmNqVWZyRmhOelBvUG1QejZL?=
 =?utf-8?B?RlZacW1kTGFnVE5tOXVvaXdLckNtRHhtNllpWkpucmt4NzNRNmw3a1FPZEp3?=
 =?utf-8?B?ZFVWQTRldytjYWFGbm5jeGw0VmNOendSWnBOaHJGbi9ycFpJNHJzYzZjUW0w?=
 =?utf-8?B?ZFFmWVdvYlBhNlJXTXJTWS9hTzRQVXQya0NBTlg0UGNOUmtjZGNGSEx4NWNz?=
 =?utf-8?B?MTJxODVIWWhNTjdkbmcxbDVRWmlrWUg0azg3Rmtyek95dUg4STNaclVvbkVx?=
 =?utf-8?B?K0lldCsxYU1zM2o4YUF1ZTFtNHRjazM2bmx4MUE4SDFvelR0ZkcyRzRBcmVi?=
 =?utf-8?B?eWd5SjI5eXZuUllnbjU2SFptdkp1a1NPMk1DS2NSRFRYYXRUNW5oaU5hTVJx?=
 =?utf-8?B?WkVCQ2VTT3BkZkJHOUg2T3A3Y2k4eko1K1JodjMzTnZuTHRZWmQrd3pEdnpx?=
 =?utf-8?B?V0RYOXhPYjFQZDZ1emo2Z05wK0E1ZEZLWkQxZzFCMlBMSTZ6WjZ6VVFSU09G?=
 =?utf-8?B?dWVsTEt6NDZvcDBZdkRPNGVBNVRWTnZ1ejJGS3U0STN0L0E1eU1NV1FEMUp5?=
 =?utf-8?B?MTZ1MGUzWkd5eGlZTld2bXhKNEYxdXZlOWZwTzZ2MFRQUDRQMXRvRzNkYXBV?=
 =?utf-8?B?bmw0aStOU3lPQ1pPUmxpU1g1aTd0RTdsVmNCcFBOUk9td05UbDRIbTFRaVYr?=
 =?utf-8?B?ak55UUZmZ0RXRDB6NXQ0d1VHWTBIVmlXcml5UUZkSG5FRFVaaEF3cU9xOVpG?=
 =?utf-8?Q?Xfux4WrCpplgFwPXkJBUL1Rs5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d1dd93e-4b27-48e5-b84c-08dab1fe1a14
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2022 18:16:54.3252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YJ4787h3R2icrXx9QsogWbuU7PyBIUK0qaYfvFirmZNN1f4f1MopTZPjti84+uFvg9QcDHpNGqxKegzbNVpmGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3155
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1BhdGNoIHY3IDEwLzEyXSBuZXQ6IG1hbmE6IERlZmluZSBkYXRhIHN0
cnVjdHVyZXMgZm9yIGFsbG9jYXRpbmcNCj4gZG9vcmJlbGwgcGFnZSBmcm9tIEdETUENCj4gDQo+
IE9uIDIwMjIvMTAvMTggMzoyMCwgbG9uZ2xpQGxpbnV4b25oeXBlcnYuY29tIHdyb3RlOg0KPiA+
IEZyb206IExvbmcgTGkgPGxvbmdsaUBtaWNyb3NvZnQuY29tPg0KPiA+DQo+ID4gVGhlIFJETUEg
ZGV2aWNlIG5lZWRzIHRvIGFsbG9jYXRlIGRvb3JiZWxsIHBhZ2VzIGZvciBlYWNoIHVzZXIgY29u
dGV4dC4NCj4gPiBEZWZpbmUgdGhlIEdETUEgZGF0YSBzdHJ1Y3R1cmVzIGZvciB1c2UgYnkgdGhl
IFJETUEgZHJpdmVyLg0KPiA+DQo+ID4gUmV2aWV3ZWQtYnk6IERleHVhbiBDdWkgPGRlY3VpQG1p
Y3Jvc29mdC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogTG9uZyBMaSA8bG9uZ2xpQG1pY3Jvc29m
dC5jb20+DQo+ID4gQWNrZWQtYnk6IEhhaXlhbmcgWmhhbmcgPGhhaXlhbmd6QG1pY3Jvc29mdC5j
b20+DQo+ID4gLS0tDQo+ID4gQ2hhbmdlIGxvZzoNCj4gPiB2NDogdXNlIEVYUE9SVF9TWU1CT0xf
TlMNCj4gPiB2NzogbW92ZSBtYW5hX2dkX2FsbG9jYXRlX2Rvb3JiZWxsX3BhZ2UoKSBhbmQNCj4g
PiBtYW5hX2dkX2Rlc3Ryb3lfZG9vcmJlbGxfcGFnZSgpIHRvIHRoZSBSRE1BIGRyaXZlcg0KPiA+
DQo+ID4gIGluY2x1ZGUvbmV0L21hbmEvZ2RtYS5oIHwgMjUgKysrKysrKysrKysrKysrKysrKysr
KysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMjUgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvbmV0L21hbmEvZ2RtYS5oIGIvaW5jbHVkZS9uZXQvbWFuYS9nZG1h
LmggaW5kZXgNCj4gPiBhOWI3OTMwZGZiZjguLmJjMDYwYjZmYTU0YyAxMDA2NDQNCj4gPiAtLS0g
YS9pbmNsdWRlL25ldC9tYW5hL2dkbWEuaA0KPiA+ICsrKyBiL2luY2x1ZGUvbmV0L21hbmEvZ2Rt
YS5oDQo+ID4gQEAgLTI0LDExICsyNCwxNSBAQCBlbnVtIGdkbWFfcmVxdWVzdF90eXBlIHsNCj4g
PiAgCUdETUFfR0VORVJBVEVfVEVTVF9FUUUJCT0gMTAsDQo+ID4gIAlHRE1BX0NSRUFURV9RVUVV
RQkJPSAxMiwNCj4gPiAgCUdETUFfRElTQUJMRV9RVUVVRQkJPSAxMywNCj4gPiArCUdETUFfQUxM
T0NBVEVfUkVTT1VSQ0VfUkFOR0UJPSAyMiwNCj4gPiArCUdETUFfREVTVFJPWV9SRVNPVVJDRV9S
QU5HRQk9IDI0LA0KPiA+ICAJR0RNQV9DUkVBVEVfRE1BX1JFR0lPTgkJPSAyNSwNCj4gPiAgCUdE
TUFfRE1BX1JFR0lPTl9BRERfUEFHRVMJPSAyNiwNCj4gPiAgCUdETUFfREVTVFJPWV9ETUFfUkVH
SU9OCQk9IDI3LA0KPiA+ICB9Ow0KPiA+DQo+ID4gKyNkZWZpbmUgR0RNQV9SRVNPVVJDRV9ET09S
QkVMTF9QQUdFCTI3DQo+ID4gKw0KPiA+ICBlbnVtIGdkbWFfcXVldWVfdHlwZSB7DQo+ID4gIAlH
RE1BX0lOVkFMSURfUVVFVUUsDQo+ID4gIAlHRE1BX1NRLA0KPiA+IEBAIC01ODcsNiArNTkxLDI2
IEBAIHN0cnVjdCBnZG1hX3JlZ2lzdGVyX2RldmljZV9yZXNwIHsNCj4gPiAgCXUzMiBkYl9pZDsN
Cj4gPiAgfTsgLyogSFcgREFUQSAqLw0KPiA+DQo+ID4gK3N0cnVjdCBnZG1hX2FsbG9jYXRlX3Jl
c291cmNlX3JhbmdlX3JlcSB7DQo+ID4gKwlzdHJ1Y3QgZ2RtYV9yZXFfaGRyIGhkcjsNCj4gPiAr
CXUzMiByZXNvdXJjZV90eXBlOw0KPiA+ICsJdTMyIG51bV9yZXNvdXJjZXM7DQo+ID4gKwl1MzIg
YWxpZ25tZW50Ow0KPiA+ICsJdTMyIGFsbG9jYXRlZF9yZXNvdXJjZXM7DQo+ID4gK307DQo+ID4g
Kw0KPiA+ICtzdHJ1Y3QgZ2RtYV9hbGxvY2F0ZV9yZXNvdXJjZV9yYW5nZV9yZXNwIHsNCj4gPiAr
CXN0cnVjdCBnZG1hX3Jlc3BfaGRyIGhkcjsNCj4gPiArCXUzMiBhbGxvY2F0ZWRfcmVzb3VyY2Vz
Ow0KPiA+ICt9Ow0KPiA+ICsNCj4gPiArc3RydWN0IGdkbWFfZGVzdHJveV9yZXNvdXJjZV9yYW5n
ZV9yZXEgew0KPiA+ICsJc3RydWN0IGdkbWFfcmVxX2hkciBoZHI7DQo+ID4gKwl1MzIgcmVzb3Vy
Y2VfdHlwZTsNCj4gPiArCXUzMiBudW1fcmVzb3VyY2VzOw0KPiA+ICsJdTMyIGFsbG9jYXRlZF9y
ZXNvdXJjZXM7DQo+ID4gK307DQo+ID4gKw0KPiA+ICAvKiBHRE1BX0NSRUFURV9RVUVVRSAqLw0K
PiA+ICBzdHJ1Y3QgZ2RtYV9jcmVhdGVfcXVldWVfcmVxIHsNCj4gPiAgCXN0cnVjdCBnZG1hX3Jl
cV9oZHIgaGRyOw0KPiA+IEBAIC02OTUsNCArNzE5LDUgQEAgdm9pZCBtYW5hX2dkX2ZyZWVfbWVt
b3J5KHN0cnVjdA0KPiBnZG1hX21lbV9pbmZvDQo+ID4gKmdtaSk7DQo+ID4NCj4gPiAgaW50IG1h
bmFfZ2Rfc2VuZF9yZXF1ZXN0KHN0cnVjdCBnZG1hX2NvbnRleHQgKmdjLCB1MzIgcmVxX2xlbiwg
Y29uc3QNCj4gdm9pZCAqcmVxLA0KPiA+ICAJCQkgdTMyIHJlc3BfbGVuLCB2b2lkICpyZXNwKTsN
Cj4gPiArDQo+IA0KPiBVbnJlbGF0ZWQgY2hhbmdlLg0KDQpXaWxsIHJlbW92ZSB0aGlzLg0KDQo+
IA0KPiA+ICAjZW5kaWYgLyogX0dETUFfSCAqLw0KPiA+DQo=
