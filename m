Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76DE0E6F2
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbfD2PxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 11:53:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35322 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728572AbfD2PxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 11:53:10 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x3TFkohv030157;
        Mon, 29 Apr 2019 08:53:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=uG8hGJPPtXzhrIiPBvXaUpPDqrMSaP5lEi/fJoz3d48=;
 b=LoeVJc2iQ+K61EhXHGKhqqCWJVySOwaWCQWq9F8rL01B1zNREzyaBJwELyTO1wZC1kpH
 f16VwcD3MgeLnnaKmteVqpCPmK4ka1S5rUPGv59EUZ3fT6b2ReezxS0LQ5Wrw6m20ShD
 9chD54rT6pOq9NrbuLaclFM7yrfdOXT5L9w= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2s4jrcdnyw-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Apr 2019 08:53:06 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 29 Apr 2019 08:52:50 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Apr 2019 08:52:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uG8hGJPPtXzhrIiPBvXaUpPDqrMSaP5lEi/fJoz3d48=;
 b=DtGmLhDB95E3jNVVaw1ud6zvSSAA6et4Tf2+eHZp5rGl3BfBg6PtGWGAT6CSsAvswVHVm1okr0ZwbKR5rphGHwg6m+jbv9XQPkTmDAhLT0GAKzDylbGde/YqP7TVf0PukKLAyU3czi5wtC57C9JLYh77kdsyLu9upOPWAFfSb8U=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1183.namprd15.prod.outlook.com (10.175.2.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Mon, 29 Apr 2019 15:52:30 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::d13:8c3d:9110:b44a]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::d13:8c3d:9110:b44a%8]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 15:52:30 +0000
From:   Martin Lau <kafai@fb.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net] ipv6: fix races in ip6_dst_destroy()
Thread-Topic: [PATCH net] ipv6: fix races in ip6_dst_destroy()
Thread-Index: AQHU/ffJW8wEka6m2kSKbFu9ObtexKZTSyaA
Date:   Mon, 29 Apr 2019 15:52:29 +0000
Message-ID: <20190429155227.etjcgwss6vqgutss@kafai-mbp.dhcp.thefacebook.com>
References: <20190428192225.123882-1-edumazet@google.com>
In-Reply-To: <20190428192225.123882-1-edumazet@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1201CA0008.namprd12.prod.outlook.com
 (2603:10b6:301:4a::18) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3a1a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ed3eddf-6ef1-467c-03e4-08d6ccbaaefa
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1183;
x-ms-traffictypediagnostic: MWHPR15MB1183:
x-microsoft-antispam-prvs: <MWHPR15MB1183385FC6BCFA85FFD8697CD5390@MWHPR15MB1183.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(376002)(346002)(396003)(366004)(189003)(199004)(4744005)(316002)(54906003)(6512007)(9686003)(6116002)(81166006)(6916009)(81156014)(478600001)(5660300002)(14454004)(8676002)(229853002)(99286004)(76176011)(97736004)(66446008)(66556008)(66946007)(73956011)(66476007)(6246003)(52116002)(71200400001)(71190400001)(2906002)(86362001)(53936002)(25786009)(64756008)(305945005)(4326008)(7736002)(1076003)(446003)(102836004)(486006)(6506007)(386003)(476003)(11346002)(186003)(68736007)(46003)(256004)(6436002)(6486002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1183;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CdwyUnEUbq4ctUCyBWLT3EWeTZZwqM80R9tOviQibJRJMEa1Qn51HJNIXAYbAwt2jMrgzzJneEwe+1v8JfLpVq/VYSilRxNJEVYHyhrljk7EsMWD7WIoFJEOcYKXPojMZF0lli1JvAjmF1A9i/pBeitc9rtpHbkFWf+Y8luvJ2MwRCjxpYc35l8NVN3Q0HItQNdUlmqwlnr9t4Yzxa3Jng4yOgzlunGLOcIwEopnD2sNiaXgVi1ulZo9VPooU5+VN9fkBHdRakpRN+tE9JHC5maiL82gb73VytYhJoYyfztJT6+6tJAKFFpWqCAZA3Lx5Tugj+VQo5Gw7AfCIdUg8xUiuOLVAMm3phIEbqaMp7AyktAxMDG+V89R9QL/XXqZTnpKPjOKTg5O5EXitYJkKUeTzLS+w6TL7M/njAbhSn8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1E41FF3E75435143ADF7FF94517F4528@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ed3eddf-6ef1-467c-03e4-08d6ccbaaefa
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 15:52:29.9794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1183
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-29_09:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 28, 2019 at 12:22:25PM -0700, Eric Dumazet wrote:
> We had many syzbot reports that seem to be caused by use-after-free
> of struct fib6_info.
>=20
> ip6_dst_destroy(), fib6_drop_pcpu_from() and rt6_remove_exception()
> are writers vs rt->from, and use non consistent synchronization among
> themselves.
>=20
> Switching to xchg() will solve the issues with no possible
> lockdep issues.
Acked-by: Martin KaFai Lau <kafai@fb.com>
