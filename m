Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FBC24089
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 20:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfETSjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 14:39:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42826 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbfETSjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 14:39:16 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4KIce4Q021577;
        Mon, 20 May 2019 11:38:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=oZ3fVEKqpuPhuxmEgEzNPu+AVyEFBTQIfo5wV6mamb8=;
 b=jS2zxUUL50KlMEn4yPJzrCJV+rlnc71MoGcYxhN+zvMA4tN+ZGKSkFSEq+UVpBmERO4R
 oFSV0fMO5BMg1kkSvOk2WTU0WEIkr0mannSTbHtpebrEZmEZ3Xfyw6nT7V1Qs72/ku/c
 CxlNJLNxcmUTHHh0/cNDBpJ2JV56HXNWU0c= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sktpm9hxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 May 2019 11:38:53 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 20 May 2019 11:38:52 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 20 May 2019 11:38:52 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 20 May 2019 11:38:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZ3fVEKqpuPhuxmEgEzNPu+AVyEFBTQIfo5wV6mamb8=;
 b=hRs2d0sVIIW6adbBMQpFTfhjAueCs+FUDfzJI79IbTu3UPM7GtQ/fOJ30ShfsJOZgniioJE5IC5fpifuhJI9Q7/oUTAz2hDhOsnLaHuyNVbdfwpY92E6LoN5uioe87HOF5yngwDLausLHssKUlTVLXQnVwNm/VESof+ZlVRkKkk=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1661.namprd15.prod.outlook.com (10.175.140.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Mon, 20 May 2019 18:38:49 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29%7]) with mapi id 15.20.1878.024; Mon, 20 May 2019
 18:38:49 +0000
From:   Martin Lau <kafai@fb.com>
To:     Joe Stringer <joe@isovalent.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf] bpf: Check sk_fullsock() before returning from
 bpf_sk_lookup()
Thread-Topic: [PATCH bpf] bpf: Check sk_fullsock() before returning from
 bpf_sk_lookup()
Thread-Index: AQHVDPaOeeOfSvW6REiskICtB640KaZv24YAgAACyICAAVmeAIAAB20AgABx2ACAAAQSAIACp1CA
Date:   Mon, 20 May 2019 18:38:49 +0000
Message-ID: <20190520183843.ixn3r6hbhdkqcthu@kafai-mbp>
References: <20190517212117.2792415-1-kafai@fb.com>
 <6dc01cb7-cdd4-8a71-b602-0052b7aadfb7@gmail.com>
 <20190517220145.pkpkt7f5b72vvfyk@kafai-mbp>
 <CADa=RyxisbcVeXL7yq6o02XOgWd87QCzq-6zDXRnm9RoD2WM=A@mail.gmail.com>
 <20190518190520.53mrvat4c4y6cnbf@kafai-mbp>
 <CADa=RyxfhK+XhAwf_C_an=+RnsQCPCXV23Qrwk-3OC1oLdHM=A@mail.gmail.com>
 <20190519020703.nbioindo5krpgupi@kafai-mbp>
In-Reply-To: <20190519020703.nbioindo5krpgupi@kafai-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR03CA0056.namprd03.prod.outlook.com
 (2603:10b6:301:3b::45) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:2cce]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e28cf62-3916-497f-37e3-08d6dd526633
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1661;
x-ms-traffictypediagnostic: MWHPR15MB1661:
x-microsoft-antispam-prvs: <MWHPR15MB166102E63EC6AC432A49B915D5060@MWHPR15MB1661.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 004395A01C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(396003)(39860400002)(346002)(376002)(136003)(366004)(189003)(199004)(73956011)(6436002)(66946007)(5660300002)(9686003)(6512007)(54906003)(66476007)(66446008)(64756008)(66556008)(316002)(53936002)(71190400001)(33716001)(71200400001)(6116002)(478600001)(2906002)(8676002)(7736002)(305945005)(8936002)(81156014)(81166006)(1076003)(4326008)(14454004)(11346002)(52116002)(76176011)(476003)(446003)(6916009)(186003)(53546011)(102836004)(256004)(46003)(386003)(6506007)(86362001)(68736007)(25786009)(229853002)(14444005)(6246003)(6486002)(486006)(99286004)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1661;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9xabop5DAMZ/KOHRFZ5QY7S13r/igJ7le/jV8OCk80wQ0QTcer3RmQXrXh+awySeH3o1iCYUiSFMblN1ll/8XgByd5xpT+rxRXXPBwB5HYtH7SAfwyPqMVUrDHwGuhNHja27dPJO0wywpibNVT+iXHQusRFw7z4pisDVJQerikLPWX8zwhi/hCnoAeLTVCIJUqUxKIDmZXzovDxmIvcU9clrnr9wzNdiWzJ0jLBMzS/bX6G0budGpVa7OrvMn1LFnd93GCn5VIkvc2dD3XxDZ2kkNrILZveKdhiVARMptxRshz/VXMMxMkN6ssPF3z8pMIOwDESokyo6HnFf9mZafNRG/48P0SGVNnFzfHG9jVa9+MflffUlRWcHTY2k5wiq1dbikiROWQAm2OYWFtZmTIA1kRV94ldflX2LX9bmRLg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EABEAF1779812D4BA8CA60CCE0295648@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e28cf62-3916-497f-37e3-08d6dd526633
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2019 18:38:49.6497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1661
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-20_07:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 18, 2019 at 07:07:29PM -0700, Martin Lau wrote:
> On Sat, May 18, 2019 at 06:52:48PM -0700, Joe Stringer wrote:
> > On Sat, May 18, 2019, 09:05 Martin Lau <kafai@fb.com> wrote:
> > >
> > > On Sat, May 18, 2019 at 08:38:46AM -1000, Joe Stringer wrote:
> > > > On Fri, May 17, 2019, 12:02 Martin Lau <kafai@fb.com> wrote:
> > > >
> > > > > On Fri, May 17, 2019 at 02:51:48PM -0700, Eric Dumazet wrote:
> > > > > >
> > > > > >
> > > > > > On 5/17/19 2:21 PM, Martin KaFai Lau wrote:
> > > > > > > The BPF_FUNC_sk_lookup_xxx helpers return RET_PTR_TO_SOCKET_O=
R_NULL.
> > > > > > > Meaning a fullsock ptr and its fullsock's fields in bpf_sock =
can be
> > > > > > > accessed, e.g. type, protocol, mark and priority.
> > > > > > > Some new helper, like bpf_sk_storage_get(), also expects
> > > > > > > ARG_PTR_TO_SOCKET is a fullsock.
> > > > > > >
> > > > > > > bpf_sk_lookup() currently calls sk_to_full_sk() before return=
ing.
> > > > > > > However, the ptr returned from sk_to_full_sk() is not guarant=
eed
> > > > > > > to be a fullsock.  For example, it cannot get a fullsock if s=
k
> > > > > > > is in TCP_TIME_WAIT.
> > > > > > >
> > > > > > > This patch checks for sk_fullsock() before returning. If it i=
s not
> > > > > > > a fullsock, sock_gen_put() is called if needed and then retur=
ns NULL.
> > > > > > >
> > > > > > > Fixes: 6acc9b432e67 ("bpf: Add helper to retrieve socket in B=
PF")
> > > > > > > Cc: Joe Stringer <joe@isovalent.com>
> > > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > > ---
> > > > > > >  net/core/filter.c | 16 ++++++++++++++--
> > > > > > >  1 file changed, 14 insertions(+), 2 deletions(-)
> > > > > > >
> > > > > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > > > > index 55bfc941d17a..85def5a20aaf 100644
> > > > > > > --- a/net/core/filter.c
> > > > > > > +++ b/net/core/filter.c
> > > > > > > @@ -5337,8 +5337,14 @@ __bpf_sk_lookup(struct sk_buff *skb, s=
truct
> > > > > bpf_sock_tuple *tuple, u32 len,
> > > > > > >     struct sock *sk =3D __bpf_skc_lookup(skb, tuple, len, cal=
ler_net,
> > > > > > >                                        ifindex, proto, netns_=
id,
> > > > > flags);
> > > > > > >
> > > > > > > -   if (sk)
> > > > > > > +   if (sk) {
> > > > > > >             sk =3D sk_to_full_sk(sk);
> > > > > > > +           if (!sk_fullsock(sk)) {
> > > > > > > +                   if (!sock_flag(sk, SOCK_RCU_FREE))
> > > > > > > +                           sock_gen_put(sk);
> > > > > >
> > > > > > This looks a bit convoluted/weird.
> > > > > >
> > > > > > What about telling/asking __bpf_skc_lookup() to not return a no=
n
> > > > > fullsock instead ?
> > > > > It is becausee some other helpers, like BPF_FUNC_skc_lookup_tcp,
> > > > > can return non fullsock
> > > > >
> > > >
> > > > FYI this is necessary for finding a transparently proxied socket fo=
r a
> > > > non-local connection (tproxy use case).
> > > You meant it is necessary to return a non fullsock from the
> > > BPF_FUNC_sk_lookup_xxx helpers?
> >=20
> > Yes, that's what I want to associate with the skb so that the delivery
> > to the SO_TRANSPARENT is received properly.
> >=20
> > For the first packet of a connection, we look up the socket using the
> > tproxy socket port as the destination, and deliver the packet there.
> > The SO_TRANSPARENT logic then kicks in and sends back the ack and
> > creates the non-full sock for the connection tuple, which can be
> > entirely unrelated to local addresses or ports.
> >=20
> > For the second forward-direction packet, (ie ACK in 3-way handshake)
> > then we must deliver the packet to this non-full sock as that's what
> > is negotiating the proxied connection. If you look up using the packet
> > tuple then get the full sock from it, it will go back to the
> > SO_TRANSPARENT parent socket. Delivering the ACK there will result in
> > a RST being sent back, because the SO_TRANSPARENT socket is just there
> > to accept new connections for connections to be proxied. So this is
> > the case where I need the non-full sock.
> >=20
> > (In practice, the lookup logic attempts the packet tuple first then if
> > that fails, uses the tproxy port for lookup to achieve the above).
> hmm...I am likely missing something.
>=20
> 1) The above can be done by the "BPF_FUNC_skC_lookup_tcp" which
>    returns a non fullsock (RET_PTR_TO_SOCK_COMMON_OR_NULL), no?
>=20
> 2) The bpf_func_proto of "BPF_FUNC_sk_lookup_tcp" returns
>    fullsock (RET_PTR_TO_SOCKET_OR_NULL) and the bpf_prog (and
>    the verifier) is expecting that.  How to address the bug here?
Joe, do you have other concerns on this bug fix?
