Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BB848DBD7
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 17:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbiAMQcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 11:32:54 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:59326 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229474AbiAMQcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 11:32:53 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20DCYjOI020776;
        Thu, 13 Jan 2022 11:32:49 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2054.outbound.protection.outlook.com [104.47.61.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2gj45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 11:32:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hzb77cvKaGldJ+Vq4dW3oZlpnEbD/9jJ+vpnAClKC0Ps73d77X6xSMdHXQ1bOgNMbp5ZeN11M2+3E+I21dbsf60KPngeQL45QTeMS5jlAnxcQIJHeFO3bPbjJVTaMNWk0xurxEwWDCk8JHtC+EtXW1nzCannkmnGIBevQCfmHdmTAF3dq32UsQBN395Bpsj0wl8Ex3+NluAWqkPlN7SDJiuMTYQ81P+Z+grDEvfDwpvXLDKwpb8sQioHfZ7Elu6wBO2f6h74Fd8fuZtBIRK/pLmqWszvwbPO/UV2OnG8vc9yA6HdICtlztJ+8x89TwkKgbQ9t9MzPBHMl/vw9kopsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5egTQwxF+N8whGeYxhyklSsWabA1nT9GqoJCocyuD3Q=;
 b=C74LgEHEJZEd4sWCMi0jkcuaFMfjqcTVGxZh1bqbwV3AgtNAgBnSvhkbZQLIFvuzdI1bYy8d7RPvawOCxIt5Dg0loziVwZaxtJEZmWy5/AB1A+fcTDNNt7b2DPyeewZgbyxces9JiilHsCxv1XtbbNlzTm6by+z4WC34ATSea0VmNdCQCxuJgp4OEgEPpiK4PJs3S/RoqHWpDq9tAhCEUvIVKUltiPTdYU4P9/kPhvZa26OJHeC8su+MsmJOTGOVWE+mUXlU8+lHQK6fgqYD1IQch1d8+6IlxO5sfWTnqONXP8swP+Y8ufaay2jkP0cKwA4EeULOJFXJ/zcpeOc4QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5egTQwxF+N8whGeYxhyklSsWabA1nT9GqoJCocyuD3Q=;
 b=GGXVM5dcu6zForPK15B9PwFeJOgBOacDSLlbE0crsa4DB9u838PpeUF5yUh3Y/9TT9x2XfWrckyOKlAwZecXkJAc1IiTUd3wOvFNjFkasJ/17G3vlMq2INKnMIJatsPzzyAM834YsuQfiW0PR746zlXpdsTcLOalZpLruxzgSS8=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB5206.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:51::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Thu, 13 Jan
 2022 16:32:47 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 16:32:47 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Claudiu.Beznea@microchip.com" <Claudiu.Beznea@microchip.com>
CC:     "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: macb: Added ZynqMP-specific
 initialization
Thread-Topic: [PATCH net-next 2/3] net: macb: Added ZynqMP-specific
 initialization
Thread-Index: AQHYB+AGgilBoBfzO0GMf9PDqSlTP6xgmIIAgACOIgA=
Date:   Thu, 13 Jan 2022 16:32:47 +0000
Message-ID: <4056deb093184971c6f75d884d998a727816561f.camel@calian.com>
References: <20220112181113.875567-1-robert.hancock@calian.com>
         <20220112181113.875567-3-robert.hancock@calian.com>
         <480dc506-5480-245a-97a9-9aaa51d81995@microchip.com>
In-Reply-To: <480dc506-5480-245a-97a9-9aaa51d81995@microchip.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5a1413e-ce8a-434e-0253-08d9d6b2557f
x-ms-traffictypediagnostic: YT2PR01MB5206:EE_
x-microsoft-antispam-prvs: <YT2PR01MB520637052B850FB28765423EEC539@YT2PR01MB5206.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: igx4REMy9xK45YQIrSu5tFJW3rM38HK2yWNVCAR83WkeOIykDr3wddk0GM3dM4iXami7/KkCAmuveCrZqrFRfIJmV3vVcP8ft9zCrBorrU7cTceB20NfSEUlpToVvPm5UqWcuXnsrxFy/uY63X/e3norTYLH/YyrNJce22t5kH7N9uPiOHJK0QTl/2SPksaKW8ushSD205TGQcOU41g2oeidO8Ohu3S+7nh4LgCajV3FfR+s2jZUDnIWAPtXDQp4AhYEq3tCh120AmvHYvZT8SPLHR2VhglLqfHE/SDtDqG8OnmNRfA4v0Mb577rnnuKqd63i/9uF5PH82OANvfmQkeCE2zzvuvTrScLKPSqyLUmRzc7Kt0ghWtHWSUoo+S5QJ32DuwH8h8XQWdRKxOiSWxVcD85iZ7jgw0P9uv5lwgWFIb85r1TV8Tfgr6p3JRu0ejYmKM2sb1gmunBoXt+V7W4vhppqBXz07j+yJNqG+VMrxK7BmL3PfOblVF8kyra6/osYCEEMcPkdi17Btdc+1TyxY3s79hOf5H84T0KZftZU0+cT91+e8TGer/rq9bgGPAd6H4LkQS1pStzY3ADHSQRRDbNWs2cqR50WjR7JgJw7jo5ZBgh2VNnMjqr1pvYVTzkG7DY1vyE7QixrmMGAQqaBYeLs9YsOGKq79CS1BiniMKvDZI98pxBuL/TCIGfTnrMy/t+QGO41J+fAKcQ3X5Oac3zN0rAmevLtMIDdS8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(5660300002)(66476007)(91956017)(38070700005)(66446008)(26005)(76116006)(53546011)(316002)(8936002)(6506007)(66946007)(83380400001)(64756008)(508600001)(66556008)(6486002)(8676002)(110136005)(4326008)(54906003)(2616005)(38100700002)(2906002)(86362001)(6512007)(71200400001)(36756003)(44832011)(122000001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dU5JZXFuR0s4d0tNSVFzMGJhaWFMUVFFNEdDMTVCclJodlp3Z29NVnJ2ZnRO?=
 =?utf-8?B?UXRBQ0pxRVZUNjlGRlgzdWExMGRUeFowcGFHQS9vMEhTeWVLdTg4bHJCZzBM?=
 =?utf-8?B?OFMvQWhYM00zckc2aFgxa1RSOEYwL1VXTlYrRjh0Z2I1Y0RncTl6SkJFak1k?=
 =?utf-8?B?UWlZTjVzeUF4ajB0N0ZPZTFQU21qakVWeXJuS1NpTUN6SXMxQjBiTlRwcisv?=
 =?utf-8?B?Mk4rUm9XRjd5QnBMbDlxQnc4MW1mRjIxdXJNbGFPc0ovc1NvYjRLOUVDOWN4?=
 =?utf-8?B?WGJ3VFRBUjRYK2tlQURUODFYZG5CbWtCckZRL2dpYUZaU1oySXcwRG92d1Z0?=
 =?utf-8?B?SzdCVi9IdkZRRlRRRm9ib05ZdFpxQjdHb2tDcHFWTXNWNDdUcFNSMTFGdC9t?=
 =?utf-8?B?QmVYQVN4RmhOT1Y5NE55ZlR2Zm11WHpmZnR0cjk3L3JybVZWSmRHU05WS3E1?=
 =?utf-8?B?b3BLNTE1K2IvcXJjd2ZVSG8xV2NnYnZuUGlrakhJUUZNby9vV2FVWnd4R2Vz?=
 =?utf-8?B?azJ6bVQ3TU9SeDJMZytkK2dTdXhpUlhlME00K3U5dDVNazZFRy9OeHN5U0FE?=
 =?utf-8?B?c25iY3ZDMXk4Y0p3WEE1Wjc1ZThzYnRSNmtVRnh4Ulk5UVJ4OXlGbkNTb3B3?=
 =?utf-8?B?R2tMSWkwMHJHajBXQzQzNjAzd2lqcjA1L2c1UDVDOUh1Z1hMWXBkTjdubnVY?=
 =?utf-8?B?WmFQOGJPeWZJL3BwNTNlbDVCS1RjRTI5ZkVBQ21IVlRnSUtTMEVzWk12K2lj?=
 =?utf-8?B?Z3BHTFhyemZrVTIwWkQ3QmE5ODlpbW93bWw1YWVweEVqWUNpazMyWmcxRytE?=
 =?utf-8?B?a0Jmam1wZVJleFFhbVdFb3UyS21TL0lha0Q4QWswbWw4RGI5V0lHRmlmWnQw?=
 =?utf-8?B?TWhkcmhCZVBVYTdZVzFVaFg1TUp4MkZnczRNa0xhWDRYUUphc0NkM0xqazF0?=
 =?utf-8?B?eENYRTIxV2pjd1NyRGVmb2l4eVRrTklOTjFUR0FUUTZ6ZjUrWW02YUUzSE1t?=
 =?utf-8?B?OXhBWE9wd2hOSC9ZZW1UT0ZaZ1BIR0NabXJ2TzVoVjJnN05QeHRTaWpjd1RF?=
 =?utf-8?B?aXdBU2I5b2xqYmJhVHltQVRPakNJNjJzUjFJTHlxR1FOS2RldXp3V1NHYlA3?=
 =?utf-8?B?WWFRdEgzeTZKS3gxTmhoVUdzUWpMQWpwM0NCV1NnRzYrRkVxdHhaV0FhQk0v?=
 =?utf-8?B?MHZDVnVjOFBORDRlOHNkVm1Ta3dZbEpvWGV2VXYwSDZOMjhISHJRQk5OZFFm?=
 =?utf-8?B?MU4ycURKQ1JqaHd1OU9UcERRQ1JIU0VIM29FT3RwbnBoNjB4SmRxWmxxV0gy?=
 =?utf-8?B?aGtWZG5jWGNtRjZWbXVrelgrNGdTZ0ZDSVRoeG1qR21mNTJlRDZuV2lsZ2ZW?=
 =?utf-8?B?bUJIa3J0UjBmSGhsSmVoV0owZ1VQWDVxZER6SmMzR1lqTnpOQ1VDMjNzeitq?=
 =?utf-8?B?L1hjOHZmVHJDNDR3YmI1eXV2Y0RiVU85VFR3WFhRRmtKdjlWSno1MHFRazJa?=
 =?utf-8?B?VDR3U2psWEJyRHRpK1E4RERxSXl6SSs3SWR3UHpGR3NyUFR6N1ExQkk5UE4w?=
 =?utf-8?B?SzNxZUpkQ2ladlowWU9qTnRMQ1BCb3pnbFpmYzFHZmxwT1IwNlBGbFFML2xP?=
 =?utf-8?B?WHl2K3VZQlRKNTIzVFZTcHNWUWYrYmVHaGJYM09xYytPZXVnQ1ZWVnRpdW5k?=
 =?utf-8?B?dVY5TjF4WkVobFFzUmxza1d6NWV3TUpqemllcnd6bFJvZnp4N2ZqbHF0Y1da?=
 =?utf-8?B?SzZxYUs0ZkVmaGcxbnBCWUFEL2tIaDZPWFZmbE9iNW5OUHFxUS9tUWJNZWpM?=
 =?utf-8?B?dUxzcTRUbjZxZjVVNHJ1U3ZINXY1U0FRU2ROS21Zb3gzc2Jzd1MzYllXUHNI?=
 =?utf-8?B?K0pQSm92NFZHYlg5dm5tbzRWQzIxVGxwSzRYOFUxTmVVcFd3MTVPL0h3aWxY?=
 =?utf-8?B?VWt0VzBRSnFyeVJMV3g1VmU1TlFjYUo3ckpMWWJRNWV6aWhzclg4Ryt1Um5V?=
 =?utf-8?B?YUI2NW1SdWR0cWkxOWxzVHk4TzRvVnZObmkxVVF1VGx0aGJHYkNNbkh5bERY?=
 =?utf-8?B?MGYxVE9EczlWdCtMUDljZldvUHhQUEtJbFc3TXV2S3VscUt1NUQxVmg2UlZR?=
 =?utf-8?B?OEYyNFhhYSszOWNEUFZ3S2FDdUpmZjVtRHB4OU1YUTA3S1JFSjVua3UxKzVz?=
 =?utf-8?B?ZGxUSDJ0YmlYRFZZaGs1c290S0V2ZnlpRVpNU0svemROQ0pGdDRCZnlaZEFx?=
 =?utf-8?Q?id1s6KyvGUCtwZvQ8fxAZzeETza1tePjfq7udqNQ0o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BD08844EA3E9E4F955D841FF808D493@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: c5a1413e-ce8a-434e-0253-08d9d6b2557f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 16:32:47.5608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +fPnz4aR4SXZdvyvo7/tDlI5tYKB19bFY1TDybKqsx5/x+GGCLNoYIf2ex7o9B6wjT9YCwJHQHzfMuhgIbYKnE7+as/aKA0kxqNynpxdihY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5206
X-Proofpoint-GUID: xwne-qHRHE8FPesK1d3TOWa-vR_kz_W5
X-Proofpoint-ORIG-GUID: xwne-qHRHE8FPesK1d3TOWa-vR_kz_W5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_08,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTAxLTEzIGF0IDA4OjA0ICswMDAwLCBDbGF1ZGl1LkJlem5lYUBtaWNyb2No
aXAuY29tIHdyb3RlOg0KPiBPbiAxMi4wMS4yMDIyIDIwOjExLCBSb2JlcnQgSGFuY29jayB3cm90
ZToNCj4gPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNo
bWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZQ0KPiA+IGNvbnRlbnQgaXMgc2FmZQ0KPiA+IA0KPiA+
IFRoZSBHRU0gY29udHJvbGxlcnMgb24gWnlucU1QIHdlcmUgbWlzc2luZyBzb21lIGluaXRpYWxp
emF0aW9uIHN0ZXBzIHdoaWNoDQo+ID4gYXJlIHJlcXVpcmVkIGluIHNvbWUgY2FzZXMgd2hlbiB1
c2luZyBTR01JSSBtb2RlLCB3aGljaCB1c2VzIHRoZSBQUy1HVFINCj4gPiB0cmFuc2NlaXZlcnMg
bWFuYWdlZCBieSB0aGUgcGh5LXp5bnFtcCBkcml2ZXIuDQo+ID4gDQo+ID4gVGhlIEdFTSBjb3Jl
IGFwcGVhcnMgdG8gbmVlZCBhIGhhcmR3YXJlLWxldmVsIHJlc2V0IGluIG9yZGVyIHRvIHdvcmsN
Cj4gPiBwcm9wZXJseSBpbiBTR01JSSBtb2RlIGluIGNhc2VzIHdoZXJlIHRoZSBHVCByZWZlcmVu
Y2UgY2xvY2sgd2FzIG5vdA0KPiA+IHByZXNlbnQgYXQgaW5pdGlhbCBwb3dlci1vbi4gVGhpcyBj
YW4gYmUgZG9uZSB1c2luZyBhIHJlc2V0IG1hcHBlZCB0bw0KPiA+IHRoZSB6eW5xbXAtcmVzZXQg
ZHJpdmVyIGluIHRoZSBkZXZpY2UgdHJlZS4NCj4gPiANCj4gPiBBbHNvLCB3aGVuIGluIFNHTUlJ
IG1vZGUsIHRoZSBHRU0gZHJpdmVyIG5lZWRzIHRvIGVuc3VyZSB0aGUgUEhZIGlzDQo+ID4gaW5p
dGlhbGl6ZWQgYW5kIHBvd2VyZWQgb24gd2hlbiBpdCBpcyBpbml0aWFsaXppbmcuDQo+ID4gDQo+
ID4gU2lnbmVkLW9mZi1ieTogUm9iZXJ0IEhhbmNvY2sgPHJvYmVydC5oYW5jb2NrQGNhbGlhbi5j
b20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWlu
LmMgfCA0NyArKysrKysrKysrKysrKysrKysrKysrKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDQ2
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiA+IGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiA+IGluZGV4IGEzNjNkYTkyOGU4Yi4uNjVi
MDM2MGM0ODdhIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2Uv
bWFjYl9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2Jf
bWFpbi5jDQo+ID4gQEAgLTM0LDcgKzM0LDkgQEANCj4gPiAgI2luY2x1ZGUgPGxpbnV4L3VkcC5o
Pg0KPiA+ICAjaW5jbHVkZSA8bGludXgvdGNwLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9pb3Bv
bGwuaD4NCj4gPiArI2luY2x1ZGUgPGxpbnV4L3BoeS9waHkuaD4NCj4gPiAgI2luY2x1ZGUgPGxp
bnV4L3BtX3J1bnRpbWUuaD4NCj4gPiArI2luY2x1ZGUgPGxpbnV4L3Jlc2V0Lmg+DQo+ID4gICNp
bmNsdWRlICJtYWNiLmgiDQo+ID4gDQo+ID4gIC8qIFRoaXMgc3RydWN0dXJlIGlzIG9ubHkgdXNl
ZCBmb3IgTUFDQiBvbiBTaUZpdmUgRlU1NDAgZGV2aWNlcyAqLw0KPiA+IEBAIC00NDU1LDYgKzQ0
NTcsNDkgQEAgc3RhdGljIGludCBmdTU0MF9jMDAwX2luaXQoc3RydWN0IHBsYXRmb3JtX2Rldmlj
ZQ0KPiA+ICpwZGV2KQ0KPiA+ICAgICAgICAgcmV0dXJuIG1hY2JfaW5pdChwZGV2KTsNCj4gPiAg
fQ0KPiA+IA0KPiA+ICtzdGF0aWMgaW50IHp5bnFtcF9pbml0KHN0cnVjdCBwbGF0Zm9ybV9kZXZp
Y2UgKnBkZXYpDQo+ID4gK3sNCj4gPiArICAgICAgIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBw
bGF0Zm9ybV9nZXRfZHJ2ZGF0YShwZGV2KTsNCj4gPiArICAgICAgIHN0cnVjdCBtYWNiICpicCA9
IG5ldGRldl9wcml2KGRldik7DQo+ID4gKyAgICAgICBpbnQgcmV0Ow0KPiA+ICsNCj4gPiArICAg
ICAgIC8qIEZ1bGx5IHJlc2V0IEdFTSBjb250cm9sbGVyIGF0IGhhcmR3YXJlIGxldmVsIHVzaW5n
IHp5bnFtcC1yZXNldA0KPiA+IGRyaXZlciwNCj4gPiArICAgICAgICAqIGlmIG1hcHBlZCBpbiBk
ZXZpY2UgdHJlZS4NCj4gPiArICAgICAgICAqLw0KPiA+ICsgICAgICAgcmV0ID0gZGV2aWNlX3Jl
c2V0KCZwZGV2LT5kZXYpOw0KPiA+ICsgICAgICAgaWYgKHJldCkgew0KPiA+ICsgICAgICAgICAg
ICAgICBkZXZfZXJyX3Byb2JlKCZwZGV2LT5kZXYsIHJldCwgImZhaWxlZCB0byByZXNldA0KPiA+
IGNvbnRyb2xsZXIiKTsNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gDQo+IElm
IHVzaW5nIG9sZCBkZXZpY2UgdHJlZXMgdGhpcyB3aWxsIGZhaWwsIHJpZ2h0PyBJZiB5ZXMsIHlv
dSBzaG91bGQgdGFrZQ0KPiBjYXJlIHRoaXMgY29kZSB3aWxsIGFsc28gd29yayB3aXRoIG9sZCBk
ZXZpY2UgdHJlZXMuDQoNCkkgdGhpbmsgSSBoYWQgYmVsaWV2ZWQgZGV2aWNlX3Jlc2V0IHNob3Vs
ZCBqdXN0IHJldHVybiBhIHN1Y2Nlc3Mgd2l0aG91dCBkb2luZw0KYW55dGhpbmcgaWYgdGhlIGRl
dmljZSB0cmVlIGhhcyBubyByZXNldCBkZWZpbmVkIGZvciB0aGUgZGV2aWNlLCBidXQgaXQgYXBw
ZWFycw0KdG8gZ2V0IHRoYXQgYmVoYXZpb3Igd2Ugc2hvdWxkIGJlIHVzaW5nIGRldmljZV9yZXNl
dF9vcHRpb25hbC4NCg0KPiANCj4gVGhhbmsgeW91LA0KPiBDbGF1ZGl1IEJlem5lYQ0KPiANCj4g
PiArICAgICAgIH0NCj4gPiArDQo+ID4gKyAgICAgICBpZiAoYnAtPnBoeV9pbnRlcmZhY2UgPT0g
UEhZX0lOVEVSRkFDRV9NT0RFX1NHTUlJKSB7DQo+ID4gKyAgICAgICAgICAgICAgIC8qIEVuc3Vy
ZSBQUy1HVFIgUEhZIGRldmljZSB1c2VkIGluIFNHTUlJIG1vZGUgaXMgcmVhZHkgKi8NCj4gPiAr
ICAgICAgICAgICAgICAgc3RydWN0IHBoeSAqc2dtaWlfcGh5ID0gZGV2bV9waHlfZ2V0KCZwZGV2
LT5kZXYsICJzZ21paS0NCj4gPiBwaHkiKTsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICAgIGlm
IChJU19FUlIoc2dtaWlfcGh5KSkgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldCA9
IFBUUl9FUlIoc2dtaWlfcGh5KTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBkZXZfZXJy
X3Byb2JlKCZwZGV2LT5kZXYsIHJldCwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICJmYWlsZWQgdG8gZ2V0IFBTLUdUUiBQSFlcbiIpOw0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+ID4gKyAgICAgICAgICAgICAgIH0NCj4gPiArDQo+
ID4gKyAgICAgICAgICAgICAgIHJldCA9IHBoeV9pbml0KHNnbWlpX3BoeSk7DQo+ID4gKyAgICAg
ICAgICAgICAgIGlmIChyZXQpIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBkZXZfZXJy
KCZwZGV2LT5kZXYsICJmYWlsZWQgdG8gaW5pdCBQUy1HVFIgUEhZOg0KPiA+ICVkXG4iLA0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcmV0KTsNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiA+ICsgICAgICAgICAgICAgICB9DQo+ID4gKw0KPiA+
ICsgICAgICAgICAgICAgICByZXQgPSBwaHlfcG93ZXJfb24oc2dtaWlfcGh5KTsNCj4gPiArICAg
ICAgICAgICAgICAgaWYgKHJldCkgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIGRldl9l
cnIoJnBkZXYtPmRldiwgImZhaWxlZCB0byBwb3dlciBvbiBQUy1HVFIgUEhZOg0KPiA+ICVkXG4i
LA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcmV0KTsNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiA+ICsgICAgICAgICAgICAgICB9DQo+ID4g
KyAgICAgICB9DQo+ID4gKyAgICAgICByZXR1cm4gbWFjYl9pbml0KHBkZXYpOw0KPiA+ICt9DQo+
ID4gKw0KPiA+ICBzdGF0aWMgY29uc3Qgc3RydWN0IG1hY2JfdXNyaW9fY29uZmlnIHNhbWE3ZzVf
dXNyaW8gPSB7DQo+ID4gICAgICAgICAubWlpID0gMCwNCj4gPiAgICAgICAgIC5ybWlpID0gMSwN
Cj4gPiBAQCAtNDU1MCw3ICs0NTk1LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBtYWNiX2NvbmZp
ZyB6eW5xbXBfY29uZmlnID0gew0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIE1BQ0JfQ0FQ
U19HRU1fSEFTX1BUUCB8IE1BQ0JfQ0FQU19CRF9SRF9QUkVGRVRDSCwNCj4gPiAgICAgICAgIC5k
bWFfYnVyc3RfbGVuZ3RoID0gMTYsDQo+ID4gICAgICAgICAuY2xrX2luaXQgPSBtYWNiX2Nsa19p
bml0LA0KPiA+IC0gICAgICAgLmluaXQgPSBtYWNiX2luaXQsDQo+ID4gKyAgICAgICAuaW5pdCA9
IHp5bnFtcF9pbml0LA0KPiA+ICAgICAgICAgLmp1bWJvX21heF9sZW4gPSAxMDI0MCwNCj4gPiAg
ICAgICAgIC51c3JpbyA9ICZtYWNiX2RlZmF1bHRfdXNyaW8sDQo+ID4gIH07DQo+ID4gLS0NCj4g
PiAyLjMxLjENCj4gPiANCg==
