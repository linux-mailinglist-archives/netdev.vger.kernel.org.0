Return-Path: <netdev+bounces-3533-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DAC0707C5C
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:51:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 434161C20D97
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 08:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA27AD3C;
	Thu, 18 May 2023 08:51:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99BC2A9E2
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 08:51:17 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A128C199F;
	Thu, 18 May 2023 01:51:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LjxzljbS9syF1yy0FRDAgz5wS2KzUgK039xTeDJ6b5KZA66Mjfoybgvkkqwo1iK0PQE5cH+uZb7WbUY3F4/3blgtbvzxOMQcLRvk8D/GhzutVe1W2dJpdtK17hjDSZiArOVezXTneU+wx20Ji1ouMgSQs35xOrcjSJ+5s2uFNH1j9KFom2okrzkzr/y9BFf6c23YstyrAVOFDsz86HSFsQhB/vFpT6Cap428of/VcTq9fMimQRocKQH5FlFqyINmwEhqv7ejr88Nj9YDEwj4Nqn29LT86fpp3tFa7y+kjYTuRNNv5dblnmLvru8hWPYPJzqt92LWYfo9EG4HNwlHXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/oUNg29OTPM8EXNlejaHCFD94AfgekG6QdDA5ZNo6Ss=;
 b=i4lniio0TT1GoQ/fw1u65Z3LkkoTHkuNBomn7O3aoGZIhB3PQXhFoD4jhCBFpHeCspOcU7ulmtu2/+GKm5XMTvdEFmBm0mdSWOJj+o8J5QDn9YhM8XIFxSelBsfnKECE/n/0YbT4b40QCAQC+mrkh/jFMZkLxc2MN3IU8oyQ/OuL1Sz7ItHltKZuJODbAFVW/nEZTkkpQKJ+YXePATUJs3c7abf77/lpdrHaTt3qP+iD1UgcQvD1XJzXK2KGN6+Oru+9gL1aQYMCutsQ5lfOOQTLyCS9OnWijNreFV2wpQIVqAyldEQY1fI8iZpo/7gSq/jrEgL/D+5OhX/EHUs+6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/oUNg29OTPM8EXNlejaHCFD94AfgekG6QdDA5ZNo6Ss=;
 b=3ONp6kjRTBFzTsA99wjGIe8LTT/y/JI5SPOHZpDw9sCAcTerwgfbN93lUTcTrWJ3BtDV12e/AsrSaQKWtQ7NnQUFrfHxgm8FMReKS0clIH7jtaA71uwYmR5+DTMRT+TN5bFolmNbkC1yAtBXCe1ErAEOGnjG51EVn6yy1qOoa/w=
Received: from MW5PR12MB5598.namprd12.prod.outlook.com (2603:10b6:303:193::11)
 by MN0PR12MB5762.namprd12.prod.outlook.com (2603:10b6:208:375::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Thu, 18 May
 2023 08:51:11 +0000
Received: from MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::8a8d:1887:c17e:4e0c]) by MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::8a8d:1887:c17e:4e0c%6]) with mapi id 15.20.6411.017; Thu, 18 May 2023
 08:51:10 +0000
From: "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "robh+dt@kernel.org"
	<robh+dt@kernel.org>, "krzysztof.kozlowski+dt@linaro.org"
	<krzysztof.kozlowski+dt@linaro.org>
CC: "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "Simek, Michal"
	<michal.simek@amd.com>, "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Sarangi, Anirudha"
	<anirudha.sarangi@amd.com>, "Katakam, Harini" <harini.katakam@amd.com>, "git
 (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH net-next V3 1/3] dt-bindings: net: xilinx_axienet:
 Introduce dmaengine binding support
Thread-Topic: [PATCH net-next V3 1/3] dt-bindings: net: xilinx_axienet:
 Introduce dmaengine binding support
Thread-Index:
 AQHZgxyMhcxz4C0Hi06uaEd1rO/7na9TSJIAgAGnKOCAAT+aAIAIK2FAgAA8X4CAASz1sA==
Date: Thu, 18 May 2023 08:51:10 +0000
Message-ID:
 <MW5PR12MB559898F664A46944FD5CFC9B877F9@MW5PR12MB5598.namprd12.prod.outlook.com>
References: <20230510085031.1116327-1-sarath.babu.naidu.gaddam@amd.com>
 <20230510085031.1116327-2-sarath.babu.naidu.gaddam@amd.com>
 <95f61847-2ec3-a4e0-d277-5d68836f66cf@linaro.org>
 <MW5PR12MB55986A4865DB56F7F024EA7687749@MW5PR12MB5598.namprd12.prod.outlook.com>
 <fe2989c2-2d90-286f-0492-2b07720afcf9@linaro.org>
 <MW5PR12MB55983A529A1F57A39C7A61B7877E9@MW5PR12MB5598.namprd12.prod.outlook.com>
 <d8af7985-49d7-021c-a51e-271d7b731971@linaro.org>
In-Reply-To: <d8af7985-49d7-021c-a51e-271d7b731971@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR12MB5598:EE_|MN0PR12MB5762:EE_
x-ms-office365-filtering-correlation-id: 024bdb38-9f51-477b-850c-08db577d0748
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 5NI/NcsbU27sRPS/zpgiAwlHwFVvz/6HOH/M68C4T5xETwn/Y+wU9FN3BIBYdpmTi6hKzh7nKhisJkugb55Om7HtugyINpWrW+SxVQU90xFP+qDvRmE91IvvWPmuzalnOJYdn7W+Pf6TDQZbdRncHvPL3M3TrggRQE1A4kpohJGV3VBXsgkaGMzhkNOnMkV/TpMuNgCTgnBpwszwhw05plBBgfbpcFy6KsC3+JoW/O0h9ts8xRV17nvX6lPx9hxBa5sXq/0q050pZy4MweRBuFtL1GqZsbTcExw4K2d1/ULNCApw7eE9FST+nfpVvA2QWSgcfaZIecLqDGV5zWj6ZlkxdE3/kslzJWEYVkMMYdxQmwBtXuwN8hvbGTwCPQhj3pJ5ON4vZtJxlbJgruWRKhaYJZgvak3qNQYUtWbnodUo11G0zViHnuMZFf6171cOji7/QoFucwOKvLVBcBk5Acy6BeXZlIhZLBaZvrCKBCVWbHqvdJnTYNijMjfbO/XoAxMFJxEWj4DeYHleaPpybrKMzNpMzt26gk7JtbHUQjl5fvqaPc+4AbABAiyuftafp3o9t59kFyYh/03d/6B9IGjkxi+6K1tCNmQTqU03F3XqsmezfeSeJglheam2LZQb
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR12MB5598.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(451199021)(66446008)(66556008)(66946007)(76116006)(66476007)(478600001)(64756008)(4326008)(54906003)(316002)(110136005)(86362001)(33656002)(38070700005)(7696005)(83380400001)(9686003)(53546011)(6506007)(26005)(186003)(52536014)(5660300002)(2906002)(8936002)(7416002)(71200400001)(8676002)(55016003)(41300700001)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ckNKZGRZS3ZTb1VMK1pwUVdQVnE5d1UvbzQ4MUZwTyt6WHJrZFY3QzdWcW8y?=
 =?utf-8?B?K0RqRTR2WmlPVk16QVM1VE1MWWNxMEtYTW9nWDhobFZ6KzUxUFV0ekovd1Vw?=
 =?utf-8?B?QkU2d3B2SlJ5aTQxWG9BdmhMNnFTekZDcmI1ZDNMWHpvbm9vdFFnQVA5bzY2?=
 =?utf-8?B?cDhKZ090Z1FyQWNqSVBOSVlnNUd4QTFnMHFvVE9qZHBpbkVKOEs0Wlc1RWpv?=
 =?utf-8?B?WlpNWDRRWllnMVc2bElPUmdIRm5QUmJjMytORStlbVE4Rnh4OVMxUVd1VEly?=
 =?utf-8?B?OFBKU0d0MDlvOHd4R1NBcmphbVluWjhhcUt2SmU2MTh2MWdvSjJ1bU80aUJZ?=
 =?utf-8?B?dUt1OXVvWm82aVA1TmRES1FjWnpBMGkxMDlEVGVkKzFScU5UL1F5WGdTUnpJ?=
 =?utf-8?B?QkdZUDhaQVVpUFZVZGMwVWFSTFhQam9aVmtZNTdZd2w2WFJ0V3IwSzB4WEI1?=
 =?utf-8?B?cmdFMWZDb0xNLzU2Q1lLcDk0aEJGbTVRSUZ3K0htN25HK2xtc0ZHVDc3bWZq?=
 =?utf-8?B?dmlwdFRsNDBIY0VxZ2N0WlFSb3FkbHBLdmsvUThtbndXM1NWZ1BpbUxCUFNC?=
 =?utf-8?B?dUlnWDdJTWxYbEZGWVJKanVITlVJVUVPNHFkdUdQTEhMcXZlbUtOQW5XV3hu?=
 =?utf-8?B?TFR0b0daaU4xZ2ZQdjlaU1prVE1HWTcydWtwUjFSYVhub0hWZ040SlNTUlJZ?=
 =?utf-8?B?ZnZJTFpudDR0UkNEaHlDSFE1bEhKeDlacHhYV2swakN2RFlnMC9hMjlLejc4?=
 =?utf-8?B?ZnQ5RVNlR214eGdkc1llYmRMVFo2VlJYZUJwTGlWenQrbUpsdmpiVE9TRUd5?=
 =?utf-8?B?Ty92ZVRqd243Tk1uQVU4ZjJicmh3NEQ4azB1U3FlalZTTTExQVlYMDU2bHlQ?=
 =?utf-8?B?WFBaWTMrVmJkUlBYNUI3MVFIVEF0WUdSUXVRMGR2czBTbkNxWWFTSWMzaTBJ?=
 =?utf-8?B?bitGblh2NEh4OTFzZG9LYlZ4SFFBRGNYNXBnWkNDSVJaU1BWSjRsK3JMR0RR?=
 =?utf-8?B?eWp6RnZqYTFpWkJBeFY2bkZuS0JmL2VvZE5vcXRlWlNjYkRUbWc5ZkRzNkNW?=
 =?utf-8?B?ZVFlWHFMc1RwMFpxZjdWZGoyT1lxaGx6WHRuNWxCYjFqWk1vaXpSZ2R0WWZz?=
 =?utf-8?B?UmYyaHFQcncxTVpRcjAyLzllS1FoNzFvZmpJTXYxTWFvVEJWb3lHSFZXRDVV?=
 =?utf-8?B?UFpZcmcyVExIZUpzR2lwUHBCT1o0TFhrZmkvRDJVTHdtaWd3U2xOU2t1L2Zu?=
 =?utf-8?B?SzUybFVQMHJjZzlwLy9hZDVwTC9mOEJ5aEJFdTdPcjZnQTBzZXd6RDdyY1g5?=
 =?utf-8?B?K3BhSGhydUlTdW5hYk1kRmNlUk1MdjFKODdiWEVlWldRbVAvZUZnOWxsY1ha?=
 =?utf-8?B?L2gxa0UySTVpdFppbldFVTZraHlndjV4SXpJMlkvNCtybUI1am5zV1ZaQ09G?=
 =?utf-8?B?a3Y0UVZOVzJKbnpTbHpURC90dDdmMEFac3VBWlFHSHM1SUdGdVZNV1N5Q2Vl?=
 =?utf-8?B?dzIrRTM5MGphdVB5RWR4SHB4bWhyR3Ayc3hRTzBVak4vM29oWWptUHNPNkNk?=
 =?utf-8?B?dzJUYXdlUEVQTWlucWpuQnQyVllnQWF0VUVhaW81ajRnakUyUm9icHZVenhB?=
 =?utf-8?B?eVBPeWsyaFpFOGJrc0pySW9JWGxYTXFJQVNRTmRsck5SODh5ZmtxTU8zbk1Y?=
 =?utf-8?B?L1RCdmd5UXVObFN2UjlZaEM2eE5wNnRxZndSQy9iaU9ubjU3dlJHcFZzamEy?=
 =?utf-8?B?dlJGaFhERGZlSjVqZ1RybmFDSjFQYW5BRDhxTFFuSE1IdTEvSjVBZVdqSzY2?=
 =?utf-8?B?NDZhNjdkNXVjdGJRSmVRd085U0JUWVZBcE5MZjRTbUVqM0RHR2lNTkowYWlu?=
 =?utf-8?B?Z3JwNE1RckFjRndLYjNadUFCZzNrSWozVFpIWkNnbDlDSEQ3TElQN2N2ci9S?=
 =?utf-8?B?V3B4TkxBSkpid1FsQ3p2c2FDd3pVaFkxZTNIbDBsa2owMFlxNkFnc2Fib3lo?=
 =?utf-8?B?ZEN0QXZwcERCemVQUE50bThyekNjNllzTUNBWEhwaXJQNXhRQzFJZDNJTEp2?=
 =?utf-8?B?REYvc2VwYnBvVVpXMklJSjVGM0tGTS84eFJtVFZHT0dkQ21MbVlKcHo0cCtG?=
 =?utf-8?Q?nTe8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR12MB5598.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 024bdb38-9f51-477b-850c-08db577d0748
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2023 08:51:10.7771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YnAFmjOq1mAlFYmvDr8M7iZIZ67wgudiAFCzTOEYFxkTlUGNubmPOHgu7p68InrFIy6EHO+PL/+xpL2/aOB0zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5762
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTZW50OiBXZWRuZXNkYXks
IE1heSAxNywgMjAyMyA4OjE5IFBNDQo+IFRvOiBHYWRkYW0sIFNhcmF0aCBCYWJ1IE5haWR1DQo+
IDxzYXJhdGguYmFidS5uYWlkdS5nYWRkYW1AYW1kLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7
DQo+IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5j
b207DQo+IHJvYmgrZHRAa2VybmVsLm9yZzsga3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8u
b3JnDQo+IENjOiBsaW51eEBhcm1saW51eC5vcmcudWs7IFNpbWVrLCBNaWNoYWwgPG1pY2hhbC5z
aW1la0BhbWQuY29tPjsNCj4gUGFuZGV5LCBSYWRoZXkgU2h5YW0gPHJhZGhleS5zaHlhbS5wYW5k
ZXlAYW1kLmNvbT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC1hcm0tDQo+IGtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBTYXJhbmdpLA0KPiBBbmlydWRoYSA8YW5pcnVkaGEu
c2FyYW5naUBhbWQuY29tPjsgS2F0YWthbSwgSGFyaW5pDQo+IDxoYXJpbmkua2F0YWthbUBhbWQu
Y29tPjsgZ2l0IChBTUQtWGlsaW54KSA8Z2l0QGFtZC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggbmV0LW5leHQgVjMgMS8zXSBkdC1iaW5kaW5nczogbmV0OiB4aWxpbnhfYXhpZW5ldDoNCj4g
SW50cm9kdWNlIGRtYWVuZ2luZSBiaW5kaW5nIHN1cHBvcnQNCj4gDQo+IE9uIDE3LzA1LzIwMjMg
MTQ6MDYsIEdhZGRhbSwgU2FyYXRoIEJhYnUgTmFpZHUgd3JvdGU6DQo+ID4+Pj4+ICsgIGRtYS1u
YW1lczoNCj4gPj4+Pj4gKyAgICBpdGVtczoNCj4gPj4+Pj4gKyAgICAgIC0gY29uc3Q6IHR4X2No
YW4wDQo+ID4+Pj4NCj4gPj4+PiB0eA0KPiA+Pj4+DQo+ID4+Pj4+ICsgICAgICAtIGNvbnN0OiBy
eF9jaGFuMA0KPiA+Pj4+DQo+ID4+Pj4gcngNCj4gPj4+DQo+ID4+PiBXZSB3YW50IHRvIHN1cHBv
cnQgbW9yZSBjaGFubmVscyBpbiB0aGUgZnV0dXJlLCBjdXJyZW50bHkgd2UNCj4gc3VwcG9ydA0K
PiA+Pj4gQVhJIERNQSB3aGljaCBoYXMgb25seSBvbmUgdHggYW5kIHJ4IGNoYW5uZWwuIEluIGZ1
dHVyZSB3ZSB3YW50IHRvDQo+ID4+PiBleHRlbmQgc3VwcG9ydCBmb3IgbXVsdGljaGFubmVsIERN
QSAoTUNETUEpIHdoaWNoIGhhcyAxNiBUWCBhbmQNCj4gPj4+IDE2IFJYIGNoYW5uZWxzLiBUbyB1
bmlxdWVseSBpZGVudGlmeSBlYWNoIGNoYW5uZWwsIHdlIGFyZSB1c2luZyBjaGFuDQo+ID4+PiBz
dWZmaXguIERlcGVuZGluZyBvbiB0aGUgdXNlY2FzZSBBWEkgZXRoZXJuZXQgZHJpdmVyIGNhbiBy
ZXF1ZXN0IGFueQ0KPiA+Pj4gY29tYmluYXRpb24gb2YgbXVsdGljaGFubmVsIERNQSAgY2hhbm5l
bHMuDQo+ID4+Pg0KPiA+Pj4gZG1hLW5hbWVzID0gdHhfY2hhbjAsIHR4X2NoYW4xLCByeF9jaGFu
MCwgcnhfY2hhbjE7DQo+ID4+Pg0KPiA+Pj4gd2lsbCB1cGRhdGUgdGhlIGNvbW1pdCBtZXNzYWdl
IHdpdGggc2FtZS4NCj4gPj4NCj4gPj4gSSBleHBlY3QgdGhlIGJpbmRpbmcgdG8gYmUgY29tcGxl
dGUsIG90aGVyd2lzZSB5b3UgZ2V0IGNvbW1lbnRzIGxpa2UNCj4gdGhpcy4NCj4gPj4gQWRkIG1p
c3NpbmcgcGFydHMgdG8gdGhlIGJpbmRpbmcgYW5kIHJlc2VuZC4NCj4gPg0KPiA+IEJpbmRpbmcg
aXMgY29tcGxldGUgZm9yIGN1cnJlbnQgc3VwcG9ydGVkIERNQSAoc2luZ2xlIGNoYW5uZWwpLiAg
V2UNCj4gPiB3aWxsIGV4dGVuZCB3aGVuIHdlIGFkZCBNQ0RNQS4NCj4gDQo+IFdoYXQgZG9lIHNp
dCBtZWFuICJjdXJyZW50IHN1cHBvcnRlZCBETUEiPyBCeSBkcml2ZXI/IG9yIGJ5IGhhcmR3YXJl
Pw0KPiBJZiB0aGUgZm9ybWVyLCB0aGVuIGhvdyBkb2VzIGl0IG1hdHRlciBmb3IgdGhlIGJpbmRp
bmdzPw0KPiANCj4gSWYgdGhlIGxhdHRlciwgdGhlbiB5b3VyIGhhcmR3YXJlIGlzIGdvaW5nIHRv
IGNoYW5nZT8gVGhlbiB5b3Ugd2lsbCBoYXZlDQo+IGRpZmZlcmVudCBzZXQgb2YgY29tcGF0aWJs
ZXMgYW5kIHRoZW4gY2FuIHVzZSBkaWZmZXJlbnQgbmFtZXMuDQo+IA0KPiA+DQo+ID4gV2Ugd2ls
bCBkZXNjcmliZSB0aGUgcmVhc29uIGZvciB1c2luZyBjaGFubmVsIHN1ZmZpeCBpbiB0aGUNCj4g
PiBkZXNjcmlwdGlvbiBhcyBiZWxvdy4NCj4gPg0KPiA+ICAgIGRtYS1uYW1lczoNCj4gPiAgICAg
ICBpdGVtczoNCj4gPiAgICAgICAgIC0gY29uc3Q6IHR4X2NoYW4wDQo+ID4gICAgICAgICAtIGNv
bnN0OiByeF9jaGFuMA0KPiA+ICAgICAgZGVzY3JpcHRpb246IHwNCj4gPiAgICAgICAgICAgIENo
YW4gc3VmZml4IGlzIHVzZWQgZm9yIGlkZW50aWZ5aW5nIGVhY2ggY2hhbm5lbCB1bmlxdWVseS4N
Cj4gPiAgICAgICAgICAgIEN1cnJlbnQgRE1BIGhhcyBvbmx5IG9uZSBUeCBhbmQgUnggY2hhbm5l
bCBidXQgaXQgd2lsbCBiZQ0KPiA+ICAgICAgICAgICAgZXh0ZW5kZWQgdG8gc3VwcG9ydCBmb3Ig
bXVsdGljaGFubmVsIERNQSAoTUNETUEpIHdoaWNoDQo+ID4gICAgICAgICAgICBoYXMgMTYgVFgg
YW5kIDE2IFJYIGNoYW5uZWxzLiBEZXBlbmRpbmcgb24gdGhlIHVzZWNhc2UgQVhJDQo+ID4gICAg
ICAgICAgICBldGhlcm5ldCBkcml2ZXIgY2FuIHJlcXVlc3QgYW55IGNvbWJpbmF0aW9uIG9mIG11
bHRpY2hhbm5lbA0KPiA+ICAgICAgICAgICAgRE1BICBjaGFubmVscy4NCj4gDQo+IE5vLCBiZWNh
dXNlIEkgZG9uJ3QgdW5kZXJzdGFuZCB3aGF0IGlzICJ3aWxsIGJlIGV4dGVuZGVkIi4gQmluZGlu
Z3MNCj4gc2hvdWxkIGJlIGNvbXBsZXRlLiBJZiB0aGV5IGFyZSBnb2luZyB0byBiZSBleHRlbmRl
ZCwgaXQgbWVhbnMgdGhleSBhcmUNCj4gbm90IGNvbXBsZXRlLiBJZiB0aGV5IGNhbm5vdCBiZSBj
b21wbGV0ZSwgd2hpY2ggaGFwcGVucywgcGxlYXNlIHByb3ZpZGUNCj4gYSByZWFzb24uIFRoZXJl
IHdhcyBubyByZWFzb24gc28gZmFyLCBleGNlcHQgeW91ciBjbGFpbSBpdCBpcyBjb21wbGV0ZS4N
Cg0KV2Ugd2lsbCByZS1zcGluIGFub3RoZXIgc2VyaWVzIHdpdGggY29tcGxldGUgYmluZGluZ3Mg
aW5jbHVkaW5nIE1DRE1BDQpzdXBwb3J0Lg0KDQpUaGFua3MsDQpTYXJhdGgNCg0K

