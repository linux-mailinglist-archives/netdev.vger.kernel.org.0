Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9AC9143F30
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbgAUOQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:16:44 -0500
Received: from mail-am6eur05on2072.outbound.protection.outlook.com ([40.107.22.72]:6169
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727255AbgAUOQn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 09:16:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8U+d522YcL9MgS8SI4sxhi03ZmoeL3BHhOHN7kFgIxUSou8ZSGKhDZUuLzUnu+ZYZhp5jTzd0Meft/IiG/1ys9IESxh8I5iq5MKGNKL47IIfvaPHZdyLYdUguyhUTj6f9sJxyQezYLMRWcs88ZqzIVY1L1NeNipuGuYJ/fnCJ6iULE7UnUpZn+oaFC9vgyBoo/DJZjZKF7Ba57Vi6PijbXaQdcIxxYnuIB8UUX9xDfSd8/1g3SmJY85W79H+NB9VW9GGz2Do93Sei4KzxinAGLuMmbKEOMPQTWRgS4iVnDM9E4Buo5LgDvqgZeWr22DgPngtRT5yul1jTNAxjXAyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCH80eXZ7bqqMkf36udYmaEVuniV/FtXWCD4uuMo6vc=;
 b=PARLI2R7a0x9KgJiBNDABItGuGMzfQrGH8mJ4web82pBVxqmcXnEJjdfSYhbxtcZpPmyUp1TI7z7veYVdXK01QhThW1FGx1Mej2VXIM74d0Z26DS6J4BI5616a8RuIlDrhtqP3rrUafCc5UjCvdZ1j/uE52y4k+Y3um9swCduKTFZQmWco29pmBAhGM0s144pJn7qAWgp87oFCr6fCp/uHonzgs+wRgc+OAXdtcgLkyIw0ena0klgvDiD4lsMyXI4vn9vG4uAc6G3kPmUcNsQziy44YxG6z6+tTCTF6kpjugBZNWqShgr3WRFUBmLAEsRkHfBejWAzRM+bgZ8k1/gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCH80eXZ7bqqMkf36udYmaEVuniV/FtXWCD4uuMo6vc=;
 b=Ao7eK9JOBYc+R56f/BhARKe+ypp0XN7N/cucwFBXLM/Qz+n3ujO/VADO8m5RkXsjcZhoTvJ3CC9Ayn3Exo8peF0yWuvJcr6z1IyL7YxO6HIWcjzs3VvMKUhKjA9ITie24cEGoxM+fIGg0gYDJDpuQKDlHAEPL3MAV2ucKt9SODw=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB6126.eurprd05.prod.outlook.com (20.178.205.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Tue, 21 Jan 2020 14:16:40 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 14:16:40 +0000
Received: from mlx.ziepe.ca (12.231.255.114) by SN2PR01CA0079.prod.exchangelabs.com (2603:10b6:800::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Tue, 21 Jan 2020 14:16:39 +0000
Received: from jgg by jggl.ziepe.ca with local (Exim 4.90_1)    (envelope-from <jgg@mellanox.com>)      id 1ituKY-00035c-QD; Tue, 21 Jan 2020 10:16:34 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Topic: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Index: AQHVzGqUgTlkW8H4N0+zRVK4Lh0XAKftaJqAgADD3wCAALX/gIAEm9kAgABdJwCAAESHAIABEKoAgAAA5wCAAABfAA==
Date:   Tue, 21 Jan 2020 14:16:40 +0000
Message-ID: <20200121141634.GE12330@mellanox.com>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200116152209.GH20978@mellanox.com>
 <03cfbcc2-fef0-c9d8-0b08-798b2a293b8c@redhat.com>
 <20200117135435.GU20978@mellanox.com>
 <20200120071406-mutt-send-email-mst@kernel.org>
 <20200120175050.GC3891@mellanox.com>
 <20200120164916-mutt-send-email-mst@kernel.org>
 <20200121141200.GC12330@mellanox.com>
 <20200121091456-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200121091456-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN2PR01CA0079.prod.exchangelabs.com (2603:10b6:800::47) To
 VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.231.255.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 37639b1b-4aa5-4aa1-cd4b-08d79e7c8885
x-ms-traffictypediagnostic: VI1PR05MB6126:|VI1PR05MB6126:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6126BCD4EEEE23AED16A93FACF0D0@VI1PR05MB6126.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(199004)(189003)(26005)(81156014)(6666004)(86362001)(7416002)(6916009)(71200400001)(52116002)(8936002)(186003)(1076003)(478600001)(33656002)(81166006)(8676002)(2616005)(5660300002)(4326008)(9746002)(66556008)(36756003)(66476007)(66946007)(9786002)(64756008)(66446008)(54906003)(2906002)(316002)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6126;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HBb2HjUb6cFHXgKJ42DNH7D5hc43lPvYED8SiR8frHJ+Zx5XUAb5RGuy8puffLjMYSm19VanihwR1OQUSNQ9uDHofhUeBC34V/7eHrF1m9+XdqiHoU1rJOJnD/IQlc6stfdxJxLP/WSRWqM8U7H5CKHzcCJ0aKDbyIMRts3ITANYCE8eebrw+MIaDTPZU1hpeC7WU9NfmunN60mGnrJMjhAQILWkHMtFJDtZz2BIXfGfwuHmEU9HS9ksvoZNL97pplcJ2yJazPikHEhncKu7LZjovpNFpq/wqYNAzwuCykCSVo+1VRobusPziKVPfXVyDDw1LoDqPUtvihPMrqV2NKg4s82PC+jMB4v5mcumyz8xrhyI8Qx3y+ymEKezYijt+VUF/Rjm1rYL77ssPAnd48a/hNOvjs2WB7DlN85BfLveTVmFAOb9OWY4NnVi00R6Mn7BAJAqLgFsc43xJcayit1Oc7puQ1ApN7kPkw6t8Cy7f3AvFGiq44K3mNyIPyRo
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D789572F2035E04481FCBAD167A48367@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37639b1b-4aa5-4aa1-cd4b-08d79e7c8885
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 14:16:40.1307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lKgxVrsiCRsDXT4b7VnLsz1tkL+xvmCVExF3vGdQNlEDcZl1TjILGp/BIhF0jg2RztnZzFYRZrWfXMXWxZoZ8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 09:15:14AM -0500, Michael S. Tsirkin wrote:
> On Tue, Jan 21, 2020 at 02:12:05PM +0000, Jason Gunthorpe wrote:
> > On Mon, Jan 20, 2020 at 04:56:06PM -0500, Michael S. Tsirkin wrote:
> > > > For vfio? vfio is the only thing I am aware doing
> > > > that, and this is not vfio..
> > >=20
> > > vfio is not doing anything. anyone can use a combination
> > > of unbind and driver_override to attach a driver to a device.
> > >=20
> > > It's not a great interface but it's there without any code,
> > > and it will stay there without maintainance overhead
> > > if we later add a nicer one.
> >=20
> > Well, it is not a great interface, and it is only really used in
> > normal cases by vfio.
> >=20
> > I don't think it is a good idea to design new subsystems with that
> > idea in mind, particularly since detatching the vdpa driver would not
> > trigger destruction of the underlying dynamic resource (ie the SF).
> >=20
> > We need a way to trigger that destruction..
> >=20
> > Jason=20
>=20
> You wanted a netlink command for this, right?

It is my suggestion.

Based on experiance here we started out with sysfs and it was OK, but
slow. When we added container support the entire sysfs thing
completely exploded and we had to replace it with netlink.

Jason
