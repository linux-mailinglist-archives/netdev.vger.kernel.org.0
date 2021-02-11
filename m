Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95146318B8F
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 14:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhBKNFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 08:05:50 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50438 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229939AbhBKNDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 08:03:23 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BD0LE8021856;
        Thu, 11 Feb 2021 05:02:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=7jevTLd8I/XReed1itMMtSAi1OdNwfdhsylXXojGYp0=;
 b=GBzvsUOj5QUv8nPn0OJo/qOYRcorF10PXsicC0lToKWo+cEQE253RycxpIdZvmMFqJc+
 auPAumjE1sd7XolBwvEcK8tJ5uh5E/0NEBKaJO8jp+sKxc92jJx/vGOi3hF3tXEYwBgG
 fj86l5dp1EyVJDYAF+nzCbaXJmcBDtSWvr7OGTaJSEPVfCRd5GcSOFIcTUDdH0DTYleb
 aBQFGmGN5emsE4RYQatAN14Ie6fYoOZ26SOMHTQ3ue4Pkx7nx6QPaarX6KSYMyN5bWrC
 DKwy+TaXSzyK3sR7kEHmk3w+feFYLIAB2R4HpA6uPHRzvxLxKfwhbPjiX/VrDTvGM0a1 Hw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrq17d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 05:02:19 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 05:02:17 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 05:02:17 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 11 Feb 2021 05:02:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUv4ewW0z4lk0u6HZ6yzPdNQUdYa3DT6+qisqb+7GktEw1LTTnordXdlliJtpn8KXNHGQUr7oq/uLaLOeh15kLMLSIlUGYs6ki23ojZoQ5m3E/22ny4FflDZhwlz9ThWA/i0z9Q91++8RVncSf9XfK3fcOHe0Dw1Sq8VKoOqsDsp29/azwnPwiZHrgrGCUXD7lqEzkqagC5g2C1ttQQRB4Z+JL/in5wFfVy9cML6G0OvR0NT0jVr9slRA447SaPO57MqhrsCgIyj5ybndHRxJHsYoIzZ9Z+b0jPwouBRhJhZE3d+IUqmR2c91tESqIBUftf9InUmV6e25ntncGWwgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jevTLd8I/XReed1itMMtSAi1OdNwfdhsylXXojGYp0=;
 b=BFMXps4TJVU8ScmHRN6zpIq+pv2/AP5ZrZQ5QGk2F6Sn2Nh2IalJaN8j/+Yi/5ShP3LhuTgTKJ1rl5Rao0OQiS57eCexrajEYlwInkZynO4gx0rTFLhfR8SzMuwhY1NRTQJg5wW21YoN4JLLU//o7Vuc8qZya0KnoCQcp7RteLje2drlFmN9PKLLtI+KADlzwQCUAKPPDf8iwNM/oOralO2UlsvszFBuc9DnSkzKUaZ+e8T6P/uf3jY/We3wyim3cqjkvhW7TQ7G6FHKwXJ+wMvteyX6hh5Yl7VE4l54+ZjqgAwCV3WJHspZF5NJHoXZFltAijAfy19sXR99H2oynA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jevTLd8I/XReed1itMMtSAi1OdNwfdhsylXXojGYp0=;
 b=axnQTgIWhxqG3/Z6nnfQ1KLYSTRxlvvKd6kFI4DV5dlSVHpOmLuGkLOArkTI2QueyqM0E1uEUw13Pot9HaSxgrXBSY0tVEvKKKDttks7sxgV5VObOcTFZ1NZl+/9BzyFmrAsISpYaI+UHoNmSYYmniVdgLOLRwDUNJ1PjHoJ0v4=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR1801MB2014.namprd18.prod.outlook.com (2603:10b6:301:64::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.29; Thu, 11 Feb
 2021 13:02:14 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3846.025; Thu, 11 Feb 2021
 13:02:14 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [EXT] Re: [PATCH v13 net-next 08/15] net: mvpp2: add FCA RXQ non
 occupied descriptor threshold
Thread-Topic: [EXT] Re: [PATCH v13 net-next 08/15] net: mvpp2: add FCA RXQ non
 occupied descriptor threshold
Thread-Index: AQHXAGQGVCHIIa4Rvk6qmqO01DA+oapS6BOAgAAC4AA=
Date:   Thu, 11 Feb 2021 13:02:14 +0000
Message-ID: <CO6PR18MB387356BB83D26789CA8B17E9B08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-9-git-send-email-stefanc@marvell.com>
 <20210211125009.GF1463@shell.armlinux.org.uk>
In-Reply-To: <20210211125009.GF1463@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.25.16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0998c23f-921c-4361-8f98-08d8ce8d409f
x-ms-traffictypediagnostic: MWHPR1801MB2014:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB2014AD677CB8B7B76B5270E3B08C9@MWHPR1801MB2014.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +lwOhtIe/OJc66deFuO5m9wi1tJG58rccjVoCy7smS+dFTWXJk26ZEUH8QrTbgHHa9KYpf+Y9uDdebfScR9uduioNYCyOE1SU23zQZGiOymOXnZyyrTtp6BYtf+dagPvke7ziz6E2tApU0uW0kGI4kQr9c6+PtxCw8e+Q9XFcRyoaJGvZMGJ68zY3QZw4rDFbI6NGokRXeW5Ws1ttiNYqt3v3oeaYMPV3Z701OHFGpH09UGG34dcoLMF7Cj4hflh4k7ylWb2JK1u0MSWfKV0JYrXYaqdE18UylW95g93i5pki+tKkr94vXdWY7RWNzOPh3Is50ccCPoX0mU/VC3Qk9vRXDNb4OHNcbx+zU0A6rTLuBCvpIEzAECZMYfmcpqPgDX6CCh6i2oeG1iZQXiOPkQTqrHNw5TazGRDPxCT1TyAR2VJ4WzqJDpkfMH54pPpAOWSed59tZeKpa3cL6qsrjm9IlcCTlzgk7wUDYZaxVKLM3q2QhXpPe2TRobB6aXRembyAVrY3q/Z/d8+snFAkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(66446008)(66556008)(66476007)(71200400001)(64756008)(2906002)(26005)(6916009)(6506007)(33656002)(7416002)(8676002)(66946007)(53546011)(316002)(478600001)(55016002)(4326008)(83380400001)(86362001)(54906003)(5660300002)(76116006)(8936002)(52536014)(9686003)(186003)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?fCO8BNv7Ck1WgnqMx4HPuj8znEMw8HHdICFkMRId4af9wH7Vq4yESv+v8Zvb?=
 =?us-ascii?Q?kDerftymSX+/sAU4XWzJIGX+4yjsUCRqqM36vFOmx9zeTb/HBoOGy/VZ5ZX+?=
 =?us-ascii?Q?l/PcLB9CQIjaZPxx4bVge/wvTp2z27GJMM0yJuh45NWOY4th6OPYjY1AHI+9?=
 =?us-ascii?Q?dDVIR32uwle02uiXFIy6M+M3c5m2T2oOmMb/w0Rb0TpOi3CCUkLSdIOfCLTH?=
 =?us-ascii?Q?bOCAVuG03BpCLxHraURlMtWuxdKu5V9EAiktBaoxnLAYPms9w6RhF1jk5rDD?=
 =?us-ascii?Q?D2NPBxSylJslBOnbwPrNxXAaXKn0KcZuP9WiILLRTMbxFQmJensIEuKSuERu?=
 =?us-ascii?Q?MyzizWWGf5XFrbDdLDIL/Idxul1dDOnmnad6K8lB5zoEJluBfm46+T3Ah8YZ?=
 =?us-ascii?Q?eVJnM75KVWp4DuHFHVv8l6iu2aEK9C8p7dTtJBFMOd3EkGZ/LjOEo54LP3KI?=
 =?us-ascii?Q?fzSlcYTtRIXXU3iOBRcpWQ5Ha5YJDOSspry9Rglej5AsDVYn/mE1Gmof4Kqf?=
 =?us-ascii?Q?zkZS46tYGmVQ/mHO8gMWvLi6uQCM/sgY9ovhj8yigbTQRLij5QjfgqzXHSu7?=
 =?us-ascii?Q?gCh9bSdH/LupnxNkf/OnCour/+Dc/x5g73BHmcpJPkDRKRFUJzKopDIvl/Wp?=
 =?us-ascii?Q?N+QnVIdSeja1y/0SpDJF0kpxYjl7W8ALWDuGpyjQwHyZo1XCcs40yze9O8gr?=
 =?us-ascii?Q?kxd6WG2W62GntDeOxSAryR05rLLYtaDu+Cd5a3+2dPZbvSq4iXzfHqsUaQQ3?=
 =?us-ascii?Q?Kju9L2dNJizG1iNuc8dmMibfEYh1Jk/98NOoUtFpPrpxiWpFECiFrOKcChKW?=
 =?us-ascii?Q?GfncVE8t2jVGnOGux0/60HbnVdmTe5MZkYN4eLqsXZJefJTwsUSnd44o7Jnw?=
 =?us-ascii?Q?+HFhiAoBBCgvHNcHHvNz+QiNSB1dwaniywbqiIBwu3v+nwY++rkJ1aiZUw+Q?=
 =?us-ascii?Q?5zoJV9yPaR0vZu2H7nmprsOgjWuOMPjVaZbfX1ZtDEBvleJje6pNBTIE+NyQ?=
 =?us-ascii?Q?QCT9YOnRiL8B7PT/+DU06r0KUoPOqQWpgAMLRT80o6U3urrsd0FR27VqAdBW?=
 =?us-ascii?Q?DPwnTVjhVBmLmUe6Mt7r1nyu54IA/fTwfkFPRLnH1xwKMAlJLhwFADK7tO6/?=
 =?us-ascii?Q?MGeTO+5vqxsbhNFBF+I+BxNwRJmlEXxs3/rZ8w0PZQfvwhJj49xDYuGLKEbD?=
 =?us-ascii?Q?rr1KERrBOu52/LmHFSqPQrtg2JV+Seo0XCVeIAgnTzoeHq2vlVvLN9xEazrG?=
 =?us-ascii?Q?V8WHe7+z68Bz2Wvuy3u9S9zEK5p96zM7ha9VGHYQ87eQWN9CR61/mdm3p9YJ?=
 =?us-ascii?Q?3FU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0998c23f-921c-4361-8f98-08d8ce8d409f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 13:02:14.1460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fZtkZumKoqIc52MfbeV7dQsqY9xzgRn7YlT0nkmCOQR9jGVspb4JZUt7gxxxk9cWXicgnQflcetfYkkMlph2EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB2014
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_06:2021-02-10,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: Thursday, February 11, 2021 2:50 PM
> To: Stefan Chulski <stefanc@marvell.com>
> Cc: netdev@vger.kernel.org; thomas.petazzoni@bootlin.com;
> davem@davemloft.net; Nadav Haklai <nadavh@marvell.com>; Yan
> Markman <ymarkman@marvell.com>; linux-kernel@vger.kernel.org;
> kuba@kernel.org; mw@semihalf.com; andrew@lunn.ch;
> atenart@kernel.org; devicetree@vger.kernel.org; robh+dt@kernel.org;
> sebastian.hesselbarth@gmail.com; gregory.clement@bootlin.com; linux-
> arm-kernel@lists.infradead.org
> Subject: [EXT] Re: [PATCH v13 net-next 08/15] net: mvpp2: add FCA RXQ non
> occupied descriptor threshold
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Thu, Feb 11, 2021 at 12:48:55PM +0200, stefanc@marvell.com wrote:
> > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > index 761f745..8b4073c 100644
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > @@ -1133,14 +1133,19 @@ static inline void
> > mvpp2_qvec_interrupt_disable(struct mvpp2_queue_vector *qvec)  static
> > void mvpp2_interrupts_mask(void *arg)  {
> >  	struct mvpp2_port *port =3D arg;
> > +	int cpu =3D smp_processor_id();
> > +	u32 thread;
> >
> >  	/* If the thread isn't used, don't do anything */
> > -	if (smp_processor_id() > port->priv->nthreads)
> > +	if (cpu > port->priv->nthreads)
> >  		return;
>=20
> What happened to a patch fixing this? Did I miss it? Was it submitted
> independently to the net tree?

Some reviewers asked to remove this from the series. I would send it as sep=
arate patch to net.

Regards.
