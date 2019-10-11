Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7B2D41A2
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 15:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbfJKNpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 09:45:24 -0400
Received: from mail-eopbgr790044.outbound.protection.outlook.com ([40.107.79.44]:52488
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728198AbfJKNpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 09:45:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fn22fyl1nTn6MPuWzLVVeR28gFZA/UxiXBHaOZ/GmOQ/tI/So1k/QuxQyOIVyKQTcd9SMqjZxI+dMS1yPnLTtzsZNA0ZzoP3L74+1/5UPdpcfkaERxxHpLFLrR+POPTL1fA039CPGLkCjJ94Sv/vcMvPlRRoHkTHun7JB+hQ8T7M0MMuXJMF7O7R44er3wVEbRDdTVQT+umMOWidD+DliYgxH8umUds5pd17t9/CjlLrMVrvXb+mYvEzn6Q19j7yVjRg+uQXf9uLmjXqJlQBYyKMulhfMOYRPtG3PkEuroYZ4MDti6L/hQEGSqQ6lSy+0jLl2UGS7EuQ4EYTmaSM3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quEnKCgv+5WxWABHnlO8gvr9Z/fUFKUP2UvYZ9VYSkQ=;
 b=E11ofs9kzJTI1ANDDbgtuO8KyOrgZqW3zvz44K/WzemLAkI2a3Hl+eDMe4+sU7JydCKxi6uRiueYWCuUR5xjLu27NgC2xzem9zAs0uH1+f1DzzV15Xau8abAuI96It6cNiRJA0ngf14jHvKjakG5Vh9lwZ79Jjo03cjhswWr9F8hVPWBI7XOmQUqzTNzLZBlyo97gyFQMyyrRCxcp3UlZWtfvKFCXgzuSG8Ip6k3DaLTOTNzvQM1BMcc0PWLOdjl/KHkTkj1W4gt+fHUdztDg3NmA6RuQhkc7xlDrp+rhKZDDbGI36bpUxCH02xTCxv08YnPpMfE3kbqxWuWcEU6Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quEnKCgv+5WxWABHnlO8gvr9Z/fUFKUP2UvYZ9VYSkQ=;
 b=Japam30eFTSijFk6zJxg3hULFKxiFr250Nay05yNsZIsQo2hihW/C1B3rHOVsjzI5gCQ6+MZYe134Em/N4pC5UJlI1jdNXgA+PDMZ7A5VT0t90BDes1Wp6MCS1l6d7xvO2K2Nrai6LlRr1JHDXRGgc4NsrBdUkwtf9Bp/h7/3nA=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3538.namprd11.prod.outlook.com (20.178.218.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.19; Fri, 11 Oct 2019 13:45:21 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.021; Fri, 11 Oct 2019
 13:45:21 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH v2 net 1/4] net: aquantia: temperature retrieval fix
Thread-Topic: [PATCH v2 net 1/4] net: aquantia: temperature retrieval fix
Thread-Index: AQHVgDofR4aKBO0BUUGbWNouygMtew==
Date:   Fri, 11 Oct 2019 13:45:19 +0000
Message-ID: <93528d520c8ff23053ff39c07bb54ecb779df717.1570787323.git.igor.russkikh@aquantia.com>
References: <cover.1570787323.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1570787323.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0005.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::17)
 To BN8PR11MB3762.namprd11.prod.outlook.com (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bde4972f-f023-43f1-bc13-08d74e514160
x-ms-traffictypediagnostic: BN8PR11MB3538:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB353873F0F0B7A877B65A07C098970@BN8PR11MB3538.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(376002)(136003)(346002)(366004)(189003)(199004)(52116002)(5640700003)(76176011)(99286004)(2501003)(14454004)(6486002)(25786009)(186003)(26005)(6506007)(476003)(5660300002)(11346002)(50226002)(102836004)(386003)(508600001)(486006)(44832011)(316002)(6916009)(305945005)(7736002)(54906003)(446003)(14444005)(5024004)(66066001)(6116002)(2351001)(8676002)(36756003)(1730700003)(3846002)(71190400001)(71200400001)(118296001)(8936002)(66574012)(2906002)(256004)(86362001)(4326008)(2616005)(6436002)(64756008)(66946007)(66476007)(66556008)(107886003)(81166006)(81156014)(66446008)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3538;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HmvJP3EmuBLfz2xoJuV+cGh0fRMaF1B2QDpQpqazZd5UiBNoW54ZIx36i/qAtkKxAQjN7vfRa9DllK4kwAnPAco3R50bRFde94lJmH3STTIZvzuLnWec7xuqOaufMU4HKD+6mpBdQ5h9cZMOnyM3BBZ0FgaxpkzvuzRLzw9gK5RrUGIyM+WMj/2eZihvHsgPsxxZ8u84Hsb3zCvArlSoO9+nGf1k0LHuFlDVqhndla2gOxU3p5MnDCBwawzzkkDn3EuT9gWaDA5VhPmYkIlyq0NQfRnNgiZS5qI/VjazSYgvN7h2iCDRA5xaci5tZccWCth9wQxljOCismlXyfy6YkUn6GtWBfNhn3+45dHEVBcJhOQcqxEY0skHgRTMoCbgByu/P52ojaelkhCVDNi005pj3XXXIFwwm16EWDhKWk4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52610D68526FD74DB5EA3FD48F844053@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bde4972f-f023-43f1-bc13-08d74e514160
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 13:45:19.5358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1/IyulWfd0OjNGJ3kuhlCfaaj+jIV1735oUtPMK8KIdrsDz5SZqDgTvLsia/2zp5/K0t5DIg5+TFRVDs9N7UPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3538
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q2hpcCB0ZW1wZXJhdHVyZSBpcyBhIHR3byBieXRlIHdvcmQsIGNvbG9jYXRlZCBpbnRlcm5hbGx5
IHdpdGggY2FibGUNCmxlbmd0aCBkYXRhLiBXZSBkbyBhbGwgcmVhZG91dHMgZnJvbSBIVyBtZW1v
cnkgYnkgZHdvcmRzLCB0aHVzDQp3ZSBzaG91bGQgY2xlYXIgZXh0cmEgaGlnaCBieXRlcywgb3Ro
ZXJ3aXNlIHRlbXBlcmF0dXJlIG91dHB1dA0KZ2V0cyB3ZWlyZCBhcyBzb29uIGFzIHdlIGF0dGFj
aCBhIGNhYmxlIHRvIHRoZSBOSUMuDQoNCkZpeGVzOiA4Zjg5NDAxMTg2NTQgKCJuZXQ6IGFxdWFu
dGlhOiBhZGQgaW5mcmFzdHJ1Y3R1cmUgdG8gcmVhZG91dCBjaGlwIHRlbXBlcmF0dXJlIikNClRl
c3RlZC1ieTogSG9sZ2VyIEhvZmZzdMOkdHRlIDxob2xnZXJAYXBwbGllZC1hc3luY2hyb255LmNv
bT4NClNpZ25lZC1vZmYtYnk6IElnb3IgUnVzc2tpa2ggPGlnb3IucnVzc2tpa2hAYXF1YW50aWEu
Y29tPg0KLS0tDQogLi4uL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9od19hdGwvaHdf
YXRsX3V0aWxzX2Z3MnguYyAgIHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1
YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF91dGlsc19mdzJ4LmMgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX3V0aWxzX2Z3MnguYw0KaW5k
ZXggZGE3MjY0ODllM2M4Li43YmM1MWY4ZDZmMmYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX3V0aWxzX2Z3MnguYw0KKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF91
dGlsc19mdzJ4LmMNCkBAIC0zMzcsNyArMzM3LDcgQEAgc3RhdGljIGludCBhcV9mdzJ4X2dldF9w
aHlfdGVtcChzdHJ1Y3QgYXFfaHdfcyAqc2VsZiwgaW50ICp0ZW1wKQ0KIAkvKiBDb252ZXJ0IFBI
WSB0ZW1wZXJhdHVyZSBmcm9tIDEvMjU2IGRlZ3JlZSBDZWxzaXVzDQogCSAqIHRvIDEvMTAwMCBk
ZWdyZWUgQ2Vsc2l1cy4NCiAJICovDQotCSp0ZW1wID0gdGVtcF9yZXMgICogMTAwMCAvIDI1NjsN
CisJKnRlbXAgPSAodGVtcF9yZXMgJiAweEZGRkYpICogMTAwMCAvIDI1NjsNCiANCiAJcmV0dXJu
IDA7DQogfQ0KLS0gDQoyLjE3LjENCg0K
