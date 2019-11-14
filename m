Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABE7FD185
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 00:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfKNXY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 18:24:27 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45498 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726912AbfKNXY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 18:24:27 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAENO5Gq021943;
        Thu, 14 Nov 2019 15:24:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/26LI4BGKNV6QVdJuVvE9rEI+PnYUekvh9WsZLlVLkw=;
 b=TH7sY8yOqxJb6KXLKxj9BEGaEwQVnu54g3pG0QIW+LqPeOSAXa+NU9uipChs8Vg6rPbZ
 WMaORKLie9F+zboKhPPiNjSdTD/n7svPl2ybKc1j7EReAf+F5ejTSbwa48MsRBGh+JDn
 1Y4e/EbY7FwGN1+P1VVoJTcx2lfuhIZOGAc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w9bjvvhda-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 14 Nov 2019 15:24:08 -0800
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 14 Nov 2019 15:23:52 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 14 Nov 2019 15:23:52 -0800
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 14 Nov 2019 15:23:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yx2DiGJ8diKI2/eXnACtU0+goDcr6Y1GvyAxM9soBD+hBel4EYb80bUsk/86n4jRoZZIHG1pQsQwtmq9BPhYQVZcbJmWP45TyQjLssx3/27FtjFXdBErNie1oL468GuzjEAU3pJK8u4zdEi5YiOqfOx+B/nwcpOWPSBHiUb2a/TL9PAIiQp9rMCScSg9ok/7qc8xxcz7PHjy+pWIXKwLo5KmhLqNoIhLMIjHQKoJ0gFaaOB9K9WWP9r4UnqSlOVJ2qDwlhkPjhTjQWHzoB3BgwG6UxB2sIHdu3l3tdz8iqN/MUeFFC6B/NKxvX8+dFEYqGaYiImTMbA1/r+FfFG0Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/26LI4BGKNV6QVdJuVvE9rEI+PnYUekvh9WsZLlVLkw=;
 b=kGIeE4Tp05+kFyfLkxCIBQsufG9yLYDlNuRM6YEGE27EQGh3U632DymBGAr107Zg4vPdZYN6ZROsaeB1rKt7Tm2bKKO1F+J6TIaVp/iOogUQU0KEwJzbu3nFOTNZJ3lxdwUkwZeKhbp43KrwLl6FaZq2ndr65knbtnQVRziFG7zjAZ4uaMKZoUZV1v69qKGjNbyDkD9JWGesl80+sINq0LPxVhewzQof4py6fI3573VkmZa4Nls6unbIEOex/4zxQoMpSPdNzN71D4rkjzuELPhUHNMrO5IO+mCVyC8Imbo5LMxFvHyR4yKwBIN8fv5E2u7tJm+aUdggOk9GruANOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/26LI4BGKNV6QVdJuVvE9rEI+PnYUekvh9WsZLlVLkw=;
 b=Na0UfIT6Qbq9yeZdqHAwBRbM0v9hJQyAfWy9EYne30KE/9QbdBj2cVBfSOOE5nyX6iXEJZaAsgKd+QBvgW0oc3RzANvI74IiGQD5xh0cY/ryanavqzj1LC10IkWwtRF1mpKjmqtr21/vsXUUD7nE9wTKLpAzusddZ+YsmTB8Odo=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1919.namprd15.prod.outlook.com (10.174.100.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 14 Nov 2019 23:23:51 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::f831:d112:6187:90d9]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::f831:d112:6187:90d9%4]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 23:23:51 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 15/20] bpf: Annotate context types
Thread-Topic: [PATCH v4 bpf-next 15/20] bpf: Annotate context types
Thread-Index: AQHVmx12SNoDMBP720G92P3g3yLwPaeLTukA
Date:   Thu, 14 Nov 2019 23:23:51 +0000
Message-ID: <8D70C347-697F-42BD-9FE4-97944884C20B@fb.com>
References: <20191114185720.1641606-1-ast@kernel.org>
 <20191114185720.1641606-16-ast@kernel.org>
In-Reply-To: <20191114185720.1641606-16-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::3:e9ac]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67c71c4e-35c5-4fb0-7de8-08d76959b5b0
x-ms-traffictypediagnostic: MWHPR15MB1919:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1919F3C54B2C09075EECFF4FB3710@MWHPR15MB1919.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(39860400002)(136003)(346002)(189003)(199004)(8676002)(186003)(102836004)(14454004)(5660300002)(305945005)(71190400001)(7736002)(71200400001)(14444005)(256004)(6916009)(25786009)(46003)(6512007)(2906002)(4326008)(81156014)(4744005)(6246003)(33656002)(11346002)(6486002)(316002)(99286004)(446003)(6506007)(76116006)(76176011)(66476007)(66946007)(66556008)(476003)(229853002)(478600001)(64756008)(86362001)(36756003)(54906003)(8936002)(6436002)(2616005)(66446008)(6116002)(81166006)(50226002)(486006)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1919;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sm0CU6wCgZuS8dJyb6WGbQd7oDWME192Fh3C+luySOSScjzfx4tWPlbYKEEDsH5tunNFhl9jheXUZaEbLS/NxW0poCX/q4kN/Qs+NIc0773IFDReA1/Y2CXGuGDbw7eiRmdkKnkaPE3HYomzQew7MrSuhEpSve1ufqT5oR3uhCbp3YzaFTXDZ5USJyIqEMMsuFnPdVTnAjP1cM/YN9QacByYgZ23tTt40RIKfqb6dhqdVPEcvHX8XBaBJAMbKB7e4wh2YuS1jW2hTj5EK1PVfTATKeGDvGwHVTZbJL52feXqq53EaGczn2BddeBso2RxXDqtwlj2Pu8eEjnxXv/65NlzdC0jSMu08lGDbWdRZ3Dn6rzr5hB7idxsLqvJzKYmBXCiQTo7/9gh++zfYbxcEDbVkvjqdHyYQqva46Ie6JLKKN+R5z56tBYBpL0pUOCt
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E8842ABE82750C4AB655249CB8B538C1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 67c71c4e-35c5-4fb0-7de8-08d76959b5b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 23:23:51.5903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CEb5H2cPCNbDqpbHH6I7DkjCoZuuvZu8AjOBP7E9Da31vQ6W9OTwlzRsn6eXpmZA/KPm6pB2hLjg5h2kgTUDdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1919
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 mlxlogscore=847 malwarescore=0 priorityscore=1501 impostorscore=0
 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911140191
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 14, 2019, at 10:57 AM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Annotate BPF program context types with program-side type and kernel-side=
 type.
> This type information is used by the verifier. btf_get_prog_ctx_type() is
> used in the later patches to verify that BTF type of ctx in BPF program m=
atches to
> kernel expected ctx type. For example, the XDP program type is:
> BPF_PROG_TYPE(BPF_PROG_TYPE_XDP, xdp, struct xdp_md, struct xdp_buff)
> That means that XDP program should be written as:
> int xdp_prog(struct xdp_md *ctx) { ... }
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>=
