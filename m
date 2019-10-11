Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEC4D4941
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 22:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbfJKUTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 16:19:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21722 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729089AbfJKUTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 16:19:32 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9BKISiL015482;
        Fri, 11 Oct 2019 13:19:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=aAY20d9IXIpZlBrZZnCQuOt9G1BeGpBUCBhfi3QvjTs=;
 b=C/CsLQ8xjo5IPMAe0oU5SfQRmDm+lLi35HCdbdkQ4AwwEFNwnoCtk0v0FwG54X9bghNE
 MwDoyRPG4uLc8dMTcNYI7klxWvpebdz+xmyNR1xiP8Pq8ptELfzG9N456T9+8g0obEj0
 jnQtxUxoZIbGdgCSdWReShoAwqMq6AmRgE4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vjtsuj0ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 13:19:15 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 11 Oct 2019 13:19:14 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 11 Oct 2019 13:19:14 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 11 Oct 2019 13:19:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g//udZLz3M6q6qpuDtS7Ng++d53DP8Q+iX1fomEDRxGRHPJ70iekCSiyEXD1qxSA0jUaZ9YVzVCdLbLZS29Zl/1l8x0Apnf4kP5tWVnp52GZYRrjhfXybRyXhc+fqoTJr47kYalhXmsSUqlicAvONvtB4hfZGAoiQ1V8zaHOSBb/jykmygTIFjwB45Frca2osm81AKuEt6K+ufp3LiQ5kkxBUZ5JAR3cBf7SlWoac6F8gWt/2y0zD0CbbBVkhZZUnIe7T6u4ZP+yImBovBpFg1tTJEQ8htFoYKoQAP1Bo41XnYLnQDrFMaGZQG+jCokmeyj6xBNo6ovpA+y0B1cNQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAY20d9IXIpZlBrZZnCQuOt9G1BeGpBUCBhfi3QvjTs=;
 b=Uz98eI9ADNAuCIO92CfUq4km1ow/tM5PlbG+MJiR1+whu20pUnn4ShXX/uC3S9ZSmIljmsBwxbNqdvFfpjNBAeKCXmoTtLj3nvRVQJEEnx+QZHQqrZyWnSgcitnfFWua8HF+Fk/rKHSZsxJkSs9M3FLYEJIAxwLvBcPbfQeC9FYyLjYgH7I2Mj4FCaYU7hFlbPn7bPCPq94z+T/dVn2ERZ3yvgiHfPvLe3oocKhcY5fnVmxmDTpkLnKQUs017wl6NNaVHeqERDP2666/idTG8C/p+5KfYdNglz2ajMv0WYSBDkUZLnCgfyNZl2bk3rIIy9ow3nv+6n8JFRrmbzRvXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAY20d9IXIpZlBrZZnCQuOt9G1BeGpBUCBhfi3QvjTs=;
 b=Ngv/S2qr+uAS9vIJ3hIDOtGcXGPoOOveo5aUnibeCpN1T1w14udeuvmLJgt135vhJlFuyjUAd3vokZgjG/2FmoQHFcK5xr+IXGIHINSFaQkvjfYwJuE9539/FXrsEm6xAZyyZR2fluqK78MRsKNt+DKcOxA9oEsxZpczGY05Fno=
Received: from BN8PR15MB3202.namprd15.prod.outlook.com (20.179.76.139) by
 BN8PR15MB3473.namprd15.prod.outlook.com (20.179.73.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Fri, 11 Oct 2019 20:19:13 +0000
Received: from BN8PR15MB3202.namprd15.prod.outlook.com
 ([fe80::5016:da37:f569:9c04]) by BN8PR15MB3202.namprd15.prod.outlook.com
 ([fe80::5016:da37:f569:9c04%5]) with mapi id 15.20.2347.021; Fri, 11 Oct 2019
 20:19:13 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 3/3] bpftool: print the comm of the process that
 loaded the program
Thread-Topic: [PATCH bpf-next 3/3] bpftool: print the comm of the process that
 loaded the program
Thread-Index: AQHVgE/4J5dC5kSjxkuSZVDIUEVz5qdV4acA
Date:   Fri, 11 Oct 2019 20:19:13 +0000
Message-ID: <20191011201910.ynztujumh7dlluez@kafai-mbp.dhcp.thefacebook.com>
References: <20191011162124.52982-1-sdf@google.com>
 <20191011162124.52982-3-sdf@google.com>
In-Reply-To: <20191011162124.52982-3-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0039.namprd08.prod.outlook.com
 (2603:10b6:300:c0::13) To BN8PR15MB3202.namprd15.prod.outlook.com
 (2603:10b6:408:aa::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:ad20]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7de0eda6-2a55-428e-141a-08d74e884844
x-ms-traffictypediagnostic: BN8PR15MB3473:
x-microsoft-antispam-prvs: <BN8PR15MB34734E708D31DF4DE3141E50D5970@BN8PR15MB3473.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:179;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(346002)(376002)(366004)(39860400002)(189003)(199004)(66556008)(476003)(66446008)(66476007)(64756008)(229853002)(305945005)(66946007)(76176011)(6246003)(6512007)(9686003)(52116002)(2906002)(7736002)(8676002)(81156014)(81166006)(186003)(99286004)(71190400001)(71200400001)(478600001)(8936002)(102836004)(25786009)(11346002)(256004)(446003)(14444005)(6436002)(6486002)(54906003)(5660300002)(316002)(386003)(6506007)(6116002)(1076003)(4326008)(6916009)(86362001)(14454004)(486006)(46003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB3473;H:BN8PR15MB3202.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B+aGcn4bFjAYrMQY0wpOVxTXTBa3i/IUtOPETkvNuiD7Gq4Yywen2fvThCYhl4jk/4vqcrY1Z9H4F3k1VKu5bNb6QT44tJUqAYjotz+DJ2tGzrjaYlU265vXHNbWbCE+3D88X15HcChOGk9Qojugelea4PRy6LFh9JvpjB4Ssjd52GQo5fDkkw5bn73ItrnSQmrumIl4gsdsI2jAhHCGX70lIqKuIOjAcDt3Trf6MIHmrHw1NOAbjKzNd7FQ3LUXLWTBBaGw1ONAxzvDa61A2sK9QqqfR3xpBFol8/rVDzmbb9CmCJK6cQn4kXyfb/Caf9YtG7fHPZN45wCFj0SYDzVE2/mXTclVF0goSXM+7jDRTv8CIbmHjsNv1Simcg0OqF1j88m4S032jsDZLw9RekbwaVYqt+yPl4pkWD9hV0I=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <98C094D3A8AB3840ADE174807ED7B2FB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7de0eda6-2a55-428e-141a-08d74e884844
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 20:19:13.3922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vkOS27JewZuc/05pTQN1YlUF1HhCI+bT0BsXgBFWAzMoYq6ZrDATp1WY2rgeoG6B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3473
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_10:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 phishscore=0
 suspectscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910110163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 09:21:24AM -0700, Stanislav Fomichev wrote:
> Print recently added created_by_comm along the existing created_by_uid.
>=20
> Example with loop1.o (loaded via bpftool):
> 4: raw_tracepoint  name nested_loops  tag b9472b3ff5753ef2  gpl
>         loaded_at 2019-10-10T13:38:18-0700  uid 0  comm bpftool
>         xlated 264B  jited 152B  memlock 4096B
>         btf_id 3
Hopefully CAP_BPF may avoid uid 0 in the future.

What will be in "comm" for the python bcc script?

>=20
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/bpf/bpftool/prog.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index 27da96a797ab..400771a942d7 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -296,7 +296,9 @@ static void print_prog_plain(struct bpf_prog_info *in=
fo, int fd)
>  		print_boot_time(info->load_time, buf, sizeof(buf));
> =20
>  		/* Piggy back on load_time, since 0 uid is a valid one */
> -		printf("\tloaded_at %s  uid %u\n", buf, info->created_by_uid);
> +		printf("\tloaded_at %s  uid %u  comm %s\n", buf,
> +		       info->created_by_uid,
> +		       info->created_by_comm);
>  	}
> =20
>  	printf("\txlated %uB", info->xlated_prog_len);
> --=20
> 2.23.0.700.g56cf767bdb-goog
>=20
