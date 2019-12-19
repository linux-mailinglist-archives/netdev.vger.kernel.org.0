Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D1E126678
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 17:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfLSQQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 11:16:00 -0500
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:38471
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726760AbfLSQQA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 11:16:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bm8z2qz+XRjKThBGSCFA2MYokGrrqgqtim+8Tuj8fhimL0ZQdT96liLizp39h1bm3YxeDvnJbyTLYlcqQj9vC3Ut0eH+xWyZnV86CAnESKbFF4Ho0THcO6NaDio7MFj4YX/LSf3Ndpe5KFWlf/MNWmM1KeDRwMWuQCrjyIuWRWn/Lnk2SmchTFqPKBBLlZ7dzhGgsJ+ukOqi4WoOEZi+xLefR+sj7HcG6U0Kaz4PxIGz7/mHrJrO89k58Ut8doMxyD3bH98w1oBAZh6mcAE8qQgUfIUqB3Ba54tZ75ZtPNM18wozQ0HiQELVYBNXrEXZob7CRBlCZriU3MxEhBq5Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyAHA+xzVVzGVsI9vMmsXDZ3DTiCwl51TCzkp2gDpPQ=;
 b=MpVQzdQYE3/2Fum5Xsj2rWo+Wvrrr0oiHwqX5rQwiTA0vo5oqjRJkxnhbuI6jeGdrs0Ii5wZCdq8Ve5WWHEyCNkmorYsGfFUcCPZgAXD3dmZBxeyc0DmvbAM2VARjrB9PJNVgMHZ+67o5+K4+TtxurDPpWqzp/RNHrTATR3Hy2UeGqBzmz4m36FiOIDUwwcdCWDjolOYC2vBZ2kozfq9h68xgyTwhmBvQO5wVBiO/64LWciVgJIjLmECeIwu7aDi5wzw4BxUCOsfRJtg9c2gJfM87C/0dhIaEd3CQJaHUJl5oNdx1W63YBiTFPNqUaE6ALAN/+p3M/1UWNPlREHzmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyAHA+xzVVzGVsI9vMmsXDZ3DTiCwl51TCzkp2gDpPQ=;
 b=tqnqzTNIgBBuo3LkUHrxVT6VwLPhpXQ50HnNX1l1fCZXk7sykqWlBIIIUGJvf+XhuoAHBdY56pzio16JgQVxgoWLWmCDN1Atohy7/TjQtf5sjvH907EtYwl203MM7X01U0aufMUO9PB5YS3h6SEas+Z3r8/S5xCm0B4Ypbm4ckI=
Received: from AM0PR05MB5284.eurprd05.prod.outlook.com (20.178.17.20) by
 AM0PR05MB4946.eurprd05.prod.outlook.com (20.177.40.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Thu, 19 Dec 2019 16:15:53 +0000
Received: from AM0PR05MB5284.eurprd05.prod.outlook.com
 ([fe80::d8ce:80d0:a591:8cc]) by AM0PR05MB5284.eurprd05.prod.outlook.com
 ([fe80::d8ce:80d0:a591:8cc%6]) with mapi id 15.20.2559.015; Thu, 19 Dec 2019
 16:15:53 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Davide Caratti <dcaratti@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roman Mashak <mrv@mojatatu.com>
Subject: Re: [PATCH net 1/2] net/sched: cls_u32: fix refcount leak in the
 error path of u32_change()
Thread-Topic: [PATCH net 1/2] net/sched: cls_u32: fix refcount leak in the
 error path of u32_change()
Thread-Index: AQHVtS3RDHKj6jsD1UGiL38qYfL+d6e/8y0AgAGEDQCAAC2QAA==
Date:   Thu, 19 Dec 2019 16:15:53 +0000
Message-ID: <vbfr2102swb.fsf@mellanox.com>
References: <cover.1576623250.git.dcaratti@redhat.com>
 <ae83c6dc89f8642166dc32debc6ea7444eb3671d.1576623250.git.dcaratti@redhat.com>
 <bafb52ff-1ced-91a4-05d0-07d3fdc4f3e4@mojatatu.com>
 <5b4239e5-6533-9f23-7a38-0ee4f6acbfe9@mojatatu.com>
In-Reply-To: <5b4239e5-6533-9f23-7a38-0ee4f6acbfe9@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0039.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::27) To AM0PR05MB5284.eurprd05.prod.outlook.com
 (2603:10a6:208:eb::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b679a98d-4bca-419c-0345-08d7849eb8ad
x-ms-traffictypediagnostic: AM0PR05MB4946:|AM0PR05MB4946:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4946B0416E156B3EC517D4C7AD520@AM0PR05MB4946.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39850400004)(346002)(376002)(396003)(199004)(189003)(6916009)(316002)(54906003)(53546011)(52116002)(6506007)(36756003)(4326008)(5660300002)(66446008)(4001150100001)(66556008)(66476007)(66946007)(478600001)(64756008)(6486002)(6512007)(2906002)(81156014)(186003)(71200400001)(26005)(2616005)(86362001)(8936002)(81166006)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4946;H:AM0PR05MB5284.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w5Mr9XNecm701FmTUCiYexCE1gOdQCxR1Zw/HrrkSlwB4+Q4jb6O5ksfjdTh/15xNDse3CEh3fBVBaKkbdqyCx+prvoJ6eVMHEeZf73fgbVzPl+b37O+uOn093wjCcZ1n8BK8XqbH5YrR2eFeYdyNNTvpL9n0vBdXWVK4sVD9S+iWo4UrfvMQYLPmMDNllsfzVT49zAiYAtUto4zyLyK9zBsURwvDXIwB16patpA7806UNVsR4U8TDTiZp8hZ4sNtV6q+uD0dQFKGrfgKUL5kwfTkwfe4D3AqW2zrWvNarHrLDa/M9vEQlsQPmOu2wbqcpcsIJWNFwZX/fVqgzxzvFLlDK0KaZeLJfiHBl9rPVrecL7ocVJGSCpLZXYQ44PKHg9faFelnO077zHDLrASPL3yGJ3qveMcwJG4Q6jCIaMBBu0dovdma9z3NS7HFs0C
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b679a98d-4bca-419c-0345-08d7849eb8ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 16:15:53.6148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sxH3N266utyMWPbEJR6qGXxIfmeOt8OKzkDCbZBiHY1RWdfWkSHt9IG0Lp1VWEYoBLqZFrUSh55j3p/jN8U4Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4946
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 19 Dec 2019 at 15:32, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> Hi Davide,
>
> I ran your test on my laptop (4.19) and nothing dangled.
> Looking at that area of the code difference 4.19 vs current net-next
> there was a destroy() in there that migrated into the inner guts of
> tcf_chain_tp_delete_empty() Vlad? My gut feeling is restoring the old
> logic like this would work at least for u32:
>
> ------------
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 6a0eacafdb19..34a1d4e7e6e3 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -2135,8 +2135,10 @@ static int tc_new_tfilter(struct sk_buff *skb, str=
uct
> nlmsghdr *n,
>         }
>
>  errout:
> -       if (err && tp_created)
> +       if (err && tp_created) {
> +               tcf_proto_destroy(tp, rtnl_held, true, NULL);
>                 tcf_chain_tp_delete_empty(chain, tp, rtnl_held, NULL);
> +       }
>  errout_tp:
>         if (chain) {
>                 if (tp && !IS_ERR(tp))
> -----
>
> Maybe even better tcf_proto_put(tp, rtnl_held, NULL) directly instead
> and no need for tcf_chain_tp_delete_empty().
>
> Of course above not even compile tested and may have consequences
> for other classifiers (flower would be a good test) and concurency
> intentions. Thoughts?
>
> cheers,
> jamal
>
> On 2019-12-18 9:23 a.m., Jamal Hadi Salim wrote:
>>
>> On 2019-12-17 6:00 p.m., Davide Caratti wrote:
>>> when users replace cls_u32 filters with new ones having wrong parameter=
s,
>>> so that u32_change() fails to validate them, the kernel doesn't roll-ba=
ck
>>> correctly, and leaves semi-configured rules.
>>>
>>> Fix this in u32_walk(), avoiding a call to the walker function on filte=
rs
>>> that don't have a match rule connected. The side effect is, these "empt=
y"
>>> filters are not even dumped when present; but that shouldn't be a probl=
em
>>> as long as we are restoring the original behaviour, where semi-configur=
ed
>>> filters were not even added in the error path of u32_change().
>>>
>>> Fixes: 6676d5e416ee ("net: sched: set dedicated tcf_walker flag when tp=
 is
>>> empty")
>>> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
>>
>> Hi Davide,
>>
>> Great catch (and good test case addition),
>> but I am not sure about the fix.
>>
>> Unless I am  misunderstanding the flow is:
>> You enter bad rules, validation fails, partial state had already been
>> created (in this case root hts) before validation failure, you then
>> leave the partial state in the kernel but when someone dumps you hide
>> these bad tables?
>>
>> It sounds like the root cause is there is a missing destroy()
>> invocation somewhere during the create/validation failure - which is
>> what needs fixing... Those dangling tables should not have been
>> inserted; maybe somewhere along the code path for tc_new_tfilter().
>> Note "replace" is essentially "create if it doesnt
>> exist" semantic therefore NLM_F_CREATE will be set.
>>
>> Since this is a core cls issue - I would check all other classifiers
>> with similar aggrevation - make some attribute fail in the middle or
>> end.
>> Very likely only u32 is the victim.
>>
>> cheers,
>> jamal
>>

Hi Jamal,

Just destroying tp unconditionally will break unlocked case (flower)
because of possibility of concurrent insertion of new filters to the
same tp instance.

The root cause here is precisely described by Davide in cover letter -
to accommodate concurrent insertions cls API verifies that tp instance
is empty before deleting it and since there is no cls ops to do it
directly, it relies on checking that walk() stopped without accessing
any filters instead. Unfortunately, somw classifier implementations
assumed that there is always at least one filter on classifier (I fixed
several of these) and now Davide also uncovered this leak in u32.

As a simpler solution to fix such issues once and for all I can propose
not to perform the walk() check at all and assume that any classifier
implementation that doesn't have TCF_PROTO_OPS_DOIT_UNLOCKED flag set is
empty in tcf_chain_tp_delete_empty() (there is no possibility of
concurrent insertion when synchronizing with rtnl).

WDYT?

Regards,
Vlad
