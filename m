Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0033512678C
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 18:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfLSRBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 12:01:05 -0500
Received: from mail-eopbgr30040.outbound.protection.outlook.com ([40.107.3.40]:10365
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726760AbfLSRBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 12:01:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqShQusx+Ue4Y0akaT5fqM70qdvhFk42GjGLger3XzdB/u9RVv2o2obHSNQyJh3w88tiuPE/scxkHsJ/Hlq23PeMKA7O8fpjzxieyUEtLBGD6sbAEdPmtBD/l7FxWCVrtfmBtDVnVykBBEuMaCtLG15nVhqehreWuV/9lGFARB9Jln0qiF4Op3CfE96ypXbhjplMrN84kgx+f4t8jwx+ANE32t+e5HZSAmIZhr8dJgdqJmgjCW+g5G1RaPs5Od3Dgm/2LKdr5cdjVu5qFGCjcboeOPWqIcGDCov/3m+nHzMyHB+8B3TXUajcX65ip9DRAZLtQoZoRhKx6niSGoEQwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xzPH8ZFQYBsDdxd8aTRYjk05EuMavjFIyEcLHqHD6dM=;
 b=nGpa2lFa5C0IhnOeaXdL9CrWvlPBRPhNztHLUQk7UHtQIYlTVEnypJcB32VPwBghmvi020+KvPyR+Icr4cpPT6r3xgyfYKQbA5MD9YbXkURXPZdvo5GOImd8eiXKpo6Xe7tcPnG+Em0fP8ul/+l1ACfDLY4HZhn/zZwkNZMurR6g3Ij26WQoNU5jUJDJJSNJvkBuqLuTV5v934xocfLJiYEoXa0S5g7FuwKXo81+39Rv6c0TUSNAencPXMyMLAP/gw/KVzvyvbvzGAcn3fpqJD80PClGEKVlt8P0DZyLTLb0xk79afNVoaOzxOvWFERNb2UZ/2ydvpe5vcV2BLq9XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xzPH8ZFQYBsDdxd8aTRYjk05EuMavjFIyEcLHqHD6dM=;
 b=b4lI8kRaUAAsBxJL7xqnYll5w5t9II37iG9nHFloUSaeA26mtP164j32u/yfGKmya9lEANMrHb40xoAU/MTqdwchEcf7BnKiYpFJKomYWi2VjU2ukuiiKdd55eX5ZOIfvqH13JHaqlwJEmx9MYK8HCv0RlKUqBYwCY0zEWDDCQ0=
Received: from AM0PR05MB5284.eurprd05.prod.outlook.com (20.178.17.20) by
 AM0PR05MB5060.eurprd05.prod.outlook.com (20.176.214.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Thu, 19 Dec 2019 17:01:01 +0000
Received: from AM0PR05MB5284.eurprd05.prod.outlook.com
 ([fe80::d8ce:80d0:a591:8cc]) by AM0PR05MB5284.eurprd05.prod.outlook.com
 ([fe80::d8ce:80d0:a591:8cc%6]) with mapi id 15.20.2559.015; Thu, 19 Dec 2019
 17:01:01 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Vlad Buslov <vladbu@mellanox.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Roman Mashak <mrv@mojatatu.com>
Subject: Re: [PATCH net 1/2] net/sched: cls_u32: fix refcount leak in the
 error path of u32_change()
Thread-Topic: [PATCH net 1/2] net/sched: cls_u32: fix refcount leak in the
 error path of u32_change()
Thread-Index: AQHVtS3RDHKj6jsD1UGiL38qYfL+d6e/8y0AgAGEDQCAAC2QAIAABOKAgAAFA4CAAAK4gA==
Date:   Thu, 19 Dec 2019 17:01:00 +0000
Message-ID: <vbfo8w42qt2.fsf@mellanox.com>
References: <cover.1576623250.git.dcaratti@redhat.com>
 <ae83c6dc89f8642166dc32debc6ea7444eb3671d.1576623250.git.dcaratti@redhat.com>
 <bafb52ff-1ced-91a4-05d0-07d3fdc4f3e4@mojatatu.com>
 <5b4239e5-6533-9f23-7a38-0ee4f6acbfe9@mojatatu.com>
 <vbfr2102swb.fsf@mellanox.com>
 <63fe479d-51cd-eff4-eb13-f0211f694366@mojatatu.com>
 <vbfpngk2r9a.fsf@mellanox.com>
In-Reply-To: <vbfpngk2r9a.fsf@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0123.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::15) To AM0PR05MB5284.eurprd05.prod.outlook.com
 (2603:10a6:208:eb::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 834b16f6-020e-4fce-b053-08d784a50666
x-ms-traffictypediagnostic: AM0PR05MB5060:|AM0PR05MB5060:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5060D4DB51493B0FA2C8600AAD520@AM0PR05MB5060.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(136003)(366004)(346002)(376002)(199004)(189003)(2616005)(2906002)(64756008)(53546011)(66946007)(6512007)(54906003)(86362001)(316002)(6486002)(36756003)(81156014)(478600001)(186003)(71200400001)(6506007)(52116002)(4326008)(37006003)(81166006)(26005)(4001150100001)(5660300002)(8936002)(66556008)(66446008)(8676002)(6200100001)(66476007)(6862004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5060;H:AM0PR05MB5284.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CACzFgANMF3c1N6VfIw1neSWt6qQk/TnTEWCy6cbCEfHbqcdfv7kM7crWq+6G6KHhw4fXzwamVkN5VxZNPQdm2X0fH39+MD9pQSoGp6aV2zosaEGs9wJ1FfBHnqxwd80tMyPfbHtcmfpZyTJtletjDSQZPLCx4FQzIirpiQUOd0SGaok9swmRp8Sbwkd6/o47gpAQPNQdU20j4RIFX0etAMjE878KB9aPXvcHrfmAeCtXl/zoAc6sLuvH3VA6DGeZVrLc2kuwx+3ojXuJ13UasTMeUS8GV1dmnX6EHWA5P+8X8AlM9DD+BPld2gFT8kD9mUciO1DR+PJm1aG5IDBqXHizC5RvAtYFTDmG6fzU72xLPiomHu5I5wMN3w9sN74wnLlaKvE+nNmJc67beJckIfoaMqBlaZAU+q4p8KqxqktuCb8FZJDMjhHd3uE8u3T
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 834b16f6-020e-4fce-b053-08d784a50666
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 17:01:01.5253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2AgxWcg5pjpqx0ywF/xzahzXHjmpBXMWL58bfY8sH589+fKBF1lRgrd/LeJ87IUw8IY38IE5s2mphgE5+xa9tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5060
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 19 Dec 2019 at 18:51, Vlad Buslov <vladbu@mellanox.com> wrote:
> On Thu 19 Dec 2019 at 18:33, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> On 2019-12-19 11:15 a.m., Vlad Buslov wrote:
>>
>>
>>> Hi Jamal,
>>>
>>> Just destroying tp unconditionally will break unlocked case (flower)
>>> because of possibility of concurrent insertion of new filters to the
>>> same tp instance.
>>>
>>
>> I was worried about that. So rtnlheld doesnt help?
>
> Rtnl_held flag can be set for multiple other reasons besides
> locked/unlocked classifier implementation (parent Qdisc doesn't support
> unlocked execution, retry in tc_new_tfilter(), etc.).
>
>>
>>> The root cause here is precisely described by Davide in cover letter -
>>> to accommodate concurrent insertions cls API verifies that tp instance
>>> is empty before deleting it and since there is no cls ops to do it
>>> directly, it relies on checking that walk() stopped without accessing
>>> any filters instead. Unfortunately, somw classifier implementations
>>> assumed that there is always at least one filter on classifier (I fixed
>>> several of these) and now Davide also uncovered this leak in u32.
>>>
>>> As a simpler solution to fix such issues once and for all I can propose
>>> not to perform the walk() check at all and assume that any classifier
>>> implementation that doesn't have TCF_PROTO_OPS_DOIT_UNLOCKED flag set i=
s
>>> empty in tcf_chain_tp_delete_empty() (there is no possibility of
>>> concurrent insertion when synchronizing with rtnl).
>>>
>>> WDYT?
>>
>> IMO that would be a cleaner fix give walk() is used for other
>> operations and this is a core cls issue.
>> Also: documenting what it takes for a classifier to support
>> TCF_PROTO_OPS_DOIT_UNLOCKED is useful (you may have done this
>> in some commit already).
>
> Well, idea was not to have classifier implement any specific API. If
> classifier has TCF_PROTO_OPS_DOIT_UNLOCKED, then cls API doesn't obtain
> rtnl and it is up to classifier to implement whatever locking necessary
> internally. However, my approach to checking for empty classifier
> instance uncovered multiple bugs and inconsistencies in classifier
> implementations of ops->walk().
>
> So I guess the requirement now is for unlocked classifier to have sane
> implementation of ops->walk() that doesn't assume >1 filters and
> correctly handles the case when insertion of first filter after
> classifier instance is created fails.

BTW another approach would be to extend ops with new callback
delete_empty(), require unlocked implementation to define it and move
functionality of tcf_proto_check_delete() there. Such approach would
remove the need for (ab)using ops->walk() for this since internally
in classifier implementation there is always a way to correctly verify
that classifier instance is empty. Don't know which approach is better
in this case.

>
>>
>> cheers,
>> jamal
