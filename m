Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4229925AF4
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 01:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfEUXwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 19:52:47 -0400
Received: from mail-eopbgr700088.outbound.protection.outlook.com ([40.107.70.88]:28128
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726434AbfEUXwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 19:52:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stackpath.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXXOQhsgg5LPvRdht5kSoMp26m2VTfh23n8+xQGUTog=;
 b=cMPtQOlyl0fyrtSmjvF+c14TFYtQLO6qTTDMUhyJc1McMcD388DqCNJDwP1hOu3QxqWif72g6TkSYKA8cXlaTIvn21/sOsiC0tV8qbelbilsdL7ZQqH0JLPhhmKyW0ypNUf1OqmQLkYFhsn4qNaDnMmOBJmoy3WzuV+AgbI6fGA=
Received: from BYAPR10MB2680.namprd10.prod.outlook.com (52.135.217.31) by
 BYAPR10MB3429.namprd10.prod.outlook.com (20.177.187.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.20; Tue, 21 May 2019 23:52:43 +0000
Received: from BYAPR10MB2680.namprd10.prod.outlook.com
 ([fe80::ec8c:9c6a:c83f:43db]) by BYAPR10MB2680.namprd10.prod.outlook.com
 ([fe80::ec8c:9c6a:c83f:43db%7]) with mapi id 15.20.1900.020; Tue, 21 May 2019
 23:52:43 +0000
From:   Matthew Cover <matthew.cover@stackpath.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Matthew Cover <werekraken@gmail.com>
Subject: tc_classid access in skb bpf context
Thread-Topic: tc_classid access in skb bpf context
Thread-Index: AQHVEC09Nj6ajF14HkezzoiQKGhG0Q==
Date:   Tue, 21 May 2019 23:52:43 +0000
Message-ID: <BYAPR10MB2680B63C684345098E6E7669E3070@BYAPR10MB2680.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=matthew.cover@stackpath.com; 
x-originating-ip: [24.56.44.135]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3918b74-848a-47d1-c15a-08d6de476a8f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR10MB3429;
x-ms-traffictypediagnostic: BYAPR10MB3429:
x-microsoft-antispam-prvs: <BYAPR10MB34291AB998FDF23F58C62129E3070@BYAPR10MB3429.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0044C17179
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(346002)(39850400004)(396003)(136003)(199004)(189003)(55016002)(9686003)(66066001)(26005)(44832011)(102836004)(99286004)(7696005)(71190400001)(81166006)(81156014)(8936002)(8676002)(53936002)(2906002)(7416002)(6116002)(6436002)(2201001)(86362001)(2501003)(71200400001)(316002)(305945005)(7736002)(3846002)(4326008)(478600001)(68736007)(186003)(74316002)(76116006)(66556008)(64756008)(66476007)(73956011)(66946007)(66446008)(14454004)(256004)(14444005)(5660300002)(52536014)(486006)(6506007)(25786009)(110136005)(476003)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR10MB3429;H:BYAPR10MB2680.namprd10.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: stackpath.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wkBwGHbzXDI8/GbNp6m8b1WWwWNrsFaIMYPdMWKw3EaYi3vV5NnbIp+6pN7HGVve2/e5UUrCkAT+jbldZSifdszr1ToelWDKvjuu/+CpTQSX0raGNZ/KMdjYgrugNMZjbrb5Hs3uvCsAYM3oM547GB61vhtVMbf5l4/MPAHYwMR3JtXe9a8zL+U5jCK0pEf9whdChIspzY/FAF6F/rCqwwKV8/ZE6YO+MphvgJF8LtNMQCu80iFFbncanRfEquNR6VWxgkJkfdi+Axei4L515pnVBZceRXEj8u0pmOkF06z+jjhmhH4zyltbyXV+KEgxd13ATPC3oIq8ZhtymNYlkD8z2Vdp/mhzaKGcuSpmGCY1NzBWRSClfSa9HY+zal3NRjc5hYE6zcIGc8DMMx2PwO7SDCUoUckMaz0V6fonA+o=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: stackpath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3918b74-848a-47d1-c15a-08d6de476a8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2019 23:52:43.0494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fd04f7e7-8712-48a5-bd2d-688fe1861f4b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3429
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__sk_buff has a member tc_classid which I'm interested in accessing from th=
e skb bpf context.

A bpf program which accesses skb->tc_classid compiles, but fails verificati=
on; the specific failure is "invalid bpf_context access".

if (skb->tc_classid !=3D 0)
 return 1;
return 0;

Some of the tests in tools/testing/selftests/bpf/verifier/ (those on tc_cla=
ssid) further confirm that this is, in all likelihood, intentional behavior=
.

The very similar bpf program which instead accesses skb->mark works as desi=
red.

if (skb->mark !=3D 0)
 return 1;
return 0;

I built a kernel (v5.1) with 4 instances of the following line removed from=
 net/core/filter.c to test the behavior when the instructions pass verifica=
tion.

    switch (off) {
-    case bpf_ctx_range(struct __sk_buff, tc_classid):
...
        return false;

It appears skb->tc_classid is always zero within my bpf program, even when =
I verify by other means (e.g. netfilter) that the value is set non-zero.

I gather that sk_buff proper sometimes (i.e. at some layers) has qdisc_skb_=
cb stored in skb->cb, but not always.

I suspect that the tc_classid is available at l3 (and therefore to utils li=
ke netfilter, ip route, tc), but not at l2 (and not to AF_PACKET).

Is it impractical to make skb->tc_classid available in this bpf context or =
is there just some plumbing which hasn't been connected yet?

Is my suspicion that skb->cb no longer contains qdisc_skb_cb due to crossin=
g a layer boundary well founded?

I'm willing to look into hooking things together as time permits if it's a =
feasible task.

It's trivial to have iptables match on tc_classid and set a mark which is a=
vailable to bpf at l2, but I'd like to better understand this.

Thanks,
Matt C.=
