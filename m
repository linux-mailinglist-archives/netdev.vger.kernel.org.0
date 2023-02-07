Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7997D68DC74
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 16:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbjBGPHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 10:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbjBGPG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 10:06:57 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2045.outbound.protection.outlook.com [40.107.100.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13043C1F;
        Tue,  7 Feb 2023 07:06:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkuUm9C+kObD0e61633yN1eX9x0OzCchJNf0Tzywz+9atbWu9PeeCW9rATg9rd7y/iaqYdLeCnEmjzYK8sV8HeEUNx4j8IDvf/AKXZts1159jJIczet5u0i2HfboTrt0Nwz025aoDucxeS5dX0LAypoabP2AesR9kQVYxQ+DtUj+aDUpGQxXick2OmqUWgj/SizubpNfDdfUXzxTRjRVILC4dUDciIrFbk+cN318vzArzTMZ0qTdpJaV5Vck3gu5QDs1I0WvCej9IXH/JH4UBGVH+fhBPCEVNkbIbxaAd7wt4uJrkb7VSd8ltpSGKlIPxLSh9U7A2tL773MM6Z7zJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WcHvOTmuwuAsK/pmy/p6s/6qYM0iY19SNQOTIoI/+Po=;
 b=fOPmUi0pSGLy/T53Kvw//R3q/GnNoTYctwpN0WspYHBNMrYKQZuKmNeRw+WKrqN+MQw+o0+XbeTXQ6lsDCO+ErWWdCLl+aX2XQkIHt2x2cE2sIxvLrjPlKw9ack8e+xo2KBsA0F0RzuAQ82g432udOa6FRK/fu9/hb5U/vf7IQDfRO0e4eEuKdSihEYW2uv6PFvCJMtipPy/vokl32rVynyh499j3EbAf2LiSN2WlV+qi6Q+qf/cOBHoJs7kHPnmsWxJQeSbI/TNnCHmE7ziSd6BjOFDpFRX1yp9++42B240tvHBHxvWu84KObTcQTQ6GLbkvG8Q+nhscnxclScQ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcHvOTmuwuAsK/pmy/p6s/6qYM0iY19SNQOTIoI/+Po=;
 b=GrJ/yam7AEO3TcIHHprvYqq5B3pzg0/LS0DG3khfLQjeYstDbvpi8J8B/lWUHdPwUvyNxNsXEQ+xrk8Em3r0Wffp+MgLAPvx8GbU0CmFCY25GRxWgJjaNn4uModDAxuuzYRDfcymkM0hWRyt7LImStvKTju8uHf+QwFCbLVXZ58=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by CY5PR12MB6623.namprd12.prod.outlook.com (2603:10b6:930:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 15:06:42 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%9]) with mapi id 15.20.6064.036; Tue, 7 Feb 2023
 15:06:42 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v5 net-next 8/8] sfc: add support for devlink
 port_function_hw_addr_set in ef100
Thread-Topic: [PATCH v5 net-next 8/8] sfc: add support for devlink
 port_function_hw_addr_set in ef100
Thread-Index: AQHZNvefaLZHrFNBhkKTgMP8f02bYq67kY0AgAgL6AA=
Date:   Tue, 7 Feb 2023 15:06:42 +0000
Message-ID: <DM6PR12MB420291F2D2816E6E46E1E4B3C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-9-alejandro.lucero-palau@amd.com>
 <Y9uo4t2J3T87yLg4@nanopsycho>
In-Reply-To: <Y9uo4t2J3T87yLg4@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4202.namprd12.prod.outlook.com
 (15.20.6086.009)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|CY5PR12MB6623:EE_
x-ms-office365-filtering-correlation-id: 52b00044-9257-4ddf-2680-08db091cec22
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /qLE0uB/bCBiByE3kNTBGVXtm6Sd+vFetyzfSp2rXv+vIbl0us4h40BM+R1M9VyftD8FGpz9gi08XuR7YyqH2eOYRMGfTOFDeKfziTa/XxL2bFN2eO32krvNU+22kYjuBrRpcQEeQJdW3uLnNCg8Rl5plY8E1liHw+B6h91ZZFoTsxbvl3HUdJdOymCqnS/tuLKSetAOty9uiV1OQe9+YLfO3rfDepR5vkBKVWNeikEsdGjrVJQihXs41MUGWVBAQJrs90hDsNrkWEUh+XQ4EhunsllPh4ozR3poEt1vdoQtF0hpU/EE/dNuPzoRxBAaffGZVBFIAVANuuXJAC2/h97FAyxaD1029q1cMbj7POLJU6xFGIm2NQbYtupa6pRlSf4dRTqCJEs3II2gQh3NjiFeJNjdNPKVF4wD9jHR1+pbkMEHN52xfVDE6Z0dy9AgrmSexnUKjn4wfdb/ZQtfsGLBGtnnzF40FMBXQ0a2HKOd3JElowpL6iSRZ6GvzR7Y+bOo5fVwIq6faE3ugN0r4Vk0d+cvWBRBeRIRUs/Yttloh8GH3XekqhdQuZlUWABMCIw6DIYQH5ZpARdYImBylyO+vJggG04yhdk/MLJkR9yA2enlBEdAL6qqPN+14UHdFTRfsr1I9ItPJaHmVJ5YuXiALzV35ykyyedN+TLWymqQke4msPUsgp7uCUnrl78aVDPkXUFdF8V5fY3d3JUzmNDBcDgJhpuMmLoi3YoIKdrtufjegDj/nlX+hfJNx+fU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199018)(6636002)(5660300002)(7416002)(54906003)(316002)(4326008)(110136005)(64756008)(122000001)(66476007)(66556008)(66446008)(8936002)(52536014)(41300700001)(66946007)(8676002)(76116006)(33656002)(38070700005)(38100700002)(7696005)(53546011)(9686003)(71200400001)(26005)(186003)(6506007)(2906002)(55016003)(478600001)(83380400001)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVJjYmlsTTliZWNJVi9COTVSVmFkWEl3Q2s1Q2MwZ3RtT3JTOFN4VVI0aVdu?=
 =?utf-8?B?d2NXcWRqSlR6U3NVU0dLSTV4ajg2YXEyWWNIcW5TSHQyTE5xYjBiL1ZhNVVM?=
 =?utf-8?B?WElEUFRQQmtKSlQ3b1NLV2pnMnBwNUxxbUxkcVlRSjNncFVQNFJDZmpOZzh4?=
 =?utf-8?B?MW5TS2N2ZSt4cGt6aElBOE5xRWtqdHJFNmduNUVIdi9GbUxzMk5IWWRHVkpG?=
 =?utf-8?B?djErWXUrbGhlV05IbUxRNkczcnZWQW9WK3ZIOTFRODlDZ2VRUWNPVUVKczB3?=
 =?utf-8?B?V0swTS82WURhbUNXRzhOZ29GVUU5bE9FNzhPSGMzRW1vRzZSdWltY0Y0cWRp?=
 =?utf-8?B?R0huMGsyejNuZmdheTRZQzZHN1UvQmdaTXJiNkNxdW42dU9oeHc0aEZZU1Q1?=
 =?utf-8?B?NEgyRmZGSW05YXdoUTdZYWRjM2RSRzFhcWtPR2F2SWRRb0pUS004QVFmQjQ4?=
 =?utf-8?B?a3h6MFRVbEJQOHdjUktrK21RTmJHbHRUTVNOQ3VURTltK0g1QTBzNjhPeDIr?=
 =?utf-8?B?ZW5oaSsvSEFFTWdPT3VkSjhVMmRIY1ZNSk9odlBzLzJWTzB1RlBtNmJ0d1k2?=
 =?utf-8?B?aDUvenNpUmh1MFBucWs4UjlHYk5mZTF2SWFqTlg2cVVQMTBFd1MxQTlFYmJ2?=
 =?utf-8?B?N29IM0Y2QVVtbU1VeTZDOTZjL0J3T0hTK05QdlZ3UmpjUmxjQzg4cU5sSVVH?=
 =?utf-8?B?dFJDZkJ1cXc1SEczYUNmT0pENk5aUUc4SFhqWjZrM2JNT1pzeE5sNGY0cHUz?=
 =?utf-8?B?NnhabU4rVEl0QTR2cDErZEZMS0ttM1FNSUxOdXlMMVBUUnhhSFFqeitvbmo4?=
 =?utf-8?B?NkJvOVBSajNxQS9DNGtnMmp2cS9SMzFZekZpS1lFZjJrbkpOSEZYUGhmTkJs?=
 =?utf-8?B?eGxhSHYrQXowNWc2Ym5QcncrSlJ3T0V5ZWJ2dmdENlRMMXlnSXBFSXhmdVg4?=
 =?utf-8?B?bEVtdTR3S3BZZGM1QjNhNzVRQW9JbEx4ZFJxNk5yWUo2YXBoTW4xQ3UxN2tz?=
 =?utf-8?B?ZXZsb3ZldHd0MDNqNW9QU2hLRXFNU1FkbndEeEtia2g0UzVWa25oWUx6ZU9q?=
 =?utf-8?B?dENQZHRnU1AyWjc5YUdrTlVSRjRyVGs5R3RLMU1aQ0RLR0RHMEVQM2ZyNjB1?=
 =?utf-8?B?bmVMbXU3V1NsTlBvWDRQNDlCNklwVTdKbEZ1L0Z3Zzg0M3dJcE91dlZDYnBM?=
 =?utf-8?B?MlJ6TW0xNU5rSGh2ZndnVzA4eDhpNUZhOVVvZWhxZjg3YUlObnppYkpFSmJE?=
 =?utf-8?B?M0dwMGRObUNEK3VmYWQ5eHJyR1A0aGhTT2FtV0p1MHl4SEw3Qk01TG0vVU5y?=
 =?utf-8?B?TFdVN2gyZVE0YkVoaDk0VnEweFBZUlZZUHphV2hOdVpTSjNpYkZRbFAvbmtl?=
 =?utf-8?B?aVE3VFJsTnA5QnhOWEM3RWZKa3NpMmtQblBzcjZYUXBRVjVzWGVNaXFoZmhU?=
 =?utf-8?B?MHluTzZEL1dTaGtCSitIMTE5Vm5QTHRIYlZ6RUpEblNpc3pTV24rUGlyNDJC?=
 =?utf-8?B?WHFXT2dDVVJGNEZ2bURhTmlXYVZ6OWV1R1kzSjQ5bnphSWJaelNQQUE3bUg5?=
 =?utf-8?B?KzhOWmJoNkx5b3VTTlJNa29YOGUxNUhBbmdWVS9JbE5YMUlKR0MxVi9GdzF2?=
 =?utf-8?B?Znk0L3d0a29xQ05ma3MrTERlaFBiMXlnbkZkbWhScjJ5UXVTOGxFRmtUbWZD?=
 =?utf-8?B?andCNzRySE1Tbm9VWVhZZGcwZ2h0OU1IcURrT2Y1eWJPTFlwV3VDbktOSUpK?=
 =?utf-8?B?UE1VNWQ2QkY4NWlwUGx0UUF3ZXRkOVZscGI0aEwzV1R1N29CRTFaNUdRYnVl?=
 =?utf-8?B?dmtPa3BXZXh1Q1puMk1iM1VEYWhFQlhEQmVxQ3YxSGJ6dUZnYkhkaUw2YmRj?=
 =?utf-8?B?VnlXNE55bENJZHRheHhodUw4R1JwVU8xN2xUUXQ4QUM2aUE5dDdRUHJBazA3?=
 =?utf-8?B?eTRIZ1U5Slp0aStzZ2ZON2xObGQzUGhXWnljSmovL2RhMmJFK1Bkd2NNT2ZL?=
 =?utf-8?B?cDNERUF2bmFPdzhFRllIREFOWGhjY01aS2dRMkRIQnJHZThGWEc1WUhrZGZh?=
 =?utf-8?B?c0ZwSStNYmFQeWFtemFjZ1FtQnhRSWxDRWhoTmtYTVdCTmk1VXZkUStTOWFB?=
 =?utf-8?Q?e/3Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A444172EBC46A94FBEECEF1E8A692973@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52b00044-9257-4ddf-2680-08db091cec22
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 15:06:42.8296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fXVb8pEDwpbkW6xqi5Cmmc02pinkmrHaomF646FVi4PDvdnJUp1sZQrOZZkXmn35zw0geNp+qk9sKNiP8s0Gjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6623
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzIvMjMgMTI6MTMsIEppcmkgUGlya28gd3JvdGU6DQo+IFRodSwgRmViIDAyLCAyMDIz
IGF0IDEyOjE0OjIzUE0gQ0VULCBhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20gd3JvdGU6
DQo+PiBGcm9tOiBBbGVqYW5kcm8gTHVjZXJvIDxhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5j
b20+DQo+Pg0KPj4gVXNpbmcgdGhlIGJ1aWx0aW4gY2xpZW50IGhhbmRsZSBpZCBpbmZyYXN0cnVj
dHVyZSwgdGhpcyBwYXRjaCBhZGRzDQo+PiBzdXBwb3J0IGZvciBzZXR0aW5nIHRoZSBtYWMgYWRk
cmVzcyBsaW5rZWQgdG8gbXBvcnRzIGluIGVmMTAwLiBUaGlzDQo+PiBpbXBsaWVzIHRvIGV4ZWN1
dGUgYW4gTUNESSBjb21tYW5kIGZvciBnaXZpbmcgdGhlIGFkZHJlc3MgdG8gdGhlDQo+PiBmaXJt
d2FyZSBmb3IgdGhlIHNwZWNpZmljIGRldmxpbmsgcG9ydC4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5
OiBBbGVqYW5kcm8gTHVjZXJvIDxhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20+DQo+IFBs
ZWFzZSBjaGVjayBteSBub3RlcyB0byB0aGUgcHJldml1b3VzIHBhdGNoLCBtb3N0IG9mIHRoZW0g
YXBwbGllcyBvbg0KPiB0aGlzIG9uZSBhcyB3ZWxsLiBDb3VwbGUgbW9yZSBiZWxvdy4NCg0KSSds
bCBkby4NCg0KPg0KPg0KPj4gLS0tDQo+PiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2Rl
dmxpbmsuYyB8IDUwICsrKysrKysrKysrKysrKysrKysrKysrKysrDQo+PiAxIGZpbGUgY2hhbmdl
ZCwgNTAgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9zZmMvZWZ4X2RldmxpbmsuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZnhfZGV2
bGluay5jDQo+PiBpbmRleCBjNDQ1NDdiOTg5NGUuLmJjYjg1NDNiNDNiYSAxMDA2NDQNCj4+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZnhfZGV2bGluay5jDQo+PiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2RldmxpbmsuYw0KPj4gQEAgLTExMCw2ICsxMTAsNTUg
QEAgc3RhdGljIGludCBlZnhfZGV2bGlua19wb3J0X2FkZHJfZ2V0KHN0cnVjdCBkZXZsaW5rX3Bv
cnQgKnBvcnQsIHU4ICpod19hZGRyLA0KPj4gCXJldHVybiByYzsNCj4+IH0NCj4+DQo+PiArc3Rh
dGljIGludCBlZnhfZGV2bGlua19wb3J0X2FkZHJfc2V0KHN0cnVjdCBkZXZsaW5rX3BvcnQgKnBv
cnQsDQo+PiArCQkJCSAgICAgY29uc3QgdTggKmh3X2FkZHIsIGludCBod19hZGRyX2xlbiwNCj4+
ICsJCQkJICAgICBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2spDQo+PiArew0KPj4gKwlN
Q0RJX0RFQ0xBUkVfQlVGKGluYnVmLCBNQ19DTURfU0VUX0NMSUVOVF9NQUNfQUREUkVTU0VTX0lO
X0xFTigxKSk7DQo+PiArCXN0cnVjdCBlZnhfZGV2bGluayAqZGV2bGluayA9IGRldmxpbmtfcHJp
dihwb3J0LT5kZXZsaW5rKTsNCj4+ICsJc3RydWN0IG1hZV9tcG9ydF9kZXNjICptcG9ydF9kZXNj
Ow0KPj4gKwllZnhfcXdvcmRfdCBwY2llZm47DQo+PiArCXUzMiBjbGllbnRfaWQ7DQo+PiArCWlu
dCByYzsNCj4+ICsNCj4+ICsJbXBvcnRfZGVzYyA9IGNvbnRhaW5lcl9vZihwb3J0LCBzdHJ1Y3Qg
bWFlX21wb3J0X2Rlc2MsIGRsX3BvcnQpOw0KPj4gKw0KPj4gKwlpZiAoIWVmMTAwX21wb3J0X2lz
X3ZmKG1wb3J0X2Rlc2MpKSB7DQo+PiArCQlOTF9TRVRfRVJSX01TR19GTVQoZXh0YWNrLA0KPj4g
KwkJCQkgICAicG9ydCBtYWMgY2hhbmdlIG5vdCBhbGxvd2VkIChtcG9ydDogJXUpIiwNCj4gIlBv
cnQiIHdpdGggIlAiPyBCZSBjb25zaXN0ZW50IHdpdGggZXh0YWNrIG1lc3NhZ2VzLg0KPiBBbHNv
ICJNQUMiLCBhcyB5b3UgdXNlZCB0aGF0IGluIHRoZSBwcmV2aW91cyBwYXRjaC4NCj4NCg0KT0su
DQoNCj4NCj4+ICsJCQkJICAgbXBvcnRfZGVzYy0+bXBvcnRfaWQpOw0KPj4gKwkJcmV0dXJuIC1F
UEVSTTsNCj4+ICsJfQ0KPj4gKw0KPj4gKwlFRlhfUE9QVUxBVEVfUVdPUkRfMyhwY2llZm4sDQo+
PiArCQkJICAgICBQQ0lFX0ZVTkNUSU9OX1BGLCBQQ0lFX0ZVTkNUSU9OX1BGX05VTEwsDQo+PiAr
CQkJICAgICBQQ0lFX0ZVTkNUSU9OX1ZGLCBtcG9ydF9kZXNjLT52Zl9pZHgsDQo+PiArCQkJICAg
ICBQQ0lFX0ZVTkNUSU9OX0lOVEYsIFBDSUVfSU5URVJGQUNFX0NBTExFUik7DQo+PiArDQo+PiAr
CXJjID0gZWZ4X2VmMTAwX2xvb2t1cF9jbGllbnRfaWQoZGV2bGluay0+ZWZ4LCBwY2llZm4sICZj
bGllbnRfaWQpOw0KPj4gKwlpZiAocmMpIHsNCj4+ICsJCU5MX1NFVF9FUlJfTVNHX0ZNVChleHRh
Y2ssDQo+PiArCQkJCSAgICJObyBpbnRlcm5hbCBjbGllbnRfSUQgZm9yIHBvcnQgKG1wb3J0OiAl
dSkiLA0KPj4gKwkJCQkgICBtcG9ydF9kZXNjLT5tcG9ydF9pZCk7DQo+PiArCQlyZXR1cm4gcmM7
DQo+PiArCX0NCj4+ICsNCj4+ICsJTUNESV9TRVRfRFdPUkQoaW5idWYsIFNFVF9DTElFTlRfTUFD
X0FERFJFU1NFU19JTl9DTElFTlRfSEFORExFLA0KPj4gKwkJICAgICAgIGNsaWVudF9pZCk7DQo+
PiArDQo+PiArCWV0aGVyX2FkZHJfY29weShNQ0RJX1BUUihpbmJ1ZiwgU0VUX0NMSUVOVF9NQUNf
QUREUkVTU0VTX0lOX01BQ19BRERSUyksDQo+PiArCQkJaHdfYWRkcik7DQo+PiArDQo+PiArCXJj
ID0gZWZ4X21jZGlfcnBjKGRldmxpbmstPmVmeCwgTUNfQ01EX1NFVF9DTElFTlRfTUFDX0FERFJF
U1NFUywgaW5idWYsDQo+PiArCQkJICBzaXplb2YoaW5idWYpLCBOVUxMLCAwLCBOVUxMKTsNCj4+
ICsJaWYgKHJjKQ0KPj4gKwkJTkxfU0VUX0VSUl9NU0dfRk1UKGV4dGFjaywNCj4+ICsJCQkJICAg
InNmYyBNQ19DTURfU0VUX0NMSUVOVF9NQUNfQUREUkVTU0VTIG1jZGkgZXJyb3IgKG1wb3J0OiAl
dSkiLA0KPiBJIGhhdmUgbm8gY2x1ZSB3aHkgdG8gcHV0IG5hbWUgb2YgdGhlIGRyaXZlciBpbiB0
aGUgZXh0YWNrLiBEb24ndCBkbyBpdC4NCj4gQWxzbywgd2hhdCBkb2VzICJNQ19DTURfU0VUX0NM
SUVOVF9NQUNfQUREUkVTU0VTIiB0ZWxsIHRvIHRoZSB1c2VyPw0KPg0KDQpJIHdhcyBzdWdnZXN0
ZWQgdG8gYWRkIHRoYXQga2luZCBvZiBpbmZvcm1hdGlvbiBieSBteSB0ZWFtLCBhbmQgSSANCnRo
b3VnaHQgaXQgd2FzIGEgZ29vZCBpZGVhLg0KDQpJIGd1ZXNzIGl0IGlzIHNvbWV0aW1lcyBub3Qg
ZWFzeSB0byByZWFsaXplIHRoaXMgaXMgZm9yIHVzZXIgc3BhY2UgLi4uDQoNCj4+ICsJCQkJICAg
bXBvcnRfZGVzYy0+bXBvcnRfaWQpOw0KPj4gKw0KPj4gKwlyZXR1cm4gcmM7DQo+PiArfQ0KPj4g
Kw0KPj4gI2VuZGlmDQo+Pg0KPj4gc3RhdGljIGludCBlZnhfZGV2bGlua19pbmZvX252cmFtX3Bh
cnRpdGlvbihzdHJ1Y3QgZWZ4X25pYyAqZWZ4LA0KPj4gQEAgLTU3NCw2ICs2MjMsNyBAQCBzdGF0
aWMgY29uc3Qgc3RydWN0IGRldmxpbmtfb3BzIHNmY19kZXZsaW5rX29wcyA9IHsNCj4+IAkuaW5m
b19nZXQJCQk9IGVmeF9kZXZsaW5rX2luZm9fZ2V0LA0KPj4gI2lmZGVmIENPTkZJR19TRkNfU1JJ
T1YNCj4+IAkucG9ydF9mdW5jdGlvbl9od19hZGRyX2dldAk9IGVmeF9kZXZsaW5rX3BvcnRfYWRk
cl9nZXQsDQo+PiArCS5wb3J0X2Z1bmN0aW9uX2h3X2FkZHJfc2V0CT0gZWZ4X2RldmxpbmtfcG9y
dF9hZGRyX3NldCwNCj4+ICNlbmRpZg0KPj4gfTsNCj4+DQo+PiAtLSANCj4+IDIuMTcuMQ0KPj4N
Cg==
