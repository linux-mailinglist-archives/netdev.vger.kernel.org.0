Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 496A642B65
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731963AbfFLP5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:57:02 -0400
Received: from mail-eopbgr30052.outbound.protection.outlook.com ([40.107.3.52]:27022
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730589AbfFLP5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 11:57:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+rKNiHKexzXpgrpe1F6lWx9PuiHNtr3us6cvgkwbRU=;
 b=rGVdX91Y3HYngwIMFaVVpubvPSKF36WBpzmZIe4Ac3Lrl+q50AxO3nsr9qVMUa/6Zv49RdkVBcMhSj2xLcSfLocH7qPwJdjqN7ILMCR5CJJm2j1+aWPOCxgHINGVIAIcTyOA09oLULc/9QnSbhm88s8vO+E7BFigbmvz7R3UQLc=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5240.eurprd05.prod.outlook.com (20.177.196.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Wed, 12 Jun 2019 15:56:48 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 15:56:48 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf-next v4 07/17] libbpf: Support drivers with non-combined
 channels
Thread-Topic: [PATCH bpf-next v4 07/17] libbpf: Support drivers with
 non-combined channels
Thread-Index: AQHVITdxVC+hU8LhkUKnNDgy7zjLlQ==
Date:   Wed, 12 Jun 2019 15:56:48 +0000
Message-ID: <20190612155605.22450-8-maximmi@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
In-Reply-To: <20190612155605.22450-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P123CA0019.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::31) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba963b33-0bf0-4ccd-35f3-08d6ef4e934d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5240;
x-ms-traffictypediagnostic: AM6PR05MB5240:
x-microsoft-antispam-prvs: <AM6PR05MB5240CFCD00AE07DE65A36733D1EC0@AM6PR05MB5240.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(39860400002)(396003)(346002)(189003)(199004)(486006)(8936002)(6486002)(446003)(8676002)(81166006)(81156014)(2906002)(6436002)(36756003)(26005)(11346002)(2616005)(476003)(50226002)(66066001)(102836004)(14454004)(186003)(107886003)(110136005)(54906003)(71190400001)(71200400001)(478600001)(316002)(25786009)(4326008)(1076003)(7736002)(305945005)(6512007)(66476007)(66946007)(66556008)(64756008)(66446008)(73956011)(68736007)(256004)(99286004)(7416002)(6116002)(386003)(14444005)(3846002)(6506007)(86362001)(53936002)(76176011)(5660300002)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5240;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ULATCRfNYow6Kf9qHfrJ+gi/kdLJWlIW1iuxSGPExnJCG3yit8mRVq4fnzoZoyAunPn7uTWzdCR1lrrlVSrTpa2rL01TBEMfWUA5As+BiJklkGEwpnS6ui3r5oNsHL/uhzTmKmZd/TL3H5qeLLg1bptkrIx8AvUj+x/dbnWyAQhFELzvxhg56Uy811LvT8L/5lWKNA0eXx96/BKPc4aOlQb9h5NOmBxP+bNtNJj9sJfh8vNIpWaPS8DEhi0xnANcSw837FgYtBB9ha97G/52eLu6HAiPYVn+VM7UClvTYJ1PSGTWoq/XHMiUgh/v89nfA2QlRQCT1+ceOF55WAMUQOBUd6ZbmUYx88Qbm9zSLjUEGpQwrWYxh+0VyqOuch2mcyUBoJ/pRcSdkDky1zoWSg3qX5dPRgSy4RV45qN8cug=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba963b33-0bf0-4ccd-35f3-08d6ef4e934d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 15:56:48.0800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5240
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q3VycmVudGx5LCBsaWJicGYgdXNlcyB0aGUgbnVtYmVyIG9mIGNvbWJpbmVkIGNoYW5uZWxzIGFz
IHRoZSBtYXhpbXVtDQpxdWV1ZSBudW1iZXIuIEhvd2V2ZXIsIHRoZSBrZXJuZWwgaGFzIGEgZGlm
ZmVyZW50IGxpbWl0YXRpb246DQoNCi0geGRwX3JlZ191bWVtX2F0X3FpZCgpIGFsbG93cyB1cCB0
byBtYXgoUlggcXVldWVzLCBUWCBxdWV1ZXMpLg0KDQotIGV0aHRvb2xfc2V0X2NoYW5uZWxzKCkg
Y2hlY2tzIGZvciBVTUVNcyBpbiBxdWV1ZXMgdXAgdG8NCiAgY29tYmluZWRfY291bnQgKyBtYXgo
cnhfY291bnQsIHR4X2NvdW50KS4NCg0KbGliYnBmIHNob3VsZG4ndCBsaW1pdCBhcHBsaWNhdGlv
bnMgdG8gYSBsb3dlciBtYXggcXVldWUgbnVtYmVyLiBBY2NvdW50DQpmb3Igbm9uLWNvbWJpbmVk
IFJYIGFuZCBUWCBjaGFubmVscyB3aGVuIGNhbGN1bGF0aW5nIHRoZSBtYXggcXVldWUNCm51bWJl
ci4gVXNlIHRoZSBzYW1lIGZvcm11bGEgdGhhdCBpcyB1c2VkIGluIGV0aHRvb2wuDQoNClNpZ25l
ZC1vZmYtYnk6IE1heGltIE1pa2l0eWFuc2tpeSA8bWF4aW1taUBtZWxsYW5veC5jb20+DQpSZXZp
ZXdlZC1ieTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KQWNrZWQtYnk6IFNh
ZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogdG9vbHMvbGliL2JwZi94
c2suYyB8IDYgKysrLS0tDQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxl
dGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYveHNrLmMgYi90b29scy9saWIv
YnBmL3hzay5jDQppbmRleCBiZjE1YTgwYTM3YzIuLjg2MTA3ODU3ZTFmMCAxMDA2NDQNCi0tLSBh
L3Rvb2xzL2xpYi9icGYveHNrLmMNCisrKyBiL3Rvb2xzL2xpYi9icGYveHNrLmMNCkBAIC0zMzQs
MTMgKzMzNCwxMyBAQCBzdGF0aWMgaW50IHhza19nZXRfbWF4X3F1ZXVlcyhzdHJ1Y3QgeHNrX3Nv
Y2tldCAqeHNrKQ0KIAkJZ290byBvdXQ7DQogCX0NCiANCi0JaWYgKGNoYW5uZWxzLm1heF9jb21i
aW5lZCA9PSAwIHx8IGVycm5vID09IEVPUE5PVFNVUFApDQorCXJldCA9IGNoYW5uZWxzLm1heF9j
b21iaW5lZCArIG1heChjaGFubmVscy5tYXhfcngsIGNoYW5uZWxzLm1heF90eCk7DQorDQorCWlm
IChyZXQgPT0gMCB8fCBlcnJubyA9PSBFT1BOT1RTVVBQKQ0KIAkJLyogSWYgdGhlIGRldmljZSBz
YXlzIGl0IGhhcyBubyBjaGFubmVscywgdGhlbiBhbGwgdHJhZmZpYw0KIAkJICogaXMgc2VudCB0
byBhIHNpbmdsZSBzdHJlYW0sIHNvIG1heCBxdWV1ZXMgPSAxLg0KIAkJICovDQogCQlyZXQgPSAx
Ow0KLQllbHNlDQotCQlyZXQgPSBjaGFubmVscy5tYXhfY29tYmluZWQ7DQogDQogb3V0Og0KIAlj
bG9zZShmZCk7DQotLSANCjIuMTkuMQ0KDQo=
