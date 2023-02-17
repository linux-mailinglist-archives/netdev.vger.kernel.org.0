Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D97769B2EB
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 20:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjBQTRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 14:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBQTR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 14:17:29 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA49734331;
        Fri, 17 Feb 2023 11:17:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mociGUUHFhk1G3Mqjix2zaRfvBUZJ8Snvl+O2o1qKJXmwG9iQ78KyySrPcBD0lgWkNsoryxb6J4angzULkS8coTVSDWcyIDeiLTbjiEpiNU8SvuPva5AxrZ4uEiQk9O4FD84y00noG1pw5a6vgqh72D04duKp2Vs/X5j8mCEcTaXJ979t+IIz2Inz4yNWuUCimOKvNtyth0d1nz7ziJaSAu3kGvB+/ipAgGuJMY78cSCIH2aqE4eyK2digVeOqbsQ1xAvJ/Vy+k/UiLG7y1A5nFnFQs5B2tzWwE0ymmSnmtrg0GsxC7A1dqEvRxEUYfrEoBCuMPiY8RsXnlVLrLfnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ilGGvN07rpkto2CassDdpfHiyhfYIppMDLRwJOGuvJY=;
 b=YHIvBih+stCyNUHB3nBlXvOJlkV7Dc2lq1dteXN67SNMXaBL0xVnjgpRzGvtwKbNwdWCU9r/lTGdDQoP5wyt71BjPIRFVrt3E68nmf0EbK03mZcY31QlY5oVPYqqnR1hAuI+bqbr2wMWSpsedTdF4bdPF/x2CNmVRBjc8TMnbpIDOb3o1nxvqo/QuqqhpcvFVDgkitETCbvVcPgoKSelhK24XXIZJKUAsu5Fno9hxNiw+YkHOOC9+VJfiYMGvVk2VQMHThiPhZRXMhuoSz2xDVzh4l5MVeJonbCesBzV+4frS/C6grajJu+rwTPtK+8lum4RTjtlFIDbI4lz5+FRAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilGGvN07rpkto2CassDdpfHiyhfYIppMDLRwJOGuvJY=;
 b=wm3Xr5ZXocjUS13gVkp0ISKP2Jy66/gvWLDOtDJ98iixuZc9yh/PaZmzWzW7wM+QdCDfvhXayNHLZelUBBmzfU6+mJEtX4JjTp8lVG2sPI67bv1ERiyuaP601ZVVAhAsDhIVpCyeoWjCLQJzbuJEUd9a7D84Hsc32DxpQoa/Ls8=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by PH7PR12MB7939.namprd12.prod.outlook.com (2603:10b6:510:278::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15; Fri, 17 Feb
 2023 19:17:22 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%7]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 19:17:22 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v2 net-next] sfc: fix ia64 builds without CONFIG_RTC_LIB
Thread-Topic: [PATCH v2 net-next] sfc: fix ia64 builds without CONFIG_RTC_LIB
Thread-Index: AQHZQvHb1c7AWuw7gkquvoq3/jufb67TaZYAgAAZSoA=
Date:   Fri, 17 Feb 2023 19:17:22 +0000
Message-ID: <DM6PR12MB42024E4DBA186238DE7ABE2EC1A19@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230217170348.7402-1-alejandro.lucero-palau@amd.com>
 <60366cf007060025725a18a77f58c41ee7e3158b.camel@redhat.com>
In-Reply-To: <60366cf007060025725a18a77f58c41ee7e3158b.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4843.namprd12.prod.outlook.com
 (15.20.6086.011)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|PH7PR12MB7939:EE_
x-ms-office365-filtering-correlation-id: fe894248-8075-4ff2-6253-08db111b985a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RMaHUBiTyej5gspWW7yQpObpicBM1L6rbBC4QqqpvW3GhV0q0kB0cwSKqobf3P4tf9C0DXqUDfC5lpQBjrtPvtQnQUGfFBsu/0YPbHcurRGCaWhuNiDGoSxsCao97NA/J10gtjYOFaeNE+u0J2KJmMeefytgBn4LHmMZu6TNZukzc6+aoe2pNeE/hDvsqsGiINA0Bg66MDzrwp4w4b9qqGIJBrfDtXIJBcN4uZDzurMUg7+UGt9WN2gyh3S59h8T3a0kt+QIT2kelpNJj/ajdx8KeAJfsAzBr2WH1VWn37UET0hG0dKSmg/G7dD70ZggKjx6qjQ5yEUm5BH8b3WMrrJy6wFS5MMrorvwuVgWkI3FFcLmsrfVP+SF1Rv4eJJ1qJ8fkhR799dXyHc6r2MObkfQEKrQcnJn04KZDv5nsuIC8IRuFqKUwGw7W5YXcm3FY7xhFEk7riPVczztVLaxov1SdT400ZEy8ulPo4TSC+uXVQD8ssCgspAvUidyjb5TmwRG8cgSn4Izpl56Jrmfx7ackgRk7K6Iop0pRlSKN1rHTbeR1ozikHH+mXlTpVQYwkORH3KmLZf1t1KM8pO7iJ3Zr948PeXCYplGp0mSRcZNsKGqRuAjqfre4rDPG950xOJTvpfOamr3CTHKf4VZcstdzAfKGqzvDJm5kyQcMlkwQgUvoo5OSJdqEMILJSO2HBB0TIX8xMamzb9BV7v4lTk6bTcoPnofX0TXviu6+v07XZCfTINrcuBENr5+u4eI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199018)(66446008)(33656002)(55016003)(8936002)(76116006)(66476007)(8676002)(2906002)(66946007)(52536014)(66556008)(64756008)(5660300002)(7416002)(4326008)(38100700002)(38070700005)(122000001)(7696005)(6506007)(478600001)(966005)(54906003)(6636002)(316002)(71200400001)(110136005)(41300700001)(83380400001)(26005)(9686003)(186003)(53546011)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dU1DK1JReEhYODRNeTlwc0hjaEJOM0J5bmlhZ3FSSVN3bjFMc2JhNG85dVJm?=
 =?utf-8?B?RzdCRjBwV0JwK2ZFV3p0alhEeWt1dVFEOGE4bThMTnhUTDk0cEY1TWh4Z2N4?=
 =?utf-8?B?NTI5K3E4TVZQK3Budm9ZZWFTLzhMaitsdis0OVY0bWI5WnQva1VWVkd1ZEpX?=
 =?utf-8?B?ZnltZ1h2WmFMMjl3MjZHamVVazlwRUV3SVAvR3VwWU1vc0RpWTI3dFZ6bEFC?=
 =?utf-8?B?ODJiRWxqNlJRZXZ3cWNIeWVFczlnOTVPNlN1czF1L3RBN1ZzUmhLQlFmcURt?=
 =?utf-8?B?b3d3d0dJdHprSVlSUFZyVHphMEJNUkp4elVzUlVBeGl0YU1sNHRnZVhIQ2h1?=
 =?utf-8?B?eFQ5ekZNUitJa0dZa1VJUkVmMUNqbkUyTFE1Qm5NbG9jOGhkMzltN2UxdWto?=
 =?utf-8?B?NHlXU2V0dXhUUS92WHg2TmhIdHoyYS9mVGhhWGxDNnViUDYvRDhyNW9ybThC?=
 =?utf-8?B?WnlVWUU2SHhtYjE3RFFwQnA0a25rRTU2Y3ZkVlBzeC9hbFRuSG9zYXZTU0RQ?=
 =?utf-8?B?V21QVDhiOCs4akJDUVo1TVVZQWtHQjJGNitLb0FyUWlqQWxXK2wvR0VVcHRP?=
 =?utf-8?B?SW5SWnd1Q1RDSThjS0EveEVKdU1EeUpORG5EUGdxN2ZEajNGSGFKUGJQRnZ6?=
 =?utf-8?B?UDlSMlJHZVFTNTRJRWZQeFpCckVjQkJoQncxZ2hiSklNZ1FWd3kyT2t4QVB6?=
 =?utf-8?B?ZmJMYlBscmVIdEw0Tm5kVXJJNkk0YVA2aHZORzZJYTN3OWg0WCtaVTlzZjEz?=
 =?utf-8?B?SFZ4TC8xZG9nVFI5SkEwUXdEallZMTBRV1dKYXdpR1hCZ2Y4MUkxMW1jWnlS?=
 =?utf-8?B?V25NNFdIZUY3R2VFbzc5LytPazNQcmJTciswUzVLUEVVMTl5RlRsOExSRUFM?=
 =?utf-8?B?dmZsL3F5emNUSy9qdzhucnlHZmYvUkVtdUtaVXloUEhkZ3dRUm9ZUDJicTdr?=
 =?utf-8?B?Z2FuSWFuOEZZRGROMkcxb2VQWDd2Uis1MVdoRWxIU1NuY0tmVUZiWi83RzRu?=
 =?utf-8?B?MUM2QXJ5cnp0aWRiM2p1bldUTGRIK2dBMFdlbURsTUFKcGZPenYwbUlTTnFj?=
 =?utf-8?B?MkxYTnpZVjNwdzE0UnFnYnBvS2VKeXF4VEtDQi91aSs5VFVHZGpkMy9pU01U?=
 =?utf-8?B?RlVqczFBS2pJQzg4TnhqWERHZGR2YlpSTGlocERTcnZhM0VDZ3NlQ1hSNUVL?=
 =?utf-8?B?RnBPanRZSzlQWmVwbzJyTW1JVjZzSzMxVW9XSUVnekcxazRnaTN3ZEFhb2Ru?=
 =?utf-8?B?dTZHdnkwQzc0WHdtYk9EUlZSaGkwVmUzZlVhNTU1V2JPSEZLQ2N2L04yVGc5?=
 =?utf-8?B?RjlZSzZpZGJZd2FXUEVRcVVOR0NNNTRSaFEvRzdUSElFY3NuK1dCMmxsU1Rn?=
 =?utf-8?B?T2JhQ1gzSFBLNEJIZTdiWTd4cDNQMitQM1FreUh3RituWjJySG5KeU1OTXNP?=
 =?utf-8?B?R056V1ZOMEFJcVNPb24rcjQ5b1NYd1Q1OWEwWitwNmVuWU9CMUh5UThSV1Jp?=
 =?utf-8?B?NHljM1VFR01xWnVDVlNkQmsybjJwMkw2N3IxM2pzN05MUERyaGMzU09kdng4?=
 =?utf-8?B?WkNEcER2KzNpTzlaRjhKTzB0RzcyR1QzOU0vOEdoWDV2dUhQVTlmL24yOFBW?=
 =?utf-8?B?NXNNSENsT1NGK0VyWmlCRjBHT0VXaXhMYVU3NXh5RGRYM0I4R2ROWnJnUDcz?=
 =?utf-8?B?b2loSUcraHVNOFZQbGhqTU9ZT0VaTEJ1WDdlSXFvcXBXQ2luYWMyVndDVUpX?=
 =?utf-8?B?L0dPQ01WMVU4MG9tNG9TM3FEc00xcTNobVphMDNwVUpUa1Zzd25vWW9FelBB?=
 =?utf-8?B?TGFycHVaby9iYSt5RTF0QUJyai9DQXdQSWN5T1puc1ZuUjV0blVhNE9lak56?=
 =?utf-8?B?S1oyc1lZdDR2cUNWc3EzQkZuUkpaTEllMUppVytacW00UWdCSlZIN1ZaMEl1?=
 =?utf-8?B?eVhmb3dwaXprL0hBTEt3bTQ2YkgyNHoxRHRiL2pqaEw5bXl1RkxocEN4TytV?=
 =?utf-8?B?Z1BkV2ppeFRPWnpsTkhmM1J0UEFmMm1ack9BWHJUSEMrZzEydHJYNDFRMXVP?=
 =?utf-8?B?TURtcktqazVqRUJIQjdja3phdWdFYzg5UE81VlV6WnQva2FTU3ovamcvdnd6?=
 =?utf-8?Q?JHD8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7763BA4A31C7340B24A3124502FBA17@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe894248-8075-4ff2-6253-08db111b985a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 19:17:22.0437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wn/2UXkLstprihWSCOrV1R+DNqIq9KQ4eD7gtS0rnHaunPb3zsyNSvgYQbJeTw3Hx0Q9fWeSZd8q4pkJ5vNXzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7939
X-Spam-Status: No, score=1.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzE3LzIzIDE3OjQ2LCBQYW9sbyBBYmVuaSB3cm90ZToNCj4gT24gRnJpLCAyMDIzLTAy
LTE3IGF0IDE3OjAzICswMDAwLCBhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20NCj4gd3Jv
dGU6DQo+PiBGcm9tOiBBbGVqYW5kcm8gTHVjZXJvIDxhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFt
ZC5jb20+DQo+Pg0KPj4gQWRkIGFuIGVtYmFycmFzaW5nbHkgbWlzc2VkIHNlbWljb2xvbiBicmVh
a2luZyBrZXJuZWwgYnVpbGRpbmcNCj4+IGluIGlhNjQgY29uZmlncy4NCj4+DQo+PiBSZXBvcnRl
ZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+PiBMaW5rOiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9vZS1rYnVpbGQtYWxsLzIwMjMwMjE3MDA0Ny5FakNQaXp1My1sa3BA
aW50ZWwuY29tLw0KPj4gRml4ZXM6IDE0NzQzZGRkMjQ5NSAoInNmYzogYWRkIGRldmxpbmsgaW5m
byBzdXBwb3J0IGZvciBlZjEwMCIpDQo+PiBTaWduZWQtb2ZmLWJ5OiBBbGVqYW5kcm8gTHVjZXJv
IDxhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20+DQo+PiAtLS0NCj4+ICAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvc2ZjL2VmeF9kZXZsaW5rLmMgfCAyICstDQo+PiAgIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2RldmxpbmsuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3NmYy9lZnhfZGV2bGluay5jDQo+PiBpbmRleCBkMmViNjcxMmJhMzUuLjNlYjM1NWZkNDI4MiAx
MDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZnhfZGV2bGluay5jDQo+
PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2RldmxpbmsuYw0KPj4gQEAgLTMy
Myw3ICszMjMsNyBAQCBzdGF0aWMgdm9pZCBlZnhfZGV2bGlua19pbmZvX3J1bm5pbmdfdjIoc3Ry
dWN0IGVmeF9uaWMgKmVmeCwNCj4+ICAgCQkJCSAgICBHRVRfVkVSU0lPTl9WMl9PVVRfU1VDRldf
QlVJTERfREFURSk7DQo+PiAgIAkJcnRjX3RpbWU2NF90b190bSh0c3RhbXAsICZidWlsZF9kYXRl
KTsNCj4+ICAgI2Vsc2UNCj4+IC0JCW1lbXNldCgmYnVpbGRfZGF0ZSwgMCwgc2l6ZW9mKGJ1aWxk
X2RhdGUpDQo+PiArCQltZW1zZXQoJmJ1aWxkX2RhdGUsIDAsIHNpemVvZihidWlsZF9kYXRlKTsN
Cj4gWW91IG1pc3NlZCB0aGUgZmVlZGJhY2sgb24gcHJldmlvdXMgdmVyc2lvbiBmcm9tIE1hbmFu
ayByZXBvcnRpbmcgeW91DQo+IHNob3VsZCBhbHNvIGFkZCBhIGZpbmFsICcpJyBhYm92ZS4gU2hv
dWxkIGJlOg0KPg0KPiArCQltZW1zZXQoJmJ1aWxkX2RhdGUsIDAsIHNpemVvZihidWlsZF9kYXRl
KSk7DQo+DQo+IFBsZWFzZSB0cnkgdG8gYnVpbGQgdGVzdCB0aGUgbmV4dCB2ZXJzaW9uIGJlZm9y
ZSBzdWJtaXR0aW5nIGl0LCB0aGFua3MhDQoNCkkgdGhvdWdodCBJIGRpZCBzbywgYnV0IG9idmlv
dXNseSB3cm9uZ2x5LiBUaGUgc2hvcnRjdXQgZm9yIGNvbmZpZ3VyaW5nIA0KdGhlIGtlcm5lbCB3
aXRob3V0IENPTkZJR19SVENfTElDIGRpZCBub3Qgd29yayBidXQgSSBkaWQgbm90IG5vdGljZS4N
Cg0KSXQgd2lsbCBub3QgaGFwcGVuIGFnYWluLg0KDQpUaGFua3MNCg0KPiBQYW9sbw0KPg0K
