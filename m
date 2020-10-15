Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFC928EE7C
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 10:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbgJOIaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 04:30:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14902 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726996AbgJOIaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 04:30:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09F8PXNF006538;
        Thu, 15 Oct 2020 01:30:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=Zjj4tXKPxeaArO8+zyZgh7yKYuf0f1jxiWTaq0Ib2ns=;
 b=aPkgSELC9GxhQBHSnSS7Y0ajl8MpixWRybduVNheiRAINZxcMkps5FJQpHrbmw7Uhrh9
 1cb0HWqSyk5pZykySrinv6DTnQG5RndRyrkOesNNPUvRrE17odbIjwv1gzE27DqZlZkv
 867IGbiH5VskyDIA8JkffN3iPKTvHeKcrlUeTwHBNF79LNoVtJf48qb10ZdW0Q59G+sj
 NL3xp7l0FH8zab0eL8y78BDjHqdMJXABEb+sA2bpUfGw0TUA4Le1/XOjKkhl0afuJbip
 JvUv2wvF0POaezWblC5kxnMilxhbwm5Dm0jmeTUnqfsC3hr3QXB9XZhKt8wb5KipDA2N tQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 343aantx59-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 15 Oct 2020 01:30:06 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 15 Oct
 2020 01:29:34 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 15 Oct
 2020 01:29:34 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.53) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 15 Oct 2020 01:29:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AN0SeM72shWxHjyF7MKCivPWQhaf78+45EN0yRcrK4fZNCHzGXpP2r/n16jAIFi1uFC+4ySg2YvQhwbUGk+cXCUYvwkYXi9OUrRFv6wW7PSw1FMk/nksW7rUr1xSA03g+ecdPUH6f99o6EWQgSUvGKmg0pOiI80moCLlAqnApW+bUoYFp6YxahKJpyDS9eNYIU0GQjPYPTx7xdDkH2rHWZVEddfJ4HoLUoAuskVdVTp37GpCbh8JXFruSosIo4ntWo7weB6z4ow6PiweTpS2W4FsCuSQLmCfI5cXn1Gzh+LSh3tkc80/PlOsakioO/bBGudcq2K/7vOB8uDzgkRU0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zjj4tXKPxeaArO8+zyZgh7yKYuf0f1jxiWTaq0Ib2ns=;
 b=RjBYIrXGG2RfGK6QphYdqbksRCFBlDTS8Z6zbtfi8RtGUpEh/gYbNrALn/OpbQMj88B5cshs5icsMf+DjtNAb2UvWlK8m0Z5Thd2PsatZO0laAI8Fc8s2BNuJgKz+qQ6KcCtHbKGshuyFv47EAcr5x+wYMrRRJDD7FKBDt1WK/wekvmMh6EA/xMOEEqM1wiXuT5KHIfvVsNAsfAApkawi0SeAaFuq5Fg/WLALFcwTRL0IDB0nA0kPJ7T/c5SoDkfv1XZHvHWJSOcEmh2PNojyGMRqsgG2HKzWSPv3YiA4+90/eoe49ThR8kcFZDKwSJQtqWvEO9GiHHSMcPF9k/Qfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zjj4tXKPxeaArO8+zyZgh7yKYuf0f1jxiWTaq0Ib2ns=;
 b=QF8J/DFUz90p9Pm0QdtjUseOvRnKaghDzys3WfHui+7OE4MxUvR3ZZslnqPlD+OZbVzHDPFJGAog3uPHM+LP3kBdB/VdKQuuyKpBdSbixcIAYZBC1zuCimxrzLYtjSwxvZyJisZm17EW9JK6scliKuBuLYSiIwhWIreCITcQUFc=
Received: from BYAPR18MB2791.namprd18.prod.outlook.com (2603:10b6:a03:111::21)
 by BYAPR18MB2661.namprd18.prod.outlook.com (2603:10b6:a03:136::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Thu, 15 Oct
 2020 08:29:30 +0000
Received: from BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::68cb:a1a3:e1cf:f9d2]) by BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::68cb:a1a3:e1cf:f9d2%5]) with mapi id 15.20.3455.032; Thu, 15 Oct 2020
 08:29:30 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        "Narayana Prasad Raju Athreya" <pathreya@marvell.com>
Subject: RE: [EXT] Re: [PATCH v7,net-next,07/13] crypto: octeontx2: load
 microcode and create engine groups
Thread-Topic: [EXT] Re: [PATCH v7,net-next,07/13] crypto: octeontx2: load
 microcode and create engine groups
Thread-Index: AQHWoIa6AHfVkGFIKUGTzj17hQ9DR6mXzPkAgACLdzA=
Date:   Thu, 15 Oct 2020 08:29:30 +0000
Message-ID: <BYAPR18MB2791FBC1851E0488FE328FAEA0020@BYAPR18MB2791.namprd18.prod.outlook.com>
References: <20201012105719.12492-1-schalla@marvell.com>
        <20201012105719.12492-8-schalla@marvell.com>
 <20201014170622.6de93e9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201014170622.6de93e9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.96.19.165]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c6b5807-52ab-47c1-7fe2-08d870e46fd7
x-ms-traffictypediagnostic: BYAPR18MB2661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB266196753B21C5D440239A62A0020@BYAPR18MB2661.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oMgMRr7vGVtgE6fn2RvaP5pXkMH/MyYeLKURW7ORDzZrARuo1A4t1PFRSKdJBUSlyt+tknyHuLVlnpbgUwqfIfktjZHUCOt5dH7DgWP0E1s7ZzL/gvDuUg5SsH106IUsdmVodNPmxyvJIPgGgDRQ79mhSuIjfeHoUHo0i+Xu0Ha/643VCVXZSZOP0c4kEEDn6TLz4moax/MQ6VhC5X+WP2VVr5Zu7FINat3Kl/uHUd99bmuB2KeainqNBJDxlsIdNRKxnwKRgU1HofWdRrd1yP1EQLCj5rqI8OAVB/g1wwZuQKDySbb0Y9EZx0eQTElTmj3doODPprFaKzwJ4f8AfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2791.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(76116006)(66946007)(66476007)(66556008)(64756008)(66446008)(478600001)(83380400001)(52536014)(316002)(9686003)(55016002)(54906003)(2906002)(4326008)(86362001)(6506007)(186003)(26005)(8676002)(8936002)(6916009)(107886003)(5660300002)(7696005)(33656002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: RzD3z1WlFrp+Ec9dRLVjCKgCnStcwqms9c+arQSw5dQXqBriFr9cbmahjCIkJoimYLiMRRl4EiPvTQBKEkAwGLuz05WclyB78HQvnl49NQhzqk+yNSmCvLb4u708i8PbPUQ60nfisGf+KUX44k/DH46i6SloBzNiDea4mGyXKozriSkiLYhXBClkLhGlO1woj6e/xLNQFbvw2yKFNZAcHJf+ky3PC1+8a2d+uwoh8iT/EYrQ//YH8c+dWP3EIsPFP6PP2ikMrHML0vkr7yoqWVIvSWljPfTFz44CckMmAG/myFIk8BC9qtmhu4dfeh5t0jAcsp+D2giA+t6UGFcJ7V/A0xXUSt/z2+8t9sGhLL/4LMNFvQ7EihYOznsB3SwVPfAxIcV5L18tK40Y4NTed0eZikpS+T39iYbCcy2/dWRZJP9RG8TNwrPbr8Jpc660V3sjRtH1YO7L6Te1Si9k49TbxXnta9cS58+HtSI+KdYiy7N8uXs4hPSEdSwX3TddpVp/GbXmPRydlu2Qrc8aKqlU/Px0IxgQt+iSGGDnzuSv5hi+XEiecE0SeqDTe+36uI2KCmV5pWAhrr9dQtgXniCJbdWkUPsjNCwNrBzPc7K2jBCTNdtof/AvY6NNdP+gSotjzOYYXOyUmjYIArMOQQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2791.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c6b5807-52ab-47c1-7fe2-08d870e46fd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2020 08:29:30.2854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X+nS1b33vbNsCEzF42w5IYFrTbjrmLz1F2uyXp+yhkGwc73RoJ1svlFvY3ght6HIdyY28Uo9Fg9PmvhKhyfOxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2661
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-15_03:2020-10-14,2020-10-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [EXT] Re: [PATCH v7,net-next,07/13] crypto: octeontx2: load micr=
ocode
> and create engine groups
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Mon, 12 Oct 2020 16:27:13 +0530 Srujana Challa wrote:
> > +/* tar header as defined in POSIX 1003.1-1990. */
> > +struct tar_hdr_t {
> > +	char name[100];
> > +	char mode[8];
> > +	char uid[8];
> > +	char gid[8];
> > +	char size[12];
> > +	char mtime[12];
> > +	char chksum[8];
> > +	char typeflag;
> > +	char linkname[100];
> > +	char magic[6];
> > +	char version[2];
> > +	char uname[32];
> > +	char gname[32];
> > +	char devmajor[8];
> > +	char devminor[8];
> > +	char prefix[155];
> > +};
> > +
> > +struct tar_blk_t {
> > +	union {
> > +		struct tar_hdr_t hdr;
> > +		char block[TAR_BLOCK_LEN];
> > +	};
> > +};
>=20
> In networking we've been pushing back on parsing firmware files
> in the kernel. Why do you need to parse tar archives?

We have 3 variants of crypto engines and each uses a different firmware fil=
e. So instead of 3 independent files in /lib/firmware, we have a consolidat=
ed tar file. The tar file is a container.
Minimal parsing of firmware file is required to ensure parity between engin=
e, firmware and driver. For example we verify version compatibility.
