Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29445510791
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 20:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352842AbiDZSzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 14:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241389AbiDZSy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 14:54:58 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2137.outbound.protection.outlook.com [40.107.220.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1FA14AF43;
        Tue, 26 Apr 2022 11:51:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBve2P3YadRw6WcbT/Zju/909awJurl7kvYLQXcqILAarEC5AutOjHcNGohw5fq6AbEVzVVbZrGTmXDZ5aM3jirY8rEsVAali9+kV6ADjOx5RGYNFaRIgFJWU+S/y47PSKjW+2ukKhKUhG9XBYHFk8WmtGOWqxl5I14lvZNlkXYijoEgw0XgkJ/MKqd1/icF4ADDUWvCElWGvKJO1MoIGohJ1KHZJo0Wk3GY+6eTAxG4oZpAjk6LeRDfp6srXd6oVXV+Tm4iW7iS1KaFOd7nSe0krC/HBKamQkzZxR6LEa/fKNxQYPQ8qX1LtsKyKDQkyBxPF1d2PBuQZ31sm4JaKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZ4/1Oi0P4Y9C21E3Dk8jsyN5Izs2woPbNLYa4gmHbQ=;
 b=DFAulOzQeM5K+uiKlIbtUthffx787IAnIDP+cZTholxrG7lb8E4HbQUD2Vt9a+m79gXC59soddDrOibSzM3clSXD4jXGpQpF3HPV1ZdP1m5+BabhuMaSnBqwlAOLa93SOYeyyaSiDUxUWbeMunsDVyNbxRlXVzxP4BHAKBjQagxGeJ+lAuP/ZOKAHAmTjk7EmqmmG7I7eV+a1VTyQGFbZ1COVRDdeJhJiOmLJGD3C9ERC5smuIyv7ROaQWfNLwgKbZsnPbJBCteBAHKfIAaJOzoI5xd+/7wAeF8haKqCM2OKuOJKKz825uWLWkNY1ZEABmqWhtzkauptvMwoKT3VEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZ4/1Oi0P4Y9C21E3Dk8jsyN5Izs2woPbNLYa4gmHbQ=;
 b=BkUtGtqKmYrAHAyVkBfVUjl9zeQipW+tOPOaPkFsryRUByfghPV4q+5qlNgk97EqT2+vt7PFNscqt81eezX25hmln47P6iKbzk+nDTy/2IwrBUCKEJxAcXC+SW/k8gwC08E1zjZ/xJn0PRVlbyFq7/KzHs/wFTQATW65Yd8ixR8=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by MN2PR13MB3790.namprd13.prod.outlook.com (2603:10b6:208:1f1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.6; Tue, 26 Apr
 2022 18:51:45 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::694a:6bf0:4537:f3e5]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::694a:6bf0:4537:f3e5%5]) with mapi id 15.20.5206.012; Tue, 26 Apr 2022
 18:51:45 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "anna@kernel.org" <anna@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wanghai38@huawei.com" <wanghai38@huawei.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] SUNRPC: Fix local socket leak in
 xs_local_setup_socket()
Thread-Topic: [PATCH net] SUNRPC: Fix local socket leak in
 xs_local_setup_socket()
Thread-Index: AQHYWW2/Q5oYWeHPakCQbwJ4ORbHbK0Cin0A
Date:   Tue, 26 Apr 2022 18:51:45 +0000
Message-ID: <d013bdc75085e380250cb79edf2b27680cbc9f7e.camel@hammerspace.com>
References: <20220426132011.25418-1-wanghai38@huawei.com>
In-Reply-To: <20220426132011.25418-1-wanghai38@huawei.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45f9526c-ab6f-4645-9002-08da27b5cfc5
x-ms-traffictypediagnostic: MN2PR13MB3790:EE_
x-microsoft-antispam-prvs: <MN2PR13MB37900B6C96F6DA986A436EFFB8FB9@MN2PR13MB3790.namprd13.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mdMRcJw0y5uZelmwJTjZ/uaZAp2g17Dmka8UkpS0hvFh8nt15/PRBmMewRd9uz0Xr7V+cF8FJWDubejYKBBVPdI1AXzwiyHbgl/xpE2n5L1DvC9AnIAHDah1+sSVH35h//00kfPUmdSA0ZD+I/TgqkS4eaeCYnl2ex+5vdLZFy8eXMfSQC/60MciDKaJCAzQzJJuPfRsWMuh+t9CtRAUezZybEXRNSKwteutwln/ENYGG0Pi7lVjpb5Ue6bwz4ZoO2nC/H0yTxldpY21i6sUVVgfixEMR/I4Up8iW8gwn+6ysGVj8qZZzyKtDrX4BRh9+Zs38JqTHJj2enT83kIoruPH4ubnPzotF/K/pfZvjvwbQT/yt3xtDMbP5k0KNI+oHC/kelewr03pYrU9Y5JZnQAnb9uBVHMNIVFgohZkvtSt/3N6YsrILpReyLGpdFLxXZHZZp67k32LfEwO+45CpPUZXrKvtErkEUKQhUsydECR+VgViVS1UgehvqQmk1WbzqV0qgLgqeuM28/thTMBcjskqRmvQGv+yQLtn+mAAw2hPhG8qUJQBEpPxbMK1pcnfgTDuYI1eKmIn+o0/Bmywbt8kCvt/QXYpk+K1x7fQgkazXFuJj3y4XUBEuP1J0j3uLA/EBFJwi1BH3LqfHnJdYGVgoHbkjM7m5POsoBHvUxapWUnRiY8FdUtSFAf+ltJ2/ibVmcMTZp/6kTG8lNHdSCsUKnfCr37GM+AP5rBrp5nHOWX3aQzQmwj+dqaaNJO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(122000001)(38100700002)(6486002)(64756008)(86362001)(2906002)(38070700005)(8676002)(4326008)(66446008)(76116006)(66946007)(66556008)(66476007)(71200400001)(110136005)(316002)(5660300002)(54906003)(8936002)(83380400001)(26005)(6512007)(2616005)(36756003)(6506007)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tjk4UjB6eFR0eU1XMDlUTnF2YkF5S2s0c2N5anRVMEpQbTdiZHhOWXNLRUlJ?=
 =?utf-8?B?QXY2UzlxQkNNTmJtd01PNkl6MDV1bmdRbXU0cEVodU93cThPdTdGRFlHdy9m?=
 =?utf-8?B?SnpQOTdXVUdYT3AxRDYwZEk2bHJwV0plWEx4VTdRQmZncnZ1emZIOE5UQlhH?=
 =?utf-8?B?NWxrMWRGNVJ3dlJrVFhCSU9RcFRBdFVNdWZ0LzlXZE9WZ3lqZ0hYNXhCT1JC?=
 =?utf-8?B?bDIrWXFaUC9udUhQS3Z0QVEwd1B6U0FESXBBSnNORWx4S3d6NW94YlJyR0w2?=
 =?utf-8?B?QXNmUGw1ZXYwS3dEUXVML1cyS3l3OWhRcklpNjVmZ2xhdkZLZ3g1aysrVkVQ?=
 =?utf-8?B?cXVFWkY4SDlSOEdvVmJzZ2lWQ09ZajYyOU4rQTg0T2RUYmF5SXg0TFVvUXQ1?=
 =?utf-8?B?b013VC9YM1JMOWhRc0ZCKzRPeThsbWxHMVUza1BPaUUvelBWcGM3anlOajYz?=
 =?utf-8?B?UTdFWHhHa3QwcWVPMmhGYUswaUpkekxBcy9mMEpDSDVURXVXNXl1SFVrSTN0?=
 =?utf-8?B?bmk3clpwY1I5TFE3ZGozcjVTU1pURFVTQXhTUzBhcXE2U2M3U2ZZTVpQVkRT?=
 =?utf-8?B?TnVOd0xHZjgvWFg4OGtKZDNaMWs4WDU2cUVNY2w2REJ4cUVIeXh2MlltNG9Q?=
 =?utf-8?B?eGxQaDFsVS9CNkZtc29LRGt1OGVUWXgvcmdlUzgrYmFWQnQvRnpjU0hBTUF1?=
 =?utf-8?B?UWNoR3pJY0F4cGhQZTJCWVIvR0ZxSVpxWHZHb1ErWkMrajRLUFN3c1E0K3NH?=
 =?utf-8?B?U2svQXYyVTRPL3pWMnRMT1BtbDZsSUZoQWloVGxiMk52dGdrV2ZVTFQ1K3Vw?=
 =?utf-8?B?SXNxbVUvbzJKU3BEdGFNMnhQZTBmdllYbUJDbzluTWZqR2xCZTN4TDNaWTBm?=
 =?utf-8?B?YTdoTjZpaUFrTkZFQk1XbGtNbXdMaytEdUh4SWJ6OXRRTklUZHNLNUw2ZDd1?=
 =?utf-8?B?cVRVdURCQ3RFQzlUVWMxS2QvY29sK2lNSERnY2RGdDNIZ09yMlQ0MUhkWGJh?=
 =?utf-8?B?dWZOMitxeFovMDJBZzJJWHk1Z3c2bmFtUGhaKzdWQjRmZUdTdTlpL0xCemgv?=
 =?utf-8?B?YmVyUDl5ZTd3SGZSUmhCT1lXTERtdkkvMU1OaEI5YzV6RDA5TFRScjJQRjFp?=
 =?utf-8?B?T1UwTTZTL0IvMW9OSGdMa29KbUFjRTRjZTRia0xrckdLak9YSTJKSThqZFdS?=
 =?utf-8?B?L2lIUEZCNWQrbnFQOFYxQXEyczhYY25ld3VObXhqa2trcEU2SzdiQjR5dWdi?=
 =?utf-8?B?RzlqVGFZcmIyLzhib1ZpYlljeXdxY2VyalNybExFcTNIVkxGUDBtWWRPZWRv?=
 =?utf-8?B?REVhZFVvbjhGZWhmQmtiOFZiSnFSWGJlT0RSRlVzWGZrd3cyc3NSWk5YVlQ3?=
 =?utf-8?B?T0tkME9pbmNVV21NWDlTaXpVS3FaZDlaWHZ6TU5Bbk5ybzFCSmlsNTllcW9N?=
 =?utf-8?B?UGJSaUtoVldhN05ucWFPcG1nRzdHalUyMThqNDBzL1BPdm5hZDRwYVRqUmE2?=
 =?utf-8?B?QnBGK2o3S1pvOXJ3RTg5QXNGNm9IYzdTS09GUURFMWtSRG5EcTRkZlNkYWZ2?=
 =?utf-8?B?UjU2S1dWR1JSSG81Ujk5Nk9tN1ljeTRZcVJJS1lDUWhWd21icGh3emV0YTFy?=
 =?utf-8?B?bzBBaENNdkM3cVVXREh4eUpiOXBxZUp3a1hXaGROdUM4NkVmYVlaTnVRVlln?=
 =?utf-8?B?MUp1WlR4dnJldExVUEpIQk5JTUpiSG8rcTRWSUJiOFIrYncrem5nSTBLQzZ3?=
 =?utf-8?B?b29Dd0dXUHkzTkJKemp6ajhpWUZyTjgzVzZ0ME5FcUdzTmhnUTZ3K3czQmlz?=
 =?utf-8?B?bTBoVjFPdWpBOXJET2d6Tlg4M3pNYnZrckpjWThNbnFJSnNrR0kzc3ZSL0oy?=
 =?utf-8?B?NTBscGVySm5CM29jWk9RWWl3aGpYZFQ0T1BBVi94TmJvTHdEMFlBSG1OUkdt?=
 =?utf-8?B?bW4ydi8wUUJEcnJDbDZMaTQwMC9sTm90MVJ1aXJWSFdjYVlBUnQ2bERqMU5m?=
 =?utf-8?B?eU9Gd0Q4MXYyaWh2VGY3Szl3U21WaDNWOTBRa3VFQWUxSkQvelE2aDNkdEwv?=
 =?utf-8?B?ZktqdGs0cGw0OTI1QWdjTWhiUWpNSzlKYUZRM3k3M21CWCtiak5kU05FY1Ix?=
 =?utf-8?B?R05YSUFvM2labWVmS0tzYlpTaGdjTzlvZFYvaGVrcXdDR213cjJRaGJ6Qkw0?=
 =?utf-8?B?d0dyT2Irbk5haWplUE5hLzhRR3JmS1VCazMwL0pHbE5mL2FJb1Zjc0l3Vmpo?=
 =?utf-8?B?OE5mRFdEN1IzYXBFeVhadFAxQ09KUHpvdUNIVU9LbE9Ub0RjTllpd1BZV2dO?=
 =?utf-8?B?eStXNnBOYzI0Z096NzJjdTB4NUhGd2N6T0RTang4VUlhQTN3b1Q1N1hoVEJT?=
 =?utf-8?Q?io4wo8kocHlnQbrI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84F95316BF2A384092136D80818192A8@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45f9526c-ab6f-4645-9002-08da27b5cfc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2022 18:51:45.4585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IePh1eGCD571UPOR7/Y/4gw8Bffr2CPQ3X0woieM2ojjEwkuJZY0+YQh83bxNlbyGYH6FeSxGXA/DV8LHQ9Eyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3790
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTA0LTI2IGF0IDIxOjIwICswODAwLCBXYW5nIEhhaSB3cm90ZToKPiBJZiB0
aGUgY29ubmVjdGlvbiB0byBhIGxvY2FsIGVuZHBvaW50IGluIHhzX2xvY2FsX3NldHVwX3NvY2tl
dCgpCj4gZmFpbHMsCj4gZnB1dCgpIGlzIG1pc3NpbmcgaW4gdGhlIGVycm9yIHBhdGgsIHdoaWNo
IHdpbGwgcmVzdWx0IGluIGEgc29ja2V0Cj4gbGVhay4KPiBJdCBjYW4gYmUgcmVwcm9kdWNlZCBp
biBzaW1wbGUgc2NyaXB0IGJlbG93Lgo+IAo+IHdoaWxlIHRydWUKPiBkbwo+IMKgwqDCoMKgwqDC
oMKgIHN5c3RlbWN0bCBzdG9wIHJwY2JpbmQuc2VydmljZQo+IMKgwqDCoMKgwqDCoMKgIHN5c3Rl
bWN0bCBzdG9wIHJwYy1zdGF0ZC5zZXJ2aWNlCj4gwqDCoMKgwqDCoMKgwqAgc3lzdGVtY3RsIHN0
b3AgbmZzLXNlcnZlci5zZXJ2aWNlCj4gCj4gwqDCoMKgwqDCoMKgwqAgc3lzdGVtY3RsIHJlc3Rh
cnQgcnBjYmluZC5zZXJ2aWNlCj4gwqDCoMKgwqDCoMKgwqAgc3lzdGVtY3RsIHJlc3RhcnQgcnBj
LXN0YXRkLnNlcnZpY2UKPiDCoMKgwqDCoMKgwqDCoCBzeXN0ZW1jdGwgcmVzdGFydCBuZnMtc2Vy
dmVyLnNlcnZpY2UKPiBkb25lCj4gCj4gV2hlbiBleGVjdXRpbmcgdGhlIHNjcmlwdCwgeW91IGNh
biBvYnNlcnZlIHRoYXQgdGhlCj4gImNhdCAvcHJvYy9uZXQvdW5peCB8IHdjIC1sIiBjb3VudCBr
ZWVwcyBncm93aW5nLgo+IAo+IEFkZCB0aGUgbWlzc2luZyBmcHV0KCksIGFuZCByZXN0b3JlIHRy
YW5zcG9ydCB0byBvbGQgc29ja2V0Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IFdhbmcgSGFpIDx3YW5n
aGFpMzhAaHVhd2VpLmNvbT4KPiAtLS0KPiDCoG5ldC9zdW5ycGMveHBydHNvY2suYyB8IDIwICsr
KysrKysrKysrKysrKysrKy0tCj4gwqAxIGZpbGUgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvbmV0L3N1bnJwYy94cHJ0c29jay5jIGIv
bmV0L3N1bnJwYy94cHJ0c29jay5jCj4gaW5kZXggMGYzOWUwOGVlNTgwLi43MjE5YzU0NTM4NWUg
MTAwNjQ0Cj4gLS0tIGEvbmV0L3N1bnJwYy94cHJ0c29jay5jCj4gKysrIGIvbmV0L3N1bnJwYy94
cHJ0c29jay5jCj4gQEAgLTE4MTksNiArMTgxOSw5IEBAIHN0YXRpYyBpbnQgeHNfbG9jYWxfZmlu
aXNoX2Nvbm5lY3Rpbmcoc3RydWN0Cj4gcnBjX3hwcnQgKnhwcnQsCj4gwqB7Cj4gwqDCoMKgwqDC
oMKgwqDCoHN0cnVjdCBzb2NrX3hwcnQgKnRyYW5zcG9ydCA9IGNvbnRhaW5lcl9vZih4cHJ0LCBz
dHJ1Y3QKPiBzb2NrX3hwcnQsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgCj4gwqDCoMKgeHBy
dCk7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHNvY2tldCAqdHJhbnNfc29jayA9IE5VTEw7Cj4g
K8KgwqDCoMKgwqDCoMKgc3RydWN0IHNvY2sgKnRyYW5zX2luZXQgPSBOVUxMOwo+ICvCoMKgwqDC
oMKgwqDCoGludCByZXQ7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCF0cmFuc3BvcnQtPmlu
ZXQpIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBzb2NrICpzayA9
IHNvY2stPnNrOwo+IEBAIC0xODM1LDYgKzE4MzgsOSBAQCBzdGF0aWMgaW50IHhzX2xvY2FsX2Zp
bmlzaF9jb25uZWN0aW5nKHN0cnVjdAo+IHJwY194cHJ0ICp4cHJ0LAo+IMKgCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB4cHJ0X2NsZWFyX2Nvbm5lY3RlZCh4cHJ0KTsKPiDCoAo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB0cmFuc19zb2NrID0gdHJhbnNwb3J0LT5z
b2NrOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB0cmFuc19pbmV0ID0gdHJhbnNw
b3J0LT5pbmV0Owo+ICsKCkJvdGggdmFsdWVzIGFyZSBOVUxMIGhlcmUKCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAvKiBSZXNldCB0byBuZXcgc29ja2V0ICovCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB0cmFuc3BvcnQtPnNvY2sgPSBzb2NrOwo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdHJhbnNwb3J0LT5pbmV0ID0gc2s7Cj4gQEAgLTE4NDQs
NyArMTg1MCwxNCBAQCBzdGF0aWMgaW50IHhzX2xvY2FsX2ZpbmlzaF9jb25uZWN0aW5nKHN0cnVj
dAo+IHJwY194cHJ0ICp4cHJ0LAo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoHhzX3N0cmVhbV9zdGFy
dF9jb25uZWN0KHRyYW5zcG9ydCk7Cj4gwqAKPiAtwqDCoMKgwqDCoMKgwqByZXR1cm4ga2VybmVs
X2Nvbm5lY3Qoc29jaywgeHNfYWRkcih4cHJ0KSwgeHBydC0+YWRkcmxlbiwgMCk7Cj4gK8KgwqDC
oMKgwqDCoMKgcmV0ID0ga2VybmVsX2Nvbm5lY3Qoc29jaywgeHNfYWRkcih4cHJ0KSwgeHBydC0+
YWRkcmxlbiwgMCk7Cj4gK8KgwqDCoMKgwqDCoMKgLyogUmVzdG9yZSB0byBvbGQgc29ja2V0ICov
Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKHJldCAmJiB0cmFuc19pbmV0KSB7Cj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoHRyYW5zcG9ydC0+c29jayA9IHRyYW5zX3NvY2s7Cj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHRyYW5zcG9ydC0+aW5ldCA9IHRyYW5zX2luZXQ7Cj4g
K8KgwqDCoMKgwqDCoMKgfQo+ICsKPiArwqDCoMKgwqDCoMKgwqByZXR1cm4gcmV0Owo+IMKgfQo+
IMKgCj4gwqAvKioKPiBAQCAtMTg4Nyw3ICsxOTAwLDcgQEAgc3RhdGljIGludCB4c19sb2NhbF9z
ZXR1cF9zb2NrZXQoc3RydWN0Cj4gc29ja194cHJ0ICp0cmFuc3BvcnQpCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqB4cHJ0LT5zdGF0LmNvbm5lY3RfdGltZSArPSAobG9uZylqaWZm
aWVzIC0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgeHBydC0+c3RhdC5jb25uZWN0X3N0
YXJ0Owo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgeHBydF9zZXRfY29ubmVjdGVk
KHhwcnQpOwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBicmVhazsKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBvdXQ7Cj4gwqDCoMKgwqDCoMKgwqDCoGNhc2Ug
LUVOT0JVRlM6Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBicmVhazsKPiDCoMKg
wqDCoMKgwqDCoMKgY2FzZSAtRU5PRU5UOgo+IEBAIC0xOTA0LDYgKzE5MTcsOSBAQCBzdGF0aWMg
aW50IHhzX2xvY2FsX3NldHVwX3NvY2tldChzdHJ1Y3QKPiBzb2NrX3hwcnQgKnRyYW5zcG9ydCkK
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgeHBydC0KPiA+YWRkcmVzc19zdHJpbmdzW1JQQ19ESVNQTEFZX0FERFJdKTsKPiDC
oMKgwqDCoMKgwqDCoMKgfQo+IMKgCj4gK8KgwqDCoMKgwqDCoMKgdHJhbnNwb3J0LT5maWxlID0g
TlVMTDsKPiArwqDCoMKgwqDCoMKgwqBmcHV0KGZpbHApOwoKUGxlYXNlIGp1c3QgY2FsbCB4cHJ0
X2ZvcmNlX2Rpc2Nvbm5lY3QoKSBzbyB0aGF0IHRoaXMgY2FuIGJlIGNsZWFuZWQgdXAKZnJvbSBh
IHNhZmUgY29udGV4dC4KCj4gKwo+IMKgb3V0Ogo+IMKgwqDCoMKgwqDCoMKgwqB4cHJ0X2NsZWFy
X2Nvbm5lY3RpbmcoeHBydCk7Cj4gwqDCoMKgwqDCoMKgwqDCoHhwcnRfd2FrZV9wZW5kaW5nX3Rh
c2tzKHhwcnQsIHN0YXR1cyk7CgotLSAKVHJvbmQgTXlrbGVidXN0CkxpbnV4IE5GUyBjbGllbnQg
bWFpbnRhaW5lciwgSGFtbWVyc3BhY2UKdHJvbmQubXlrbGVidXN0QGhhbW1lcnNwYWNlLmNvbQoK
Cg==
