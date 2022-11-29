Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99ED63B6A3
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234682AbiK2Afc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiK2Afb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:35:31 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11012008.outbound.protection.outlook.com [40.93.200.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADFF31349;
        Mon, 28 Nov 2022 16:35:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZvyjvX8lXcdiG+wNMsSmRn9c+uM52aZXpQFhboHv6U58SgJiyFtADA2HWWR9dqxWZJ7oGhlQHbSlD4Qwn8UD7JWihTUbac/JsFal0Fgn6WK6CihJcTH3Qqi9DPG6/ptK1P4USjefPIFj+IZ3o2eQXJFHmGdgxN224Xf1oQr8U2I2E9Gohz8SfRMES6A6cWBzy9f7tgWwHhudwfQKmMJ6A97L2m6DgBoTEOrH9Bxvlslylvx2K/fYj0jkzGBKuBRmN49lcwjnZH3vPx7ar2qWZ1j4jwOCYuR0wftcy2C09JRwWclPnnUcRiRxswB1iyfgmtvRI6r1gyfw5I+M4HAnvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yPUUgLhAw7QHs4vAviT4e37yWcjvW6/v9Tdm+2pfliI=;
 b=UAoO+xVIXyxZKV1jA6NJ5sNpIdOePxwJs1YNzEV64qv/2Yb+BCJd+9fMRjuStKSufpTJmggecKjtlG088r3e6KgwcRKJd9RHAg+4krPEo+NpklrMQxr45ERbn50L8lt1FB9Ky6sFeuHCMZ6nWIkL9d5nti9AVYHzCGCo5b2FGZ8oeDSMlEUK8yODhR0b7cvL0zQo/z0EctflJGNR7acPfuVnk3vLDdR7FIBekGrMFzMudP6Ggal/sN/k7t0Y5pVy5w0Mk9q/WMxsEttXQPeOV2zy/dGcstGb3IYiblz0Da1NxQkJioxWd0Mjjs2ahSMe56MjRYqkAH1XQb1NpFWz6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPUUgLhAw7QHs4vAviT4e37yWcjvW6/v9Tdm+2pfliI=;
 b=ZNd79bgA9bTaUcugNZp6YpDYQJC5ynpZu/nuTvZIbg+C2hMnr8o0MdJBxpovCALhwjkL6R6XreCSWb1LEyKdcrEjioSjiqCaENrPab56ph/Nyn2m6HkN7gY6Nrqg9q3aFUk4MZ2969uF5M910ZwLdzM92ecLT/ZiTS7qIJgUoBc=
Received: from BYAPR05MB4470.namprd05.prod.outlook.com (2603:10b6:a02:fc::24)
 by SN7PR05MB7775.namprd05.prod.outlook.com (2603:10b6:806:105::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Tue, 29 Nov
 2022 00:35:28 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::d8d7:7b60:23c3:8ee6]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::d8d7:7b60:23c3:8ee6%4]) with mapi id 15.20.5857.020; Tue, 29 Nov 2022
 00:35:28 +0000
From:   Ronak Doshi <doshir@vmware.com>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 net 2/2] vmxnet3: use correct intrConf reference when
 using extended queues
Thread-Topic: [PATCH v1 net 2/2] vmxnet3: use correct intrConf reference when
 using extended queues
Thread-Index: AQHZA4QZbXD4p13J7kSGqXK9W1Qhk65Uh8+A
Date:   Tue, 29 Nov 2022 00:35:27 +0000
Message-ID: <4137D072-6887-47A5-9652-0F0A5FFBE329@vmware.com>
References: <20221128193205.3820-1-doshir@vmware.com>
 <20221128193205.3820-3-doshir@vmware.com>
 <8ba44ad1-675f-92c2-0e13-6bf9c4f8e598@intel.com>
In-Reply-To: <8ba44ad1-675f-92c2-0e13-6bf9c4f8e598@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.64.22081401
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR05MB4470:EE_|SN7PR05MB7775:EE_
x-ms-office365-filtering-correlation-id: 770c4e7c-1361-44f7-5ef9-08dad1a19cfa
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LAgVMpFD0EPu1hWbJU215Z+dEIrzG1LJOhSeg+EeqR3Yy+H6qHvrXyXMdSTyxU/zriq3mnd/l8uLuL7QVt6nq5/VkpIDzY036yR2rIoNYEeycepYy20A4oauaGg1y6gVUs7cpH4iqUe7GXESEqS4Qq+8mnevn1+cuSgcLmoyhZpgy54FybvIoacuP9MfUv52O/7Kq47r5oJ/MoftTBbJDbaDrwokijwwNL89CSgf8VPNv7AKOzTZ4GH2Q+w5sPKzIdY30ypjmZiXkCxjpjCqZ9ewJEevNEfS3Tgekp2atnticFaNVSQckf6UOL3AdHJRKRxiTailFUU+yBSiBfse8QhgruZBrtplzyDg7BEDGxEEjI5gBKQIDfuiZwMKKGzzKOSAeoQFFLz6OI3xEMSs+4ZvEOcsiEfO9+KQGROHGlD/WaHIh4we5+deWk7HQYmgpPeVyzUOBSZ6JMoWJviIZgKxjNgRL3b8JY97dAYT9Pc8YqnOU7nWZyKZ7235apYpx66JvftzRJNEEkpvxlM0uY/39MLAtInlfUFMSFKeaVnqK6mBU1FYPCVJ4VdGhQxWy1uaVNNq6Uhk7f02pnouXYu2paJ/gLCLfyJVIXZ8HbN6+ohVC77avONimURsxCT1OPlB9e/ilKUfuGXdWlxI2Hn9s1mN4hKf5tZ+y/vSkIAZ36NIRyAT30COgGkvk4QDUMbOMZ6XDXLAE+rWBjpF8JBHsnv/PeNTGk0x23xFT+E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(451199015)(71200400001)(6486002)(6506007)(86362001)(478600001)(53546011)(316002)(110136005)(6512007)(2616005)(54906003)(41300700001)(4744005)(5660300002)(33656002)(38070700005)(2906002)(8936002)(38100700002)(186003)(66446008)(66476007)(8676002)(4326008)(64756008)(66556008)(36756003)(66946007)(76116006)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFgvMGgvaU5BYTJ1UkRRNnFINUNjQjdFL01PamNFY2dyQ0VLWTdleHFoUzBG?=
 =?utf-8?B?TElpNjZVdjJ5UXkxc1JsWk1IV2szMVhrUjc3M1hFcmhQN1BsTG9DaE53bW1Z?=
 =?utf-8?B?N2J0NU1rVW44ZWFvUHRycEROSXZuRVg2WTFWeC9Jb1FuYXp4eUNLT0xuemlF?=
 =?utf-8?B?MDl5L3BpRWZ2eGVvbFp6dVF6M2JPci85eTdHYlpIRVFmeWo5MzEzUDJZbDRp?=
 =?utf-8?B?Zms2ZVRsdHU3OVZGV3J6cVduck5zQXk1a08xOU5UTjg3N3Fyd3BTSnlmWHNU?=
 =?utf-8?B?NUZibXVpOHRHRVB0Ri9kQzdkYmpBR0d6T21qVnR3a2tTVzJObTd0T3A1a1dW?=
 =?utf-8?B?QjJjN2IvWTcyOHU2OUQ1OUpOS0VMNStHVFQvMENxTTlTdWFkbWlGNHl2TWdl?=
 =?utf-8?B?eTJaQnlKUjhmaTFUbTUwTjhkUkVXaVFGdWNHZk0vZW4xVTk0bUp0bTRycHkx?=
 =?utf-8?B?WkNJWnJ1OFBZbGxBWG9Ra01lWXpkQjZpMmx1ZGdxTVN0L3hSNTIxY0lrVmNt?=
 =?utf-8?B?SGtTQm1zWm4wS2RWeE5NeE9ndXhSQjJNeDFYYVp5ZFpVZVBvL3A1UnJ0Nlp6?=
 =?utf-8?B?S0NVUmZvb0I4OUd3WFVpdlJLUlZhOXRlYWh1eTMwTWNHQjJ5a05CUDk4K0Vr?=
 =?utf-8?B?eXFKSmZ5Y1NpQS85YjEzWm1iK0pHT0xwZFloN1V3anNuL050K283ak9odGZv?=
 =?utf-8?B?ZDJYMTRTZjE0V3psR1VFYVBvNGhGV2VPcWRyckVrU3JRNzVSSFpPbFZ1QU05?=
 =?utf-8?B?RXF4TUpjREpLbTh5TXY4RDFPbnkyZU5hNzNydlIxZ3VwTWtISEVBZ2trOGY2?=
 =?utf-8?B?aXFXa3FCZC8vTDhWVUx6MkdUUWRjWEtvcUxzd3p5a3dGZUxnNHpYVE1zbnNZ?=
 =?utf-8?B?UmszZnZDK1Y5aGhHcUhuZDdoOWQyVVA1cHBpOVYreVpGbmhzL1l6MUpqODhH?=
 =?utf-8?B?am9CMjJXbytISUJydG14U01YSmo5VDBIbVI5djh1aHBwLzZSY2dtRnNMSFYz?=
 =?utf-8?B?dGt3b250bzBWeG95eW5vMHFPa21nbGxtdkdqUVdrNFJwa0N6M3lQbVZTb0RC?=
 =?utf-8?B?NGFXRExMbk55SXZqRGpSS2JyYjN6ZkxjUFprNTBaSnI2QU5TVlNVUWZjQWkw?=
 =?utf-8?B?NDNoeExzZ2tMWGErdUwxM2kweGM2RkRPTlFuMnV3Z3c0Q2hoV1RsNzRKWDMz?=
 =?utf-8?B?SlpuelpmY0FNRmJ2Q2x1WTl5YVo3bFpCSVhXbGhHdFE4ZU9UelpIaDlaeTUv?=
 =?utf-8?B?bXN2RjBYbVAwR3BGM1p4VGF6RzJld1BFSC9TUlQrNkRqSFl4ZEFYemVFMFdG?=
 =?utf-8?B?YjBVRTNHQUt0d2V1MEJNbmdrZjQrdk8veGg4Zyt1VDhSTkJYQ1A4SncxTk4z?=
 =?utf-8?B?LzZFU3diaW1uQ0huSUMvdFVqVnRrVkJHb0N0eDlYV0N4QjJ3Z3lzbXBKaUoz?=
 =?utf-8?B?TjVGbUtjYUNGWHNvemRGaElqRGl3SEs0c0thMS9BajZycG90aVF5MytDT3ZE?=
 =?utf-8?B?K3B2R1dPcGNBN3NKaXJRdFBoRnRNWS9scE1NL2J2Z3ZNdWRJb2Z2S1JCQWtl?=
 =?utf-8?B?ZGdFOGt2VVZERTR4RWtwYm1TTS9kdnZ2aGJMeldsZzA4eFJTZXJyZjl6M3d5?=
 =?utf-8?B?YVFBWlA5R1h0SHdsTGJXNmhFdHBQY0pHU25XeVRCMURUNDdmS2lCVEhJWHhH?=
 =?utf-8?B?Sktob2hnZENaazNVVHRqWmcwWmx6am1GcE1mV0NOaGNaNkJBNGhweUNtc0lD?=
 =?utf-8?B?czFIaEQxVnl5ZFZwSGR2cUg2dlZKK0h3OUJVM2hzNjFjQzU0T1FUZmFsbTNT?=
 =?utf-8?B?Y0JKVnFwclhCcVJJRExBVmw5L1Roay9OZm5oeFBYQm9xVHJuMGZUUDJWUGMy?=
 =?utf-8?B?VDRIZWcvaU5tMkRsMTcrb2d4VTdya0hzVjk4VXJHUFV0WThuNVRpVlpXbkdp?=
 =?utf-8?B?RndGVkM3Q0JXS1dzVFFYRGdmaFgvWkROK1QxcGgvdWhDcVR6TGVGN01Bd0xB?=
 =?utf-8?B?bmxyUzRieHJTWFlORFprY1RLdFUzR3hENkpFY2NJNmh0ZHFEcFJzRTVHSXJI?=
 =?utf-8?B?cWNIY0dqQU1WNlc3dXZEelF2RWg1UGYrT0MxYWQ1T1NUMnRkWGhBOThXOHow?=
 =?utf-8?B?cThrZkt5K3p3OXV3c040aUF1dU5IV3NvSHhqUVJac1FDR1crZVdWNXVlYzR2?=
 =?utf-8?Q?4dVVQmi/x3fNInM/joAgp0782Rrc1kg/kVLgy08K7x93?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9476E2851A945343A72FF2E5749BC36F@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4470.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 770c4e7c-1361-44f7-5ef9-08dad1a19cfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 00:35:27.9627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FCPiOhcZhlElHxgeraL2aDE1GYWKMykINU2zja8PYmg7M59Bw77aH5Sr+9XTgVPC55Kmd4yLBhBhncC+7Vj7zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR05MB7775
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu79PbiAxMS8yOC8yMiwgMzo0OSBQTSwgIkphY29iIEtlbGxlciIgPGphY29iLmUua2VsbGVy
QGludGVsLmNvbT4gd3JvdGU6DQo+ICAgICAhISBFeHRlcm5hbCBFbWFpbA0KPg0KPiAgICAgT24g
MTEvMjgvMjAyMiAxMTozMiBBTSwgUm9uYWsgRG9zaGkgd3JvdGU6DQo+ICAgID4gJ0NvbW1pdCAz
OWY5ODk1YTAwZjQgKCJ2bXhuZXQzOiBhZGQgc3VwcG9ydCBmb3IgMzIgVHgvUnggcXVldWVzIikn
DQo+ICAgID4gYWRkZWQgc3VwcG9ydCBmb3IgMzJUeC9SeCBxdWV1ZXMuIEFzIGEgcGFydCBvZiB0
aGlzIHBhdGNoLCBpbnRyQ29uZg0KPiAgICA+IHN0cnVjdHVyZSB3YXMgZXh0ZW5kZWQgdG8gaW5j
b3Jwb3JhdGUgaW5jcmVhc2VkIHF1ZXVlcy4NCj4gICAgPg0KPg0KPiAgICAgTml0OiBubyBuZWVk
IHRvIHF1b3RlIGFyb3VuZCB0aGUgY29tbWl0IHJlZmVyZW5jZSBoZXJlLg0KPg0KPiAgICAgSSBk
b24ndCBwZXJzb25hbGx5IHRoaW5rIGl0cyB3b3J0aCBhIHJlLXJvbGwgdG8gZml4IHRoYXQsIGJ1
dCBnb29kIHRvIGJlDQo+ICAgICBhd2FyZSBvZiBpbiBmdXR1cmUgc3VibWlzc2lvbi4NCj4NCj4g
ICAgIFRoZSBwYXRjaCBpdHNlbGYgbWFrZXMgc2Vuc2UuDQo+DQo+ICAgICBSZXZpZXdlZC1ieTog
SmFjb2IgS2VsbGVyIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+DQoNClRoYW5rcywgSmFjb2Is
IGZvciB0aGUgcmV2aWV3Lg0KDQo=
