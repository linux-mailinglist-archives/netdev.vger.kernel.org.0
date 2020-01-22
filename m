Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2B6144E08
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 09:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgAVI4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 03:56:35 -0500
Received: from mail-eopbgr30123.outbound.protection.outlook.com ([40.107.3.123]:45215
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbgAVI4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 03:56:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYi+Ap+C6vuAaIRKMZwpEqxeOsJXUDle37LfUmXHD08G63QoXm/uhnJsourr+kVGS68T+q/0rKTYcssPylqlLSiFw4wyCd23THEBsOs5ERII7cJqjfMOZudYHWE3krp5k+/r+COUCTPFW5jK46LU+hMZUGknshCn1zQw3cERNKihkkKGIbmJXOrS8Ld0kTUfRi0AlpN48K/8lnwgX5QYfEclmk+U7Z8dQVJnVGTjJboQ3FMpQnmsP7xMnb2xo1P1kD1skZbrqnSRv3cdheQ1YqcrpDUK8xBbGWBxrDuYxFzdVUZui76xqTTG/bKltRTg9xfcGQtxcQUbikbzwU1axg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+pE8rYtRPkOuNsNFF+9JekgCvkwlUyq2VL1Lkzrjhc=;
 b=NuHm9y5uvZHqjCq361Gv23BsgH4Plwob3rDWbAaQPW9a838Ja8V+dS0AZQla/5c7ZpIQND57DrfSgMFmj6zAH7GXf0PeW4v9mGNGjOHbKNtE0vPBdQMM2gXnNr33xlnz9TpcQktctNmP/qc4wYB4VqSfiYtrFavvvzwjwUdrLPJ5REfWjKQhS6NXtIVr6Faik9Iae5sm5Yx/OwMTbF7XOfq7R2h91nVNcK9SYRahu5/1yGQqkhYVbqHwydXC95UZwnmMe+lak+qeVPcSTTcFG9M0IXG7Kzige7SWM2wA4H9vdLAaIOerNrkp234+CEqroAQAHKZVqeFCH7qRiZJIrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+pE8rYtRPkOuNsNFF+9JekgCvkwlUyq2VL1Lkzrjhc=;
 b=F5TJjUzrx6fgR3lX8n15Jq5amXAwaTvM/uxymHPV/oKnAygkyoe1Ep4bCaujM7wFOr1CWGsn/I7qBG+eITZvdmtn9UK4j5c8BdjwVWtsYZAWap2574N0w9BZc56gRD5rSkmQFmi+WEG1I//Wj7KqVj1uC3bPMCwLlD+YgAbSF9w=
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com (20.178.20.19) by
 AM0PR05MB5617.eurprd05.prod.outlook.com (20.178.114.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 22 Jan 2020 08:56:31 +0000
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7]) by AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7%6]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 08:56:31 +0000
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "matteo.croce@redhat.com" <matteo.croce@redhat.com>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: [PATCH] mvneta driver disallow XDP program on hardware buffer
 management
Thread-Topic: [PATCH] mvneta driver disallow XDP program on hardware buffer
 management
Thread-Index: AQHV0QHXhq9dlCCNu0aI+Ym7zKijkA==
Date:   Wed, 22 Jan 2020 08:56:31 +0000
Message-ID: <581AE616-51FA-41F0-B4F1-E0CA761D68F2@voleatech.de>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sven.auhagen@voleatech.de; 
x-originating-ip: [37.24.174.42]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 952d5ce9-6521-48ef-b0fc-08d79f18f9ed
x-ms-traffictypediagnostic: AM0PR05MB5617:
x-microsoft-antispam-prvs: <AM0PR05MB561766C02AD6B80815713AF5EF0C0@AM0PR05MB5617.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39830400003)(366004)(376002)(346002)(136003)(396003)(189003)(199004)(316002)(2616005)(66574012)(44832011)(33656002)(71200400001)(76116006)(66446008)(64756008)(66556008)(66476007)(54906003)(66946007)(86362001)(6512007)(8676002)(6486002)(508600001)(186003)(26005)(4326008)(81156014)(8936002)(6916009)(81166006)(2906002)(15974865002)(36756003)(5660300002)(6506007)(309714004);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR05MB5617;H:AM0PR05MB5156.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: voleatech.de does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vCHGe+7MoiFsUv+cmlO7MslFlI04d99qvjV/NFpZ+5YD0Y8jN0sIYFh19/LHqjdUlkEE8F7OiWE2IHp8Q1Fi8WuN1R5uoo5ufMYWrQImViibdMEZRStYKpYJgWAoiemxIMAtqY8z8l2iLh5oKOPt+PMCtD4cgmdBs9NHU3KFCArOTmSA6FRAXC8tYCO8YmlVdvXywMT+LMNsQNblcP4pB0qh8pEeSoP37ZJcd7Pmac/8BkMM5oClc1f7EyhH7a/fzD1iqyMb2PDOQ5iB3QZJQLOtZ7w7IfQ48lu/aFWhZksTIuJxrJE5Zzi26F4FMyLbIo/MxI2dSZ10aZS4Ttg40Ai0IDIha4UtPjguGTePXPAOE2U+8vOs01ZGNjIIKUjtV8Rq1AfjwnFQeQVAdQYSMadMPl4OEc9FD3s40Kh9X+EFoKBdBJ/lNdKyBavZSboPt3HlnRyzNQ2AhVWpleqSRLu4se2WMWeHA6TUB7HKHSNyRoNmMrKdg8o9H34fi8hG
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <44B5A7BC45E4C14D835EC431197D6EB3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 952d5ce9-6521-48ef-b0fc-08d79f18f9ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 08:56:31.6370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xQSyDZpbeYizPN8a57qct9y1AXTI8BA8g/JVabhBH7A5/wI75G8OAs0/1mQIJ2j4LfVp9CgScrUFa7hxEBSDMIbBD+kzyiPAhED+kqxuVAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5617
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmVjZW50bHkgWERQIFN1cHBvcnQgd2FzIGFkZGVkIHRvIHRoZSBtdm5ldGEgZHJpdmVyIGZvciBz
b2Z0d2FyZSBidWZmZXIgbWFuYWdlbWVudCBvbmx5Lg0KSXQgaXMgc3RpbGwgcG9zc2libGUgdG8g
YXR0YWNoIGFuIFhEUCBwcm9ncmFtIGlmIGhhcmR3YXJlIGJ1ZmZlciBtYW5hZ2VtZW50IGlzIHVz
ZWQuDQpJdCBpcyBub3QgZG9pbmcgYW55dGhpbmcgYXQgdGhhdCBwb2ludC4NCg0KVGhlIHBhdGNo
IGRpc2FsbG93cyBhdHRhY2hpbmcgWERQIHByb2dyYW1zIHRvIG12bmV0YSBpZiBoYXJkd2FyZSBi
dWZmZXIgbWFuYWdlbWVudCBpcyB1c2VkLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdmVuIEF1aGFnZW4g
PHN2ZW4uYXVoYWdlbkB2b2xlYXRlY2guZGU+DQoNCi0tLSBkcml2ZXJzL25ldC9ldGhlcm5ldC9t
YXJ2ZWxsL212bmV0YS5jICAgICAgICAgICAgMjAyMC0wMS0yMiAwODo0NDowNS42MTEzOTU5NjAg
KzAwMDANCisrKyBkcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL212bmV0YS5jICAgICAgICAg
MjAyMC0wMS0yMiAwODo0NToyMy40NzIyNjM3OTUgKzAwMDANCkBAIC00MjI1LDYgKzQyMjUsMTEg
QEAgc3RhdGljIGludCBtdm5ldGFfeGRwX3NldHVwKHN0cnVjdCBuZXRfZA0KICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICByZXR1cm4gLUVPUE5PVFNVUFA7DQogICAgICAgICAgICAgICAg
fQ0KDQorICAgICAgICAgICAgICBpZiAocHAtPmJtX3ByaXYpIHsNCisgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBOTF9TRVRfRVJSX01TR19NT0QoZXh0YWNrLCAiSGFyZHdhcmUgQnVmZmVy
IE1hbmFnZW1lbnQgbm90IHN1cHBvcnRlZCBvbiBYRFAiKTsNCisgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICByZXR1cm4gLUVPUE5PVFNVUFA7DQorICAgICAgICAgICAgICB9DQorDQogICAg
ICAgICAgICAgICAgbmVlZF91cGRhdGUgPSAhIXBwLT54ZHBfcHJvZyAhPSAhIXByb2c7DQogICAg
ICAgICAgICAgICAgaWYgKHJ1bm5pbmcgJiYgbmVlZF91cGRhdGUpDQogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIG12bmV0YV9zdG9wKGRldik7DQoNCg0KDQorKysgVm9sZWF0ZWNoIGF1
ZiBkZXIgRS1Xb3JsZCwgMTEuIGJpcyAxMy4gRmVicnVhciAyMDIwLCBIYWxsZSA1LCBTdGFuZCA1
MjEgKysrDQoNCkJlc3RlIEdyw7zDn2UvQmVzdCByZWdhcmRzDQoNClN2ZW4gQXVoYWdlbg0KRGlw
bC4gTWF0aC4gb2VjLiwgTS5TYy4NClZvbGVhdGVjaCBHbWJIDQpIUkI6IEIgNzU0NjQzDQpVU1RJ
RDogREUzMDM2NDMxODANCkdyYXRod29obHN0ci4gNQ0KNzI3NjIgUmV1dGxpbmdlbg0KVGVsOiAr
NDkgNzEyMTUzOTU1MA0KRmF4OiArNDkgNzEyMTUzOTU1MQ0KRS1NYWlsOiBzdmVuLmF1aGFnZW5A
dm9sZWF0ZWNoLmRlDQp3d3cudm9sZWF0ZWNoLmRlPGh0dHBzOi8vd3d3LnZvbGVhdGVjaC5kZT4N
CkRpZXNlIEluZm9ybWF0aW9uIGlzdCBhdXNzY2hsaWXDn2xpY2ggZsO8ciBkZW4gQWRyZXNzYXRl
biBiZXN0aW1tdCB1bmQga2FubiB2ZXJ0cmF1bGljaCBvZGVyIGdlc2V0emxpY2ggZ2VzY2jDvHR6
dGUgSW5mb3JtYXRpb25lbiBlbnRoYWx0ZW4uIFdlbm4gU2llIG5pY2h0IGRlciBiZXN0aW1tdW5n
c2dlbcOkw59lIEFkcmVzc2F0IHNpbmQsIHVudGVycmljaHRlbiBTaWUgYml0dGUgZGVuIEFic2Vu
ZGVyIHVuZCB2ZXJuaWNodGVuIFNpZSBkaWVzZSBNYWlsLiBBbmRlcmVuIGFscyBkZW0gYmVzdGlt
bXVuZ3NnZW3DpMOfZW4gQWRyZXNzYXRlbiBpc3QgZXMgdW50ZXJzYWd0LCBkaWVzZSBFLU1haWwg
enUgbGVzZW4sIHp1IHNwZWljaGVybiwgd2VpdGVyenVsZWl0ZW4gb2RlciBpaHJlbiBJbmhhbHQg
YXVmIHdlbGNoZSBXZWlzZSBhdWNoIGltbWVyIHp1IHZlcndlbmRlbi4gRsO8ciBkZW4gQWRyZXNz
YXRlbiBzaW5kIGRpZSBJbmZvcm1hdGlvbmVuIGluIGRpZXNlciBNYWlsIG51ciB6dW0gcGVyc8O2
bmxpY2hlbiBHZWJyYXVjaC4gRWluZSBXZWl0ZXJsZWl0dW5nIGRhcmYgbnVyIG5hY2ggUsO8Y2tz
cHJhY2hlIG1pdCBkZW0gQWJzZW5kZXIgZXJmb2xnZW4uIFdpciB2ZXJ3ZW5kZW4gYWt0dWVsbGUg
VmlyZW5zY2h1dHpwcm9ncmFtbWUuIEbDvHIgU2Now6RkZW4sIGRpZSBkZW0gRW1wZsOkbmdlciBn
bGVpY2h3b2hsIGR1cmNoIHZvbiB1bnMgenVnZXNhbmR0ZSBtaXQgVmlyZW4gYmVmYWxsZW5lIEUt
TWFpbHMgZW50c3RlaGVuLCBzY2hsaWXDn2VuIHdpciBqZWRlIEhhZnR1bmcgYXVzLg0K
