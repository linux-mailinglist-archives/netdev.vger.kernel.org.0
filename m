Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AAD344E74
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 19:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhCVSYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 14:24:34 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64146 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231617AbhCVSYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 14:24:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12MIBBZv004329;
        Mon, 22 Mar 2021 11:24:09 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0b-0016f401.pphosted.com with ESMTP id 37dgjnx1sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 11:24:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exqviFRlbubX7Mr+FPayO0y1QMFs+4BUdmNo8dMNsbbulNblNqJPCJJ2CJyNen+EVudpBmltUgOTQDgu0VyRzwL6ay7buIHnVfXpstnZRpJQxAGWSm2E8/zZ4DADdrkVHStjG6NyE10PWCZt+OONb92P6NrFdROTuj7Uup2oRGQmYYVCw7DS1p3d+9VpYBSdw8DQOPPgD+ToDDo8AiigwjBzAGgwFQ62Z3v/ZrMqmzF6tWmAOS5Yb/Z+sUqs3Axr92Z2L4ZYla6fNH9QCx5vXx43O9TElOSrQtr/jKGYECg9Et5P0kacpILK+Tp49LobiEl5kuuf9nrTJLLr6ccvLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EY5vWIHHbT+LVIPb730iPW0GZmnAA0OObXAMAT1YNb0=;
 b=f6Mrd8KkoMx6kYcO+SgHzDz1KnoujC55Nd/xfg1+E6QGZ9+kbp/7ffJ7u9x4RQIwI0gkNR0BcLsxv3eGMPFVu1ufZhczuINSgDTw+hYopc7JrFzet7djfgh5ES4+QdC1zGvdLbKUJvGEdTdMUjr3dUl2kezDy+cg/lQUvH/zcFpF6l3q0r5XcN+WxNDHCiTE2NWVEc4jtGicvmzzjQBQMkiul3uB05U1vtVyPvVAEEYpDmaMWRLWJl9y+YJQBhMxlJYyw0B03PjvImKf8/75j8UpX8a6nIhuhiH/XoZ45DpfKJbxcYC4BWZ9Vb5BfdvFCwtkiK8W/b0euM5cEIV3KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EY5vWIHHbT+LVIPb730iPW0GZmnAA0OObXAMAT1YNb0=;
 b=LVECFHESzufP1NdaegoPNP4AUBcxVwlAIoRnga/HVZa8B2Zm6/yEseMXoHH2RfFhe5cPTy3b0/9+S7dP1LYhVR3Vz/L5RM/Zea6afzU2leNdVxB5x91SN1YAmQkiD9TQ5WFbdLDpOXzTmR3R7QFy7Y+ebcsA/38w1VZUs3fyXA4=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB3924.namprd18.prod.outlook.com (2603:10b6:5:340::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 18:24:06 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ddee:3de3:f688:ee3e]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ddee:3de3:f688:ee3e%7]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 18:24:06 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "rabeeh@solid-run.com" <rabeeh@solid-run.com>
Subject: RE: [EXT] Re: [V2 net-next] net: mvpp2: Add reserved port private
 flag configuration
Thread-Topic: [EXT] Re: [V2 net-next] net: mvpp2: Add reserved port private
 flag configuration
Thread-Index: AQHXFpW4dTR4hPIdakagD6uzfQ/d0ap/ArIAgAfBQuCAA4BOAIAF9pLggAAIxICAAAc3gA==
Date:   Mon, 22 Mar 2021 18:24:05 +0000
Message-ID: <CO6PR18MB3873473DF823D778135AE9E0B0659@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1615481007-16735-1-git-send-email-stefanc@marvell.com>
 <YEpMgK1MF6jFn2ZW@lunn.ch>
 <CO6PR18MB38733E25F6B3194D4858147BB06B9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <YFO9ug0gZp8viEHn@lunn.ch>
 <CO6PR18MB3873543426EC122F1C53DC40B0659@CO6PR18MB3873.namprd18.prod.outlook.com>
 <YFjFqaHxXiwcZpr2@lunn.ch>
In-Reply-To: <YFjFqaHxXiwcZpr2@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77e065a2-1f07-4022-bf83-08d8ed5fad72
x-ms-traffictypediagnostic: CO6PR18MB3924:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB3924857CE8BB05C7A24ACBA0B0659@CO6PR18MB3924.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 37wamn6EGuSBsS5JLvln+O1bLTTd4XsgqvkuRk9GjGc5fqPElwsSHbr1+3jD0qlsLtx/l2yr+zQK4BZDWYw/wh6T/4f2NLyo7QyDy40Tw9MMx2uC/BVLzQaD3KSrPV3Sffg+tJHsjKRHOx9n0WcarO8Er3pX8uV7D7ITtTXMfaf+BpJM4KVbufa3/SXLsRmIFDXBh+gjoUEnS1qtOmrfK1KpOylaGCLmQnl9XcQO5Tw84pCRJIJdTxzhP8Q2ON9cRGdBYOlO9GLLNMSa2YdDCd6+gilXBDPUx1S6WE4yD3vyKHGIaptwqts5TurefEFHskfsQmJaRNK2k4yKJiHwc8JaBlXVqnBPd/Ya2sbdrLTnpA9k1ccyb1096oleIIy4HvbLSty841/WDqDC3JSPti2+eKKU+iUWL62Qn4YUxRVfSIiQEkyjOV9031HB3NCC/bViurY+usCGmNo/iqL7OWawUnezd6/HfznXtRDR8IndPS/JleT/YG0auXrkaRj/PV+3jgBdsV/+M4aACY4wBwC8jVYoaSSZQnSjiYgbJQR+7avZ51/sN8+aV6n7UrUMNV5FpkaRmnl1FC7X1DgAfmbYQZV+c7IkcMa8UnhoxVC0xLTVNPX6roISAYZd+KWkVSukYgdT6j8XLhFGV/XuocnHRB8YQ8gMfmlaFAvjA5M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(2906002)(9686003)(33656002)(6916009)(38100700001)(8676002)(64756008)(66446008)(66556008)(71200400001)(316002)(66946007)(55016002)(6506007)(76116006)(66476007)(7416002)(26005)(186003)(54906003)(7696005)(52536014)(8936002)(5660300002)(478600001)(83380400001)(4326008)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/7RSoHXpjxV/FDXxvXpafcfmxgnL5RsEBYQaWJfYHxCgI0AeZC02veAS4A77?=
 =?us-ascii?Q?YCGsSyeAHtuGiSO4iM9WXxMAPy/VNTkF7FFxFJYAeRzdgYP25HFz77aWh8bj?=
 =?us-ascii?Q?uQGESAFe+bmoa6Va+cN981RGV/9M7OYwqzqYiZiyg3SnZ9V/Zc61ytgDpob4?=
 =?us-ascii?Q?CVy2PE9DztHpAcOV9i94eC0/Ykxt9zrYIw1mlkbqyRK8TCXBB2PNX3LC0mOU?=
 =?us-ascii?Q?72Z8MCq0k5RkIkIxOUGmNIoZex2VzZ77PjcW706bh/swLjRzhyPFmRuayGPU?=
 =?us-ascii?Q?NumoodJTHDHZDZY3f0SXNKbZ5cOx2izyFerlvjahjqzR317LcCP/nxjzIkSH?=
 =?us-ascii?Q?X8eFw65Nt/bkbBZhZSRzADjKiMwnwvJd5MteM0u6WDL6+g5DXGPOTphPRgWh?=
 =?us-ascii?Q?Bd081nC8IQOyYAsZX/H+6NYNec9oHGyP06f1DWdM6wvwYEm3XDQfEh7fB9YM?=
 =?us-ascii?Q?eE3Ii31yjmpG8aXvkprXdJx+l7SVQBEdW1uYDWPXC9nI3uj5RMy8ztI5RiBp?=
 =?us-ascii?Q?Fenh0aLqqqCKIvzLdwEPUBnopovVhppEsdQTxZ31O4IBWveI7vUCXIqJJwVp?=
 =?us-ascii?Q?z2CG3fcXyS9+cdtgzDIWmKROA9pYXH7yQQujhNkTgMxoqDVeWKouHb6Z+6mi?=
 =?us-ascii?Q?yXm86kO2AayavXzdBYlT6ON4jhKYT/g0EdAIrVJ5y66byq81m+QcLgSEv4ad?=
 =?us-ascii?Q?0LkJY3MUzT6igzNQQ62JAuXNw+xrkLwPkzwQ9fZdeBZ11hgnVxb6ythuZzE8?=
 =?us-ascii?Q?oiifvE60ZeglRW6q3LcdnEOEjOvMXonZ3xcmUtm5xwZ7itCKd9DLdKtmfMp0?=
 =?us-ascii?Q?PLdVql0yEQJ5hPk9WKirXsyYqOEzQbW2dgRILvzhn2q/eDP+AnLc0I3jPpZM?=
 =?us-ascii?Q?VbByk6rICbnZTc9eMBprYcbjJVProOj0L6oEEntN/aXhF1iBm1Qlu7DB8zoG?=
 =?us-ascii?Q?nCchCSUQCEi4+heRkIAgzZaf//V3oo0WkWKpb+xBcHzee3QwmkU3FKwUgtNu?=
 =?us-ascii?Q?li1NsIM8B36RpXvSfHjTKvHimmMmppxwEzWcYDPd2+kWCAEH24QTx6wWGZEW?=
 =?us-ascii?Q?WyOQ1BFJq4LeTVdT45YvsPt9JlppEhgRBAS9xNsPegdb0KdhnUG5EZR/xnD5?=
 =?us-ascii?Q?B3QBWqFIfHXPUWOgnRA3vPKHGGjBki85z+Bd7lhMscbG9OW3tEs/rAkewHIC?=
 =?us-ascii?Q?+dnCj5FheDcm9hhmxCDaZy29p04d1QAJ9lBSadpXZvxX3R9iNkMOALfQI5vm?=
 =?us-ascii?Q?PZiy2BKKP7IpqgdKBvtLKAPF9VP2CWej5S/Y6jp4JivXKkfikIGW3yE6/+fG?=
 =?us-ascii?Q?WhE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e065a2-1f07-4022-bf83-08d8ed5fad72
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2021 18:24:05.8658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u78l0nEhs6rQIkSa+V0/x5T8yl51R1RRavJqGb6Kuob4ruXsHYVWJVQ67hkyGoU/zBhQP/2Z/4c6sJdPzK40RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3924
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-22_10:2021-03-22,2021-03-22 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > CM3 won't use this interface till ethtool priv flag was set, it can be =
done by
> communication over CM3 SRAM memory.
> >
> > > How does CM3 know the status of the link?
> >
> > CM3 has access to MAC registers and can read port status bit.
> >
> > > How does CM3 set its
> > > flow control depending on what auto-neg determines, etc?
> >
> > Same as PPv2 Packet Processor RX and TX flow don't really care about au=
to-
> neg, flow control, etc.
> > CM3 can ignore it, all this stuff handled in MAC layer. CM3 just pollin=
g RX
> descriptor ring and using TX ring for transmit.
> >
> > >
> > > > 3. In some cases we need to dynamically switch the port "user"
> > > > between CM3 and kernel. So I would like to preserve this
> > > > functionality.
> > >
> > > And how do you synchronize between Linux and CM3 so you know how
> is
> > > using it and who cannot use it?
> > >
> > >       Andrew
> >
> > I can add CM3 SRAM update into ethtool priv flag callback, so CM3 won't
> use port till it was reserved to CM3.
>=20
> I really think you need to step back here and look at the bigger picture.=
 If
> linux should not use the interface, it should not exist. If it does not e=
xist, you
> cannot use ethtool on it.
>=20
> What you might want to consider is adding remoteproc support between
> Linux on the main processor and whatever you have on the CM3. You can
> use RPMsg to send requests back and forth between Linux and the CM3. It
> can request that the shared parts of the packet processor are set up for =
it.
> Linux can tell it when the link comes up? It can request how the PHY auto=
-
> neg should be configured.
>=20
> 	Andrew

I would check this option.=20

Thanks,
Stefan.
