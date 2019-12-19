Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95FB0126768
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 17:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfLSQwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 11:52:54 -0500
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:10862
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726840AbfLSQwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 11:52:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPpn89aLI39NBx+ZwVUrHWFTy/VvUIh4a5R0i1w98eAUgmSyNGOOlo4O0eZkwU5vSuYPC/vGrdLNpudNwyYKOcjw9PGa+U1Vu827QoQ0Rk/7M81K8qqBebN8J58HZcwvZpmPK5JzYgD9EO6QqwCxUqasd+gu0dbeEL+ygyrtN6AG5zByzO0iMF/HWycBQ55LlkekykcNmSuPxYUX/bL2imn802HjJNdBIEonzlRpzDwxqW6RYaRFYFBLGDg3Hzs1+63o445VSOvS411nO01Is+gPfSN2ZGXKQc1gF2AL8oY3pC3qoIi2ntFqwxfxfYzgE3Ii+F78mE8hi3s/sCI0rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghhDmOCfaGYBY8uEetPhiSHgtKxog0cAb1ThwgbjmXU=;
 b=fFwVwf3mPxWH0RIOWnETgwlrJ4sNnfv9w/PdJyqGgrEzOOzx21PxEg/KCY1HS7MH5+1i3rlpjugiqL+Mp071HqpImLHwp46t0MMnDfXPNpSmYXAN5J+imyLzjOg/BN0oHK9gGMDeRDrT7wlzDtpCKx1h59fJQ9T+4SewOYSEDffuk90p3BiC83Yt1EQMfXqxzw8mpyy39zpV5eaWLprEHaSmOS+U7sulBrkWxwFqYFFtAi8pr5Unf1CRWnQu/myq92aoUbcxocsLLv4JgI4gPVpbYiWa5LHD/X7mUWkrjzPcZYX+Ty+bG2iSH2hhXe6+0GkAGUu9snF/vq4SO0W0Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghhDmOCfaGYBY8uEetPhiSHgtKxog0cAb1ThwgbjmXU=;
 b=o2fmWWtuOjb7Bk4Sx1AsG5OHTTWbrKM0M/upxbujvQyZ/7+J8R6ykug1f6R53AK59g2fFbvv/XRa7SxRysEU74RNtqPvAhd1q0SGer4zFFYTHiNRSn/VUGPATwm+5QCT31K2hyZQvUG0Hy2fIQYYgK7OG8DEyUNdPRfkPDWAshw=
Received: from AM0PR05MB5284.eurprd05.prod.outlook.com (20.178.17.20) by
 AM0PR05MB4146.eurprd05.prod.outlook.com (52.134.90.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Thu, 19 Dec 2019 16:51:17 +0000
Received: from AM0PR05MB5284.eurprd05.prod.outlook.com
 ([fe80::d8ce:80d0:a591:8cc]) by AM0PR05MB5284.eurprd05.prod.outlook.com
 ([fe80::d8ce:80d0:a591:8cc%6]) with mapi id 15.20.2559.015; Thu, 19 Dec 2019
 16:51:17 +0000
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
Thread-Index: AQHVtS3RDHKj6jsD1UGiL38qYfL+d6e/8y0AgAGEDQCAAC2QAIAABOKAgAAFA4A=
Date:   Thu, 19 Dec 2019 16:51:17 +0000
Message-ID: <vbfpngk2r9a.fsf@mellanox.com>
References: <cover.1576623250.git.dcaratti@redhat.com>
 <ae83c6dc89f8642166dc32debc6ea7444eb3671d.1576623250.git.dcaratti@redhat.com>
 <bafb52ff-1ced-91a4-05d0-07d3fdc4f3e4@mojatatu.com>
 <5b4239e5-6533-9f23-7a38-0ee4f6acbfe9@mojatatu.com>
 <vbfr2102swb.fsf@mellanox.com>
 <63fe479d-51cd-eff4-eb13-f0211f694366@mojatatu.com>
In-Reply-To: <63fe479d-51cd-eff4-eb13-f0211f694366@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0134.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::26) To AM0PR05MB5284.eurprd05.prod.outlook.com
 (2603:10a6:208:eb::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 194f7896-0de2-4fdd-518d-08d784a3aa96
x-ms-traffictypediagnostic: AM0PR05MB4146:|AM0PR05MB4146:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4146AB5AF87A10D5884BA4CAAD520@AM0PR05MB4146.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39850400004)(396003)(189003)(199004)(53546011)(2906002)(186003)(4001150100001)(36756003)(26005)(6512007)(81166006)(81156014)(6506007)(6916009)(6486002)(316002)(8676002)(478600001)(52116002)(71200400001)(64756008)(66556008)(66476007)(66446008)(66946007)(86362001)(54906003)(8936002)(4326008)(2616005)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4146;H:AM0PR05MB5284.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dORqq48q1rw/Oxamo6vR41lvvupiaYoDl7OLb2GTT49r/PZWLlYSPK0+DBUh/fkw4uKEgdu8bsxSf7S3T3ST5IRPjEy5x28Q5wxNrFr8Sy61KAJ2OiWxusPwRwGT8lzgDJidMYNeDL2FKVHJTtk7dSpavNrVZyVYANb+HIbqPPgINkANJAsQGRbrbopre6UZFR50Px2UFJ/nL5/eHBZJ/mEH3L2lA0DwPThmo40k0ls9vViCFGSO3RT0HTzOa3mTFGJ1XzHjpxRtNAqoctO2JtDBqUNS4QeZI3SfVt0zJW4wsKpiKq3ocU1anKpupYz6boTspIz8+0Stq2EnMc9FJvE1Qk+cy7IoS/NWLbGpLjqQMxFnvXSZIrYWI6SiMn1iTIG7Y7FZHIalPdAuDiH9QBIqf4RfVDVe/UgoP3HVMDY3E5X1UuQiE+UlDceYRUMw
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 194f7896-0de2-4fdd-518d-08d784a3aa96
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 16:51:17.4856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jIgwCXYdZy6MvfUT45CBIlmbl7dLTkiyCuO047zi1J5GnU8a3pIG2g6r4mavynoNcvpTg2rGl6vetZUDsU2Svg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 19 Dec 2019 at 18:33, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2019-12-19 11:15 a.m., Vlad Buslov wrote:
>
>
>> Hi Jamal,
>>
>> Just destroying tp unconditionally will break unlocked case (flower)
>> because of possibility of concurrent insertion of new filters to the
>> same tp instance.
>>
>
> I was worried about that. So rtnlheld doesnt help?

Rtnl_held flag can be set for multiple other reasons besides
locked/unlocked classifier implementation (parent Qdisc doesn't support
unlocked execution, retry in tc_new_tfilter(), etc.).

>
>> The root cause here is precisely described by Davide in cover letter -
>> to accommodate concurrent insertions cls API verifies that tp instance
>> is empty before deleting it and since there is no cls ops to do it
>> directly, it relies on checking that walk() stopped without accessing
>> any filters instead. Unfortunately, somw classifier implementations
>> assumed that there is always at least one filter on classifier (I fixed
>> several of these) and now Davide also uncovered this leak in u32.
>>
>> As a simpler solution to fix such issues once and for all I can propose
>> not to perform the walk() check at all and assume that any classifier
>> implementation that doesn't have TCF_PROTO_OPS_DOIT_UNLOCKED flag set is
>> empty in tcf_chain_tp_delete_empty() (there is no possibility of
>> concurrent insertion when synchronizing with rtnl).
>>
>> WDYT?
>
> IMO that would be a cleaner fix give walk() is used for other
> operations and this is a core cls issue.
> Also: documenting what it takes for a classifier to support
> TCF_PROTO_OPS_DOIT_UNLOCKED is useful (you may have done this
> in some commit already).

Well, idea was not to have classifier implement any specific API. If
classifier has TCF_PROTO_OPS_DOIT_UNLOCKED, then cls API doesn't obtain
rtnl and it is up to classifier to implement whatever locking necessary
internally. However, my approach to checking for empty classifier
instance uncovered multiple bugs and inconsistencies in classifier
implementations of ops->walk().

So I guess the requirement now is for unlocked classifier to have sane
implementation of ops->walk() that doesn't assume >1 filters and
correctly handles the case when insertion of first filter after
classifier instance is created fails.

>
> cheers,
> jamal
