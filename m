Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B56143EEB
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgAUOIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:08:05 -0500
Received: from mail-eopbgr10055.outbound.protection.outlook.com ([40.107.1.55]:56567
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727817AbgAUOIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 09:08:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3+Tah1ok+DnBXhl8wuDQ7njNX6Ho0BLu8wLddK7Sa4okN96AQeDwwuXy00c8JlE1h2SoRxoaEOJAwE5/41goQUqEL9VH+ebutofdl+KgLP1QO/gLAaMpKspDUdDrfLu7vOdsgqIyRrSxyMcgzkwk9CFiWH1axfbbBC3krbaP8jJIThHNuUqPjCQmn/tWoxFXHAzL1PnEwv87I9ESCnwureIJ5mOfemb7MvHcAepx1HfMU3r1A29W07q2d/MZwUP2Zu69yTJdSFusQqh8paMzxiTR7Vd4uSpovO1aSW3BQwhZbYAGo0yrygb6+EisDAKzAqo1BxAbvkTgGd40K2ycQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZY0HXOflSA6ogq/reDfCaMlevs6iJQM5GeBmBjWTXs=;
 b=OLbb75QoWSyC8Wm5LLvvmbPBW+QLm1iigSCOP6i4ZfT6R/1G/kQpcT6T9mi/NOFeGjeWCjAPd6Nqcvop5qDyau3uLn/mleCmPPqpYJJr1qPXJzI2M8LEm8dbXZB55tvwP/hpQ2mwUlQup+tKiIgJJwXgkSwTyXuTyaPWDdCi/9KSHalzKhL53F2WHSjWoaZtug2j94I/QG/vGRvWuquF4WoFvS8JsGjmOAyYkKOb38353JjPwBHkAiLxatFlrhLkIj8PYixYd+K3YqR7JltRQjKK22mv+Jd/S0xPck8EohNvmwYnSMfJQrhK8GYYZlSCf6fBeehPh1L/Hr/KHWLSFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZY0HXOflSA6ogq/reDfCaMlevs6iJQM5GeBmBjWTXs=;
 b=mSCeZlDdPHh/4vyg/DsZMcwqF+PdL6pixBhROVCbMXgfHSA9j7+ickC/IoNTTsCIthBS/ujNJZ0J3BpMTwuyE4ojeYZsxcmfPzH1VbaEu1pjC+KN2xysfplQm0J7m7APn4rPyDrNX7D01GA5MOkMUCi5vEw/AkzShyOjHUZKQ7s=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB4512.eurprd05.prod.outlook.com (52.133.14.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.22; Tue, 21 Jan 2020 14:07:59 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 14:07:59 +0000
Received: from mlx.ziepe.ca (12.231.255.114) by SN4PR0701CA0026.namprd07.prod.outlook.com (2603:10b6:803:2d::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Tue, 21 Jan 2020 14:07:59 +0000
Received: from jgg by jggl.ziepe.ca with local (Exim 4.90_1)    (envelope-from <jgg@mellanox.com>)      id 1ituCB-00032N-4c; Tue, 21 Jan 2020 10:07:55 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Shahaf Shuler <shahafs@mellanox.com>,
        Jason Wang <jasowang@redhat.com>,
        Rob Miller <rob.miller@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        "Bie, Tiwei" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Ariel Adam <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Topic: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Index: AQHVzGqUgTlkW8H4N0+zRVK4Lh0XAKfuxkEAgAAbnwCAAAWygIACz0CAgAGL1YCAAJh1gIAAMuaAgAAJaICAARgbgA==
Date:   Tue, 21 Jan 2020 14:07:59 +0000
Message-ID: <20200121140755.GB12330@mellanox.com>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
 <20200120174933.GB3891@mellanox.com>
 <AM0PR0502MB3795C92485338180FC8059CFC3320@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <20200120162449-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200120162449-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0701CA0026.namprd07.prod.outlook.com
 (2603:10b6:803:2d::24) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.231.255.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: acf5f34e-40fd-4f16-9a8c-08d79e7b5218
x-ms-traffictypediagnostic: VI1PR05MB4512:|VI1PR05MB4512:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB45124D5F3CAE60D41E3BB1B4CF0D0@VI1PR05MB4512.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(199004)(189003)(478600001)(86362001)(81156014)(8676002)(8936002)(81166006)(9746002)(36756003)(66946007)(64756008)(66556008)(66446008)(66476007)(7416002)(2906002)(316002)(6916009)(186003)(71200400001)(5660300002)(4326008)(26005)(52116002)(9786002)(1076003)(33656002)(2616005)(54906003)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4512;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uOjUywRNc0A/0nWqKzv/w8C+ug80ncUf9xZKqaS4rUWiD+LCgPOpAq153IlkPKUW1W9PWpZj8rwsD9B42iwA6aFSIyaoDsmAgm3urrqOxkduuYuwo3vXEk5fjtQPlmIBayLic88ovB50cgjh/DfZSJmDBoO6ZSwrctT+s6Y29GsCSzcWO9UsKDIINNujmxU6bEde0PTSjWQdfZisoTrB8D1zhyuC1890D6gD7e1qIrFi2fRpYFzlLyKFk0JbTO8IyNqHtE7GTeWWHgREd0OgB4L2xAWz42u/hdeQ3FrCSsW1kPoV0vqlgZoVezgGdUP7fFRXtSkR7LDEAJnOmRBeMiJn4JBV+1cPDsvLaplu+vQF8OZtrr63hypIR6fMLk+P0OMjk9ZA5S+eAsYQOXr+Lkg4c8ViDoTmf1LXUpYlV1aZlBeQRGnH01S3sT+UPdazGIQemgBM3POm0La9O7+haEIukSolQTqf9LgIAAqATB1NrxMSgiZffrHP6Gp5dSYH
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DA8054F3EAA1074B8B36A071C759522B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acf5f34e-40fd-4f16-9a8c-08d79e7b5218
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 14:07:59.3113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r3DzMNMycWf7/ozGh2jSMLYD45/MXQhC94LNiWOZzGprK9HQyZ7VTnoiuvi2bEFNGvMoaNiu0LMcgNaSrixtDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 04:25:23PM -0500, Michael S. Tsirkin wrote:
> On Mon, Jan 20, 2020 at 08:51:43PM +0000, Shahaf Shuler wrote:
> > Monday, January 20, 2020 7:50 PM, Jason Gunthorpe:
> > > Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
> > >=20
> > > On Mon, Jan 20, 2020 at 04:43:53PM +0800, Jason Wang wrote:
> > > > This is similar to the design of platform IOMMU part of vhost-vdpa.=
 We
> > > > decide to send diffs to platform IOMMU there. If it's ok to do that=
 in
> > > > driver, we can replace set_map with incremental API like map()/unma=
p().
> > > >
> > > > Then driver need to maintain rbtree itself.
> > >=20
> > > I think we really need to see two modes, one where there is a fixed
> > > translation without dynamic vIOMMU driven changes and one that suppor=
ts
> > > vIOMMU.
> > >=20
> > > There are different optimization goals in the drivers for these two
> > > configurations.
> >=20
> > +1.
> > It will be best to have one API for static config (i.e. mapping can be
> > set only before virtio device gets active), and one API for dynamic
> > changes that can be set after the virtio device is active.=20
>=20
> Frankly I don't see when we'd use the static one.
> Memory hotplug is enabled for most guests...

If someone wants to run a full performance application, like dpdk,
then they may wish to trade memory hotplug in that VM for more
performance.

Perhaps Shahaf can quantify the performance delta?

Jason
