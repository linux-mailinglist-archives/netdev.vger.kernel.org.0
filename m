Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0CE675144
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjATJfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjATJfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:35:12 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852676796A
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 01:35:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nC0VbtkXTR5iMtR8IuOo++TuFY3IAgSnknIsDD8iLKFR2sKk8aHqKplBPpDz02tUkpw0CcJeZ5TrC1/8bOYthUYCSjUnEju+CBl0ZdLZkxGmou8chuCtD1BQxqOc60hrnser7jERgkhVDJxcdsbz66GOTXvc6bMujrb/zf1mqwziNvXlDE8pMwfXndhv+/LP5QpGeyt0etBOmRIsmNRrvOqiJ8gte1D3d/qqCET079AjzixRsoyG1KK4ik4KnrNIXFv5rqM9ZqBjaw9GyiMtXJuZt2424+ltaI68vOysJmEoOF+GxJnvQ8xuIHu8ct8Yu/XyGB0wNZSh5CNL/qyq6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gat509/P6/laD87YTzKeqgo1TxRPOdB3bzAtxwKqm8=;
 b=Q4YUVlBC5u4bi1MU3vhgmTQeNYbkcM/x71Z634aHyEsyCFp6JvPYD7p3gfHsGEKTk29fVSWNJStyEdBdUFjCp1cFykOl4Cq2QMEMxjl9UvP6AuM5vj+iR6s+on61h7rv5JWQVZn8iTPprMG9dwOB3s6d4Lvc7rjALID1VO+URAKjM/e4S/J1kBjxdr6wQxscX0dRJaDGC+GbeU/TRqG1yxUycYOjdyKdts27O7rwCd9I8UkFhPvHM8nQLg3hDVtte+OnMLwBK8GOSUhGWe4qR0w4dz68A2n37Gu8A28/7hP4i8qgwQrX5xyihQIDIlT/t74jjHwiyQnuDW5+OA6ujw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gat509/P6/laD87YTzKeqgo1TxRPOdB3bzAtxwKqm8=;
 b=RnICqTQgL8bDYlWZPrctd8MPM65jNRgkpzbvqdud0bgDwph4y3p+BpwqaL6+FTMFIjsgnAAsPnxYF9fATMdMVFAVBeWUSXj3Tlz1uTfV/fjdDMWpoFgA4boGmehLg6YpXN7PwzN7P55NUladO4Zy4EkX/GTkZQvSgcM9H0BhV9A=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by MW3PR12MB4586.namprd12.prod.outlook.com (2603:10b6:303:53::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Fri, 20 Jan
 2023 09:34:59 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%7]) with mapi id 15.20.6002.026; Fri, 20 Jan 2023
 09:34:59 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm@gmail.com" <habetsm@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next 3/7] sfc: add mport lookup based on driver's
 mport data
Thread-Topic: [PATCH net-next 3/7] sfc: add mport lookup based on driver's
 mport data
Thread-Index: AQHZK/m3zwIZUyvzUEiJhr0giDNJhK6ma70AgAChGgA=
Date:   Fri, 20 Jan 2023 09:34:59 +0000
Message-ID: <9240b567-7dcf-202d-57f9-226a9de097ca@amd.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-4-alejandro.lucero-palau@amd.com>
 <1a3387e7-dbe3-905a-4b7a-ef2cd776cb33@intel.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.53.21091200
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|MW3PR12MB4586:EE_
x-ms-office365-filtering-correlation-id: f80e2c0b-2e15-469b-01d1-08dafac99942
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uZKCqkvBAvb7XZHPRrU3QTEdRO8spIYBjGFkX/Q094v4EOCZDOi7vrwF2qAfWeu8hobJUu4BCeXZ8JOFJZU1C0b8Rmea03cEJVWGzNlfbEi2ETr7R4N7fwLwYQ6H5X2CGjZAyJRGrMhSyCYp6gQn+ftZkgcu7Nlo/MNv/siveooQW3q7ZNpchfUBKEHWZB+h4dLKtf8C5Cd3hA13KHvMgjOb6caxSEA8ipH3ycJsOTjQ1bCP+2JT+w/AWYrdqrg6cm4mqA9Gsg//OyHrvjdkAKdk66Ybw/zoPRmw3a0Dp9jUYN7G2uJim+pEFzk4Q8n/krVOQTflXUXZC4e6Giq4igLhDeXOWOKRUtqZseoBUcYZijPrPujMizpS/MDFSqLBgL1ofJ28bKUx2xQ05OdI0KloGdKvMhItei3cVkO7IAESM18cxxxQDHSn5hJpgq1LdlPj3R4ZFCLbZrYG/sHacPPxvEh4+w3K2R3ESVna2ikjK9rZSIfQMPDetXDOnkYWDGTNKjA6SVLXYF1ww+N/MfHOuZaMmAYHVgr8Z2Buk574MTMa565+DfWUhK/B7o2otsXmh6tu9iAumbkx4rB2/XP1lcFl4NwiheGvkPt9Voe07jR7QP6BtTVOIeVbXD4JbxrWVvlTDXCfuKuUedXyuxl6IUzWQuwtoYFHy9/3dK6dHcqvH4t3iTfUJSddifzEvwJg2jrkU76Nsy13XrJFwmm4X7U/WxjQoq27RAO97eyKNwtXFjJTbOU1y/0fZIgMYhRiP2wFxWJ98fo4WS2PvQ3vqUHjZebDC4qdN0cHAqU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(451199015)(316002)(6636002)(4326008)(2616005)(5660300002)(54906003)(122000001)(8936002)(38100700002)(41300700001)(36756003)(26005)(6512007)(186003)(91956017)(83380400001)(66556008)(76116006)(66476007)(66446008)(8676002)(66946007)(110136005)(64756008)(31686004)(31696002)(38070700005)(86362001)(2906002)(6486002)(6506007)(478600001)(53546011)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cUs2U3Bvamg2eURla3hVZTF6a25rQ05uZzRkMi9JV0R1bTBpUEFSa2VWUDJQ?=
 =?utf-8?B?MGc3cWgrRkpMSWtEa2xzY21uN1JUN3NQTWRRcDBEVUJIN2k3UDR3MkVOZzlk?=
 =?utf-8?B?RDQ4aEZJNExDc2MyRHVTZkp0ZS9NR3dnWHJEMURLbkxnM0RieCttZGNFdkxl?=
 =?utf-8?B?VEhPbGF5czdqREcvU09INklIa1lvbTRyWnJaKzdJTFhkSFJVVXFGNDdlRXMv?=
 =?utf-8?B?a0lORnlVOWloSi9rSGgwT1JsTVdsc3h5TTJuRU4vQ1FrTTdJY3BxSVJ4eHdL?=
 =?utf-8?B?Z0hZVFBYbHh5NDJ5VGlLZ1NMWGdJWVE5REJUelJBekl0NXVvb0x5ZTNjTmwz?=
 =?utf-8?B?Rk9pc1U3clpwc0dZUU8vcmhLUGdxZGFnSytjR1E1TWNNeUhSbDdZdVZnemVG?=
 =?utf-8?B?VFU3cnJSMkNOVTdVL1Y1eFphYTZvMTZ3cVNZQy9ERFJobGgvcEk3R29RUEpn?=
 =?utf-8?B?UEhQcFY1a3NyUTRFektLMDVaMFVvd0k2K1F0cGp3Uy9YYzBmVG52UVI0dzhw?=
 =?utf-8?B?c2Z4NVJRTG0wcDFqeFVSRndXUU9MZFVtMWFlampvd1luQTFhdG1VZ0FZSi9q?=
 =?utf-8?B?ZXdLZ2RxQTNzZ2dwWXZrUys2bUwyVFA2SnZ1MzRIQjlnOFZpZmhhTjlMVGZ3?=
 =?utf-8?B?czhZMzhhWmI3bmF4K1lCQzhQVFRKNVRyRVlMSVJoQjRzZ3VPNHR3WWFraVYw?=
 =?utf-8?B?QytReWoyUk9CTmx0aGJDQ2ovQU1BUlQ3SXRQZWxoQ0E2V3QwTElpMFJjS2NC?=
 =?utf-8?B?SU92Y3RYajFtQTV1aGlnYUFTV2dJd2MxRzNJLytrMVNOM0haRmUvMXFJaU9n?=
 =?utf-8?B?N1Y2dGZPL0d6VEc0V0xWTzJaRDFOd2NoR2hjMm82YlBBTUdpS004cVZvWkxQ?=
 =?utf-8?B?VVFsc0FlZ2hMR0dDZlRtNWF5ZjZPRDRCeFpnUU9Xb0Rjc2RPbTd6cVVwdG5v?=
 =?utf-8?B?d3cvRUlZa1VMUDN3NlY3T0h5dzg1bmVSMEVyYzZkVjZoSlhja0c4NEFTcFlU?=
 =?utf-8?B?dStlTytMQlRCUms5cWxCOW1ybkIyZlliNE1HN3NPem9XWWxEZDQxcGN5QVI2?=
 =?utf-8?B?VXB1UDBvN2MwVDFFKzVndjdFNnRpMWZtNWsvb0p5U0RrU1lOQUUxS0dmNU1F?=
 =?utf-8?B?cEFvbGVmS2ZkcVdPZmU2N3hSVU9kUVE4UHRkR0RiQktzZW1LU0Nua3I1QnB4?=
 =?utf-8?B?eUhBQmJtVFBWeXNqT1JnY1pqS3c4bDlUaFJPVUJmdGdocjgwbkN1Szdic3Mw?=
 =?utf-8?B?T21GOUVqazkxY2F2RDVDTUNrWkh5NEpndU9HWWVTYzAxa0JGalJmZ1JKN2x4?=
 =?utf-8?B?aDNtY3pGR1hmTEJtMUM0OW5ONWlRZWFEMCsyOENjWmJFVEVhQWt0UVF6N2s0?=
 =?utf-8?B?bmM2LytkWEtvT0NZaWJtRE51Z0w0c2lVcUdETE5qQy9BMk5OMExjSHU2Vnkv?=
 =?utf-8?B?K2xXcjRHN2JBR0dkYURCYWVwSTVsSzNYRXRNVnVPQU5oMExPTFZ6Ny8zenEr?=
 =?utf-8?B?ZDQzcWdlT0YrQy9DWkRyMnFmeGxzMDY5STl6V2hIVXAwQWlaTTFPVVBKZVdS?=
 =?utf-8?B?TU9aSEVzR3JQc0xPSWZUTGFnN0lZMHZrdFBPYmtxNzFXZzhibzJWMEVpVzdS?=
 =?utf-8?B?ZHQrZDVvdzh5WDF3WWgwMUlzd0Z1bDF4a2hNSi9tKzVLcVJkM1pwQ1ZsQStZ?=
 =?utf-8?B?czN0WFRxV1FzcHkxam9MU1ArZjE5dndsbSs1ZExqdSs3cW56UzZFa0p3TmtL?=
 =?utf-8?B?NW1SZ1BRam1zZExxSmREUW9PMDMxT1lsa3lPVDNjVDJ3d2I4TTZIdFFlalND?=
 =?utf-8?B?SnYvTkFsSDN5RFZMQTBPV09scHpLemVoc2hWcmdra05YcjF0eHZta0lPTnkz?=
 =?utf-8?B?b2kxU05FaXFSZkMyZ0lDWWVWOEFORytLMWc2enlVOTlvMlJXQ1pvSmRBd29u?=
 =?utf-8?B?cTNjVDJpS1RaZDAyTDZhWWU5YkVLUEtGZWVHYVkvYWdOclFHbDdacGJQQTBa?=
 =?utf-8?B?dFowa3ZqTFdVbkRid0RaWm54K0gvUkFzd0dyYWVsbkFQUitVVDY5bEZsbll0?=
 =?utf-8?B?Qkh6SGIrYkFpQjdxZEtydXd0Z01rU2YxWnRTMm1VdTJxMGdTSmJXUjJWUGdL?=
 =?utf-8?Q?60mvjptzRumcghHjHmIA3mcpW?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8AF7105E41369C489CCDB5C7ECA159F0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f80e2c0b-2e15-469b-01d1-08dafac99942
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 09:34:59.2644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rWk/zj9zzBIu1bdkG9g8NHRdN3lC4KMP9o6t0fWA6wws1z6qzzD47yioBsjqNZ2mtrZVlV+2Esy3QjkKg9F6+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4586
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzE5LzIzIDIzOjU3LCBKYWNvYiBLZWxsZXIgd3JvdGU6DQo+DQo+IE9uIDEvMTkvMjAy
MyAzOjMxIEFNLCBhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20gd3JvdGU6DQo+PiAraW50
IGVmeF9tYWVfbG9va3VwX21wb3J0KHN0cnVjdCBlZnhfbmljICplZngsIHUzMiB2Zl9pZHgsIHUz
MiAqaWQpDQo+PiArew0KPj4gKwlzdHJ1Y3QgZWYxMDBfbmljX2RhdGEgKm5pY19kYXRhID0gZWZ4
LT5uaWNfZGF0YTsNCj4+ICsJc3RydWN0IGVmeF9tYWUgKm1hZSA9IGVmeC0+bWFlOw0KPj4gKwlz
dHJ1Y3Qgcmhhc2h0YWJsZV9pdGVyIHdhbGs7DQo+PiArCXN0cnVjdCBtYWVfbXBvcnRfZGVzYyAq
bTsNCj4+ICsJaW50IHJjID0gLUVOT0VOVDsNCj4+ICsNCj4+ICsJcmhhc2h0YWJsZV93YWxrX2Vu
dGVyKCZtYWUtPm1wb3J0c19odCwgJndhbGspOw0KPj4gKwlyaGFzaHRhYmxlX3dhbGtfc3RhcnQo
JndhbGspOw0KPj4gKwl3aGlsZSAoKG0gPSByaGFzaHRhYmxlX3dhbGtfbmV4dCgmd2FsaykpICE9
IE5VTEwpIHsNCj4+ICsJCWlmIChtLT5tcG9ydF90eXBlID09IE1BRV9NUE9SVF9ERVNDX01QT1JU
X1RZUEVfVk5JQyAmJg0KPj4gKwkJICAgIG0tPmludGVyZmFjZV9pZHggPT0gbmljX2RhdGEtPmxv
Y2FsX21hZV9pbnRmICYmDQo+PiArCQkgICAgbS0+cGZfaWR4ID09IDAgJiYNCj4+ICsJCSAgICBt
LT52Zl9pZHggPT0gdmZfaWR4KSB7DQo+PiArCQkJKmlkID0gbS0+bXBvcnRfaWQ7DQo+PiArCQkJ
cmMgPSAwOw0KPj4gKwkJCWJyZWFrOw0KPj4gKwkJfQ0KPj4gKwl9DQo+PiArCXJoYXNodGFibGVf
d2Fsa19zdG9wKCZ3YWxrKTsNCj4+ICsJcmhhc2h0YWJsZV93YWxrX2V4aXQoJndhbGspOw0KPiBD
dXJpb3VzIGlmIHlvdSBoYXZlIGFueSByZWFzb25pbmcgZm9yIHdoeSB5b3UgY2hvc2Ugcmhhc2h0
YWJsZSB2cw0KPiBhbm90aGVyIHN0cnVjdHVyZSAoc3VjaCBhcyBhIHNpbXBsZXIgaGFzaCB0YWJs
ZSBvZiBsaW5rZWQgbGlzdHMgb3IgeGFycmF5KS4NCg0KDQpUaGUgbXBvcnRzIGNhbiBhcHBlYXIg
YW5kIGRpc2FwcGVhciAoYWx0aG91Z2ggaXQgaXMgbm90IHN1cHBvcnRlZCBieSB0aGUgDQpjb2Rl
IHlldCBub3IgYnkgY3VycmVudCBmaXJtd2FyZS9oYXJkd2FyZSkgc28gc29tZXRoaW5nIHJlc2l6
YWJsZSB3YXMgDQpuZWVkZWQgZm9yIHN1cHBvcnRpbmcgdGhpcyBpbiB0aGUgbmVhciBmdXR1cmUu
DQoNCg0KPiBBdCBhbnkgcmF0ZSwNCj4NCj4gUmV2aWV3ZWQtYnk6IEphY29iIEtlbGxlciA8amFj
b2IuZS5rZWxsZXJAaW50ZWwuY29tPg0KDQo=
