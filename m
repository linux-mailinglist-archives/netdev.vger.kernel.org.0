Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4E9367359
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 21:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243161AbhDUTV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 15:21:56 -0400
Received: from mail-bn8nam11on2127.outbound.protection.outlook.com ([40.107.236.127]:33925
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243021AbhDUTVy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 15:21:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSKG6vSnKrBXosBq2UYg+HZlDq9JphhGUMmgvW8HDX9cdo0FJMR17IecZDjmzFi8HB23ssdrrfEoEtbFiMYt4zq4uPR9u1JiFIpuwWacV9zAjdxsP1+sDNRXjHjVJ71e1C3i1NFgEt+/LzoUpRt2HQDAGmhKZqILyBGaEd+X0HnKozIWWsYoFg4dxhAxFBMIHPW6LJchQ/VBxcUcSPhqzOLJcUuf0fmbKlWsrsDpD9fLvaWLLtkk+srlSAzhA5LcSGXxWGLHDm3STrtNaaCaywSg79bdtHn2PCXtxMExOb19GZMVrs8MdgezbptxJjfUa4rV9b6z25yona+QdxHXKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETQdYM34+beZa7XfWtmTVuqUmaiSgMrmUGyYKzK2TFs=;
 b=dag1ZyBFqIc/DJT2mOMUnE2rcRLX+4iCI2yBR0FAOzNfVBpp+VFYKtI3eZw2udRzDxEo4O5Ce9C6qt0fAKZiw2dpHeThmXtg4hZRuulh1cQwV77LgzprVtlLGN1UOqzzFpoOrgNIttTLu61YAt++CuF5R0uGQdreT5CNbS2ARDWoffDOV4BKifiRUrS+oAaLqBeYkP46lTewLTBi+6iLhHoq8gLv6tulxH5vWNIDUeyWhEZplr0yd1po8GVyRxeMqupyxuBedCFCebtFTRGHYevS70awfbTouaEgEIopGlYySpoM2v7asal1NOZGJVp+hx2IBcOFM6etOL7Ae9rHgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETQdYM34+beZa7XfWtmTVuqUmaiSgMrmUGyYKzK2TFs=;
 b=r1SZEeDQa47sObVh1Lcwq6Hwb1r59k4JNbV8iTEx/tyEeHmmkY1J+DJPcJzW3VhzNipKx/5F8C/O0rHGp/f/WZbLeKwjF1gvTLU/BooQdSyvrCwFuuDD3Bs8y5BCJo4T17cOybLnZLvdvdiopqtwfNkNaNboR1A7VnezfjJ4I1s=
Received: from CH2PR22MB2056.namprd22.prod.outlook.com (2603:10b6:610:5d::11)
 by CH2PR22MB2056.namprd22.prod.outlook.com (2603:10b6:610:5d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Wed, 21 Apr
 2021 19:21:20 +0000
Received: from CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::fd2f:cbcc:563b:aa4f]) by CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::fd2f:cbcc:563b:aa4f%6]) with mapi id 15.20.4065.020; Wed, 21 Apr 2021
 19:21:20 +0000
From:   "Gong, Sishuai" <sishuai@purdue.edu>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "tparkin@katalix.com" <tparkin@katalix.com>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] net: fix a concurrency bug in l2tp_tunnel_register()
Thread-Topic: [PATCH v2] net: fix a concurrency bug in l2tp_tunnel_register()
Thread-Index: AQHXMgIkA0od3E621kiKZ11bZZJQ5Kq3ZccAgAf9N4A=
Date:   Wed, 21 Apr 2021 19:21:20 +0000
Message-ID: <9860EA3C-374D-41D6-B0E6-58B448D4348A@purdue.edu>
References: <20210415141724.17471-1-sishuai@purdue.edu>
 <CAM_iQpUqMOTAwfrXoY5a4tCTdCk05OEFc4sZDjKr-wzoew5kaA@mail.gmail.com>
In-Reply-To: <CAM_iQpUqMOTAwfrXoY5a4tCTdCk05OEFc4sZDjKr-wzoew5kaA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=purdue.edu;
x-originating-ip: [66.253.158.155]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da839300-4820-4814-307f-08d904faa4e1
x-ms-traffictypediagnostic: CH2PR22MB2056:
x-microsoft-antispam-prvs: <CH2PR22MB2056BEC0C64BB1C8F4C7EE1CDF479@CH2PR22MB2056.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QmpSmUILV8BfOUQ15m28RZ77rK8IOwpC1SRPFAvez+DUJjjO9U5gmT9YtdBS0BG0Qks1cskApxrpWrnmlB0T9DFptnegWuBBqPzUtwf40pddUzvon3hYPGXx7JakkZI8Opb3VOM7QbdjyhobJuEoSC7neNEzbofFLDCgMbmjPlrrN6J44WzgqI52FKtXJP0clRyaGSavUTNch2L3dORCIdsyuevbR5tAXpKErG2Arkcx239xGWpZUz6V4Gxzn7vcq2RVxGfaw40xc1d/xod0Kuf/v+T4O7QiNSiJWLuSDdmJcdkS92J51hQtImodl0NqzHyP4ZnIdViOsxkQkT8bNql81pfh/QT4z+Ax2g2TjQqJNLN/uLkJO1bwID2vamLg4uG2g2/BgDR2LCG2tXErH9GOlwSSc+lWN/ogWKlCYs4SWxTnqMb84lJh2rWW3AeyBboSwXOiimyzvmKaDU1drQaZdkIoKIJ7J1FmODDRKYytp3gQV2Wt0xM5WLO2aBVbGIqI1kXqtECHOY5gO2IjybyBLzmZieASDkA6OkiyCcMbhzsN3JFUkTsYLD4BYvEwSs2zmBnAeFRmN9MLDyMX3XubkeaPj+23jsZTgBGR881S3uMDkgGoATrlOc+p0XyE+YAsF5xy6AIQLyCCQNBKYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR22MB2056.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(5660300002)(75432002)(71200400001)(6486002)(6506007)(2906002)(186003)(53546011)(8936002)(316002)(6512007)(8676002)(122000001)(6916009)(478600001)(38100700002)(36756003)(4326008)(26005)(86362001)(54906003)(786003)(83380400001)(76116006)(2616005)(66446008)(64756008)(66476007)(66556008)(66946007)(33656002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gbcXPiyOrFDxLeJdqcThhnpWjMiZ04rWGXefPe0z6Q34+NwSVwGbkD9IBzhT?=
 =?us-ascii?Q?8iEw+d3lG1qDGWW+XbDyn7Zbg3BxDtTTKv1AN9vY5Mw5i26t3igRXzZx6ADR?=
 =?us-ascii?Q?npbY9EwxqssgjPCAi4hd2w95oZ45zetBFPLuzsOHh1Jto/1xBCRuKjVA9dry?=
 =?us-ascii?Q?EHKROhf8SmW0VtfKs/2L2f+wVNZMvuMKOeBlwhVhQyfiR1sOLnhkhD6Rfq3x?=
 =?us-ascii?Q?jxKCczY7AClTQD70pxh5J+I41Rhe163mEQcFzmh7EZnFWXBMGshys18xttaT?=
 =?us-ascii?Q?2ms8U4a/p5rEgwHItcsZEl73EPytVsQkzfDwT+iW0Q0EaVMa7R6iSs4Zbo9P?=
 =?us-ascii?Q?iNcoiJIACkCAO79fENrQRvOxnd86eEUXCvw+ZtB41xd7HetLU43s8Mwus/vM?=
 =?us-ascii?Q?zP5VYh0vgtVAlhTDNeSS7OGWoHcz0WXb1pL72S1vUiwceRja3J3E5kFm+j1U?=
 =?us-ascii?Q?AwRZ9FCDNPPTcXVPbvrpmoaY24Pnz9a8V7pPOyGk/8wtDqIPK1u1XE+AyqCt?=
 =?us-ascii?Q?9mUZXW6EZG9HQZza02+oMSuIODc7V+0oxTkPyG+jFj2D6wR6UfTirX5ri2lw?=
 =?us-ascii?Q?+l5Ark2XxQWNYOIkLc0Oc+tNxWnmhXBlubh0UQE6Jmakvww98r/4F1WY0wnZ?=
 =?us-ascii?Q?UsBcRo/Ii/UOkgxwH+wzUGTnu3wpWwilkbu4N43l9Phz4xrT4eKmCtC7mWYq?=
 =?us-ascii?Q?/4XbuG0rkz34gZ7IkWGiVUKHLce47eHocCd5Xw3N8m1At79CutSLpda+wm5v?=
 =?us-ascii?Q?cOXTddu01761Cr0vIfXEW6qNtvf2aZ62IuStdqG3rqpK81i96be9FgezzGzX?=
 =?us-ascii?Q?wG+G/ERjtYo8V34ou9t24kbpS24jUpdzWOeNH0kSEvrxIfWi35KexkoMeqas?=
 =?us-ascii?Q?53uFEFxzD4m+47R5kJzbU9H4F5ZgM0VKjORaYfJUuQT5j11xsbzNN7OlWGGJ?=
 =?us-ascii?Q?0eQG0nqn5Gqj1uhFWbzQvkVGhB/iZFub1GbIWXHWExcn6SNudyyuEDImCPFy?=
 =?us-ascii?Q?4UzMVC/TlMFRIp8s64RfKAtap4EfZEsCvGj+DGQhcQmuVpFyf7MX7327hyHs?=
 =?us-ascii?Q?BjUfoTgmUMNR6uya4vC5DbjyPDC+T55wHWRjRAKLF2NO/fJlw/g/QX5ViSOU?=
 =?us-ascii?Q?XLFqx25Qd9FR1ojKbzLezHugwqmGGwRz42gDXEwji39Yo27C+vtHbZP+oed1?=
 =?us-ascii?Q?QOeWZak7ygVr225BuY0bFX25wbzEevyrePbfeR65LBwdLehaWE6+qH4BVzr3?=
 =?us-ascii?Q?fUN9z2DddxZfo3RId1tANuIhVWXBmpTHnl0RG6LShnasZTIV1v8QFYDPF7B4?=
 =?us-ascii?Q?YL6JWHFsaTvI9F+GY3u/Nvt+?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <99F0816CC0014A4E8359F799F6E82AE5@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR22MB2056.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da839300-4820-4814-307f-08d904faa4e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2021 19:21:20.3465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FOWTDVR2vdZxUxzgKT+u7urvXjarhyjHUkuVMF7iIt9hjXKqjUsiwFo+y8bqLSg2XP4go7G7NvarHMhNKz2ObQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR22MB2056
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Apr 16, 2021, at 1:21 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>=20
> On Thu, Apr 15, 2021 at 7:18 AM Sishuai Gong <sishuai@purdue.edu> wrote:
>> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
>> index 203890e378cb..879f1264ec3c 100644
>> --- a/net/l2tp/l2tp_core.c
>> +++ b/net/l2tp/l2tp_core.c
>> @@ -1478,6 +1478,9 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunne=
l, struct net *net,
>>        tunnel->l2tp_net =3D net;
>>        pn =3D l2tp_pernet(net);
>>=20
>> +       sk =3D sock->sk;
>> +       tunnel->sock =3D sk;
>> +
>>        spin_lock_bh(&pn->l2tp_tunnel_list_lock);
>>        list_for_each_entry(tunnel_walk, &pn->l2tp_tunnel_list, list) {
>>                if (tunnel_walk->tunnel_id =3D=3D tunnel->tunnel_id) {
>> @@ -1490,9 +1493,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunne=
l, struct net *net,
>>        list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
>>        spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
>>=20
>> -       sk =3D sock->sk;
>>        sock_hold(sk);
>> -       tunnel->sock =3D sk;
>=20
> I think you have to hold this refcnt before making tunnel->sock visible
> to others.
>=20
> Why not just move this together and simply release the refcnt on error
> path?
Thanks. It totally makes sense. I am going to send the next version.
>=20
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index 203890e378cb..8eb805ee18d4 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -1478,11 +1478,15 @@ int l2tp_tunnel_register(struct l2tp_tunnel
> *tunnel, struct net *net,
>        tunnel->l2tp_net =3D net;
>        pn =3D l2tp_pernet(net);
>=20
> +       sk =3D sock->sk;
> +       sock_hold(sk);
> +       tunnel->sock =3D sk;
> +
>        spin_lock_bh(&pn->l2tp_tunnel_list_lock);
>        list_for_each_entry(tunnel_walk, &pn->l2tp_tunnel_list, list) {
>                if (tunnel_walk->tunnel_id =3D=3D tunnel->tunnel_id) {
>                        spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
> -
> +                       sock_put(sk);
>                        ret =3D -EEXIST;
>                        goto err_sock;
>                }
> @@ -1490,10 +1494,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel
> *tunnel, struct net *net,
>        list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
>        spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
>=20
> -       sk =3D sock->sk;
> -       sock_hold(sk);
> -       tunnel->sock =3D sk;
> -
>        if (tunnel->encap =3D=3D L2TP_ENCAPTYPE_UDP) {
>                struct udp_tunnel_sock_cfg udp_cfg =3D {
>                        .sk_user_data =3D tunnel,

