Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E98C68EA36
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 09:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjBHIx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 03:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjBHIx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 03:53:28 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9109EFD;
        Wed,  8 Feb 2023 00:53:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZ9osGKGdmbDQBWe7AbSajPPvM88oAw5Bg8AOx8cwQOHTih5LEwe72fMBpN1xsmlvItk+5gQR6YkN+hA2PCcQWmuPypmdm0ePk2pkU6gSer30LoE3QSzt26orbaXXODFkW9lAqsHE4ao4/jOaLY0WDA8usFjpAmrqzmcS7CnALqTKLWjJdSIMvBOP8WX6kPAzoaZidDlsYVQ/fty+a74/qBIxFCzbLAy6D5PM2p5mWVS7TQk/oMedmCinP02Nc89luCEQQqgbyEVOa+fZ9YTDvFvxgxHgmBgofcdomDZdynUb4KrI6oIUVyOOEtnv1wyDvC08XMAQhA5xoUWNTbXRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JjZMereU4sc2hToEDPJ3PxvEBbA3JZnhuvlr8IiV0lY=;
 b=DhlUKzpQniCr4tzRg11hKugsNYTwqQaaSjdBDgZx1q/cytfJEvnqteIv+R/70qx8ofI2T95BGSa4gDVeYaE7zjYU8Ik+A53aj2lT3aEAYOKTCGR8S8MTzfaIj8KR8FT57Bk5PxdC6kWLTFRzto3q3DDc+KjU5+omqAJX8eoKegPZDZGryEL4JTQ1LSf5sm/qLCKs/gXpM5keylxxbxGv3boFKPvTzItKzL5+gjpg8v+ElQiRA5A2zq2S4Ryp7G/2O7u2J9PWkG4TjYRVkA9aLtvu9g8Pz8jEGwq18Xzf4Pap8mgz2ik/AwMJEinhxgdrRgma3wG/eoRVSsCOt8K//A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JjZMereU4sc2hToEDPJ3PxvEBbA3JZnhuvlr8IiV0lY=;
 b=kFpi+ejp0NFoayOkpYX4yFu1Co1JCiNWK0i9vbnitFUFDYxluCFmZCDJfzO42HmodRivrhCU7VslKRlDGDb0NvIRRX7V53hMei9kmqkXTC7SLyo/EWm8pFML03PVIXeOk0FuXMwQAEXppecp/jpM71N0L3x8hdFCiXfwA7Mz4gY=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by MN0PR12MB6270.namprd12.prod.outlook.com (2603:10b6:208:3c2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 08:53:24 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%9]) with mapi id 15.20.6064.036; Wed, 8 Feb 2023
 08:53:24 +0000
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
Subject: Re: [PATCH v5 net-next 2/8] sfc: add devlink info support for ef100
Thread-Topic: [PATCH v5 net-next 2/8] sfc: add devlink info support for ef100
Thread-Index: AQHZNveRaZV2migBBki/Fbor0TTGVq67jUyAgAgJY4CAAAS0gIAAA0yAgAAlLwCAAO4rAIAAFXkA
Date:   Wed, 8 Feb 2023 08:53:23 +0000
Message-ID: <DM6PR12MB4202100B7C79855A104B810DC1D89@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-3-alejandro.lucero-palau@amd.com>
 <Y9ulUQyScL3xUDKZ@nanopsycho>
 <DM6PR12MB4202DC0B50437D82E28EAAC2C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
 <Y+JnH+ecdTGgYqAf@nanopsycho>
 <DM6PR12MB42026D97627495DC2FF2A346C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
 <DM6PR12MB4202E78CB7CB3BE13817B782C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
 <Y+NQ3tuK6hnDmvah@nanopsycho>
In-Reply-To: <Y+NQ3tuK6hnDmvah@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4185.namprd12.prod.outlook.com
 (15.20.6086.009)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|MN0PR12MB6270:EE_
x-ms-office365-filtering-correlation-id: ce841558-43bd-45f1-e82e-08db09b1efd2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jj7vTkqykvtb8PrT73NMjvDmJN2080ZSU5T7Tyi7ze4saKG/1WYyPs/KAilEW4AZETtW7zKu0i5H8FqcM4L84bUbbwSrxtCwmo4guSQGO+dT6BCTJWitR7/mQMRyOYmuCZKZIm960JHggXskkNn8jvyoNsMehPXbgAtb3bcbzTcZAZZ32DFi2jLpe0Y+tDoedoeBWIYv4V2AKpVl9oTPAryAsrk0Ey+QvtMMBBRJ3qCy7d8y7gVbLco542jqx9RjnAz0hXsbGudS0Ia9uFkKfTSTy0/e6xbcv/r9DZ/djcFPO1luftFkw+PZijR0Ct6Bctp1984T5zLkad361OPdPWg6vrP/LxC/EZhZdQr8LeQDCGrLbJ5A5gdEo7llRkZqZtj0PqkUfECY7JfBkgfh4aB3/LC+1xnB772SDMmzdtVzN1epBFmJO2ao/oWC2uLw7LI5oA5v8dFQoDL7dHor8xEGVYDivQhaDJKm9P4F4rUXZ0TW091Hc84CKOXvAk8IPZnVZvrveSz/ZOsmFJwH4B3nsHVE376evAVcz3XRiyNeeFsbL3YjXq7XNet0T/bCS5b+ns9eL8YbK/MlpbCdygu9f2UsUiflU2F7QANJ0TYU/6Xs3QCtsn8fZqrdWqKZ2CUkNUFzLVZ1JR/RRTphj7nI5MlU8h8AjvTkAzqDoAujAdsU81O+50QYv22N8UsfO1JmhFzKB1fzhGqxqwdAfbEAcANoMbc/fZhu5ujC1ipdmtDpJ7bsQ3G2KI8C7NtR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199018)(122000001)(38100700002)(8936002)(9686003)(6506007)(52536014)(76116006)(41300700001)(186003)(26005)(4326008)(8676002)(64756008)(66556008)(33656002)(66476007)(66446008)(66946007)(38070700005)(55016003)(7416002)(5660300002)(316002)(54906003)(6636002)(478600001)(53546011)(71200400001)(7696005)(2906002)(110136005)(83380400001)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?di9JT0RMb25PUFdEbG1JN0Z2NXR2OGVWYzEyWjZla3FFREFRN2dmNGhzTSti?=
 =?utf-8?B?SzlDVWFENmlleWpacFl3N2tweDZJYWZYUGEvV1B4dGVBNjlkUW9GTzY1M0ta?=
 =?utf-8?B?RUVFbFRpZDNFbHFLK1Y5djM0MGZBM3JVZkdUQVFLYTVoditQMnpWRjd6Q1Bl?=
 =?utf-8?B?REM4UUxpbDUrNzRXUjlzYkhPYW9NYlBWOXQ5UTJMSHdIZnBxUW5iZW9UQmVG?=
 =?utf-8?B?bkRWRzlKd2I2aTdWUEowc3RGWUs5TWg5cENCMDlJcVJJRjdsekF2bFVHUWJR?=
 =?utf-8?B?Y2xINTl2U20xUElsU01NL2d0TkxudDJXNm5OQzI2V2Y4bHdPZ1hzUjRRQzBv?=
 =?utf-8?B?cGdyMFdqcTBqbHEvM3FKUmp2ZHFiR2xFKzZCNUQzcElwcGxWYlR2dlkxd21F?=
 =?utf-8?B?Q2pqNllXN0FDMkdoakhBd0Zzc2NOV2hsVTQ4VW5sWWN4THcwalovVVpwZ04v?=
 =?utf-8?B?Ti9GWUdMVWJPcDFOc2ZQaHpiZzhtenJVbnp2MlpONkc1ZVlBdDBlU2Z2M0RU?=
 =?utf-8?B?UjlNTm5acGprcHpUWklzSnpJUStCUEx6c1ZTM2E2VWIyNmNHbmtZYlA1UjBJ?=
 =?utf-8?B?eXg0enFEU3dKZHVMSmJmYkZkUjBmb1F1QkRVR3BzOEsydEtYOG9ZTVY3di8x?=
 =?utf-8?B?UjlXNmUreDRVOEo5QWdCNG5YZktlOVB0eUJyWEI0ejZnOWE2Wm56RW84eGdh?=
 =?utf-8?B?aHJaaWFORWthSWw2OGt2Zy8vY0oyNmlYTEMvcTA3eUxDY2d0YUJHNUNhV3Ny?=
 =?utf-8?B?NXNiT1c4M3FrWncyaUErZVhlQkZWaDcvRVAyR0ZMM0lxL1lIYXVhb3FCRjZF?=
 =?utf-8?B?TVVMeFBUek9iSmVoRjBiWGF1YXBDYWljNEZ6bXpneTVGSXFTMHYrZEt3c1ZI?=
 =?utf-8?B?TFpLdVJITE1wd3UyaWdLMThkTHZMVEJ2cGZqZXpUcnBiTGNVRVVINzZtOExi?=
 =?utf-8?B?OU96bmg2eTQ0L0I2S2g5NVZqRGEvaGdybU5qdnVvNE51b3BoT3YzeElXWlFv?=
 =?utf-8?B?MFEzSTYvNVc2YnU0ZGpxejU3WFZHK0VyQjJrRy94eUhjUmJsVnBISCtxMzlU?=
 =?utf-8?B?Nm1UVXNaL0l2YXJIREFJRFFkSGJYTGdLT1ROK2NIbkRHc2RVYkMzTXJHZVdt?=
 =?utf-8?B?TzhkVHVTNmVwaHRaMlQ1anBlTWFSQStEa0UzY3VGV1crQnpVcHVrcDJkZFZZ?=
 =?utf-8?B?UDZZSjNSQmkzYXY2c1M2SEIwdndYVE5wZ2JwYWQ5TFJaYTlJUVdsMWloclpZ?=
 =?utf-8?B?ZDhKWFZuckRVc0svWGJvYkdvdmJFZklBS0cwU0FKMjhuZWd2eDU5dE1KUUd0?=
 =?utf-8?B?Wm1CSHZraCtnMXJjcUNiSW03a3lxQ2tLb1dwY3MvV3dDenVsQytvSW1yWXcy?=
 =?utf-8?B?d0NCdW92VCs0L2hpd0ZONDFVdGVkVDhBWG0xWHdjbi9NMzMzMlhFNDlIa1ow?=
 =?utf-8?B?amtBMEM4Y015cEgvQW1zbXhHRlorRDAzbkVzdHBXemVXM3R2QW9IajVBMTAz?=
 =?utf-8?B?UGVWNFRQam9NTHFlblpvVUcyc0FmTXpEMWo5RCt3U1k5N3htWGQ3SnN6R2xJ?=
 =?utf-8?B?NmxjV0VmVUFNcnFlVHk0Zkt0OVREbTQzOVo1MEVTYXFDdk5YOGFiTlJkZDJD?=
 =?utf-8?B?V1l4THpUVGFGVjVQSU1WTlc0YkNlTnVIemNZQkZDSlRvZU5kSjdPNTR3eFI5?=
 =?utf-8?B?U3EvaFlINVVhUktVUndpMnV3bW9aejV0YmJNWnNCODBybHJCTkk1dEdsRWQ4?=
 =?utf-8?B?Q1cwMk92MnFnZksrRHZleS9UajczMkwvMmRiaDFPa2NwL0xyb01oNUpxT21m?=
 =?utf-8?B?QWpMcTE0VnBWSnRhcHpLT3hHSnFPNGZQeE1oTnU3ek5pbWV2K1h6R1NuamtC?=
 =?utf-8?B?SUpqRzk4bURONjRtYktnb1JvUnE1bnlTVkpoZFc1ZThZTUx2UnZQS1RTNUxs?=
 =?utf-8?B?aXRFYjE3RVJjZzhIcWlSREhpdGhLVG9ud2VYZWFXVS90V09OdHg2TlJqV3d0?=
 =?utf-8?B?ZDRvVlQ1eTJ3YTcyV0hMOEhmd2ZEU2Z5MGdlRGxlUktoN01RbFhtYlduZHVt?=
 =?utf-8?B?dXRNRXY3blAyQ0ttK3diR2c1dDV6ZjNmeU5SbVVON0NHRmM0c0JxeEdJWlRz?=
 =?utf-8?Q?Ze/Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CDB3190D2252F943AA877E62AE832A84@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce841558-43bd-45f1-e82e-08db09b1efd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 08:53:23.9870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: upq5kzs98DrNen+wYxmub/e6XEEbAg4udojNGNO2o6Kr/aAPwi7eBzL7JFGgYYLf64Xi595YxqQlqvYgaeWhlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6270
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzgvMjMgMDc6MzUsIEppcmkgUGlya28gd3JvdGU6DQo+IFR1ZSwgRmViIDA3LCAyMDIz
IGF0IDA2OjI0OjA1UE0gQ0VULCBhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20gd3JvdGU6
DQo+PiBPbiAyLzcvMjMgMTU6MTAsIEx1Y2VybyBQYWxhdSwgQWxlamFuZHJvIHdyb3RlOg0KPj4+
IE9uIDIvNy8yMyAxNDo1OCwgSmlyaSBQaXJrbyB3cm90ZToNCj4+Pj4gVHVlLCBGZWIgMDcsIDIw
MjMgYXQgMDM6NDI6NDVQTSBDRVQsIGFsZWphbmRyby5sdWNlcm8tcGFsYXVAYW1kLmNvbSB3cm90
ZToNCj4+Pj4+IE9uIDIvMi8yMyAxMTo1OCwgSmlyaSBQaXJrbyB3cm90ZToNCj4+Pj4+PiBUaHUs
IEZlYiAwMiwgMjAyMyBhdCAxMjoxNDoxN1BNIENFVCwgYWxlamFuZHJvLmx1Y2Vyby1wYWxhdUBh
bWQuY29tIHdyb3RlOg0KPj4+Pj4+PiBGcm9tOiBBbGVqYW5kcm8gTHVjZXJvIDxhbGVqYW5kcm8u
bHVjZXJvLXBhbGF1QGFtZC5jb20+DQo+Pj4+Pj4+DQo+Pj4+Pj4+IFN1cHBvcnQgZm9yIGRldmxp
bmsgaW5mbyBjb21tYW5kLg0KPj4+Pj4+IFlvdSBhcmUgcXVpdGUgYnJpZWYgZm9yIGNvdXBsZSBo
dW5kcmVkIGxpbmUgcGF0Y2guIENhcmUgdG8gc2hlZCBzb21lDQo+Pj4+Pj4gbW9yZSBkZXRhaWxz
IGZvciB0aGUgcmVhZGVyPyBBbHNvLCB1c2UgaW1wZXJhdGl2ZSBtb29kIChhcHBsaWVzIHRvIHRo
ZQ0KPj4+Pj4+IHJlc3Qgb2YgdGhlIHBhdGhlcykNCj4+Pj4+Pg0KPj4+Pj4+IFsuLi5dDQo+Pj4+
Pj4NCj4+Pj4+IE9LLiBJJ2xsIGJlIG1vcmUgdGFsa2F0aXZlIGFuZCBpbXBlcmF0aXZlIGhlcmUu
DQo+Pj4+Pg0KPj4+Pj4+PiArc3RhdGljIGludCBlZnhfZGV2bGlua19pbmZvX2dldChzdHJ1Y3Qg
ZGV2bGluayAqZGV2bGluaywNCj4+Pj4+Pj4gKwkJCQlzdHJ1Y3QgZGV2bGlua19pbmZvX3JlcSAq
cmVxLA0KPj4+Pj4+PiArCQkJCXN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFjaykNCj4+Pj4+
Pj4gK3sNCj4+Pj4+Pj4gKwlzdHJ1Y3QgZWZ4X2RldmxpbmsgKmRldmxpbmtfcHJpdmF0ZSA9IGRl
dmxpbmtfcHJpdihkZXZsaW5rKTsNCj4+Pj4+Pj4gKwlzdHJ1Y3QgZWZ4X25pYyAqZWZ4ID0gZGV2
bGlua19wcml2YXRlLT5lZng7DQo+Pj4+Pj4+ICsJY2hhciBtc2dbTkVUTElOS19NQVhfRk1UTVNH
X0xFTl07DQo+Pj4+Pj4+ICsJaW50IGVycm9yc19yZXBvcnRlZCA9IDA7DQo+Pj4+Pj4+ICsJaW50
IHJjOw0KPj4+Pj4+PiArDQo+Pj4+Pj4+ICsJLyogU2V2ZXJhbCBkaWZmZXJlbnQgTUNESSBjb21t
YW5kcyBhcmUgdXNlZC4gV2UgcmVwb3J0IGZpcnN0IGVycm9yDQo+Pj4+Pj4+ICsJICogdGhyb3Vn
aCBleHRhY2sgYWxvbmcgd2l0aCB0b3RhbCBudW1iZXIgb2YgZXJyb3JzLiBTcGVjaWZpYyBlcnJv
cg0KPj4+Pj4+PiArCSAqIGluZm9ybWF0aW9uIHZpYSBzeXN0ZW0gbWVzc2FnZXMuDQo+Pj4+Pj4+
ICsJICovDQo+Pj4+Pj4+ICsJcmMgPSBlZnhfZGV2bGlua19pbmZvX2JvYXJkX2NmZyhlZngsIHJl
cSk7DQo+Pj4+Pj4+ICsJaWYgKHJjKSB7DQo+Pj4+Pj4+ICsJCXNwcmludGYobXNnLCAiR2V0dGlu
ZyBib2FyZCBpbmZvIGZhaWxlZCIpOw0KPj4+Pj4+PiArCQllcnJvcnNfcmVwb3J0ZWQrKzsNCj4+
Pj4+Pj4gKwl9DQo+Pj4+Pj4+ICsJcmMgPSBlZnhfZGV2bGlua19pbmZvX3N0b3JlZF92ZXJzaW9u
cyhlZngsIHJlcSk7DQo+Pj4+Pj4+ICsJaWYgKHJjKSB7DQo+Pj4+Pj4+ICsJCWlmICghZXJyb3Jz
X3JlcG9ydGVkKQ0KPj4+Pj4+PiArCQkJc3ByaW50Zihtc2csICJHZXR0aW5nIHN0b3JlZCB2ZXJz
aW9ucyBmYWlsZWQiKTsNCj4+Pj4+Pj4gKwkJZXJyb3JzX3JlcG9ydGVkICs9IHJjOw0KPj4+Pj4+
PiArCX0NCj4+Pj4+Pj4gKwlyYyA9IGVmeF9kZXZsaW5rX2luZm9fcnVubmluZ192ZXJzaW9ucyhl
ZngsIHJlcSk7DQo+Pj4+Pj4+ICsJaWYgKHJjKSB7DQo+Pj4+Pj4+ICsJCWlmICghZXJyb3JzX3Jl
cG9ydGVkKQ0KPj4+Pj4+PiArCQkJc3ByaW50Zihtc2csICJHZXR0aW5nIGJvYXJkIGluZm8gZmFp
bGVkIik7DQo+Pj4+Pj4+ICsJCWVycm9yc19yZXBvcnRlZCsrOw0KPj4+Pj4+IFVuZGVyIHdoaWNo
IGNpcmN1bXN0YW5jZXMgYW55IG9mIHRoZSBlcnJvcnMgYWJvdmUgaGFwcGVuPyBJcyBpdCBhIGNv
bW1vbg0KPj4+Pj4+IHRoaW5nPyBPciBpcyBpdCByZXN1bHQgb2Ygc29tZSBmYXRhbCBldmVudD8N
Cj4+Pj4+IFRoZXkgYXJlIG5vdCBjb21tb24gYXQgYWxsLiBJZiBhbnkgb2YgdGhvc2UgaGFwcGVu
LCBpdCBpcyBhIGJhZCBzaWduLA0KPj4+Pj4gYW5kIGl0IGlzIG1vcmUgdGhhbiBsaWtlbHkgdGhl
cmUgYXJlIG1vcmUgdGhhbiBvbmUgYmVjYXVzZSBzb21ldGhpbmcgaXMNCj4+Pj4+IG5vdCB3b3Jr
aW5nIHByb3Blcmx5LiBUaGF0IGlzIHRoZSByZWFzb24gSSBvbmx5IHJlcG9ydCBmaXJzdCBlcnJv
ciBmb3VuZA0KPj4+Pj4gcGx1cyB0aGUgdG90YWwgbnVtYmVyIG9mIGVycm9ycyBkZXRlY3RlZC4N
Cj4+Pj4+DQo+Pj4+Pg0KPj4+Pj4+IFlvdSB0cmVhdCBpdCBsaWtlIGl0IGlzIHF1aXRlIGNvbW1v
biwgd2hpY2ggc2VlbXMgdmVyeSBvZGQgdG8gbWUuDQo+Pj4+Pj4gSWYgdGhleSBhcmUgcmFyZSwg
anVzdCByZXR1cm4gZXJyb3IgcmlnaHQgYXdheSB0byB0aGUgY2FsbGVyLg0KPj4+Pj4gV2VsbCwg
dGhhdCBpcyBkb25lIG5vdy4gQW5kIGFzIEkgc2F5LCBJJ20gbm90IHJlcG9ydGluZyBhbGwgYnV0
IGp1c3QgdGhlDQo+Pj4+PiBmaXJzdCBvbmUsIG1haW5seSBiZWNhdXNlIHRoZSBidWZmZXIgbGlt
aXRhdGlvbiB3aXRoIE5FVExJTktfTUFYX0ZNVE1TR19MRU4uDQo+Pj4+Pg0KPj4+Pj4gSWYgZXJy
b3JzIHRyaWdnZXIsIGEgbW9yZSBjb21wbGV0ZSBpbmZvcm1hdGlvbiB3aWxsIGFwcGVhciBpbiBz
eXN0ZW0NCj4+Pj4+IG1lc3NhZ2VzLCBzbyB0aGF0IGlzIHRoZSByZWFzb24gd2l0aDoNCj4+Pj4+
DQo+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBOTF9TRVRfRVJSX01TR19GTVQo
ZXh0YWNrLA0KPj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAiJXMuICVkIHRvdGFsIGVycm9ycy4gQ2hlY2sgc3lz
dGVtIG1lc3NhZ2VzIiwNCj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbXNnLCBlcnJvcnNfcmVwb3J0ZWQpOw0K
Pj4+Pj4NCj4+Pj4+IEkgZ3Vlc3MgeW91IGFyZSBjb25jZXJuZWQgd2l0aCB0aGUgZXh0YWNrIHJl
cG9ydCBiZWluZyBvdmVyd2hlbG1lZCwgYnV0DQo+Pj4+PiBJIGRvIG5vdCB0aGluayB0aGF0IGlz
IHRoZSBjYXNlLg0KPj4+PiBObywgSSdtIHdvbmRlcmluZyB3aHkgeW91IGp1c3QgZG9uJ3QgcHV0
IGVycm9yIG1lc3NhZ2UgaW50byBleGFjayBhbmQNCj4+Pj4gcmV0dXJuIC1FU09NRUVSUk9SIHJp
Z2h0IGF3YXkuDQo+Pj4gV2VsbCwgSSB0aG91Z2h0IHRoZSBpZGVhIHdhcyB0byBnaXZlIG1vcmUg
aW5mb3JtYXRpb24gdG8gdXNlciBzcGFjZQ0KPj4+IGFib3V0IHRoZSBwcm9ibGVtLg0KPj4+DQo+
Pj4gUHJldmlvdXMgcGF0Y2hzZXRzIHdlcmUgbm90IHJlcG9ydGluZyBhbnkgZXJyb3Igbm9yIGVy
cm9yIGluZm9ybWF0aW9uDQo+Pj4gdGhyb3VnaCBleHRhY2suIE5vdyB3ZSBoYXZlIGJvdGguDQo+
Pg0KPj4gSnVzdCB0cnlpbmcgdG8gbWFrZSBtb3JlIHNlbnNlIG9mIHRoaXMuDQo+Pg0KPj4gQmVj
YXVzZSB0aGF0IGxpbWl0IHdpdGggTkVUTElOS19NQVhfRk1UTVNHX0xFTiwgd2hhdCBJIHRoaW5r
IGlzIGJpZw0KPj4gZW5vdWdoLCBzb21lIGNvbnRyb2wgbmVlZHMgdG8gYmUgdGFrZW4gYWJvdXQg
d2hhdCB0byByZXBvcnQuIEl0IGNvdWxkIGJlDQo+PiBqdXN0IHRvIHdyaXRlIHRoZSBidWZmZXIg
d2l0aCB0aGUgbGFzdCBlcnJvciBhbmQgcmVwb3J0IHRoYXQgbGFzdCBvbmUNCj4gV2FpdC4gTXkg
cG9pbnQgaXM6IGZhaWwgb24gdGhlIGZpcnN0IGVycm9yIHJldHVybmluZyB0aGUgZXJyb3IgdG8N
Cj4gaW5mb19nZXQoKSBjYWxsZXIuIEp1c3QgdGhhdC4gTm8gYWNjdW11bGF0aW9uIG9mIGFueXRo
aW5nLg0KDQoNCk9LLiBJJ2xsIGRvIGp1c3QgdGhhdCBpbiB2Ni4NCg0KVGhhbmtzDQoNCg0KPg0K
Pj4gb25seSwgd2l0aCBubyBuZWVkIG9mIGtlZXBpbmcgdG90YWwgZXJyb3JzIGNvdW50LiBCdXQg
SSBmZWx0IG9uY2Ugd2UNCj4+IGhhbmRsZSBhbnkgZXJyb3IsIHJlcG9ydGluZyB0aGF0IGV4dHJh
IGluZm8gYWJvdXQgdGhlIHRvdGFsIGVycm9ycw0KPj4gZGV0ZWN0ZWQgc2hvdWxkIG5vdCBiZSBh
IHByb2JsZW0gYXQgYWxsLCBldmVuIGlmIGl0IGlzIGFuIHVubGlrZWx5DQo+PiBzaXR1YXRpb24u
DQo+Pg0KPj4gQlRXLCBJIHNhaWQgd2Ugd2VyZSByZXBvcnRpbmcgYm90aCwgdGhlIGVycm9yIGFu
ZCB0aGUgZXh0YWNrIGVycm9yDQo+PiBtZXNzYWdlLCBidXQgSSd2ZSByZWFsaXplZCB0aGUgZnVu
Y3Rpb24gd2FzIG5vdCByZXR1cm5pbmcgYW55IGVycm9yIGJ1dA0KPj4gYWx3YXlzIDAsIHNvIEkn
bGwgZml4IHRoYXQuDQo+Pg0KPj4NCj4+Pj4+Pj4gKwl9DQo+Pj4+Pj4+ICsNCj4+Pj4+Pj4gKwlp
ZiAoZXJyb3JzX3JlcG9ydGVkKQ0KPj4+Pj4+PiArCQlOTF9TRVRfRVJSX01TR19GTVQoZXh0YWNr
LA0KPj4+Pj4+PiArCQkJCSAgICIlcy4gJWQgdG90YWwgZXJyb3JzLiBDaGVjayBzeXN0ZW0gbWVz
c2FnZXMiLA0KPj4+Pj4+PiArCQkJCSAgIG1zZywgZXJyb3JzX3JlcG9ydGVkKTsNCj4+Pj4+Pj4g
KwlyZXR1cm4gMDsNCj4+Pj4+Pj4gK30NCj4+Pj4+Pj4gKw0KPj4+Pj4+PiBzdGF0aWMgY29uc3Qg
c3RydWN0IGRldmxpbmtfb3BzIHNmY19kZXZsaW5rX29wcyA9IHsNCj4+Pj4+Pj4gKwkuaW5mb19n
ZXQJCQk9IGVmeF9kZXZsaW5rX2luZm9fZ2V0LA0KPj4+Pj4+PiB9Ow0KPj4+Pj4+IFsuLi5dDQo=
