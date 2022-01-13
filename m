Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A5848DBA3
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 17:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbiAMQXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 11:23:21 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:58035 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229533AbiAMQXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 11:23:21 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20DCHw2q027594;
        Thu, 13 Jan 2022 11:22:53 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2057.outbound.protection.outlook.com [104.47.61.57])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2ghw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 11:22:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qgm6myIHkUqbiNBraBpS0qwAchQ64hmeZ1nBPEVyIJAmTDQs7eZ7wg2stPUcpx5cj/rfZ7xqyee7Dw//doYNXm42kYy34P82mIorYV3TMqmBpQLS3lLeiEdr1v1M4pNEnDmAHnVufZ89U5vlESJeNGKSCjruBHl4ZlfhxF4+v3UPSwnAlEl0B45je3TGErcfV+Y1Z7IFU04t/QbyDx0LdM9qr+P3UtPMrrr2isZFY2+8jNW+Z2ez8VPVsKabRA/lCFKP8DS00Pun4qUE3WL89VczFaghzpggZNFjCDgHblQpAc58RvLBBC8CBgwks/oMzwG008pLb7BN57HkliBgew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L2OI1iqulPsi90Q0EUANhgu9bSpZ012j5BRxiXNNk+E=;
 b=IQUVISXpfTKGg0dlOY9VjhiEe0T1Io7sRjFFT6oNJs+fNuERCP8xOdSpkZoBtaA29L5ew34AUsYOlHsT6j3E8ApaTddNH2CYeggxkBo/jBPnxYX2T9W2eK8JLUODt3nrZ/LnvgKMKyVlyZLGx3R0zcuR0h3PJ35hyuB0NNzQKwCWAGmye8Vn4Alv71SZqleHLJVW0y9rhLyQ/DyaHc0t7ZJNf6tbMWBB/o1jNcvJU/ckQPYcR6NDk9PUh/7tDQQr+LcsanO5kNf1O+WCWY1vFdx2WNA9L5jZMSaJCr807zWzanq5o3u9P4OwoUyd9tZQxVsQ0Fsx7Sv73cmKb8Zujw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2OI1iqulPsi90Q0EUANhgu9bSpZ012j5BRxiXNNk+E=;
 b=EQ4FKjbV1zXMGHAEgjdFeztWHJOUZGbuAuBixQeRz6snsE42IdJbuzp7HfWNcV0y5QcyeH60Xg+UvYkPalGCubAy7698hkVR7835g00Tz4tPiu6xnuqq+frqL5WsapdM51axKj3e8mwza7xPp08H7KMTfA0X6R7pkVQxSMXfAS0=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB4384.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:34::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Thu, 13 Jan
 2022 16:22:52 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 16:22:52 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "radheys@xilinx.com" <radheys@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "ariane.keller@tik.ee.ethz.ch" <ariane.keller@tik.ee.ethz.ch>
Subject: Re: [PATCH net v2 4/9] net: axienet: add missing memory barriers
Thread-Topic: [PATCH net v2 4/9] net: axienet: add missing memory barriers
Thread-Index: AQHYB9sjIj35bqMc90a5bTYEAQqtUqxg3SyAgABGuwA=
Date:   Thu, 13 Jan 2022 16:22:51 +0000
Message-ID: <1596c9878c684dd559abe9088c7d90daa76b1f57.camel@calian.com>
References: <20220112173700.873002-1-robert.hancock@calian.com>
         <20220112173700.873002-5-robert.hancock@calian.com>
         <SA1PR02MB85604DE700BA8511C604B632C7539@SA1PR02MB8560.namprd02.prod.outlook.com>
In-Reply-To: <SA1PR02MB85604DE700BA8511C604B632C7539@SA1PR02MB8560.namprd02.prod.outlook.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54c6e04a-cdcc-40b6-c004-08d9d6b0f277
x-ms-traffictypediagnostic: YT2PR01MB4384:EE_
x-microsoft-antispam-prvs: <YT2PR01MB43843D1C7C0160F8763CF7D7EC539@YT2PR01MB4384.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZY77LryfDRY3EwL5lDUq5dEoh0aIiLBmK7f/cILsQTlKaCOHFcZ4zOLI6U8erc70ZrzyszZ/JwB5bhICfQe8VIU8uzRo9pBOTipy2YMCp+f+6iSdLAvKkRpUDIyH6rv3aszyklGZiEaYXBL00AxN7C1e020AjbhLEJfQwcB6e4aI8TI1POvK+AuPByq98Pcx/9jzWGI9mKbXh5TYJE2Y1GGiSe0dk3ZzxnOzCl9Z2KCRAYBdjJptEwXifH62OCasMiwAbTE1znGM2VztuXTf9ExsWm7/H1fELMpFOkgLzl42bFiFaT8IXEtc+gUhq4UxowKoI56ZHBYiRwgjxL2u2vtNlYb6Qi9DBvPK0HOFYqkCwosM2PclpJxgBQatpAZy85pYFBhl4XaQsWTSIWFDIpt5NCxnpGyPKnOkg73CYoTPSbTKol6dgDpkHYXbGV8nDYRBtKsZCHPhOaIf7J7euSgjJEL1KaojAPoNuArIBkUEdSBKMDLzbm42iN1Po8Ipa+fHFG7re56sm/NOU8pJF7LFlMY6BeZpbA9vqi8m6UUPrIjFNSX8rgM6TEwzgvDSUtQ4LEeOfaIGI+7r5HJ9KJBItmuQv8mRBEZHgx/yB1CzEvo6YGhkgMMHCwZIkuxOySWkXPQKhqikCq2AP8sDCGGWGcT1etTT6P5+cO3qR/bg+ULkvD0toMkcrYqBOHgrsywcsDwYEM+TT7vAEExPdyKKhXcxGvlAGV9AY0qRmZEP7m89G99vunViDTtGLE/n1ywxlUByNL9sio+nH7TxI8gvvwgfO/MPLk6+CH7Gdhldrd77sF7TwdW5qlTARYMa5DdO6V6cs/x+7ax3rz71Tw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(66946007)(15974865002)(44832011)(66556008)(64756008)(66446008)(110136005)(91956017)(76116006)(6486002)(54906003)(316002)(66476007)(2616005)(6506007)(508600001)(53546011)(186003)(4326008)(38070700005)(71200400001)(122000001)(83380400001)(6512007)(8676002)(38100700002)(26005)(8936002)(36756003)(2906002)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RzRLREF6M2tkZXA3NVR5T2JmV1oweWZsZDFSbE1tK3p6d3JPWDE4N2ZyanlH?=
 =?utf-8?B?aW1aQWpUN2VKV0lBd1J5S01mM0tKdjJFVjJMS1lIbFBOY25ieElhL1AvRWlF?=
 =?utf-8?B?THAxcitXVjJXUXJlR2x2UEkvUVZwbE9lVU5DeHBHQVhjY3R1MFE3SUgwdWpC?=
 =?utf-8?B?OTM2ZTAvbWI1YUhZL1ZFQStiMmFyUDBBSVRqK0src0FPZk5uMWVheXZCMHkr?=
 =?utf-8?B?d1NWUWltV28yYTc0VUFGL0owdDhzMnA3dmVkaENuRkd1RzVucmtGbEdHRW1j?=
 =?utf-8?B?VkhoQ2hNVGFxTXRJcTlkU1g3aXBEUDhPQUNVdlMzVEtQaCtXelR4SjdLRnBH?=
 =?utf-8?B?clJJMjZlWEFzMVJ3VktXZ3JYdFZlcVRHeXRsMWtjN0V1M25TSXFkdmFCdVp1?=
 =?utf-8?B?Tk92czc3ZU9TL2F3cHFmdHE5Q01ySUJuYVpmREtmZWxKOFlHQlRYQ0owa1lQ?=
 =?utf-8?B?bUovRWpWbTNBS3VJTUFWSU1iMFlwM3ptYm9xdjRxT00ydHhGMVFRUmdGNFdr?=
 =?utf-8?B?cFFIUTl1T3RPaSs4WjRrOHJNU1BVMFBFTmhaM0pLRENmdFBzdlE2NmxUaW1M?=
 =?utf-8?B?eG10S0N4ZFRjUGpOQVJyeTJNNkJpRzM2ZDYzUjR1N0FzNjB5cjh5eFYzY1F3?=
 =?utf-8?B?S2JFMWhMY3AyUzJKcTZrTFVrcC8xUE9LOUV4cVdXUE1TTy9aMUNvNFVKaHRW?=
 =?utf-8?B?RmYrWE9ReVVXTFAwdE8waUZ1dTBMako4ZWNMYjZQb1ZGZ3ZyUWJHVVlQdDho?=
 =?utf-8?B?akJjOWNKWHowYlpHZkRpSDZtZ0MyQkNWYnk3VzRINVNoZGxNNTI4UDdFSkdR?=
 =?utf-8?B?SmhVVDF4UDI1Y04rNmtWbEs5L29yNzJ1Sk5TYkVIS1NTRzRUNmdEYkpQSnhM?=
 =?utf-8?B?WHJVai9Ga01YUnJacDdyOWJxVTlvTDRlY1YvSndvYjBDQlRiMlNsWUhmWWkx?=
 =?utf-8?B?cU9kZFFKdGxOZjZpckVmR2NFMEhGV0M4anBEUTl5T0VvdVRvSWtGL2Y0c1po?=
 =?utf-8?B?UkFoYlBqVTZQVDJOdmtNTW14NGZmU0hqZlBld0prQ3lBbFJoZHE4enNtMEsw?=
 =?utf-8?B?UFVUdFd6ZkUwNVRiTHhrd0hDZGRFbWxJSDdmeUVXWGxnZnJOcmlCeENqeDM1?=
 =?utf-8?B?dDJGc2oxVWRJYnc5WXZucVRoVlZxc3J6V2NzVnpuUWx4MWd1VWQrYmVWZjIv?=
 =?utf-8?B?Q0ozeWZLOWtIWDZHNkV6VFl2VVFtbHJlZ2d3UTN2eDRLUDhzendXdEd1aVpw?=
 =?utf-8?B?bGRudDNMejl0SGp1TDVTbGJrUFlnU2ZjNWFtUyt3TjdWWXhCMitVbFkvam1O?=
 =?utf-8?B?bWpTR1F1QnNjQ3gzcEpXMG5YQUNmbi9yaE5JNTN5bFpwdGJQSm50TVR6UTNt?=
 =?utf-8?B?Y1B6OGJXeU1kNFpYNXR3Vk1FUmU2bTA5RDhqTEd5WHVRd0lab2RoZlp6b2lx?=
 =?utf-8?B?N1VvNWNCTWRaZzZrSGZRa2pCcmZoR3ZkZGJmcHpWSDZPUmR5ckhtTDFTRkcz?=
 =?utf-8?B?cXhjWGZyQWNUcVNYYzl5TWxiTnJSMVdLTG4xTUtDZitVaUxBa1pDc1hSWGVG?=
 =?utf-8?B?djJYNG4wS1Yxc09uTktyVDRMcm14ZVNvV1dIYS9JZEdBeUl4WmFlUzJSdVlt?=
 =?utf-8?B?eG9SVWlvdG1VZ0tyMW1ReWRRVGFLODlkRm1NV3c3WDVQY1pZR2J0OU5ZVGxk?=
 =?utf-8?B?SVlETTFFZkE3MzB0MmFyV3RPaHV4NCt2aFlTbSsxd2IyQ201aDB5OE8yd0x3?=
 =?utf-8?B?dW50Q1FBaFllbFpXc0RacGdtVE4yRTlPQ3RjNUVkVUovREhsZzRyeE8xbE5x?=
 =?utf-8?B?K1NYLzNEWEptMHpQZHhoazUrczk2ZFk2eG1wOXJ5aU5nWkx4NnRZRXVSRGl1?=
 =?utf-8?B?c1QrdG9icHU0WVU5YnNwRmxZa01xa3IxRk1IRXdkUWFPUHFvQkZ3QmdZZHBL?=
 =?utf-8?B?aUNsS0hJdGk1eU1abHFZdWtaRTZIL2MvTS96T080WHdFRFpzOU4vbXRsRlV2?=
 =?utf-8?B?M1c4RVVzanE3WTZOcHNGT0xEcnRyLzFVRFNQU2VRNzMzMHZhWUVhUWhtdUw2?=
 =?utf-8?B?Yno1SFh3L2lhVDZCZzNRbHpnbHlFc05VSVJ2elR1VlU0cFUxc2NIc1plQ1JT?=
 =?utf-8?B?b1BTcW94cTlpZkR0T2p0bzhXR2JpeDd4SHc4c0crd29GeldIc2NSb0w4aDVh?=
 =?utf-8?B?Z2N6MDI0OUdTSlZvblVtTVBDYmt1M2JXV21uRVZDaUdVRGpEYy9Eb1dqOU53?=
 =?utf-8?Q?6U+yiflIT2Enk7dJjBfUs8SWfP8147VwAm1kpM0pKg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D2303561D340446AE5AEB4B4AC56321@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 54c6e04a-cdcc-40b6-c004-08d9d6b0f277
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 16:22:51.9207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qaVD+RijOHRa8TIq7MRyXoiZGwwCXNk45Vw4TBX22M6+Gg/3lc2N9Nrofc3TwC4T+pYPRzcDYW4qKmw4Aj5AXgkROKFQFT4elnP2nVCnfY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB4384
X-Proofpoint-GUID: U_RuugaaFw5SFNzZYWZ2cQHTOxMt9xwV
X-Proofpoint-ORIG-GUID: U_RuugaaFw5SFNzZYWZ2cQHTOxMt9xwV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_08,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=831
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTAxLTEzIGF0IDEyOjA5ICswMDAwLCBSYWRoZXkgU2h5YW0gUGFuZGV5IHdy
b3RlOg0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogUm9iZXJ0IEhh
bmNvY2sgPHJvYmVydC5oYW5jb2NrQGNhbGlhbi5jb20+DQo+ID4gU2VudDogV2VkbmVzZGF5LCBK
YW51YXJ5IDEyLCAyMDIyIDExOjA3IFBNDQo+ID4gVG86IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcN
Cj4gPiBDYzogUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5c0B4aWxpbnguY29tPjsgZGF2ZW1A
ZGF2ZW1sb2Z0Lm5ldDsNCj4gPiBrdWJhQGtlcm5lbC5vcmc7IGxpbnV4LWFybS1rZXJuZWxAbGlz
dHMuaW5mcmFkZWFkLm9yZzsgTWljaGFsIFNpbWVrDQo+ID4gPG1pY2hhbHNAeGlsaW54LmNvbT47
IGFyaWFuZS5rZWxsZXJAdGlrLmVlLmV0aHouY2g7IGRhbmllbEBpb2dlYXJib3gubmV0Ow0KPiA+
IFJvYmVydCBIYW5jb2NrIDxyb2JlcnQuaGFuY29ja0BjYWxpYW4uY29tPg0KPiA+IFN1YmplY3Q6
IFtQQVRDSCBuZXQgdjIgNC85XSBuZXQ6IGF4aWVuZXQ6IGFkZCBtaXNzaW5nIG1lbW9yeSBiYXJy
aWVycw0KPiA+IA0KPiA+IFRoaXMgZHJpdmVyIHdhcyBtaXNzaW5nIHNvbWUgcmVxdWlyZWQgbWVt
b3J5IGJhcnJpZXJzOg0KPiA+IA0KPiA+IFVzZSBkbWFfcm1iIHRvIGVuc3VyZSB3ZSBzZWUgYWxs
IHVwZGF0ZXMgdG8gdGhlIGRlc2NyaXB0b3IgYWZ0ZXIgd2Ugc2VlDQo+ID4gdGhhdA0KPiA+IGFu
IGVudHJ5IGhhcyBiZWVuIGNvbXBsZXRlZC4NCj4gPiANCj4gPiBVc2Ugd21iIGFuZCBybWIgdG8g
YXZvaWQgc3RhbGUgZGVzY3JpcHRvciBzdGF0dXMgYmV0d2VlbiB0aGUgVFggcGF0aCBhbmQgVFgN
Cj4gPiBjb21wbGV0ZSBJUlEgcGF0aC4NCj4gPiANCj4gPiBGaXhlczogOGEzYjdhMjUyZGNhOSAo
ImRyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueDogYWRkZWQgWGlsaW54IEFYSQ0KPiA+IEV0aGVy
bmV0DQo+ID4gZHJpdmVyIikNCj4gPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnQgSGFuY29jayA8cm9i
ZXJ0LmhhbmNvY2tAY2FsaWFuLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQveGlsaW54L3hpbGlueF9heGllbmV0X21haW4uYyB8IDExICsrKysrKysrKystDQo+ID4gIDEg
ZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9t
YWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9t
YWluLmMNCj4gPiBpbmRleCBmNGFlMDM1YmVkMzUuLmRlOGY4NTE3NWE2YyAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5jDQo+
ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21haW4u
Yw0KPiA+IEBAIC02MzIsNiArNjMyLDggQEAgc3RhdGljIGludCBheGllbmV0X2ZyZWVfdHhfY2hh
aW4oc3RydWN0IG5ldF9kZXZpY2UNCj4gPiAqbmRldiwgdTMyIGZpcnN0X2JkLA0KPiA+ICAJCWlm
IChucl9iZHMgPT0gLTEgJiYgIShzdGF0dXMgJg0KPiA+IFhBWElETUFfQkRfU1RTX0NPTVBMRVRF
X01BU0spKQ0KPiA+ICAJCQlicmVhazsNCj4gPiANCj4gPiArCQkvKiBFbnN1cmUgd2Ugc2VlIGNv
bXBsZXRlIGRlc2NyaXB0b3IgdXBkYXRlICovDQo+ID4gKwkJZG1hX3JtYigpOw0KPiA+ICAJCXBo
eXMgPSBkZXNjX2dldF9waHlzX2FkZHIobHAsIGN1cl9wKTsNCj4gPiAgCQlkbWFfdW5tYXBfc2lu
Z2xlKG5kZXYtPmRldi5wYXJlbnQsIHBoeXMsDQo+ID4gIAkJCQkgKGN1cl9wLT5jbnRybCAmDQo+
ID4gWEFYSURNQV9CRF9DVFJMX0xFTkdUSF9NQVNLKSwgQEAgLTY0NSw4ICs2NDcsMTAgQEAgc3Rh
dGljIGludA0KPiA+IGF4aWVuZXRfZnJlZV90eF9jaGFpbihzdHJ1Y3QgbmV0X2RldmljZSAqbmRl
diwgdTMyIGZpcnN0X2JkLA0KPiA+ICAJCWN1cl9wLT5hcHAxID0gMDsNCj4gPiAgCQljdXJfcC0+
YXBwMiA9IDA7DQo+ID4gIAkJY3VyX3AtPmFwcDQgPSAwOw0KPiA+IC0JCWN1cl9wLT5zdGF0dXMg
PSAwOw0KPiA+ICAJCWN1cl9wLT5za2IgPSBOVUxMOw0KPiA+ICsJCS8qIGVuc3VyZSBvdXIgdHJh
bnNtaXQgcGF0aCBhbmQgZGV2aWNlIGRvbid0IHByZW1hdHVyZWx5IHNlZQ0KPiA+IHN0YXR1cyBj
bGVhcmVkICovDQo+ID4gKwkJd21iKCk7DQo+ID4gKwkJY3VyX3AtPnN0YXR1cyA9IDA7DQo+IA0K
PiBBbnkgcmVhc29uIGZvciBtb3Zpbmcgc3RhdHVzIGluaXRpYWxpemF0aW9uIGRvd24/DQoNClBy
b2JhYmx5IG5vdCBzdHJpY3RseSBuZWNlc3NhcnksIGJ1dCB0aGUgaWRlYSB3YXMgdG8gZW5zdXJl
IHRoYXQgYW55IG9mIHRoZQ0Kb3RoZXIgd3JpdGVzIHRvIHRoZSBkZXNjcmlwdG9yIHdlcmUgdmlz
aWJsZSBiZWZvcmUgdGhlIGRldmljZSBzYXcgdGhlIHN0YXR1cw0KYmVpbmcgY2xlYXJlZCAoaW5k
aWNhdGluZyBpdCBpcyBhdmFpbGFibGUgdG8gYmUgcmVhZCBieSB0aGUgZGV2aWNlKS4NCg0KPiAN
Cj4gPiAgCQlpZiAoc2l6ZXApDQo+ID4gIAkJCSpzaXplcCArPSBzdGF0dXMgJg0KPiA+IFhBWElE
TUFfQkRfU1RTX0FDVFVBTF9MRU5fTUFTSzsgQEAgLTcwNCw2ICs3MDgsOSBAQCBzdGF0aWMgaW5s
aW5lDQo+ID4gaW50IGF4aWVuZXRfY2hlY2tfdHhfYmRfc3BhY2Uoc3RydWN0IGF4aWVuZXRfbG9j
YWwgKmxwLA0KPiA+ICAJCQkJCSAgICBpbnQgbnVtX2ZyYWcpDQo+ID4gIHsNCj4gPiAgCXN0cnVj
dCBheGlkbWFfYmQgKmN1cl9wOw0KPiA+ICsNCj4gPiArCS8qIEVuc3VyZSB3ZSBzZWUgYWxsIGRl
c2NyaXB0b3IgdXBkYXRlcyBmcm9tIGRldmljZSBvciBUWCBJUlEgcGF0aCAqLw0KPiA+ICsJcm1i
KCk7DQo+ID4gIAljdXJfcCA9ICZscC0+dHhfYmRfdlsobHAtPnR4X2JkX3RhaWwgKyBudW1fZnJh
ZykgJSBscC0+dHhfYmRfbnVtXTsNCj4gPiAgCWlmIChjdXJfcC0+c3RhdHVzICYgWEFYSURNQV9C
RF9TVFNfQUxMX01BU0spDQo+ID4gIAkJcmV0dXJuIE5FVERFVl9UWF9CVVNZOw0KPiA+IEBAIC04
NDMsNiArODUwLDggQEAgc3RhdGljIHZvaWQgYXhpZW5ldF9yZWN2KHN0cnVjdCBuZXRfZGV2aWNl
ICpuZGV2KQ0KPiA+IA0KPiA+ICAJCXRhaWxfcCA9IGxwLT5yeF9iZF9wICsgc2l6ZW9mKCpscC0+
cnhfYmRfdikgKiBscC0+cnhfYmRfY2k7DQo+ID4gDQo+ID4gKwkJLyogRW5zdXJlIHdlIHNlZSBj
b21wbGV0ZSBkZXNjcmlwdG9yIHVwZGF0ZSAqLw0KPiA+ICsJCWRtYV9ybWIoKTsNCj4gPiAgCQlw
aHlzID0gZGVzY19nZXRfcGh5c19hZGRyKGxwLCBjdXJfcCk7DQo+ID4gIAkJZG1hX3VubWFwX3Np
bmdsZShuZGV2LT5kZXYucGFyZW50LCBwaHlzLCBscC0NCj4gPiA+IG1heF9mcm1fc2l6ZSwNCj4g
PiAgCQkJCSBETUFfRlJPTV9ERVZJQ0UpOw0KPiANCj4gSWRlYWxseSB3ZSB3b3VsZCBhbHNvIG5l
ZWQgYSB3cml0ZSBiYXJyaWVyIGluIHhtaXQgZnVuY3Rpb24ganVzdCBiZWZvcmUgDQo+IHVwZGF0
aW5nIHRhaWwgZGVzY3JpcHRvci4NCg0KSSBkb24ndCB0aGluayBpdCBzaG91bGQgYmUgbmVlZGVk
IHRoZXJlIGJlY2F1c2UgdGhlcmUgaXMgYW4gaW1wbGljaXQgYmFycmllciBvbg0KdGhlIE1NSU8g
d3JpdGUuDQoNCj4gDQo+ID4gLS0NCj4gPiAyLjMxLjENCi0tIA0KUm9iZXJ0IEhhbmNvY2sNClNl
bmlvciBIYXJkd2FyZSBEZXNpZ25lciwgQ2FsaWFuIEFkdmFuY2VkIFRlY2hub2xvZ2llcw0Kd3d3
LmNhbGlhbi5jb20NCg==
