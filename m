Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318472C87A6
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 16:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgK3PUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 10:20:51 -0500
Received: from mail-bn8nam11on2124.outbound.protection.outlook.com ([40.107.236.124]:4265
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727022AbgK3PUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 10:20:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=no+/TGxXrMQ4Pi7QvuZqtmxWMoSFJsgvq/NTMB+lgAQYFS6Ige31/XetiS/Zv74fHI2ovVY1lrfTIPmDfcxcwk6767xivli+8jpV7em/ulB8MMTPgkHRtYmomtv6Aqzl8Ow66uFWSy2tBrkCRIBlJkPPwaGIUnds8BRKg8uEZL+nD2gBhW75yLsfJjz59G6VQWgRIvexyli0mF1YHYQPVDtcbJDbfCwB5dxWNjSDT0gMXF4mE5RAZsXiqs4w3MDiNpTXbhWQB6zMrvj39uLHKkp2IX5YojMbivLKlXT/MUNNeNRlxyOqZaIUIsa6NeizIO/KDp4Nkmv4mfU8RDD3kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q4buU+Ygb0yXf3ROkZn/YYRIJfqeOBlYJ50NsvZoToI=;
 b=OyoT1d/T1mYcBo4mtBtBmbVTkjYZu3zsYnosxREAKQEeXPoBigGcx0A3a6vKdvr2+8km+PnMXKPHyhXVEWTFKbJHTAXXU0tp+TJnz39Nl5G3bGyctyHQFFRdi4KUmzQPJb6m0GkdQGx5wrxCrMuEtytCBuwpeCtbJoj5xgPoTw+EkD09ZmmQSItY4MaxqD3eeTenMVyrp1gvyFOeysype4Zm0jvcNLt0YaNCSMsGgWB8ZZRl7P+ClxJD6Ra1Xv5HxcMEyIW7j6EUdw9F+/5L8BJpRfyrrSgg5N9euvkCztTvK3zux24e3iElTprPImRzTaY8KTzTb4QGkXTTmlaVjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q4buU+Ygb0yXf3ROkZn/YYRIJfqeOBlYJ50NsvZoToI=;
 b=PW/iljetB8xZ8PQqhdt8KwggdLKy511MdFln3Yr+BjPfwGWIbNahdwMErApR8WaR3MqfxdhF23pROSHoIXM1KZhM+zkBm+9Rp6NUoG5IvynvxnUsxemSlFCxB2vhwt94MtBqWyyKCeXr0R1ot3cSAnjmWdumt6HD3TYGrFDSAzQ=
Received: from CH2PR22MB2056.namprd22.prod.outlook.com (2603:10b6:610:5d::11)
 by CH2PR22MB1975.namprd22.prod.outlook.com (2603:10b6:610:5d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Mon, 30 Nov
 2020 15:20:02 +0000
Received: from CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::1922:c660:f2f4:50fa]) by CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::1922:c660:f2f4:50fa%7]) with mapi id 15.20.3611.031; Mon, 30 Nov 2020
 15:20:02 +0000
From:   "Gong, Sishuai" <sishuai@purdue.edu>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [Race] data race between dev_ifsioc_locked() and
 eth_commit_mac_addr_change()
Thread-Topic: [Race] data race between dev_ifsioc_locked() and
 eth_commit_mac_addr_change()
Thread-Index: AQHWxyxGUpgAFzgHykuA/k1UH6SdWQ==
Date:   Mon, 30 Nov 2020 15:20:02 +0000
Message-ID: <F35A5D81-F42C-49BC-9F0B-94563C5B7436@purdue.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=purdue.edu;
x-originating-ip: [66.253.158.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c0a185d-0382-4ef6-98bc-08d8954368e9
x-ms-traffictypediagnostic: CH2PR22MB1975:
x-microsoft-antispam-prvs: <CH2PR22MB1975034F5B1A6850965EDED4DFF50@CH2PR22MB1975.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:972;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OMRRQkw3zDSf3rvd0aMPMvFCdByg/dIda4ftPRohZSvpDlZqr9d3aaibH/RKzOVN5CMd+rEdCK1kRjDQ72CJPGH+KLz67a64abxMgyXa+bP8Oattct8RXfcZ+RqN6/SbHdsvNIzqVgnaUd+2fhRhw9YUr0gYtkT1au5FjN/00g9pPqVbfPtjnS6Y7UPF+2xzb92Ec/ehchesWnlcBIjx0jBMfR9rvq2QQ60aijF1ALhbmuudJiQcWlANvXPf2U7b+nqalEcKa/JwsNWNPrDAMvusdEJ6gCO2MkQRIhwDKYASwYqOMfZe3UnFjQn4fTht
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR22MB2056.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(39860400002)(376002)(396003)(186003)(2906002)(4326008)(26005)(8676002)(478600001)(2616005)(36756003)(8936002)(33656002)(75432002)(5660300002)(71200400001)(76116006)(64756008)(86362001)(6486002)(66946007)(786003)(66476007)(66446008)(6916009)(316002)(6506007)(6512007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JDNha3ghmVPmSAOZuabwKe/cfEDYz9pXHA2K/7vZQqMy3CECxdH0mn7BsBl6?=
 =?us-ascii?Q?OEpczNceQWUge4IpRbbmAzpEuuXPwveV7shSCH858G0ssn2jkcdmvd5Wff4g?=
 =?us-ascii?Q?8nsh9ChQpVTpqRtSi2O95j8KWai8A8Vxd2AsDk94J9e/h59A75OV+olq3dll?=
 =?us-ascii?Q?QtLjRSGYTTh1DKoGKnjg5NG6xK67vCi6dLZP0+X1vxQzir4QHYGKtksYBCjU?=
 =?us-ascii?Q?fbheGJQ8Cv/AovuaQkrYqCRhpP9VzaaEdElWgVhrtJ8tDhBshgxzHyfYeiCd?=
 =?us-ascii?Q?cXGQKx6CKDLD4sebn1TRvVl4+M1uK/M5zAKzcQTgkMH0jKJEa8EZTdyE1KdE?=
 =?us-ascii?Q?3uP/uCc+WwMhLC3w0/xVs8F+61cf2/p/svaVPVqaohplkbqLCpWZPOTAy+0g?=
 =?us-ascii?Q?/EqskLWyfih195kEAPKyRFbQagW9OSYDREMDYNLxxi7us8m4onzlghK3ZrjG?=
 =?us-ascii?Q?MVRkgiSk8ZdLeiIRhyA9dogUZ6SgVBIJdf2262utZ1iRc7RJ3Rh6mZzu7Efy?=
 =?us-ascii?Q?ua27s2QSyRxHDPWuZdG80+M7h4xE1RtlkAEuQRYbf8ZaiJ+RSBnPr8YVyFCQ?=
 =?us-ascii?Q?UAIhLgrlJadCxEb4AyeV/6z3zsFtAFAyxkMMLmh7jxUbGYaBVp0dxXixP+u6?=
 =?us-ascii?Q?LTAvX5y7ZzUZ5P53QbjYL7uSJB4R0qX1vvWqAQSK4BbkzEyX3+Z1/DPwTnoO?=
 =?us-ascii?Q?wTPyZ5bTF39yp2tJ5k3/UMZR/bADbR2IuPVkUyTF1/M4Muz/uIM0DQ1MP85r?=
 =?us-ascii?Q?H5C3J0eW2VlFZqOdh7mdOxaNeHv8UuEmEfQWQfV231FfqwQZKovtugCVVXGx?=
 =?us-ascii?Q?FFBK2UUo3IO/IAD9vJtJTcdmOvU+CnbqNZLG/m+sZWG7orX2WREaCMsueNE8?=
 =?us-ascii?Q?0OLYgyjwHVIllMLWNNtsPdhRqlgo3Da0aXjgNRPWkPgL0a+ASQIIBPlHI91g?=
 =?us-ascii?Q?bx3hsV4QrhlHAEZ0XmCqbyMB8aAIX1b6UlnJFQURgdtumew5Ar+QZVGU5+cC?=
 =?us-ascii?Q?IxBr?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <75C0CBFDD5BBC74FA75C88A99406D959@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR22MB2056.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c0a185d-0382-4ef6-98bc-08d8954368e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 15:20:02.6211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Di/SuxbnfzpAQ1hfWGcDsm4oI2YuQ/2ADrMzyhy7bKQidhQjtkmXokOfsioe5qWPOesKbjjIRIRo7ZSZDOfZJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR22MB1975
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We found a data race in linux kernel 5.3.11 that we are able to reproduce i=
n x86 under specific interleavings. Currently, we are not sure about the co=
nsequence of this race but it seems that the two memcpy can lead to some in=
consistency.

------------------------------------------
Writer site

 /tmp/tmp.B7zb7od2zE-5.3.11/extract/linux-5.3.11/net/ethernet/eth.c:307
        298  /**
        299   * eth_commit_mac_addr_change - commit mac change
        300   * @dev: network device
        301   * @p: socket address
        302   */
        303  void eth_commit_mac_addr_change(struct net_device *dev, void *=
p)
        304  {
        305      struct sockaddr *addr =3D p;
        306
 =3D=3D>    307      memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
        308  }

------------------------------------------
Reader site

 /tmp/tmp.B7zb7od2zE-5.3.11/extract/linux-5.3.11/net/core/dev_ioctl.c:130
        110
        111      switch (cmd) {
        112      case SIOCGIFFLAGS:  /* Get interface flags */
        113          ifr->ifr_flags =3D (short) dev_get_flags(dev);
        114          return 0;
        115
        116      case SIOCGIFMETRIC: /* Get the metric on the interface
        117                     (currently unused) */
        118          ifr->ifr_metric =3D 0;
        119          return 0;
        120
        121      case SIOCGIFMTU:    /* Get the MTU of a device */
        122          ifr->ifr_mtu =3D dev->mtu;
        123          return 0;
        124
        125      case SIOCGIFHWADDR:
        126          if (!dev->addr_len)
        127              memset(ifr->ifr_hwaddr.sa_data, 0,
        128                     sizeof(ifr->ifr_hwaddr.sa_data));
        129          else
 =3D=3D>    130              memcpy(ifr->ifr_hwaddr.sa_data, dev->dev_addr,
        131                     min(sizeof(ifr->ifr_hwaddr.sa_data),
        132                     (size_t)dev->addr_len));
        133          ifr->ifr_hwaddr.sa_family =3D dev->type;
        134          return 0;
        135
        136      case SIOCGIFSLAVE:
        137          err =3D -EINVAL;
        138          break;
        139
        140      case SIOCGIFMAP:
        141          ifr->ifr_map.mem_start =3D dev->mem_start;
        142          ifr->ifr_map.mem_end   =3D dev->mem_end;
        143          ifr->ifr_map.base_addr =3D dev->base_addr;
        144          ifr->ifr_map.irq       =3D dev->irq;
        145          ifr->ifr_map.dma       =3D dev->dma;
        146          ifr->ifr_map.port      =3D dev->if_port;
        147          return 0;
        148
        149      case SIOCGIFINDEX:
        150          ifr->ifr_ifindex =3D dev->ifindex;


------------------------------------------
Writer calling trace

- __sys_sendmsg=20
-- ___sys_sendmsg=20
--- sock_sendmsg
---- netlink_unicast
----- netlink_rcv_skb
------ __rtnl_newlink
------- do_setlink
-------- dev_set_mac_address
--------- eth_commit_mac_addr_change

------------------------------------------
Reader calling trace

- ksys_ioctl
-- do_vfs_ioctl
--- vfs_ioctl
---- dev_ioctl



Thanks,
Sishuai

