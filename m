Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6BC2C886A
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 16:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgK3Pku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 10:40:50 -0500
Received: from mail-mw2nam10on2091.outbound.protection.outlook.com ([40.107.94.91]:39008
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727309AbgK3Pkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 10:40:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/XpOLSNIs2fMmNNUx16FmEgK2HGw+kI/w9W7ArFRfvuK0bziONA2wRqvtqP2MPy7Woz//uNGES6m9wedoGmCl1lPGWCeSc6T4Xgp+Z+osmNBevaIvdOXCbZi0e9whht/3svMsPDse5zz6VdjEh4UbYoBBvT2wB+O/KCr2iS+0eySj2FXBbJF2T0s57ay5gW8nn95YumC6vgvSnx6C6DS8csRDUytcxTl6ARx/QaCeh/t/keqMnPS+OnXKohs50fceKByDfDdu6yqb91URagyxtW4DtclyEplStN9skxIry80Wd1NMECl2ZUnYRbC9vuDSmsmy0LBDSht8xuYFB0tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvCegd9Jv+CBXTy7kn6s/TUcLbmj96iRvPxO4bU3tqs=;
 b=kCd8RJXzSqvjecGK8UsWnxW8d4C7xVciAgvpQ4EhvAX+03gUT1vvXKGesuX7jYnAuyi6kKOQA+wcbAo7CD1zobsFwwOBFtNkOlpkcebkbnrDmrzFKoPqHDpCPd5UiZVNaaAxRHUg1RhupAfqC8XNLR2afzL10wDBQQSwXvcSjmLrYD71BROt+ZwQZd35VIE/iAHGNMwmBZFWhxrayKpxrcq6HRbMQ8OuZUFud596XZ2+5brxFovDAtM6ngfeB8EsDp0tY+1hGjPjaO9IDCedgwSESoZOqlvSqgEkxK8dF05KT+UNKBOz8CyI+ABnsP66ig6ip/DVxjCwxcbEVyA1eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvCegd9Jv+CBXTy7kn6s/TUcLbmj96iRvPxO4bU3tqs=;
 b=eSTVAPIBn/IeshcOxSG5YOXl9YcP4u2tIS4qB8iMSJKzMimMmNdPEVzjeSeY4fonPBJZYhwwVWIa4xDw/RnS06l6++IyN4XMarkynW4WKl8SlOzWR36XWIZCip/5FMkLVqUhbf0BUsQ0IwUX9VOMo1lifBXTx3/nX8vhnlKia7w=
Received: from CH2PR22MB2056.namprd22.prod.outlook.com (2603:10b6:610:5d::11)
 by CH2PR22MB1846.namprd22.prod.outlook.com (2603:10b6:610:81::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.24; Mon, 30 Nov
 2020 15:40:02 +0000
Received: from CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::1922:c660:f2f4:50fa]) by CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::1922:c660:f2f4:50fa%7]) with mapi id 15.20.3611.031; Mon, 30 Nov 2020
 15:40:02 +0000
From:   "Gong, Sishuai" <sishuai@purdue.edu>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [Race] data race between eth_heder_cache_update() and
 neigh_hh_output()
Thread-Topic: [Race] data race between eth_heder_cache_update() and
 neigh_hh_output()
Thread-Index: AQHWxy8Rr3hrHMLJgUW+yBBlGmJC6Q==
Date:   Mon, 30 Nov 2020 15:40:02 +0000
Message-ID: <8B318E86-EED9-4EFE-A921-678532F36BBD@purdue.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=purdue.edu;
x-originating-ip: [66.253.158.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18b0730f-ebad-47a9-cc95-08d895463408
x-ms-traffictypediagnostic: CH2PR22MB1846:
x-microsoft-antispam-prvs: <CH2PR22MB184625913555184855381620DFF50@CH2PR22MB1846.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sf/1VsrJxEEkv9nc41XoYbMt6iblqXCEyqBkXYVu6RLnIMWVxGb7HV5R3CPZBtBcJ8wU3Eoj6KBB1ZTYfH1Jr996PSk1s/y2nC/xsbdpbl9fUJtlVwcoeB9mRGPDZ/kt9aPwwvrNYZIkdzWTDq8ava0Yqi265C79DGzApi7Yg4hisSsEqQNRpTZy7rXSZOEAoj7qFnsZF33o7TZ0raI6D38ATXhzV1clUPd91YolM9f/ePmyvmQLlMqFQRx4/zFaMqBEzFYfhv5qjYrvQrXZvwTQdD/MlrWN4h1QL/b++1wOwSkAzmj6Phd1F2yGAGFl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR22MB2056.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(376002)(39860400002)(136003)(2616005)(6506007)(6486002)(26005)(186003)(6916009)(6512007)(4326008)(33656002)(66446008)(478600001)(64756008)(71200400001)(66556008)(86362001)(5660300002)(66476007)(76116006)(316002)(83380400001)(786003)(66946007)(8936002)(8676002)(2906002)(75432002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?497aj0tcIHh6T3KkRMlkB4CfezoNwIzCoPm6obDK7t2NGvF0O8jhM1X6C4ZR?=
 =?us-ascii?Q?RYIi/kB2lqkvO1ff8yb12+kWe/f9rgRlN6BLSZHNkSZnjR3DJoPGc4BkeT/9?=
 =?us-ascii?Q?aUEosPTiFDvvIBTGx/o6E/uS1ZgBNvsaUS96cXzHhQm4O+1ggBxRTPHG7ONE?=
 =?us-ascii?Q?gli0LtbagtYbnbTuVsocMG5wTp3RDWmJmogoXz1yBgOQFekFK7+KwNE5pYR7?=
 =?us-ascii?Q?XevMJ8rNLuvksT7GGKjIfd+EctcIqUzby2h3/ldBp31n5AxFIuYVKqa+IYOg?=
 =?us-ascii?Q?kE3I6GRq9mOubqWW6tYYySpMzvzhuGwwvSu+cLz2WKccZA7QqX4G/NITtS3c?=
 =?us-ascii?Q?rdoGo9RxYqFp0cQ6VchtHJhpoUZm5xaZdM7R2XoW/2wxEarfxzAIWqi9ImIK?=
 =?us-ascii?Q?c5j81WvHl4nHjlKqCJ8idfSf5w+dvciArU2JgtQnDfWf4d1oumfDHw2KqgQn?=
 =?us-ascii?Q?ubS9Uzi4cMDoDX0k0Oe4TJUybqC3Wqs1w2XeSR/phnuir5mNdZIMQ6R+APad?=
 =?us-ascii?Q?GxCx2PFR75+K+4JsxvAIrWN/E+Y5mlWpgaldBah6wY2zYyJ7yzgJSDb+KROF?=
 =?us-ascii?Q?PnRmJYpVr6L9IF8EFd5qPnOXwgWBbEW+QKs0TteduNIlsi4semQE69AffF7X?=
 =?us-ascii?Q?Hnl9WFU0DupLwRZJFLC280saO1n6OgAvSThbtiuqLjYeZqA7s6NA4CQa6YcQ?=
 =?us-ascii?Q?RgkDdueYa6yW8SblumGWvlLichCF9UAKrtIAI+dtdEn95YTjMyiNeQVjaRYL?=
 =?us-ascii?Q?ZtWpfmTudUE8qMXVQZHb6dh11bZiS7VlLDF2Bxw9numGpL7ShyNMmx3cSpeJ?=
 =?us-ascii?Q?IOwenYsrJ9lvHLgj9nGeyctvdNcjKrD2C0oQCBX46bP89iquCF1t/ZI/UVWq?=
 =?us-ascii?Q?yIfbo/RpzJbsJQJvkzRHIe6zVqXsFWd+7GCA6AvIfhpmrrmSQF5Agbk68Pih?=
 =?us-ascii?Q?IBiLTsVkVnG72eupHqBKVAkMZTVCFDGg3XOrRtwQlIG8pXnGG/mFnw1qoKZ+?=
 =?us-ascii?Q?02sG?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2F2DD8414F705E46BC89FDD322C46873@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR22MB2056.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18b0730f-ebad-47a9-cc95-08d895463408
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 15:40:02.5041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vfq2Z/Q5Yqt8Q1R3yhLQfFrUHiNj0RYLf/bog8MIxGek3ExaSV2d3Fvj9bm9/bA4d49CpYfWmZTx45BZeXK0jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR22MB1846
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We found a data race in linux kernel 5.3.11 that we are able to reproduce i=
n x86 under specific interleavings. We are not sure about the consequence o=
f this race now but it seems that the two memcpy() can lead to some inconsi=
stency. We also noticed that both the writer and reader are protected by lo=
cks, but the writer is protected using seqlock while the reader is protecte=
d by rculock.

------------------------------------------
Write site

 /tmp/tmp.B7zb7od2zE-5.3.11/extract/linux-5.3.11/net/ethernet/eth.c:264
        252  /**
        253   * eth_header_cache_update - update cache entry
        254   * @hh: destination cache entry
        255   * @dev: network device
        256   * @haddr: new hardware address
        257   *
        258   * Called by Address Resolution module to notify changes in ad=
dress.
        259   */
        260  void eth_header_cache_update(struct hh_cache *hh,
        261                   const struct net_device *dev,
        262                   const unsigned char *haddr)
        263  {
 =3D=3D>    264      memcpy(((u8 *) hh->hh_data) + HH_DATA_OFF(sizeof(struc=
t ethhdr)),
        265             haddr, ETH_ALEN);
        266  }
        267  EXPORT_SYMBOL(eth_header_cache_update);

------------------------------------------
Reader site

/tmp/tmp.B7zb7od2zE-5.3.11/extract/linux-5.3.11/include/net/neighbour.h:481
        463  static inline int neigh_hh_output(const struct hh_cache *hh, s=
truct sk_buff *skb)
        464  {
        465      unsigned int hh_alen =3D 0;
        466      unsigned int seq;
        467      unsigned int hh_len;
        468
        469      do {
        470          seq =3D read_seqbegin(&hh->hh_lock);
        471          hh_len =3D hh->hh_len;
        472          if (likely(hh_len <=3D HH_DATA_MOD)) {
        473              hh_alen =3D HH_DATA_MOD;
        474
        475              /* skb_push() would proceed silently if we have ro=
om for
        476               * the unaligned size but not for the aligned size=
:
        477               * check headroom explicitly.
        478               */
        479              if (likely(skb_headroom(skb) >=3D HH_DATA_MOD)) {
        480                  /* this is inlined by gcc */
 =3D=3D>    481                  memcpy(skb->data - HH_DATA_MOD, hh->hh_dat=
a,
        482                         HH_DATA_MOD);
        483              }
        484          } else {
        485              hh_alen =3D HH_DATA_ALIGN(hh_len);
        486
        487              if (likely(skb_headroom(skb) >=3D hh_alen)) {
        488                  memcpy(skb->data - hh_alen, hh->hh_data,
        489                         hh_alen);
        490              }
        491          }
        492      } while (read_seqretry(&hh->hh_lock, seq));
        493
        494      if (WARN_ON_ONCE(skb_headroom(skb) < hh_alen)) {
        495          kfree_skb(skb);
        496          return NET_XMIT_DROP;
        497      }
        498
        499      __skb_push(skb, hh_len);
        500      return dev_queue_xmit(skb);
        501  }

------------------------------------------
Writer calling trace

- ksys_ioctl
-- do_vfs_ioctl=20
--- vfs_ioctl
---- arp_ioctl
----- arp_req_set
------ neigh_update
------- __neigh_update

------------------------------------------
Reader calling trace

- __sys_sendto
-- sock_sendmsg
--- inet_sendmsg
---- ip_push_pending_frames
----- ip_send_skb
------ ip_local_out
------- ip_finish_output
-------- __ip_finish_output
--------- ip_finish_output2


Thanks,
Sishuai

