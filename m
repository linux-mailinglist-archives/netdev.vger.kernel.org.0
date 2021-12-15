Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C66747660A
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 23:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhLOWlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 17:41:37 -0500
Received: from mail-dm3nam07on2075.outbound.protection.outlook.com ([40.107.95.75]:12043
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230031AbhLOWlh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 17:41:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCIod5u4UfM9VpAoszC38ASZyhC+wwaXVDWAYofxU/eatYapnQzwW+EbIjzM4O1Q2+bmMvfrMpxS5pImAkUspbpdnoWrf/QuFILBBiBJd2RL/kuyQPgaa6jLH4+Ev545qwFkg0RIeyGCkNgToHxjEdmLxgAGE7ZzFjnZXeQASMLT/bJmEpH4J6InilD992XMCfaTUXBfEmmiPoS7QQ0R4T8hvJzldihhmYbtYyV1xdoTUV9Xmze4G46VTIoo1SJ1Dzbf7VnH0ez6o+0hqMqNRyDqT+2JON1t6Qy4Poasg2xhmF7e8rRxo9ookCsWuYtgk0wfQX4ibgq8gMxIqqn6Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CAX3xQQoSDBSNOV5aztEYBSgtWHQnuGlAkPBUMkTsRE=;
 b=g1MVCACGen4LJVje3CO+qA2/fesuLx36jLoHWtuaoLvsmrr+7scFTYNkPuTOTsQAv6ou9wgLFILQpVA/gA/MS+EBP2IYLcLmsCZ5vV3rYeECfQDqqOJiQgYLY2iDSQnYCw0Oe/OaFqDx4X/BrzDNjBRnoIoxXHUJCKyT398OlGblEiGWFR6Pyd1Ajzyp1Ogx/4SCUhEzHzFtNkAYScRRnjshZsrVknGAMeG/TfGZf6Dmhb5EXjPV49bTHsupJDNhISGzfv72DFgr8BTgG+pj4aFCxJ0O8bmDRXcZ6nt6Cfu4wiKkC8DGE4uNH2o3m6anw+QWMY8Y5Xo+WTaH+qgIDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CAX3xQQoSDBSNOV5aztEYBSgtWHQnuGlAkPBUMkTsRE=;
 b=HPbFLGhMViZEf5asymklgCvRcx9s57iWjPx5Subtz5gecBDW0PKpnZyPbUbvAKPGlwQqGKpO3eb1TpCh/reEpHFePZpq7rKA81ktuyJ6F+9s1qBZcoaJVJqGbqGQO1lnAoWN6Q9yPbuvIUDvHrCpAPccUck9Sab7qmfQTGJVmILVxshc3Qx8hd/Oso53Os483bL10H87xeiRcz3Yl4DNpgp9YbayhPXxLS/ADMOq6tP172gFgxSQpnNhACKtuSgsTXwXcPOc8N/JnHdZOirxlzqRfQZqJ5E1MCrzE5hFwSqc8+aCUFaAO3HTzBfhAI/LNLXINF0np6T8emkSWJGVlg==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB3745.namprd12.prod.outlook.com (2603:10b6:a03:1ae::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Wed, 15 Dec
 2021 22:41:35 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2%7]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 22:41:35 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull-request] mlx5-next branch 2021-12-15
Thread-Topic: [pull-request] mlx5-next branch 2021-12-15
Thread-Index: AQHX8eSNpvHoVn9Q10+0EcNJVS/d9Kwz7qWAgAAvrYA=
Date:   Wed, 15 Dec 2021 22:41:34 +0000
Message-ID: <dc7e552eabbccd8aeca27f77c3e8783da9379823.camel@nvidia.com>
References: <20211215184945.185708-1-saeed@kernel.org>
         <20211215112319.44d7daea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211215112319.44d7daea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.2 (3.42.2-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78548e7e-79cc-4da1-b59c-08d9c01c0c72
x-ms-traffictypediagnostic: BY5PR12MB3745:EE_
x-microsoft-antispam-prvs: <BY5PR12MB3745F6B55FFB2E1DDA6025A0B3769@BY5PR12MB3745.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bSyNcC8u6XCr3YQW5cjtnuKbmETQcVzwyf+j1xmUZuE6avyXCW8tJo0DPSQiDue+i5le9NLUrcnXjXBzSQJTZsdMMfrBfbeL7xa/NFyowjmewUX0dGgbhWxaDtdZwJd0wV7y/gHMF/9Kt8epoE1h4vRVMYrDVG0XV/Qf5MGIVNnxX66PD3wZMqnSMFDqob2mffjFx6mAxOMbHDl/8sPzt2rFZT6+7XbOkKECpd80cT5WkL4UVnJMVUKqDvXXWqCeFIz0b9Lj9nI1ATFId2q4ZV/oVNEzJcd50sZZ56JsKt8XdFpQbcB2R9G1u64FWjfYOYEKWqDqyvXq2d/TSZzptc9fsnP+6M7/sf1BBh/mq24fToD9BuZ4EotOlyIOHbxsDEMjCHF2zHH7zEdvZ5sHFPpLPtLVolD2HgmKtuLu2rRgmq+AaRnIqFzWrk6EQKFF6NEpS1zbZlEcsif7Dpjn5NykhYITn12QO+UGNZLv2nv1gtmXgiJVj4WN++FZsnaI2JdvWyC209qznJirEGPUkx2Umr87D7x/bt18GaXpAJbGzcoeL18H5STqV4vxJUQ+NtrXrg6O5yiVy2BeTbGC6qqOafqqDCdPWWVlhqjSDjoFJzdVGx3zTzTcCcin05zxKl9Fkbc02LWgSv7D+puU5RvqbifIuFoshjZ0ia3gizS4CgfnZ6OsRIYVso77yS7ZYglvcH5SFdtNHIiy2uLIc5/LS57G2I52OdykMXLqM1ZJg3ozPjFys9cs/OYes3p6ge3Xdq75bJNfh8/ZXBiz5mnCqn+XBFKp6+Hhxrlx4OcG48lfsQraY8PLj8uAqGtDv+rFzK0ADLQcAmBl/ob6qg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(36756003)(66556008)(4326008)(86362001)(66446008)(122000001)(64756008)(66946007)(38070700005)(508600001)(6486002)(8936002)(2616005)(6506007)(8676002)(38100700002)(6916009)(71200400001)(316002)(76116006)(4744005)(4001150100001)(2906002)(26005)(966005)(6512007)(54906003)(186003)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UDVWWXBoTDVXeFZVMmllZDg2emZxU002OEdrUkRCczYwSlNoUW5QVUU2cHA0?=
 =?utf-8?B?RktmMnAyU2hoai83aE5hUEd4bjE0dkxUWGhmVGUybTlFZ2R2N2ZJRHBWSWc4?=
 =?utf-8?B?bFY2eGVFYkJMMU1WYzhoSTErRTdVVWtQOXNHSkM3SCtFcjJ2VXVWb1djT1NB?=
 =?utf-8?B?eTNaanJzeHlFbTNEUGhHck84dTlGcXlPckNOQWw0L0Nob0ZlbU1oMXorWG0z?=
 =?utf-8?B?cG5mNWo3QnRkdEt4SmtwZGNRWDFEZEpUdzJBUUNFY0JoN1YydTNsVndjY2N5?=
 =?utf-8?B?UmhoeUh0V2xPRWVBZURZYVdnUElydTlaWmdmc3V2NUwxRjgzampYaGJvbUJi?=
 =?utf-8?B?Q3Z2S0duckcybDFUUHFQV2xyZ25OWEtUSlgwM1FVUVgydjJ1dDlLbnc2SmVm?=
 =?utf-8?B?TEl4ZjVpZ1Irem9zYmhPYkVNaG5GdWRZK1A5QXNUZmFaS0ZvR2JtTHFEVHdw?=
 =?utf-8?B?a1R0aGZ2WFhxZkw3NDFHODlPUnRkQ2tCN3RoVkNqeU42OFVXM3FOOW1idXVo?=
 =?utf-8?B?S1RiNmg3TFhMRmdpL1lMUHN3RmJ4WURPdi9vNlFPUHFpV2NKcjFCN1JYY21O?=
 =?utf-8?B?YW52NDV2aEFhejh1MTZ6Nms4cTZ2K2JTVkNFTzFoSm9aS2xQblRaTFJ6UjZv?=
 =?utf-8?B?a2JxNC82Rkdxb3dlVEdpcEQvS3JNWVdyc21lK2ZRN0JIVnJxNDdlTnZJYXVI?=
 =?utf-8?B?TjVKWVFnWWhpckpwUVFPdmdkek9tTHJYM2ZxclM0S1Q2b0h0MzRKV3A4R3Rw?=
 =?utf-8?B?bEl3UUthdkY1aWxCYzlDK0tGVE5yY0pDWlMrYjRSOXlPeXEwQmVqT2I3L1NU?=
 =?utf-8?B?OENQS1IwSnM5aVJEUHJMWG9sbWRGK29Ub283cWMyTWdxenVFK1dNaklIMGMx?=
 =?utf-8?B?ZE9UUDlQWmxnaWczNzhQNFZYZzVrcE9FRHlFVFU2UWFlYld2Szl4V240djJH?=
 =?utf-8?B?NlNLRllmV2tCWkF1bEJZY0Vud3E1ZVFLU2Nmem5NdFZraU1UcldrOGNWSmNY?=
 =?utf-8?B?c1cvTkQxOUx1UFlRcVdmQlJYdkcyQVN5aDVSSXJURlF4alAyd2tIc3BFRU5B?=
 =?utf-8?B?YjVuci9iaWIvNWFMSXEvTTFzYlVtL2VraENqb1hUeUt6R21idWI0UlBrR1BZ?=
 =?utf-8?B?M1Zqd2FRbUVqcTZEOUt2SzI4VFlRcFl4Y2gzWjIvaTduSDh3K3M3SE9UbGRL?=
 =?utf-8?B?amR0M1hYaFhGV0U1bC9YMzgveUcwWFk0UWVnVlpCYUUwK1g3ZkJVejJIT3po?=
 =?utf-8?B?T01oVjN3SW5aZWRDd01hOHBKVWo0L1dmSVhXV05NcFUzQnI5bXBKZHdsZ2RW?=
 =?utf-8?B?QWE1MWlHb1Q5SzJlTU9GaGRQMDlCRE1nbms5dUR3a05FMzNFYldINEplVkdr?=
 =?utf-8?B?Qm5FcnlwNHpudmlPcW9zVytXVUdqSGdEdWh6NElKbzMxbW1FMTNxSlJBNVdQ?=
 =?utf-8?B?dWNtUkZSV2RJd3VEZWw5bEFzZDVtMlhZeE9PTjdnVU1PeU9qMEZmQkRjbk53?=
 =?utf-8?B?WmNyeDQ1bE42eHUydUpEc3prWDE3UEdKQVFvQUFwNXRaV0hoNGVubTRxWjFE?=
 =?utf-8?B?aU1NZXNHMXRtRTZhUit2aUlGc3V3bmNxODB6NStBZzZ0QnlUT3hBUDVhZDZn?=
 =?utf-8?B?d0pWanJLOVdRRlhsUm5ON2xRQXBHWUFTOVJpeitoQUQ2b3lSYVpCWitnSWow?=
 =?utf-8?B?RTgrTU5pTURMOGRtdkVFRVBBZHdsZXIyaStZM2I0bENXdnc3dStSY2h0T2ps?=
 =?utf-8?B?MEwwbnZXaTVCZHR4NDl1K2lpMW1ZQ1dSSElwaXNRT3IrM0FFTWlxS1Erblkr?=
 =?utf-8?B?RTV6RHEyZE41dEpsK1NFQ0lSWTFCdmpmZ1NWOGxQNmEzVUhycDBXLzNaRmpX?=
 =?utf-8?B?R0t5NFBLdEVadmhUODc0eDBqdENoalBhRC9FWEpwYVE1YVVYeEg1eVlxeGVR?=
 =?utf-8?B?Vnk0R1pOSmphN1JBMndhblh4YkdXTkt4Q01sMnZndWE5Z1FwTFpzbEY1K002?=
 =?utf-8?B?eXFnU0tzNWowTmU2VmFzRmt6dFhLUzNBS3BXaCtKUWxacVEyekxpbDhEWlZa?=
 =?utf-8?B?ZkVVWEsray83TTdTMGFWd1dMM2F4VlNQc0gzRUQ5VXBzZUplT0JvTGY0Ukwy?=
 =?utf-8?B?K0x1QXhoT0lkcXV5WktZVWM4MHdFNGJEbURBUXZTS2RMdGxpVndmTUl6ZUJt?=
 =?utf-8?Q?IMfQit0MNL2J5YMUgm7ZoV4hCBunm9qqiplgDhrhzvq/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C1FAAA412E3634DBC1A306B74145DAA@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78548e7e-79cc-4da1-b59c-08d9c01c0c72
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 22:41:34.8454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6qlODviLwWO64NNXHX6Hff0J3hTCMk3RCJbL0cSG+TVPh/3NVW/r/RLb7kou+YzFL2OBCYduvy8dKRAWj46Jtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3745
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTEyLTE1IGF0IDExOjIzIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAxNSBEZWMgMjAyMSAxMDo0OTo0NSAtMDgwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBUaGlzIHB1bGxzIG1seDUtbmV4dCBicmFuY2ggaW50byBuZXQtbmV4dCBhbmQgcmRt
YSBicmFuY2hlcy4NCj4gPiBBbGwgcGF0Y2hlcyBhbHJlYWR5IHJldmlld2VkIG9uIGJvdGggcmRt
YSBhbmQgbmV0ZGV2IG1haWxpbmcgbGlzdHMuDQo+ID4gDQo+ID4gUGxlYXNlIHB1bGwgYW5kIGxl
dCBtZSBrbm93IGlmIHRoZXJlJ3MgYW55IHByb2JsZW0uDQo+ID4gDQo+ID4gMSkgQWRkIG11bHRp
cGxlIEZEQiBzdGVlcmluZyBwcmlvcml0aWVzIFsxXQ0KPiA+IDIpIEludHJvZHVjZSBIVyBiaXRz
IG5lZWRlZCB0byBjb25maWd1cmUgTUFDIGxpc3Qgc2l6ZSBvZiBWRi9TRi4NCj4gPiDCoMKgIFJl
cXVpcmVkIGZvciAoIm5ldC9tbHg1OiBNZW1vcnkgb3B0aW1pemF0aW9ucyIpIHVwY29taW5nIHNl
cmllcw0KPiA+IFsyXS4NCj4gDQo+IFdoeSBhcmUgeW91IG5vdCBwb3N0aW5nIHRoZSBwYXRjaGVz
Pw0KDQphbHJlYWR5IHBvc3RlZCBiZWZvcmUgOg0KWzFdDQpodHRwczovL2xvcmUua2VybmVsLm9y
Zy9uZXRkZXYvMjAyMTEyMDExOTM2MjEuOTEyOS0xLXNhZWVkQGtlcm5lbC5vcmcvDQpbMl0NCmh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMTEyMDgxNDE3MjIuMTM2NDYtMS1zaGF5ZEBu
dmlkaWEuY29tLw0KDQo=
