Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAFF69786A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 09:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjBOIn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 03:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjBOInZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 03:43:25 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F4514EAC;
        Wed, 15 Feb 2023 00:43:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btWqw/a+vv9J2KPOehIfVNmAKsulc+3DejL7hQcSwRpIS0EuWj0GgqvmZs69RNsjENNQpT5ZxWgmTLuPB1YrDRTgv8fDj397dreBroTOzYdyfaNjHqXeforjAhmDhFm6hYhvq2My/zfFP3ib4RNPdFM7rcQY2oAHe41u8lsqaTwah11hujFIhqYRhgGwoGyR98/kGzK6Mn3kK4RqVBsJYBwpXFbvPp3a4O3buhPLjskg3fp7c8nC6hzERwicTPgwpg2ExF69AWNzjOgm2qaGKn5V2SYJd0sa8MCLiyYQ5ydz2IyFGZnVJqTK4KHwaeX5tPTvynDDtNgNGOhI4Zl0Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rrbJIS/hBjEdIiXcyDXW1FoFBbY2XVyXgx80bDtmtDQ=;
 b=DvuoHp4pQM8ZBQbKnqYInB2FX/1g6Nlbg/RiK0EQDoU3D9w/Mv4Ne6L88HpWYyg+IShBuS0ObJNkEVkfHs+cPZhnetSYLxkq+pmBWAsVhASJg5u1dXjk2MnYPucCU+Wx8C/kLr5ferGiNohwi8NhAnFoGUluXOaW/Wl1+00QnhOSTIfFSkR2H0k60TL7niC5dRySIcQuMsTi5ZOhJSQh5webHqN1Ei+2Fjo9jhjXNgZY8krTEV/b9VBlJ/wBucouUazslPaGx36QbhMiRCHUEklxHGy+6YN+CGbmRRm1wZNZLGW3gqBcIfMv7k1EuE4i4T1BEXtpp1nVH3pbDvmqzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rrbJIS/hBjEdIiXcyDXW1FoFBbY2XVyXgx80bDtmtDQ=;
 b=QfEFNC4HRzVRYHq9PqjpCoqDw5XnJaw0rYxbMatBHVT9PNokXkQBjKKL7RhuTgIrpEd8noUuS/ah7U5+kiGqoFBv+V0nIQv9xRCbIxom4beEAZEZVcYSX4z/u9Lred345ysvxTPv3bZFHqWzXYPMNAsRp31vfwX2wYokavrAuoU=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by DM6PR12MB4060.namprd12.prod.outlook.com (2603:10b6:5:216::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 08:43:21 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%7]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 08:43:21 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v7 net-next 2/8] sfc: add devlink info support for ef100
Thread-Topic: [PATCH v7 net-next 2/8] sfc: add devlink info support for ef100
Thread-Index: AQHZP9nw3FNTgJCe/UuCF25AT1c/La7OD0wAgACC9ACAABi3AIABCF+A
Date:   Wed, 15 Feb 2023 08:43:21 +0000
Message-ID: <DM6PR12MB4202CDD780F886E718159A8CC1A39@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
 <20230213183428.10734-3-alejandro.lucero-palau@amd.com>
 <Y+s6vrDLkpLRwtx3@unreal> <ef18677a-74d0-87a7-5659-637e63714b15@gmail.com>
 <cac3fa89-50a3-6de0-796c-a215400f3710@intel.com>
In-Reply-To: <cac3fa89-50a3-6de0-796c-a215400f3710@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4577.namprd12.prod.outlook.com
 (15.20.6086.011)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|DM6PR12MB4060:EE_
x-ms-office365-filtering-correlation-id: 496798b9-a5bb-432c-6f37-08db0f30b181
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KREoC2a9ItDS8aMEYTsSMR9i2bbo4B8LBQJ1NiKXkqrbYz6Hnpsrz5+4Wkm24q6m9SBHeSefZwFMQPOz/nsAQMaiws9AEjyFWB9kTeJbeUedzbJXGDH5bXS71RJFAXUMJaogSh7yBBE+lC+HWjLVQP1+e11vQH9NF95PGyoAbmRGdXX5OXGYQaQ+K55Nx4nijljrD7K4zlQeL6bSJEavvyNOwFngSayMPPCb0WZ3Wy6TdxE3+TEXE26WiL4BAOK0Hkyd9g7R/8Dt77bi1vB2AxlGf0RG/g+TXARAJSGATRhg0fN5+2K1bPpRo8HFdnbzRjRL+Wgj7izP4GPPOdAAsmzPXah8u5VDfkqx5Olx4CFol+V+e/5ILSrZo2vh7PPF1TwYlPtdKuxC+zKIPBiTdbqlFfoth5DlSyVF3EXa/u6WQ3Yk8l7wBChPvOL6sHhHTGgpdV35Y11WnKvgO4Q6Mma5lwWITDdpqeIZRertnZLo/5XLwyXcuZujjMna1JA3/MzyBzRa+CsnbwScolKq9YbIjn3I/m4FyqcauHwAfKGg9C80wU7VU4IfbkfYZ0tqcqs4Hz7N7flXwbOKtZBFRpD5sfrKAgBoR9h3t8Z/7K+VEspJ/jVMZZbch+39Sh09jj+JbHsCON4/BFhhDFXRr8SFhSYKhoeI7BA4z5cmkHDgI7phf5cUivY3JYMQ7cVX5npL6ZFlIcmmDe5Fj9b9Bhq3C8VilzaFbX71io4S9YGx7oZz3jRw6GbvFi2vM9ou
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(366004)(376002)(39860400002)(451199018)(33656002)(38070700005)(316002)(110136005)(54906003)(8676002)(66556008)(4326008)(64756008)(66446008)(76116006)(66946007)(478600001)(66476007)(7696005)(71200400001)(2906002)(52536014)(8936002)(41300700001)(5660300002)(7416002)(38100700002)(55016003)(122000001)(186003)(9686003)(26005)(53546011)(6506007)(83380400001)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0JPczFibUJIU2E4azlpN1hpbXQwNGtmL1ArdS9wQWVQOXhHR3A0OGIyTHNo?=
 =?utf-8?B?ZG04S1VBWFFGcjVabFBBTWRxc3pFTlhhVWgyN01nazRMT0YvbytnRU9SeDBv?=
 =?utf-8?B?cDkrSmtwUFdGK3kza0VscWdleXBWelJ5MFFHazh5R2RySWhQTnovdE93azFa?=
 =?utf-8?B?MzBoNllWNGpLMjZFd2M5UmNxOXRwSHh2OVh6bUV2cVBxTGpnaCtad1J0Tm9U?=
 =?utf-8?B?ckFiN1lwZktsSHJ0OFZBTDVjWC9xVXIwaXIxaDJBeDA3dTFrMFdCamltZ3RK?=
 =?utf-8?B?em4wQUVDTi93L2Iya2FEanI0d1VWY0xGZHdEVml2WFhtL0FJMnY0WExhcGpW?=
 =?utf-8?B?eVBqelpZQ2o1RDBEQW42MjczaEpYa2orZEtCNHcxTVJ1QjRCMG81aUhXa1Rh?=
 =?utf-8?B?UWFJL2VhaUdDeTVFR1dvc1lYRUxiWXh5eEZpUHFUbE00b2ljOGc1cnh2SWta?=
 =?utf-8?B?RStFQlBqYTRGa2dXOTRCMkJ5dzJkQU1ocUUyMnZHNTdHMnZCY1c1TlFNYlhI?=
 =?utf-8?B?M0k0TUpnQ2ZoTC9CK2xwTDZlTjRwTGxBRmJtVjg4MElHVjg0ZmpQY05nSnBj?=
 =?utf-8?B?aXhXc1FscnBVSWVPUUlIdlpWNDNxazdQT0VEMElsWmU0VC95T2lMNEdZM0Vx?=
 =?utf-8?B?SkczMFhxY2M5ZHJlaW8yTVpjNmhGSy9wOEEwQ0RVT29zaWY2L1ltaGM0UjV4?=
 =?utf-8?B?aHdBUUxZZU0vd25XM2tINkwxYmdyYlVKbFRTK3RHamxUK1dONzNOWjZmdUMx?=
 =?utf-8?B?TE5XU0dxcm4veVZSOUhzNTV0dGx2OW9OYlg4QnNjdWpid2xaQkN6RENFM1R3?=
 =?utf-8?B?RnAxeVo0Z1pQa0xTa24zSUNQU0p0VjBBbktoSHR2aUdZUjBYM2s4eXlaRXRF?=
 =?utf-8?B?S1pBWm84WENscERhL2grSDNkMUlFK2V1WjZaY01iRnpnWG9ySzhFWjFlQmhU?=
 =?utf-8?B?Tms4WitqTWdCeVBnUWJabUpJeFd3VHBURTBQU0ZoRFViaFRqaTBOQUl1RkNV?=
 =?utf-8?B?RUNoVzBhWXdQUVp6Y3FKTWJmeGZyRi8wWjV3YnU3VS9QUG9zazlQaVNPemNZ?=
 =?utf-8?B?OGxTbkFsZDFjU3dLSW1NR2g4dWJYVEJpTmJtZVBPU2JNYVlYK3hpMVliNGJq?=
 =?utf-8?B?SDRkV2l0c2NVMlNmeFkyTTVORk8vaGdsWHgrZWsvY0F3a1JldGYvQmZydzJJ?=
 =?utf-8?B?RldhRHJFckg3L05qZGpMSnRzMmc2SC9vbG1ldjExc0tNa1ByNkdqVlpVMVJ0?=
 =?utf-8?B?VlpWUXRqSGtaelczNHQ2VS9IcEphRldoWDNHSU9uaTQ1QnU3TlRPUHp1Z2FM?=
 =?utf-8?B?b2IwT045L1NBZGZaQVM1M0QwVng2US90L0ZyKzB2azR3VkZPelJyeitSN0Q3?=
 =?utf-8?B?bkwvOXdGdHBaK0lBTEI1a1FHVXJJRGx5RUNiczRNTDlXbHBxYVR2MDl4SFd2?=
 =?utf-8?B?QlNFdkdIZ3VyNmtEbnREK3ZLTmhWclpVaHZrVExxUURGTW1Bb2toSjVsaWto?=
 =?utf-8?B?SnY5Ym9wdkJyenM2eCtaQ3BadHE4RERzWFN3RkkwK0RJMmNld1FteXlMTzZq?=
 =?utf-8?B?d0lOTWxWa0MzcCs2VG1sTHUwcjRRYlBZc2ovUWxOelRRcEc5dkJFQVRVdEtF?=
 =?utf-8?B?em5MTHZTVDVTeTJNNWR0UzNZTWhJN1R0WUFsd3B5TUtMVTBKb3dZc2hsdTJ1?=
 =?utf-8?B?aWlLSDlaYVhvaHhoUjI1M3gwNkl1V2thcU9FV1l2a2R2bFBYVkRpRGUrYXBl?=
 =?utf-8?B?Q1lDVDU0QUdaZklkcHFLOC93c2JHUThDcjZZbURuVkhxOEJleCtRYlpqV1Bu?=
 =?utf-8?B?RDc0RHhJUUtpTnVWYTFQQmQ5WlBTMTBHK2lOWlB0TSthaTRweGtpR0NsenIv?=
 =?utf-8?B?M1VFUXhDQkNKRk1RQm5pRnVZS1BSNnh3bUpjdFpaMTVTNTJxTWlNTU95RkZN?=
 =?utf-8?B?U283UkhUbkFLUnNBLzVaK3I4NjM0dEp3Y0tJakZxVkc5NGhUK0NxMGR5Y0lj?=
 =?utf-8?B?dVNjc1hDN0t1Y3RObW53cWpvNTNtM0Vrelk4OXRUUEsxT0tHbVhoUW9FTEp1?=
 =?utf-8?B?cHRwbmVKRUpnYVFDSStQaG12QkZmWGtGWGhlckJwYy9VVTMzTmpnaEpINWZx?=
 =?utf-8?Q?+5Rs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1B0F5D9FB496643A2A2CF67A0ADC76F@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 496798b9-a5bb-432c-6f37-08db0f30b181
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 08:43:21.3487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H53dPRL9KTm6SZZeiG3GnjOCVvOBuhNmKFcY9doo0Ip39Ci3eNyXoz67FmRvx9oqO6ISZhilSHZAC0UDZ1yuPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4060
X-Spam-Status: No, score=1.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzE0LzIzIDE2OjU2LCBBbGV4YW5kZXIgTG9iYWtpbiB3cm90ZToNCj4gRnJvbTogRWR3
YXJkIENyZWUgPGVjcmVlLnhpbGlueEBnbWFpbC5jb20+DQo+IERhdGU6IFR1ZSwgMTQgRmViIDIw
MjMgMTU6Mjg6MjQgKzAwMDANCj4NCj4+IE9uIDE0LzAyLzIwMjMgMDc6MzksIExlb24gUm9tYW5v
dnNreSB3cm90ZToNCj4+PiBPbiBNb24sIEZlYiAxMywgMjAyMyBhdCAwNjozNDoyMlBNICswMDAw
LCBhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20gd3JvdGU6DQo+Pj4+ICsjaWZkZWYgQ09O
RklHX1JUQ19MSUINCj4+Pj4gKwl1NjQgdHN0YW1wOw0KPj4+PiArI2VuZGlmDQo+Pj4gSWYgeW91
IGFyZSBnb2luZyB0byByZXN1Ym1pdCB0aGUgc2VyaWVzLg0KPj4+DQo+Pj4gRG9jdW1lbnRhdGlv
bi9wcm9jZXNzL2NvZGluZy1zdHlsZS5yc3QNCj4+PiAgICAxMTQwIDIxKSBDb25kaXRpb25hbCBD
b21waWxhdGlvbg0KPj4+ICAgIDExNDEgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+Pj4g
Li4uLg0KPj4+ICAgIDExNTYgSWYgeW91IGhhdmUgYSBmdW5jdGlvbiBvciB2YXJpYWJsZSB3aGlj
aCBtYXkgcG90ZW50aWFsbHkgZ28gdW51c2VkIGluIGENCj4+PiAgICAxMTU3IHBhcnRpY3VsYXIg
Y29uZmlndXJhdGlvbiwgYW5kIHRoZSBjb21waWxlciB3b3VsZCB3YXJuIGFib3V0IGl0cyBkZWZp
bml0aW9uDQo+Pj4gICAgMTE1OCBnb2luZyB1bnVzZWQsIG1hcmsgdGhlIGRlZmluaXRpb24gYXMg
X19tYXliZV91bnVzZWQgcmF0aGVyIHRoYW4gd3JhcHBpbmcgaXQgaW4NCj4+PiAgICAxMTU5IGEg
cHJlcHJvY2Vzc29yIGNvbmRpdGlvbmFsLiAgKEhvd2V2ZXIsIGlmIGEgZnVuY3Rpb24gb3IgdmFy
aWFibGUgKmFsd2F5cyogZ29lcw0KPj4+ICAgIDExNjAgdW51c2VkLCBkZWxldGUgaXQuKQ0KPj4+
DQo+Pj4gVGhhbmtzDQo+PiBGV0lXLCB0aGUgZXhpc3RpbmcgY29kZSBpbiBzZmMgYWxsIHVzZXMg
dGhlIHByZXByb2Nlc3Nvcg0KPj4gICBjb25kaXRpb25hbCBhcHByb2FjaDsgbWF5YmUgaXQncyBi
ZXR0ZXIgdG8gYmUgY29uc2lzdGVudA0KPj4gICB3aXRoaW4gdGhlIGRyaXZlcj8NCj4+DQo+IFdo
ZW4gaXQgY29tZXMgdG8gImNvbnNpc3RlbmN5IHZzIHN0YXJ0IGRvaW5nIGl0IHJpZ2h0IiB0aGlu
ZywgSSBhbHdheXMNCj4gZ28gZm9yIHRoZSBsYXR0ZXIuIFRoaXMgIndlJ2xsIGZpeCBpdCBhbGwg
b25lIGRheSIgbW9tZW50IG9mdGVuIHRlbmRzIHRvDQo+IG5ldmVyIGhhcHBlbiBhbmQgaXQncyBh
cHBsaWNhYmxlIHRvIGFueSB2ZW5kb3Igb3Igc3Vic3lzLiBTdG9wIGRvaW5nDQo+IHRoaW5ncyB0
aGUgZGlzY291cmFnZWQgd2F5IG9mdGVuIGlzIGEgZ29vZCAoYW5kIHNvbWV0aW1lcyB0aGUgb25s
eSkgc3RhcnQuDQoNCg0KSXQgaXMgbm90IGNsZWFyIHRvIG1lIHdoYXQgeW91IHByZWZlciwgaWYg
Zml4aW5nIHRoaXMgbm93IG9yIGxlYXZpbmcgaXQgDQphbmQgZml4aW5nIGl0IGxhdGVyLg0KDQpU
aGUgZmlyc3Qgc2VudGVuY2UgaW4geW91ciBjb21tZW50IHN1Z2dlc3QgdGhlIGxhdHRlciB0byBt
ZS4gVGhlIHJlc3Qgb2YgDQp0aGUgY29tbWVudCBzdWdnZXN0cyB0aGUgZml4IGl0IG5vdy4NCg0K
QW55d2F5LCBwYXRjaHdvcmsgc2F5cyBjaGFuZ2VzIHJlcXVlc3RlZCwgc28gSSdsbCBzZW5kIHY4
Lg0KDQpUaGFua3MNCg0KPiBUaGFua3MsDQo+IE9sZWsNCg==
