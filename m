Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A97333433A
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 17:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhCJQit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 11:38:49 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9706 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229546AbhCJQiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 11:38:19 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12AGKNEh007712;
        Wed, 10 Mar 2021 08:38:02 -0800
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by mx0b-0016f401.pphosted.com with ESMTP id 374drr3x68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Mar 2021 08:38:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mMRamhcXTBHVDv2Yo2oO1XJZwCQqy+DQvmANIjCfJxUI4iWCAMommmQgjfeQODaiPyiA3gTn1fnP1vVB5+iMxpFNIIUAe2t/M3otCU+YRMFmV1gjjgfp/wVctQP6flhsx4Q78Y2RM39MMgRK0xPgUmB+0yDMx3CR5+f46tr5+Adl0LmFW06xBMBlKx8gNoauJCu4HSLubVDbx02Q+z/QKSLJjJDmSwe9rq29BcOzgMDjB04Zlgg1GdWOiuiF67vrbK8eBrstOwqU2/r2N247Al40MQ1zonpmU9wR2hidNr8AS9lRguvajZIf7I3X+EgREmWqvEWJZ0VyYA3EQBIiTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IliFAbLLAZkKCeKThBoSEBh+SrUktjM4mfy6Q6SnXcA=;
 b=J5c+HwEHR2KtmDD+7XYPWv19M5n5ElofZs/MTqYfc4uiQ0XJ6gaG2qVRHZ+KYV8vpzyeiGYPc8Q0xjkyKpO8rrW+ae+8uq8qWAfxv9dW2G5t4noPe/Zx2CT6s74DAUw24lPDKlxl2ianU+P8Yj3C9p3zr8td15rKZm9qAgsXRWJmVPoQHugJfSvHf4lYZmbNDkb59T0W75iSuKKUjI9NLhd5dcU0f7HuauQdHq7k0ESS6r5JhM+L6SnT8QQyGr63yUzQL2ZRi89vxKA5eDSu6u1WEqI7uDKHaBKqGDfd9oWwAn3r9uCxFcOJ0tskJrFoJqx53CgRbHMcA5HbabaDag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IliFAbLLAZkKCeKThBoSEBh+SrUktjM4mfy6Q6SnXcA=;
 b=Is7n7DzRwJevSEXSxZr+ZL2LDS9bSp9ABUfluE2rOgH5qaRcynpoojFyIb3/QCejx0e3Z/+Ysu/QfBWeZRW+i1EPbjHzgwj2Zy3GsxbT6e85UsapO8tYkq3FYmsSf7QW9JrSbA0KhSLNZJDGR69Y5g1i9eFKoqycSiAT1BI8hZ4=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1565.namprd18.prod.outlook.com (2603:10b6:300:cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 16:37:58 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3912.030; Wed, 10 Mar 2021
 16:37:58 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "rabeeh@solid-run.com" <rabeeh@solid-run.com>
Subject: RE: [EXT] Re: [net-next] net: mvpp2: Add reserved port private flag
 configuration
Thread-Topic: [EXT] Re: [net-next] net: mvpp2: Add reserved port private flag
 configuration
Thread-Index: AQHXFZGs7YE0C+mbQkm8VJDJz1s2Cap9XyCAgAALbuA=
Date:   Wed, 10 Mar 2021 16:37:58 +0000
Message-ID: <CO6PR18MB3873813B7C30F2BE0095C061B0919@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1615369329-9389-1-git-send-email-stefanc@marvell.com>
 <YEjq1eehhA+8MYwH@lunn.ch>
In-Reply-To: <YEjq1eehhA+8MYwH@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab0cad89-e81e-4505-5a3b-08d8e3e2dd31
x-ms-traffictypediagnostic: MWHPR18MB1565:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB1565E5A9140E54E20C968593B0919@MWHPR18MB1565.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: maNd/xhjwCtwslMQocGC1w7jo8bwwYZklgxYrhFpjohXyD1cQ2TXikYwmVHJpH9PXMWhurMOktH5Nxn8k0hkINyB6vYCKHLtTBifvOgIDRYFDPjaDFSSeclA6OOofTTwq/zZlEdoVw5JRWSIkv321WWa1twtFjCiIyrLumDyUP6KuySbBIW3ygTTFQhC/P9L0s56HVqdD919PkV1AGS4bzqtbKVWLNiAhH94QYVpqogphaReGIx6CDJcxc+9xOb/YUH9ehtJsnlI59kLfzeiI9+Q1REvzNuPYVT2vbFTJDayjIPObsCYFY7+OkFdu/VXIkJPhRIGi9XcrCQj6yoAE0J/Le/Sps6voUOcFJ/hyiZMS4nD7vzwmxlXbMQuPPvQfMvwG7kqczN21yGA0rWEqtwfoSEPMFi/koWctzGlTIoQGFuuN0FNHHsVNiFk8WfXyNIbHCw3LuVkK1b3tCMPhkxEefEJXMoGCmfRp8djpM/xDu7gwdujqX7YS127zpAsDdeymsHyJa3duCkwXp/WKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(52536014)(316002)(4326008)(5660300002)(54906003)(8936002)(6506007)(53546011)(478600001)(8676002)(64756008)(66446008)(66476007)(76116006)(66946007)(66556008)(7696005)(2906002)(33656002)(71200400001)(26005)(6916009)(7416002)(9686003)(186003)(55016002)(83380400001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?637JfMfDykrpceMEOLDgs8mW73QZqRnB5/EZf9XWu/1URjLKetCZvtqI2XHo?=
 =?us-ascii?Q?V5Fgu992lTxRuhOTilzwyBt4EcY7x1D8B443hTI+zIBKtzOEs3L1APDjQu+u?=
 =?us-ascii?Q?bAbPKjn/zAMhyjJBYtwolMAFMzkqXPrC/qIchpkaROvuHJ/ue8pZOrJOimk4?=
 =?us-ascii?Q?IuA/lV+qHcPAe/LWDf7MiY80eWsvXAesUDad3kOEVBZ9+DBiR7PS4nEdf0g2?=
 =?us-ascii?Q?uUTyXQ86y4eERXoq66/LVixH6RnJndjFtfSl/wc0HF4LXfWPx2qI6+efu0Jf?=
 =?us-ascii?Q?c9t3xLj6l2gSOnHLp/9sZt1yqkDE7SInHafEtC6dAHH6oIrQAYxYDQG27x59?=
 =?us-ascii?Q?ALQ1RHymUcT0/i/N+vDbozhz6zcvzL8fliJa5mBRi31w+E1Qnb2uud0xDeqG?=
 =?us-ascii?Q?RsNy1D5ebyLxG+iarWyFg7X8bhlsA+NQE6SMBiwKoPq5wp1YbnDDsbeONMqV?=
 =?us-ascii?Q?vXrpvIMIRdWaIsZ+Oonh9QeRL/Eit0EmNdeZfqlnHexfJmocZ11kCl0d3pRf?=
 =?us-ascii?Q?cRs0/ooQc2AuFTGGpYMGeCwkg/AUKTEZk+rTv1x5nYcII6G3Gau3rmy83u0M?=
 =?us-ascii?Q?yx67RhMaFLRLYnvOQXPFdGNKOa9z0E2cl6KKeyQphNxK7UmQBeg8Y+xZovNS?=
 =?us-ascii?Q?ZS5xzWBm70LGXpH4SHYH3fnmETMOk1OfaHitYlEKQUFGPr3g3uc5MWuRYlj4?=
 =?us-ascii?Q?jQ6TZMZCrZc7Ihhn42Bet6zUrHT65tEWuaTVQsUQR/cA/H0OtrZLKOdDiSCK?=
 =?us-ascii?Q?iuEoYq2gj2P3eHI0h1/CypE4C8obM2eWbRZqKsrIripZQg9ZDjbnNohmlUsP?=
 =?us-ascii?Q?JAiqUG3G2uaA09XcVxrqljsYho+8FObTmOtqIT08mGu/6n+RmqysRoSV0Gvb?=
 =?us-ascii?Q?B4LiKZ5ZZs3pdRudz2DN8ux1potJv8OM4aWpAUO85PsKwVbV7BMvPtlqRbxa?=
 =?us-ascii?Q?5y1c3xT+S57OPaZZKQPOT1hv5yqlmBYPkW8V4i/Vi4fryNUlgQxOH1qALInF?=
 =?us-ascii?Q?lBZr8iaK/9lyjJgbpos27h4V/xp5WbCBQ+HIzlraPUjzWK/6z0C8IXLww6LV?=
 =?us-ascii?Q?LO/scRd12oW1OaxL9RtGNHVewyBKaMr8YbynHQTjiCp/9EMLG+eWrSwbGAqH?=
 =?us-ascii?Q?/gwkBsxkVRMON+OGtncY6zxACM1RvloCKi8QTBuJiL5Lbi0krED7Tma5kE5L?=
 =?us-ascii?Q?QlLgzn9JaH8oUa8yd4J9s7FDi7uiHHRw8UAf4zRQcH6wsA3gM2mlJcwCR9FV?=
 =?us-ascii?Q?9cI+wPfb3fV6w5C+lbxiUn09rXGBTch9hO6L53AGZBpRwH2BqxCtV1IH0jht?=
 =?us-ascii?Q?RwI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab0cad89-e81e-4505-5a3b-08d8e3e2dd31
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 16:37:58.4325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2LCnjvkgb8clKGaK/hQ4LX9xXAfPTBINMZlQDUZ8LBWU1EX43bg6FmJzj6VZqdg/XdydzyCb/crQnplOS55uog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1565
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-10_09:2021-03-10,2021-03-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, March 10, 2021 5:51 PM
> To: Stefan Chulski <stefanc@marvell.com>
> Cc: netdev@vger.kernel.org; thomas.petazzoni@bootlin.com;
> davem@davemloft.net; Nadav Haklai <nadavh@marvell.com>; Yan
> Markman <ymarkman@marvell.com>; linux-kernel@vger.kernel.org;
> kuba@kernel.org; linux@armlinux.org.uk; mw@semihalf.com;
> rmk+kernel@armlinux.org.uk; atenart@kernel.org; rabeeh@solid-run.com
> Subject: [EXT] Re: [net-next] net: mvpp2: Add reserved port private flag
> configuration
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> >  static void mvpp2_ethtool_get_strings(struct net_device *netdev, u32
> sset,
> >  				      u8 *data)
> >  {
> >  	struct mvpp2_port *port =3D netdev_priv(netdev);
> >  	int i, q;
> >
> > -	if (sset !=3D ETH_SS_STATS)
> > -		return;
> > +	switch (sset) {
> > +	case ETH_SS_STATS:
> > +		for (i =3D 0; i < ARRAY_SIZE(mvpp2_ethtool_mib_regs); i++) {
> > +			strscpy(data, mvpp2_ethtool_mib_regs[i].string,
> > +				ETH_GSTRING_LEN);
> > +			data +=3D ETH_GSTRING_LEN;
> > +		}
>=20
> Hi Stefan
>=20
> Maybe rename the existing function to
> mvpp2_ethtool_get_strings_stats() and turn it into a helper. Add a new
> mvpp2_ethtool_get_strings_priv() helper. And a new
> mvpp2_ethtool_get_strings() which just calls the two helpers.=20

OK, I can do this.

> Overall the
> patch should be smaller and much easier to review.
>=20
>     Andrew

Make it patch series? I can split it to 2/3 patches.
Thanks,
Stefan.

