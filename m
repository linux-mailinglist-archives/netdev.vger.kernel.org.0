Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC5848DCBA
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 18:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbiAMROY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 12:14:24 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:35319 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229943AbiAMROX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 12:14:23 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20DCYjYk020776;
        Thu, 13 Jan 2022 12:14:15 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2054.outbound.protection.outlook.com [104.47.60.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2gkg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:14:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e8RysSVI6jtlh+L3QqBBsNPy0Hszol8UYNG5YU8ZnvYo8TU453ezC4rJXbcZetACz3puk7IUf2uyrFyxogBrkuTikG8soHFjq5HcAjZIhPA5pNHzJqf5xPgHpasADukU+ax6tBWvvXYJemD5VUnkdQzwcTZp5MHlSXTQvA6NWYg7y+8BvPUV+Rt5QdfoTOgtqeg9d48EtIhHMAWl6pBAXZ+qHuVTcyNKZRA7qb87fHHWVqC168L2NVpUQ391yrkYNIbeSz7JTbtKe3Fvy6bPs9GnezayNJEgawSxYCIfPI1PjL3QCU8h6eEqEku5VLIVKoIRLxTUQt2hscXlsxQrHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C2xYcr8blab62tIvlQPsO5pG+hqaTVvYwhGDvN9ayCo=;
 b=m2IvUhUh+zTULva5XmMTMmngSQw3+jbuo8KldBHAqlr8tyMSsErMXY3AYBaqJsNR3phIww8GdjTbawoGRzBYrKTcRosdW33QyheFdWVeToQoX4CJ2r23YWtDYbpKTL8SsxiGlaAgaSR4HAYGHmCahmJs8tm2H1QmFXk2bjK6m9W9Ef+Fn18YLD8qm0Ziw5vcZtUaS4p6mkq8Scz7n8VUi8zAmZC4fFV+BgjYqOnh+JrBS2HLfML+CJqI7wDXS37mKToZLx3I7vpxlIDMzsFWMaSPYYOFsogBqRfaTXPAtYN4U85EyOYZ+2O85KEj6N2n+iFfzgBNzFOKS1QKYsyozQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2xYcr8blab62tIvlQPsO5pG+hqaTVvYwhGDvN9ayCo=;
 b=MB2gMK/nuRIrHG/bFQ+y5UhCaeHbMyBTjgDb5CSM7BNpgfoL82oQLO1/JLhjvUC/rjchAM66BKz806o1a3PAI6zoImEJ73cxq8QdGWmFdudWdoOzhIfq+44U9Ahc2hEhODRw/bFGX2EUjc8RxvkDE8k33VfCjsr1mK1GwW2lrqU=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTBPR01MB2414.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 13 Jan
 2022 17:14:13 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 17:14:13 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "harinik@xilinx.com" <harinik@xilinx.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "piyush.mehta@xilinx.com" <piyush.mehta@xilinx.com>
Subject: Re: [PATCH net-next 2/3] net: macb: Added ZynqMP-specific
 initialization
Thread-Topic: [PATCH net-next 2/3] net: macb: Added ZynqMP-specific
 initialization
Thread-Index: AQHYB+AGgilBoBfzO0GMf9PDqSlTP6xgjmMAgAAunICAAHU4AA==
Date:   Thu, 13 Jan 2022 17:14:13 +0000
Message-ID: <0d794fca04b5e6d5d3c87fc576b1232b20db0b18.camel@calian.com>
References: <20220112181113.875567-1-robert.hancock@calian.com>
         <20220112181113.875567-3-robert.hancock@calian.com>
         <3caae1db-b577-1e1f-3377-11272945054c@xilinx.com>
         <CAFcVECJavcDzHyi2MiM1kkYqsm=W8zTN4QWMx1fuZkXRS936JQ@mail.gmail.com>
In-Reply-To: <CAFcVECJavcDzHyi2MiM1kkYqsm=W8zTN4QWMx1fuZkXRS936JQ@mail.gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c905bab3-6110-4a39-3a7e-08d9d6b81f00
x-ms-traffictypediagnostic: YTBPR01MB2414:EE_
x-microsoft-antispam-prvs: <YTBPR01MB24142D6ABA76FEC78424F74AEC539@YTBPR01MB2414.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mTetKnC9hfTDfM4pSRhSRGyw0CkLiZJFFiKIU+Dd8Xs2XZCjo5kfouHaCb0I+8Y6bM2D3bp/TmARMNoQ+Rqj5QBVzhuUJdSfvldJAlJefqZLp8cBQmuVbQeqLiFN8tK4c444RuTAB0Je5ME1CxkIJV99+GNbYpfdkmUbd/H1y2kJiXY5jagbVqZC81GJtofDkHP9E748LCz9EPgjLg1lcrYGnyHNiv7EKDHPkPRQ+CzhjONT51N2NwxdgMx76wEWD1z0K93v8NTQjI8Y076upyQsbfny+Ti5cUy5GThRxBXoENd4uiFfmJ2BTdqm6MhIv8XH9Ez8ezwUP5DxWyjW1j7mxW0o3LeFyp1ynCuZxzEP8DiF9gRYUc6ltD/aFuiYAt/wpLBR9ZaPArARrskRePexIcmNWxK0LOL3lQ08M+eyedqJDyadjNz+PhvywCApsyPgwBBWphLDgRp210qYzuGW9ME3ZH/xMRPM0MazTyObIcPNeXjg1UVv4lJxu7e0VPXyXPp5bU5uV4gTHW3ktmrjQIW+YPdyzrWK9IELS0lss73Sufqf/Ew+LPjQpCf9qTm4j7IZf4Fv667ZAwJH1kn+pYEOvKHzA4ip9m9k/P0Ceu294KUxpsOBqn9hp1CC5G4lQ5QO168oRuQYM6jszpFxAxNibcu/FzMeec1dXf6h58rqO2RSo6pbnuXhxyWlPlX1kpxtdUhitYZ5ajE2xOmblygLDc+brxKNDCF6ZcB2y0Law0iORNtujHPvVLH9+zbnxkRUojl9i5L/qUIEGBgnWU7EwZvtOx9gToOwOfn+EbO+dwLDIZigsFS4TqjbsYZNxhnoaZZphkJhhGEOy8i8Y/GsOUhJ100RtFw1FEI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(2906002)(54906003)(15974865002)(508600001)(316002)(5660300002)(6512007)(2616005)(66476007)(66556008)(64756008)(66446008)(66946007)(6506007)(71200400001)(7416002)(76116006)(38100700002)(53546011)(8936002)(186003)(122000001)(8676002)(44832011)(86362001)(83380400001)(6486002)(26005)(38070700005)(4326008)(36756003)(91956017)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2FtMytIT1E3MW5HZkJHS0hmaE9NQXJFWlU5Q1BrZGhYZzM2SnRvdFc2d1JS?=
 =?utf-8?B?ZTViVzNPaURHd1MxMmRnQWdJczdsV0lZZWRUS2hRSklLMk4vc0dGNGVHSkVN?=
 =?utf-8?B?VjBwV3pDaDVmVkZGdStlTEZ5YUtyNmE3bXEyUHcvNVd3eGovVit1OWgxTlZr?=
 =?utf-8?B?b2pJUXNYTXBEYVJlVnhqaEhjV3dlM2x2K3BXdDkwM3NhVFJXMFcyUEFLMUN5?=
 =?utf-8?B?ZUVtazk0LzA4dEdoQjllRG9wODVPcjJNN3ZYampmdUVCK1NsK0paa3NIVU00?=
 =?utf-8?B?M000bHlWNmQrN2YrOGp3SGtDWXN1d1VNbkpKNFdzb2dTTkhmSDFVNUhkaVR2?=
 =?utf-8?B?UEJCd21CeTRGVjRvQlplK2lrRi9KOFZNU041UWhBSEVVSmM4MjE5d0R1b05O?=
 =?utf-8?B?R08zbHFUZHdHcjdNbTJPQU5Pc2pCam41ck45cVhrc3hOejJzcldMNmJsUlNr?=
 =?utf-8?B?YXlzRVFaeHhIcEFabE5NaFUrUTh1QXdZS2ZKM0lqQ01UaDJvUUZZOFd4cTM4?=
 =?utf-8?B?ajJPOWRtYVBaMU1VZkd5SmFkTW5EUmtDdG5zbUVOWEFOdWU3RFd0azlVMlUz?=
 =?utf-8?B?b0JoSUpReE5JZ2dOUStzZWhReGZCZXRmQ2RaWml4L2gybkpjUkJ5QTZ6NHZI?=
 =?utf-8?B?N3A0c3gxQWRic1ZQcFRoRkZYeDVMdGFtQ1FtRmw0d2lRMlU2RGdIb0tHZ21V?=
 =?utf-8?B?bGRBRUVFY3hIRy80Z2s4dklJbTZROUNpS0h6U1VQYzYyTFVVVG1kODRZQlda?=
 =?utf-8?B?QXpDcDRHUlhIRmplYzFIRHJpNVpkY2NDeEF4MjJ1U2UwVWprOTVEc0c3UGs3?=
 =?utf-8?B?bTZsVkxiL1RzZ2w2RjdCUHZjTm53M0NUTERZSnVFaGtkSjBzYlFDZXlCYzBr?=
 =?utf-8?B?cFhzbjlreXl0WVpvSTduT1VMeHJqWStvaklmT0xRTkZtVG5zS2k0cVJIZmFt?=
 =?utf-8?B?TXZnZVFpY3NKdkFDU0k5d0hCZDVLU1V6VkZncjQ5RDNCUUZMVXg5V0xpYU9P?=
 =?utf-8?B?SDJuSUhXY1ByMG45Y2JYNTF4RjV2UkZsUEJjWEROeW1QS2F5NDNmZVltQm1k?=
 =?utf-8?B?TDV1WW1WaExzaUdhNVVJTXFiZy9KU1BiMXo1QVBlMUFDSGFoKzkvTmVERHpR?=
 =?utf-8?B?V01wdHAwSm9NTjVWTVJuTjM1ZE5ESnoxcXNUSkd0R29SbU5nQjZIWEVHZFE0?=
 =?utf-8?B?cVN4eW5kbnBqRGEycnpJeEgyRGpjdVFDZXk3bVJZRWhlaldMQjRQVUpJd3JY?=
 =?utf-8?B?bDhPVnZ0eklhaEhGNHVlL1hSM1B5b1VZMnh4K1F1NTVvbmFDUzFqYkVPS0Q4?=
 =?utf-8?B?c3BrV0lKRHJidmpBWHE0dFBJV2sweUlvMVFBaWR4NExwcHhyWFVGWkE3S0dw?=
 =?utf-8?B?WEFSYWo1ZDFzUUl1VjBZWTRKb0hNK3FVVzUweDUzSjFRaXBQMjlwRnA3TVdt?=
 =?utf-8?B?cFNrYzhINTJQcmhPWkNYenkyZXNTWUl2amNPRVdGeVVtNDVwSnNlUUF0V3oy?=
 =?utf-8?B?UzMyOFA4VGZVdzJiLy9nMFVPWG9lRy82WjFCRzh5RVBQU3NwaExHbC9ZdTNr?=
 =?utf-8?B?bHZjdTZ0V1dkd1lTYUlmRTcwMnMxU3JwZ1JDeGFSNXhlT1JwVzgrblNUazFS?=
 =?utf-8?B?bERETE0vUVVZNU91SzhEYTlZMDRmVE1LRWlCcHJKbnU5VGVBN1BuVlJ4S2ZQ?=
 =?utf-8?B?NG9TQndoQVRzZmw5aUFJL3RDMDJ2cVdaYUZIcmREZGxEZDJXUGNMWUpVZEpO?=
 =?utf-8?B?MFFjRlpQbXVYbGtqeGJQUldsMGxsbVNSUTJWQlJ2RWRhT0VZYmMvYXdEQWRw?=
 =?utf-8?B?K3pSbTFidnZoMXI4WkJxakNvMzFMQldEdCtFY1ljbHJ6TmhpU1hPcWhTbzZP?=
 =?utf-8?B?MTlKcFkveTUwVWZBWHZzYXBwZFR0NjJ1YkNreDJJNWlvMjFic21VZXZJWEhu?=
 =?utf-8?B?L2g0VEZ1TGEycXBXbUEwZFVRcllqL2piSDhSNkRNd1FoNng1d2JRbWNPVWF6?=
 =?utf-8?B?czM2Yi84cDFhT2E0OWQ4aDJFS09VblZtejRjeVVSalRVMjZqVzFmSW83UUpa?=
 =?utf-8?B?eFFIa2c3bU9IUmQvTHNwZWxHQlN3VDJSTmZSWFV3WThJQmZDTUppWjFUV0ps?=
 =?utf-8?B?VXlsYlo4cjUyNGZmQUhVYlZ1TWt1b2M1SmpNck0zekNYUUkrWnFPTWhzVzUy?=
 =?utf-8?B?V3ZPbEl1N3dZdTd1VFVtVXBxNERpdDBNTDJWTDk5VkpRdWk2SG1LY28vQU1u?=
 =?utf-8?Q?URZ5ma0T+miBHqYLy+s24ezDM0H1aFSw6erZ19NhFY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86C64CDE9ED86140BE4DFFB5CA5A84FB@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: c905bab3-6110-4a39-3a7e-08d9d6b81f00
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 17:14:13.1446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PqfqcP6C1imvtrlkK/RBpe2JVyHMIBmx2aZZKctuEA5+0BrjGGNe/zC60IJNZAcubavYjsYxyz1VfFu/2yL9xYzJfNk9efemQgDbj8Muhlw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB2414
X-Proofpoint-GUID: O11U9O16BmCL-074XcoOVe9uWPfrjyyR
X-Proofpoint-ORIG-GUID: O11U9O16BmCL-074XcoOVe9uWPfrjyyR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_08,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTAxLTEzIGF0IDE1OjQ0ICswNTMwLCBIYXJpbmkgS2F0YWthbSB3cm90ZToN
Cj4gK1JhZGhleQ0KPiANCj4gSGkgUm9iZXJ0LA0KPiANCj4gT24gVGh1LCBKYW4gMTMsIDIwMjIg
YXQgMjo0NiBQTSBNaWNoYWwgU2ltZWsgPG1pY2hhbC5zaW1la0B4aWxpbnguY29tPiB3cm90ZToN
Cj4gPiANCj4gPiANCj4gPiBPbiAxLzEyLzIyIDE5OjExLCBSb2JlcnQgSGFuY29jayB3cm90ZToN
Cj4gPiA+IFRoZSBHRU0gY29udHJvbGxlcnMgb24gWnlucU1QIHdlcmUgbWlzc2luZyBzb21lIGlu
aXRpYWxpemF0aW9uIHN0ZXBzDQo+ID4gPiB3aGljaA0KPiA+ID4gYXJlIHJlcXVpcmVkIGluIHNv
bWUgY2FzZXMgd2hlbiB1c2luZyBTR01JSSBtb2RlLCB3aGljaCB1c2VzIHRoZSBQUy1HVFINCj4g
PiA+IHRyYW5zY2VpdmVycyBtYW5hZ2VkIGJ5IHRoZSBwaHktenlucW1wIGRyaXZlci4NCj4gPiA+
IA0KPiA+ID4gVGhlIEdFTSBjb3JlIGFwcGVhcnMgdG8gbmVlZCBhIGhhcmR3YXJlLWxldmVsIHJl
c2V0IGluIG9yZGVyIHRvIHdvcmsNCj4gPiA+IHByb3Blcmx5IGluIFNHTUlJIG1vZGUgaW4gY2Fz
ZXMgd2hlcmUgdGhlIEdUIHJlZmVyZW5jZSBjbG9jayB3YXMgbm90DQo+ID4gPiBwcmVzZW50IGF0
IGluaXRpYWwgcG93ZXItb24uIFRoaXMgY2FuIGJlIGRvbmUgdXNpbmcgYSByZXNldCBtYXBwZWQg
dG8NCj4gPiA+IHRoZSB6eW5xbXAtcmVzZXQgZHJpdmVyIGluIHRoZSBkZXZpY2UgdHJlZS4NCj4g
PiA+IA0KPiA+ID4gQWxzbywgd2hlbiBpbiBTR01JSSBtb2RlLCB0aGUgR0VNIGRyaXZlciBuZWVk
cyB0byBlbnN1cmUgdGhlIFBIWSBpcw0KPiA+ID4gaW5pdGlhbGl6ZWQgYW5kIHBvd2VyZWQgb24g
d2hlbiBpdCBpcyBpbml0aWFsaXppbmcuDQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFJv
YmVydCBIYW5jb2NrIDxyb2JlcnQuaGFuY29ja0BjYWxpYW4uY29tPg0KPiA+ID4gLS0tDQo+ID4g
PiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgfCA0NyArKysrKysr
KysrKysrKysrKysrKysrKy0NCj4gPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDQ2IGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiA+ID4gaW5kZXggYTM2M2RhOTI4ZThiLi42NWIwMzYw
YzQ4N2EgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21h
Y2JfbWFpbi5jDQo+ID4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2Jf
bWFpbi5jDQo+ID4gPiBAQCAtMzQsNyArMzQsOSBAQA0KPiA+ID4gICAjaW5jbHVkZSA8bGludXgv
dWRwLmg+DQo+ID4gPiAgICNpbmNsdWRlIDxsaW51eC90Y3AuaD4NCj4gPiA+ICAgI2luY2x1ZGUg
PGxpbnV4L2lvcG9sbC5oPg0KPiA+ID4gKyNpbmNsdWRlIDxsaW51eC9waHkvcGh5Lmg+DQo+ID4g
PiAgICNpbmNsdWRlIDxsaW51eC9wbV9ydW50aW1lLmg+DQo+ID4gPiArI2luY2x1ZGUgPGxpbnV4
L3Jlc2V0Lmg+DQo+ID4gPiAgICNpbmNsdWRlICJtYWNiLmgiDQo+ID4gPiANCj4gPiA+ICAgLyog
VGhpcyBzdHJ1Y3R1cmUgaXMgb25seSB1c2VkIGZvciBNQUNCIG9uIFNpRml2ZSBGVTU0MCBkZXZp
Y2VzICovDQo+ID4gPiBAQCAtNDQ1NSw2ICs0NDU3LDQ5IEBAIHN0YXRpYyBpbnQgZnU1NDBfYzAw
MF9pbml0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UNCj4gPiA+ICpwZGV2KQ0KPiA+ID4gICAgICAg
cmV0dXJuIG1hY2JfaW5pdChwZGV2KTsNCj4gPiA+ICAgfQ0KPiA+ID4gDQo+ID4gPiArc3RhdGlj
IGludCB6eW5xbXBfaW5pdChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiA+ID4gK3sN
Cj4gPiA+ICsgICAgIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBwbGF0Zm9ybV9nZXRfZHJ2ZGF0
YShwZGV2KTsNCj4gPiA+ICsgICAgIHN0cnVjdCBtYWNiICpicCA9IG5ldGRldl9wcml2KGRldik7
DQo+ID4gPiArICAgICBpbnQgcmV0Ow0KPiA+ID4gKw0KPiA+ID4gKyAgICAgLyogRnVsbHkgcmVz
ZXQgR0VNIGNvbnRyb2xsZXIgYXQgaGFyZHdhcmUgbGV2ZWwgdXNpbmcgenlucW1wLXJlc2V0DQo+
ID4gPiBkcml2ZXIsDQo+ID4gPiArICAgICAgKiBpZiBtYXBwZWQgaW4gZGV2aWNlIHRyZWUuDQo+
ID4gPiArICAgICAgKi8NCj4gPiA+ICsgICAgIHJldCA9IGRldmljZV9yZXNldCgmcGRldi0+ZGV2
KTsNCj4gPiA+ICsgICAgIGlmIChyZXQpIHsNCj4gPiA+ICsgICAgICAgICAgICAgZGV2X2Vycl9w
cm9iZSgmcGRldi0+ZGV2LCByZXQsICJmYWlsZWQgdG8gcmVzZXQNCj4gPiA+IGNvbnRyb2xsZXIi
KTsNCj4gPiA+ICsgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gPiA+ICsgICAgIH0NCj4gPiA+
ICsNCj4gPiA+ICsgICAgIGlmIChicC0+cGh5X2ludGVyZmFjZSA9PSBQSFlfSU5URVJGQUNFX01P
REVfU0dNSUkpIHsNCj4gPiA+ICsgICAgICAgICAgICAgLyogRW5zdXJlIFBTLUdUUiBQSFkgZGV2
aWNlIHVzZWQgaW4gU0dNSUkgbW9kZSBpcyByZWFkeSAqLw0KPiA+ID4gKyAgICAgICAgICAgICBz
dHJ1Y3QgcGh5ICpzZ21paV9waHkgPSBkZXZtX3BoeV9nZXQoJnBkZXYtPmRldiwgInNnbWlpLQ0K
PiA+ID4gcGh5Iik7DQo+ID4gPiArDQo+ID4gPiArICAgICAgICAgICAgIGlmIChJU19FUlIoc2dt
aWlfcGh5KSkgew0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgIHJldCA9IFBUUl9FUlIoc2dt
aWlfcGh5KTsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICBkZXZfZXJyX3Byb2JlKCZwZGV2
LT5kZXYsIHJldCwNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJm
YWlsZWQgdG8gZ2V0IFBTLUdUUiBQSFlcbiIpOw0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAg
IHJldHVybiByZXQ7DQo+ID4gPiArICAgICAgICAgICAgIH0NCj4gPiA+ICsNCj4gPiA+ICsgICAg
ICAgICAgICAgcmV0ID0gcGh5X2luaXQoc2dtaWlfcGh5KTsNCj4gPiA+ICsgICAgICAgICAgICAg
aWYgKHJldCkgew0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgIGRldl9lcnIoJnBkZXYtPmRl
diwgImZhaWxlZCB0byBpbml0IFBTLUdUUiBQSFk6DQo+ID4gPiAlZFxuIiwNCj4gPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHJldCk7DQo+ID4gPiArICAgICAgICAgICAgICAgICAg
ICAgcmV0dXJuIHJldDsNCj4gPiA+ICsgICAgICAgICAgICAgfQ0KPiA+IA0KPiA+IEkgd2FzIHBs
YXlpbmcgd2l0aCBpdCByZWNlbnRseSBvbiB1LWJvb3Qgc2lkZSBhbmQgZGV2aWNlIHJlc2V0IHNo
b3VsZA0KPiA+IGhhcHBlbg0KPiA+IGJldHdlZW4gcGh5IGluaXQgYW5kIHBoeSBwb3dlciBvbiB0
byBmaW5pc2ggY2FsaWJyYXRpb24uDQo+ID4gQXQgbGVhc3QgdGhhdCdzIEkgd2FzIHRvbGQgYW5k
IHRoYXQncyBJIHVzZSBpbiB1LWJvb3QgZHJpdmVyLg0KPiA+IA0KPiA+IEhhcmluaS9QaXl1c2g6
IFBsZWFzZSBjb3JyZWN0IG1lIGlmIEkgYW0gd3JvbmcuDQo+IA0KPiBUaGFua3MgZm9yIHRoZSBw
YXRjaC4NCj4gDQo+IEdFTSBzaG91bGQgZGVmaW5pdGVseSBiZSByZXNldCBvbmNlIGFmdGVyIHRo
ZSBzZXJkZXMgaW5pdCBhbmQgcG93ZXIgb24gaXMNCj4gZG9uZS4NCj4gSXQgY2FuIGJlIGhlbGQg
aW4gcmVzZXQgYW5kIHJlbGVhc2VkIGFmdGVyIHNlcmRlcyBpbml0IG9yIHJlc2V0IHdpdGggYSAx
LTANCj4gYWZ0ZXINCj4gc2VyZGVzIGluaXQuIEVpdGhlciBzaG91bGQgYmUgZmluZSBidXQgYSBy
ZXNldCBiZWZvcmUgcGh5IGluaXQgbWF5IG5vdCB3b3JrLg0KPiBJJ3ZlIGFkZGVkIFJhZGhleSB3
aG8gd29ya2VkIG9uIHRoaXMgcmVjZW50bHkgYW5kIGNhbiBhZGQgYW55IGZ1cnRoZXIgaW5mby4N
Cg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2sgb24gdGhpcy4gSSBiZWxpZXZlIEkgcHJldHR5IG11
Y2ggYXJyaXZlZCBhdCB0aGUNCnNlcXVlbmNlIEkgaGFkIHZpYSB0cmlhbCBhbmQgZXJyb3Igd2hl
biB0cnlpbmcgdG8gZ2V0IHRoaW5ncyB0byB3b3JrIGFuZCBzbyBpdA0KbWlnaHQgbm90IHF1aXRl
IGJlIGlkZWFsLiBJJ3ZlIGRvbmUgc29tZSB0ZXN0cyB3aXRoIG1vdmluZyB0aGUgcmVzZXQgZG93
biB0bw0KYWZ0ZXIgdGhlIFBIWSBpbml0IGFuZCBwb3dlciBvbiBhbmQgdGhhdCBzZWVtcyB0byB3
b3JrIHdlbGwsIHNvIGlmIHRoYXQncyB0aGUNCnByZWZlcnJlZCBzZXF1ZW5jZSBJIGNhbiBzd2l0
Y2ggdG8gdGhhdC4NCg0KPiANCj4gUmVnYXJkcywNCj4gSGFyaW5pDQotLSANClJvYmVydCBIYW5j
b2NrDQpTZW5pb3IgSGFyZHdhcmUgRGVzaWduZXIsIENhbGlhbiBBZHZhbmNlZCBUZWNobm9sb2dp
ZXMNCnd3dy5jYWxpYW4uY29tDQo=
