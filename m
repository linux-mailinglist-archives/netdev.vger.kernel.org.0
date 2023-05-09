Return-Path: <netdev+bounces-1148-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB1566FC561
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:51:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E9C0281254
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA51617ADA;
	Tue,  9 May 2023 11:51:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFC2DDCD
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:51:03 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2138440E0;
	Tue,  9 May 2023 04:51:02 -0700 (PDT)
Received: from canpemm100009.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QFxG204rgzpV7y;
	Tue,  9 May 2023 19:46:50 +0800 (CST)
Received: from kwepemi500026.china.huawei.com (7.221.188.247) by
 canpemm100009.china.huawei.com (7.192.105.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 19:51:00 +0800
Received: from kwepemi500026.china.huawei.com ([7.221.188.247]) by
 kwepemi500026.china.huawei.com ([7.221.188.247]) with mapi id 15.01.2507.023;
 Tue, 9 May 2023 19:50:59 +0800
From: "dongchenchen (A)" <dongchenchen2@huawei.com>
To: "simon.horman@corigine.com" <simon.horman@corigine.com>
CC: David Miller <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "jbenc@redhat.com" <jbenc@redhat.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "weiyongjun (A)"
	<weiyongjun1@huawei.com>, yuehaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH next, v2] net: nsh: Use correct mac_offset to unwind gso
 skb in nsh_gso_segment()
Thread-Topic: Re: [PATCH next, v2] net: nsh: Use correct mac_offset to unwind
 gso skb in nsh_gso_segment()
Thread-Index: AdmCa6/13xAu81DfR1qLOi3J8tOZMQ==
Date: Tue, 9 May 2023 11:50:59 +0000
Message-ID: <772b50e4ecb24da98ae917b650891d8d@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.174.177.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > As the call trace shows, skb_panic was caused by wrong=20
> > skb->mac_header in nsh_gso_segment():
> >=20
> > invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
> > CPU: 3 PID: 2737 Comm: syz Not tainted 6.3.0-next-20230505 #1
> > RIP: 0010:skb_panic+0xda/0xe0
> > call Trace:
> >  skb_push+0x91/0xa0
> >  nsh_gso_segment+0x4f3/0x570
> >  skb_mac_gso_segment+0x19e/0x270
> >  __skb_gso_segment+0x1e8/0x3c0
> >  validate_xmit_skb+0x452/0x890
> >  validate_xmit_skb_list+0x99/0xd0
> >  sch_direct_xmit+0x294/0x7c0
> >  __dev_queue_xmit+0x16f0/0x1d70
> >  packet_xmit+0x185/0x210
> >  packet_snd+0xc15/0x1170
> >  packet_sendmsg+0x7b/0xa0
> >  sock_sendmsg+0x14f/0x160
> >=20
> > The root cause is:
> > nsh_gso_segment() use skb->network_header - nhoff to reset=20
> > mac_header in skb_gso_error_unwind() if inner-layer protocol gso fails.
> > However, skb->network_header may be reset by inner-layer protocol=20
> > gso function e.g. mpls_gso_segment. skb->mac_header reset by the=20
> > inaccurate network_header will be larger than skb headroom.
> >=20
> > nsh_gso_segment
> >     nhoff =3D skb->network_header - skb->mac_header;
> >     __skb_pull(skb,nsh_len)
> >     skb_mac_gso_segment
> >         mpls_gso_segment
> >             skb_reset_network_header(skb);//skb->network_header+=3Dnsh_=
len
> >             return -EINVAL;
> >     skb_gso_error_unwind
> >         skb_push(skb, nsh_len);
> >         skb->mac_header =3D skb->network_header - nhoff;
> >         // skb->mac_header > skb->headroom, cause skb_push panic
> >=20
> > Use correct mac_offset to restore mac_header to fix it.
> >=20
> > Fixes: c411ed854584 ("nsh: add GSO support")
> > Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
>=20
> nit: As this is a fix it should probably be targeted at 'net'
>      (as opposed to 'net-next'). This should be noted in the subject.
>=20
>      Subject: [PATCH net v2]...
>=20
> > ---
> > v2:
> >   - Use skb->mac_header not skb->network_header-nhoff for mac_offset.
> > ---
> >  net/nsh/nsh.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/net/nsh/nsh.c b/net/nsh/nsh.c index=20
> > e9ca007718b7..7eb536a9677f 100644
> > --- a/net/nsh/nsh.c
> > +++ b/net/nsh/nsh.c
> > @@ -78,6 +78,7 @@ static struct sk_buff *nsh_gso_segment(struct=20
> > sk_buff *skb,  {
> >  	struct sk_buff *segs =3D ERR_PTR(-EINVAL);
> >  	unsigned int nsh_len, mac_len;
> > +	u16 mac_offset =3D skb->mac_header;
>=20
> nit: It is generally preferred to arrange local variable in networking co=
de
>      from shortest line to longest - reverse xmas tree order.
>=20
>      This can be verified using.
>      https://github.com/ecree-solarflare/xmastree/blob/master/README
>=20
Thank you very much for your suggestions!
v3 will be sent.

Dong Chenchen
> >  	__be16 proto;
> >  	int nhoff;
> > =20
> > @@ -108,8 +109,7 @@ static struct sk_buff *nsh_gso_segment(struct sk_bu=
ff *skb,
> >  	segs =3D skb_mac_gso_segment(skb, features);
> >  	if (IS_ERR_OR_NULL(segs)) {
> >  		skb_gso_error_unwind(skb, htons(ETH_P_NSH), nsh_len,
> > -				     skb->network_header - nhoff,
> > -				     mac_len);
> > +				     mac_offset, mac_len);
> >  		goto out;
> >  	}
> > =20
> > --
> > 2.25.1
> >=20
> >

