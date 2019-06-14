Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2BA467AF
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 20:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbfFNSl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 14:41:56 -0400
Received: from mail-eopbgr00089.outbound.protection.outlook.com ([40.107.0.89]:43654
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725973AbfFNSlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 14:41:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSaQ6fx4BtvUbdXelFsdHf8c3tzpaQX9z0BLVwQONHY=;
 b=nkocBi5JqgeTkjlUupOJA9W4Ws5chUkxWKwIECRt0uYxW/Si6HgtaPRL4wV5Wg9r/jX3zBDmmUsmGo3XOLU07LKtAGLaBbEL3US3RnBqxtycYCHiMt0lrugHccdjBLG4Qf2STon5dqy/bBvIRGfqCSfELrMZW949pxPmhpmoILg=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2613.eurprd05.prod.outlook.com (10.172.225.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Fri, 14 Jun 2019 18:41:52 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.012; Fri, 14 Jun 2019
 18:41:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH net-next v3 1/2] net/mlx5e: use indirect calls wrapper for
 skb allocation
Thread-Topic: [PATCH net-next v3 1/2] net/mlx5e: use indirect calls wrapper
 for skb allocation
Thread-Index: AQHVIQg7QJTcV7jOQE+n6Xq+qt4vbKabf5cA
Date:   Fri, 14 Jun 2019 18:41:52 +0000
Message-ID: <f0d1c37b8aa41267114ef5a342feae564681b9c6.camel@mellanox.com>
References: <cover.1560333783.git.pabeni@redhat.com>
         <a3fdbe3ca0f9304921c3f8ee45494043274b50ce.1560333783.git.pabeni@redhat.com>
In-Reply-To: <a3fdbe3ca0f9304921c3f8ee45494043274b50ce.1560333783.git.pabeni@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6fd3bdf-afa9-41c6-8f08-08d6f0f7f7b1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2613;
x-ms-traffictypediagnostic: DB6PR0501MB2613:
x-microsoft-antispam-prvs: <DB6PR0501MB26131F445E34EC6E451ACD95BEEE0@DB6PR0501MB2613.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(366004)(376002)(346002)(199004)(189003)(8676002)(36756003)(6486002)(7736002)(305945005)(6436002)(53936002)(6246003)(11346002)(6512007)(446003)(2616005)(229853002)(476003)(5660300002)(486006)(66066001)(6506007)(2501003)(76176011)(6116002)(3846002)(81166006)(14454004)(8936002)(118296001)(68736007)(99286004)(26005)(186003)(64756008)(54906003)(66476007)(58126008)(316002)(110136005)(66946007)(73956011)(71190400001)(91956017)(71200400001)(256004)(86362001)(4326008)(76116006)(478600001)(66446008)(25786009)(558084003)(2906002)(66556008)(102836004)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2613;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Fr1QlOL/aN6/9CbYWQW/m5hYpEJzaVrcI3/ysjpaH135oI7Bo8NGwJrjYQvWWmGUENZtyoZFyazrTyhvKsIy7SfeLhac8QarRKg1gTy6RfcETB0WI9nkL/U9ZsefnT9hQdBgFvFk85ZiXX/+Q1BAvCsUG+oAd3tF/8JE9NnbTbrlhuq3//FnDvkMX+M/Ez1b/StAHgk2UmweYWsSIGsAOiW9aCZ3uIVCA+TdrYGPjGzY+vfbJxUS5RMEW5wepRYPU0iolF1lL3lhdORVDj4EfG/2ZOakUtSOSTOVya77LbUCSkpCBS0i8XDzVQdk5QjTTCoz5MSAUW9x31g++mSRe1VsYAH20n7nvFueNt1fBgv9aB+dESAYF61jDkDm5noMSt5fJJWUB0+9nJSErIP299SScWSZ2OVbX9Wix0Fsboo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BAF16E22299DED4AA6603059A6156D53@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6fd3bdf-afa9-41c6-8f08-08d6f0f7f7b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 18:41:52.1510
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2613
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA2LTEyIGF0IDEyOjE4ICswMjAwLCBQYW9sbyBBYmVuaSB3cm90ZToNCj4g
V2UgY2FuIGF2b2lkIGFuIGluZGlyZWN0IGNhbGwgcGVyIHBhY2tldCB3cmFwcGluZyB0aGUgc2ti
IGNyZWF0aW9uDQo+IHdpdGggdGhlIGFwcHJvcHJpYXRlIGhlbHBlci4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT4NCg0KQWNrZWQtYnk6IFNhZWVk
IE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KDQo=
