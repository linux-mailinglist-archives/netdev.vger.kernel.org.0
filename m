Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBFE936864
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 01:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfFEXza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 19:55:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54778 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726510AbfFEXz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 19:55:29 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x55Nrs82001391;
        Wed, 5 Jun 2019 16:55:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8yzPcbh92Ma1382Sw/rAwcscaIezBevGrKjOEMmhMnQ=;
 b=PMzuUPC7vCUAWdLcZHgzpb/qBJWj54sm3oXLHhiikeiwM/X+wxUOQgGaNym1nJXrm+Wm
 BZoTzfIGAwKAfRxjq9msUI8vPvX1hbxz2KLShGnwBvRhldYOLmoDzyA9i1zl4KfraMD3
 OaBraQkAwZt4KySdEKm6Ykbti5WCfP4/7WU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sxm030ua8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 05 Jun 2019 16:55:01 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 5 Jun 2019 16:54:59 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 5 Jun 2019 16:54:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yzPcbh92Ma1382Sw/rAwcscaIezBevGrKjOEMmhMnQ=;
 b=nuNmAUWHCePYj6qCgoeKfPqNDpKylFXwm91egOD0OrrZwy+bQ7IF0gkuR3o8PukgyJJETIh6J0A2/g8jBnzVFpgfE8YeBRSwJMesojUCytBdThZ09naqQ0aQkYrsSn0byHRxk09q9mzkeNQqoxtZezf9rWYxisa4BF0xCLvQGmE=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1230.namprd15.prod.outlook.com (10.175.2.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Wed, 5 Jun 2019 23:54:58 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Wed, 5 Jun 2019
 23:54:58 +0000
From:   Martin Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "Andrey Ignatov" <rdna@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Martynas Pumputis <m@lambda.lt>
Subject: Re: [PATCH bpf 1/2] bpf: fix unconnected udp hooks
Thread-Topic: [PATCH bpf 1/2] bpf: fix unconnected udp hooks
Thread-Index: AQHVG98PvNVi58SN5EiEoejGyA+SeKaNvGKA
Date:   Wed, 5 Jun 2019 23:54:57 +0000
Message-ID: <20190605235451.lqas2jgbur2sre4z@kafai-mbp.dhcp.thefacebook.com>
References: <3d59d0458a8a3a050d24f81e660fcccde3479a05.1559767053.git.daniel@iogearbox.net>
In-Reply-To: <3d59d0458a8a3a050d24f81e660fcccde3479a05.1559767053.git.daniel@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0202.namprd04.prod.outlook.com
 (2603:10b6:104:5::32) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:b7bf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e540013-cb7e-422a-2977-08d6ea1134c4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1230;
x-ms-traffictypediagnostic: MWHPR15MB1230:
x-microsoft-antispam-prvs: <MWHPR15MB1230E989661F03ED9C32AFBCD5160@MWHPR15MB1230.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:431;
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(396003)(136003)(366004)(189003)(199004)(45904002)(6916009)(229853002)(2906002)(478600001)(256004)(5024004)(1076003)(14444005)(71190400001)(71200400001)(53936002)(86362001)(316002)(5660300002)(14454004)(81156014)(54906003)(81166006)(7736002)(6436002)(6246003)(99286004)(476003)(73956011)(68736007)(486006)(25786009)(102836004)(76176011)(6506007)(386003)(4326008)(66446008)(64756008)(66556008)(66476007)(66946007)(52116002)(46003)(6486002)(186003)(305945005)(8676002)(8936002)(9686003)(6116002)(6512007)(11346002)(446003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1230;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nO1+3LEAChecklzJERIuUQ9Q+zJfCr9XqKeMhmPCEyg3VQBbaZLDcqt/gzQnzVPLzTUWXI5iOpu7/9iBuFBY7NcusrXXP3nWTJkU6pQOkjP/JFlqmj5o7/sbcdKJLgnGXDoG9qZuSOYYljVj/a27CYR3Thf0Bthw27+o0qwWkoIUtBfE272vZaFbhuIDgcMM8Wr99fGw5DLHyWTk8Kt8RJdJbcxCkMpSNgqZUPncDn3n/dycGSmUUwiTLxxlNR2347l6bfUjbNu8kzN1hvrcnYpvcPjD7FgpoYeJLWz2CIwvTRW5UhCbt+HNwCf2YQ8eJnwHRHBVaO+rnpHmKe20AFrDuAXbXeZgY2gLqLxZ59L2lkjLGVaSWSwbOWaxnGtu8Mn0neuc5SC6/0f5STxjSKcu2YfGpVbpfmYIQJnzo2k=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D2F5FD663A2B18409C27774A48E5E45E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e540013-cb7e-422a-2977-08d6ea1134c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2019 23:54:57.8170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1230
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-05_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906050152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 10:40:49PM +0200, Daniel Borkmann wrote:
> Intention of cgroup bind/connect/sendmsg BPF hooks is to act transparentl=
y
> to applications as also stated in original motivation in 7828f20e3779 ("M=
erge
> branch 'bpf-cgroup-bind-connect'"). When recently integrating the latter
> two hooks into Cilium to enable host based load-balancing with Kubernetes=
,
> I ran into the issue that pods couldn't start up as DNS got broken. Kuber=
netes
> typically sets up DNS as a service and is thus subject to load-balancing.
>=20
> Upon further debugging, it turns out that the cgroupv2 sendmsg BPF hooks =
API
> is currently insufficent and thus not usable as-is for standard applicati=
ons
> shipped with most distros. To break down the issue we ran into with a sim=
ple
> example:
>=20
>   # cat /etc/resolv.conf
>   nameserver 147.75.207.207
>   nameserver 147.75.207.208
>=20
> For the purpose of a simple test, we set up above IPs as service IPs and
> transparently redirect traffic to a different DNS backend server for that
> node:
>=20
>   # cilium service list
>   ID   Frontend            Backend
>   1    147.75.207.207:53   1 =3D> 8.8.8.8:53
>   2    147.75.207.208:53   1 =3D> 8.8.8.8:53
>=20
> The attached BPF program is basically selecting one of the backends if th=
e
> service IP/port matches on the cgroup hook. DNS breaks here, because the
> hooks are not transparent enough to applications which have built-in msg_=
name
> address checks:
>=20
>   # nslookup 1.1.1.1
>   ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.207#53
>   ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.208#53
>   ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.207#53
>   [...]
>   ;; connection timed out; no servers could be reached
>=20
>   # dig 1.1.1.1
>   ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.207#53
>   ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.208#53
>   ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.207#53
>   [...]
>=20
>   ; <<>> DiG 9.11.3-1ubuntu1.7-Ubuntu <<>> 1.1.1.1
>   ;; global options: +cmd
>   ;; connection timed out; no servers could be reached
>=20
> For comparison, if none of the service IPs is used, and we tell nslookup
> to use 8.8.8.8 directly it works just fine, of course:
>=20
>   # nslookup 1.1.1.1 8.8.8.8
>   1.1.1.1.in-addr.arpa	name =3D one.one.one.one.
>=20
> In order to fix this and thus act more transparent to the application,
> this needs reverse translation on recvmsg() side. A minimal fix for this
> API is to add similar recvmsg() hooks behind the BPF cgroups static key
> such that the program can track state and replace the current sockaddr_in=
{,6}
> with the original service IP. From BPF side, this basically tracks the
> service tuple plus socket cookie in an LRU map where the reverse NAT can
> then be retrieved via map value as one example. Side-note: the BPF cgroup=
s
> static key should be converted to a per-hook static key in future.
>=20
> Same example after this fix:
>=20
>   # cilium service list
>   ID   Frontend            Backend
>   1    147.75.207.207:53   1 =3D> 8.8.8.8:53
>   2    147.75.207.208:53   1 =3D> 8.8.8.8:53
>=20
> Lookups work fine now:
>=20
>   # nslookup 1.1.1.1
>   1.1.1.1.in-addr.arpa    name =3D one.one.one.one.
>=20
>   Authoritative answers can be found from:
>=20
>   # dig 1.1.1.1
>=20
>   ; <<>> DiG 9.11.3-1ubuntu1.7-Ubuntu <<>> 1.1.1.1
>   ;; global options: +cmd
>   ;; Got answer:
>   ;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 51550
>   ;; flags: qr rd ra ad; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1
>=20
>   ;; OPT PSEUDOSECTION:
>   ; EDNS: version: 0, flags:; udp: 512
>   ;; QUESTION SECTION:
>   ;1.1.1.1.                       IN      A
>=20
>   ;; AUTHORITY SECTION:
>   .                       23426   IN      SOA     a.root-servers.net. nst=
ld.verisign-grs.com. 2019052001 1800 900 604800 86400
>=20
>   ;; Query time: 17 msec
>   ;; SERVER: 147.75.207.207#53(147.75.207.207)
>   ;; WHEN: Tue May 21 12:59:38 UTC 2019
>   ;; MSG SIZE  rcvd: 111
>=20
> And from an actual packet level it shows that we're using the back end
> server when talking via 147.75.207.20{7,8} front end:
>=20
>   # tcpdump -i any udp
>   [...]
>   12:59:52.698732 IP foo.42011 > google-public-dns-a.google.com.domain: 1=
8803+ PTR? 1.1.1.1.in-addr.arpa. (38)
>   12:59:52.698735 IP foo.42011 > google-public-dns-a.google.com.domain: 1=
8803+ PTR? 1.1.1.1.in-addr.arpa. (38)
>   12:59:52.701208 IP google-public-dns-a.google.com.domain > foo.42011: 1=
8803 1/0/0 PTR one.one.one.one. (67)
>   12:59:52.701208 IP google-public-dns-a.google.com.domain > foo.42011: 1=
8803 1/0/0 PTR one.one.one.one. (67)
>   [...]
>=20
> In order to be flexible and to have same semantics as in sendmsg BPF
> programs, we only allow return codes in [1,1] range. In the sendmsg case
> the program is called if msg->msg_name is present which can be the case
> in both, connected and unconnected UDP.
>=20
> The former only relies on the sockaddr_in{,6} passed via connect(2) if
> passed msg->msg_name was NULL. Therefore, on recvmsg side, we act in simi=
lar
> way to call into the BPF program whenever a non-NULL msg->msg_name was
> passed independent of sk->sk_state being TCP_ESTABLISHED or not. Note
> that for TCP case, the msg->msg_name is ignored in the regular recvmsg
> path and therefore not relevant.
>=20
> For the case of ip{,v6}_recv_error() paths, picked up via MSG_ERRQUEUE,
> the hook is not called. This is intentional as it aligns with the same
> semantics as in case of TCP cgroup BPF hooks right now. This might be
> better addressed in future through a different bpf_attach_type such
> that this case can be distinguished from the regular recvmsg paths,
> for example.
LGTM.

They are new hooks.  Should it belong to bpf-next instead?

>=20
> Fixes: 1cedee13d25a ("bpf: Hooks for sys_sendmsg")
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Andrey Ignatov <rdna@fb.com>
> Cc: Martynas Pumputis <m@lambda.lt>
> ---
>  include/linux/bpf-cgroup.h     |  8 ++++++++
>  include/uapi/linux/bpf.h       |  2 ++
>  kernel/bpf/syscall.c           |  8 ++++++++
>  kernel/bpf/verifier.c          | 12 ++++++++----
>  net/core/filter.c              |  2 ++
>  net/ipv4/udp.c                 |  4 ++++
>  net/ipv6/udp.c                 |  4 ++++
>  tools/bpf/bpftool/cgroup.c     |  5 ++++-
>  tools/include/uapi/linux/bpf.h |  2 ++
Should the bpf.h sync to tools/ be in a separate patch?

[ ... ]

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 95f93544..d2c8a66 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5361,9 +5361,12 @@ static int check_return_code(struct bpf_verifier_e=
nv *env)
>  	struct tnum range =3D tnum_range(0, 1);
> =20
>  	switch (env->prog->type) {
> +	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
> +		if (env->prog->expected_attach_type =3D=3D BPF_CGROUP_UDP4_RECVMSG ||
> +		    env->prog->expected_attach_type =3D=3D BPF_CGROUP_UDP6_RECVMSG)
> +			range =3D tnum_range(1, 1);
>  	case BPF_PROG_TYPE_CGROUP_SKB:
>  	case BPF_PROG_TYPE_CGROUP_SOCK:
> -	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
>  	case BPF_PROG_TYPE_SOCK_OPS:
>  	case BPF_PROG_TYPE_CGROUP_DEVICE:
>  	case BPF_PROG_TYPE_CGROUP_SYSCTL:
> @@ -5380,16 +5383,17 @@ static int check_return_code(struct bpf_verifier_=
env *env)
>  	}
> =20
>  	if (!tnum_in(range, reg->var_off)) {
> +		char tn_buf[48];
> +
>  		verbose(env, "At program exit the register R0 ");
>  		if (!tnum_is_unknown(reg->var_off)) {
> -			char tn_buf[48];
> -
>  			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
>  			verbose(env, "has value %s", tn_buf);
>  		} else {
>  			verbose(env, "has unknown scalar value");
>  		}
> -		verbose(env, " should have been 0 or 1\n");
> +		tnum_strn(tn_buf, sizeof(tn_buf), range);
> +		verbose(env, " should have been in %s\n", tn_buf);
A heads up that it may have a confict with a bpf-next commit
5cf1e9145630 ("bpf: cgroup inet skb programs can return 0 to 3")

>  		return -EINVAL;
>  	}
>  	return 0;
