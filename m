Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07CDF3213A
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 01:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfFAXzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 19:55:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55914 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726211AbfFAXzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 19:55:19 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x51No9nV010914;
        Sat, 1 Jun 2019 16:54:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=eh8QeL5DmJofe8zQcApMI/XJaV4gPVnwnMFBISmrv9I=;
 b=IYRycVNw2/Ta2XrUWhSpMXw3arM6lQXKjtD5TWHGtdrqq9ywR+ZWLEIXRTtTtjAxybNm
 WvHb+6lnw38dwN76reWWqiAbyfleqoNxIgVVEsyMd7cagA38CaasbI/vDSmlNeh3QBdc
 a7W9KSVOVDQxr0CY1g+8UClUTTMEkseWn0U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sunfu1fc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 01 Jun 2019 16:54:56 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 1 Jun 2019 16:54:54 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 1 Jun 2019 16:54:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eh8QeL5DmJofe8zQcApMI/XJaV4gPVnwnMFBISmrv9I=;
 b=axEmoxGGx/U0A6xK/P9Qxmzd3PgxVkPyUwI0uGktpvH5VUmx64o0eTYiBP2VdzsQcWRBdsB2IHYGOoOr1qo0LSA1hADtobWXNzbkbd6faNhk57AlluGXjEOEYuVtYwRC/QVzNzIZR3N5tn9O58i7wTMcQZkuJBOE2xEIv0RNgcA=
Received: from DM5PR15MB1163.namprd15.prod.outlook.com (10.173.215.141) by
 DM5PR15MB1308.namprd15.prod.outlook.com (10.173.212.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.16; Sat, 1 Jun 2019 23:54:53 +0000
Received: from DM5PR15MB1163.namprd15.prod.outlook.com
 ([fe80::cc3d:9bc2:1c3f:e661]) by DM5PR15MB1163.namprd15.prod.outlook.com
 ([fe80::cc3d:9bc2:1c3f:e661%4]) with mapi id 15.20.1943.018; Sat, 1 Jun 2019
 23:54:52 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Martin Lau <kafai@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Craig Gallek <kraig@google.com>
Subject: Re: [PATCH bpf 1/2] bpf: udp: ipv6: Avoid running reuseport's
 bpf_prog from __udp6_lib_err
Thread-Topic: [PATCH bpf 1/2] bpf: udp: ipv6: Avoid running reuseport's
 bpf_prog from __udp6_lib_err
Thread-Index: AQHVGAB413xwJ9RXsEKlNmEX6k/AS6aHes0A
Date:   Sat, 1 Jun 2019 23:54:52 +0000
Message-ID: <E1A13752-B9E8-41D8-A44D-12CE1933C46D@fb.com>
References: <20190531222910.2499861-1-kafai@fb.com>
 <20190531222911.2500496-1-kafai@fb.com>
In-Reply-To: <20190531222911.2500496-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::6be]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 796d1048-697a-4ce4-c969-08d6e6ec8a7f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR15MB1308;
x-ms-traffictypediagnostic: DM5PR15MB1308:
x-microsoft-antispam-prvs: <DM5PR15MB13082D25D58F99780C7A6ACDB31A0@DM5PR15MB1308.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 00550ABE1F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(136003)(346002)(39860400002)(189003)(199004)(66946007)(66446008)(66476007)(64756008)(73956011)(66556008)(33656002)(4326008)(6116002)(91956017)(76116006)(229853002)(305945005)(14454004)(478600001)(102836004)(7736002)(82746002)(57306001)(76176011)(6486002)(6506007)(6436002)(53546011)(6636002)(2906002)(6512007)(36756003)(71200400001)(71190400001)(83716004)(81156014)(81166006)(54906003)(25786009)(37006003)(68736007)(316002)(186003)(99286004)(86362001)(6862004)(8676002)(53936002)(50226002)(486006)(5660300002)(446003)(8936002)(2616005)(46003)(6246003)(476003)(11346002)(14444005)(5024004)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1308;H:DM5PR15MB1163.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0BcEMthYx+Gsm3bd6slXQoItV7zO44w80qtamIr9Cp7nUHm5lx7XQZzuj7sPn3T1gWevP+1alyBVH+ESHG8Lq5dDnbLqsOwW+gu+DYn0RZX+IZTGmqBHBEqmzJM1B+T9P5ZFGL+2MKCDBJV4FYs6llNPAHdmQH0pJue9Pm4Ks/lEQBvxuELkj2SNgnNba0kLtjwZA70ZjqHZlijvMi/Tdu2UZlc9RV5Vf7V6OwiAfDZzIKljJKjOlTQaRLxvMO95v7h3lHSMQShROYknIKPRUgtRU9dmuZiTRhugvl6xsGHLprjUn2C4WHKv/25EZbih/K7qE2DHdkHVJgdo6Cm2TGQA3p0HZDa9q4cCLfLDhBO52msJK2GLXfokGGovk0IQeEIGorLEaZyjYWbXq9se804YXQiXMfCGtruutCp/QWA=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4088AE47345E3E4CB74731CE8D7AD511@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 796d1048-697a-4ce4-c969-08d6e6ec8a7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2019 23:54:52.8473
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
> __udp6_lib_err() may be called when handling icmpv6 message. For example,
> the icmpv6 toobig(type=3D2).  __udp6_lib_lookup() is then called
> which may call reuseport_select_sock().  reuseport_select_sock() will
> call into a bpf_prog (if there is one).
>=20
> reuseport_select_sock() is expecting the skb->data pointing to the
> transport header (udphdr in this case).  For example, run_bpf_filter()
> is pulling the transport header.
>=20
> However, in the __udp6_lib_err() path, the skb->data is pointing to the
> ipv6hdr instead of the udphdr.
>=20
> One option is to pull and push the ipv6hdr in __udp6_lib_err().
> Instead of doing this, this patch follows how the original
> commit 538950a1b752 ("soreuseport: setsockopt SO_ATTACH_REUSEPORT_[CE]BPF=
")
> was done in IPv4, which has passed a NULL skb pointer to
> reuseport_select_sock().
>=20
> Fixes: 538950a1b752 ("soreuseport: setsockopt SO_ATTACH_REUSEPORT_[CE]BPF=
")
> Cc: Craig Gallek <kraig@google.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> net/ipv6/udp.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 07fa579dfb96..133e6370f89c 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -515,7 +515,7 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_=
skb_parm *opt,
> 	struct net *net =3D dev_net(skb->dev);
>=20
> 	sk =3D __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
> -			       inet6_iif(skb), inet6_sdif(skb), udptable, skb);
> +			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
> 	if (!sk) {
> 		/* No socket for error: try tunnels before discarding */
> 		sk =3D ERR_PTR(-ENOENT);
> --=20
> 2.17.1
>=20

