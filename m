Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7D1E7B77
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731493AbfJ1ViR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:38:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36082 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728338AbfJ1ViR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 17:38:17 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9SLYe0b030551;
        Mon, 28 Oct 2019 14:38:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rFndJV6VyNdDSEpfSusTPqgww3TVUVKgq7KQZznIxCo=;
 b=O4vGQXy7ebXQjF4XsgprhrMpZJ8hEudm9T3lZMBv+8a4Lx0Z/hzn0Vdoh2brgW1PNRI9
 nPMAAJQaxmCWBSf9uHD5crc8VmGu0MVFK1U5FD9vW9CA9jLlyR2eY881zhbBpf0LT4vC
 bK/fz1rLbhDxENtusNKBAxZejjWqBlqGX2c= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vvkvq2vf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Oct 2019 14:38:14 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 28 Oct 2019 14:38:13 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 28 Oct 2019 14:38:12 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 28 Oct 2019 14:38:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FapPofDPbbKHk5scvrObHm9JmI06fbXY3S7f4ZTvN/+pMgKGDolEzlPT59hzZ5Qr7mzdD9kXkw7uTzRsHXKw3h5veUETDyInM1qW6gHfME5x185ogxdvx93fKXfcsN1DxVAI8fhk27uuFu1PTiYD5Q/r7yKD5ZAZ7sPO6fZYZmMtkcRq+gFLoMaIXrjpYy7kkqk+vXQqaWQK5tdPGYpUXXYjm25Rhihy8QRG24Az0Oc4xCMZckQwfbFduKJksU0XHI/bc8EH13WG5Dv1pB43qhHEnALqk0XuwDQoFa5cCyUFp9kPPx4kVk3IRbdhwKFCm86vQpjxNFdsErOpLJYisw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFndJV6VyNdDSEpfSusTPqgww3TVUVKgq7KQZznIxCo=;
 b=SY9dhoVkDMkxUoCCSZhwXAuKj/W1Cl1iLmY81cwSAdRFOAHwwvGQtnwTG3c/QfAByRBFI05isiDQfnG157gEJbAW3f/YEBuUJHeEJWw4Dqwt9TNLvPfCgOChxAdrZ8IBiJ/A2OKY80TlDOEWgaIWcOaydSa96+JmEqD5Dw+R8IkLpvGgF6mnFGEymqHeH43P3WdgBb7Bgxy1wHxVS9vFzSp2QrO5AS7ZI77d5LSvwqlyzm01JKTd6nqp3gTswoV8R/BZJR+CY3QgoKUVQVKTCTFkVyMlaPk62mtnDV4qxDRvFko1nWZEBJLUAPODvLIY3LJDmVRM8OkwkScCB0bBuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFndJV6VyNdDSEpfSusTPqgww3TVUVKgq7KQZznIxCo=;
 b=UNOuJM0MAOEThRrPBVzvgv2nm5SvgC79n6y9/IOmtOi7fUrwQcEu8igu1KzKwd15KJNTiSekk58kNXZc8Vu277Ps/foJzhjJ3tfUceQOUjDGodQBiiSa/6IkD3VSMQ23xMWs1mMH4uJPzm+xP+/RE4bzRYSCNfuanNTuRrW5GOg=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3056.namprd15.prod.outlook.com (20.178.254.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 21:38:11 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2387.023; Mon, 28 Oct 2019
 21:38:11 +0000
From:   Martin Lau <kafai@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     Jakub Sitnicki <jakub@cloudflare.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>
Subject: Re: [RFC bpf-next 0/5] Extend SOCKMAP to store listening sockets
Thread-Topic: [RFC bpf-next 0/5] Extend SOCKMAP to store listening sockets
Thread-Index: AQHViM0cMelp7mfgSECOn4gRCJXJt6dvlj+AgABwfwCAAIg0gIAABkgAgAAJIQA=
Date:   Mon, 28 Oct 2019 21:38:11 +0000
Message-ID: <20191028213804.yv3xfjjlayfghkcr@kafai-mbp>
References: <20191022113730.29303-1-jakub@cloudflare.com>
 <20191028055247.bh5bctgxfvmr3zjh@kafai-mbp.dhcp.thefacebook.com>
 <875zk9oxo1.fsf@cloudflare.com>
 <20191028204255.jmkraj3xlp346xz4@kafai-mbp.dhcp.thefacebook.com>
 <5db758142fac5_6642abc699aa5c4fd@john-XPS-13-9370.notmuch>
In-Reply-To: <5db758142fac5_6642abc699aa5c4fd@john-XPS-13-9370.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR15CA0063.namprd15.prod.outlook.com
 (2603:10b6:301:4c::25) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:5bd3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc92daad-39b0-41a3-d8a4-08d75bef2160
x-ms-traffictypediagnostic: MN2PR15MB3056:
x-ms-exchange-purlcount: 4
x-microsoft-antispam-prvs: <MN2PR15MB30566AC6D9E4DB6C44023615D5660@MN2PR15MB3056.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(396003)(39860400002)(136003)(376002)(346002)(366004)(199004)(189003)(305945005)(478600001)(11346002)(7736002)(54906003)(476003)(316002)(53546011)(386003)(6916009)(6506007)(102836004)(14444005)(66476007)(5660300002)(186003)(33716001)(64756008)(66446008)(14454004)(66556008)(6512007)(99286004)(9686003)(52116002)(76176011)(6306002)(256004)(6116002)(5024004)(81156014)(71200400001)(8676002)(446003)(71190400001)(81166006)(486006)(325944009)(1076003)(229853002)(8936002)(4326008)(2906002)(86362001)(6486002)(6436002)(46003)(25786009)(966005)(66946007)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3056;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZrnOYAka+VVwONjaj6u97ZClUt45BGHquRZ+WSs668mheKjqE1Pwdu/CF9bBGNES3WTktFVNYt+Qlh3WAQrUwgNE+Xz5YJNpKc2NOCEgb/in81J0ruNEbnWmnZzvClL/GKoyRS0ohZVqB9EDpS9QQxU+ZuzPB9pDwjZXzgh7m9QJcQHo4pZ5xKptRL4kEM0iDzpm0nLEMIN82q29cGvPGiAy2jqOEO+w/Bps+U/Dylf6SEImK9NysgTwLmjB+r+Rvt+KJHsW3FACfbiMe4CsaXTFh6L+5yG3w5kIueuPRex3N5TxBVzLf+uddxxB8Jb5dlD+53zcfsN+FnRHsvdgg3am+d178wPH67TNy3LIYpoGSwdOiU4Nc81EpmDxU6koPlPdwyaFs+Ba4LLGWz29KtTw/x2HkQ769f9pUzO1C1tCGb6ni9UrmjSKQ2Ey9WOLeU7obuFxVtpGZLA+qgPiGXqueY02a8+vn2Bax/2GxCk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3288108447EB9642BFA4E97A37D472FC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fc92daad-39b0-41a3-d8a4-08d75bef2160
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 21:38:11.3189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Meks8t4fAeribiK4xxHoCHFICp8tEv4rhRSIdK6YM1TR4vXoYYdApJGBMKbMINDD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3056
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-28_07:2019-10-28,2019-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910280202
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 02:05:24PM -0700, John Fastabend wrote:
> Martin Lau wrote:
> > On Mon, Oct 28, 2019 at 01:35:26PM +0100, Jakub Sitnicki wrote:
> > > On Mon, Oct 28, 2019 at 06:52 AM CET, Martin Lau wrote:
> > > > On Tue, Oct 22, 2019 at 01:37:25PM +0200, Jakub Sitnicki wrote:
> > > >> This patch set is a follow up on a suggestion from LPC '19 discuss=
ions to
> > > >> make SOCKMAP (or a new map type derived from it) a generic type fo=
r storing
> > > >> established as well as listening sockets.
> > > >>
> > > >> We found ourselves in need of a map type that keeps references to =
listening
> > > >> sockets when working on making the socket lookup programmable, aka=
 BPF
> > > >> inet_lookup [1].  Initially we repurposed REUSEPORT_SOCKARRAY but =
found it
> > > >> problematic to extend due to being tightly coupled with reuseport
> > > >> logic (see slides [2]).
> > > >> So we've turned our attention to SOCKMAP instead.
> > > >>
> > > >> As it turns out the changes needed to make SOCKMAP suitable for st=
oring
> > > >> listening sockets are self-contained and have use outside of progr=
amming
> > > >> the socket lookup. Hence this patch set.
> > > >>
> > > >> With these patches SOCKMAP can be used in SK_REUSEPORT BPF program=
s as a
> > > >> drop-in replacement for REUSEPORT_SOCKARRAY for TCP. This can hope=
fully
> > > >> lead to code consolidation between the two map types in the future=
.
> > > > What is the plan for UDP support in sockmap?
> > >=20
> > > It's on our road-map because without SOCKMAP support for UDP we won't=
 be
> > > able to move away from TPROXY [1] and custom SO_BINDTOPREFIX extensio=
n
> > > [2] for steering new UDP flows to receiving sockets. Also we would li=
ke
> > > to look into using SOCKMAP for connected UDP socket splicing in the
> > > future [3].
> > >=20
> > > I was planning to split work as follows:
> > >=20
> > > 1. SOCKMAP support for listening sockets (this series)
> > > 2. programmable socket lookup for TCP (cut-down version of [4])
> > > 3. SOCKMAP support for UDP (work not started)
> > hmm...It is hard to comment how the full UDP sockmap may
> > work out without a code attempt because I am not fluent in
> > sock_map ;)
> >=20
> > From a quick look, it seems there are quite a few things to do.
> > For example, the TCP_SKB_CB(skb) usage and how that may look
> > like in UDP.  "struct udp_skb_cb" is 28 bytes while "struct napi_gro_cb=
"
> > seems to be 48 bytes already which may need a closer look.
>=20
> The extra bits sockmap needs are used for redirecting between
> between sockets. These will fit in the udp cb area with some
> extra room to spare. If that is paticularly challenging we can
> also create a program attach type which would preclude using
> those bits in the sk_reuseport bpf program types. We already
> have types for rx, tx, nop progs, so one more should be fine.
>=20
> So at least that paticular concern is not difficult to fix.
>=20
> >=20
> > > 4. programmable socket lookup for UDP (rest of [4])
> > >=20
> > > I'm open to suggestions on how to organize it.
> > >=20
> > > >> Having said that, the main intention here is to lay groundwork for=
 using
> > > >> SOCKMAP in the next iteration of programmable socket lookup patche=
s.
> > > > What may be the minimal to get only lookup work for UDP sockmap?
> > > > .close() and .unhash()?
> > >=20
> > > John would know better. I haven't tried doing it yet.
> > >=20
> > > From just reading the code - override the two proto ops you mentioned=
,
> > > close and unhash, and adapt the socket checks in SOCKMAP.
> > Do your use cases need bpf prog attached to sock_map?
>=20
> Perhaps not specifically sock_map but they do need to be consolidated
> into a map somewhere IMO this has proven to be the most versatile. We
> can add sockets from the various BPF hooks or from user space and have
> the ability to use the existing map tools, etc.
>=20
> >=20
> > If not, would it be cleaner to delicate another map_type
> > for lookup-only use case to have both TCP and UDP support.
>=20
> But we (Cilium project and above splicing use case is also interested)
> will need UDP support so it will be supported regardless of the
> SK_REUSEPORT_BPF so I think it makes sense to consolidate all these
> use cases on to the existing sockmap.
>=20
> Also sockmap supports inserting sockets from BPF and from userspace
> which actually requires a bit of logic to track state, etc. Its been
> in use and been beat on by various automated test tools so I think
> at minimum this needs to be reused. Re-implementing this logic seems
> a waste of time and it wasn't exactly trivial and took some work.
>=20
> Being able to insert the sockets from XDP (support coming soon) and
> from sock_ops programs turns out to be fairly powerful.
>=20
> So in short I think it makes most sense to consolidate on sock_map
> because
>=20
>   (a) we need and will add udp support regardless,

>   (b) we already handle the tricky parts inerting/removing live sockets
I didn't mean not to reuse the existing sockmap logic on tracking
socks life-time.  I was exploring options if the first step for UDP
could be lookup-only support first.

It is always better to get full UDP support ;)
It seems to be confident also, then there is little reason not to do
so in UDP sockmap support v1.

>   (c) from this series it looks like its fairly straight forward
>   (d) we get lots of shared code
>=20
> Thanks,
> John
>=20
>=20
> >=20
> > >=20
> > > -Jakub
> > >=20
> > > [1] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__blog.cloud=
flare.com_how-2Dwe-2Dbuilt-2Dspectrum_&d=3DDwIBAg&c=3D5VD0RTtNlTh3ycd41b3MU=
w&r=3DVQnoQ7LvghIj0gVEaiQSUw&m=3DlSo-FsOeNl_8znZZ07H8I6ZYAinPKTR5C3Cn_Ol3QY=
Q&s=3DDZgW8-2Xl1P8NU59ji4ieQLzwWpx4t3gGq_tqB0l3Bo&e=3D=20
> > > [2] https://lore.kernel.org/netdev/1458699966-3752-1-git-send-email-g=
ilberto.bertin@gmail.com/
> > > [3] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudfla=
re.com/
> > > [4] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__blog.cloud=
flare.com_sockmap-2Dtcp-2Dsplicing-2Dof-2Dthe-2Dfuture_&d=3DDwIBAg&c=3D5VD0=
RTtNlTh3ycd41b3MUw&r=3DVQnoQ7LvghIj0gVEaiQSUw&m=3DlSo-FsOeNl_8znZZ07H8I6ZYA=
inPKTR5C3Cn_Ol3QYQ&s=3DNerUqb4j7IsGBTcni6Yxk40wf6kTkckHXn3Nx5i4mCU&e=3D=20
>=20
>=20
