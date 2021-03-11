Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B3E3381EC
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 00:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhCKXvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 18:51:07 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:42386 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231638AbhCKXvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 18:51:02 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12BNlYhh014669;
        Thu, 11 Mar 2021 18:50:56 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2058.outbound.protection.outlook.com [104.47.61.58])
        by mx0c-0054df01.pphosted.com with ESMTP id 375yymha32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 18:50:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N85tkJNH2YcqwIU0XS8h1KR4iINRNsf2dNRRK1Bc/tkCDybj6UpuvQHlOyyDnSv8kxc5xG7XVjX8A/BJFk135pZswAy+2vTyRNiSxLs7NCH8XRdne9Yw7c2kNEywa4cn4J3XOstQYvp0hIlAoLNuozlCSZLjtGg8MzmTPRTb1ey0yYodZxaOA0oGtyYT0XBz+LQPSSIV/Lpck2yqY3j8YzkjV9JecMs3obZ/Lv61brJECOU9rgdDHzY65DP+c2unf1fs2wiBR2P0TmVNFJ0DDYE3QSk0D0w8OamhNw7T/DXaVesKApKiJfzDPkjwlXLbu0X+mo4wVdeayYqxRJNc+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5oF68FqUR0idsbytKTdaj2A5hGrYSXJrK98VPpEQYg0=;
 b=iS6+Kk1zxmhlyoOm7YkBCuH2M0aSgoU1W6kfeBV50z9RHrNOG0P0PQcIL4soWhKH5PWhWs01yLBVkYT4toTBN5p6yC6LADJUDzlfSPEIhfpW+Gnp/gsWWXjl5r/sS1L/Id8QRZq2Ve1XULEIChg8KniyPZAcZJ3XmmPfooBK+Aei7JY3O9NG7HQ6rToc/zE6Dl7eMXoe1pEaKTK5Vphdsh91BAiQccsFsF0fwgSt5C0EktwWNwOhEh1S977Zj3OY0tNRYmZPUsQ45+F8JKa7+pPCJIa4+mJw4JXL6FHys0PWY8SiOU6F1/tVnu3xpgbvBeDUlaDP2lmwdZw8vsTQFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5oF68FqUR0idsbytKTdaj2A5hGrYSXJrK98VPpEQYg0=;
 b=EJ9C7sLCdwZU3QNbdKUeeBQ3pKm+no+gB08d1397ORow44i2jjs+dskq00M2QiazbExS3xYZUnpWbzrisYtRYpaqDYqYRiBuRWLdeh0zJRiVglco3wFexKoFHeYuWJVHor+FXpGuY3B1Voe+ZBOqNGu0YIYF49dNSAgmi7SXpPw=
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::17)
 by YTBPR01MB3552.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:16::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Thu, 11 Mar
 2021 23:50:53 +0000
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128]) by YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128%6]) with mapi id 15.20.3890.041; Thu, 11 Mar 2021
 23:50:53 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net: axienet: Enable more clocks
Thread-Topic: [PATCH net-next 2/2] net: axienet: Enable more clocks
Thread-Index: AQHXFrLDPggdvvmlFEmH1SfhOu00Uap/dVcA
Date:   Thu, 11 Mar 2021 23:50:53 +0000
Message-ID: <29465542349719ea7799639b434da9a3b29aa930.camel@calian.com>
References: <20210311201117.3802311-1-robert.hancock@calian.com>
         <20210311201117.3802311-3-robert.hancock@calian.com>
In-Reply-To: <20210311201117.3802311-3-robert.hancock@calian.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-16.el8) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 826f62db-022a-44a3-80cb-08d8e4e881ba
x-ms-traffictypediagnostic: YTBPR01MB3552:
x-microsoft-antispam-prvs: <YTBPR01MB355219182E47C1FFB9EAE518EC909@YTBPR01MB3552.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1HuWRNI71J8MBB8LrdZYCOg99Zm7qQWLQ+0v4d3NWtYtClkbJWIJwGiJkZKUGMH9/pfM+I92W3huR529ZwPkKocbRDPUUHPNYrlJRRLF12Mdw1OlxeVliF/M/cofw/A/4k7h5YHFV7G+vzhjNQARSeFmuwqE6/tMUCjNmfKrT63WaZqd4B/2h1riMQqMAMIq1h8mL+U3Xy0x9xWJRFRoAwPjcVVtCFS9TsIDHX5gg57Gv1XPhML0tJ12lqR5HxLVA/RxPdobzhJNu34vgcAZg8ZeJjt63WRVVEVRW5k9RZZbFo0YT/vtfc4NZJldbYEzE/O5kdZbQGonIYOmkCcaosHf0qXGX8FfWKkZj61M1Q10t1PQvHhdN8X7FnMVKQgszuR/7/+QlWAO7L1dLn33G2/wetxeLyghe+FgVISX9bTutPU0M1ebWJFAXjWqYxg1JFJ+I+mZZT5bhD6w24Xj36WkI3N53WnKbELPDlkQLYkAYpMDq1BQdXkZLK/8b3/URzzL/i1IIUsN7kMo+7YAAoYowcln37iyy2BjLU7qJYyIbW2ezgIYiYS34QfXd8rcv/1AtVIKBKNIlf9CNy7/7hIDhavsQy3W9fD7lZSWE+23ROKZiGQmZ4ByMRRD5To9x5PCzIU+4OcKVGZdBzd1ZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39850400004)(136003)(346002)(366004)(91956017)(2906002)(66946007)(66446008)(44832011)(86362001)(6512007)(64756008)(66556008)(76116006)(36756003)(478600001)(54906003)(966005)(5660300002)(26005)(66476007)(83380400001)(15974865002)(71200400001)(186003)(2616005)(6506007)(316002)(4326008)(8676002)(6486002)(8936002)(110136005)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?LzZZWlRYc2YybXNqdjJ1bmJ3c2lEWmVyanU3ZG1rdXAwcExLeWZNQ2VXd055?=
 =?utf-8?B?NC9nM0pDNnNmemJsTVRSQ3owcWRsSjhxZmdsa21ZUzBJazZqTXR6cFh2a2hk?=
 =?utf-8?B?UGpGZ2hXaUJwaUpZd2daQ0ZmY2s1YURicFpxRnVud3d1S3Uwd2xPaldZUHd3?=
 =?utf-8?B?bVM4akd5WjhDRFNaMU4xOWRrcHhkRXU0ZDcyME9ac2RJUlJvYWtHVFFuU0RK?=
 =?utf-8?B?eEdUazVzWmVZVjhPK2pTb1dreUNzaWNldTN6MU41bVJQS2R5bVRNSm5wWmlE?=
 =?utf-8?B?WGplcnI1L1RsYVRjMFJEL1BWTysyb25YUW1OSWQ5Vm9Va1MvcHYzK29IaHFX?=
 =?utf-8?B?SnVvZVBac25MU08rVWIvcUFMaml5SHMrbWZaY2FRNi84MUwyOWc3Qm1wT2xl?=
 =?utf-8?B?bE85Q3JYN3N4REh2Y2lVcmh3WktNUmx0Q1ZtZkRIMSs0SER0QW80UHpOTVpD?=
 =?utf-8?B?cmVGNnBxeTExV2g3eUZxTUZPQ3FUMDJvaWdxSEg1K2lVekE4T3RNc1J0c1dZ?=
 =?utf-8?B?SXJacFN4bS93NS9nRjZOa0F0Z212bSsweFpoRndLWWp5Yk5qUEVOdjdBU1E4?=
 =?utf-8?B?d1ZwK3kxM1ZxNDRnRXlHZUd0VkJGMUo1TW5TeTFhZEJEdzFlZDQrcnBtZUFR?=
 =?utf-8?B?QTNiOFNKNEFGemptTm81bXloWlFzT1ZoWk16MkVHR1BFd2ozUkpmNDdOTC92?=
 =?utf-8?B?cFYxc0FsaGJ2TFZSd3VyOUJJYlU4aTVDamVFQU9sRkF2aTdxZXVvTU1qRXBY?=
 =?utf-8?B?K3BlL25lTTJTenVTMnRnQlBVY3NWNXlmZitHZzljUEhEVTZWMDl0OTFaS3dV?=
 =?utf-8?B?dG1GalNKL3VRNDQ2WEZ2Q010SjNhTXNFSXNXUll0dDhPRFNzWkVlUWFUSm8v?=
 =?utf-8?B?MEFEYmZkTUJkcTNJSkNwYWQrb1UvbFVoaUJNNVFGdmtUNXExUVQxNm4xblhx?=
 =?utf-8?B?K2dmZHorMlF4VDBPQXl5Umhya0xQVzlKWVhUd3F0TGVFOURob0RqbDhoem5F?=
 =?utf-8?B?VHpiNDdRR3k4Q2N2ZmNVMmJ1NnBINEg5VEQ2enFpZFlIektkTnc0YWp4MmVa?=
 =?utf-8?B?a2JkdnA5VUtMSFljTHR4Q3JwQUZTQ28wUmVOcTNrM0hYQ2ZyQkxVZm9RWk9l?=
 =?utf-8?B?Z09SeCtKYlNIcUVwTGhIcFpXV0VHbUxyMXRLOHNnV3hWUDNFT3RaYnc4K2tS?=
 =?utf-8?B?YURVSDQycEUzeG5XNktJdjFVaG02V3V2allveENpbEwrbTJUS2oyWjQrRVRt?=
 =?utf-8?B?RkVVRVc5SUgrcXNadWJHc3JHL2NCS0FPNnBBQlFZbmZhU1FXQUl4M3hWYUJB?=
 =?utf-8?B?aGpHZlU1UmVxakpCTFptTkRHdVZjRXgxR0hTdHJUMzQ2Y2NuTGZsQU80cWp2?=
 =?utf-8?B?MDdMTUxmTjEzRjVwazlFUUpRWFc3TTFmVmpiV2ZFZjRDTWhxZ2s5V2pxek1N?=
 =?utf-8?B?N3NPb2FCNmpjZTVnckQwbG0rbG5SejlpclJzNHQvL2taWDBPS1hWY0FDYVBD?=
 =?utf-8?B?aDlhSlVkbVI4S2NFa2VIckg3R2NvcmxRY3ZTZjFPOEo5VDVBbHdiU1I0aHNv?=
 =?utf-8?B?akU1MjBHOWI0TDMxT091QmlnSlRCL0Y4bEl2aGdJU2pVUGRYOU5yemZoTjdO?=
 =?utf-8?B?aThrbGpvZjR4Q1l0MWloOXcvektPVjBMaFlYNTZhTUEvZFBwc3dzd2pEZ0hq?=
 =?utf-8?B?Slk2ZldEalNrNElJSmJzMVBXQWNUb0JLNUI0YjdUVjdJbjFiekF5eXVGYkR2?=
 =?utf-8?Q?Kv6HTdXCi6fDzk1aC0ilbzEJUMOyVaeNkDe0oVn?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0140750609EE2A428BC47C14D84E7D51@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 826f62db-022a-44a3-80cb-08d8e4e881ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 23:50:53.2164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h9ZHVgnigXpvYoPGBXP2IWHJSi4Naz8FB5MUbCTF/TfVHxPwiVpkK2/zvfaXj04PZcsQKqsYfG5X+4jjGtKo2ttL6FIjUegYPGdz55RlRuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3552
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_12:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103110130
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTAzLTExIGF0IDE0OjExIC0wNjAwLCBSb2JlcnQgSGFuY29jayB3cm90ZToN
Cj4gVGhpcyBkcml2ZXIgd2FzIG9ubHkgZW5hYmxpbmcgdGhlIGZpcnN0IGNsb2NrIG9uIHRoZSBk
ZXZpY2UsIHJlZ2FyZGxlc3MNCj4gb2YgaXRzIG5hbWUuIEhvd2V2ZXIsIHRoaXMgY29udHJvbGxl
ciBsb2dpYyBjYW4gaGF2ZSBtdWx0aXBsZSBjbG9ja3MNCj4gd2hpY2ggc2hvdWxkIGFsbCBiZSBl
bmFibGVkLiBBZGQgc3VwcG9ydCBmb3IgZW5hYmxpbmcgYWRkaXRpb25hbCBjbG9ja3MuDQo+IFRo
ZSBjbG9jayBuYW1lcyB1c2VkIGFyZSBtYXRjaGluZyB0aG9zZSB1c2VkIGluIHRoZSBYaWxpbngg
dmVyc2lvbiBvZiB0aGlzDQo+IGRyaXZlciBhcyB3ZWxsIGFzIHRoZSBYaWxpbnggZGV2aWNlIHRy
ZWUgZ2VuZXJhdG9yLCBleGNlcHQgZm9yIG1ndF9jbGsNCj4gd2hpY2ggaXMgbm90IHByZXNlbnQg
dGhlcmUuDQo+IA0KPiBGb3IgYmFja3dhcmQgY29tcGF0aWJpbGl0eSwgaWYgbm8gbmFtZWQgY2xv
Y2tzIGFyZSBwcmVzZW50LCB0aGUgZmlyc3QNCj4gY2xvY2sgcHJlc2VudCBpcyB1c2VkIGZvciBk
ZXRlcm1pbmluZyB0aGUgTURJTyBidXMgY2xvY2sgZGl2aWRlci4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IFJvYmVydCBIYW5jb2NrIDxyb2JlcnQuaGFuY29ja0BjYWxpYW4uY29tPg0KPiANCg0KTm90
ZSB0aGF0IHRoaXMgcGF0Y2ggaXMgZGVwZW5kZW50IG9uICJuZXQ6IGF4aWVuZXQ6IEZpeCBwcm9i
ZSBlcnJvciBjbGVhbnVwIiAoDQpodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3Qv
bmV0ZGV2YnBmL3BhdGNoLzIwMjEwMzExMjAwNTE4LjM4MDE5MTYtMS1yb2JlcnQuaGFuY29ja0Bj
YWxpYW4uY29tLw0KICkgd2hpY2ggaXMgdGFnZ2VkIGZvciB0aGUgbmV0IHRyZWUuDQoNCj4gLS0t
DQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXQuaCAgfCAgOCAr
KystLQ0KPiAgLi4uL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5jIHwg
MzQgKysrKysrKysrKysrKysrLS0tLQ0KPiAgLi4uL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54
X2F4aWVuZXRfbWRpby5jIHwgIDQgKy0tDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDM1IGluc2VydGlv
bnMoKyksIDExIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldC5oDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
eGlsaW54L3hpbGlueF9heGllbmV0LmgNCj4gaW5kZXggMWU5NjZhMzk5NjdlLi45MmY3Y2VmYjM0
NWUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhp
ZW5ldC5oDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5l
dC5oDQo+IEBAIC0zNzYsNiArMzc2LDggQEAgc3RydWN0IGF4aWRtYV9iZCB7DQo+ICAJc3RydWN0
IHNrX2J1ZmYgKnNrYjsNCj4gIH0gX19hbGlnbmVkKFhBWElETUFfQkRfTUlOSU1VTV9BTElHTk1F
TlQpOw0KPiAgDQo+ICsjZGVmaW5lIFhBRV9OVU1fTUlTQ19DTE9DS1MgMw0KPiArDQo+ICAvKioN
Cj4gICAqIHN0cnVjdCBheGllbmV0X2xvY2FsIC0gYXhpZW5ldCBwcml2YXRlIHBlciBkZXZpY2Ug
ZGF0YQ0KPiAgICogQG5kZXY6CVBvaW50ZXIgZm9yIG5ldF9kZXZpY2UgdG8gd2hpY2ggaXQgd2ls
bCBiZSBhdHRhY2hlZC4NCj4gQEAgLTM4NSw3ICszODcsOCBAQCBzdHJ1Y3QgYXhpZG1hX2JkIHsN
Cj4gICAqIEBwaHlsaW5rX2NvbmZpZzogcGh5bGluayBjb25maWd1cmF0aW9uIHNldHRpbmdzDQo+
ICAgKiBAcGNzX3BoeToJUmVmZXJlbmNlIHRvIFBDUy9QTUEgUEhZIGlmIHVzZWQNCj4gICAqIEBz
d2l0Y2hfeF9zZ21paTogV2hldGhlciBzd2l0Y2hhYmxlIDEwMDBCYXNlWC9TR01JSSBtb2RlIGlz
IGVuYWJsZWQgaW4NCj4gdGhlIGNvcmUNCj4gLSAqIEBjbGs6CUNsb2NrIGZvciBBWEkgYnVzDQo+
ICsgKiBAYXhpX2NsazoJQVhJIGJ1cyBjbG9jaw0KPiArICogQG1pc2NfY2xrczoJT3RoZXIgZGV2
aWNlIGNsb2Nrcw0KPiAgICogQG1paV9idXM6CVBvaW50ZXIgdG8gTUlJIGJ1cyBzdHJ1Y3R1cmUN
Cj4gICAqIEBtaWlfY2xrX2RpdjogTUlJIGJ1cyBjbG9jayBkaXZpZGVyIHZhbHVlDQo+ICAgKiBA
cmVnc19zdGFydDogUmVzb3VyY2Ugc3RhcnQgZm9yIGF4aWVuZXQgZGV2aWNlIGFkZHJlc3Nlcw0K
PiBAQCAtNDM0LDcgKzQzNyw4IEBAIHN0cnVjdCBheGllbmV0X2xvY2FsIHsNCj4gIA0KPiAgCWJv
b2wgc3dpdGNoX3hfc2dtaWk7DQo+ICANCj4gLQlzdHJ1Y3QgY2xrICpjbGs7DQo+ICsJc3RydWN0
IGNsayAqYXhpX2NsazsNCj4gKwlzdHJ1Y3QgY2xrX2J1bGtfZGF0YSBtaXNjX2Nsa3NbWEFFX05V
TV9NSVNDX0NMT0NLU107DQo+ICANCj4gIAlzdHJ1Y3QgbWlpX2J1cyAqbWlpX2J1czsNCj4gIAl1
OCBtaWlfY2xrX2RpdjsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlu
eC94aWxpbnhfYXhpZW5ldF9tYWluLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngv
eGlsaW54X2F4aWVuZXRfbWFpbi5jDQo+IGluZGV4IDVkNjc3ZGIwYWVlNS4uOTYzNTEwMWZiYjg4
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVu
ZXRfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhp
ZW5ldF9tYWluLmMNCj4gQEAgLTE4NjMsMTcgKzE4NjMsMzUgQEAgc3RhdGljIGludCBheGllbmV0
X3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UNCj4gKnBkZXYpDQo+ICAJbHAtPnJ4X2JkX251
bSA9IFJYX0JEX05VTV9ERUZBVUxUOw0KPiAgCWxwLT50eF9iZF9udW0gPSBUWF9CRF9OVU1fREVG
QVVMVDsNCj4gIA0KPiAtCWxwLT5jbGsgPSBkZXZtX2Nsa19nZXRfb3B0aW9uYWwoJnBkZXYtPmRl
diwgTlVMTCk7DQo+IC0JaWYgKElTX0VSUihscC0+Y2xrKSkgew0KPiAtCQlyZXQgPSBQVFJfRVJS
KGxwLT5jbGspOw0KPiArCWxwLT5heGlfY2xrID0gZGV2bV9jbGtfZ2V0X29wdGlvbmFsKCZwZGV2
LT5kZXYsICJzX2F4aV9saXRlX2NsayIpOw0KPiArCWlmICghbHAtPmF4aV9jbGspIHsNCj4gKwkJ
LyogRm9yIGJhY2t3YXJkIGNvbXBhdGliaWxpdHksIGlmIG5hbWVkIEFYSSBjbG9jayBpcyBub3QN
Cj4gcHJlc2VudCwNCj4gKwkJICogdHJlYXQgdGhlIGZpcnN0IGNsb2NrIHNwZWNpZmllZCBhcyB0
aGUgQVhJIGNsb2NrLg0KPiArCQkgKi8NCj4gKwkJbHAtPmF4aV9jbGsgPSBkZXZtX2Nsa19nZXRf
b3B0aW9uYWwoJnBkZXYtPmRldiwgTlVMTCk7DQo+ICsJfQ0KPiArCWlmIChJU19FUlIobHAtPmF4
aV9jbGspKSB7DQo+ICsJCXJldCA9IFBUUl9FUlIobHAtPmF4aV9jbGspOw0KPiAgCQlnb3RvIGZy
ZWVfbmV0ZGV2Ow0KPiAgCX0NCj4gLQlyZXQgPSBjbGtfcHJlcGFyZV9lbmFibGUobHAtPmNsayk7
DQo+ICsJcmV0ID0gY2xrX3ByZXBhcmVfZW5hYmxlKGxwLT5heGlfY2xrKTsNCj4gIAlpZiAocmV0
KSB7DQo+IC0JCWRldl9lcnIoJnBkZXYtPmRldiwgIlVuYWJsZSB0byBlbmFibGUgY2xvY2s6ICVk
XG4iLCByZXQpOw0KPiArCQlkZXZfZXJyKCZwZGV2LT5kZXYsICJVbmFibGUgdG8gZW5hYmxlIEFY
SSBjbG9jazogJWRcbiIsIHJldCk7DQo+ICAJCWdvdG8gZnJlZV9uZXRkZXY7DQo+ICAJfQ0KPiAg
DQo+ICsJbHAtPm1pc2NfY2xrc1swXS5pZCA9ICJheGlzX2NsayI7DQo+ICsJbHAtPm1pc2NfY2xr
c1sxXS5pZCA9ICJyZWZfY2xrIjsNCj4gKwlscC0+bWlzY19jbGtzWzJdLmlkID0gIm1ndF9jbGsi
Ow0KPiArDQo+ICsJcmV0ID0gZGV2bV9jbGtfYnVsa19nZXRfb3B0aW9uYWwoJnBkZXYtPmRldiwg
WEFFX05VTV9NSVNDX0NMT0NLUywgbHAtDQo+ID5taXNjX2Nsa3MpOw0KPiArCWlmIChyZXQpDQo+
ICsJCWdvdG8gY2xlYW51cF9jbGs7DQo+ICsNCj4gKwlyZXQgPSBjbGtfYnVsa19wcmVwYXJlX2Vu
YWJsZShYQUVfTlVNX01JU0NfQ0xPQ0tTLCBscC0+bWlzY19jbGtzKTsNCj4gKwlpZiAocmV0KQ0K
PiArCQlnb3RvIGNsZWFudXBfY2xrOw0KPiArDQo+ICAJLyogTWFwIGRldmljZSByZWdpc3RlcnMg
Ki8NCj4gIAlldGhyZXMgPSBwbGF0Zm9ybV9nZXRfcmVzb3VyY2UocGRldiwgSU9SRVNPVVJDRV9N
RU0sIDApOw0KPiAgCWxwLT5yZWdzID0gZGV2bV9pb3JlbWFwX3Jlc291cmNlKCZwZGV2LT5kZXYs
IGV0aHJlcyk7DQo+IEBAIC0yMTA5LDcgKzIxMjcsOCBAQCBzdGF0aWMgaW50IGF4aWVuZXRfcHJv
YmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIAlvZl9ub2RlX3B1dChscC0+cGh5
X25vZGUpOw0KPiAgDQo+ICBjbGVhbnVwX2NsazoNCj4gLQljbGtfZGlzYWJsZV91bnByZXBhcmUo
bHAtPmNsayk7DQo+ICsJY2xrX2J1bGtfZGlzYWJsZV91bnByZXBhcmUoWEFFX05VTV9NSVNDX0NM
T0NLUywgbHAtPm1pc2NfY2xrcyk7DQo+ICsJY2xrX2Rpc2FibGVfdW5wcmVwYXJlKGxwLT5heGlf
Y2xrKTsNCj4gIA0KPiAgZnJlZV9uZXRkZXY6DQo+ICAJZnJlZV9uZXRkZXYobmRldik7DQo+IEBA
IC0yMTMyLDcgKzIxNTEsOCBAQCBzdGF0aWMgaW50IGF4aWVuZXRfcmVtb3ZlKHN0cnVjdCBwbGF0
Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICANCj4gIAlheGllbmV0X21kaW9fdGVhcmRvd24obHApOw0K
PiAgDQo+IC0JY2xrX2Rpc2FibGVfdW5wcmVwYXJlKGxwLT5jbGspOw0KPiArCWNsa19idWxrX2Rp
c2FibGVfdW5wcmVwYXJlKFhBRV9OVU1fTUlTQ19DTE9DS1MsIGxwLT5taXNjX2Nsa3MpOw0KPiAr
CWNsa19kaXNhYmxlX3VucHJlcGFyZShscC0+YXhpX2Nsayk7DQo+ICANCj4gIAlvZl9ub2RlX3B1
dChscC0+cGh5X25vZGUpOw0KPiAgCWxwLT5waHlfbm9kZSA9IE5VTEw7DQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXRfbWRpby5jDQo+IGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21kaW8uYw0KPiBpbmRl
eCA5YzAxNGNlZTM0YjIuLjQ4ZjU0NGY2Yzk5OSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21kaW8uYw0KPiArKysgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXRfbWRpby5jDQo+IEBAIC0xNTksOCArMTU5
LDggQEAgaW50IGF4aWVuZXRfbWRpb19lbmFibGUoc3RydWN0IGF4aWVuZXRfbG9jYWwgKmxwKQ0K
PiAgDQo+ICAJbHAtPm1paV9jbGtfZGl2ID0gMDsNCj4gIA0KPiAtCWlmIChscC0+Y2xrKSB7DQo+
IC0JCWhvc3RfY2xvY2sgPSBjbGtfZ2V0X3JhdGUobHAtPmNsayk7DQo+ICsJaWYgKGxwLT5heGlf
Y2xrKSB7DQo+ICsJCWhvc3RfY2xvY2sgPSBjbGtfZ2V0X3JhdGUobHAtPmF4aV9jbGspOw0KPiAg
CX0gZWxzZSB7DQo+ICAJCXN0cnVjdCBkZXZpY2Vfbm9kZSAqbnAxOw0KPiAgDQotLSANClJvYmVy
dCBIYW5jb2NrDQpTZW5pb3IgSGFyZHdhcmUgRGVzaWduZXIsIENhbGlhbiBBZHZhbmNlZCBUZWNo
bm9sb2dpZXMNCnd3dy5jYWxpYW4uY29tDQo=
