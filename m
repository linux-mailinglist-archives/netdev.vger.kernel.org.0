Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E43AF9CD16
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 12:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730379AbfHZKLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 06:11:55 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:20587
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730287AbfHZKLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 06:11:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NM+Nt+yfJvOiJtIQGLZZcXreI7lq9cRpMtfI+MgW+dHi9CzZShLFV/XoIeU6fdUJzqq7xsF/7MojDpbcMdGskzpuWpEoi5k7YVTQ74sUJ7KLC961HE0qKYOln1+aE0tAzz6WS5TxXwkJJ10135ufTcnbBsnLeuOvlniDZ0agdyL6lQ+o0eDm9ZvhMbzgpV6UG/uHCW+HAU/iK13zYjZY1FeQtX4icZfF7aB5YeNyg2Y+gFGmI9PR5/7ceSckGftqNERnTYblf0s+yyDfCRHXRxdc7s7pfNTwHAaIy2gIWzSYy5TtRK1E4KSHVhztQiw+MDmkRw/W2O80fqKromd9Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37OlrQGCcox5MNH74lAqKBQrYfsmpKy1047uWJIMmys=;
 b=NqfPyfSzLR6yjcEUkfWcFKpznF8Qrs62ji1+6q710fSh8zQQct09Q4RWUSbGP6mgVRsVylqIhP44YK2dHfp6fS9310kUxkYJqKoYd4Mf4gWr2RvM4uZwb9BQmbxWHBYn6McmLP83PiL/0x39FsZVy22uHLJFueSSvGy4wkLDdwa1tbwHu+3O3labr3PZ4lcg/xMBCcz8RpPx8GGN6Nv6kwzfk14W7pGHuCP1skpHf2EC4MaF1Hry+Air38BIfugDoy3HpXBxsCANeKEIZSgsGhCzvnXgjwCQLh3dDnbQDamHkI71KmwNztrxSpv/WNFmVu+Wxse67gy41BO19ympUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37OlrQGCcox5MNH74lAqKBQrYfsmpKy1047uWJIMmys=;
 b=mrX0mjx4Bj7CzKtZuqRUMEFC5w+9O87uYtXQAm/9oQm/SKpdM6R4XPNO/8dM/ofuQj4dKjxwaDlKs3x4k6OaXtcpL3SqSazvVhQh9DZs2IbncazXDYI+bmBEitF+ZVgurUu1+tsyGsM/Ci2LpCKK9hYYu6RqUppSZCnOOBAbm3M=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB6335.eurprd05.prod.outlook.com (20.179.25.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Mon, 26 Aug 2019 10:11:49 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae%7]) with mapi id 15.20.2178.020; Mon, 26 Aug 2019
 10:11:49 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        Matthew Wilcox <willy@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 29/38] cls_flower: Convert handle_idr to XArray
Thread-Topic: [PATCH 29/38] cls_flower: Convert handle_idr to XArray
Thread-Index: AQHVV6dBDphG1i4E/Em8IqEgKFP29acF7LiAgAZKxgCAAQaIAA==
Date:   Mon, 26 Aug 2019 10:11:49 +0000
Message-ID: <vbfk1b08cd9.fsf@mellanox.com>
References: <20190820223259.22348-1-willy@infradead.org>
 <20190820223259.22348-30-willy@infradead.org> <vbftvaa4bny.fsf@mellanox.com>
 <CAM_iQpXXKwKUhzU1wwXrXqwXSEq-OJ4diBhSuR04kitLKs=g0g@mail.gmail.com>
In-Reply-To: <CAM_iQpXXKwKUhzU1wwXrXqwXSEq-OJ4diBhSuR04kitLKs=g0g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0207.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::27) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49aec44a-aabd-4480-6c4b-08d72a0dcef0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6335;
x-ms-traffictypediagnostic: VI1PR05MB6335:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB63355944FD72A2F130CBD2A7ADA10@VI1PR05MB6335.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(189003)(199004)(478600001)(25786009)(66066001)(66476007)(81166006)(81156014)(7736002)(305945005)(486006)(476003)(2616005)(36756003)(8676002)(66946007)(66556008)(66446008)(64756008)(6246003)(316002)(14454004)(54906003)(6506007)(6116002)(256004)(8936002)(14444005)(6486002)(99286004)(53546011)(2906002)(6512007)(4326008)(86362001)(53936002)(386003)(76176011)(71200400001)(71190400001)(102836004)(186003)(446003)(11346002)(26005)(4744005)(6916009)(3846002)(5660300002)(52116002)(6436002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6335;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eKyIlk0j4Q+NAEUAR1X/0M1ojRjthGqdXh+JUcYybOBeMZpLcgzYzd1GdkOFkqwBKV9soJCXlqttPCHpMf1nRyiEZmkBiMvnjTVi3bBMLmf/gFVquPQcxRerA0qeSt9Qplq4rSCVGEdZux+d7850HbNSIcGAW92mq8TNbF/AWw9zlgOwzTnldNhwlE8Mx2DLqhGXWK7I1KuIiOyuWPtJSQ5FJ+nHv87u+HCvIrG7X35DkEfNmsfdxslz9vQplZX6TstIfaiLKgVENhHeFZpljBUqhNAmJs6N16sl/wNOOZv5qPVxNs8iRBBFNzvrJu240pxQM6LB38jGHf8NFN2QfISNBaayLC75drVH6+GpLAZuX2l4ZmFM8zGoHFYuVirZoNpiS5rD3+Vf/DvB9mSq86Q0NI+PdXkWAEPRRWCQlvI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49aec44a-aabd-4480-6c4b-08d72a0dcef0
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 10:11:49.3307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nsxQD1XLenT86DwzqQlcaMDQiKH/KYRxTM932rbCO7jZJ+VQdIw6LGJISAchNpvx6nfJCRiBGRmU8s2TFpJx5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6335
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sun 25 Aug 2019 at 21:32, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Aug 21, 2019 at 11:27 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>> At first I was confused why you bring up rtnl lock in commit message
>> (flower classifier has 'unlocked' flag set and can't rely on it anymore)
>> but looking at the code I see that we lost rcu read lock here in commit
>> d39d714969cd ("idr: introduce idr_for_each_entry_continue_ul()") and you
>> are correctly bringing it back. Adding Cong to advise if it is okay to
>> wait for this patch to be accepted or we need to proceed with fixing the
>> missing RCU lock as a standalone patch.
>
> Hmm? Isn't ->walk() still called with RTNL lock? tcf_chain_dump()
> calls __tcf_get_next_proto() which asserts RTNL.
>
> So why does it still need RCU read lock when having RTNL?

Individual filters can be deleted without obtaining rtnl lock. And
without rcu read lock, f can be deallocated in fl_walk() main loop
before refcount_inc_not_zero() obtains reference to it.
