Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2882748BBDB
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 01:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347206AbiALAak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 19:30:40 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:8827 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346577AbiALAak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 19:30:40 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20C0N06V012625;
        Tue, 11 Jan 2022 19:30:35 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2054.outbound.protection.outlook.com [104.47.60.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dgjrs9b6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 19:30:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWLBDimD1jA3yHpfFPv7x2tixhehmboYBhBdR9NQPKO6UHBex2P8V26G6CRtG/C+iDkcPZOCqfKFPGTLFgdRC4mTAhx+QIY8ne1GJezyH8PjIRfbNy5mkbhgn+H8UxGxPNCMOUoXLl8vF9aHCJYLsM+C2Qkydx8UhDQjrF4vjsxIQpF1y/szRWOQ0bLV555hJx5zimamV9Lih2B7zyyDQVlMW4zDERnsgAABafYdW+VyJfoz/koM41mKZX0EhA95BP9yk6ISA+FkcuusTsomOp/csixnwxHOmmu4A+OYCmWNvpTmaRAHMrDQOXoTh0c/l/I5MVFUBJM0ZuPKPtR7sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TufdMLiDVuHT86um2DZuAD/PQilB8C9PHzEvir+yXys=;
 b=gcug+uumawb3p3vaHSVf8Nz5CJ+gTZKM0+e/nteMRTEygMTdeI2PfWScWEouRFqUSrybN5ZPPm+vPTkvwAYlId88Npu0iSb7bLAhwF/+ymMxBRfirj+dPH6oPXYiBFzsRayL6JU+kzExmRnTLLMMzT3DRBat4KGBWmQAxWWjkB66jY9byySKkbO68wtM15kciMGsmWNMmyzUiFncLRdQs9GcfeVbnmO604GXVcGmTIP0RLBTMyKCMUSXBsl12F/uFJ+jvYhdV0UmtK7tjLnfnNfkHuVonMMZIJAMrs+zmWQ8ibkUJLld7iykDi10T7bCDN3uQa32xcWqMcmfBlMfEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TufdMLiDVuHT86um2DZuAD/PQilB8C9PHzEvir+yXys=;
 b=gwGXjEnc3Whfsm9kwJn0KHryfnERUUidINst/pQPHJY5jN0Dc3LlD3TPFYuiHA1DwKWh6D4l1AP9Lnwp8umK1YRBsjHr9oUJOMKFuSZBdKNeKMcY3Feoq5U21OVF16RVwYRvmv5A83zbPKyhzGXA04QUjB5j46yhwu1F8yknkA0=
Received: from YT2PR01MB6270.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:4d::14)
 by YT3PR01MB8788.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:7d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Wed, 12 Jan
 2022 00:30:33 +0000
Received: from YT2PR01MB6270.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4441:49c3:f6d1:65ec]) by YT2PR01MB6270.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4441:49c3:f6d1:65ec%9]) with mapi id 15.20.4867.012; Wed, 12 Jan 2022
 00:30:33 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH net 1/7] net: axienet: Reset core before accessing MAC and
 wait for core ready
Thread-Topic: [PATCH net 1/7] net: axienet: Reset core before accessing MAC
 and wait for core ready
Thread-Index: AQHYBzA3l79aNpCzkEq2jvYVBMWu/qxeiNYA
Date:   Wed, 12 Jan 2022 00:30:33 +0000
Message-ID: <b66ac3d0a3c544ca082eb5c8d25c72dc1ce8f451.camel@calian.com>
References: <20220111211358.2699350-1-robert.hancock@calian.com>
         <20220111211358.2699350-2-robert.hancock@calian.com>
In-Reply-To: <20220111211358.2699350-2-robert.hancock@calian.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d3ad23a-8c34-425d-0141-08d9d562beb3
x-ms-traffictypediagnostic: YT3PR01MB8788:EE_
x-microsoft-antispam-prvs: <YT3PR01MB8788A94AC602FA0EA5EDE7C2EC529@YT3PR01MB8788.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /2lLlZRLbPz5J26eCGZIlEQ7hQscVNtknxbY1FMABiuobkJIavBrX1JlpjBpqFCqN9Xe3pF8Fms6VvoSUKJPgZ2YugcobIXNzHp9PaoZWdPgyqrLQZwT/iYvSkM+Nt8kQ0J+cMUnRRXi9whas1Y8MY1Cp/xO5RNipcLAM6SfiRHckuZWhYMmkgxnnGYvAW7W7rX5dg/TtTq8uxKj2akYaV5d5pTz+caJFjYB02X4WCAHFtDGZpCK49GLDw1G28kBAWbAdZjHQsR486TjcIhjbJEsP4WXzcCIopocK8plugbrjPY9KDVZqdwkKh+AsGGyqoz4R1l+QsnfqMz1XpIEOpEuw6t+sIxrp1A/GgahczLZzwnb9e2A40dP3FBjqNjV6C6EOAPj2YVaOVbJBsPNogxZZ5MnyK4VYhN0RIStTF+Li9H3B0D7TSHK+xgQIPux2rOYw3bV438/1ZNmiEJDUtrfYVFi8gU5kgvnhGnlSyJ02sjWiCNgC58t8klnLixZuGwQE4zWj11sojFQMA4gQeEXnEk79SSJYswg417JOcHcDi03az1P6hYeTtF506tgelJErbVi05zbRRjxSrdU+hpJgG7mIEMRjTYVlprZ6k70UVFnzbNVWjPlExvsm03AsYmTxVZVEc4C9y/Xhf+QGAFbodirNm4zVDrUWo66wfReAO/Psu6tqkFW08No/AePvmNwdiZSkg2eDQJFFryNYBuxF+A3Fx7Gq0GNElczB2c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB6270.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(76116006)(66946007)(91956017)(4326008)(64756008)(71200400001)(2616005)(66476007)(66446008)(66556008)(54906003)(44832011)(508600001)(36756003)(122000001)(86362001)(83380400001)(8676002)(6486002)(5660300002)(6916009)(6512007)(6506007)(26005)(38070700005)(316002)(186003)(8936002)(38100700002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eE1DUWU5US91NjJXdk1FZzhOOWlFUDV1dFErR2k5a213YkxxQzFwK2RTd3lK?=
 =?utf-8?B?SHFCdmpmWjQxYXBHOUlrNWQvQXd3NFd3cWRVYmRKVmxLbStnOE15bWJEOEJW?=
 =?utf-8?B?c0hlZTQya0VtU1BBRDFUbklxRzFxTTZXcmpXR0ZJK09EV2FsSGQ4enlkcTlP?=
 =?utf-8?B?ekIxZXJ6Z0JOc2lTK3JFWnhpUGRTYjk1UHhKdXpmRHZFdkZsdkFEMzZLOXAr?=
 =?utf-8?B?RjE0RU1zaWp3MGtyS2Q3UURSR1FjeVE2bENnUVQybmlrREppRlhTUEJoU0tD?=
 =?utf-8?B?eGptZmNZZFZKeFVGRzBDU2hwOG1UbWlLUjVadmo0OVZlYUNPdm5OcnhiYk9W?=
 =?utf-8?B?bW9EMEZta2ZqLzBTV1ZiOGdjV2YyNWNqWDhBdFIzTytBam9RaEI0U2lhTW1V?=
 =?utf-8?B?MEFSQmlDblkxSWZOUlFjZnVnNWRnZWQzMGdhNjVlOXR6bi81dW9Gb1B3SUh6?=
 =?utf-8?B?OUF0VG5vM3dVMVpNY3dxM3hTQ1drODVzTU5VRW5xUDZDVzNUM1RUa2VvclpT?=
 =?utf-8?B?c3ozNUpNZjdWekFNcnFhSmNNclY3REcwb0YyTDcvUGR3MkVjazVlV1M3R2xG?=
 =?utf-8?B?dmNXNWd6ZDBMVWV2SVpXU213VmhlZFVJbjUxdlNVV1dxbTE3Nyt6eEUyVjBo?=
 =?utf-8?B?V090WC9adjFZS1ZkNk9IQVVJcWcwNW1xWkRXTjhidEN4dDh3YmRnNTFQWk8w?=
 =?utf-8?B?cUMvRmhZRUZkMFVXZjJuZXJUL1V2MS9mSlhyU3BuL3R4T2RUUVMrWURSSnVB?=
 =?utf-8?B?MXBpSEZrRHZoelpGaW9aMHVvYk84Wlp5a0M3aTR1UklXOE1xMzJsVVFzYmJL?=
 =?utf-8?B?akE1alkrVlR1Y2VGZnNja29iR1Y1dDNianZLV1ZFWjhheUV1ZStqQzFsWDlp?=
 =?utf-8?B?M2wrOVp6SEdpYjN6ZC84Qys0ZCszS1NYQmhjU3R3NUNzWCtqc1hxQjdUUW1F?=
 =?utf-8?B?TmhaNmVtOXQ5aEhmVVUrdGpmdGZVRmJsUy9VeXpUQTVhcFV0b09yK0hwWHRz?=
 =?utf-8?B?TlpZajBZU0xPRUpCY2d4K0g2WXlQWDRVbHFDNHl3dGVuSFhzL2pvd0lLV3Ux?=
 =?utf-8?B?b0VsZkVhcTVZdVRRbkpJRGxmbVl5MmxRV1lwMVNVVTQ3a2xkQUNVZnJwQUds?=
 =?utf-8?B?Y09lcUdZTmJBWXRmdlRMYno2c3dEdmtpRVFwSHFudnlLeDluZjkxaU9VamtF?=
 =?utf-8?B?R2xSaUcrNHNtS0dLSk8rNXhOYXBndmJkQ1RHMDlKTWNwTG9CUy94S2ZyZlVX?=
 =?utf-8?B?Q1FBUHVQYlhqKzRkdUUxclA2NE5GbDY1U1FLS0REVHdRTmxqUzhQelBZTWtu?=
 =?utf-8?B?N3RuMHNZcysyNis0Q2g5czdoQVk2TWxQYlNrcmpudHdNekQ3a2ZVa1BoL2ZU?=
 =?utf-8?B?RHc0TVNYYklWZTVjNTRrcStKNnRPR01vOHZsQ0Nxb09vL2NySjlzTlVyTGNu?=
 =?utf-8?B?dEo4bXErYkorbUY4UVJNOXl6ZWtUQ1lkK0JUOWtrNXh5N2RycHdUbUxXUWNW?=
 =?utf-8?B?RXFENHRBOWJNTmFxSk9sQUlnM1ZtYWVoYUxla3RWczV3bFkwZklHMmxJekdw?=
 =?utf-8?B?SW1zQlNPOElYWHlZaW01dmhHUkYveXNMNFJMZUFjNVlBZW1QWndWTUhTVW9G?=
 =?utf-8?B?bmhmYU9xTWxqYXZ6c2pZTWpxRVdpbG1EOHJHRmtybmFMZUJodzhyQUhzaVJi?=
 =?utf-8?B?cnhtM3pSZm5LZ3AvRzJKN0labFNWV1RlNzVFRk9GV0M0a3JoTXRQZHhLRHIv?=
 =?utf-8?B?dWY2QjFkSHFsckhTckhRdzdHU01qcDdUdlJVNi92SlNNcmJRcjFXRG1VRmt3?=
 =?utf-8?B?MG9kTWFFdjlIbjdGVnpSMmFZRVZJTFZxcStPR1BlTm82MW1ZYkxKVTB3OE1N?=
 =?utf-8?B?eVA3Y24rNmZtK3B4eEFkd3B3dFAyRitwOVNoWkU2MVBRYW1kWldLNGQvZ2Qy?=
 =?utf-8?B?OEw4N2g5UmZXaWIrRXNoU1JBbXgvNUtzWU12WUErbllZaEdobmJLUDJtQjJQ?=
 =?utf-8?B?TGx0L0Q5dXBRcHVLYSs0cWU0QWhvVHlCZlRUMUZwdEpXOUdYU0syZXhoK09X?=
 =?utf-8?B?WmhvSnozcnYyOGRsLzVpTEx4Rm42TFZVY3NQNGo4UXFRcUd0eWQ1bmpndUpk?=
 =?utf-8?B?T0w3Si9lVCtiTy83Z1dETE1Ga0VzWGkzanpaTEg3RW9qY29wQmFqbkdCYk9n?=
 =?utf-8?B?dHptc0JFMmRhbUMzYjV6ZVZSTXVWcXFubXlzSDRFVlk0WjZEYUkybzV6VEI2?=
 =?utf-8?Q?RPxgL5+wVb435QBbkMTyfgRkT3Zyx01w56BMKxgFqE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73551C16934D904786C2805E89140665@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB6270.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d3ad23a-8c34-425d-0141-08d9d562beb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 00:30:33.1924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: axX+/3y6T4/2csOZhSxZf++fsS3gP1GQiO0WlRLSdlp1iKf4u8f2v4UuYKNBVgnRR42eal7WD/EQPoJURVV30Y8ZVNb+Sf827MtEEpUC13U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB8788
X-Proofpoint-ORIG-GUID: wG1UxroUmw2qr16U5L5tzePRfhVGgQTy
X-Proofpoint-GUID: wG1UxroUmw2qr16U5L5tzePRfhVGgQTy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTAxLTExIGF0IDE1OjEzIC0wNjAwLCBSb2JlcnQgSGFuY29jayB3cm90ZToN
Cj4gSW4gc29tZSBjYXNlcyB3aGVyZSB0aGUgWGlsaW54IEV0aGVybmV0IGNvcmUgd2FzIHVzZWQg
aW4gMTAwMEJhc2UtWCBvcg0KPiBTR01JSSBtb2Rlcywgd2hpY2ggdXNlIHRoZSBpbnRlcm5hbCBQ
Q1MvUE1BIFBIWSwgYW5kIHRoZSBNR1QNCj4gdHJhbnNjZWl2ZXIgY2xvY2sgc291cmNlIGZvciB0
aGUgUENTIHdhcyBub3QgcnVubmluZyBhdCB0aGUgdGltZSB0aGUNCj4gRlBHQSBsb2dpYyB3YXMg
bG9hZGVkLCB0aGUgY29yZSB3b3VsZCBjb21lIHVwIGluIGEgc3RhdGUgd2hlcmUgdGhlDQo+IFBD
UyBjb3VsZCBub3QgYmUgZm91bmQgb24gdGhlIE1ESU8gYnVzLiBUbyBmaXggdGhpcywgdGhlIEV0
aGVybmV0IGNvcmUNCj4gKGluY2x1ZGluZyB0aGUgUENTKSBzaG91bGQgYmUgcmVzZXQgYWZ0ZXIg
ZW5hYmxpbmcgdGhlIGNsb2NrcywgcHJpb3IgdG8NCj4gYXR0ZW1wdGluZyB0byBhY2Nlc3MgdGhl
IFBDUyB1c2luZyBvZl9tZGlvX2ZpbmRfZGV2aWNlLg0KPiANCj4gQWxzbywgd2hlbiByZXNldHRp
bmcgdGhlIGRldmljZSwgd2FpdCBmb3IgdGhlIFBoeVJzdENtcGx0IGJpdCB0byBiZSBzZXQNCj4g
aW4gdGhlIGludGVycnVwdCBzdGF0dXMgcmVnaXN0ZXIgYmVmb3JlIGNvbnRpbnVpbmcgaW5pdGlh
bGl6YXRpb24sIHRvDQo+IGVuc3VyZSB0aGF0IHRoZSBjb3JlIGlzIGFjdHVhbGx5IHJlYWR5LiBU
aGUgTWd0UmR5IGJpdCBjb3VsZCBhbHNvIGJlDQo+IHdhaXRlZCBmb3IsIGJ1dCB1bmZvcnR1bmF0
ZWx5IHdoZW4gdXNpbmcgNy1zZXJpZXMgZGV2aWNlcywgdGhlIGJpdCBkb2VzDQo+IG5vdCBhcHBl
YXIgdG8gd29yayBhcyBkb2N1bWVudGVkIChpdCBzZWVtcyB0byBiZWhhdmUgYXMgc29tZSBzb3J0
IG9mDQo+IGxpbmsgc3RhdGUgaW5kaWNhdGlvbiBhbmQgbm90IGp1c3QgYW4gaW5kaWNhdGlvbiB0
aGUgdHJhbnNjZWl2ZXIgaXMNCj4gcmVhZHkpIHNvIGl0IGNhbid0IHJlYWxseSBiZSByZWxpZWQg
b24uDQo+IA0KPiBGaXhlczogM2UwOGZkNGE4Mjk4IChuZXQ6IGF4aWVuZXQ6IFByb3Blcmx5IGhh
bmRsZSBQQ1MvUE1BIFBIWSBmb3IgMTAwMEJhc2VYDQo+IG1vZGUpDQoNClBhdGNod29yayBwb2lu
dHMgb3V0IHRoYXQgdGhpcyBjb21taXQgZG9lc24ndCBleGlzdCBpbiBtYWlubGluZSwgaXQncyBm
cm9tIHRoZQ0KNS4xMCBzdGFibGUgdHJlZS4gVGhlIGNvcnJlc3BvbmRpbmcgbWFpbmxpbmUgY29t
bWl0IGlzDQoxYTAyNTU2MDg2ZmMwZWIxNmUwYTBkMDkwNDNlOWZmYjBlMzFjN2RiLg0KDQo+IFNp
Z25lZC1vZmYtYnk6IFJvYmVydCBIYW5jb2NrIDxyb2JlcnQuaGFuY29ja0BjYWxpYW4uY29tPg0K
PiAtLS0NCj4gIC4uLi9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21haW4uYyB8
IDM0ICsrKysrKysrKysrKystLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyNCBpbnNlcnRpb25z
KCspLCAxMCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQveGlsaW54L3hpbGlueF9heGllbmV0X21haW4uYw0KPiBpbmRleCA5MDE0NGFjN2FlZTguLmY0
YWUwMzViZWQzNSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hp
bGlueF9heGllbmV0X21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngv
eGlsaW54X2F4aWVuZXRfbWFpbi5jDQo+IEBAIC00OTYsNyArNDk2LDggQEAgc3RhdGljIHZvaWQg
YXhpZW5ldF9zZXRvcHRpb25zKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LA0KPiB1MzIgb3B0aW9u
cykNCj4gIA0KPiAgc3RhdGljIGludCBfX2F4aWVuZXRfZGV2aWNlX3Jlc2V0KHN0cnVjdCBheGll
bmV0X2xvY2FsICpscCkNCj4gIHsNCj4gLQl1MzIgdGltZW91dDsNCj4gKwl1MzIgdmFsdWU7DQo+
ICsJaW50IHJldDsNCj4gIA0KPiAgCS8qIFJlc2V0IEF4aSBETUEuIFRoaXMgd291bGQgcmVzZXQg
QXhpIEV0aGVybmV0IGNvcmUgYXMgd2VsbC4gVGhlIHJlc2V0DQo+ICAJICogcHJvY2VzcyBvZiBB
eGkgRE1BIHRha2VzIGEgd2hpbGUgdG8gY29tcGxldGUgYXMgYWxsIHBlbmRpbmcNCj4gQEAgLTUw
NiwxNSArNTA3LDIzIEBAIHN0YXRpYyBpbnQgX19heGllbmV0X2RldmljZV9yZXNldChzdHJ1Y3Qg
YXhpZW5ldF9sb2NhbA0KPiAqbHApDQo+ICAJICogdGhleSBib3RoIHJlc2V0IHRoZSBlbnRpcmUg
RE1BIGNvcmUsIHNvIG9ubHkgb25lIG5lZWRzIHRvIGJlIHVzZWQuDQo+ICAJICovDQo+ICAJYXhp
ZW5ldF9kbWFfb3V0MzIobHAsIFhBWElETUFfVFhfQ1JfT0ZGU0VULCBYQVhJRE1BX0NSX1JFU0VU
X01BU0spOw0KPiAtCXRpbWVvdXQgPSBERUxBWV9PRl9PTkVfTUlMTElTRUM7DQo+IC0Jd2hpbGUg
KGF4aWVuZXRfZG1hX2luMzIobHAsIFhBWElETUFfVFhfQ1JfT0ZGU0VUKSAmDQo+IC0JCQkJWEFY
SURNQV9DUl9SRVNFVF9NQVNLKSB7DQo+IC0JCXVkZWxheSgxKTsNCj4gLQkJaWYgKC0tdGltZW91
dCA9PSAwKSB7DQo+IC0JCQluZXRkZXZfZXJyKGxwLT5uZGV2LCAiJXM6IERNQSByZXNldCB0aW1l
b3V0IVxuIiwNCj4gLQkJCQkgICBfX2Z1bmNfXyk7DQo+IC0JCQlyZXR1cm4gLUVUSU1FRE9VVDsN
Cj4gLQkJfQ0KPiArCXJldCA9IHJlYWRfcG9sbF90aW1lb3V0KGF4aWVuZXRfZG1hX2luMzIsIHZh
bHVlLA0KPiArCQkJCSEodmFsdWUgJiBYQVhJRE1BX0NSX1JFU0VUX01BU0spLA0KPiArCQkJCURF
TEFZX09GX09ORV9NSUxMSVNFQywgNTAwMDAsIGZhbHNlLCBscCwNCj4gKwkJCQlYQVhJRE1BX1RY
X0NSX09GRlNFVCk7DQo+ICsJaWYgKHJldCkgew0KPiArCQlkZXZfZXJyKGxwLT5kZXYsICIlczog
RE1BIHJlc2V0IHRpbWVvdXQhXG4iLCBfX2Z1bmNfXyk7DQo+ICsJCXJldHVybiByZXQ7DQo+ICsJ
fQ0KPiArDQo+ICsJLyogV2FpdCBmb3IgUGh5UnN0Q21wbHQgYml0IHRvIGJlIHNldCwgaW5kaWNh
dGluZyB0aGUgUEhZIHJlc2V0IGhhcw0KPiBmaW5pc2hlZCAqLw0KPiArCXJldCA9IHJlYWRfcG9s
bF90aW1lb3V0KGF4aWVuZXRfaW9yLCB2YWx1ZSwNCj4gKwkJCQl2YWx1ZSAmIFhBRV9JTlRfUEhZ
UlNUQ01QTFRfTUFTSywNCj4gKwkJCQlERUxBWV9PRl9PTkVfTUlMTElTRUMsIDUwMDAwLCBmYWxz
ZSwgbHAsDQo+ICsJCQkJWEFFX0lTX09GRlNFVCk7DQo+ICsJaWYgKHJldCkgew0KPiArCQlkZXZf
ZXJyKGxwLT5kZXYsICIlczogdGltZW91dCB3YWl0aW5nIGZvciBQaHlSc3RDbXBsdFxuIiwNCj4g
X19mdW5jX18pOw0KPiArCQlyZXR1cm4gcmV0Ow0KPiAgCX0NCj4gIA0KPiAgCXJldHVybiAwOw0K
PiBAQCAtMjA0Niw2ICsyMDU1LDExIEBAIHN0YXRpYyBpbnQgYXhpZW5ldF9wcm9iZShzdHJ1Y3Qg
cGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgCWxwLT5jb2FsZXNjZV9jb3VudF9yeCA9IFhBWElE
TUFfREZUX1JYX1RIUkVTSE9MRDsNCj4gIAlscC0+Y29hbGVzY2VfY291bnRfdHggPSBYQVhJRE1B
X0RGVF9UWF9USFJFU0hPTEQ7DQo+ICANCj4gKwkvKiBSZXNldCBjb3JlIG5vdyB0aGF0IGNsb2Nr
cyBhcmUgZW5hYmxlZCwgcHJpb3IgdG8gYWNjZXNzaW5nIE1ESU8gKi8NCj4gKwlyZXQgPSBfX2F4
aWVuZXRfZGV2aWNlX3Jlc2V0KGxwKTsNCj4gKwlpZiAocmV0KQ0KPiArCQlnb3RvIGNsZWFudXBf
Y2xrOw0KPiArDQo+ICAJbHAtPnBoeV9ub2RlID0gb2ZfcGFyc2VfcGhhbmRsZShwZGV2LT5kZXYu
b2Zfbm9kZSwgInBoeS1oYW5kbGUiLCAwKTsNCj4gIAlpZiAobHAtPnBoeV9ub2RlKSB7DQo+ICAJ
CXJldCA9IGF4aWVuZXRfbWRpb19zZXR1cChscCk7DQo=
