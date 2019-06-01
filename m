Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC9C132138
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 01:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfFAXzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 19:55:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56792 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726211AbfFAXzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 19:55:11 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x51NnMlX014352;
        Sat, 1 Jun 2019 16:54:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=sQkQuOfDjzsrS3FS/a6Y8j3URmRmlD9Bdpb36dcSQ8g=;
 b=HTAlz195wg2tsyIuGPGo2YKtI1Mpd3k90QetGbWdnGudvR+UTCo0VT4rgRa7uFzV8KXV
 BiQOgerSuSvc1hkX38WIkopvEV7glZT8x4T6W7/3z9AEBYwr9HQ1CrilY7S4kySwJsdI
 BPWIaOBFy/krA/w54Twxi24xDgW6cKUhI9Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2supvbs9vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 01 Jun 2019 16:54:50 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 1 Jun 2019 16:54:49 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 1 Jun 2019 16:54:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQkQuOfDjzsrS3FS/a6Y8j3URmRmlD9Bdpb36dcSQ8g=;
 b=b/ZRCOg26OgUJ6xbIs12LZfO1Auubt+GZjUkXH45F5euzijFycSi8L/HGqIrdW4xu80HQ+neqmihteBE5dlA9xPoDDb/sWinN2NCv35xrFHI2cZkm4/d2BCVavwmeVHDFZdsCKhRHK7mSoXtehPuaNkgis9aEj5P637RFkxWG0w=
Received: from DM5PR15MB1163.namprd15.prod.outlook.com (10.173.215.141) by
 DM5PR15MB1308.namprd15.prod.outlook.com (10.173.212.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.16; Sat, 1 Jun 2019 23:54:46 +0000
Received: from DM5PR15MB1163.namprd15.prod.outlook.com
 ([fe80::cc3d:9bc2:1c3f:e661]) by DM5PR15MB1163.namprd15.prod.outlook.com
 ([fe80::cc3d:9bc2:1c3f:e661%4]) with mapi id 15.20.1943.018; Sat, 1 Jun 2019
 23:54:46 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Martin Lau <kafai@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Tom Herbert <tom@herbertland.com>
Subject: Re: [PATCH bpf 2/2] bpf: udp: Avoid calling reuseport's bpf_prog from
 udp_gro
Thread-Topic: [PATCH bpf 2/2] bpf: udp: Avoid calling reuseport's bpf_prog
 from udp_gro
Thread-Index: AQHVGABUpxevhnmX1kivwtuNG3NSD6aHesWA
Date:   Sat, 1 Jun 2019 23:54:46 +0000
Message-ID: <AB1E485E-DAEE-49BD-BC86-1299C6830B7F@fb.com>
References: <20190531222910.2499861-1-kafai@fb.com>
 <20190531222913.2500781-1-kafai@fb.com>
In-Reply-To: <20190531222913.2500781-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::6be]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 211153b0-982e-4863-43e8-08d6e6ec86b7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR15MB1308;
x-ms-traffictypediagnostic: DM5PR15MB1308:
x-microsoft-antispam-prvs: <DM5PR15MB1308A227B31C5C7A9010C96AB31A0@DM5PR15MB1308.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:299;
x-forefront-prvs: 00550ABE1F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(136003)(346002)(39860400002)(189003)(199004)(66946007)(66446008)(66476007)(64756008)(73956011)(66556008)(33656002)(4326008)(6116002)(91956017)(76116006)(229853002)(305945005)(14454004)(478600001)(102836004)(7736002)(82746002)(57306001)(76176011)(6486002)(6506007)(6436002)(53546011)(6636002)(2906002)(6512007)(36756003)(71200400001)(71190400001)(83716004)(81156014)(81166006)(54906003)(25786009)(37006003)(68736007)(316002)(186003)(99286004)(86362001)(6862004)(8676002)(53936002)(50226002)(486006)(5660300002)(446003)(8936002)(2616005)(46003)(6246003)(476003)(11346002)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1308;H:DM5PR15MB1163.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uHG7+d8NYJLhAEv+dAadSesxrg6a8HQT4r003RXWLjcM13iKIxOBnHnz3t1Yv31vRNVF/GaV4Z3Io60zIlParS4LK0715hs6o6cTmxGP0/Xj1qZH2riBacWShkdNAHpmCSE7La3zRbrZOhsYD4wQZuyOE4gqYNqUMGrtNADpNcx6fdlBkzZY4/dPwMVmk9H04Qrv4EDpKLfjBlQKj6IkE26FUXjZoeMss0AH7paHvp2qLP1qWmlvtdJD0ntPibD6A56bMqzNVYa1GqaLIPgdSWI6y/B6HBaNDJYtV6XbTRrnagES1snBi5Fh+KAeaFoMGMT4wIqei6yiolsVugfldRQyLWv1oWhYqJoM+6N+6AsyEmNYYn+qc6FZhpwd2CXz2OdqfhGo9er8lQvTVoER5zyHiOIORewwAxPCHlJnZ48=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4C4059787312724A9415354A205C19CF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 211153b0-982e-4863-43e8-08d6e6ec86b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2019 23:54:46.5140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1308
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-01_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906010172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 31, 2019, at 3:29 PM, Martin KaFai Lau <kafai@fb.com> wrote:
>=20
> When the commit a6024562ffd7 ("udp: Add GRO functions to UDP socket")
> added udp[46]_lib_lookup_skb to the udp_gro code path, it broke
> the reuseport_select_sock() assumption that skb->data is pointing
> to the transport header.
>=20
> This patch follows an earlier __udp6_lib_err() fix by
> passing a NULL skb to avoid calling the reuseport's bpf_prog.
>=20
> Fixes: a6024562ffd7 ("udp: Add GRO functions to UDP socket")
> Cc: Tom Herbert <tom@herbertland.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
> net/ipv4/udp.c | 6 +++++-
> net/ipv6/udp.c | 2 +-
> 2 files changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 8fb250ed53d4..85db0e3d7f3f 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -503,7 +503,11 @@ static inline struct sock *__udp4_lib_lookup_skb(str=
uct sk_buff *skb,
> struct sock *udp4_lib_lookup_skb(struct sk_buff *skb,
> 				 __be16 sport, __be16 dport)
> {
> -	return __udp4_lib_lookup_skb(skb, sport, dport, &udp_table);
> +	const struct iphdr *iph =3D ip_hdr(skb);
> +
> +	return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
> +				 iph->daddr, dport, inet_iif(skb),
> +				 inet_sdif(skb), &udp_table, NULL);

I think we can now remove the last argument of __udp4_lib_lookup()?


> }
> EXPORT_SYMBOL_GPL(udp4_lib_lookup_skb);
>=20
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 133e6370f89c..4e52c37bb836 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -243,7 +243,7 @@ struct sock *udp6_lib_lookup_skb(struct sk_buff *skb,
>=20
> 	return __udp6_lib_lookup(dev_net(skb->dev), &iph->saddr, sport,
> 				 &iph->daddr, dport, inet6_iif(skb),
> -				 inet6_sdif(skb), &udp_table, skb);
> +				 inet6_sdif(skb), &udp_table, NULL);
> }
> EXPORT_SYMBOL_GPL(udp6_lib_lookup_skb);
>=20
> --=20
> 2.17.1
>=20

