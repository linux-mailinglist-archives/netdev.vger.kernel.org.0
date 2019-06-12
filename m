Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C8942B60
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbfFLP46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:56:58 -0400
Received: from mail-eopbgr30052.outbound.protection.outlook.com ([40.107.3.52]:27022
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726725AbfFLP4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 11:56:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zO9K0bIT1qILIKRTAwoVmOwIp9578Tg4ebYPUq28a/s=;
 b=UHqSqm49TM7+mZJvdLxldO2jEYLOjw9YpPRPCMYUQmHbWES+LbPMC/OFKvntqbSeSi2uoXLgZ8PE/lnS0+iUHvpMd2c9GCW8zRfklJGJyuwmPm1uxsOeZjKEM3czAERQ9PJgB0VTgA602tCltZhDEi3gBF2nVRZLgxD9aks7+IE=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5240.eurprd05.prod.outlook.com (20.177.196.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Wed, 12 Jun 2019 15:56:41 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 15:56:41 +0000
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
Subject: [PATCH bpf-next v4 04/17] libbpf: Support getsockopt XDP_OPTIONS
Thread-Topic: [PATCH bpf-next v4 04/17] libbpf: Support getsockopt XDP_OPTIONS
Thread-Index: AQHVITdt7LXPNGfTskGofiqdw+tH+w==
Date:   Wed, 12 Jun 2019 15:56:41 +0000
Message-ID: <20190612155605.22450-5-maximmi@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 739d7682-1e67-48d1-73ad-08d6ef4e8f61
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5240;
x-ms-traffictypediagnostic: AM6PR05MB5240:
x-microsoft-antispam-prvs: <AM6PR05MB52408C233FFBBA56F5269516D1EC0@AM6PR05MB5240.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(39860400002)(396003)(346002)(189003)(199004)(486006)(8936002)(6486002)(446003)(8676002)(81166006)(81156014)(2906002)(6436002)(36756003)(26005)(11346002)(2616005)(476003)(50226002)(66066001)(102836004)(14454004)(186003)(107886003)(110136005)(54906003)(71190400001)(71200400001)(478600001)(316002)(25786009)(4326008)(1076003)(7736002)(305945005)(6512007)(66476007)(66946007)(66556008)(64756008)(66446008)(73956011)(68736007)(256004)(99286004)(7416002)(6116002)(386003)(3846002)(6506007)(86362001)(53936002)(76176011)(5660300002)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5240;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JB3XvCD1SHfiWAYrri+SRmo65AKf8cmXxHeEQpveEacLSVdXvP/fifXFgV1TcvgvY6dDb4UoYAuDyQMbuc5o8j6c537N91gOVSbwoN96tmBAsSUMFUJaERIJv7tFkiFJBUgb7CawEQWqCGWAtyP6erDTdnrtVaEDxdXlEzHh9YWki22pJbgxgS5/1dNnc1JEL3kBR51t/fvMWW2XmQAkn4JprgByPvmqjwBYEp6HSdCXEH6KQnSVAcBtNemBdIZf0vlKggaTd1BK0r8cmaDRHIU3/2K1MS9S0+LW0mO+1Z4Byr1NmARj1okt9J7JkJ4PH+ZdSuKQBzY7xSUXvwqvV8nAL63xXUaoFwfZunP9SLoP9E5Jpz4sPnQBfK72pkCoQxB6Ly8sqAw3K8uPvEAJGPXcMBN4/uwujIrRT6M5xBE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 739d7682-1e67-48d1-73ad-08d6ef4e8f61
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 15:56:41.5247
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

UXVlcnkgWERQX09QVElPTlMgaW4gbGliYnBmIHRvIGRldGVybWluZSBpZiB0aGUgemVyby1jb3B5
IG1vZGUgaXMgYWN0aXZlDQpvciBub3QuDQoNClNpZ25lZC1vZmYtYnk6IE1heGltIE1pa2l0eWFu
c2tpeSA8bWF4aW1taUBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogVGFyaXEgVG91a2FuIDx0
YXJpcXRAbWVsbGFub3guY29tPg0KQWNrZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVs
bGFub3guY29tPg0KLS0tDQogdG9vbHMvbGliL2JwZi94c2suYyB8IDEyICsrKysrKysrKysrKw0K
IDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS90b29scy9s
aWIvYnBmL3hzay5jIGIvdG9vbHMvbGliL2JwZi94c2suYw0KaW5kZXggN2VmNjI5M2I0ZmQ3Li5i
ZjE1YTgwYTM3YzIgMTAwNjQ0DQotLS0gYS90b29scy9saWIvYnBmL3hzay5jDQorKysgYi90b29s
cy9saWIvYnBmL3hzay5jDQpAQCAtNjUsNiArNjUsNyBAQCBzdHJ1Y3QgeHNrX3NvY2tldCB7DQog
CWludCB4c2tzX21hcF9mZDsNCiAJX191MzIgcXVldWVfaWQ7DQogCWNoYXIgaWZuYW1lW0lGTkFN
U0laXTsNCisJYm9vbCB6YzsNCiB9Ow0KIA0KIHN0cnVjdCB4c2tfbmxfaW5mbyB7DQpAQCAtNDgw
LDYgKzQ4MSw3IEBAIGludCB4c2tfc29ja2V0X19jcmVhdGUoc3RydWN0IHhza19zb2NrZXQgKip4
c2tfcHRyLCBjb25zdCBjaGFyICppZm5hbWUsDQogCXZvaWQgKnJ4X21hcCA9IE5VTEwsICp0eF9t
YXAgPSBOVUxMOw0KIAlzdHJ1Y3Qgc29ja2FkZHJfeGRwIHN4ZHAgPSB7fTsNCiAJc3RydWN0IHhk
cF9tbWFwX29mZnNldHMgb2ZmOw0KKwlzdHJ1Y3QgeGRwX29wdGlvbnMgb3B0czsNCiAJc3RydWN0
IHhza19zb2NrZXQgKnhzazsNCiAJc29ja2xlbl90IG9wdGxlbjsNCiAJaW50IGVycjsNCkBAIC01
OTcsNiArNTk5LDE2IEBAIGludCB4c2tfc29ja2V0X19jcmVhdGUoc3RydWN0IHhza19zb2NrZXQg
Kip4c2tfcHRyLCBjb25zdCBjaGFyICppZm5hbWUsDQogCX0NCiANCiAJeHNrLT5wcm9nX2ZkID0g
LTE7DQorDQorCW9wdGxlbiA9IHNpemVvZihvcHRzKTsNCisJZXJyID0gZ2V0c29ja29wdCh4c2st
PmZkLCBTT0xfWERQLCBYRFBfT1BUSU9OUywgJm9wdHMsICZvcHRsZW4pOw0KKwlpZiAoZXJyKSB7
DQorCQllcnIgPSAtZXJybm87DQorCQlnb3RvIG91dF9tbWFwX3R4Ow0KKwl9DQorDQorCXhzay0+
emMgPSBvcHRzLmZsYWdzICYgWERQX09QVElPTlNfWkVST0NPUFk7DQorDQogCWlmICghKHhzay0+
Y29uZmlnLmxpYmJwZl9mbGFncyAmIFhTS19MSUJCUEZfRkxBR1NfX0lOSElCSVRfUFJPR19MT0FE
KSkgew0KIAkJZXJyID0geHNrX3NldHVwX3hkcF9wcm9nKHhzayk7DQogCQlpZiAoZXJyKQ0KLS0g
DQoyLjE5LjENCg0K
