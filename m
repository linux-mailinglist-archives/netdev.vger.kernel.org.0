Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3FE48DBBB
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 17:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbiAMQ1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 11:27:44 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:2944 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232646AbiAMQ1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 11:27:44 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20DCNHrL005627;
        Thu, 13 Jan 2022 11:27:14 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2053.outbound.protection.outlook.com [104.47.61.53])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj0fcgvd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 11:27:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZtQTJi4DbzTao4wt6NdGGFeRrgux4DUNo9+PWlsyDtt8rFwLQ0y25cqLm8YTA0Be+cG73yy1lOHoNKl4FMGLEX1Ax9BToYK9/ZZQjA6q+qtl1lXQ+LmAkDHSucZBzya1KeXMPsNc4Fxy1Qoda/8tlvoP0Og91oJdN1/5LoNjYo/SqJOq13WqfaolGUikh0eOgsGI0S+A9A1VkCanx4ae4ToYb2feHqqzyypqq3diahwyY9aDuAkcLdrWhrI2ZNoFBR3CFE6Eb6STjGvrrOZYeYzkWMK1gEm4f7Gr4tU9R9TxViajG9UV7PFe3sQCxRO8xIBUsz+cyloX0c7dDQcXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=klQWVvSvkh/NEb0kLEXXFGhcHPU0l2TbHhSX6dmGEfQ=;
 b=YGp5MMSmOADk79BFlaOtlJHmqac1O3UdKSWhLB7y4uVGahM1B4V4hIHw92ysoFfzOQel0T1RKhO8XKrm/Gu7gcVtHdSyAow1ToEZRNYXYsKnY/gV7B1Nkg2nTgX6OOrKMjqKy7ecVmB3ZNgBBBaaM+tWMYc9AE1E2JRXjFZeAVFjLScA8nMoNorzzNCUvd3vrgXxtUgn0GieltjcZYQULbsi7H7PbLuJPmOTw5JwBUb5/fiYddm0DECE9++n21ixTwFyVybCyGPWqns1TnO2F3sY5BqBXyRbF3KTKsDY8N0Rub9ZBJH7FHq1kRdn/4xv6QodnvSRWjlr/WWyXsoUgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=klQWVvSvkh/NEb0kLEXXFGhcHPU0l2TbHhSX6dmGEfQ=;
 b=nNC/U0jrqktZkEg/btWwOwZ1tz0BEhkXeo9BFTBAb5obH+U/5ySqtZWQVC1NRGNGaabKPe8Fv/F8jj953OEsnb1jZ4BM8vOExhyvI4tnG48VsPoOv2xGmWjja9MmKRRDwHFAAmjbXyWNGz3cbOfAGImjq/vpp7CY10J9gWvbmk8=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB5299.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:2d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Thu, 13 Jan
 2022 16:27:12 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 16:27:11 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "radheys@xilinx.com" <radheys@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "ariane.keller@tik.ee.ethz.ch" <ariane.keller@tik.ee.ethz.ch>,
        "harinik@xilinx.com" <harinik@xilinx.com>
Subject: Re: [PATCH net v2 2/9] net: axienet: Wait for PhyRstCmplt after core
 reset
Thread-Topic: [PATCH net v2 2/9] net: axienet: Wait for PhyRstCmplt after core
 reset
Thread-Index: AQHYB9siTmd37dFHx06OgTrgb8NTyaxg2IoAgABMlIA=
Date:   Thu, 13 Jan 2022 16:27:11 +0000
Message-ID: <3cf8932154c2c162dc5bf4222c7f466119cfb623.camel@calian.com>
References: <20220112173700.873002-1-robert.hancock@calian.com>
         <20220112173700.873002-3-robert.hancock@calian.com>
         <SA1PR02MB8560F3EF51828D9065763968C7539@SA1PR02MB8560.namprd02.prod.outlook.com>
In-Reply-To: <SA1PR02MB8560F3EF51828D9065763968C7539@SA1PR02MB8560.namprd02.prod.outlook.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a609725-cbc2-4a16-0694-08d9d6b18d2c
x-ms-traffictypediagnostic: YQXPR01MB5299:EE_
x-microsoft-antispam-prvs: <YQXPR01MB529933EE99038BB181A93C22EC539@YQXPR01MB5299.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wb23Plwb7hvkSvBpLFFc0HHMz5a9beGcvbSCL42u6kdRxNHSPpvLYFaVCdlDCwOgUjhnMJVzRopobZ8y7Uu9mOzUa5lQIadxTXe99lqXEU15VQGpsMTF2mwnQlwo4KsfW2H28hLI9yr4buhEVgD5nR6Pr0PXnL1f8Cwj6zCRM13A4B01rmHcMFxRjA1tUqNJaXSQ/9IsetTF1jG2quDqNHlkQiT+lT/pf5HV+jGxNhJamGiwJubQfRT2y9Nz4VzozRHImuM2Wr7JYhz8rjJL+ZFMF/4k4kss8iBc809tj7QCgVdtbapjfnlWl4x9CmymKL4j8HGzIcIDjHYmPYJyQhXR7VMtjRwQyZHMW3xGJmR9sU3ItEbUPgRLNrt+zUikf/eRyZahBXSHNu5iM8rI+Jn7K2GM+CjjRuuriTgUHtpWnpsriFdtnwV2Wpb/2O/7Dm5yvM6yjjzkqrleyAmf7rfCpiB2G//ORVMcumJOmL5SongrJu22+Mqq4y3zcA+YmykDPBqIicE0a7qRPA6Rr8ffc5ANPKfuy0cRTY1RCZJ/s7GyGVI4sJneM5HlsS30IgrKDMC+778Oyy1iTwxgu1ovOqWCjq95KoRM5UKVyBp1bVaYKnRj7yUqbJ+bQ1JlX4bX7qNzo59wp56MGAoA7TraM2D2j2enEYSxqa1bhWXMvOYFzGzGEf8gYszrG6u5dCSA5zZZzH3+ZuIno7ORs81uNvSDncXfI93TPsBsp1cmHi4XncCwMPCdRHkqMpNTMCNBNXjEH3cdDlCEYsRucbH/x0zNP97iDnxk4BLJCRs6DAkS9/e31yrUEgBhbGMHNwJJ+6Uow5eqXql0BXpHtH9mIaQ9bdCzNe8wnyob5I0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(2906002)(8676002)(8936002)(44832011)(5660300002)(122000001)(36756003)(64756008)(66446008)(110136005)(66556008)(66476007)(54906003)(66946007)(76116006)(91956017)(316002)(15974865002)(6512007)(38100700002)(508600001)(2616005)(6486002)(6506007)(4326008)(86362001)(186003)(83380400001)(53546011)(38070700005)(26005)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkhOV0dnMUJEZEZMVVM5NFpLUXJ0VmZTNjBsS2UxTFhQeUVkZlF0ajAwS0tj?=
 =?utf-8?B?UmZwNHFCVlhYL0VpdS9wK2NQSFB1VEhMdmYxQWJ5eWlWQm5nT3ZLRGt0akxR?=
 =?utf-8?B?VnhyRWprMXVnZFVsdjJWT1NlVGNVR3Urc1FpS1VXOXlEOHBsb0VvTjVuN3lM?=
 =?utf-8?B?MllMS2YvZldVM0ZsSUFZMHZRbzhia3Uxd1d4ZU5ObmRaZDBsTHl1USs0Tytt?=
 =?utf-8?B?SUhNaVgxM29HRVMzNjVaU1ZyMGNDamNMZFEvdkxLdGZ6cWY3RzBxZitSVlE1?=
 =?utf-8?B?TFhGNUJibVRUSXNOMVQrMHAyYVNLTnc1VlVXcTlzaVpGb3BoQWwzdStyNDJa?=
 =?utf-8?B?a2JMaCtKeDh1WjBKTklFMEN4UiszZEZyM2tYcUNJblNaYUs4SmYxU0U0Vjdj?=
 =?utf-8?B?Q1htZ0ozdkhDV1EzMVZrZitMYWZ2QlhTVElzbkx3ME9wVFI2MVVaTWl5dGRm?=
 =?utf-8?B?NEhqdGlEbTQ4NGY1UzhNY3FGZWR4YjhBS0l1SGs2QTVrYWlKQUE3d3dhQ2Z2?=
 =?utf-8?B?cUs3ZWdBY3ZjQ2NySVVUMnRzVFNKOGRLcUZMRWJRWTllQ2hZUUVVdTRGRUxF?=
 =?utf-8?B?Vkh6T2NqRWxHbU5WNjRIazUzWTVrdFp0Y3VwTUE2V2lYdVNTd3Irc2ZWRnR5?=
 =?utf-8?B?RGEwR2lUL1hMN1R4ZEV0S3cxZkU4VURUQjhFZTB5YjVIc0ozWTdKSHJVTjh4?=
 =?utf-8?B?V2dMd1lZY0RmZ2Fhb0RnN1F0WVlrMHZUWjB0dWg3L3RXaTQrVUg0eTVROEk4?=
 =?utf-8?B?NVZKWE1IYVMvVEQ5R2F4Q1RMVEwzVEVQVkk2dThaTWx4ZVBJVFhaMVNlRlVj?=
 =?utf-8?B?ZFYyNkhFOWtpb0tOL0l5azNjNlg1Qi80anBBVGlKd29UNWNTUnhEaFQycGw2?=
 =?utf-8?B?S2psS3c0VktPWThpaExkQ0srSW43OUl5MGZqM0szWXBpSGtoOGRUc3ZyZitR?=
 =?utf-8?B?RXd6Z2lBTEU0bnZPeXBzanhhSjV0Q3NTcmR1RTBHYkM0Uk5HUEs4SFFKaFp0?=
 =?utf-8?B?bHU4RjdqRDR2TmxlNE9PM1o3emJLdXVaRlRLRnFyMW8zdFlrTG1qbUViRG9K?=
 =?utf-8?B?YjlKT3pBdEdGTjJ1VDR5cEIxdnRudTUvcTdwUWRjTW1jcEZRQ1Y0N3pPNW1M?=
 =?utf-8?B?eGZFcUc5NWxrc1hZSzU1SWQ3VEJwL29mbStPSmJuc3hEaTRTVWtVcjBWSmpL?=
 =?utf-8?B?WVNnSkdlTmp4SUNpY0FNZWRyUE92WHJVMVAwNWNEOC9xNVNPVkwxNlNBTGhk?=
 =?utf-8?B?QWtEN01XZ0s3em1ZYlBPMnNrVGkySmxnYWw5bXNhZGNDNHdoeFg5bldlbGlM?=
 =?utf-8?B?OHgvVGpMN2JYcVZKSVNTVG8vQ2VvU2FBRlJoNEozUThNYWwyTmtQdkZnS0NB?=
 =?utf-8?B?RlhLV25UaUlkaTZnNXhiVndDVVpBRmMrRXoxMG52Q2FBRjBNREpXZ21MN01W?=
 =?utf-8?B?K3dtbGRJbVBsajBpY2RWNW14cEpyQWlmNmlDODFlcDFBYm9pUk9nRHZxSDVZ?=
 =?utf-8?B?YTJBcllJN2NnU2F1K29hemRldk1WU0NLaWtzdHNBb0M4QjBpdlZBVFp6L0dh?=
 =?utf-8?B?TitCYkM0SVNMbjRYa3R2WjZZSHN1ZW5FMXI4ZlZVRzZGWlRVZU9kNUwxdWdV?=
 =?utf-8?B?Y05KTUhEVEwrTTBmbUMxaFRvY3dadlZuc0x6ZEFyRWtkRWF2Kzh6Vk9iN0d5?=
 =?utf-8?B?VEpSM2hqS0FtYjA1SXJoL2hwMEtXRVMvMjdsN00rd2RTTjJNaWl6bUxuVHNY?=
 =?utf-8?B?S21nS3ZINDBYb1ViS1FRRjkwaTNQc1o3bmlKYnJLZWFNSjRrUjdTai9iM1VV?=
 =?utf-8?B?V2VuVWVPdTdFN1BDQzNOYVN6SU8yaTE1aDZXQXJWQ0QybndTVEdHVTgxM212?=
 =?utf-8?B?dUlzbWFteU04a01uSUxYOC80NGt5SDZ3dVhDVUNTWG12OUtRZVdsUkFIN2Zx?=
 =?utf-8?B?NWRNV0JYd0ZCNWFxcWxENzRzeHc1VkxGRnJlcndJRVdoUEZqNzROYXBKK1Zq?=
 =?utf-8?B?M2RCaTVIV0cwUmhCSU01cndlbldFOGRQVklQdEtUa2FxUG16UlhiL3hPcGJp?=
 =?utf-8?B?dFNyUEJSQ3o1dGRnTnJOazNQRmE2OXJRaHpmQ1VheG41NXBpdXNUR043TCta?=
 =?utf-8?B?ZnRRcGttc1VHS0VuTmd3VnZzK1l4c04vZHAydVBCYmh2alZ3U1FCZFVERXlq?=
 =?utf-8?B?UEswRWNKSWdKNkx2N1dVNkVEdFd3U3I2WWV5RzZneVV2elp1VlU1cmZMdlo4?=
 =?utf-8?Q?8ulUC3f1LMjCIt/KYvmPDxCuqEy/4tSK+PkCR3s+SA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <30B7F94925359F48B54C83E55D26B338@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a609725-cbc2-4a16-0694-08d9d6b18d2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 16:27:11.5039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XO1G1kTOfzkgLruCTcxZtjkWrf/r0odRqrhAyLSoCQS/tRsrD93ZL3146nVt33dXW9BIHD3z71edhfKlA9KVsdo4Y4kBcNgvA4c9gkzigOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB5299
X-Proofpoint-GUID: 3nzWdfDD1g_pp8ab_ldMtGjAt1J4ABn8
X-Proofpoint-ORIG-GUID: 3nzWdfDD1g_pp8ab_ldMtGjAt1J4ABn8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_08,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTAxLTEzIGF0IDExOjUzICswMDAwLCBSYWRoZXkgU2h5YW0gUGFuZGV5IHdy
b3RlOg0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogUm9iZXJ0IEhh
bmNvY2sgPHJvYmVydC5oYW5jb2NrQGNhbGlhbi5jb20+DQo+ID4gU2VudDogV2VkbmVzZGF5LCBK
YW51YXJ5IDEyLCAyMDIyIDExOjA3IFBNDQo+ID4gVG86IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcN
Cj4gPiBDYzogUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5c0B4aWxpbnguY29tPjsgZGF2ZW1A
ZGF2ZW1sb2Z0Lm5ldDsNCj4gPiBrdWJhQGtlcm5lbC5vcmc7IGxpbnV4LWFybS1rZXJuZWxAbGlz
dHMuaW5mcmFkZWFkLm9yZzsgTWljaGFsIFNpbWVrDQo+ID4gPG1pY2hhbHNAeGlsaW54LmNvbT47
IGFyaWFuZS5rZWxsZXJAdGlrLmVlLmV0aHouY2g7IGRhbmllbEBpb2dlYXJib3gubmV0Ow0KPiA+
IFJvYmVydCBIYW5jb2NrIDxyb2JlcnQuaGFuY29ja0BjYWxpYW4uY29tPg0KPiA+IFN1YmplY3Q6
IFtQQVRDSCBuZXQgdjIgMi85XSBuZXQ6IGF4aWVuZXQ6IFdhaXQgZm9yIFBoeVJzdENtcGx0IGFm
dGVyIGNvcmUNCj4gPiByZXNldA0KPiA+IA0KPiA+IFdoZW4gcmVzZXR0aW5nIHRoZSBkZXZpY2Us
IHdhaXQgZm9yIHRoZSBQaHlSc3RDbXBsdCBiaXQgdG8gYmUgc2V0DQo+ID4gaW4gdGhlIGludGVy
cnVwdCBzdGF0dXMgcmVnaXN0ZXIgYmVmb3JlIGNvbnRpbnVpbmcgaW5pdGlhbGl6YXRpb24sIHRv
DQo+ID4gZW5zdXJlIHRoYXQgdGhlIGNvcmUgaXMgYWN0dWFsbHkgcmVhZHkuIFRoZSBNZ3RSZHkg
Yml0IGNvdWxkIGFsc28gYmUNCj4gPiB3YWl0ZWQgZm9yLCBidXQgdW5mb3J0dW5hdGVseSB3aGVu
IHVzaW5nIDctc2VyaWVzIGRldmljZXMsIHRoZSBiaXQgZG9lcw0KPiANCj4gSnVzdCB0byB1bmRl
cnN0YW5kIC0gY2FuIHlvdSBzaGFyZSA3LSBzZXJpZXMgZGVzaWduIGRldGFpbHMuDQo+IEJhc2Vk
IG9uIGRvY3VtZW50YXRpb24gLSBUaGlzIE1ndFJkeSBiaXQgaW5kaWNhdGVzIGlmIHRoZSBURU1B
QyBjb3JlIGlzDQo+IG91dCBvZiByZXNldCBhbmQgcmVhZHkgZm9yIHVzZS4gSW4gc3lzdGVtcyB0
aGF0IHVzZSBhbiBzZXJpYWwgdHJhbnNjZWl2ZXIsIA0KPiB0aGlzIGJpdCBnb2VzIHRvIDEgd2hl
biB0aGUgc2VyaWFsIHRyYW5zY2VpdmVyIGlzIHJlYWR5IHRvIHVzZS4NCg0KRnJvbSB3aGF0IEkg
c2F3LCB0aGUgYml0IGJlaGF2ZWQgYXMgZGVzY3JpYmVkIG9uIFp5bnFNUCB3aGVyZSBpdCB3b3Vs
ZCBnbyB0byAxDQpkdXJpbmcgaW5pdGlhbGl6YXRpb24sIGJ1dCBvbiBhIEtpbnRleC03IGRlc2ln
biB3aXRoIHRoaXMgY29yZSwgdGhlIGJpdCBuZXZlcg0Kc2VlbWVkIHRvIGdvIHRvIDEgdW50aWwg
YW4gYWN0dWFsIGxpbmsgd2FzIGVzdGFibGlzaGVkIG9uIHRoZSB0cmFuc2NlaXZlciwgc28NCml0
IHdhc24ndCByZWFsbHkgdXNhYmxlIGluIHRoaXMgc2l0dWF0aW9uLg0KDQo+IA0KPiBBbHNvIGlm
IHdlIGRvbid0IHdhaXQgZm9yIHBoeSByZXNldCAtIHdoYXQgaXMgdGhlIGlzc3VlIHdlIGFyZSBz
ZWVpbmc/DQoNClRoaXMgaXMgbW9yZSBmb3IgdGhlIGNhc2Ugb2YgdXNpbmcgYW4gZXh0ZXJuYWwg
UEhZIGRldmljZSAtIHdlIHNob3VsZG4ndCBiZQ0KcHJvY2VlZGluZyB0byBNRElPIGluaXRpYWxp
emF0aW9uIGFuZCBwb3RlbnRpYWxseSB0cnlpbmcgdG8gdGFsayB0byB0aGUgUEhZDQp3aGVuIGl0
IGlzIHBvdGVudGlhbGx5IHN0aWxsIGluIHJlc2V0Li4NCg0KPiANCj4gPiBub3QgYXBwZWFyIHRv
IHdvcmsgYXMgZG9jdW1lbnRlZCAoaXQgc2VlbXMgdG8gYmVoYXZlIGFzIHNvbWUgc29ydCBvZg0K
PiA+IGxpbmsgc3RhdGUgaW5kaWNhdGlvbiBhbmQgbm90IGp1c3QgYW4gaW5kaWNhdGlvbiB0aGUg
dHJhbnNjZWl2ZXIgaXMNCj4gPiByZWFkeSkgc28gaXQgY2FuJ3QgcmVhbGx5IGJlIHJlbGllZCBv
bi4NCj4gPiANCj4gPiBGaXhlczogOGEzYjdhMjUyZGNhOSAoImRyaXZlcnMvbmV0L2V0aGVybmV0
L3hpbGlueDogYWRkZWQgWGlsaW54IEFYSQ0KPiA+IEV0aGVybmV0DQo+ID4gZHJpdmVyIikNCj4g
PiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnQgSGFuY29jayA8cm9iZXJ0LmhhbmNvY2tAY2FsaWFuLmNv
bT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGll
bmV0X21haW4uYyB8IDEwICsrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2Vy
dGlvbnMoKykNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQveGls
aW54L3hpbGlueF9heGllbmV0X21haW4uYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQveGls
aW54L3hpbGlueF9heGllbmV0X21haW4uYw0KPiA+IGluZGV4IGY5NTAzNDJmNjQ2Ny4uZjQyNWE4
NDA0YTliIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxp
bnhfYXhpZW5ldF9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngv
eGlsaW54X2F4aWVuZXRfbWFpbi5jDQo+ID4gQEAgLTUxNiw2ICs1MTYsMTYgQEAgc3RhdGljIGlu
dCBfX2F4aWVuZXRfZGV2aWNlX3Jlc2V0KHN0cnVjdCBheGllbmV0X2xvY2FsDQo+ID4gKmxwKQ0K
PiA+ICAJCXJldHVybiByZXQ7DQo+ID4gIAl9DQo+ID4gDQo+ID4gKwkvKiBXYWl0IGZvciBQaHlS
c3RDbXBsdCBiaXQgdG8gYmUgc2V0LCBpbmRpY2F0aW5nIHRoZSBQSFkgcmVzZXQgaGFzDQo+ID4g
ZmluaXNoZWQgKi8NCj4gPiArCXJldCA9IHJlYWRfcG9sbF90aW1lb3V0KGF4aWVuZXRfaW9yLCB2
YWx1ZSwNCj4gPiArCQkJCXZhbHVlICYgWEFFX0lOVF9QSFlSU1RDTVBMVF9NQVNLLA0KPiA+ICsJ
CQkJREVMQVlfT0ZfT05FX01JTExJU0VDLCA1MDAwMCwgZmFsc2UsIGxwLA0KPiA+ICsJCQkJWEFF
X0lTX09GRlNFVCk7DQo+ID4gKwlpZiAocmV0KSB7DQo+ID4gKwkJZGV2X2VycihscC0+ZGV2LCAi
JXM6IHRpbWVvdXQgd2FpdGluZyBmb3IgUGh5UnN0Q21wbHRcbiIsDQo+ID4gX19mdW5jX18pOw0K
PiA+ICsJCXJldHVybiByZXQ7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICAJcmV0dXJuIDA7DQo+ID4g
IH0NCj4gPiANCj4gPiAtLQ0KPiA+IDIuMzEuMQ0KLS0gDQpSb2JlcnQgSGFuY29jaw0KU2VuaW9y
IEhhcmR3YXJlIERlc2lnbmVyLCBDYWxpYW4gQWR2YW5jZWQgVGVjaG5vbG9naWVzDQp3d3cuY2Fs
aWFuLmNvbQ0K
