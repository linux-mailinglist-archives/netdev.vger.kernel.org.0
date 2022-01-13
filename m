Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AF148DBDD
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 17:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbiAMQeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 11:34:13 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:15294 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229474AbiAMQeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 11:34:12 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20DCNHrv005627;
        Thu, 13 Jan 2022 11:34:04 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2053.outbound.protection.outlook.com [104.47.60.53])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj0fcgvjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 11:34:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qgf4uFsaz8+U9b/F+9/2L2IeAOZAsZQtgqrggv16pNFcRlYYtTp3ovc1hn1IwOOwPPEJPI9De8rKGQdn9DbiINlpXW2BhI3r/qPlL4Pt+DAjZ4r4HqDn4r6Yt4JmgXRQgX+W/bh/XRgH/mMVRV7lJrD5HEuZAxaFECHoDb8jhQUe91JV7ZTPXuPSJb524XpTYFWYGfjLlBrAs613KUMhLK4ILqnFXp2cnQtxW/B5ShN4k98NF3aT3sPT0Q26km+TSgI3xedcTa73C81NP/4Q+YlP/Lt2TaIQ7izbnXsGRAJMwH1c+QGm6P7MKa/F4FTD+4snG9GZYjhuNWZJ6lQiTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LsVGPYZSomw6f+GWSPTOEOk8HneeFFOsdc/eC+NfbM4=;
 b=aGQ4zJdQu/FF0N5DcfuWULTey9HuEOgwuy9OcRGI94Fu+qCZ7SAGDFCuAfDfWHEeX8B0sq+BcsOR1ydyNj40djqFVOkZ/IFzVlOuyioLR9rKn5dPoMFL+5O6D6qBSEo1Z/SQzi9M19b/x5J5cG1W5fLg0ooJeQhx4yFNRc99IUl/t1zCQ+t3/LULekfuLeOZ8NweWcdNa0lgnkLu1IL+cO2BjH7C2pVJmVgazPCy4PflnoRFDFS/XBIGo9qGrUqiqmfPcemBHXmw2Eq0ngW55XnXEwQNi7Tg6ptOsvkkqxiNQDrbLZP/ihGbE3xUSZiC79bU0yGAIEWsBmUzDVwP3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LsVGPYZSomw6f+GWSPTOEOk8HneeFFOsdc/eC+NfbM4=;
 b=I+5eijLHbiNj6ARGa2ehulTenoV06+JudQyUZ7tPydSbh2zp23XxQ4qdYVKU8hwLo8shRqzl5z35xfByQF9e/HeVzV8b2uvXQLijdu3fIdT+c9tCLPCynOO43y8n2JII4u5kFNC6e2uuH6CVEOP0GtNXjcq4p6G9m0kxcEsF+yw=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT1PR01MB4233.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:28::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 16:34:02 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 16:34:02 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] macb: bindings doc: added generic PHY and
 reset mappings for ZynqMP
Thread-Topic: [PATCH net-next 1/3] macb: bindings doc: added generic PHY and
 reset mappings for ZynqMP
Thread-Index: AQHYB+AFnpyx9QceS0yLrcrcPty5NqxgjbIAgACZS4A=
Date:   Thu, 13 Jan 2022 16:34:02 +0000
Message-ID: <b8612073ebd24e4bf9f4e729bd5ea7c4678494e2.camel@calian.com>
References: <20220112181113.875567-1-robert.hancock@calian.com>
         <20220112181113.875567-2-robert.hancock@calian.com>
         <d5952271-a90f-4794-0087-9781d2258e17@xilinx.com>
In-Reply-To: <d5952271-a90f-4794-0087-9781d2258e17@xilinx.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a09faa5c-bf3c-4049-5ed8-08d9d6b281f1
x-ms-traffictypediagnostic: YT1PR01MB4233:EE_
x-microsoft-antispam-prvs: <YT1PR01MB4233C1F05EB58C3CA12A0FDEEC539@YT1PR01MB4233.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XGJ7stXHmm+2FyMABQUYBpWQjm6CgfIhnTwUVq0hGVj9EAg9nG6yE0cnH2o8FmfRvmJoczcHBV0ZZC6hZBFX0W1w4zW02ZmhgqaCuvJLLPGFA+pS20AhMx5s1EYWpJ7yrZcRKZCeZ4kp9DbZl5gW2Wbs1K82Fe3oKiHVNLWS1eg9FiSvKk9I9ifQtbAaEuiYq6ZnV101H3JiakhQQmCGIPwoqr+kIakXU0xw/JcraufBo3lms1tUZZLaAEcu7RsCRv6+mzcDP3JWgp9IGtSlXfpN8q64BPvoM1ffBIi1INyyX3retuab55JtHm909ThPZZJOJZKtJjwRi4NoXFVHaZNT69j6bq+RXMkkP5EBphBJl3fdN2rxtlj+CLMKJhc9h4V7JmsOpY/yzENnlU9jMUckSOC6RSNUGa4LJSUueGGLmZvLBpON2TGfpswu9rNroejSErX8KmNlbXFLVZ1ubb4KfmMaQLrLGwG4VwskVULfYelgbRrV6qsqL5QMbSMstKykexRsoeUaAQ2ZrpIT30XwxL8PtJXYwY+/lUpfjXHQB573Z+f4SwVb7dh2/Mk2t7zIBIcCUxSQ3WUwnHJz0bJRqgYh8AmCSgqcMSvu3jJc/EjsXsOxBVqUFo9ctK2wM5tUuM/ISwdgsRiNq1XGfbMcvTRbd4q2v5osKCMlQ8GHIjux1TusG5ry1J5dNI1Cqix7yI41+8PtY3RLIizz/qMQ9aaTxNNO0r9bzdI2OKWblTzF9Np17nZiuTJ9akQyKHkoygxNRjsq1EOCMROoj54raeyK+9TF7+QXRY2OyPSNDqXQqfRrqJKHiNwyA96AEeytUOmFhxcAQMYPyBngJJb/sx4N2bcPuYoqhROuJuLDNgqzB66A3yp/HKGus6AF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(110136005)(6506007)(66446008)(54906003)(36756003)(66556008)(64756008)(122000001)(53546011)(6512007)(26005)(66476007)(316002)(71200400001)(66946007)(508600001)(86362001)(44832011)(186003)(76116006)(8676002)(91956017)(8936002)(83380400001)(6486002)(5660300002)(15974865002)(38070700005)(2906002)(2616005)(4326008)(99106002)(41533002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnFmN1pDbG5UUTRaN3BUamVXaXFobThteFFQaGZWalJ6QXZobGQwNWxXeE1r?=
 =?utf-8?B?M2UxeWNoenptSjJDaFdWRFJMcjQwd3BFazcvUm5icnBJMmRIRi8wQjlITnI3?=
 =?utf-8?B?ZzdsM0dpTVpNSUN4T2IvbTluekV2Z0E0WmFueHJ3QVpxd2FTOWlONkU0NjdY?=
 =?utf-8?B?bGxWblkwb3g1Ym4xR05JTGU3WVBITGg4SWZKdGRwYVdzYURnODNUOXlDZlNB?=
 =?utf-8?B?MFB6VjZzeFV5SGhEK0h4Y3N2UWhvaUN6RFFjWG1vUHdJcXVUY294anI5WjFi?=
 =?utf-8?B?YU11aW5KZHJtekNaS0xPcHZ2K0RNNXRPTG5XL1Ixcnk3cEFCZkJYS1Q2S1VX?=
 =?utf-8?B?eGs3TmhiOWxPdlVIVVN4VjdXV1hlaWRoS2xITnJYRDdmM2VmWEtYTDBOT2xN?=
 =?utf-8?B?bE9pWVhnNTVRTEl5R29ZMHB0Z3RFdGVLMjVyU3QxWTFCN3ZUUVJXbzNHVU1q?=
 =?utf-8?B?ZXFSYVhSK3VhdHdyNUxWOTdMZHFQcnZUakVoaHJFdkJ0a0J2RnM4dHpRNVBl?=
 =?utf-8?B?OGRFbFg2TjdYM3c0eC9YYWNVaTJ5MFZRUVJPQUZ3QUdQaWwxRG00NHJyZ3VP?=
 =?utf-8?B?YkhEZ2p2RnNtSW5DMVNYNStWWG8xbHBYSlcwQkFIN0h3NStnb3FWaklDV3dh?=
 =?utf-8?B?UXBzb1J2YVlMNUFkRVFIZ0V5UU1jeVdNSnQ5aHFJeVJmdTEvaDBBWXVybjJU?=
 =?utf-8?B?N2YyMnVISkV2TDM1YWNQUXBFUi9EeGt0dEpTenNSZmE0clhpVWthdTduM2VT?=
 =?utf-8?B?WmE1eFFucWZWRnBGRTZZSFNmRlNTd3BOejFNcEV3YzdYWmlXUTArN1BVcFYz?=
 =?utf-8?B?d0tWdkRkSTVpTXdnbjZhWUpMbDc5b0lxek5tMmpNSitZdEp5MVVxSWVLNWIz?=
 =?utf-8?B?TmVxK2dqbkRVR04vM09HdTRKZytLVWVMNXkrRVRXSi9VcFY1T3dhbHI0azZW?=
 =?utf-8?B?ZGRyS2s5UXlTUXZZYm0vUGdsbTFMYnJYSWdydzM2SEJ5QkxabzVkcFNxYktM?=
 =?utf-8?B?ZXVLZDZxSE1NRU9WOTB1RTlOTktzTjFLUytTRXhtMVdKOUphUmNBb2g1aTgr?=
 =?utf-8?B?SmZxekthUkpRcmoyT3N1LzEzNWhtbjk0eFNSQlZSRmN5QkxseUIxK2xkOTFj?=
 =?utf-8?B?dm50M3puRE1Jb0hNOHlTNEZqdXpRYlNZbUtzRFpqQzZ2Y2E0NGJKKzRrcTh1?=
 =?utf-8?B?a0pDYzEwMHRjSWZibmFqMGRyeEtvZmYyMXBxMzFPTFRPay96L0swL1JyZkpL?=
 =?utf-8?B?cEplUWJEaHBBZUZnblJCaWRkMWIzNEpkWUxnS25yYVhYZDFVY3NLcXdpSGs3?=
 =?utf-8?B?V29QNjRwTGlRSUxVWE9NQWk4cDRrSUlvNmx1Q2w4UFdJRVgyNjl2MitMRkZR?=
 =?utf-8?B?L0NvSXVZRFZUSmd4bEtTTzFNUllQUDlMb2hQemh5aXN6ZDFjaGx1NVIwTytI?=
 =?utf-8?B?dlRLMVpTaGZRNGVsYWxmSVRQYlhmMHJkb2tFMXFKTUcxWmpXL1c3V1kwbndV?=
 =?utf-8?B?alMwVFVGUU11UHBKL3FsQlVtSlVpWWVyeFVWNVZwOGtFQXBJdHBIcCt4YzlU?=
 =?utf-8?B?MFVxMEluejlKSWdvdjNxZmlVamlWUU5EYy9LdFpKUXluVGR3WGIxeXVJTFVN?=
 =?utf-8?B?Z3F5SWJ0N0dVQkVOYnZteW5GN3MvRnF2Q1JHK1J6WXZMU3k4QWtIZjMvZUtk?=
 =?utf-8?B?Y2VqL3NXZkc1VDdKR0VaOGlnV3UyWDFzQlpPQnNuZlVUYU14Vjl0SVVlN0N2?=
 =?utf-8?B?K0U2dW9WRG0yVmJYZHZBblhYeUg3QWhrMHdWblg0b3E2dnoweERaOUxOSURn?=
 =?utf-8?B?Q0ZTdCtRbVIzaXBqVEJ0dWZyejR6Y1lSazVvMDhNZ1FpMVVUUXE4SytiTHRT?=
 =?utf-8?B?MVVSSGNjc01yRDZ2RTBGZWNuaWhyM0R6cXdVQTBtM3VUdW5pSE43YVZRbmdV?=
 =?utf-8?B?UGVIQlhhSVBSVzdrVmk0M3JmVmZnUXF3NTlQRmppWnF5VW94aVYxKzhmeE95?=
 =?utf-8?B?WW4vTlVGZmVOSFMzN3hxcGRvVkZ0c0R6Wm5aSE41ZXBKSytUa283R29vOXNE?=
 =?utf-8?B?UTV1ZUlKd3VoQ2FabFdkcVR6Q1BRZ1AzZVFEVWVmdVIxdW1vMHp5ZXRJWkdp?=
 =?utf-8?B?UnM5ckxsUVdsWVB2U3o3dG91emlWcXZEZjBkNUUxdktCZUptTW1HS2E1T2VD?=
 =?utf-8?B?cllGNkc5bmRNSkQ3eFcxQXFDTG1ZNmM0TjYrd0lwVkpaeDk4S2tKdmpyTy9r?=
 =?utf-8?Q?wL3WUhAhGoWqUkBibc8N/Oc9vYV7lzFQBr6yb9tZYk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <776E5EDFD51AB44D8B39AE5524834C74@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a09faa5c-bf3c-4049-5ed8-08d9d6b281f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 16:34:02.1613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IPrplCwGovIn+Vkj7iqYVbvnLOjpqjHSe/W3I5Au6xAnKUOhLEOTyBrCpj4Ini0Ga93hvp/kR8v/4DCS94E3wDHFrmjQSVEkL4ovWUT1+R0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB4233
X-Proofpoint-GUID: IcQY5OkzgaaxB5xBC3rispY7BZ_sP4h9
X-Proofpoint-ORIG-GUID: IcQY5OkzgaaxB5xBC3rispY7BZ_sP4h9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_08,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTAxLTEzIGF0IDA4OjI1ICswMTAwLCBNaWNoYWwgU2ltZWsgd3JvdGU6DQo+
IA0KPiBPbiAxLzEyLzIyIDE5OjExLCBSb2JlcnQgSGFuY29jayB3cm90ZToNCj4gPiBVcGRhdGVk
IG1hY2IgRFQgYmluZGluZyBkb2N1bWVudGF0aW9uIHRvIHJlZmxlY3QgdGhlIHBoeS1uYW1lcywg
cGh5cywNCj4gPiByZXNldHMsIHJlc2V0LW5hbWVzIHByb3BlcnRpZXMgd2hpY2ggYXJlIG5vdyB1
c2VkIHdpdGggWnlucU1QIEdFTQ0KPiA+IGRldmljZXMsIGFuZCBhZGRlZCBhIFp5bnFNUC1zcGVj
aWZpYyBEVCBleGFtcGxlLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFJvYmVydCBIYW5jb2Nr
IDxyb2JlcnQuaGFuY29ja0BjYWxpYW4uY29tPg0KPiA+IC0tLQ0KPiA+ICAgLi4uL2RldmljZXRy
ZWUvYmluZGluZ3MvbmV0L21hY2IudHh0ICAgICAgICAgIHwgMzMgKysrKysrKysrKysrKysrKysr
Kw0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDMzIGluc2VydGlvbnMoKykNCj4gPiANCj4gPiBkaWZm
IC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tYWNiLnR4dA0K
PiA+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tYWNiLnR4dA0KPiA+
IGluZGV4IGExYjA2ZmQxOTYyZS4uZTUyNjk1MjE0NWI4IDEwMDY0NA0KPiA+IC0tLSBhL0RvY3Vt
ZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWFjYi50eHQNCj4gPiArKysgYi9Eb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21hY2IudHh0DQo+ID4gQEAgLTI5LDYg
KzI5LDEyIEBAIFJlcXVpcmVkIHByb3BlcnRpZXM6DQo+ID4gICAJT3B0aW9uYWwgZWxlbWVudHM6
ICdyeF9jbGsnIGFwcGxpZXMgdG8gY2Rucyx6eW5xbXAtZ2VtDQo+ID4gICAJT3B0aW9uYWwgZWxl
bWVudHM6ICd0c3VfY2xrJw0KPiA+ICAgLSBjbG9ja3M6IFBoYW5kbGVzIHRvIGlucHV0IGNsb2Nr
cy4NCj4gPiArLSBwaHlfbmFtZXMsIHBoeXM6IFJlcXVpcmVkIHdpdGggWnlucU1QIFNvQyB3aGVu
IGluIFNHTUlJIG1vZGUuDQo+ID4gKyAgICAgICAgICAgICAgICAgICBwaHlfbmFtZXMgc2hvdWxk
IGJlICJzZ21paS1waHkiIGFuZCBwaHlzIHNob3VsZA0KPiA+ICsgICAgICAgICAgICAgICAgICAg
cmVmZXJlbmNlIFBTLUdUUiBnZW5lcmljIFBIWSBkZXZpY2UgZm9yIHRoaXMgY29udHJvbGxlcg0K
PiA+ICsgICAgICAgICAgICAgICAgICAgaW5zdGFuY2UuIFNlZSBaeW5xTVAgZXhhbXBsZSBiZWxv
dy4NCj4gPiArLSByZXNldHMsIHJlc2V0LW5hbWVzOiBSZWNvbW1lbmRlZCB3aXRoIFp5bnFNUCwg
c3BlY2lmeSByZXNldCBjb250cm9sIGZvcg0KPiA+IHRoaXMNCj4gPiArCQkgICAgICAgY29udHJv
bGxlciBpbnN0YW5jZSB3aXRoIHp5bnFtcC1yZXNldCBkcml2ZXIuDQo+ID4gICANCj4gPiAgIE9w
dGlvbmFsIHByb3BlcnRpZXM6DQo+ID4gICAtIG1kaW86IG5vZGUgY29udGFpbmluZyBQSFkgY2hp
bGRyZW4uIElmIHRoaXMgbm9kZSBpcyBub3QgcHJlc2VudCwgdGhlbg0KPiA+IFBIWXMNCj4gPiBA
QCAtNTgsMyArNjQsMzAgQEAgRXhhbXBsZXM6DQo+ID4gICAJCQlyZXNldC1ncGlvcyA9IDwmcGlv
RSA2IDE+Ow0KPiA+ICAgCQl9Ow0KPiA+ICAgCX07DQo+ID4gKw0KPiA+ICsJZ2VtMTogZXRoZXJu
ZXRAZmYwYzAwMDAgew0KPiA+ICsJCWNvbXBhdGlibGUgPSAiY2Rucyx6eW5xbXAtZ2VtIiwgImNk
bnMsZ2VtIjsNCj4gPiArCQlpbnRlcnJ1cHQtcGFyZW50ID0gPCZnaWM+Ow0KPiA+ICsJCWludGVy
cnVwdHMgPSA8MCA1OSA0PiwgPDAgNTkgND47DQo+ID4gKwkJcmVnID0gPDB4MCAweGZmMGMwMDAw
IDB4MCAweDEwMDA+Ow0KPiA+ICsJCWNsb2NrcyA9IDwmenlucW1wX2NsayBMUERfTFNCVVM+LCA8
Jnp5bnFtcF9jbGsgR0VNMV9SRUY+LA0KPiA+ICsJCQkgPCZ6eW5xbXBfY2xrIEdFTTFfVFg+LCA8
Jnp5bnFtcF9jbGsgR0VNMV9SWD4sDQo+ID4gKwkJCSA8Jnp5bnFtcF9jbGsgR0VNX1RTVT47DQo+
ID4gKwkJY2xvY2stbmFtZXMgPSAicGNsayIsICJoY2xrIiwgInR4X2NsayIsICJyeF9jbGsiLCAi
dHN1X2NsayI7DQo+ID4gKwkJI2FkZHJlc3MtY2VsbHMgPSA8MT47DQo+ID4gKwkJI3NpemUtY2Vs
bHMgPSA8MD47DQo+ID4gKwkJI3N0cmVhbS1pZC1jZWxscyA9IDwxPjsNCj4gPiArCQlpb21tdXMg
PSA8JnNtbXUgMHg4NzU+Ow0KPiA+ICsJCXBvd2VyLWRvbWFpbnMgPSA8Jnp5bnFtcF9maXJtd2Fy
ZSBQRF9FVEhfMT47DQo+ID4gKwkJcmVzZXRzID0gPCZ6eW5xbXBfcmVzZXQgWllOUU1QX1JFU0VU
X0dFTTE+Ow0KPiA+ICsJCXJlc2V0LW5hbWVzID0gImdlbTFfcnN0IjsNCj4gPiArCQlzdGF0dXMg
PSAib2theSI7DQo+ID4gKwkJcGh5LW1vZGUgPSAic2dtaWkiOw0KPiA+ICsJCXBoeS1uYW1lcyA9
ICJzZ21paS1waHkiOw0KPiA+ICsJCXBoeXMgPSA8JnBzZ3RyIDEgUEhZX1RZUEVfU0dNSUkgMSAx
PjsNCj4gPiArCQlmaXhlZC1saW5rIHsNCj4gPiArCQkJc3BlZWQgPSA8MTAwMD47DQo+ID4gKwkJ
CWZ1bGwtZHVwbGV4Ow0KPiA+ICsJCQlwYXVzZTsNCj4gPiArCQl9Ow0KPiA+ICsJfTsNCj4gDQo+
IEdlZXJ0IGFscmVhZHkgY29udmVydGVkIHRoaXMgZmlsZSB0byB5YW1sIHRoYXQncyB3aHkgeW91
IHNob3VsZCB0YXJnZXQgdGhpcw0KPiB2ZXJzaW9uLg0KDQpJcyB0aGF0IHZlcnNpb24gaW4gYSB0
cmVlIHNvbWV3aGVyZSB0aGF0IGNhbiBiZSBwYXRjaGVkIGFnYWluc3Q/DQoNCj4gDQo+IFRoYW5r
cywNCj4gTWljaGFsDQotLSANClJvYmVydCBIYW5jb2NrDQpTZW5pb3IgSGFyZHdhcmUgRGVzaWdu
ZXIsIENhbGlhbiBBZHZhbmNlZCBUZWNobm9sb2dpZXMNCnd3dy5jYWxpYW4uY29tDQo=
