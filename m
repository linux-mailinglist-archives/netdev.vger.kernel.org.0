Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40BF0C0AE4
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 20:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfI0SR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 14:17:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19230 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726294AbfI0SR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 14:17:56 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8RI4g1g022338;
        Fri, 27 Sep 2019 11:17:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=p3O0B9pTfmpUg3hZ1ABDMjn7HuTpiJZSE44q6NuVbpo=;
 b=L/ODGNUPGU2XEUl1Xtyx6rF+MikSeRqb25LgB34ogRGXQAOOV4yyfcgJl3TmmPV6i2m8
 AvpvKatDLj58BcxbjQtIyHQNE2syhA09Si9AJjqCfYBXVtwyjSGtLstrqGXLzEmwsSij
 X7qRim1g0C9Ua5uq9/9lMNC9uXPcegIT39A= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2v9pk80b4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 27 Sep 2019 11:17:39 -0700
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 27 Sep 2019 11:17:38 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 27 Sep 2019 11:17:38 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 27 Sep 2019 11:17:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1ELWr2o0gmpYY1SMBzggcS4mhmp9I78J+lxKLRJ2YlsJqJgW7GfN1XV4FKToNItnqVq5yz5qfL6WjD9NJL7a3dkAhVyHekoDUxDLfnuNmTJBdJC7haGgE2rqAFERMKB9qpGLDtOFrb0+mIOm5OnhhcnwuLJg7AXdLtrt/NbAEn7NlqSU7XbZy7T0yJ/YY1yVT9AiDvADz5J6K1SYdFDjCxWNUWSJI/tymkFOl8IKJj468n7nV9/+RGc1rHoV6XuZsEsXwGv21v4KAnqz2FOCyPMLKtfNSQJMmPHrS6xQW7uJNn0X7aUMz8dmfcTd4IMDS5vzHRTTHB+hJgfxngVPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3O0B9pTfmpUg3hZ1ABDMjn7HuTpiJZSE44q6NuVbpo=;
 b=WsIzIqEpBNKKx0+O3rrkH4NRgGSY7TB3e+/FwRrYjM7KrCSu5TughvvuotgIvK4u+mcGomIJkpPbJuSAxkFbxjVyfHd2Dq4/X8LDuU7/7ZrGWP5MlLRAymIet+BCM9f1Bw9gov1+77V6pT9Jttqz0/6qrwEUV2dyKY0yv618pSB7pQNQdiWGhZZJqc4SAnt62665o36niDJbVrXioxBeGWNUSUjJqJ7wo6hUBEAme5WWwCPYdgmP2uYug1RoQyI8ObM9j5tza1x7KlW15+lGcoDkgVIrCTvlIjIKsHAnKuRLu2/boPBK/kJn3gIq4VWJR8cOmwJFYY6m3hiTL14sQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3O0B9pTfmpUg3hZ1ABDMjn7HuTpiJZSE44q6NuVbpo=;
 b=fow/NzVM1jq0lE7jLJ7/x/qbIyNQ7qVcNoOYy2sFEXsLI1Wq+kSnZuh3IUUsQYfy2KZhrPfGG8M3tRtF1JfudVnr0KsIuKXEQCA9msqPissggLefM7ARzN3bRq/xCSPY0N9RsAeSgaKs9KGcEgxW7A7I8byogQpiuWpoVesYLsY=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1261.namprd15.prod.outlook.com (10.175.2.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Fri, 27 Sep 2019 18:17:36 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::acac:2542:7b0b:583c]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::acac:2542:7b0b:583c%6]) with mapi id 15.20.2284.023; Fri, 27 Sep 2019
 18:17:36 +0000
From:   Martin Lau <kafai@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf] bpf: Fix a race in reuseport_array_free()
Thread-Topic: [PATCH bpf] bpf: Fix a race in reuseport_array_free()
Thread-Index: AQHVdVPxyEcQqINYA0aChEzQ25OGv6c/xkWAgAAOt4A=
Date:   Fri, 27 Sep 2019 18:17:36 +0000
Message-ID: <20190927181729.7ep3pp2hiy6l5ixk@kafai-mbp.dhcp.thefacebook.com>
References: <20190927165221.2391541-1-kafai@fb.com>
 <04f683c6-ac49-05fb-6ec9-9f0d698657a2@gmail.com>
In-Reply-To: <04f683c6-ac49-05fb-6ec9-9f0d698657a2@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::26) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::5bdb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8801b61-b398-490c-cb3b-08d74376f95a
x-ms-traffictypediagnostic: MWHPR15MB1261:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1261168E8E564C4E63B97283D5810@MWHPR15MB1261.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0173C6D4D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(376002)(346002)(39860400002)(189003)(199004)(8676002)(6486002)(7736002)(8936002)(305945005)(14454004)(81166006)(476003)(446003)(81156014)(66446008)(64756008)(6116002)(54906003)(6512007)(6436002)(229853002)(66946007)(66476007)(66556008)(11346002)(486006)(478600001)(6916009)(9686003)(2906002)(316002)(52116002)(256004)(14444005)(1076003)(186003)(4744005)(25786009)(6246003)(99286004)(76176011)(46003)(102836004)(86362001)(5660300002)(6506007)(71190400001)(4326008)(386003)(71200400001)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1261;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F9hRuTIKqFUqgjgJuxRqLmAu7obrBfDi8vP2XuUy9nTiMWcjd9yZcoHTOavfNM/RXCHmPsQtGOL9gPN3Pc9zEjTUpwLJ7lWQMxhsrbeVn6SPetKhf0bpVHOG1hP7mNPcrgK34bn6PTCK5+4BaRRyUEbKQnG8K8KoSmGIe6RQryoGpRuK/AVm0biY7T62K2OGxLbr8iMLuE5IDJ/jnYk8r34AA135eAc4T29ohLMrvb0uzfq/S3hH6S1E/dVPOd5vrBl0RVCpw9PKHUwB594iWlHbADk1TYGohgd9LTMv6Rwd0pijCOTeaUEUldJUH+2KX5ogTdUut/sMYad5zorfrVeybJAU7Xg5NPR8d6E3KYxQSWzrwYcQZ+3BZFTv3PIVWP5Csr8ElU9Zph1asddktsZbIWd0h3KNUuCbH5PzBls=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <02158AFB47643949A4E8AD9F518417F9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a8801b61-b398-490c-cb3b-08d74376f95a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2019 18:17:36.8002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GdkQ+VwIV9n3sJVN9zLRgWS47lIsBOawhI9YCk3YyQQZ6sVqZvWhJuBM0/6802ut
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1261
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-27_08:2019-09-25,2019-09-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 clxscore=1015 mlxlogscore=932 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909270150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 10:24:49AM -0700, Eric Dumazet wrote:
>=20
>=20
> On 9/27/19 9:52 AM, Martin KaFai Lau wrote:
> > In reuseport_array_free(), the rcu_read_lock() cannot ensure sk is stil=
l
> > valid.  It is because bpf_sk_reuseport_detach() can be called from
> > __sk_destruct() which is invoked through call_rcu(..., __sk_destruct).
>=20
> We could question why reuseport_detach_sock(sk) is called from __sk_destr=
uct()
> (after the rcu grace period) instead of sk_destruct() ?
Agree.  It is another way to fix it.

In this patch, I chose to avoid the need to single out a special treatment =
for
reuseport_detach_sock() in sk_destruct().

I am happy either way.  What do you think?

>=20
> >=20
> > This patch takes the reuseport_lock in reuseport_array_free() which
> > is not the fast path.  The lock is taken inside the loop in case
> > that the bpf map is big.
> >=20
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
>=20
> Fixes: 5dc4c4b7d4e8 ("bpf: Introduce BPF_MAP_TYPE_REUSEPORT_SOCKARRAY")
Ah...missed that.  Thanks!

