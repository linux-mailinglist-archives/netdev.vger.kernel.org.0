Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7342E127C3E
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 15:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbfLTOEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 09:04:50 -0500
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:58089
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727344AbfLTOEu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 09:04:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjvxFuyIlhdw0IGLepL5pTVELx/oyRPmbdn30gu0PgDV4YmeBFaT3+BBiTXk744R31x5aSTlsnrVIeXwG81BXrAQBrdVctCWsDc8jDOBSemy/MGlk2D7Nzx8U3DziPFaE6t2ugLH97qBS1OnZx8THqes0aSXkVPP8R9gNomBIRdskmAMvm5heKEud+T6AI0Wt84g9PsELv7XLY9cPMt5cVxculc5mU0cEIFg2lytnIJz34SNLyJ+x4AeyMnsyKfsBSTZjkIbOpKG4YvLHiKP8fkiaLgLtx0YZv5MoZyTWWQw0gNrmlK47YBN+P6Dir+73JOxPuFR8og8F4a9AT7HfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJJADfCotJhn8EkrQI64/N1CN/USC8xpMY+jxWXnJRE=;
 b=lhEVSsbWbd/qv+J6Tpr6FZl2KQ9Dkd6DEretzuldZE2StWDSi9JASY7JKZjGz8c3HDg3P/YMatfx3t91k+8DixEkwrS+qQNXS+abOg3twk9/0PgGH25s6GBWLQKSPkqwXyQfemtODKAyIYVmb/ehaig+SKWiIjV50bOHpmvHyQcmHL6MP8ibn9xJZ+NejGMbhJusRjhNUavTuBEUQ5pCQIzLp6oZTWWU7iQ8Uq8w98hUGrKgzASpYSNsWxOUbFqAm1vG5a3QGBpRMZuX2FxRgRfVyXNX5sWbzVI0UH29N8CKx2qZ4a658FAWb8IOKXhMmoaPEXVDtOkbWCb2oFkPIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJJADfCotJhn8EkrQI64/N1CN/USC8xpMY+jxWXnJRE=;
 b=kMX88Ap1iIUq7sH75E8c7hTcQclEQxuUkgYuVr34Oe5gKI28g0ogxno0Gaci6gAUrceucN/ZNt+Opxusg9SX8BnbA48OEhlcjv4OI3cZ9pxgJ8XItOeJ3oZVYKyvoJKsKE6a/DQDIMgeKWA+FtZnaPnxiINa3a9twyBbrD5sSxI=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB4224.eurprd05.prod.outlook.com (10.171.182.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.16; Fri, 20 Dec 2019 14:04:47 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::79d0:a1c8:b28:3d10]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::79d0:a1c8:b28:3d10%5]) with mapi id 15.20.2559.016; Fri, 20 Dec 2019
 14:04:47 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Roman Mashak <mrv@mojatatu.com>
Subject: Re: [PATCH net 1/2] net/sched: cls_u32: fix refcount leak in the
 error path of u32_change()
Thread-Topic: [PATCH net 1/2] net/sched: cls_u32: fix refcount leak in the
 error path of u32_change()
Thread-Index: AQHVtS3RDHKj6jsD1UGiL38qYfL+d6e/8y0AgAGEDQCAAC2QAIAABOKAgAAFA4CAAAK4gIABQWAAgAAD8wCAABH2gIAACc+A
Date:   Fri, 20 Dec 2019 14:04:47 +0000
Message-ID: <vbfa77n2iv8.fsf@mellanox.com>
References: <cover.1576623250.git.dcaratti@redhat.com>
 <ae83c6dc89f8642166dc32debc6ea7444eb3671d.1576623250.git.dcaratti@redhat.com>
 <bafb52ff-1ced-91a4-05d0-07d3fdc4f3e4@mojatatu.com>
 <5b4239e5-6533-9f23-7a38-0ee4f6acbfe9@mojatatu.com>
 <vbfr2102swb.fsf@mellanox.com>
 <63fe479d-51cd-eff4-eb13-f0211f694366@mojatatu.com>
 <vbfpngk2r9a.fsf@mellanox.com> <vbfo8w42qt2.fsf@mellanox.com>
 <b9b2261a-5a35-fdf7-79b5-9d644e3ed097@mojatatu.com>
 <548e3ae8-6db8-a45c-2d9c-0e4a09dc737b@mojatatu.com>
 <cc0a3849-48c0-384d-6dd5-29a6763695f2@mojatatu.com>
In-Reply-To: <cc0a3849-48c0-384d-6dd5-29a6763695f2@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0231.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::27) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0b677c78-e53b-4673-b133-08d78555925b
x-ms-traffictypediagnostic: VI1PR05MB4224:|VI1PR05MB4224:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4224DB9E124A5B137111B1D0AD2D0@VI1PR05MB4224.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 025796F161
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(199004)(189003)(6486002)(4326008)(316002)(2616005)(54906003)(66946007)(478600001)(6916009)(53546011)(6506007)(86362001)(81156014)(186003)(26005)(8676002)(81166006)(8936002)(66556008)(2906002)(64756008)(66476007)(66446008)(71200400001)(36756003)(52116002)(4001150100001)(5660300002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4224;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z2JLL+kH5gut913lg0I4LWTYU3FVJRhfCIfhRWJwqRTk7nezB9hcQEbqSAG9H66wiTHWX2dEBumNZI/VzrIh/OI9QsYG8ABo23+Iz1lnt+RyGVC73Py6ORuWm1SmiCYfYO2HQ00vQ48Gfk8MqhSh6u1fONyZ/IOM+mWqMT7FPfB4Tgv92EPUYYxnhL0A1B2aA3VSiaLEZ3+h6SVZsTFS1np5EhKqqcyuJICy+Ne9CUujj5UNA7ay9ccxX/64UceroZcjdokyBUztBhWpxt4nnoRbZA2mgeCnDemvOKRVCJSvCRy6g3W6697ct66yiQdXjVt4c2faVhis6aSj6/0OkojdPmCF1Ic/urSNbEXsXvm9/aGcGAlvNXf7qA4UqMy/8FaCOx9K/74pk8hafv2wNjq5qOQ7IitoxC7Pfk/DmmjIjSqocQTwtGEJDGp+uHdz
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b677c78-e53b-4673-b133-08d78555925b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2019 14:04:47.1890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ePWvOBIPhQeeF33Bt/oj3G9HPn3g1DdIm4qfzC1S1WYO0jX1FE78nmSCK7RVtndDslwANQZ85592P5+FHX1nkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4224
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 20 Dec 2019 at 15:29, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2019-12-20 7:25 a.m., Jamal Hadi Salim wrote:
>> On 2019-12-20 7:11 a.m., Jamal Hadi Salim wrote:
>>
>>> I see both as complementing each other. delete_empty()
>>> could serves like guidance almost for someone who wants to implement
>>> parallelization (and stops abuse of walk()) and
>>> TCF_PROTO_OPS_DOIT_UNLOCKED is more of a shortcut. IOW, you
>>> could at the top of tcf_proto_check_delete() return true
>>> if TCF_PROTO_OPS_DOIT_UNLOCKED is set while still invoking
>>
>>
>> Something like attached...
>
> Vlad,
> I tested this and it seems to fix the issue. But there may be
> other consequences...
>
> cheers,
> jamal

Hi Jamal,

Yes, I think the patch would work. However, we don't really need the
flags check, if we are going to implement the new ops->delete_empty()
callback because it can work like this:

if (!tp->ops->delete_empty) {
   tp->deleting =3D true;
   return tp->deleting;
} else {
  return tp->ops->delete_empty(tp);
}

WDYT?

Regards,
Vlad
