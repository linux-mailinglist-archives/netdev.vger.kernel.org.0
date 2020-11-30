Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EA12C8B4B
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 18:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387628AbgK3Rgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 12:36:42 -0500
Received: from mail-dm6nam11on2094.outbound.protection.outlook.com ([40.107.223.94]:26656
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725961AbgK3Rgl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 12:36:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JoPYY4jIjYp1cznbF3uRFtf1hkFu9nW3K0ux0rIB4jkBJDCEepGfXEtJZwR4Q0HIpUYHIAGgw6J8gjgejYwmGe3xXGj4cs1bPzYynJ+r9PaBuntczUmjf5ZsuV+5Wew70vNLihNjYXGxoJTUEDaP8cyQYUihVxrm4VpVi6qpVeSRZ52NIL+o8hbZHv6kRtMju0Wbpj3pMfmBGG2VkAi4coUKUYoZ929elOeVp/+g6kWmp6+2d0104hqPskuJ5DLP4yCZGS2KOqePMht3R1fRHoG6xn6hCyg9fwTfqNN81YTzTyrQJ6gItWec6NL9IcR+1wyM8kgWkiX9A5l1+l4WCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TlyRk/g47IqXmcN4J8PYpVDbutkcPszehUVgL3XBDv8=;
 b=oRzdr87eF/5hTLVFEwO/sJ99pElwwKfDjelbfVBoKkgmHxAy3DgGD2Xe2QiMN1riJA53lWMfOdKlTF67hiix7B19gCZb3z6GbQoWcew08rQ3n3pu9nsEkXyDyMcOU6fDydkr26PSARK35aNIA0YR+jog5C9fAGel4ozYIFUSDDMkQ0NkjoOoSNPHtBqC2akAdOc6DlJlnFJ258TmI1P+rKY3ygmPpyW2kP/0VAHC7UAMrCowKN0OBkp4CDli+MI4DCq8Oow7VbX7qlEHDJVDYVruf5tiPLOzWRhecJe+AWkyS/dUSZ53MCI7D9KEC3lJx9VUBuRW3pQeqhVenpGW6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TlyRk/g47IqXmcN4J8PYpVDbutkcPszehUVgL3XBDv8=;
 b=q8fvzDG5BwV04pQ6ncsrSuQseurPROPf/KEDairT1RoHmbVFGYu38nD6mx2yKEA+i0XixTsTkb7vT6kWjGUJ7+xekKue6F/KqCRcjfc2YM4f6gHkY22QvW65jKVJeuw1wqVBWxEiSt4kes9EVCG6Of1Zh3Lbj2Wx33Nz0npresA=
Received: from CH2PR22MB2056.namprd22.prod.outlook.com (2603:10b6:610:5d::11)
 by CH2PR22MB1990.namprd22.prod.outlook.com (2603:10b6:610:82::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Mon, 30 Nov
 2020 17:35:52 +0000
Received: from CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::1922:c660:f2f4:50fa]) by CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::1922:c660:f2f4:50fa%7]) with mapi id 15.20.3611.031; Mon, 30 Nov 2020
 17:35:52 +0000
From:   "Gong, Sishuai" <sishuai@purdue.edu>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Race: data race between rawv6_send_hdrinc() and __dev_set_mtu() 
Thread-Topic: Race: data race between rawv6_send_hdrinc() and __dev_set_mtu() 
Thread-Index: AQHWxz9Ayg/39NUYdkuhtuPKQV+mQg==
Date:   Mon, 30 Nov 2020 17:35:52 +0000
Message-ID: <649F6CF5-85D9-40EE-85D1-F698CE1757A2@purdue.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=purdue.edu;
x-originating-ip: [66.253.158.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b23791e7-a366-475b-a74d-08d8955662a4
x-ms-traffictypediagnostic: CH2PR22MB1990:
x-microsoft-antispam-prvs: <CH2PR22MB1990C68DA33E0C37D83AE8EDDFF50@CH2PR22MB1990.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q+N9rc5IZSI9rINzwFFBn7n3Cfiw3Cy+FZBVOzYNxmkBn7P4wVGbFtovoJxC+LbME/Ow9FnTGFUChAJI7ZL5mnzYMmtdSXz3ZTTGQQj/zLC/t4GYyW2cMVnHG15yeh/388UZXXEJpjGHaQADvGr+EAa4+huBEaRScHwEi8c0ksejdFHQu/I/hqjqImhO5FkKdt0oZwV38VZb+PjzH1zziuwZ3f56WecuBdQZDbb72sJEc1c7dTEodf+G6uPSb8LUe/F0+xHBsIMhGMLbiWhRB4Im0KlF6VEr1l/OYX1kzEvPTp6q4PxcztNQxMXdJ/yY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR22MB2056.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(136003)(376002)(366004)(36756003)(75432002)(83380400001)(64756008)(478600001)(86362001)(4743002)(8676002)(26005)(33656002)(110136005)(6486002)(8936002)(2906002)(4326008)(66446008)(316002)(76116006)(786003)(66946007)(2616005)(5660300002)(66476007)(6506007)(66556008)(186003)(71200400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?CSQvhJpa8Lnx+k1EL8Kpv7RjMOSIEXAC7yk2Xhvn+o20s7YxHMGKOKm6LNO1?=
 =?us-ascii?Q?JLNJvkTRyidoA0V5IlINazNYSWjZIj1bk1dtJnncS/pZx0XNXQWrwc3t8UR0?=
 =?us-ascii?Q?o5mrYDJF5dSDtL/PEyKkHvyHVe4eb5uOhzI2YbVlACh+HSxY++7RWsa0xbPo?=
 =?us-ascii?Q?rYzfsH8Ff6OKcfWGU0BrQy96oXQoXzB/mHmwpNY+0plLujycijgM+5r9BknN?=
 =?us-ascii?Q?Zgz+rafPjODMZRN9v+GDYP9Xy4gG9/z2/JNA+wSYAsWk2Bk0AVO2S0Si7Xoo?=
 =?us-ascii?Q?QJ+SCiORydDOg6kpUJSK4IovgeLhlEBnqHeWtJcsUZaNCuWwjx5SGF8OtRYr?=
 =?us-ascii?Q?IqkOfr2fv7+DWmKRzumK9aeIR25Z/1Va6Lu2iB7NatPyeWmu1fhbeIRFRB9c?=
 =?us-ascii?Q?XNm3tsugDUQB19A2iKTqP3koh2nHM8pGc1udJDXWTFk2xOYp1z8PlAqKklmU?=
 =?us-ascii?Q?NVKJEkZBqU8stR2U5/zSDLnBa9XFvq4kU5p3BPMwNC4UQeQ2TFjtBydwKtF7?=
 =?us-ascii?Q?IGqv0PzLyKPYtO/Xhy3VsQQSpgHXIQjiIVGll+5OF3wt91c0T6QHs4IVEboC?=
 =?us-ascii?Q?Eufx59qRv6Au758joD/qFl8gDFyFOonTluDm+wL/khXHy4ksvfMkPNGKeoeU?=
 =?us-ascii?Q?0CUNDgNFkSNK2G7vxU05vB3pvh22CIvY6iZYZe3VzLSOHlT6rVjE51cUUvoZ?=
 =?us-ascii?Q?NnruBLivs7HT223OrR+rqpVpz52sxcriqOJuWeBXb1m+sR6gZ26ty+dTcwGB?=
 =?us-ascii?Q?n+lB2aWX0Ypj0Px3qZyevXTs58eTTySIzCUWNmb8/PxP/Ziqk0DZ0AYhLXy+?=
 =?us-ascii?Q?OdiVfyl63d2KAOO9k/FtoEG8d2RZ6JZ/G8pJS2U6GK2byQ/AFOZbLGkVIe3R?=
 =?us-ascii?Q?j/ENhZAr2K9a7GJwiXqcyAa4Rp+9I41e1uaRAurrVZyMTQLWY8x+2M9bBIsQ?=
 =?us-ascii?Q?pJgcPLmd9JRVxUOakguvGDaEM/Rc0PaOOPtknFMmPSdpHK2wwkN1kSELzBlo?=
 =?us-ascii?Q?8va7?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FE775A1F8766E74CA8F00086225AFC42@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR22MB2056.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b23791e7-a366-475b-a74d-08d8955662a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 17:35:52.6981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tOkTslW8ROV4B4lMAeh+86wE/AJw0HHCTYN/ISpCmykXbh+9C0NG7dqiPDFMMcTUmyFeF1YO/V8XROmzKstywg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR22MB1990
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We found a data race in linux kernel 5.3.11 that we are able to reproduce i=
n x86 under specific interleavings. Currently, we are not sure about the co=
nsequence of this race so we would like to confirm with the community if th=
is can be a harmful bug.

------------------------------------------
Writer site

/tmp/tmp.B7zb7od2zE-5.3.11/extract/linux-5.3.11/net/core/dev.c:7665
       7658  int __dev_set_mtu(struct net_device *dev, int new_mtu)
       7659  {
       7660      const struct net_device_ops *ops =3D dev->netdev_ops;
       7661
       7662      if (ops->ndo_change_mtu)
       7663          return ops->ndo_change_mtu(dev, new_mtu);
       7664
 =3D=3D>   7665      dev->mtu =3D new_mtu;
       7666      return 0;


------------------------------------------
Reader site

 /tmp/tmp.B7zb7od2zE-5.3.11/extract/linux-5.3.11/net/ipv6/raw.c:632
        618  static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *m=
sg, int length,
        619              struct flowi6 *fl6, struct dst_entry **dstp,
        620              unsigned int flags, const struct sockcm_cookie *so=
ckc)
        621  {
        622      struct ipv6_pinfo *np =3D inet6_sk(sk);
        623      struct net *net =3D sock_net(sk);
        624      struct ipv6hdr *iph;
        625      struct sk_buff *skb;
        626      int err;
        627      struct rt6_info *rt =3D (struct rt6_info *)*dstp;
        628      int hlen =3D LL_RESERVED_SPACE(rt->dst.dev);
        629      int tlen =3D rt->dst.dev->needed_tailroom;
        630
        631      if (length > rt->dst.dev->mtu) {
 =3D=3D>    632          ipv6_local_error(sk, EMSGSIZE, fl6, rt->dst.dev->m=
tu);
        633          return -EMSGSIZE;
        634      }
        635      if (length < sizeof(struct ipv6hdr))
        636          return -EINVAL;
        637      if (flags&MSG_PROBE)
        638          goto out;
        639
        640      skb =3D sock_alloc_send_skb(sk,
        641                    length + hlen + tlen + 15,
        642                    flags & MSG_DONTWAIT, &err);
        643      if (!skb)
        644          goto error;
        645      skb_reserve(skb, hlen);
        646
        647      skb->protocol =3D htons(ETH_P_IPV6);
        648      skb->priority =3D sk->sk_priority;
        649      skb->mark =3D sk->sk_mark;
        650      skb->tstamp =3D sockc->transmit_time;
        651
        652      skb_put(skb, length);


------------------------------------------
Writer calling trace

- ksys_ioctl
-- do_vfs_ioctl=20
--- vfs_ioctl
---- dev_ioctl
----- dev_ifsioc
------ dev_set_mtu
------- dev_set_mtu_ext
-------- __dev_set_mtu

------------------------------------------
Reader calling trace

- __sys_sendto
-- sock_sendmsg
--- inet_sendmsg
---- rawv6_sendmsg



Thanks,
Sishuai

