Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D77A22001
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 00:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfEQWCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 18:02:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45822 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726726AbfEQWCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 18:02:17 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4HLrSD8006699;
        Fri, 17 May 2019 15:01:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=gu3tTIo9METGyVRV6uNT6odq22kTEtiBP8AJT7ZhrpM=;
 b=K+X1Mdf7OpGUvyrd8bhoOEnWN0/fGgL7es0h48i5cR5v/8codYW5/FxuIGs3uHBpEVZW
 jJLZsaB9Vqi39ClZVDz1sJpHU1mJkOukY/+o+uXz0CNS7Lse1+qhqx8DkJYLcmQoAuIJ
 H+1UMWm3lw1SpIhnxf2ba2nbKnS3SbrT+zo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2shsqgjcgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 17 May 2019 15:01:54 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 17 May 2019 15:01:53 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 17 May 2019 15:01:53 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 17 May 2019 15:01:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gu3tTIo9METGyVRV6uNT6odq22kTEtiBP8AJT7ZhrpM=;
 b=DtwzPjA0dJXo50aEqfXz8vfDcLamkX14bVW53HGcm/R3uAt+Jr/00zHAbAUeKPSm+kLS5VOMYcECS27Rc+N38PmhxEHr6OVFmAg6gCJjLaLETvv5DIwFPrPUpBQ6+XtOQ6XsQAkWLs6FiQ+dTQ8zT3thPeQHvNfQRFn7cqglKrk=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1903.namprd15.prod.outlook.com (10.174.100.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Fri, 17 May 2019 22:01:48 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29%7]) with mapi id 15.20.1878.024; Fri, 17 May 2019
 22:01:48 +0000
From:   Martin Lau <kafai@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Joe Stringer <joe@isovalent.com>
Subject: Re: [PATCH bpf] bpf: Check sk_fullsock() before returning from
 bpf_sk_lookup()
Thread-Topic: [PATCH bpf] bpf: Check sk_fullsock() before returning from
 bpf_sk_lookup()
Thread-Index: AQHVDPaOeeOfSvW6REiskICtB640KaZv24YAgAACyIA=
Date:   Fri, 17 May 2019 22:01:47 +0000
Message-ID: <20190517220145.pkpkt7f5b72vvfyk@kafai-mbp>
References: <20190517212117.2792415-1-kafai@fb.com>
 <6dc01cb7-cdd4-8a71-b602-0052b7aadfb7@gmail.com>
In-Reply-To: <6dc01cb7-cdd4-8a71-b602-0052b7aadfb7@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0087.namprd04.prod.outlook.com
 (2603:10b6:104:6::13) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:ef70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75ce0b43-8338-42a8-b2cb-08d6db13419a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1903;
x-ms-traffictypediagnostic: MWHPR15MB1903:
x-microsoft-antispam-prvs: <MWHPR15MB19035B99B44F4D6332BCE7A8D50B0@MWHPR15MB1903.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(346002)(376002)(39860400002)(136003)(366004)(396003)(189003)(199004)(229853002)(68736007)(46003)(5660300002)(4326008)(6436002)(14454004)(478600001)(8936002)(73956011)(446003)(11346002)(66476007)(66556008)(66446008)(6486002)(86362001)(186003)(64756008)(53936002)(66946007)(476003)(486006)(316002)(102836004)(76176011)(33716001)(6116002)(52116002)(53546011)(386003)(99286004)(6916009)(2906002)(6506007)(7736002)(9686003)(25786009)(305945005)(6512007)(1076003)(81156014)(81166006)(8676002)(6246003)(71190400001)(71200400001)(14444005)(256004)(54906003)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1903;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6uYuv+Pf+QfZmPPLu11beJAfwqV+h6qdniwprRKpXAbQjjUrJA+JkUxztHukRpPbxSljCWgSqY2gGwVEN+9pcVZNL5oTG/1c8KhNl00rITTqWgaZ0LNIP3KflNiXhP7goO/+7asdG73mZs6VeoH9KEb7/MGIXye9zBglH4Gpfk8440P8UQfEZXhp3ZWmcByy0PfubIUO6cl7nCxUHhKUwqs25dawI2aMHMGiGmncXzdS089q0qmRyEKMIuYMIIwAR8LvxApLdOPLLMNXBsjXObawDRYZj8MH2MoYPc/i3F42QCG5D3WuryOaID5HrSQUh4ZDIdedlTe+XDIF9l2ZaNsuD5ba6a325xtr69HIwgkjedSh9bnuP1HjqN4/elk8+eX70iXMYgshy1qf4rame25D/NSmr9BGjD6A4ekdD54=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F68E5AA979EC9D4CAA20608AF9E60D99@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ce0b43-8338-42a8-b2cb-08d6db13419a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 22:01:47.4885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1903
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-17_14:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 17, 2019 at 02:51:48PM -0700, Eric Dumazet wrote:
>=20
>=20
> On 5/17/19 2:21 PM, Martin KaFai Lau wrote:
> > The BPF_FUNC_sk_lookup_xxx helpers return RET_PTR_TO_SOCKET_OR_NULL.
> > Meaning a fullsock ptr and its fullsock's fields in bpf_sock can be
> > accessed, e.g. type, protocol, mark and priority.
> > Some new helper, like bpf_sk_storage_get(), also expects
> > ARG_PTR_TO_SOCKET is a fullsock.
> >=20
> > bpf_sk_lookup() currently calls sk_to_full_sk() before returning.
> > However, the ptr returned from sk_to_full_sk() is not guaranteed
> > to be a fullsock.  For example, it cannot get a fullsock if sk
> > is in TCP_TIME_WAIT.
> >=20
> > This patch checks for sk_fullsock() before returning. If it is not
> > a fullsock, sock_gen_put() is called if needed and then returns NULL.
> >=20
> > Fixes: 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
> > Cc: Joe Stringer <joe@isovalent.com>
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  net/core/filter.c | 16 ++++++++++++++--
> >  1 file changed, 14 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 55bfc941d17a..85def5a20aaf 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -5337,8 +5337,14 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_=
sock_tuple *tuple, u32 len,
> >  	struct sock *sk =3D __bpf_skc_lookup(skb, tuple, len, caller_net,
> >  					   ifindex, proto, netns_id, flags);
> > =20
> > -	if (sk)
> > +	if (sk) {
> >  		sk =3D sk_to_full_sk(sk);
> > +		if (!sk_fullsock(sk)) {
> > +			if (!sock_flag(sk, SOCK_RCU_FREE))
> > +				sock_gen_put(sk);
>=20
> This looks a bit convoluted/weird.
>=20
> What about telling/asking __bpf_skc_lookup() to not return a non fullsock=
 instead ?
It is becausee some other helpers, like BPF_FUNC_skc_lookup_tcp,
can return non fullsock.

>=20
> > +			return NULL;
> > +		}
> > +	}
> > =20
> >  	return sk;
> >  }
> > @@ -5369,8 +5375,14 @@ bpf_sk_lookup(struct sk_buff *skb, struct bpf_so=
ck_tuple *tuple, u32 len,
> >  	struct sock *sk =3D bpf_skc_lookup(skb, tuple, len, proto, netns_id,
> >  					 flags);
> > =20
> > -	if (sk)
> > +	if (sk) {
> >  		sk =3D sk_to_full_sk(sk);
> > +		if (!sk_fullsock(sk)) {
> > +			if (!sock_flag(sk, SOCK_RCU_FREE))
> > +				sock_gen_put(sk);
> > +			return NULL;
> > +		}
> > +	}
> > =20
> >  	return sk;
> >  }
> >=20
