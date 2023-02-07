Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B0968DC5E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 16:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbjBGPBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 10:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbjBGPBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 10:01:21 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF61DDBFA;
        Tue,  7 Feb 2023 07:01:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ECrJ7j7C37NNa2KwaJww1csjVZy9FMz3jCOAhpnRXz8vPnDuAvFMnmJK5q3S3vmt6IPsOiV31jYP9j+RdWSW26vLi/YmLfPOhXbEIgrMIniwkbvdENO4+3j8Z0qxlw9SoKLYmMTlf2o6MJpH2Tfl6/Z3kzOenOfLQmqr+BA6nD/2LNZnJ+UWRWkI4dQq87OP5F2OXRjFU6otjXTdA36aNRIZPw04zrbbaYT+GHX/Ifc/35YfF5fieazJ/u2DI6i3Jqmxa+m+EVNhlFPZjB8IvI0uvqGkYGVlk39pZ/10u08jmKZAU8TKCyqX+gEdxuoLnf+zZ1fwDFsEkv1MpAWJqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sm2oz4/AztJez/K4RVqwT7MnCj2AbeVJaowXnH6wBP8=;
 b=aPVfI0TgAT3BmQnfE0ihtl3q6sat9d0sBIQbF5OhI/QE16Kc6wyQTh5TF0Zl9+N1P0RE73y3WV2dz1nkhTO6RH01WY9hRdAwhxD8MVxy+vlnnMSmXjx14ovyi6AI7zD0ffKZQhd5oGAmePavJx8dXb6JoAF8P2BkiBSARc1kOkYCEPkCECH1bxV/MhdMSR5O/ZQ6x0gYhlKpniNLivxj35h7pf3+WHw85dyecEnCOIMUAKdKQ+SdlCMEZ5SxcNUretiKUTyYGrLtdi5okCV1dOoJ2wBoKmbV5YmCiIDxJ4LaAcpuuYfmJblXQ0nLYZMaohgEglrWKjFb4haFh1+LYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sm2oz4/AztJez/K4RVqwT7MnCj2AbeVJaowXnH6wBP8=;
 b=UnhkEkk1MZ1bgw3gvMVtdES9w51PaLw3uGnU9Tgy819M3HLJuhcHRxZWnjogA06d7aKnvgX5wBfJs7DxEoiUbypPQkmmrkSgmw3VGfgKkgHxu1s1UQihG84xSwPy+yYLWPNr2UMWN6VM/hENyECMd7F36wCv/c5WX/yj6mtyP40=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by SN7PR12MB6862.namprd12.prod.outlook.com (2603:10b6:806:265::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 15:01:15 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%9]) with mapi id 15.20.6064.036; Tue, 7 Feb 2023
 15:01:15 +0000
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
Subject: Re: [PATCH v5 net-next 7/8] sfc: add support for devlink
 port_function_hw_addr_get in ef100
Thread-Topic: [PATCH v5 net-next 7/8] sfc: add support for devlink
 port_function_hw_addr_get in ef100
Thread-Index: AQHZNveZ4AEcUHNqWUuukJHT7qRNu667kJcAgAgK/oA=
Date:   Tue, 7 Feb 2023 15:01:15 +0000
Message-ID: <DM6PR12MB42028E512EAB5BA1BB8845F9C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-8-alejandro.lucero-palau@amd.com>
 <Y9uoFNFjs1QDHt2K@nanopsycho>
In-Reply-To: <Y9uoFNFjs1QDHt2K@nanopsycho>
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
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|SN7PR12MB6862:EE_
x-ms-office365-filtering-correlation-id: 765fa0e6-9ec6-4f3f-1831-08db091c2903
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fBWC52o8nZYS6DI1WONlTPKafZdyKEUOfRD0AGwU7nSr6hiUOEmv07t9gX9GzYs1SjVbsweFuESc20CaPHAxfp1HKUwq5hW7m2izdBdhp3RufJwsCIz6Ah+yp/J3li8qs3SEo7P/09jsNPUnG4ZZHMydA/3ds1FDEZYsJPDlCSLtZzLuQVjdMnA7dfhkvih7B4DL5OKMWovLgC/F3kMPHtzqOSy5JgzOHUo/m52XCUAndGGzAXHB24PL5Za2huUHlGW1dMy8omX11jJvPLovtYFcCHd4QJH5eZT5tHPh//qgtOGOYefyRn5wYPizwi7DYriZd1SxQoaXED3xmTw+HU6dxeEyNxBCsSQY/GdymHJ6YCapF0a1unxPapQlc0dCpPYSWz7e/xD0ppqIDicgfLoFRNQQRrFYqfmpqPKllXANQl9l86zWY9tR9+4lDneSsVsnKpGOrpJJz2uaorZUGCXnDXRmb7h9ThP2+kF+Qc/SO/IJdXBW2RUTIm5k32W75X7jPWwT/G2Orq3SrGR4tXOW+XMlZfU/yGBh4BV5MAVapyyN74DyiUrTvP9oTVif8KtFUJUmRhvG6SHcjiCcpDL4+seTEYmZfP5X6arwDWa4NVG0+ukFTJ4i9uSkjYGp3hZHJfcXNfoUthtnarg1MeMweDM9UAyP8dTa7VuiopjOBP3Sn1HBFhlAoNvHOwy0qq3S6kwUnO3JRe/tezcsxwQQXWDbAUKn9zrSwnVAJV8lX94Ogg/YqJwYziN9nJSh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(376002)(396003)(366004)(451199018)(316002)(6636002)(66446008)(66946007)(76116006)(110136005)(8676002)(54906003)(52536014)(66556008)(4326008)(8936002)(41300700001)(5660300002)(33656002)(38070700005)(38100700002)(122000001)(53546011)(186003)(26005)(7696005)(9686003)(6506007)(64756008)(71200400001)(83380400001)(2906002)(7416002)(66476007)(55016003)(478600001)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1ZXSVRQVC9CL0tlUDhpalMwRTRsN3ROVEd5U0NNRFBhc3BtTy95WklBcjdl?=
 =?utf-8?B?Nmo5eVpMa01HaXFGY3UzdWNiN0hyLzR1N2g2L211dnViZEZVeUt4NDhZcWds?=
 =?utf-8?B?cmw3VnowdnBGNGs2K3M4cU5sTWhPbkZpMVUvV0pFTVpoZUtBYnMzSGxGMUZx?=
 =?utf-8?B?UFRjalNGajZTS1dlclhJcDd3eGpicGhQQjBMZXRvdGtjc2pJK2hXZ01veG1p?=
 =?utf-8?B?c3pwSG9Fc1FqM1FCVERaVGliUkhyZTVPbW5adVM4enRuT2tiL3Avb0luNmE5?=
 =?utf-8?B?VFkyd2FSbXRXWnRyQnJ2ZjVXdW5zajRla2NEM1R3RWJnNmpqSE5vNXJMcVBB?=
 =?utf-8?B?RHVaZm5nWS81S3NqNGVHdHg5ZFBueEtDTGxsemtYRXBibDlYLzNNYnBvWlVW?=
 =?utf-8?B?NkRqOGVsMTNCNlZUTXVvckxyV0pPMklsc01haXJvSTlWM1pLdGdOaVNBY2Ft?=
 =?utf-8?B?UldxYURsV2RJcmxobmMvZUlxTjArc1dWcVhnQWlIRkw0MGd5YXdlTW43SU5R?=
 =?utf-8?B?Q25CSVNpYnJLREVZVGl3dEc2aTVVOEJCT0NrVVlDRVJTYTdRR1RnOGRrSzhL?=
 =?utf-8?B?MzgySG0rTEhMWnRaekFWVXNvU1dmTmprc1cxWlR3ZXl5cS9xTVhjdmNyelgz?=
 =?utf-8?B?VjBxSnEwNENoa1M1ajRieVhaY25IVC8yOGdnTzFRUTRPZzVKa2dLS1pMalBE?=
 =?utf-8?B?eXhrMU5LQnRCQVFSLzBzWVFJQUltSzZPUWNuaDdUUHhnalZMRC9yRHkvc3Q1?=
 =?utf-8?B?RDEzYmJqNmQ1cnl1OVYyNDV4ajdaYUtPWXErRnhLR1A5UmdCSEpSZ3JJNjFQ?=
 =?utf-8?B?bmw2ZjQ3dWdiek9GRG1EdlNtejRQaU92dXhNZld6eGIzdnJVZVk5WHovYVFL?=
 =?utf-8?B?S2lvRDBzc3B1RFJaTzlsNkROalVLY3NoVDVVK2JCTGtWVmJDdVM3OGFYMUVP?=
 =?utf-8?B?R1FnR0Jxb3hjaUFQYUwvWWtJcXFlb1NtRGM2WngyUDdtVmwzUG0xSHVWMG85?=
 =?utf-8?B?MUtpRm9XOHFzc0Fzajh5YmVHSU1ybTRWbERQRXo4b3lJbTJsUTJROGwxbjdT?=
 =?utf-8?B?R1ZYdHRlTmw5MHRybjFObVV0SzUrOEN2UU1vTWRnV1FEWUJEL1BRU2V1S2hm?=
 =?utf-8?B?UG1FLzMwZVB2Rm1jSU1vVE1wT25kczVRM0tSS2FaSHdQenlsNmVsWjlhTG1Y?=
 =?utf-8?B?ZmhXOGZiSlNLbmpHUENKcUh2YlVzZjArNW1kVWdFVlAvVCtXeEpNQVp5aUZO?=
 =?utf-8?B?NG1wTW1sMTRrYjUwVmErVTNpNmIrTjJDelI3aEJkUTcxUTZKZGFESmx0aHBz?=
 =?utf-8?B?Um9wSTM3Q2JTbjVBZzd2MFJGVGpNcjRKZ1doWHVJM2duYUw1aW5rL0NtS0FR?=
 =?utf-8?B?V1FIaENKYUwwR1JtSkJYSG5BWlMrbGc0Y3E0eGxPai9BVThIeTlIS2xBdnd2?=
 =?utf-8?B?TXk4bUMrRmxrQXJUT3VVcmV3YXhVL0xBN01hU1BvNExGTjJVMnVCbjJhN3RS?=
 =?utf-8?B?d0JRNCtEWlNxdHVLS0xQWURUaTI3Y0FkS21UVE5MVWdxTHdMVWI1NXM0c3NW?=
 =?utf-8?B?N0k4cmN3b3lRU0xhcFQ3SGxhTHA2U241bkVoSEkrL09SZXp3ZFdNT1dUUzAr?=
 =?utf-8?B?ZUxNaGtEV2ZoWmdZc3BRSGZjWWdFRCt2ZU92b1RTT1dCeWRXRVg4K1RnN2lz?=
 =?utf-8?B?ZnJKS0M3RGRTakYvUG1IMG9FNVB2cUsxUEI1OU4vWWdwLy9RdmNtekhiRDcx?=
 =?utf-8?B?RFBZU1k1ajF5azd3aWlFb0tGcldaT0JRNklsY3BhWmdMR1B0NzRQbEdpR1VM?=
 =?utf-8?B?QzZ6UVBpVVNTRGc0WGlmanZETVQ2YjFQUGVUNnNNbEx6dC91VTBUOG1maFEv?=
 =?utf-8?B?eXJDRzcwSThFdDhUYS9tRjNNWGxaWEZldUo4QmVjVjZXMVQ4ZGw3dXcyM3Vo?=
 =?utf-8?B?NmhNVmpxYXJCcXFqdXFpVnh1ODNBNUhLMitoL08zd0s3V1RhZzdLbmhxMkh6?=
 =?utf-8?B?VGNBNTdPYnVoSW85NldSMzZoYzFyLzJpQ2U2OHArTXlxQlVPVzRwd21ISm5B?=
 =?utf-8?B?enIvTHVwdFVjSk45WHFuV2ZwSWxRWUJFVXlRaGpOSVI1VDhTOWt4TjNCTWYw?=
 =?utf-8?Q?Fu3U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8D99DA82FBC454182771F68D4AAA94A@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 765fa0e6-9ec6-4f3f-1831-08db091c2903
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 15:01:15.4547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pfxmok0BPWD2bKNJWNl2E04pkz3dZhGcxImviPhtLngQ4e4UAV5TMajhw+6glB45NGvmNBgVIlj1ALB1rhXwRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6862
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzIvMjMgMTI6MDksIEppcmkgUGlya28gd3JvdGU6DQo+IFRodSwgRmViIDAyLCAyMDIz
IGF0IDEyOjE0OjIyUE0gQ0VULCBhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20gd3JvdGU6
DQo+PiBGcm9tOiBBbGVqYW5kcm8gTHVjZXJvIDxhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5j
b20+DQo+Pg0KPj4gVXNpbmcgdGhlIGJ1aWx0aW4gY2xpZW50IGhhbmRsZSBpZCBpbmZyYXN0cnVj
dHVyZSwgdGhpcyBwYXRjaCBhZGRzDQo+IERvbid0IHRhbGsgYWJvdXQgInRoaXMgcGF0Y2giLiBK
dXN0IHRlbGwgdGhlIGNvZGViYXNlIHdoYXQgdG8gZG8uDQoNCk9LDQoNCj4NCj4+IHN1cHBvcnQg
Zm9yIG9idGFpbmluZyB0aGUgbWFjIGFkZHJlc3MgbGlua2VkIHRvIG1wb3J0cyBpbiBlZjEwMC4g
VGhpcw0KPj4gaW1wbGllcyB0byBleGVjdXRlIGFuIE1DREkgY29tbWFuZCBmb3IgZ2V0dGluZyB0
aGUgZGF0YSBmcm9tIHRoZQ0KPj4gZmlybXdhcmUgZm9yIGVhY2ggZGV2bGluayBwb3J0Lg0KPj4N
Cj4+IFNpZ25lZC1vZmYtYnk6IEFsZWphbmRybyBMdWNlcm8gPGFsZWphbmRyby5sdWNlcm8tcGFs
YXVAYW1kLmNvbT4NCj4+IC0tLQ0KPj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmMTAwX25p
Yy5jICAgfCAyNyArKysrKysrKysrKysrDQo+PiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWYx
MDBfbmljLmggICB8ICAxICsNCj4+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZjEwMF9yZXAu
YyAgIHwgIDggKysrKw0KPj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmMTAwX3JlcC5oICAg
fCAgMSArDQo+PiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2RldmxpbmsuYyB8IDUzICsr
KysrKysrKysrKysrKysrKysrKysrKysrDQo+PiA1IGZpbGVzIGNoYW5nZWQsIDkwIGluc2VydGlv
bnMoKykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmMTAw
X25pYy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmMTAwX25pYy5jDQo+PiBpbmRleCBh
YTQ4Yzc5YTIxNDkuLmJlY2QyMWMyMzI1ZCAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3NmYy9lZjEwMF9uaWMuYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2Zj
L2VmMTAwX25pYy5jDQo+PiBAQCAtMTEyMiw2ICsxMTIyLDMzIEBAIHN0YXRpYyBpbnQgZWYxMDBf
cHJvYmVfbWFpbihzdHJ1Y3QgZWZ4X25pYyAqZWZ4KQ0KPj4gCXJldHVybiByYzsNCj4+IH0NCj4+
DQo+PiArLyogTUNESSBjb21tYW5kcyBhcmUgcmVsYXRlZCB0byB0aGUgc2FtZSBkZXZpY2UgaXNz
dWluZyB0aGVtLiBUaGlzIGZ1bmN0aW9uDQo+PiArICogYWxsb3dzIHRvIGRvIGFuIE1DREkgY29t
bWFuZCBvbiBiZWhhbGYgb2YgYW5vdGhlciBkZXZpY2UsIG1haW5seSBQRnMgc2V0dGluZw0KPj4g
KyAqIHRoaW5ncyBmb3IgVkZzLg0KPj4gKyAqLw0KPj4gK2ludCBlZnhfZWYxMDBfbG9va3VwX2Ns
aWVudF9pZChzdHJ1Y3QgZWZ4X25pYyAqZWZ4LCBlZnhfcXdvcmRfdCBwY2llZm4sIHUzMiAqaWQp
DQo+PiArew0KPj4gKwlNQ0RJX0RFQ0xBUkVfQlVGKG91dGJ1ZiwgTUNfQ01EX0dFVF9DTElFTlRf
SEFORExFX09VVF9MRU4pOw0KPj4gKwlNQ0RJX0RFQ0xBUkVfQlVGKGluYnVmLCBNQ19DTURfR0VU
X0NMSUVOVF9IQU5ETEVfSU5fTEVOKTsNCj4+ICsJdTY0IHBjaWVmbl9mbGF0ID0gbGU2NF90b19j
cHUocGNpZWZuLnU2NFswXSk7DQo+PiArCXNpemVfdCBvdXRsZW47DQo+PiArCWludCByYzsNCj4+
ICsNCj4+ICsJTUNESV9TRVRfRFdPUkQoaW5idWYsIEdFVF9DTElFTlRfSEFORExFX0lOX1RZUEUs
DQo+PiArCQkgICAgICAgTUNfQ01EX0dFVF9DTElFTlRfSEFORExFX0lOX1RZUEVfRlVOQyk7DQo+
PiArCU1DRElfU0VUX1FXT1JEKGluYnVmLCBHRVRfQ0xJRU5UX0hBTkRMRV9JTl9GVU5DLA0KPj4g
KwkJICAgICAgIHBjaWVmbl9mbGF0KTsNCj4+ICsNCj4+ICsJcmMgPSBlZnhfbWNkaV9ycGMoZWZ4
LCBNQ19DTURfR0VUX0NMSUVOVF9IQU5ETEUsIGluYnVmLCBzaXplb2YoaW5idWYpLA0KPj4gKwkJ
CSAgb3V0YnVmLCBzaXplb2Yob3V0YnVmKSwgJm91dGxlbik7DQo+PiArCWlmIChyYykNCj4+ICsJ
CXJldHVybiByYzsNCj4+ICsJaWYgKG91dGxlbiA8IHNpemVvZihvdXRidWYpKQ0KPj4gKwkJcmV0
dXJuIC1FSU87DQo+PiArCSppZCA9IE1DRElfRFdPUkQob3V0YnVmLCBHRVRfQ0xJRU5UX0hBTkRM
RV9PVVRfSEFORExFKTsNCj4+ICsJcmV0dXJuIDA7DQo+PiArfQ0KPj4gKw0KPj4gaW50IGVmMTAw
X3Byb2JlX25ldGRldl9wZihzdHJ1Y3QgZWZ4X25pYyAqZWZ4KQ0KPj4gew0KPj4gCXN0cnVjdCBl
ZjEwMF9uaWNfZGF0YSAqbmljX2RhdGEgPSBlZngtPm5pY19kYXRhOw0KPj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZjEwMF9uaWMuaCBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3NmYy9lZjEwMF9uaWMuaA0KPj4gaW5kZXggZTU5MDQ0MDcyMzMzLi5mMWVkNDgxYzEyNjAg
MTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWYxMDBfbmljLmgNCj4+
ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZjEwMF9uaWMuaA0KPj4gQEAgLTk0LDQg
Kzk0LDUgQEAgaW50IGVmMTAwX2ZpbHRlcl90YWJsZV9wcm9iZShzdHJ1Y3QgZWZ4X25pYyAqZWZ4
KTsNCj4+DQo+PiBpbnQgZWYxMDBfZ2V0X21hY19hZGRyZXNzKHN0cnVjdCBlZnhfbmljICplZngs
IHU4ICptYWNfYWRkcmVzcywNCj4+IAkJCSAgaW50IGNsaWVudF9oYW5kbGUsIGJvb2wgZW1wdHlf
b2spOw0KPj4gK2ludCBlZnhfZWYxMDBfbG9va3VwX2NsaWVudF9pZChzdHJ1Y3QgZWZ4X25pYyAq
ZWZ4LCBlZnhfcXdvcmRfdCBwY2llZm4sIHUzMiAqaWQpOw0KPj4gI2VuZGlmCS8qIEVGWF9FRjEw
MF9OSUNfSCAqLw0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZjEw
MF9yZXAuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZjEwMF9yZXAuYw0KPj4gaW5kZXgg
NmI1YmM1ZDY5NTVkLi4wYjMwODNlZjBlYWQgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9zZmMvZWYxMDBfcmVwLmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Nm
Yy9lZjEwMF9yZXAuYw0KPj4gQEAgLTM2MSw2ICszNjEsMTQgQEAgYm9vbCBlZjEwMF9tcG9ydF9v
bl9sb2NhbF9pbnRmKHN0cnVjdCBlZnhfbmljICplZngsDQo+PiAJCSAgICAgbXBvcnRfZGVzYy0+
aW50ZXJmYWNlX2lkeCA9PSBuaWNfZGF0YS0+bG9jYWxfbWFlX2ludGY7DQo+PiB9DQo+Pg0KPj4g
K2Jvb2wgZWYxMDBfbXBvcnRfaXNfdmYoc3RydWN0IG1hZV9tcG9ydF9kZXNjICptcG9ydF9kZXNj
KQ0KPj4gK3sNCj4+ICsJYm9vbCBwY2llX2Z1bmM7DQo+PiArDQo+PiArCXBjaWVfZnVuYyA9IGVm
MTAwX21wb3J0X2lzX3BjaWVfdm5pYyhtcG9ydF9kZXNjKTsNCj4+ICsJcmV0dXJuIHBjaWVfZnVu
YyAmJiAobXBvcnRfZGVzYy0+dmZfaWR4ICE9IE1BRV9NUE9SVF9ERVNDX1ZGX0lEWF9OVUxMKTsN
Cj4+ICt9DQo+PiArDQo+PiB2b2lkIGVmeF9lZjEwMF9pbml0X3JlcHMoc3RydWN0IGVmeF9uaWMg
KmVmeCkNCj4+IHsNCj4+IAlzdHJ1Y3QgZWYxMDBfbmljX2RhdGEgKm5pY19kYXRhID0gZWZ4LT5u
aWNfZGF0YTsNCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWYxMDBf
cmVwLmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWYxMDBfcmVwLmgNCj4+IGluZGV4IGFl
NmFkZDRiMDg1NS4uYTA0MjUyNWEyMjQwIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvc2ZjL2VmMTAwX3JlcC5oDQo+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMv
ZWYxMDBfcmVwLmgNCj4+IEBAIC03Niw0ICs3Niw1IEBAIHZvaWQgZWZ4X2VmMTAwX2ZpbmlfcmVw
cyhzdHJ1Y3QgZWZ4X25pYyAqZWZ4KTsNCj4+IHN0cnVjdCBtYWVfbXBvcnRfZGVzYzsNCj4+IGJv
b2wgZWYxMDBfbXBvcnRfb25fbG9jYWxfaW50ZihzdHJ1Y3QgZWZ4X25pYyAqZWZ4LA0KPj4gCQkJ
ICAgICAgIHN0cnVjdCBtYWVfbXBvcnRfZGVzYyAqbXBvcnRfZGVzYyk7DQo+PiArYm9vbCBlZjEw
MF9tcG9ydF9pc192ZihzdHJ1Y3QgbWFlX21wb3J0X2Rlc2MgKm1wb3J0X2Rlc2MpOw0KPj4gI2Vu
ZGlmIC8qIEVGMTAwX1JFUF9IICovDQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvc2ZjL2VmeF9kZXZsaW5rLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2Rldmxp
bmsuYw0KPj4gaW5kZXggYWZkYjE5ZjBjNzc0Li5jNDQ1NDdiOTg5NGUgMTAwNjQ0DQo+PiAtLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2RldmxpbmsuYw0KPj4gKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvc2ZjL2VmeF9kZXZsaW5rLmMNCj4+IEBAIC02MCw2ICs2MCw1NiBAQCBz
dGF0aWMgaW50IGVmeF9kZXZsaW5rX2FkZF9wb3J0KHN0cnVjdCBlZnhfbmljICplZngsDQo+Pg0K
Pj4gCXJldHVybiBkZXZsX3BvcnRfcmVnaXN0ZXIoZWZ4LT5kZXZsaW5rLCAmbXBvcnQtPmRsX3Bv
cnQsIG1wb3J0LT5tcG9ydF9pZCk7DQo+PiB9DQo+PiArDQo+PiArc3RhdGljIGludCBlZnhfZGV2
bGlua19wb3J0X2FkZHJfZ2V0KHN0cnVjdCBkZXZsaW5rX3BvcnQgKnBvcnQsIHU4ICpod19hZGRy
LA0KPj4gKwkJCQkgICAgIGludCAqaHdfYWRkcl9sZW4sDQo+PiArCQkJCSAgICAgc3RydWN0IG5l
dGxpbmtfZXh0X2FjayAqZXh0YWNrKQ0KPj4gK3sNCj4+ICsJc3RydWN0IGVmeF9kZXZsaW5rICpk
ZXZsaW5rID0gZGV2bGlua19wcml2KHBvcnQtPmRldmxpbmspOw0KPj4gKwlzdHJ1Y3QgbWFlX21w
b3J0X2Rlc2MgKm1wb3J0X2Rlc2M7DQo+PiArCWVmeF9xd29yZF90IHBjaWVmbjsNCj4+ICsJdTMy
IGNsaWVudF9pZDsNCj4+ICsJaW50IHJjID0gMDsNCj4gUG9pbnRsZXNzIGluaXQuDQo+DQo+DQoN
ClJpZ2h0DQoNCj4+ICsNCj4+ICsJbXBvcnRfZGVzYyA9IGNvbnRhaW5lcl9vZihwb3J0LCBzdHJ1
Y3QgbWFlX21wb3J0X2Rlc2MsIGRsX3BvcnQpOw0KPj4gKw0KPj4gKwlpZiAoIWVmMTAwX21wb3J0
X29uX2xvY2FsX2ludGYoZGV2bGluay0+ZWZ4LCBtcG9ydF9kZXNjKSkgew0KPj4gKwkJcmMgPSAt
RUlOVkFMOw0KPj4gKwkJTkxfU0VUX0VSUl9NU0dfRk1UKGV4dGFjaywNCj4+ICsJCQkJICAgIlBv
cnQgbm90IG9uIGxvY2FsIGludGVyZmFjZSAobXBvcnQ6ICV1KSIsDQo+PiArCQkJCSAgIG1wb3J0
X2Rlc2MtPm1wb3J0X2lkKTsNCj4+ICsJCWdvdG8gb3V0Ow0KPj4gKwl9DQo+PiArDQo+PiArCWlm
IChlZjEwMF9tcG9ydF9pc192ZihtcG9ydF9kZXNjKSkNCj4+ICsJCUVGWF9QT1BVTEFURV9RV09S
RF8zKHBjaWVmbiwNCj4+ICsJCQkJICAgICBQQ0lFX0ZVTkNUSU9OX1BGLCBQQ0lFX0ZVTkNUSU9O
X1BGX05VTEwsDQo+PiArCQkJCSAgICAgUENJRV9GVU5DVElPTl9WRiwgbXBvcnRfZGVzYy0+dmZf
aWR4LA0KPj4gKwkJCQkgICAgIFBDSUVfRlVOQ1RJT05fSU5URiwgUENJRV9JTlRFUkZBQ0VfQ0FM
TEVSKTsNCj4+ICsJZWxzZQ0KPj4gKwkJRUZYX1BPUFVMQVRFX1FXT1JEXzMocGNpZWZuLA0KPj4g
KwkJCQkgICAgIFBDSUVfRlVOQ1RJT05fUEYsIG1wb3J0X2Rlc2MtPnBmX2lkeCwNCj4+ICsJCQkJ
ICAgICBQQ0lFX0ZVTkNUSU9OX1ZGLCBQQ0lFX0ZVTkNUSU9OX1ZGX05VTEwsDQo+PiArCQkJCSAg
ICAgUENJRV9GVU5DVElPTl9JTlRGLCBQQ0lFX0lOVEVSRkFDRV9DQUxMRVIpOw0KPj4gKw0KPj4g
KwlyYyA9IGVmeF9lZjEwMF9sb29rdXBfY2xpZW50X2lkKGRldmxpbmstPmVmeCwgcGNpZWZuLCAm
Y2xpZW50X2lkKTsNCj4+ICsJaWYgKHJjKSB7DQo+PiArCQlOTF9TRVRfRVJSX01TR19GTVQoZXh0
YWNrLA0KPj4gKwkJCQkgICAiTm8gaW50ZXJuYWwgY2xpZW50X0lEIGZvciBwb3J0IChtcG9ydDog
JXUpIiwNCj4+ICsJCQkJICAgbXBvcnRfZGVzYy0+bXBvcnRfaWQpOw0KPj4gKwkJZ290byBvdXQ7
DQo+PiArCX0NCj4+ICsNCj4+ICsJcmMgPSBlZjEwMF9nZXRfbWFjX2FkZHJlc3MoZGV2bGluay0+
ZWZ4LCBod19hZGRyLCBjbGllbnRfaWQsIHRydWUpOw0KPj4gKwlpZiAocmMgIT0gMCkNCj4gd2h5
ICJpZiAocmMpIiBpcyBub3QgZW5vdWdoIGhlcmU/DQo+DQoNClJpZ2h0DQoNCj4+ICsJCU5MX1NF
VF9FUlJfTVNHX0ZNVChleHRhY2ssDQo+PiArCQkJCSAgICJObyBhdmFpbGFibGUgTUFDIGZvciBw
b3J0IChtcG9ydDogJXUpIiwNCj4+ICsJCQkJICAgbXBvcnRfZGVzYy0+bXBvcnRfaWQpOw0KPiBJ
dCBpcyByZWR1bmRhbnQgdG8gcHJpbnQgbXBvcnRfaWQgd2hpY2ggaXMgZXhwb3NlZCBhcyBkZXZs
aW5rIHBvcnQgaWQuDQo+IFBsZWFzZSByZW1vdmUgZnJvbSB0aGUgYWxsIHRoZSBleHRhY2sgbWVz
c2FnZXMuIE5vIG5lZWQgdG8gbWVudGlvbg0KPiAicG9ydCIgYXQgYWxsLCBhcyB0aGUgdXNlciBr
bm93cyBvbiB3aGljaCBvYmplY3QgaGUgaXMgcGVyZm9ybWluZyB0aGUNCj4gY29tbWFuZC4NCg0K
SSB0aGluayB0aGUgaWRlYSB3YXMgdG8gaGF2ZSBzdWNoIGEgcmVwb3J0IHRvIHVzZXIgc3BhY2Ug
YXMgaW5wdXQgZnJvbSBhIA0KY2xpZW50IHRvIG91ciBzdXBwb3J0IHRlYW0gd2hpY2ggY291bGQg
aGVscC4NCg0KQnV0IEkgZ3Vlc3MgeW91IGFyZSByaWdodCwgYW5kIHRoYXQgaW5mbyB3b3VsZCBh
bHNvIGJlIHJlcG9ydGVkIHdpdGhvdXQgDQpzcGVjaWZpY2FsbHkgYWRkaW5nIGl0IGhlcmUuDQoN
Cg0KPiBBbHNvLCBwZXJoYXBzIGl0IHdvdWxkIHNvdW5kIGJldHRlciB0byBzYXkgIk5vIE1BQyBh
dmFpbGFibGUiPw0KPg0KPg0KDQpUaGF0IHN1YnRsZSBjaGFuZ2UgY291bGQgaW1wbHkgYSB0b3Rh
bCBkaWZmZXJlbnQgbWVhbmluZyAuLi4gYXQgbGVhc3QgaW4gDQpteSBuYXRpdmUgbGFuZ3VhZ2Uu
IEJ1dCBJIHdpbGwgbm90IGZpZ2h0IHRoaXMgb25lIDotKSBhbmQgY2hhbmdlIGl0IGluIHRoZQ0K
bmV4dCB2ZXJzaW9uLg0KDQo+PiArb3V0Og0KPj4gKwkqaHdfYWRkcl9sZW4gPSBFVEhfQUxFTjsN
Cj4gT2RkLiBJIHRoaW5rIHlvdSBzaG91bGQgbm90IHRvdWNoIGh3X2FkZHJfbGVuIGluIGNhc2Ug
b2YgZXJyb3IuDQo+DQoNCkl0IGRvZXMgbm90IGhhcm0uIERvZXMgaXQ/DQoNCk90aGVyd2lzZSwg
SSBuZWVkIGFub3RoZXIgZ290byBpbiBwcmV2aW91cyBlcnJvciBjaGVja2luZyB3aGF0IHNlZW1z
IG9kZCANCmZvciBhIHNpbmdsZSBsaW5lLg0KDQo+PiArCXJldHVybiByYzsNCj4+ICt9DQo+PiAr
DQo+PiAjZW5kaWYNCj4+DQo+PiBzdGF0aWMgaW50IGVmeF9kZXZsaW5rX2luZm9fbnZyYW1fcGFy
dGl0aW9uKHN0cnVjdCBlZnhfbmljICplZngsDQo+PiBAQCAtNTIyLDYgKzU3Miw5IEBAIHN0YXRp
YyBpbnQgZWZ4X2RldmxpbmtfaW5mb19nZXQoc3RydWN0IGRldmxpbmsgKmRldmxpbmssDQo+Pg0K
Pj4gc3RhdGljIGNvbnN0IHN0cnVjdCBkZXZsaW5rX29wcyBzZmNfZGV2bGlua19vcHMgPSB7DQo+
PiAJLmluZm9fZ2V0CQkJPSBlZnhfZGV2bGlua19pbmZvX2dldCwNCj4+ICsjaWZkZWYgQ09ORklH
X1NGQ19TUklPVg0KPj4gKwkucG9ydF9mdW5jdGlvbl9od19hZGRyX2dldAk9IGVmeF9kZXZsaW5r
X3BvcnRfYWRkcl9nZXQsDQo+PiArI2VuZGlmDQo+PiB9Ow0KPj4NCj4+ICNpZmRlZiBDT05GSUdf
U0ZDX1NSSU9WDQo+PiAtLSANCj4+IDIuMTcuMQ0KPj4NCg==
