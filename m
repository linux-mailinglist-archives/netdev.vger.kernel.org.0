Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4EF52E46D
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 07:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344156AbiETFjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 01:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiETFjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 01:39:42 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120084.outbound.protection.outlook.com [40.107.12.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5400B14B643;
        Thu, 19 May 2022 22:39:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMJAXRt0v62Prt1uUAj4iZ7ENucBmDlecWp4USxYcso0/wrzyEqNAOt0vkmcaALYsPR7noBg63d+RyDBnrccRegiprYZJEV3z0LR1KLvrt2p6QiApY6ZIialxYAqEGjL2EXNowe+9WjSbOxS0G063GA66g0u1sBv4R/XmgIAag90/RgW2GCLkQI3AJ9x3XURUgv6f+p6cqy7fZA4nmUSelPKU28Pc1B6/VF/r2ePWFHAk72YnSv+5yfNW/LUNY4hLpiZqwFaRmvvEtfsxZy0eX7nyzptJryyxHI9+dAJn9DQ9wK97EMWJeutpvxWH2p9YrOYz8thiPblMC+CQeO5og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ff4GXXNze4sBRIIwID4MqDOzQgyjDaMmmvCR5VJVKC8=;
 b=R4KvY2btL5vP5CihQg4CZ5DC6IaScS7bjUx044TUNIUuf+sEz7m18DOXQ5yKF/NUyMBR4cghj8/M0wWOXxG/inq4SdNdv1AfqpRco9RTac0EecOxg/fq9YZsVC9JGqMndr6V9BEVVil+FBIX2KYZP0vzXA60B9PS/R+z5Iu8Q1BDQz1o64DE47t9EDTVYJSqTefA1mebFCd9+M28C3Mw/BL8M13j7awHtZez4+CtkO2C4uom/fUQR7Lc4Jvuu2X/A8cKtd6XbP+IbA2LZMLxxkJEXLWb6Do0yjUNcP8CvPJoKG8o+58auKOgDR7uKWauw5ru14UOCZdJJs7oZ8xUgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB2303.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:13::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 05:39:38 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::ad4e:c157:e9ac:385d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::ad4e:c157:e9ac:385d%8]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 05:39:38 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Mans Rullgard <mans@mansr.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>,
        Dan Malek <dan@embeddededge.com>,
        Joakim Tjernlund <joakim.tjernlund@lumentis.se>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: fs_enet: sync rx dma buffer before reading
Thread-Topic: [PATCH] net: fs_enet: sync rx dma buffer before reading
Thread-Index: AQHYa7YuVEP9k/Dzd0ymrSBr6A4wj60nQJAA
Date:   Fri, 20 May 2022 05:39:38 +0000
Message-ID: <03f24864-9d4d-b4f9-354a-f3b271c0ae66@csgroup.eu>
References: <20220519192443.28681-1-mans@mansr.com>
In-Reply-To: <20220519192443.28681-1-mans@mansr.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a577e529-ee20-4ff9-3a4e-08da3a232174
x-ms-traffictypediagnostic: MR1P264MB2303:EE_
x-microsoft-antispam-prvs: <MR1P264MB23038CC35309121B05586DFEEDD39@MR1P264MB2303.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H/ypzgxUWbdYiEFU8mh4mqsO3KWvTKWBYP3jQfjjysbzPNtQlb8fQnBFHF6mkKDA3g6GttoN3Lq0RpdXs9jkPGEHbeXcb50NHVfubdqjoyAGwUyPcof6hGwJKJ5K/lz56F8Ku8Aknb8V8xRef092p/jxoGgQRJZCuhF2MW8W/Lpt7QyhOC3Huwh164CBEY2jmy/5SIBNQYIUG3tZeSoQxQ7n9n6s0iAk11l5IxBRydpy2yH7/s8DpBqeSBnxG8fncVbbzU9alzx1m/hWHIHZcRb+ell1Qvs+3mqEl9XiMHhNBGL9VChR2l1Lfs/LMoPwcs/hBvrC4oM5oZ5mfLdKS727X9QhQh+qnyQhshNxBOZrotSFl0v8SZd+l55iewWpALYtRJegoQ1HcGiM0jpLenEQbyEUGnFE9IobCP4kJOoN3cytht81CgxgrwfRL1jZoDwDUyQFHSfNH/yRjTcwtMKggysSuLuPpN812eKXUcBJDiWl1tMKNh+chto0ww9w7OSwNvqUI5Dq2gqyJa58g+QcXqpROrq9M0sGAN+f7geQKExTmPzFgzbqfxhry2OuXhYlN+0vAcyXkMx3IXhsadh3/A2OAnhjr8wk/0v9NIb3jIp+dallIMUgyamkjg86gycQmxkJeQ468x6tASG8eOXppyj56bGjPMQL6ocTK9AMwwfvzz2JKbsoKzOQYBHYjylKGEqxFhTLtmk/xzom8MN+cZ090sQWxPfAF66DgA6b3KbcRa7BCmpr/CYQMmZQ/LqbyBBMZGrKcB1qwWdfM6AJLn49DUxe0MBlxWZnD7o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(66574015)(186003)(6512007)(122000001)(26005)(31686004)(921005)(38070700005)(5660300002)(6506007)(38100700002)(66476007)(316002)(71200400001)(508600001)(110136005)(6486002)(2906002)(7416002)(8676002)(83380400001)(76116006)(36756003)(8936002)(86362001)(31696002)(64756008)(66946007)(66556008)(66446008)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUwrUVRHbnJOUDBlU3pjVU9VOGRiOWxBakZUNmV6RVRQZnNsRmRTRUUrSHNu?=
 =?utf-8?B?MkRTR3E4N0hLVHRDa1ZDVDFvUzB6VVhvUHNSTDRFRDhKNnYwNWZyT0tWVk4w?=
 =?utf-8?B?ZmtOWW1UdURpSjhhcjl5SnhLTWlVdTZMWjBqL3VBR2VLRlJKVnE4WjIvZlpC?=
 =?utf-8?B?VDFjRDkzMUpVeWV0ZytiejlrQzRlUS8rT0dKUklVWDlKNm4wM3dXYmNBNUk3?=
 =?utf-8?B?TER1azFNTldCOHdVcUJ1a0UzSm9UR1dnOFVWK0xGN3VHQmxpMW5HS1NKQnli?=
 =?utf-8?B?b2p1cWFkVkd5dS96V0RoQkxTZERyLzg2Y2hla3hqM3lOZVVnUXVHTktQZHUz?=
 =?utf-8?B?NkF4S05UQlBHNyt6NFJobHBFbTdTdDRVNGJ1aWZKWU5CN01DU1l1ZVVES3Vu?=
 =?utf-8?B?Z1VCZ1dtbEVsTFp5SG1veHJwb001TW1PSXl6NXc5ME11TDdWSUJOUTVBR1da?=
 =?utf-8?B?T243Q2o3U3ZJSlBzaG1kOEdUTUN0WFlaK09jeTdnOWlIRHhUMTJxN1ZCOUxY?=
 =?utf-8?B?RTdwaVJ6UFE1eEZSTklSV2JyZ1VkZ2c0Q21zbUJiV1RwN1JaM0FGSDU1cmFv?=
 =?utf-8?B?cXFGd0gveWZ3RWZJeFZaSGxVK01kU3lBcUgwMmRXNzRoZnhwYm9Tdjk0Vlg1?=
 =?utf-8?B?c2FvSEc0NkNGRVFzYk1nczloNEFQd0w2SGJORjRUVmJvNGdYeGVMNzlSbzVa?=
 =?utf-8?B?VlJJVGhCdTJ1NmhiTDFiKzdGV0hMUEF6c0U1RHB6SWc3aUNaeFYyT3NiVm01?=
 =?utf-8?B?Q0dvLzRsU1ZnMWZFWUtIbU1IV00rV2VhdGRLZDhRK0FwR2RnaW8xWC9yOURy?=
 =?utf-8?B?VXpjTzBKOVVuU0lNMmlWMWdsNy9tbGFtN2VNSGhhZVJjWVRpcWw1WlRsQi9U?=
 =?utf-8?B?OTlOSUlVbUIva2VIcWNhOXRIVm96TmJKODE1Y2dpUnR2RUl2TzYzMnJwMHJl?=
 =?utf-8?B?cy9RbmwyWkltMlFUR091a1dHZmZ2djlSS0ZycjQrcmpadVYydGphTGlYTzhY?=
 =?utf-8?B?TjVXTCt0Sm1vZjZYRGtIOEpEczR5c1Z6MTFnTm9LMWlOdW1yaGc0SkM5aUpn?=
 =?utf-8?B?aXY1YXBYOVhaTTR4YVZiUi9ReWd6LzJiRjFmT1RPRjRSWGhkNjlNak11dzhh?=
 =?utf-8?B?UjR6UFdPZS9yNUtZNEJQdGQ5akhtQk5TSERXU2g0azd0ZVB2THhZVkxOYlVF?=
 =?utf-8?B?QURXMkZLUmhuVFg2aFRaTkhaUVVRRGU0VUE2ZGlIbk1kLzdpMDlUT2x3STFX?=
 =?utf-8?B?SzRzUThvZE5HR0NDNWRnVVBDUERlNmJyeVV2cmk2MW9OYVdZUXVxTSs0bE8w?=
 =?utf-8?B?Q3JocFEwS21QV29wRTVSc1hJVnphU3o2QjgrdDdOZlp0U0M3UFZ3eTM5bGFT?=
 =?utf-8?B?dHdHLzNTS1lJM1NEZUFkUXpWakp3SVpoRUpqVExwWnk4a3hXQnNjU2lUOWN1?=
 =?utf-8?B?aDFIZ3RnbHo4Wm1EL0d3YzdRZndpa2tRNjlxUjM3WVJvOEU4R04zSEFnbkZM?=
 =?utf-8?B?MDNoR3RzVVA5RDlnb0tUWHVKV095VDlmaGRpNjFuU1pUY01rQmdLczlqQ0pE?=
 =?utf-8?B?UEdhbUdZRjBob00rSzI0Tm11STIrNWxwQlZKaUZKR3E3ajBoMWlKUm9EV1F2?=
 =?utf-8?B?Y01LM3MyeWgrUFgxeUlGTmdkSlAxL1FwTlRyclU1aFFvanljZVJVM1hFVWNJ?=
 =?utf-8?B?a3BuYUYzSUd2VUNtSTZhSEFxalByQ29zN1FtUExtRDE5ZkwxSzNDemprT3Aw?=
 =?utf-8?B?WjR0R003elhGY1pUVjBJQVJMWUFudVJKMkZBc1NyeXJWcWVUck9NQkpoUVhQ?=
 =?utf-8?B?Zmo3SmNqZUNDY3l0dXpqZFl2RllnRDRRTDczL1Jmby9nOHhGUk8ySVgrZVIx?=
 =?utf-8?B?R0FndlJEVkcwcm4zemc1WFVISTIrMkRhUE01TnRtZzgrYWQ2RWh4L3lRNVND?=
 =?utf-8?B?MFl0MEI2SGZETlFjWE1pSDNCRTJ5YlpXSzJlb1didHJaa0szVXI3bEV0dEdo?=
 =?utf-8?B?VXM2ZE5aaDkyckJ5OVVJUmk0S1l6bGhZMHZmRHJKRUJkYWJJNS9XR1g4bGNW?=
 =?utf-8?B?ODJSU2tuQ29QNzBUUjh0RFNDUWpXVGJYUkpQd1dKcThwWXRmeTE5M1FjNXgr?=
 =?utf-8?B?VWxFdFh6UEtPOU8vRnRwMTZLcE90Y0J2eVRtNTlFMmQ1NnNFTzd5YkRYdC95?=
 =?utf-8?B?aVhJQ2ptQ0xjaElrbG9lSVM0N0VXVGtaUXdReUxkcWtndVpTWHUzQklmTzMr?=
 =?utf-8?B?bEkvR3lDY293SkJjREg3dDVHRWFrai9wTmJtQms2MUg1bjZ4USs5WUhOS1Za?=
 =?utf-8?B?MEJJMGxBYnEvZm9PNCtlMjlNdEVsZlpEcXpMNyt5VHRtQ1duUlZvSGNKVG1D?=
 =?utf-8?Q?JTRjWSMvYpV3osAAWFRFzVzLoRTWDIU45qoiI?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <417B0EE9D156C24EB9427A8DDB2F0A40@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a577e529-ee20-4ff9-3a4e-08da3a232174
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 05:39:38.5721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l2V/qncBEKGz7CP0Md9Te2dmVfecUgXNANZknOUdM4/YVg83+gpXPVLqaTZsfFmz9BsPOBBoOAj78rAcWhAPCLpC+bFFp28z0U5Rwfir3B8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB2303
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TGUgMTkvMDUvMjAyMiDDoCAyMToyNCwgTWFucyBSdWxsZ2FyZCBhIMOpY3JpdMKgOg0KPiBUaGUg
ZG1hX3N5bmNfc2luZ2xlX2Zvcl9jcHUoKSBjYWxsIG11c3QgcHJlY2VkZSByZWFkaW5nIHRoZSBy
ZWNlaXZlZA0KPiBkYXRhLiBGaXggdGhpcy4NCg0KU2VlIG9yaWdpbmFsIGNvbW1pdCAwNzBlMWYw
MTgyN2MuIEl0IGV4cGxpY2l0ZWx5IHNheXMgdGhhdCB0aGUgY2FjaGUgDQptdXN0IGJlIGludmFs
aWRhdGUgX0FGVEVSXyB0aGUgY29weS4NCg0KVGhlIGNhY2hlIGlzIGluaXRpYWx5IGludmFsaWRh
dGVkIGJ5IGRtYV9tYXBfc2luZ2xlKCksIHNvIGJlZm9yZSB0aGUgDQpjb3B5IHRoZSBjYWNoZSBp
cyBhbHJlYWR5IGNsZWFuLg0KDQpBZnRlciB0aGUgY29weSwgZGF0YSBpcyBpbiB0aGUgY2FjaGUu
IEluIG9yZGVyIHRvIGFsbG93IHJlLXVzZSBvZiB0aGUgDQpza2IsIGl0IG11c3QgYmUgcHV0IGJh
Y2sgaW4gdGhlIHNhbWUgY29uZGl0aW9uIGFzIGJlZm9yZSwgaW4gZXh0ZW5zbyB0aGUgDQpjYWNo
ZSBtdXN0IGJlIGludmFsaWRhdGVkIGluIG9yZGVyIHRvIGJlIGluIHRoZSBzYW1lIHNpdHVhdGlv
biBhcyBhZnRlciANCmRtYV9tYXBfc2luZ2xlKCkuDQoNClNvIEkgdGhpbmsgeW91ciBjaGFuZ2Ug
aXMgd3JvbmcuDQoNCg0KPiANCj4gRml4ZXM6IDA3MGUxZjAxODI3YyAoIm5ldDogZnNfZW5ldDog
ZG9uJ3QgdW5tYXAgRE1BIHdoZW4gcGFja2V0IGxlbiBpcyBiZWxvdyBjb3B5YnJlYWsiKQ0KPiBT
aWduZWQtb2ZmLWJ5OiBNYW5zIFJ1bGxnYXJkIDxtYW5zQG1hbnNyLmNvbT4NCj4gLS0tDQo+ICAg
ZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZzX2VuZXQvZnNfZW5ldC1tYWluLmMgfCA4
ICsrKystLS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlv
bnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUv
ZnNfZW5ldC9mc19lbmV0LW1haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9m
c19lbmV0L2ZzX2VuZXQtbWFpbi5jDQo+IGluZGV4IGIzZGFlMTdlMDY3ZS4uNDMyY2UxMGNiZmQw
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZnNfZW5ldC9m
c19lbmV0LW1haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZnNf
ZW5ldC9mc19lbmV0LW1haW4uYw0KPiBAQCAtMjQwLDE0ICsyNDAsMTQgQEAgc3RhdGljIGludCBm
c19lbmV0X25hcGkoc3RydWN0IG5hcGlfc3RydWN0ICpuYXBpLCBpbnQgYnVkZ2V0KQ0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAvKiArMiB0byBtYWtlIElQIGhlYWRlciBMMSBj
YWNoZSBhbGlnbmVkICovDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNrYm4g
PSBuZXRkZXZfYWxsb2Nfc2tiKGRldiwgcGt0X2xlbiArIDIpOw0KPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBpZiAoc2tibiAhPSBOVUxMKSB7DQo+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBkbWFfc3luY19zaW5nbGVfZm9yX2NwdShmZXAtPmRldiwN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgQ0JEUl9C
VUZBRERSKGJkcCksDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIEwxX0NBQ0hFX0FMSUdOKHBrdF9sZW4pLA0KPiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBETUFfRlJPTV9ERVZJQ0UpOw0KPiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNrYl9yZXNlcnZlKHNrYm4sIDIpOyAgIC8q
IGFsaWduIElQIGhlYWRlciAqLw0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHNrYl9jb3B5X2Zyb21fbGluZWFyX2RhdGEoc2tiLA0KPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc2tibi0+ZGF0YSwgcGt0X2xl
bik7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3dhcChza2Is
IHNrYm4pOw0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZG1hX3N5
bmNfc2luZ2xlX2Zvcl9jcHUoZmVwLT5kZXYsDQo+IC0gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIENCRFJfQlVGQUREUihiZHApLA0KPiAtICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBMMV9DQUNIRV9BTElHTihwa3RfbGVu
KSwNCj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgRE1B
X0ZST01fREVWSUNFKTsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfQ0KPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgfSBlbHNlIHsNCj4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgc2tibiA9IG5ldGRldl9hbGxvY19za2IoZGV2LCBFTkVUX1JYX0ZSU0laRSk7
DQo+IC0tDQo+IDIuMzUuMQ0KPiA=
