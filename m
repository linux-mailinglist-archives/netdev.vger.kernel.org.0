Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED00E6BCD4C
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjCPKxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjCPKxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:53:52 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F05710A;
        Thu, 16 Mar 2023 03:53:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMdI05FcXMB7lDT/U+tZPnhKAOc4+3XTz65zecKw9hW0hLNsKYFJFuw7ktyayu7eCOUGc+gpPQWIhQ5HhydqFc30v3eEtCjLTp7P/mkWo6OkqzUqbXhRqccj9T3c5dHffbBWxKs/vtvBtNWzU1+6t1GzT741tIQBXNCMY+VyAylfQo/Tp1k8UonIQ9Wi5lzivbqR+GLOgYYHqqQ+/YTtgFb2UqeKIU1QVdQw4FhqAJtCcWp++mEFJ0vpkqZIvt9naSC6D7nUap8nRND0NpUOTvIAaa3Wvc3LI6KrsVZoe60/bp2jPha0u7bJe+mZvZPT+VYVXDAxy9FZqPYwDvkuCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RXETBRMeMqgyfaIx4K8zzJYWr7k/K47Dw6ittSx4wfI=;
 b=gwvXKB+oKBBI1rLJorVWxaYohCeQklFaBZPFj/evg05FnOVbLoZ7yriQGvgQQW03r7Z6s8QNarsRVWi7sSTaWvZuUzU1KeItDFC/MGQDs5g1lQFyGSoBKE1YVzWhcHrhqwYQDYOMxOSoxvQWA9b7pn9uQF3gQKpWM+i8Ze5XJFHLkEl9d4o+ITsfSX2U1JSyOq/votg6FChXFA61kRmWZOZzkdkzD6AQpk4YTI7t0GQYc3rAKLuqDGGDdVMa2jiVaxi0ZePtCE8mmIPNvBLnG6HgZDUyWE1zVGzayeOmkdcGQ4OWYX9ByFCr/+tReq3TnGWSGQLMpO/RJiDfl1fkOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXETBRMeMqgyfaIx4K8zzJYWr7k/K47Dw6ittSx4wfI=;
 b=0OGhilehKLklwVeor72ur9/GnF87ylyBs3mhj6+bxSahl54KWMx8T1vZdZLJaYqDkYr2u/UgLHJeKSq28p4tGjVM3o85by2pmnz/EQ1ehuPS8tMor5l3S2KEf1YnWveZ8ZNEP29Jw/EoH/P/vhdA/0dFyBzNTX77FxoTS7DMevM=
Received: from MW5PR12MB5598.namprd12.prod.outlook.com (2603:10b6:303:193::11)
 by SA1PR12MB7317.namprd12.prod.outlook.com (2603:10b6:806:2ba::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Thu, 16 Mar
 2023 10:53:45 +0000
Received: from MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::9d4f:fc5e:1bae:3654]) by MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::9d4f:fc5e:1bae:3654%5]) with mapi id 15.20.6178.026; Thu, 16 Mar 2023
 10:53:44 +0000
From:   "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
        "Sarangi, Anirudha" <anirudha.sarangi@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH net-next V3] dt-bindings: net: ethernet-controller: Add
 ptp-hardware-clock
Thread-Topic: [PATCH net-next V3] dt-bindings: net: ethernet-controller: Add
 ptp-hardware-clock
Thread-Index: AQHZUYEJ2QaNLSVIj0yKLdN2Kq23Cq7wXv4AgAoWP4CAAtBxoA==
Date:   Thu, 16 Mar 2023 10:53:44 +0000
Message-ID: <MW5PR12MB55988A6BACF98A29391CF64D87BC9@MW5PR12MB5598.namprd12.prod.outlook.com>
References: <20230308054408.1353992-1-sarath.babu.naidu.gaddam@amd.com>
 <20230308054408.1353992-2-sarath.babu.naidu.gaddam@amd.com>
 <c2773010-2367-ba20-e0fa-2e060cb95128@linaro.org>
In-Reply-To: <c2773010-2367-ba20-e0fa-2e060cb95128@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR12MB5598:EE_|SA1PR12MB7317:EE_
x-ms-office365-filtering-correlation-id: 779eaf5d-877d-4038-d127-08db260cb69c
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z/6ajsigi2sSBg/XhQsViftInqjDFP1uaG5qJX0EzhMOxBekG26cA9SVmmuZmfD3+Jfe+OTafJezPGqszwK+sJi1K1Gt2KRiOdcaNxyYyET9WQwNFLoS5Tfsw84WGYL6swwA0P3maT+UigTpxLrzwQ5kocsfdzxDWLVq+czxozx3vyyaSXXnHlesfcyuz0E1SOk20JI9jEi2lddg5zInxSIf0Tdo37mfr+jd1kEa+l6gQBpGiP7iZvPWBtW7Re7VOy9NqeWqtwNTAGMjR8wsWu6FyIlg4DPRdr+mcGGDSLmqMvjFUJRRbLHYyMI8kLYMq7MnMUNkvHCZNcuMSDBIFbPoWmAqGu+5enZEPez2iMl58sJaX3U6qS3JfoRKqQsLkRN91AivkcUDVPYd869V8bKYLNA572TEnpEn3tC+ja/dkkHU5C8/vX6VGWRv7A6bZ4iZGUB98sWpiDBsUmAOus/Xm7qbQx63Cf8bJm1lkqz0OQc7VsAOOjUdQ9ae7QSmpn/jVB1bd3tBD/4l3SZ7wqyQupIgL3UPp4OQHrQ+lNcxVw7Wjz9mAu2NqDCK5SlptkBKV/IU0xdHf2FZpFBget7qEWboW6zUlCWaCWdfnSOWijh502pOykLjbOEQ+MACHFCEGLeEF1CU4kjP0oebDbEYycg6ZCW892yG6KmJO5F767rkenCseR4F7RomJJvs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR12MB5598.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199018)(33656002)(86362001)(9686003)(186003)(53546011)(26005)(6506007)(71200400001)(38070700005)(7696005)(83380400001)(478600001)(55016003)(110136005)(54906003)(316002)(66476007)(41300700001)(64756008)(66946007)(122000001)(66556008)(66446008)(2906002)(76116006)(4326008)(8676002)(5660300002)(52536014)(8936002)(7416002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3ZsM1I4and0cU5mTUFYMjJibUZselVWM2g0NHRpUVVqbUVQVDJXUUx4RHJU?=
 =?utf-8?B?Q0JvdEY3ZWxqWGVsSjhGbXBpRlFiRGVhdGthZisvMlBEMklMK3JnQWhQbFU4?=
 =?utf-8?B?SSs4RmpFNVpkQjVDRk5wUjJ4S3lMZ3B2ZlVSZmZtQlBTZjR1ZEJpcmFQR2RE?=
 =?utf-8?B?dUFIYyt2cUQzU3FvSFdoUlFuK2J1V2ZjRXFWY2xzK1dXYmtoUVdiQlJwQm1N?=
 =?utf-8?B?Nmc1NWx0UDgzN1hVb0JRZHNPNmVlMmVneXA0YjZnOTFvV0NqdXdpcjRNUTN0?=
 =?utf-8?B?RXFObnhGZ1lBRE1GRFhWUG15RnpNR0xJbFRaV2txUS8vODZnaFRNV0tRRjI4?=
 =?utf-8?B?QkIxUTVNb2lQNmxEM1dBZ011Q3VJVERhU2EyVWFOb1pSR21hRVhtcTlvbVZo?=
 =?utf-8?B?MTlSbEN0eDRRa3pFaHE1emoxelM1ZDY4aXo1RWpZMjhqcVR5U1ZjK2VGS2pm?=
 =?utf-8?B?eFdQOTVOV2FCZjYxT1JYMjVhelY0U3p6TVRFRU1VWUdCcmc0YW16THplVk1O?=
 =?utf-8?B?NlNMd2VSVUlNdlJBa3JGZ09yakVHWHYwaVhPazN4Q3ZDbnQzSjVWSGptZWk2?=
 =?utf-8?B?WERnL1lNUy9NWks2V3dsN0ttNGs0RU8xRmZIZWl0MEJUVzNRbnlkSzh1YVI0?=
 =?utf-8?B?MC9KYWI0RG03THFqclBsVTZHVThuaXdlbnJFSUZ4R2VLU1FRZWIzNUJpSXpB?=
 =?utf-8?B?SDRpcDlzL2Mya1h1LzMzSzBTN1R4OWsxalNZbGlSOW5kbWUvV2ZneERVa0l4?=
 =?utf-8?B?S212RWh4VXlPK3pDZDQwWjJ2MkQyRUNsUEVRTHR2aEhpUlZ3ZWpVTHRCTHVZ?=
 =?utf-8?B?UFAzZStNaW1CR0oycGxyWjJnRUdKM1VHUldGdGZZVjVQNC93WjI0KzEveko2?=
 =?utf-8?B?ZWplVUlneG9oOTBNSmF1a3BiYktRSlE4U0xSdEJxY25wYmh0Q3k3eWVoUUtW?=
 =?utf-8?B?WkpBMCtqYmZ6MWxMWmEvWnhaR05iYXlwNHl5RjlxT1RKOGc3cXBLMlpiVzUv?=
 =?utf-8?B?bVBGelNGbUJzcjdXNDdvSGl0WUlta2ZzdExScGMrMXZyRTVMZDEvSUVraS9j?=
 =?utf-8?B?b2tQbWRKZ1VkVFZ2bWRrS2JHN3NjV2J1R3NUWnBHSGYyRTlSdHMzcGRCU2dy?=
 =?utf-8?B?OVZObTliVW5uS01mQWZ4RE5uUkFFMituODBUSFVnM1IzNUJ2SkQraVV4YnVz?=
 =?utf-8?B?U2szdzJOS1FMaVhOakRNdFpEa1VvRWl0eWpjUW12RndLZVdUVFJnUlZucnpo?=
 =?utf-8?B?NUpxVXlaZGhnRXZhNERINW5PYW94YlRwenJiYTVWL3RBd0x6MzRaQkUrdjlC?=
 =?utf-8?B?OUFqZlJNQnJTYWVQSUJpUEN5RjBjUnZTRHcvRVRnOExrSGNCVUp0VHExRlZ1?=
 =?utf-8?B?UDNVbUYxU2dzdlNPY0ZUUktjdWZFVXlCL2E2ZGo4VVUwNXhWVTNUWjcwc01n?=
 =?utf-8?B?TDA5Q0dCQ09kanBjWkc4UEtTRkExTlFKM3FMNFMzSXBSQmowQVBFZ1paSEdr?=
 =?utf-8?B?SWgvTXdyZ0R2ZzgwOWNEd1VMc2xJRXRhdXZuTXZlWE1sS1ZNazhPZGpGcTFu?=
 =?utf-8?B?MmdSaDN4N0puVUNVNWxjdk0zckViVUFOTkJybFBxNHlSZWlYMVJiNXlrV3V0?=
 =?utf-8?B?YlZKNWgzNFUvRkxEYWRHM2huL2orZGZSbEhYRlcyWUhZbVFUNFhIWDQwRVNm?=
 =?utf-8?B?YzU5cVBOc2F0QjRZbER3NnVYWnBXZStueEptd2FNZmpET0hDZUxBTmU2Yko3?=
 =?utf-8?B?d2dCSzRmbFdNSjBxNkljaXN6VlB2TzJoWUMzSG9BbFh1cUZGRVJhNHo0dlJa?=
 =?utf-8?B?RXFlWkQvb3VERUxOOU1haGgyOStYcVViZVdRZCs4dHRCRUFWa3A5V01EY21W?=
 =?utf-8?B?SlZhbFp1TUJpWGpqTTAwUzM1d3h0aFhCMTkyOUwxV0tQdHVPU1g3TUkyT1hm?=
 =?utf-8?B?akh1dEtISVcwYXF3eFAzTXp0TjJIZExBdzVQSHlmQUZhdzRtV2xIK3IxZmdB?=
 =?utf-8?B?bFY3SkRMeldjVjJydzRhRlNtb1ptdkYxSmJBVU94c2tUUUV5TlBqK2ZuVkta?=
 =?utf-8?B?ZTVrcForYnNvTXlyNENMY1RSN2pxSVpDNGZxd2ppTkt4dXBDOUZRVEl2bTFF?=
 =?utf-8?Q?jElA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR12MB5598.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 779eaf5d-877d-4038-d127-08db260cb69c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 10:53:44.7781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TxjDcaJh9XTLoXf0bJJEKX4HElvzC8h6bBZYTzmE1VSC77p0lZIeBrpmyUKOza2vOBB0bjhY0EvsFRklqzOUug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7317
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTZW50OiBUdWVzZGF5LCBN
YXJjaCAxNCwgMjAyMyA5OjE2IFBNDQo+IFRvOiBHYWRkYW0sIFNhcmF0aCBCYWJ1IE5haWR1DQo+
IDxzYXJhdGguYmFidS5uYWlkdS5nYWRkYW1AYW1kLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7
DQo+IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5j
b207DQo+IHJvYmgrZHRAa2VybmVsLm9yZzsgcmljaGFyZGNvY2hyYW5AZ21haWwuY29tDQo+IENj
OiBrcnp5c3p0b2Yua296bG93c2tpK2R0QGxpbmFyby5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7DQo+IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnOw0KPiB5YW5nYm8ubHVAbnhwLmNvbTsgUGFuZGV5LCBSYWRoZXkgU2h5YW0NCj4gPHJh
ZGhleS5zaHlhbS5wYW5kZXlAYW1kLmNvbT47IFNhcmFuZ2ksIEFuaXJ1ZGhhDQo+IDxhbmlydWRo
YS5zYXJhbmdpQGFtZC5jb20+OyBLYXRha2FtLCBIYXJpbmkNCj4gPGhhcmluaS5rYXRha2FtQGFt
ZC5jb20+OyBnaXQgKEFNRC1YaWxpbngpIDxnaXRAYW1kLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCBuZXQtbmV4dCBWM10gZHQtYmluZGluZ3M6IG5ldDogZXRoZXJuZXQtY29udHJvbGxlcjoN
Cj4gQWRkIHB0cC1oYXJkd2FyZS1jbG9jaw0KPiANCj4gT24gMDgvMDMvMjAyMyAwNjo0NCwgU2Fy
YXRoIEJhYnUgTmFpZHUgR2FkZGFtIHdyb3RlOg0KPiA+IFRoZXJlIGlzIGN1cnJlbnRseSBubyBz
dGFuZGFyZCBwcm9wZXJ0eSB0byBwYXNzIFBUUCBkZXZpY2UgaW5kZXgNCj4gPiBpbmZvcm1hdGlv
biB0byBldGhlcm5ldCBkcml2ZXIgd2hlbiB0aGV5IGFyZSBpbmRlcGVuZGVudC4NCj4gPg0KPiA+
IHB0cC1oYXJkd2FyZS1jbG9jayBwcm9wZXJ0eSB3aWxsIGNvbnRhaW4gcGhhbmRsZSB0byBQVFAg
Y2xvY2sgbm9kZS4NCj4gPg0KPiA+IEl0cyBhIGdlbmVyaWMgKG9wdGlvbmFsKSBwcm9wZXJ0eSBu
YW1lIHRvIGxpbmsgdG8gUFRQIHBoYW5kbGUgdG8NCj4gPiBFdGhlcm5ldCBub2RlLiBBbnkgZnV0
dXJlIG9yIGN1cnJlbnQgZXRoZXJuZXQgZHJpdmVycyB0aGF0IG5lZWQgYQ0KPiA+IHJlZmVyZW5j
ZSB0byB0aGUgUEhDIHVzZWQgb24gdGhlaXIgc3lzdGVtIGNhbiBzaW1wbHkgdXNlIHRoaXMgZ2Vu
ZXJpYw0KPiA+IHByb3BlcnR5IG5hbWUgaW5zdGVhZCBvZiB1c2luZyBjdXN0b20gcHJvcGVydHkg
aW1wbGVtZW50YXRpb24gaW4NCj4gdGhlaXINCj4gPiBkZXZpY2UgdHJlZSBub2Rlcy4iDQo+ID4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXJhdGggQmFidSBOYWlkdSBHYWRkYW0NCj4gPiA8c2FyYXRo
LmJhYnUubmFpZHUuZ2FkZGFtQGFtZC5jb20+DQo+ID4gQWNrZWQtYnk6IFJpY2hhcmQgQ29jaHJh
biA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPg0KPiA+IC0tLQ0KPiA+DQo+ID4gRnJlZXNjYWxl
IGRyaXZlciBjdXJyZW50bHkgaGFzIHRoaXMgaW1wbGVtZW50YXRpb24gYnV0IGl0IHdpbGwgYmUg
Z29vZA0KPiA+IHRvIGFncmVlIG9uIGEgZ2VuZXJpYyAob3B0aW9uYWwpIHByb3BlcnR5IG5hbWUg
dG8gbGluayB0byBQVFAgcGhhbmRsZQ0KPiA+IHRvIEV0aGVybmV0IG5vZGUuIEluIGZ1dHVyZSBv
ciBhbnkgY3VycmVudCBldGhlcm5ldCBkcml2ZXIgd2FudHMgdG8NCj4gPiB1c2UgdGhpcyBtZXRo
b2Qgb2YgcmVhZGluZyB0aGUgUEhDIGluZGV4LHRoZXkgY2FuIHNpbXBseSB1c2UgdGhpcw0KPiA+
IGdlbmVyaWMgbmFtZSBhbmQgcG9pbnQgdGhlaXIgb3duIFBUUCBjbG9jayBub2RlLCBpbnN0ZWFk
IG9mIGNyZWF0aW5nDQo+ID4gc2VwYXJhdGUgcHJvcGVydHkgbmFtZXMgaW4gZWFjaCBldGhlcm5l
dCBkcml2ZXIgRFQgbm9kZS4NCj4gDQo+IEFnYWluLCBJIHdvdWxkIGxpa2UgdG8gc2VlIGFuIHVz
ZXIgb2YgdGhpcy4gSSBhc2tlZCBhYm91dCB0aGlzIGxhc3QgdGltZSBhbmQNCj4gbm90aGluZyB3
YXMgcHJvdmlkZWQuDQo+IA0KPiBTbyBiYXNpY2FsbHkgeW91IHNlbmQgdGhlIHNhbWUgdGhpbmcg
aG9waW5nIHRoaXMgdGltZSB3aWxsIGJlIGFjY2VwdGVkLi4uDQoNCkFwb2xvZ2llcyBmb3IgbWlz
Y29tbXVuaWNhdGlvbi4gQXMgb2Ygbm93LCB3ZSBzZWUgb25seSBmcmVlc2NhbGUgZHJpdmVyDQpo
YXMgdGhpcyB0eXBlIG9mIGltcGxlbWVudGF0aW9uIGJ1dCB3aXRoIGRpZmZlcmVudCBiaW5kaW5n
IG5hbWUuIHdlIGRvIA0Kbm90IGhhdmUgdGhlIGhhcmR3YXJlIHRvIHRlc3QgdGhpcy4gSG93ZXZl
ciwgSSBhbSBnb2luZyB0byB1cHN0cmVhbSBQVFANCnN1cHBvcnQgaW4gQU1EL1hpbGlueCBheGll
dGhlcm5ldCBkcml2ZXIgdGhhdCB3aWxsIGJlIHVzZXIgb2YgdGhpcyBiaW5kaW5nLg0KDQogSSB3
aWxsIHBpY2sgdXAgb24gdGhpcyBiaW5kaW5nIGFnYWluIGFsb25nIHdpdGggY29uc3VtZXIgZHJp
dmVyIGFuZCBhZGRyZXNzDQogeW91ciByZXZpZXcgY29tbWVudHMuICAgICANCg0KVGhhbmtzIGZv
ciB0aGUgcmV2aWV3Lg0KDQpUaGFua3MsDQpTYXJhdGgNCg0KDQoNCg0KDQo=
