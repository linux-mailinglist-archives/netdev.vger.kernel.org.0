Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A3230225E
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbhAYHQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:16:01 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63184 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727198AbhAYHOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:14:03 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10P75Uwo007118;
        Sun, 24 Jan 2021 23:12:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=DL/jz2SbloW8qn5I14ttuBVFEVSAqs1gOWse+qMy4LY=;
 b=HHME2IpOWTsQlAK/UHlfE6kh+tYGvcprocm00bIimrDUzHKz4CkFyC2q2UwXgAMdQT/f
 xiARaIs52kgNR7oVqLoqisEBBPz4MNwK3+Wcl9cSfujj7H8EcdxeJn14X/OTl/7L/u+v
 Z1S8YQmkJUudPeKQiSS4mthZhOUdkcal0QjkdpiUCb+vzRrc+dbTCqdeZrPBLQhcpSBZ
 KeMVyrgrZ55duzWjhCUGOYNIuuzMqG1aXRTSbGdrlXVEWZ1Mm+QdeiqaO0/pJNKw4WLJ
 ELEczDxPNbysLLMJBYro6jRai/8yfMQN/rR8J4YgZNKR1qmVYntpcxY1JebMbg0atvKO xQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1u3q5k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jan 2021 23:12:38 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 23:12:37 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 23:12:37 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 24 Jan 2021 23:12:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6nqm8Ji0WDOgRqBCkQk+P7ft51xXUCXy+ClUQsr2eGrP+WfcB5SUEl3IzWlGwx6eZP2wJmFP+bEE0j+y/8UdKNUAjmg0Y58ae2lAKYsx07dduWL1pU1Mahwcx5L38ClKxsKt1JgvuaU3XLMBEzrgDbdULvQH98VzWpxqyul45lIh40cxYJAYdlCo0sKFAymvs97WrNyf0SF9puZcjCa2fDTG25KrawlvyvhbhP1N4niO+T17P7hZd+TZxr+M9xBuWTkIkoAhmlPsQVPCoegUwWGCOicgWPITHu0U/MzfeK+6s9ek/udKo+Oxc2jq57nBzBgZj51tNevuLgP/CRFJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DL/jz2SbloW8qn5I14ttuBVFEVSAqs1gOWse+qMy4LY=;
 b=HBU50ZWkxp5aR0frvqrzj/cO1S986Dj6Lo857UWuVJEMxZHlds0KHYC0FXWwZy+z9rU1mQnE/j1HNUxawF84lZ1+Olobw2M0XwUo0FvUX+iBn/f66z35hi726hcJpcfAceAgMfr2h6FDz4lYXKrI/8mBwrmWRfJQXLM9UX1InE7XYKd4XLmlwctVDelCwT4vC037vRFhBrt3blNwIVZn3EnnKSMDOXHVkfDzphhDem6LOl4L+hvzlCdhThlcN8CJNjFptTXGg7bnrEfYzCqp72at8ibZNPEFnMkFk7uCEFHXOoo8Z24INzhcqcD0CHqy7PyQStrUnmm3ft6j6seM9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DL/jz2SbloW8qn5I14ttuBVFEVSAqs1gOWse+qMy4LY=;
 b=kklQDtdTyTweVkGiDWiZ1zuIM4iURM66GfG/ZTb1YEV/Eaj9De3J5CDzPlqHGBjPoC3DZ9VIynUmaeKIQDsahilyj+Y2Qj3RUXvL+Oz0yzHIVHQNb5hJBPBogLyOLcT2tyy1K5xnT9hEBPs7dSo1M8jpYaQTpTOawhnhH2zp7cA=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1568.namprd18.prod.outlook.com (2603:10b6:300:ce::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Mon, 25 Jan
 2021 07:12:34 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3784.019; Mon, 25 Jan 2021
 07:12:34 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 RFC net-next 04/18] net: mvpp2: add PPv23
 version definition
Thread-Topic: [EXT] Re: [PATCH v2 RFC net-next 04/18] net: mvpp2: add PPv23
 version definition
Thread-Index: AQHW8kZchLujdtMv9Ea2pwqlGkruZqo2wi2AgAAHuvCAAFjWAIAAyz1w
Date:   Mon, 25 Jan 2021 07:12:34 +0000
Message-ID: <CO6PR18MB387356C7FAF89824E1D3F5B6B0BD9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-5-git-send-email-stefanc@marvell.com>
 <20210124131810.GZ1551@shell.armlinux.org.uk>
 <CO6PR18MB387343A510B3C5A9C5E004B2B0BE9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <YA3ElJbfk9Km2HiF@lunn.ch>
In-Reply-To: <YA3ElJbfk9Km2HiF@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 917e3fbd-b9e0-48e6-c43e-08d8c1009679
x-ms-traffictypediagnostic: MWHPR18MB1568:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB15683283958AE5F926A549C4B0BD9@MWHPR18MB1568.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BC2bbaPowX7zhWIf7Y8ttw8e4nfOKChM1xOXze7K2DKCuzz6nfjBiJHSR0yVOrZfStMa9hLKOiBJwCW3Nh1zrapBC2EkA1L9bCAa3epuGjJUFdZbXc5le3gn/gghST63fk5TcF6K1uE4I2nyDfrrMqbhrX9lrYU5joyxHOltj8EPVPWIePP+P3fGqziAXiQkZDkpeX9qm/nOSJ8rFJeRANqqt7FKTZds1EXRzBeND+SNuYqDPm1hmkRulsoMuTTkvrqEOQTlohhkwbYy+2uqRgluqkcjuz5mbgGK+VTyJYBkRInMlv5A+AbOW7HXxL7fDZ6mt/cmMeJg0J+LOuYvpH31DUFtZeOrVs0VTZYXsEgL5iQdhLegBC5G+wl0sDN1B9JGDH+Miad/dlrZrz+lUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(9686003)(71200400001)(478600001)(76116006)(66556008)(316002)(86362001)(66946007)(8936002)(54906003)(6916009)(55016002)(7696005)(64756008)(4326008)(66476007)(66446008)(52536014)(2906002)(8676002)(5660300002)(26005)(4744005)(83380400001)(186003)(33656002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/02CxpJs9n/bPTQU3XaoAgLPI2sX4cKOAQ0P/uF24iv1O7K5zPleuiGnsF2c?=
 =?us-ascii?Q?dZ6aqpONjT7hH2nW9/bOG8LN+oHRyiwG3Xkd8OqJFHs5Cmi4ENMhxePT60jR?=
 =?us-ascii?Q?7S7tCGp/2J8XucQUGASpJj4GVyP3YvINnz/HlxhY+I7lRQ0ego2HwKtk2okK?=
 =?us-ascii?Q?T8f6AOCTrkMCC9tX1ZkAJlJrnNj4NwayAM4O6R1QIroVhpnA0OMb6L9KD2N4?=
 =?us-ascii?Q?Kwtcga26QP2f0+y1gIJ2jSp7+uZsW0BrdEyu8m8C0sPRUkh8Jg3CzslkyqyP?=
 =?us-ascii?Q?w4H7U1rXtdeYAdnREAcU/llN1Uk472hNf505o6DdcjRY0cG0DAXAmovynfGX?=
 =?us-ascii?Q?b0oyxyLlibfHtjjl7qIBHR0WiG3kxJkl/j3j14nME6CnHX667w51GplFeb+p?=
 =?us-ascii?Q?7hQhnSOuHEqrjPoGhnW8qDRfJGXdDkpaRUMWbHiC1LCHJagiS12c/JR4ELc+?=
 =?us-ascii?Q?j2RfLm6kCOWX5hq75twc9NoVYf0VdFRI24cRVa9gxlnl/ZLwsyZIFXk+xps6?=
 =?us-ascii?Q?RllEOAuEueteV3KJh2YCh4cC8dGeGZYJ8NWbWCv+q39N/uhJg7jUPw3lwyqM?=
 =?us-ascii?Q?1Sn02C3zXClet+HOXsXItChk9jsTEYBenUH2gsa/GyB9U21QY1xvAn23o+UN?=
 =?us-ascii?Q?Ccdp23xHBvMYWa+n+jmG2ssVnaP+FlDanY0feXqnNzYs+JRyU19cTVzKtvEt?=
 =?us-ascii?Q?OYNTOrP3BGFPdMEsh1k1dQyx4DiNTzDln0n3u//wx151vcLlUj17nBTryMgN?=
 =?us-ascii?Q?hXuQU/K+WWQ/Z5w31F0cBt1LXY3OawH2gXY0QNnDSwvhDmGRGErqgGYKUA9H?=
 =?us-ascii?Q?R05zwXq12MMI3UIFIzmcH5Ig3W6lX1WrxyKxgAwWVEqFeNSlW6GRUDyZE7sO?=
 =?us-ascii?Q?nZ3se4g9et0MA9GAOPxLs98Qv+wcC+AuEkpn2pKCsPwmW6Zh7tVuQ1l9u9fm?=
 =?us-ascii?Q?Cdxr7P3zKDU1vO2h1YjmyD1KstssnvG3d7nm4wbKE7dg/Quyb3req1qVx3je?=
 =?us-ascii?Q?sPgKAHIbsoMuMHJ8Ppbh/xICERHwuAZ7sUpqPQYd96P//AQjcqdiYgqKm43b?=
 =?us-ascii?Q?pkx4RJp4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 917e3fbd-b9e0-48e6-c43e-08d8c1009679
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 07:12:34.0742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bC5wGT5WhZnsEq4EdwxLhGzsYRZtQsXyfwZL4V9L0pXAxFZ3KQ6b6XCySVGY1J8gxNuLV4OB5DN1/jTyTEi5Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1568
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-25_01:2021-01-22,2021-01-25 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > We cannot access PPv2 register space before enabling clocks(done in
> mvpp2_probe) , PP21 and PP22/23 have different sets of clocks.
>=20
> > So diff between PP21 and PP22/23 should be stored in device tree(in
> > of_device_id), with MVPP22 and MVPP21 stored as .data
>=20
> Hi Stefan
>=20
> As far as i can see, you are not adding a new compatible. So 'marvell,arm=
ada-
> 7k-pp2' means PPv2.2 and PPv2.3? It would be good to update the comment
> at the beginning of marvell-pp2.txt to indicate this.
>=20
> 	Andrew

Ok, I would add comment.

Thanks,
Stefan.
