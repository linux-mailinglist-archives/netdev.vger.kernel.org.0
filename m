Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DFF48CBF5
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 20:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356520AbiALT1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 14:27:33 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:5202 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345160AbiALT0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 14:26:32 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CE6nKP020453;
        Wed, 12 Jan 2022 14:26:02 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj0fcg7re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 14:26:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luBx1XR17BYkiNuw+1CvyYuOMT9VvZeB81xxxK+IFbHZEZbFgY6WDIUisV845Mh9HseXpPuPHAt3OwZb7QcMqhvCfeBN5yO74azM9/V81G3y41Eceq2ok7SbPj7OOTnO83UraC6pGFct0uIZz0hThm0HvHRx8PUmEIHu5gh9tzIgPuNLDgoPne0UzTwbzDWwUboaXAY8G/4tTKWR0EpMU7PFeG2rHI7j/C7QGT06J/1wy9cT1eR7Pai2l5gaTipz577idias/OW75803uenQYQ3SzGaGI6oWjWmLRXvvmM+MeI9ewTPIYVqdw260vSfn8zQqInetG3qaDdAkhNuuyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YWqUG48TxsVqdqAjBVquku5+HhCLVKQmo/PbFQBMu1s=;
 b=FVABuli7VXJ87On4/t8/1ja/sNB2wnsydXDWkEL42D/npZYzc3zXKRrXEIuYTBQHLKeImrelBIJcs+gtgfZXFgVFAI2nCTDNXnjh+KSidlftkhbZZcxJ4ECrKb+BisJXfe7Pylwytj8ZqjLjVlsn2q5xkl6VfdmaKbGgPxsIElu18zr0qtAJoEBv1+b3u4BPWiEKT2Uy3c/PL79chzpUPLoDUARfrz6DzGg9fiNxilhz/3RHDFMeoQV6NZbiP85BSmjGIlZ29yDssf2WGki6EYWcjJvOQjvKsHKL7ARGhDgtGoYyxVchlePMxCRXoMyAEoaQyU4Hyejm+61kWA6Xlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWqUG48TxsVqdqAjBVquku5+HhCLVKQmo/PbFQBMu1s=;
 b=4E8Q5NHbMqFGt0XiANuuW8oIYmYsrcSv2UlqEQx+C2nECD9r4pB5ilCIa+uPkwMO2eQMuE3KKWaTP1WPuDdasjgMnwmM9VyeoEKm1skPfmUbExSOGg743dWtF5DaDCBbT5nJ3Xi7sSREXX1EHitVpqCLnEgNDpjG+biC9TAalok=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTOPR0101MB2137.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 12 Jan
 2022 19:25:59 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 19:25:59 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ariane.keller@tik.ee.ethz.ch" <ariane.keller@tik.ee.ethz.ch>
Subject: Re: [PATCH net v2 2/9] net: axienet: Wait for PhyRstCmplt after core
 reset
Thread-Topic: [PATCH net v2 2/9] net: axienet: Wait for PhyRstCmplt after core
 reset
Thread-Index: AQHYB9siTmd37dFHx06OgTrgb8NTyaxfweoAgAAC0wA=
Date:   Wed, 12 Jan 2022 19:25:58 +0000
Message-ID: <d0b00b8c96be17e6ad636f5a74ebfb170a603eac.camel@calian.com>
References: <20220112173700.873002-1-robert.hancock@calian.com>
         <20220112173700.873002-3-robert.hancock@calian.com>
         <Yd8o6P6Pp7V7S+oL@lunn.ch>
In-Reply-To: <Yd8o6P6Pp7V7S+oL@lunn.ch>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b68c1a0b-6269-4a60-63b9-08d9d6015cd0
x-ms-traffictypediagnostic: YTOPR0101MB2137:EE_
x-microsoft-antispam-prvs: <YTOPR0101MB21379C860348A84608CE5F79EC529@YTOPR0101MB2137.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D/ZOqyl5TD/VraFXKFhzRUTK0zBGaDaTcTDGhBYRJNefWMvDu3Pttiz9GsLRs4G7lwrMv7YjyoDTxXmT9IMAaV3yNnaFW0kE1iYNFj/XS/ZqTe9B29hvTVS6uFiy9psWTvOypcTuIx6x/HvufLpX/1L4nen3pOr01E3QzktR949DHXQoqAYHxHlcNP4SKdunGpU1wN04zUKPxuVczowQXtl730Dg/OW9Zywx1reMEhU6TLcm38R84aUniyEyJngpBrYSbw6kLAiA4IqWqEUL6eK0CtI2jq3o1MKBvfRZXl+4PoazK8izLjHiORlvAiJ5MXMHxMDPnc5mGAbs3GGEcyrYNHYqu2IcFenSbA5BX4kgz+2V/+IAyQnwXoOXjEDIRhGeiFMgQwF+ARRlvj+3nmWos9Os8ylts2d0SM8Xk5iDFJVEPBkctX1meKtRrnH8CNvtpNxdOvHQhpoDLIxu8bUmzmXo+1rUuJg9yprp1cSDl6IU4rN/BFEaymD3zO/CLXcuKU2H04hOzX3ZlYIX4qN0G2+g2cGyvHQ8r5Z/bmVG6RQD4df1WL0N2uJgzAF9G7x68Of79IMbr1eN3Nl2STAECI7D0+W3LhuSZT7wnAQry678Jy8P8Y1oU7x+iaePkvweVKqx72etSY1+gKL42FnWZ+nwmN+ztqVF/4lbUP414F6XET9TClQ9aeJKQcrP4T+T9bheSNzIFrH3ipZzJFVu97S/eoZ5xiZAvfiu0XpoSTQfa0KdvfIRnAQcxPCraoOf9/WWqwn9IWqhu6ASjsO9DTldUMWwCSFs+CFBkL5gCEfnABfwu0dKaALFrYxD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(6916009)(71200400001)(91956017)(2616005)(6486002)(38070700005)(36756003)(6506007)(508600001)(316002)(26005)(186003)(6512007)(44832011)(5660300002)(122000001)(966005)(64756008)(66446008)(2906002)(8676002)(66556008)(66476007)(83380400001)(86362001)(8936002)(76116006)(54906003)(66946007)(4326008)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T1NRV2h1V25Oc0QvNkFmaCt4WkxKOGg1TFVMcHhWM0FkREJaY09iS3hNNDN0?=
 =?utf-8?B?Zi9NUU9EbkZSY1V4ZENkY25PQnQ0YkpjcUJYRGRjc0dINHVRUVVteGtuKzdU?=
 =?utf-8?B?ck5mSVIzSk13RnVscnYzQWhaa1QvM1JPbGNOck9DcTdiUW92N2xnYk1JajhL?=
 =?utf-8?B?Z3lYOWd5amo2clJoN2lOejZpQTRWa3N3NGNtZUEyV3h4Uy9rSzBUZkxIZGdm?=
 =?utf-8?B?YXlVc2tZdGRiT1M5MUhtalBrQ29KV3pLekxwemdXQWtlejJTcHVYa25USWhu?=
 =?utf-8?B?c0lFQXF2Mzc1UUcxb1RQREhjM3k3SlFkOVFOVXd4ckN3eTZvYi90NUdZbENN?=
 =?utf-8?B?NzZEWjZWSXllN0cvY0N0dTR0aHNDRjdkNURzaWJqd0Y2MkRXTGEvZVdIK3NU?=
 =?utf-8?B?ZGI5cUhNZUNrQ1hWa3IybnE5NUQ2YlNBS3p5TTB4ek83VVdnaEtKblFKTjV5?=
 =?utf-8?B?bmVGS1ZsMEc4dWxEYXptNDFyS0dZNTBNWU42MjExanBvVHphd2JaTnpUaTdK?=
 =?utf-8?B?amFDVmluVlQ0Vks3U1FxcUdjL0U5QlpXS3BLSEErODdkNmpKd2FKRElvODZF?=
 =?utf-8?B?RTNiNzYveDlXY3BLdE5vcUFES3lyOHpTOGZlZENMLzZQempvY3VpNk5yNjNQ?=
 =?utf-8?B?Ym1HZHg4RE00NmJLZ00vL1owRVhYU3M4QUpvUzBFUXVCTW9sSHV4N3dlRVh5?=
 =?utf-8?B?SHlVNzhMaW92ZkdyR2xmM1RKbTBzZXJocXF4aHoyQmVTQTg4MkpsWStJb3pJ?=
 =?utf-8?B?bmVmZkZCSzBBK21US0NTT24yMVJJc1NxNE5uM2pxNmtzUVdscm1SaGlraldv?=
 =?utf-8?B?QU9QVHlpQTlYaFFjMmRzaVVvTnVxQSttejg2a0lLSWExNW5aZDRnRWtha2dw?=
 =?utf-8?B?V2hZTDEvVzZKWC96aGhHZmJza3FkcW9VNzgycUtVOFFFbE1CZnJrTk5aT285?=
 =?utf-8?B?cW1teUJqNC9vUTY5c3NEUjVrRW1EcytYZk12MU5zZENRTTRSc2g0REc5Wlpq?=
 =?utf-8?B?cWxJWmtBWmJYNWZmVGxoWTh5Q3pjakFCSkNWVjdBT0RiRVhFVStuLzlqYXFr?=
 =?utf-8?B?WXk1SEZFbHlnM2JoS0pkeWZ5cys1YUJRaVQxMjVRYTFiTkZlQWJPM3VoWmpB?=
 =?utf-8?B?RlFmSFZhYjFKYUlEL3Q5YzZnRzliTkJoOGFWR3VKNjZqRktRbWNwV3hqZFJU?=
 =?utf-8?B?VUJNQ0hDZ09jZk5Lc3g1aFQ3aHZueFJXKzkrbis0REFOTEZYa1FJMjA0aCtC?=
 =?utf-8?B?U3U3bmsrNU9QSTFrTk1CY2l4UkREWi9ISW5JVC94dWJLYTRLUW1YNjA0OG5D?=
 =?utf-8?B?RG9qM1doL0lhZi9temlXYjdkbjg1WTFmQlZYU3FMWUdjS2N4NnFWTkFQNmZ2?=
 =?utf-8?B?L2E4VE9LKzAzSWlTOFZnM2RWL3FjY3BIN0NySFY1Tk9HRHNvTGtkcGo5NWtC?=
 =?utf-8?B?QWU2eFZIOUplQXVhaHkvU04xYTZoQXhZMmlvdXIwRVhFNW9NbVd3N1JQUC9w?=
 =?utf-8?B?cCtEQW0zSzJQSUtZL1FJYzJBa1Z5ak9GZFlqenJJdjl2SnJOMlJLU0J1ZlI1?=
 =?utf-8?B?WldUeFJ6aUJmSS80MHVrSlpBZGdIYmFPZ2oxN0IrbFIxRVBSOVZRdUJwV1E5?=
 =?utf-8?B?cDlZVlNMOXQrcE5ROVhib28rWm1CUThxQlFZdTJoVWY0dUVXVDh6U1lWS1Yx?=
 =?utf-8?B?UlFwdkZxUk8vRU5uN3oyVk9PNytJTkh2NURjOGkzbkZhT2lxVnFMZU9qV0py?=
 =?utf-8?B?RHVZY3JJQVJtZEdPR1A2LzF0UytFVlRRZ3Budm9pQVhGWDdZUnJJS0xMZjZX?=
 =?utf-8?B?ZnJDZjFLS3pNZit1Y3pvbEFad0FXUjFzYzVsMUdZY3hlVE1Xcnk5UVoxM0d2?=
 =?utf-8?B?RWVPQmpwV1I2RjVEZnFBN0RTS3VPOW9QanN4Vk5ERWJ4K3VSOFlqNmJLK1Qr?=
 =?utf-8?B?UTV3WGdrL3Fnc0lwWFJHQ1RjamsyNjE2NWlUQlF0MmtOaDhnVUQ4ZzQrM3d2?=
 =?utf-8?B?NHVoZ2xHRWJPODgzbkN0bGpqNDI2eFM4TUdROENPWDZGT0FmLy9zYUU2YW5E?=
 =?utf-8?B?SG9YVUs0eGIwdE81VEdVYmRRU0VvZGl0RitlSGI0cXRzWnFmWjg5OFZJOGdQ?=
 =?utf-8?B?RExONEFJemdHMFJidldNcWd0SjJmQjFEVkhocE56aUptSzVBdzRxVzIyWjJT?=
 =?utf-8?B?WmVNY3h4MXNJK2pOMnRrTU9teENxazZQNnY0S3ZRcFQ4RDhnUGw1LzNoYll0?=
 =?utf-8?Q?utFsOJOrOPwnYNUT5flfgVB/7VnwXCGcz39y3V6CrM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <94B95E047FA564419AD2E49FD7ED6B0B@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b68c1a0b-6269-4a60-63b9-08d9d6015cd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 19:25:58.9639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I+iPwwV3tNTkNm3EX0D2ZLhrTLaAciQeogWZbAWzYNhxsZR+ajJfa39fpjP+9arbpzjagQ5dmf4HrVxMsiW3+Tswgw9Ge/aoozaMDKvoOR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTOPR0101MB2137
X-Proofpoint-GUID: kC4q9Y5NHG21AT5b_t2fX0xWtZinboH3
X-Proofpoint-ORIG-GUID: kC4q9Y5NHG21AT5b_t2fX0xWtZinboH3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTAxLTEyIGF0IDIwOjE1ICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
T24gV2VkLCBKYW4gMTIsIDIwMjIgYXQgMTE6MzY6NTNBTSAtMDYwMCwgUm9iZXJ0IEhhbmNvY2sg
d3JvdGU6DQo+ID4gV2hlbiByZXNldHRpbmcgdGhlIGRldmljZSwgd2FpdCBmb3IgdGhlIFBoeVJz
dENtcGx0IGJpdCB0byBiZSBzZXQNCj4gPiBpbiB0aGUgaW50ZXJydXB0IHN0YXR1cyByZWdpc3Rl
ciBiZWZvcmUgY29udGludWluZyBpbml0aWFsaXphdGlvbiwgdG8NCj4gPiBlbnN1cmUgdGhhdCB0
aGUgY29yZSBpcyBhY3R1YWxseSByZWFkeS4gVGhlIE1ndFJkeSBiaXQgY291bGQgYWxzbyBiZQ0K
PiA+IHdhaXRlZCBmb3IsIGJ1dCB1bmZvcnR1bmF0ZWx5IHdoZW4gdXNpbmcgNy1zZXJpZXMgZGV2
aWNlcywgdGhlIGJpdCBkb2VzDQo+ID4gbm90IGFwcGVhciB0byB3b3JrIGFzIGRvY3VtZW50ZWQg
KGl0IHNlZW1zIHRvIGJlaGF2ZSBhcyBzb21lIHNvcnQgb2YNCj4gPiBsaW5rIHN0YXRlIGluZGlj
YXRpb24gYW5kIG5vdCBqdXN0IGFuIGluZGljYXRpb24gdGhlIHRyYW5zY2VpdmVyIGlzDQo+ID4g
cmVhZHkpIHNvIGl0IGNhbid0IHJlYWxseSBiZSByZWxpZWQgb24uDQo+ID4gDQo+ID4gRml4ZXM6
IDhhM2I3YTI1MmRjYTkgKCJkcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbng6IGFkZGVkIFhpbGlu
eCBBWEkNCj4gPiBFdGhlcm5ldCBkcml2ZXIiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IFJvYmVydCBI
YW5jb2NrIDxyb2JlcnQuaGFuY29ja0BjYWxpYW4uY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5jIHwgMTAgKysrKysrKysr
Kw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5j
DQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5j
DQo+ID4gaW5kZXggZjk1MDM0MmY2NDY3Li5mNDI1YTg0MDRhOWIgMTAwNjQ0DQo+ID4gLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21haW4uYw0KPiA+ICsr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9tYWluLmMNCj4g
PiBAQCAtNTE2LDYgKzUxNiwxNiBAQCBzdGF0aWMgaW50IF9fYXhpZW5ldF9kZXZpY2VfcmVzZXQo
c3RydWN0IGF4aWVuZXRfbG9jYWwNCj4gPiAqbHApDQo+ID4gIAkJcmV0dXJuIHJldDsNCj4gPiAg
CX0NCj4gPiAgDQo+ID4gKwkvKiBXYWl0IGZvciBQaHlSc3RDbXBsdCBiaXQgdG8gYmUgc2V0LCBp
bmRpY2F0aW5nIHRoZSBQSFkgcmVzZXQgaGFzDQo+ID4gZmluaXNoZWQgKi8NCj4gPiArCXJldCA9
IHJlYWRfcG9sbF90aW1lb3V0KGF4aWVuZXRfaW9yLCB2YWx1ZSwNCj4gPiArCQkJCXZhbHVlICYg
WEFFX0lOVF9QSFlSU1RDTVBMVF9NQVNLLA0KPiA+ICsJCQkJREVMQVlfT0ZfT05FX01JTExJU0VD
LCA1MDAwMCwgZmFsc2UsIGxwLA0KPiA+ICsJCQkJWEFFX0lTX09GRlNFVCk7DQo+ID4gKwlpZiAo
cmV0KSB7DQo+ID4gKwkJZGV2X2VycihscC0+ZGV2LCAiJXM6IHRpbWVvdXQgd2FpdGluZyBmb3Ig
UGh5UnN0Q21wbHRcbiIsDQo+ID4gX19mdW5jX18pOw0KPiA+ICsJCXJldHVybiByZXQ7DQo+ID4g
Kwl9DQo+ID4gKw0KPiANCj4gSXMgdGhpcyBiaXQgZ3VhcmFudGVlZCB0byBiZSBjbGVhciBiZWZv
cmUgeW91IHN0YXJ0IHdhaXRpbmcgZm9yIGl0Pw0KDQpUaGUgZG9jdW1lbnRhdGlvbiBmb3IgdGhl
IElQIGNvcmUgKCANCmh0dHBzOi8vd3d3LnhpbGlueC5jb20vY29udGVudC9kYW0veGlsaW54L3N1
cHBvcnQvZG9jdW1lbnRhdGlvbi9pcF9kb2N1bWVudGF0aW9uL2F4aV9ldGhlcm5ldC92N18yL3Bn
MTM4LWF4aS1ldGhlcm5ldC5wZGYNCiApIHN0YXRlcyBmb3IgdGhlIHBoeV9yc3RfbiBvdXRwdXQg
c2lnbmFsOiAiVGhpcyBhY3RpdmUtTG93IHJlc2V0IGlzIGhlbGQNCmFjdGl2ZSBmb3IgMTAgbXMg
YWZ0ZXIgcG93ZXIgaXMgYXBwbGllZCBhbmQgZHVyaW5nIGFueSByZXNldC4gQWZ0ZXIgdGhlIHJl
c2V0DQpnb2VzIGluYWN0aXZlLCB0aGUgUEhZIGNhbm5vdCBiZSBhY2Nlc3NlZCBmb3IgYW4gYWRk
aXRpb25hbCA1IG1zLiIgVGhlDQpQaHlSc3RDb21wbHQgYml0IGRlZmluaXRpb24gbWVudGlvbnMg
IlRoaXMgc2lnbmFsIGRvZXMgbm90IHRyYW5zaXRpb24gdG8gMSBmb3INCjUgbXMgYWZ0ZXIgUEhZ
X1JTVF9OIHRyYW5zaXRpb25zIHRvIDEiLiBHaXZlbiB0aGF0IGEgcmVzZXQgb2YgdGhlIGNvcmUg
aGFzIGp1c3QNCmJlZW4gY29tcGxldGVkIGFib3ZlLCB0aGUgUEhZIHJlc2V0IHNob3VsZCBhdCBs
ZWFzdCBoYXZlIGJlZW4gaW5pdGlhdGVkIGFzDQp3ZWxsLCBzbyBpdCBzaG91bGQgYmUgc3VmZmlj
aWVudCB0byBqdXN0IHdhaXQgZm9yIHRoZSBiaXQgdG8gYmVjb21lIDEgYXQgdGhpcw0KcG9pbnQu
DQoNCj4gDQo+ICAgIEFuZHJldw0K
