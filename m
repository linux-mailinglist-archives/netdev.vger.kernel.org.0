Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC3263224E
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 09:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbfFBHGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 03:06:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44096 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbfFBHGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 03:06:22 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x526xfMB022800;
        Sun, 2 Jun 2019 00:05:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Ap5EQrVbKfzcSD1frDo36WIThZ9bovXqi5upQVpyHhQ=;
 b=qrGXwWyituZoHBgd/TOFR6k50ATaQDVwRLEsVoXte15KhMVyn70bDbOyV2Au/QN2FpVX
 86ERtdCloFzCwWETGqCLTowwTxd83k/uuUUkeBnG2XAhGFQfaoAYzfuYyff0wHfzw/2I
 84cnBWXv3GUTqErnn6oQ5dT7+49YNciLc1k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sunfu21vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 02 Jun 2019 00:05:58 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 2 Jun 2019 00:05:57 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 2 Jun 2019 00:05:56 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 2 Jun 2019 00:05:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ap5EQrVbKfzcSD1frDo36WIThZ9bovXqi5upQVpyHhQ=;
 b=licIMrQkVpRY/Ks6D2tei0bjg7D+Pa1SRQUFXuPViwNrPi+hxM5NznyaOZg9Wq8DPpXp2Mi14fbdAJie22lDH7XSciUlgmmPNLj5nQ5++OwunnpAXmYX++fjB/+pFah8GRwXlmqhY252ilwYWCntWRAjH1a1FaIlqBNLxZzS53k=
Received: from DM5PR15MB1163.namprd15.prod.outlook.com (10.173.215.141) by
 DM5PR15MB1386.namprd15.prod.outlook.com (10.173.219.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Sun, 2 Jun 2019 07:05:38 +0000
Received: from DM5PR15MB1163.namprd15.prod.outlook.com
 ([fe80::cc3d:9bc2:1c3f:e661]) by DM5PR15MB1163.namprd15.prod.outlook.com
 ([fe80::cc3d:9bc2:1c3f:e661%4]) with mapi id 15.20.1943.018; Sun, 2 Jun 2019
 07:05:38 +0000
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
Thread-Index: AQHVGABUpxevhnmX1kivwtuNG3NSD6aHesWAgAAU4oCAAGOCAA==
Date:   Sun, 2 Jun 2019 07:05:38 +0000
Message-ID: <361864C5-1353-4B41-A0C9-BD277607A809@fb.com>
References: <20190531222910.2499861-1-kafai@fb.com>
 <20190531222913.2500781-1-kafai@fb.com>
 <AB1E485E-DAEE-49BD-BC86-1299C6830B7F@fb.com>
 <20190602010925.eifdfmuao4pv5mui@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190602010925.eifdfmuao4pv5mui@kafai-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::91be]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c4de0803-8d3e-4cce-22fa-08d6e728b7d2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR15MB1386;
x-ms-traffictypediagnostic: DM5PR15MB1386:
x-microsoft-antispam-prvs: <DM5PR15MB13861C4B2E72B022AA62E295B31B0@DM5PR15MB1386.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 005671E15D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(346002)(136003)(396003)(366004)(51914003)(189003)(199004)(82746002)(83716004)(71200400001)(71190400001)(86362001)(36756003)(91956017)(76116006)(305945005)(2906002)(46003)(33656002)(73956011)(66446008)(66476007)(66556008)(64756008)(66946007)(256004)(5660300002)(478600001)(186003)(54906003)(6636002)(37006003)(6862004)(50226002)(4326008)(76176011)(2616005)(6486002)(99286004)(6512007)(7736002)(6436002)(446003)(14454004)(11346002)(8936002)(229853002)(53936002)(6246003)(8676002)(81156014)(81166006)(316002)(486006)(57306001)(25786009)(476003)(6116002)(68736007)(6506007)(53546011)(102836004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1386;H:DM5PR15MB1163.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: E1+pNtqxnUwAqOcGSAFjMz8MImB4JF9jOYw4+p/dyBtkKudyGpN0aKEftS+OXu/K6Y9k/qTsjEFcfCIlVT1VW2B3b5mEH+jqHDqjBuKUEp2LhDcwPiBtBYioa3LeWcFx/OtYrN5oSzQUo2UL+bDirMCwNsY9hoZqGX1982KS0KUqz8xjlqWDHyXSeV2OtpBZJDHDOQ8JFLTsTG/YQbbU7ctJAQYhHoBy9FVvPT4QSYbhaDEshnqGssJ/FwhIN7EhklJcwi3NH8gT0DJ0Gs/IW/X27/jOhwG1QnbLwL8mreRVQnFNTPd9wC7ixaQP4TJtHeCbXs+npyso6c3HiKvqlAkuwlNQyN9Hhe4jCMgnpnlSmK0M+/N+xy51qrA8bBGT2ZThGFu6en1aZDa7vUm3vB5OodwYCN7Rbzj8ld44wRA=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9C987E6570F9324DA667AE18FBDBA265@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c4de0803-8d3e-4cce-22fa-08d6e728b7d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2019 07:05:38.7383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1386
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-02_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906020053
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 1, 2019, at 6:09 PM, Martin Lau <kafai@fb.com> wrote:
>=20
> On Sat, Jun 01, 2019 at 04:54:46PM -0700, Song Liu wrote:
>>=20
>>=20
>>> On May 31, 2019, at 3:29 PM, Martin KaFai Lau <kafai@fb.com> wrote:
>>>=20
>>> When the commit a6024562ffd7 ("udp: Add GRO functions to UDP socket")
>>> added udp[46]_lib_lookup_skb to the udp_gro code path, it broke
>>> the reuseport_select_sock() assumption that skb->data is pointing
>>> to the transport header.
>>>=20
>>> This patch follows an earlier __udp6_lib_err() fix by
>>> passing a NULL skb to avoid calling the reuseport's bpf_prog.
>>>=20
>>> Fixes: a6024562ffd7 ("udp: Add GRO functions to UDP socket")
>>> Cc: Tom Herbert <tom@herbertland.com>
>>> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
>>> ---
>>> net/ipv4/udp.c | 6 +++++-
>>> net/ipv6/udp.c | 2 +-
>>> 2 files changed, 6 insertions(+), 2 deletions(-)
>>>=20
>>> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
>>> index 8fb250ed53d4..85db0e3d7f3f 100644
>>> --- a/net/ipv4/udp.c
>>> +++ b/net/ipv4/udp.c
>>> @@ -503,7 +503,11 @@ static inline struct sock *__udp4_lib_lookup_skb(s=
truct sk_buff *skb,
> Note that this patch is changing the below "udp4_lib_lookup_skb()"
> instead of the above "__udp4_lib_lookup_skb()".
>=20
>>> struct sock *udp4_lib_lookup_skb(struct sk_buff *skb,
>>> 				 __be16 sport, __be16 dport)
>>> {
>>> -	return __udp4_lib_lookup_skb(skb, sport, dport, &udp_table);
>>> +	const struct iphdr *iph =3D ip_hdr(skb);
>>> +
>>> +	return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
>>> +				 iph->daddr, dport, inet_iif(skb),
>>> +				 inet_sdif(skb), &udp_table, NULL);
>>=20
>> I think we can now remove the last argument of __udp4_lib_lookup()?
> The last arg of __udp4_lib_lookup() is skb.
> __udp4_lib_lookup_skb(), which is not changed in this patch, is still
> calling __udp4_lib_lookup() with a skb and the skb is used by the
> reuseport's bpf_prog.  Hence, it cannot be removed.

I see. I somehow missed this path. Thanks for the explanation.=20

Acked-by: Song Liu <songliubraving@fb.com>

>=20
>>=20
>>=20
>>> }
>>> EXPORT_SYMBOL_GPL(udp4_lib_lookup_skb);
>>>=20
>>> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
>>> index 133e6370f89c..4e52c37bb836 100644
>>> --- a/net/ipv6/udp.c
>>> +++ b/net/ipv6/udp.c
>>> @@ -243,7 +243,7 @@ struct sock *udp6_lib_lookup_skb(struct sk_buff *sk=
b,
>>>=20
>>> 	return __udp6_lib_lookup(dev_net(skb->dev), &iph->saddr, sport,
>>> 				 &iph->daddr, dport, inet6_iif(skb),
>>> -				 inet6_sdif(skb), &udp_table, skb);
>>> +				 inet6_sdif(skb), &udp_table, NULL);
>>> }
>>> EXPORT_SYMBOL_GPL(udp6_lib_lookup_skb);
>>>=20
>>> --=20
>>> 2.17.1
>>>=20
>>=20

