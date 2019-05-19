Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 898B5225B4
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 04:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbfESCII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 22:08:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54400 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727870AbfESCIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 22:08:07 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4J24O0g025056;
        Sat, 18 May 2019 19:07:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rn2bZMXzJ+06QhhTH9YcliDdyYjTlGVnXYb5cWioDZs=;
 b=loWI4lUJN4eYnYPLzHW32WEJvtV7PpDkwas6UFBEyd9l87BJPCYdlY5xWDo2nzrtxC8r
 rdBZ0OF+CWXTnwfrMvfVak1OV0BNor7F2SMEEwK51p6PfNoJJAq+up1OmnS0GsHmERBc
 FAaqYrw2LjIodTQ5/D9v7z4TUeUug/9oOL8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sjfsehhd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 18 May 2019 19:07:46 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 18 May 2019 19:07:45 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 18 May 2019 19:07:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rn2bZMXzJ+06QhhTH9YcliDdyYjTlGVnXYb5cWioDZs=;
 b=rfZk5kuyoYzc66L08PZOrmkzBOcllcGLkj4jKriwhl8AXTfKJDJMrn6CBA4329+bxbT2G9Cvyv7ITdDgTiBoTx/ivasD3XwM8wC6AUvsOKJLdZykLqj3bzLsuhuRV/DvDgWx7pqunoyu0Av05u8DvLjGHk7CONaGwqwQSJutU1Y=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1389.namprd15.prod.outlook.com (10.173.234.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Sun, 19 May 2019 02:07:29 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29%7]) with mapi id 15.20.1878.024; Sun, 19 May 2019
 02:07:29 +0000
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
Thread-Index: AQHVDPaOeeOfSvW6REiskICtB640KaZv24YAgAACyICAAVmeAIAAB20AgABx2ACAAAQSAA==
Date:   Sun, 19 May 2019 02:07:29 +0000
Message-ID: <20190519020703.nbioindo5krpgupi@kafai-mbp>
References: <20190517212117.2792415-1-kafai@fb.com>
 <6dc01cb7-cdd4-8a71-b602-0052b7aadfb7@gmail.com>
 <20190517220145.pkpkt7f5b72vvfyk@kafai-mbp>
 <CADa=RyxisbcVeXL7yq6o02XOgWd87QCzq-6zDXRnm9RoD2WM=A@mail.gmail.com>
 <20190518190520.53mrvat4c4y6cnbf@kafai-mbp>
 <CADa=RyxfhK+XhAwf_C_an=+RnsQCPCXV23Qrwk-3OC1oLdHM=A@mail.gmail.com>
In-Reply-To: <CADa=RyxfhK+XhAwf_C_an=+RnsQCPCXV23Qrwk-3OC1oLdHM=A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0029.namprd02.prod.outlook.com
 (2603:10b6:301:60::18) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::23c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff319b1b-9db9-4164-c9cf-08d6dbfebecb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1389;
x-ms-traffictypediagnostic: MWHPR15MB1389:
x-microsoft-antispam-prvs: <MWHPR15MB13895B4FE3AFFE19CDB3FF4FD5050@MWHPR15MB1389.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00429279BA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(136003)(376002)(396003)(346002)(366004)(39860400002)(199004)(189003)(25786009)(476003)(229853002)(316002)(386003)(33716001)(6486002)(53546011)(68736007)(66476007)(5660300002)(73956011)(66946007)(6246003)(1076003)(102836004)(86362001)(53936002)(186003)(4326008)(6506007)(66446008)(64756008)(66556008)(52116002)(9686003)(256004)(71190400001)(486006)(8936002)(99286004)(81166006)(71200400001)(14454004)(54906003)(8676002)(81156014)(446003)(478600001)(2906002)(76176011)(6116002)(305945005)(7736002)(14444005)(6436002)(6512007)(11346002)(6916009)(46003)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1389;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZD5diGABOzEksLpXzm04WddNDP+E3pnW4Ro1mGlxDIjlRsblujgt3zpxsy09srmuzJfShXHhP1zbS76q6EgH/pWL8Iczk8MsmFYzG7u9cSUwOr4R5EQW0RTo/MQCgGYJThpwXOrTPHDZvWWwJwAex1FHJGLaTKs8rnju0G67xFlnzoMu0o1YeZDpJtqg45ihSmNH0zCK7z1I+UHem6fZ7e+7sfemgMKApTib753qo1LOGiSM3qyyt0N210Oeuo0jzqTDJZHm+pByYYYeVZ2rtaZKemQoOZb2BxfSYTGI4gMu0IBpmMu8N8mf3HC2cg7i//Y4oZKUfOauPg7wtq2Hv7+ObBa4t1rijjtmJ447l+12eVGlNKoaJUWBjxvYhwKFdhmEPG60BLyi4K6YBqclZV6tNcX9frybns8I2dfuvhs=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <891463BB82CEAD4EB367388DD06656D2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ff319b1b-9db9-4164-c9cf-08d6dbfebecb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2019 02:07:29.3590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1389
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-19_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905190013
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 18, 2019 at 06:52:48PM -0700, Joe Stringer wrote:
> On Sat, May 18, 2019, 09:05 Martin Lau <kafai@fb.com> wrote:
> >
> > On Sat, May 18, 2019 at 08:38:46AM -1000, Joe Stringer wrote:
> > > On Fri, May 17, 2019, 12:02 Martin Lau <kafai@fb.com> wrote:
> > >
> > > > On Fri, May 17, 2019 at 02:51:48PM -0700, Eric Dumazet wrote:
> > > > >
> > > > >
> > > > > On 5/17/19 2:21 PM, Martin KaFai Lau wrote:
> > > > > > The BPF_FUNC_sk_lookup_xxx helpers return RET_PTR_TO_SOCKET_OR_=
NULL.
> > > > > > Meaning a fullsock ptr and its fullsock's fields in bpf_sock ca=
n be
> > > > > > accessed, e.g. type, protocol, mark and priority.
> > > > > > Some new helper, like bpf_sk_storage_get(), also expects
> > > > > > ARG_PTR_TO_SOCKET is a fullsock.
> > > > > >
> > > > > > bpf_sk_lookup() currently calls sk_to_full_sk() before returnin=
g.
> > > > > > However, the ptr returned from sk_to_full_sk() is not guarantee=
d
> > > > > > to be a fullsock.  For example, it cannot get a fullsock if sk
> > > > > > is in TCP_TIME_WAIT.
> > > > > >
> > > > > > This patch checks for sk_fullsock() before returning. If it is =
not
> > > > > > a fullsock, sock_gen_put() is called if needed and then returns=
 NULL.
> > > > > >
> > > > > > Fixes: 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF=
")
> > > > > > Cc: Joe Stringer <joe@isovalent.com>
> > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > ---
> > > > > >  net/core/filter.c | 16 ++++++++++++++--
> > > > > >  1 file changed, 14 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > > > index 55bfc941d17a..85def5a20aaf 100644
> > > > > > --- a/net/core/filter.c
> > > > > > +++ b/net/core/filter.c
> > > > > > @@ -5337,8 +5337,14 @@ __bpf_sk_lookup(struct sk_buff *skb, str=
uct
> > > > bpf_sock_tuple *tuple, u32 len,
> > > > > >     struct sock *sk =3D __bpf_skc_lookup(skb, tuple, len, calle=
r_net,
> > > > > >                                        ifindex, proto, netns_id=
,
> > > > flags);
> > > > > >
> > > > > > -   if (sk)
> > > > > > +   if (sk) {
> > > > > >             sk =3D sk_to_full_sk(sk);
> > > > > > +           if (!sk_fullsock(sk)) {
> > > > > > +                   if (!sock_flag(sk, SOCK_RCU_FREE))
> > > > > > +                           sock_gen_put(sk);
> > > > >
> > > > > This looks a bit convoluted/weird.
> > > > >
> > > > > What about telling/asking __bpf_skc_lookup() to not return a non
> > > > fullsock instead ?
> > > > It is becausee some other helpers, like BPF_FUNC_skc_lookup_tcp,
> > > > can return non fullsock
> > > >
> > >
> > > FYI this is necessary for finding a transparently proxied socket for =
a
> > > non-local connection (tproxy use case).
> > You meant it is necessary to return a non fullsock from the
> > BPF_FUNC_sk_lookup_xxx helpers?
>=20
> Yes, that's what I want to associate with the skb so that the delivery
> to the SO_TRANSPARENT is received properly.
>=20
> For the first packet of a connection, we look up the socket using the
> tproxy socket port as the destination, and deliver the packet there.
> The SO_TRANSPARENT logic then kicks in and sends back the ack and
> creates the non-full sock for the connection tuple, which can be
> entirely unrelated to local addresses or ports.
>=20
> For the second forward-direction packet, (ie ACK in 3-way handshake)
> then we must deliver the packet to this non-full sock as that's what
> is negotiating the proxied connection. If you look up using the packet
> tuple then get the full sock from it, it will go back to the
> SO_TRANSPARENT parent socket. Delivering the ACK there will result in
> a RST being sent back, because the SO_TRANSPARENT socket is just there
> to accept new connections for connections to be proxied. So this is
> the case where I need the non-full sock.
>=20
> (In practice, the lookup logic attempts the packet tuple first then if
> that fails, uses the tproxy port for lookup to achieve the above).
hmm...I am likely missing something.

1) The above can be done by the "BPF_FUNC_skC_lookup_tcp" which
   returns a non fullsock (RET_PTR_TO_SOCK_COMMON_OR_NULL), no?

2) The bpf_func_proto of "BPF_FUNC_sk_lookup_tcp" returns
   fullsock (RET_PTR_TO_SOCKET_OR_NULL) and the bpf_prog (and
   the verifier) is expecting that.  How to address the bug here?
