Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE4A8D4DD0
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 08:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfJLG4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 02:56:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62222 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727016AbfJLG4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 02:56:20 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9C6sGmi027276;
        Fri, 11 Oct 2019 23:56:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=M8kmfz+fec7N7FI9zmz6E0Bi2uI/QLjqaDvh1AODNEI=;
 b=DCPNsbX5jMaqQISkHkY2XEolQMr8uOCGMtu0gR+Nuy6Kc0dgKJuOYYUoqUtBEUo+AtRz
 kLECaVy408xNABWsS564ktqwHypWUqmv2SQHh18YsUMSoMvt5Mj76CJksxy8N7yLo9ox
 SMR4Bb9h8vCHn5ZnmmY7MdtmeQisp/91dZo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vjtsm3jg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 23:56:15 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 11 Oct 2019 23:56:14 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 11 Oct 2019 23:56:13 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 11 Oct 2019 23:56:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxWUWh4OoUkJDaJ5lC3Y1Hns/+VbMibhrDdnH+VFk/asqm+twJ2qZAUtg2K6lrVWW7n7QenDJiKJtcozURD/Zs9vL2JfOaYN00Iq+MrOKqE/sUmJMcdCp3KQ/4y/y4Yie2jbwbTc5p0X/nGmijxzBRwahjziT+4TsQ7oYih+p3M/xSuNfIAEEw8Y4vW47aHfxsyotLrB4uVN309GeiZBoIfV5P6EmdLE7JCBHGBw3YwKeuQf6s0cxX1oKkPbrmFrYN8bynhgBes6eZPuriB43a4vVZmBomVFCCvWebyPZQQ2ylzyzLFNyLekpw6St65fl2uXPgLnfyyTWdALpXn/Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M8kmfz+fec7N7FI9zmz6E0Bi2uI/QLjqaDvh1AODNEI=;
 b=P1VLfXpRg9AgptUjuSIzvxZPXXxnzE0U/PYSWrOskvmpebrQDisxCFLVr9NpUmSYp1MPZneU8zaMZsyzpBErG4hjsoc1EuWybDikGSBFWq/dcy8Nf5hl2+p8WZ7vrTKb2ORaKiWsaOhk/KjBfDB2w4wLMM/YEeD+yMLhmWZd3e2U9aWRql8/MIWsrq/vIrR9qdyUD2t4rNO/k/TEo9cLQ7W+RbvC72e+WB+gLp5wnU2ZuiAYt1NlyMOW48H6cJomUspdQhatcIV/hsiFA7digEzA8fVoKwo0xRdC1EYiAERFzZ7FKUKsNQ+0wAZozCk4Qz7tZI+uqLTKoxpmDBMM+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M8kmfz+fec7N7FI9zmz6E0Bi2uI/QLjqaDvh1AODNEI=;
 b=Vmr1b/xHBV5PucKYX8xM//1MKDrqaUS/r5mr94e4BY7yik/sY4xLERGwAx4eiZqMQVjCYBfX5r/r8Hf0mbwXieuOIdKAZl+xVr0IdCFxLBXOR1a/dzHmskVj3rL+CWyJHsMt+zyJadKxnOSqB78KquXjjQpYOIWkqPGqL3k83fo=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3359.namprd15.prod.outlook.com (20.179.22.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Sat, 12 Oct 2019 06:56:12 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2347.021; Sat, 12 Oct 2019
 06:56:12 +0000
From:   Martin Lau <kafai@fb.com>
To:     Wei Wang <weiwan@google.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        Jesse Hathaway <jesse@mbuki-mvuki.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: Race condition in route lookup
Thread-Topic: Race condition in route lookup
Thread-Index: AQHVfrqzp034SiLNvUyIFpgTa/vMKqdTjKQAgAH4ioCAABJQAIAAJNSAgADadwA=
Date:   Sat, 12 Oct 2019 06:56:12 +0000
Message-ID: <20191012065608.igcba7tcjr4wkfsf@kafai-mbp.dhcp.thefacebook.com>
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter>
 <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
 <20191011154224.GA23486@splinter>
 <CAEA6p_AFKwx_oLqNOjMw=oXcAX4ftJvEQWLo0aWCh=4Hs=QjVw@mail.gmail.com>
In-Reply-To: <CAEA6p_AFKwx_oLqNOjMw=oXcAX4ftJvEQWLo0aWCh=4Hs=QjVw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0031.namprd12.prod.outlook.com
 (2603:10b6:301:2::17) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::3588]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e9f70ce-35b8-4c7f-af07-08d74ee14482
x-ms-traffictypediagnostic: MN2PR15MB3359:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR15MB33591E0B1F628422D63B5B1DD5960@MN2PR15MB3359.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0188D66E61
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(136003)(366004)(376002)(396003)(51914003)(199004)(189003)(51444003)(4326008)(2906002)(81166006)(54906003)(8676002)(25786009)(256004)(14444005)(6916009)(8936002)(5660300002)(316002)(6246003)(6116002)(6306002)(9686003)(6512007)(478600001)(486006)(446003)(11346002)(476003)(81156014)(46003)(186003)(229853002)(86362001)(66574012)(305945005)(66476007)(66556008)(64756008)(14454004)(53546011)(71200400001)(1076003)(66946007)(66446008)(6436002)(102836004)(71190400001)(6506007)(386003)(966005)(6486002)(7736002)(76176011)(99286004)(52116002)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3359;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iqZPZF7QrL3tMkY1F7ozrOriwS7VnFMuDA+9oS0t3bANtZSSsFjm8oxgGf5mK6F1PparZLeXwo5zT84C9mBqFKPRPuHpmYwTYa9neomTYwlpJEp4LlfAcAciA+VObyDFKrCE1xm8sd8KSo3OBKk1EKMKGng6UfBNuHt0S5zBsZGCBOCUNw/v1NqTI4LBA6KEpRdAJbspF11Q6sbQ+4XiSWEF27DhpfGarnTR4O2Y/n3Uv/WirH/OhG/aJywURxnKEyneMsu8EsnRtk5cTSUE2Ry/nwr4iYfvMy55DCIhoWmlOAFputl/vSywklykwd1xic9bGm72EcqIyqnXEyIRIyR/A3u8OhbXXA9PzGSqN9N3QCNLjHOQStz/COjokNf+7Kt37LI33C9d7sIXJIB3T45lzznTJ+zJ2l49lay2WNXh5FXzMxTMNNEj/Qo05k12TFwukz71nObjo4UNpiXTUA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B7EB87CC58DF2E438D101FC6A0C80B31@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e9f70ce-35b8-4c7f-af07-08d74ee14482
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2019 06:56:12.7493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zw9Qal6bdwJhB31jWXqIFSg64AWdBjcW3EMr3yC2WxfMuf2MeROy3ouRISSeZDZY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3359
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-12_03:2019-10-10,2019-10-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910120062
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 10:54:13AM -0700, Wei Wang wrote:
> On Fri, Oct 11, 2019 at 8:42 AM Ido Schimmel <idosch@idosch.org> wrote:
> >
> > On Fri, Oct 11, 2019 at 09:36:51AM -0500, Jesse Hathaway wrote:
> > > On Thu, Oct 10, 2019 at 3:31 AM Ido Schimmel <idosch@idosch.org> wrot=
e:
> > > > I think it's working as expected. Here is my theory:
> > > >
> > > > If CPU0 is executing both the route get request and forwarding pack=
ets
> > > > through the directly connected interface, then the following can ha=
ppen:
> > > >
> > > > <CPU0, t0> - In process context, per-CPU dst entry cached in the ne=
xthop
> > > > is found. Not yet dumped to user space
> > > >
> > > > <Any CPU, t1> - Routes are added / removed, therefore invalidating =
the
> > > > cache by bumping 'net->ipv4.rt_genid'
> > > >
> > > > <CPU0, t2> - In softirq, packet is forwarded through the nexthop. T=
he
> > > > cached dst entry is found to be invalid. Therefore, it is replaced =
by a
> > > > newer dst entry. dst_dev_put() is called on old entry which assigns=
 the
> > > > blackhole netdev to 'dst->dev'. This netdev has an ifindex of 0 bec=
ause
> > > > it is not registered.
> > > >
> > > > <CPU0, t3> - After softirq finished executing, your route get reque=
st
> > > > from t0 is resumed and the old dst entry is dumped to user space wi=
th
> > > > ifindex of 0.
> > > >
> > > > I tested this on my system using your script to generate the route =
get
> > > > requests. I pinned it to the same CPU forwarding packets through th=
e
> > > > nexthop. To constantly invalidate the cache I created another scrip=
t
> > > > that simply adds and removes IP addresses from an interface.
> > > >
> > > > If I stop the packet forwarding or the script that invalidates the
> > > > cache, then I don't see any '*' answers to my route get requests.
> > >
> > > Thanks for the reply and analysis Ido, I tested with an additional sc=
ript which
> > > adds and deletes a route in a loop, as you also saw this increased th=
e
> > > frequency of blackhole route replies from the first script.
> > >
> > > Questions:
> > >
> > > 1. We saw this behavior occurring with TCP connections traversing our=
 routers,
> > > though I was able to reproduce it with only local route requests on o=
ur router.
> > > Would you expect this same behavior for TCP traffic only in the kerne=
l which
> > > does not go to userspace?
> >
> > Yes, the problem is in the input path where received packets need to be
> > forwarded.
> >
> > >
> > > 2. These blackhole routes occur even though our main routing table is=
 not
> > > changing, however a separate route table managed by bird on the Linux=
 router is
> > > changing. Is this still expected behavior given that the ip-rules and=
 main
> > > route table used by these route requests are not changing?
> >
> > Yes, there is a per-netns counter that is incremented whenever cached
> > dst entries need to be invalidated. Since it is per-netns it is
> > incremented regardless of the routing table to which your insert the
> > route.
> >
> > >
> > > 3. We were previously rejecting these packets with an iptables rule w=
hich sent
> > > an ICMP prohibited message to the sender, this caused TCP connections=
 to break
> > > with a EHOSTUNREACH, should we be silently dropping these packets ins=
tead?
> > >
> > > 4. If we should just be dropping these packets, why does the kernel n=
ot drop
> > > them instead of letting them traverse the iptables rules?
> >
> > I actually believe the current behavior is a bug that needs to be fixed=
.
> > See below.
> >
> > >
> > > > BTW, the blackhole netdev was added in 5.3. I assume (didn't test) =
that
> > > > with older kernel versions you'll see 'lo' instead of '*'.
> > >
> > > Yes indeed! Thanks for solving that mystery as well, our routers are =
running
> > > 5.1, but we upgraded to 5.4-rc2 to determine whether the issue was st=
ill
> > > present in the latest kernel.
> >
> > Do you remember when you started seeing this behavior? I think it
> > started in 4.13 with commit ffe95ecf3a2e ("Merge branch
> > 'net-remove-dst-garbage-collector-logic'").
> >
> > Let me add Wei to see if/how this can be fixed.
> >
> > Wei, in case you don't have the original mail with the description of
> > the problem, it can be found here [1].
> >
> > I believe that the issue Jesse is experiencing is the following:
> >
> > <CPU A, t0> - Received packet A is forwarded and cached dst entry is
> > taken from the nexthop ('nhc->nhc_rth_input'). Calls skb_dst_set()
> >
> > <t1> - Given Jesse has busy routers ("ingesting full BGP routing tables
> > from multiple ISPs"), route is added / deleted and rt_cache_flush() is
> > called
> >
> > <CPU B, t2> - Received packet B tries to use the same cached dst entry
> > from t0, but rt_cache_valid() is no longer true and it is replaced in
> > rt_cache_route() by the newer one. This calls dst_dev_put() on the
> > original dst entry which assigns the blackhole netdev to 'dst->dev'
> >
> > <CPU A, t3> - dst_input(skb) is called on packet A and it is dropped du=
e
> > to 'dst->dev' being the blackhole netdev
> >
> > The following patch "fixes" the problem for me:
> >
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index 42221a12bdda..1c67bdb80fd5 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -1482,7 +1482,6 @@ static bool rt_cache_route(struct fib_nh_common *=
nhc, struct rtable *rt)
> >         prev =3D cmpxchg(p, orig, rt);
> >         if (prev =3D=3D orig) {
> >                 if (orig) {
> > -                       dst_dev_put(&orig->dst);
> >                         dst_release(&orig->dst);
> >                 }
> >         } else {
> >
> > But if this dst entry is cached in some inactive socket and the netdev
> > on which it took a reference needs to be unregistered, then we can
> > potentially wait forever. No?
> >
> Yes. That's exactly the reason we need to free the dev here.
> Otherwise as you described, we will see "unregister_netdevice: waiting
> for xxx to become free. Usage count =3D x" flushing the screen... Not
> fun...
>=20
>=20
> > I'm thinking that it can be fixed by making 'nhc_rth_input' per-CPU, in
> > a similar fashion to what Eric did in commit d26b3a7c4b3b ("ipv4: percp=
u
> > nh_rth_output cache").
> >
> Hmm... Yes... I would think a per-CPU input cache should work for the
> case above.
> Another idea is: instead of calling dst_dev_put() in rt_cache_route()
> to switch out the dev, we call, rt_add_uncached_list() to add this
> obsolete dst cache to the uncached list. And if the device gets
> unregistered, rt_flush_dev() takes care of all dst entries in the
> uncached list. I think that would work too.
>=20
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index dc1f510a7c81..ee618d4234ce 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -1482,7 +1482,7 @@ static bool rt_cache_route(struct fib_nh_common
> *nhc, struct rtable *rt)
>         prev =3D cmpxchg(p, orig, rt);
>         if (prev =3D=3D orig) {
>                 if (orig) {
> -                       dst_dev_put(&orig->dst);
> +                       rt_add_uncached_list(orig);
>                         dst_release(&orig->dst);
>                 }
>         } else {
>=20
> + Martin for his idea and input.
The above fix should work and a simple one liner for net.
percpu may be a too big hammer for bug fix.
It is only needed for input route?  A comment would be nice.

While reading around, I am puzzling why a rt has to be recreated
for the same route.  I could be missing something.

I don't recall that is happening to ipv6 route even that tree-branch's
fn_sernum has changed. =20

It seems v4 sk has not stored the last lookup rt_genid.
e.g. __sk_dst_check(sk, 0).  Everyone is sharing the rt->rt_genid
to check for changes, so the rt must be re-created?

>=20
> > Two questions:
> >
> > 1. Do you agree with the above analysis?
> > 2. Do you have a simpler/better solution in mind?
> >
> > Thanks
> >
> > [1] https://lore.kernel.org/netdev/CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXq=
f3A1eZHBa7z3=3Dyg@mail.gmail.com/T/#medece9445d617372b4842d44525ef0d3ba1ea0=
83
