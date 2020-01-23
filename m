Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09159146329
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 09:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgAWIRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 03:17:01 -0500
Received: from mail-eopbgr50122.outbound.protection.outlook.com ([40.107.5.122]:41953
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725785AbgAWIRB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 03:17:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fs4XSwyVzdjmdlXcy5hBPfivALwCTQKz1Tud4pilfalrQe5U5GOJTHf4SAqXVUKT111FAouiejW6HwD1BrqzEY653uVx7Et16lI/Vt1daBQ/+cXsLzVDDNd1rUIw08q6n4rnXYc+pmkFgA4ytInqFtk5WdFAZzHdxaeiFjgNPeAX6nSOQ79wWyYB0BHjrnqmMimsIJV97H/zlhtrVCIyiMOdGDvs029yP9qpiQfZY1go1nRda1+l56MiYmuV/6xLGQ+OGuDkcQ1/0u21EA+WEfK4W555UYBdx0myI8CoJcY2/M30V4INyhBbsWLfggDC5WsZ/FAmd+wx0/xH245dzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/BssOqD4/Tiil8aryhkK0ytKFng8LM89t8ssN5jRM8=;
 b=nawfJHX8b4Yd7vFZj9PgnkXX0YUH87yHUmSEzuzmy80PDbCh/3clOsnqme3H4AZje2oG4/C84fE680bO+RFk1k9SgRjNPm9ck/de87jRTQTXNr255i78euZo4Gfz8QMZS6Wc0HXyHIcHTtPc/pWQo9pcE98vwdOsp1YX0au+oqltlBI1RIzxiDAnOg/jmoY8uN9/OHsLSVdqj0somfvnoLKHLzLeRoqz+sxhzp/cpiV/3A3b2KBZbDhCZdLX+9N2CMEZ5YEwLu35fwj04eIP3Q6qROmsmWo0GaGelqI+tOee2/KMdU5a8g1J2qVg22AU25HXZQKfS5kXImtDGq1Tgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/BssOqD4/Tiil8aryhkK0ytKFng8LM89t8ssN5jRM8=;
 b=OrpCJdvOrdayLM5xu34TJR0oGwcGgTYfjRTQehvEAjIXZHOImUSW1jyIb7XC6nLCllBM4C8iVkrA1t4z7xpGqGtl1bas6HofRdlxWmIA4J7/9mpim4SVtwmuZxrVfJnQmanXpgJXBrAaFGxOxKrprQgd9pzSVFZvUP2WAMtZTm4=
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com (20.178.20.19) by
 AM0PR05MB4641.eurprd05.prod.outlook.com (52.133.52.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.22; Thu, 23 Jan 2020 08:16:55 +0000
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7]) by AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 08:16:55 +0000
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
Subject: [PATCH v2] mvneta driver disallow XDP program on hardware buffer
 management
Thread-Topic: [PATCH v2] mvneta driver disallow XDP program on hardware buffer
 management
Thread-Index: AQHV0cV5u88rHVCCFkyUaev8yrzA/w==
Date:   Thu, 23 Jan 2020 08:16:55 +0000
Message-ID: <D1D78C6F-B2B2-4E55-8350-74DCBDB1EE01@voleatech.de>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sven.auhagen@voleatech.de; 
x-originating-ip: [37.24.174.42]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6551ec5-59c3-494a-7c01-08d79fdc9c3a
x-ms-traffictypediagnostic: AM0PR05MB4641:
x-microsoft-antispam-prvs: <AM0PR05MB46417BA98FE90E6C3EBA0CD4EF0F0@AM0PR05MB4641.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(189003)(199004)(6486002)(54906003)(5660300002)(6512007)(36756003)(6506007)(508600001)(15974865002)(26005)(81156014)(81166006)(6916009)(186003)(8676002)(8936002)(71200400001)(33656002)(44832011)(66574012)(2906002)(64756008)(66476007)(86362001)(4326008)(2616005)(66446008)(66556008)(66946007)(76116006)(309714004);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR05MB4641;H:AM0PR05MB5156.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: voleatech.de does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5HlxcQfiophBTqY9b/V+s/3JWg4nleAi97zZMSHuxXzzLit5f43qBQDGz71HIYBlH3m2m2WfpGYolaOS5sKsOd21BeOXyzAY3xexiqMJs4YKxAXcnz/lUYC/NsjAtgCOKWvKTOcISpFxvB1rhHLGIURpxwpI5HcqzigcB5tk3JoWjZxLRKoMzmAmnT1Uin5G2clvhFDWXka7CSkhpoQ4/JIrtCU3tlgeEBDk7I3Ve1VI7ykqD3xK0WaPpX1fNKudrdvWrdKyTUvWJpqrRPLFEwtcbwjnNj8VG84a/H9MPC5/Jh14fLqAkhIi+EijssqrGBtlHwGP6mKnBy2gC5dxBOFGGzn7ebg0DEdX+CI7ot+ZPdU7PftrGZ5c1P3ECVAcUdRjkWubd5RO+erwxzlqFnkQnV6CCLF9P2CMsfHQMqEX8eOUbcoyUKYiObUQTyx2lopIkV+i9eCuzDpjUKY1lwqk2HSTGfDKMhUKc3I6AL7QNcCfkegLTKb13CkKkjX+
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0ACF6F5A21A63F408B4673EE949B1F01@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: e6551ec5-59c3-494a-7c01-08d79fdc9c3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 08:16:55.7485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6w1A0HL4e8R4nMrDrsh7wSO45l0KeKsVH4wGGp6HYa9M6K3OJr2vvPuQLdtk6qOB5hrjsB+gR/v4/OVbHLvJTHbt978odEX/u3cmp0THb90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4641
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmVjZW50bHkgWERQIFN1cHBvcnQgd2FzIGFkZGVkIHRvIHRoZSBtdm5ldGEgZHJpdmVyDQpmb3Ig
c29mdHdhcmUgYnVmZmVyIG1hbmFnZW1lbnQgb25seS4NCkl0IGlzIHN0aWxsIHBvc3NpYmxlIHRv
IGF0dGFjaCBhbiBYRFAgcHJvZ3JhbSBpZg0KaGFyZHdhcmUgYnVmZmVyIG1hbmFnZW1lbnQgaXMg
dXNlZC4NCkl0IGlzIG5vdCBkb2luZyBhbnl0aGluZyBhdCB0aGF0IHBvaW50Lg0KDQpUaGUgcGF0
Y2ggZGlzYWxsb3dzIGF0dGFjaGluZyBYRFAgcHJvZ3JhbXMgdG8gbXZuZXRhDQppZiBoYXJkd2Fy
ZSBidWZmZXIgbWFuYWdlbWVudCBpcyB1c2VkLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdmVuIEF1aGFn
ZW4gPHN2ZW4uYXVoYWdlbkB2b2xlYXRlY2guZGU+DQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tYXJ2ZWxsL212bmV0YS5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVs
bC9tdm5ldGEuYw0KaW5kZXggNzFhODcyZDQ2YmM0Li45NjU5M2I5ZmJkOWIgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL212bmV0YS5jDQorKysgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tYXJ2ZWxsL212bmV0YS5jDQpAQCAtNDIyNSw2ICs0MjI1LDEyIEBAIHN0YXRp
YyBpbnQgbXZuZXRhX3hkcF9zZXR1cChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBzdHJ1Y3QgYnBm
X3Byb2cgKnByb2csDQogcmV0dXJuIC1FT1BOT1RTVVBQOw0KIH0NCg0KK2lmIChwcC0+Ym1fcHJp
dikgew0KK05MX1NFVF9FUlJfTVNHX01PRChleHRhY2ssDQorICAgIkhhcmR3YXJlIEJ1ZmZlciBN
YW5hZ2VtZW50IG5vdCBzdXBwb3J0ZWQgb24gWERQIik7DQorcmV0dXJuIC1FT1BOT1RTVVBQOw0K
K30NCisNCiBuZWVkX3VwZGF0ZSA9ICEhcHAtPnhkcF9wcm9nICE9ICEhcHJvZzsNCiBpZiAocnVu
bmluZyAmJiBuZWVkX3VwZGF0ZSkNCiBtdm5ldGFfc3RvcChkZXYpOw0KDQoNCisrKyBWb2xlYXRl
Y2ggYXVmIGRlciBFLVdvcmxkLCAxMS4gYmlzIDEzLiBGZWJydWFyIDIwMjAsIEhhbGxlIDUsIFN0
YW5kIDUyMSArKysNCg0KQmVzdGUgR3LDvMOfZS9CZXN0IHJlZ2FyZHMNCg0KU3ZlbiBBdWhhZ2Vu
DQpEaXBsLiBNYXRoLiBvZWMuLCBNLlNjLg0KVm9sZWF0ZWNoIEdtYkgNCkhSQjogQiA3NTQ2NDMN
ClVTVElEOiBERTMwMzY0MzE4MA0KR3JhdGh3b2hsc3RyLiA1DQo3Mjc2MiBSZXV0bGluZ2VuDQpU
ZWw6ICs0OSA3MTIxNTM5NTUwDQpGYXg6ICs0OSA3MTIxNTM5NTUxDQpFLU1haWw6IHN2ZW4uYXVo
YWdlbkB2b2xlYXRlY2guZGUNCnd3dy52b2xlYXRlY2guZGU8aHR0cHM6Ly93d3cudm9sZWF0ZWNo
LmRlPg0KRGllc2UgSW5mb3JtYXRpb24gaXN0IGF1c3NjaGxpZcOfbGljaCBmw7xyIGRlbiBBZHJl
c3NhdGVuIGJlc3RpbW10IHVuZCBrYW5uIHZlcnRyYXVsaWNoIG9kZXIgZ2VzZXR6bGljaCBnZXNj
aMO8dHp0ZSBJbmZvcm1hdGlvbmVuIGVudGhhbHRlbi4gV2VubiBTaWUgbmljaHQgZGVyIGJlc3Rp
bW11bmdzZ2Vtw6TDn2UgQWRyZXNzYXQgc2luZCwgdW50ZXJyaWNodGVuIFNpZSBiaXR0ZSBkZW4g
QWJzZW5kZXIgdW5kIHZlcm5pY2h0ZW4gU2llIGRpZXNlIE1haWwuIEFuZGVyZW4gYWxzIGRlbSBi
ZXN0aW1tdW5nc2dlbcOkw59lbiBBZHJlc3NhdGVuIGlzdCBlcyB1bnRlcnNhZ3QsIGRpZXNlIEUt
TWFpbCB6dSBsZXNlbiwgenUgc3BlaWNoZXJuLCB3ZWl0ZXJ6dWxlaXRlbiBvZGVyIGlocmVuIElu
aGFsdCBhdWYgd2VsY2hlIFdlaXNlIGF1Y2ggaW1tZXIgenUgdmVyd2VuZGVuLiBGw7xyIGRlbiBB
ZHJlc3NhdGVuIHNpbmQgZGllIEluZm9ybWF0aW9uZW4gaW4gZGllc2VyIE1haWwgbnVyIHp1bSBw
ZXJzw7ZubGljaGVuIEdlYnJhdWNoLiBFaW5lIFdlaXRlcmxlaXR1bmcgZGFyZiBudXIgbmFjaCBS
w7xja3NwcmFjaGUgbWl0IGRlbSBBYnNlbmRlciBlcmZvbGdlbi4gV2lyIHZlcndlbmRlbiBha3R1
ZWxsZSBWaXJlbnNjaHV0enByb2dyYW1tZS4gRsO8ciBTY2jDpGRlbiwgZGllIGRlbSBFbXBmw6Ru
Z2VyIGdsZWljaHdvaGwgZHVyY2ggdm9uIHVucyB6dWdlc2FuZHRlIG1pdCBWaXJlbiBiZWZhbGxl
bmUgRS1NYWlscyBlbnRzdGVoZW4sIHNjaGxpZcOfZW4gd2lyIGplZGUgSGFmdHVuZyBhdXMuDQo=
