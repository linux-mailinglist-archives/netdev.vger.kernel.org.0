Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B527C2248E
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 21:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbfERTFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 15:05:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37136 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728088AbfERTFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 15:05:50 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4IJ3rxA024214;
        Sat, 18 May 2019 12:05:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=5MpBUY+R49QGVVhsMrB5jvmm+YABkW8VZbDVp4wml9w=;
 b=eJ7SVU9199qV9tlLjeRHD9YN2YkNYLCyFhJMZfnAwCbCiAAzIOuYXhcx+EFf+K81z1ip
 0nbsYhXXRmT2bq2kEUESLTXjcimFGLk7AU+8lfnOsBkPZ8FrXR+XfkqdYBpwq8wc9ox/
 tOKUaopjBLEKMUybqlEvo/mhO8HsAvH6Z+8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sjdbps80j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 18 May 2019 12:05:27 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 18 May 2019 12:05:26 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 18 May 2019 12:05:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MpBUY+R49QGVVhsMrB5jvmm+YABkW8VZbDVp4wml9w=;
 b=ikbbCCn1cpHQ9LiTbFHXsGzsDhuu53VA5yVjIhUF5WjB+6fZ+iuzU5fVaLOvAoqQgA+tieELYEg0LgG8XKLTpwsDVz20GPCDuKEoQTTZQNmJuZt4BRuFCIL8O+mMdV1DzdcOjYUpWIqnT0xL7Q8SvTjEI8f/iDtAbvoutedP7s4=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1807.namprd15.prod.outlook.com (10.174.255.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Sat, 18 May 2019 19:05:24 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29%7]) with mapi id 15.20.1878.024; Sat, 18 May 2019
 19:05:24 +0000
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
Thread-Index: AQHVDPaOeeOfSvW6REiskICtB640KaZv24YAgAACyICAAVmeAIAAB20A
Date:   Sat, 18 May 2019 19:05:24 +0000
Message-ID: <20190518190520.53mrvat4c4y6cnbf@kafai-mbp>
References: <20190517212117.2792415-1-kafai@fb.com>
 <6dc01cb7-cdd4-8a71-b602-0052b7aadfb7@gmail.com>
 <20190517220145.pkpkt7f5b72vvfyk@kafai-mbp>
 <CADa=RyxisbcVeXL7yq6o02XOgWd87QCzq-6zDXRnm9RoD2WM=A@mail.gmail.com>
In-Reply-To: <CADa=RyxisbcVeXL7yq6o02XOgWd87QCzq-6zDXRnm9RoD2WM=A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:a03:40::20) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::9b5e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa36a721-f067-4e33-cb0c-08d6dbc3c7d5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1807;
x-ms-traffictypediagnostic: MWHPR15MB1807:
x-microsoft-antispam-prvs: <MWHPR15MB1807C8C2D34912F93F3BF8D9D5040@MWHPR15MB1807.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0041D46242
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(346002)(136003)(39860400002)(376002)(396003)(366004)(199004)(189003)(11346002)(8936002)(54906003)(81166006)(7736002)(5660300002)(8676002)(305945005)(6916009)(99286004)(476003)(486006)(6246003)(81156014)(446003)(256004)(71190400001)(71200400001)(14444005)(86362001)(229853002)(316002)(68736007)(14454004)(6116002)(52116002)(2906002)(6486002)(66946007)(102836004)(46003)(1076003)(386003)(53936002)(6436002)(478600001)(53546011)(186003)(33716001)(9686003)(73956011)(6512007)(6506007)(25786009)(66476007)(66556008)(64756008)(4326008)(66446008)(76176011)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1807;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: U3Ar5z9bGWs4N5cN8ru5TDcMfES1iclPc4Yy4/HheuJHna85E/xmyY3B959btV7k7Uhmw5Kg69yMGpWTOGFTlivK/hej1h7NsL3wj1bnet+ubHot4ZREf6vO+cdwGuvMezQIjj6AN1VD44/MRUWibibaIdBCw0tk5ga+aySLbMYg950YQVppRhP/F1woRtjukqUBnAgqQQBcta73+04vJ/awrQ0MpwNZEni0fKNs9lzUcv9hZaoMY+GFjTwUoLVB/8ATfFf5bM8IiFZAS5hy0/BzKMNuT41Lel/Eb29itIvd3KvwxMmLpVCF99W5scCRVpfJEHCsHSu0M1RZWVNspxnoHyOEMvMtsBmq+vwS4XNqddpPps+9Vd0nUjUIq3GIMRFTZfVt9e/1XhTp50k9KlNp4M1kC+1FmWgTBoJgdFY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CF1E0EFF791FF5489B7D8616243C055E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: aa36a721-f067-4e33-cb0c-08d6dbc3c7d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2019 19:05:24.2410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1807
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-18_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=835 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905180138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 18, 2019 at 08:38:46AM -1000, Joe Stringer wrote:
> On Fri, May 17, 2019, 12:02 Martin Lau <kafai@fb.com> wrote:
>=20
> > On Fri, May 17, 2019 at 02:51:48PM -0700, Eric Dumazet wrote:
> > >
> > >
> > > On 5/17/19 2:21 PM, Martin KaFai Lau wrote:
> > > > The BPF_FUNC_sk_lookup_xxx helpers return RET_PTR_TO_SOCKET_OR_NULL=
.
> > > > Meaning a fullsock ptr and its fullsock's fields in bpf_sock can be
> > > > accessed, e.g. type, protocol, mark and priority.
> > > > Some new helper, like bpf_sk_storage_get(), also expects
> > > > ARG_PTR_TO_SOCKET is a fullsock.
> > > >
> > > > bpf_sk_lookup() currently calls sk_to_full_sk() before returning.
> > > > However, the ptr returned from sk_to_full_sk() is not guaranteed
> > > > to be a fullsock.  For example, it cannot get a fullsock if sk
> > > > is in TCP_TIME_WAIT.
> > > >
> > > > This patch checks for sk_fullsock() before returning. If it is not
> > > > a fullsock, sock_gen_put() is called if needed and then returns NUL=
L.
> > > >
> > > > Fixes: 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
> > > > Cc: Joe Stringer <joe@isovalent.com>
> > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > ---
> > > >  net/core/filter.c | 16 ++++++++++++++--
> > > >  1 file changed, 14 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > index 55bfc941d17a..85def5a20aaf 100644
> > > > --- a/net/core/filter.c
> > > > +++ b/net/core/filter.c
> > > > @@ -5337,8 +5337,14 @@ __bpf_sk_lookup(struct sk_buff *skb, struct
> > bpf_sock_tuple *tuple, u32 len,
> > > >     struct sock *sk =3D __bpf_skc_lookup(skb, tuple, len, caller_ne=
t,
> > > >                                        ifindex, proto, netns_id,
> > flags);
> > > >
> > > > -   if (sk)
> > > > +   if (sk) {
> > > >             sk =3D sk_to_full_sk(sk);
> > > > +           if (!sk_fullsock(sk)) {
> > > > +                   if (!sock_flag(sk, SOCK_RCU_FREE))
> > > > +                           sock_gen_put(sk);
> > >
> > > This looks a bit convoluted/weird.
> > >
> > > What about telling/asking __bpf_skc_lookup() to not return a non
> > fullsock instead ?
> > It is becausee some other helpers, like BPF_FUNC_skc_lookup_tcp,
> > can return non fullsock
> >
>=20
> FYI this is necessary for finding a transparently proxied socket for a
> non-local connection (tproxy use case).
You meant it is necessary to return a non fullsock from the
BPF_FUNC_sk_lookup_xxx helpers?

>=20
>=20
> > >
> > > > +                   return NULL;
> > > > +           }
> > > > +   }
> > > >
> > > >     return sk;
> > > >  }
> > > > @@ -5369,8 +5375,14 @@ bpf_sk_lookup(struct sk_buff *skb, struct
> > bpf_sock_tuple *tuple, u32 len,
> > > >     struct sock *sk =3D bpf_skc_lookup(skb, tuple, len, proto, netn=
s_id,
> > > >                                      flags);
> > > >
> > > > -   if (sk)
> > > > +   if (sk) {
> > > >             sk =3D sk_to_full_sk(sk);
> > > > +           if (!sk_fullsock(sk)) {
> > > > +                   if (!sock_flag(sk, SOCK_RCU_FREE))
> > > > +                           sock_gen_put(sk);
> > > > +                   return NULL;
> > > > +           }
> > > > +   }
> > > >
> > > >     return sk;
> > > >  }
> > > >
> >
