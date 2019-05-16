Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5EF1FE89
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 06:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbfEPEiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 00:38:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38404 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbfEPEiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 00:38:21 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4G4Se6P016994;
        Wed, 15 May 2019 21:38:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=zRiJD+UnVUcp57f893/01mi+600DWx8fFzvhyROp5SI=;
 b=LnlXofNZ++hAk6t/YdrgTvHjiCIiX8Isdt9I+pf61x41UMZnTxZhZHm1N55cmpyXWrYN
 6YW8yGetGSwnJPEQL1WuAD2zJ+uYxzlP6k3rvYna8otnyqO4XPr4S2mrg11Z/MyHWXxk
 oINcfVeTkCnAeqEbcNa/LS3okwqsw3RJ1dw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sgsc9sdc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 May 2019 21:38:10 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 15 May 2019 21:38:09 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 15 May 2019 21:38:08 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 15 May 2019 21:38:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRiJD+UnVUcp57f893/01mi+600DWx8fFzvhyROp5SI=;
 b=BDwzbAOMcDC1PwMMN2E8NExIzsPWjHEhx3kfkbrdoUJtsT44JlKe+UhBJ9ESqu0HLvMNbCY8FodmfGWHdo9lqvWIofEO7TWMk1MXSkkE/35GB1Odgaf8WFwtkh3K1gzliKBBEstKegN1qrgVb7I+dvFdGP+mSOoAfBDT8zx+SJk=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1552.namprd15.prod.outlook.com (10.173.235.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Thu, 16 May 2019 04:37:49 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29%7]) with mapi id 15.20.1878.024; Thu, 16 May 2019
 04:37:49 +0000
From:   Martin Lau <kafai@fb.com>
To:     David Ahern <dsahern@gmail.com>, Wei Wang <weiwan@google.com>,
        Wei Wang <tracywwnj@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] ipv6: fix src addr routing with the exception table
Thread-Topic: [PATCH net] ipv6: fix src addr routing with the exception table
Thread-Index: AQHVCrex/r1lP5xDgk+ii1tsEqeq96ZsuxgAgAAlMYCAAADVAIAAS6uA
Date:   Thu, 16 May 2019 04:37:49 +0000
Message-ID: <20190516043747.fetcartssmclet46@kafai-mbp>
References: <20190515004610.102519-1-tracywwnj@gmail.com>
 <20190515215052.vqku4gohestbkldj@kafai-mbp>
 <CAEA6p_AA2Xy==jrEWcWuRN2xk3Wz-MqdPC32HtRP90vPH_KmhQ@mail.gmail.com>
 <6ab0f808-bcd9-0f6f-9d88-c1272493b6d9@gmail.com>
In-Reply-To: <6ab0f808-bcd9-0f6f-9d88-c1272493b6d9@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0003.namprd20.prod.outlook.com
 (2603:10b6:300:13d::13) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::d272]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4dd796f0-0f90-45f9-df18-08d6d9b84020
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1552;
x-ms-traffictypediagnostic: MWHPR15MB1552:
x-microsoft-antispam-prvs: <MWHPR15MB155259769B25EAA5A2163B12D50A0@MWHPR15MB1552.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(376002)(346002)(396003)(39860400002)(136003)(366004)(189003)(199004)(81166006)(8676002)(6486002)(54906003)(5660300002)(110136005)(73956011)(186003)(71190400001)(71200400001)(11346002)(81156014)(68736007)(446003)(4326008)(25786009)(476003)(486006)(8936002)(6246003)(64756008)(66556008)(66476007)(53936002)(7736002)(33716001)(305945005)(66946007)(53546011)(6506007)(386003)(102836004)(6116002)(66446008)(99286004)(76176011)(229853002)(6512007)(14454004)(6436002)(316002)(9686003)(478600001)(2906002)(46003)(52116002)(86362001)(256004)(1076003)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1552;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gWpxU2yN8NF/rFUc2mCE01hvQmoR00jYlk/p+hEe+lzCk3WwwF/15uappLCQScODm7wXfa5zmqPExNKHQ2xLldAE+PzcbYo8Eth+xkEKsMo+/edkg/LMUOPDnIY8PJR+lYRfEb2tl2TVqyM12HL/u5kc2lYzZZwoN7YCw9fiYc1AhSwh6g3rN4zmTYkgbf/wh3iihMCu70ZvYZx0uRc/Vf//+4K1N/BA8WKu4CLlj+G8+kzNktcvEroeDGco81ZwaAdfb1Wf6y4zdJ6peQBsqxd/dAekD1J9UODpBqTgivfQir/esAv5RfDHAvrnSSxKmq5mWKhrAfBawhcqMEIIDEUV46WAW6871copDF9INMxrRfu0dg7GQrXjo/NOVzWoTF3aNXYQsct9x3SEJdE2M3THV+uqfIu+j2rcuhotFmI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B4EBC907BA2C2D4FAC20E7408A2EA531@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dd796f0-0f90-45f9-df18-08d6d9b84020
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 04:37:49.6993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1552
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=680 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905160031
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 06:06:58PM -0600, David Ahern wrote:
> On 5/15/19 6:03 PM, Wei Wang wrote:
> > Thanks Martin.
> > Changing __rt6_find_exception_xxx() might not be easy cause other
> > callers of this function does not really need to back off and use
> > another saddr.
> > And the validation of the result is a bit different for different calle=
rs.
I was thinking other callers can pass NULL for the new arg "saddr2".

> > What about add a new helper for the above 2 cases and just call that
> > from both places?
That will also do.  I think it may even have less code churn
on the existing functions.  I guess the new helper may just call
__rt6_find_exception_rcu() inside with "saddr" first and
then again with "saddr2" (if needed)?

>=20
> Since this needs to be backported to stable releases, I would say
> simplest patch for that is best.
>=20
> I have changes queued for this area once net-next opens; I can look at
> consolidating as part of that.
Some of the functions have mutliple changes since then, I suspect
less code churn on these existing functions will make the backport
to stable easier also.
This bug has been there since 4.15.  I think it can take a mement
to do it now rather than later.

