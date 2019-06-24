Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE2051A40
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 20:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732742AbfFXSGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 14:06:07 -0400
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:47879
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727764AbfFXSGG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 14:06:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ijA2NVHv1SeKpAsESZTMKXSF+O6acni2lbii8yc5/4E=;
 b=Ko9i/AY3BnoZgEaV37zD8MHFzqKaM/I0bfPJXeAS+XNYjaVQOEyYfDP12l6cLkIxY5zhm7qQJuRquS4B6I2ol82CaFOeQrPO6WD+va6RfIDy/SMUp27QFmEv//+pEDrX2UOL3bar56oAn38nkeK2AUYvK0k4b+FOhY0ulyt6BOM=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 18:06:02 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 18:06:02 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Yishai Hadas <yishaih@dev.mellanox.co.il>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 11/12] IB/mlx5: Implement DEVX dispatching
 event
Thread-Topic: [PATCH rdma-next v1 11/12] IB/mlx5: Implement DEVX dispatching
 event
Thread-Index: AQHVJfmOhAl6cjxbGkeHYVIPFHC63aaqvcMAgABRjgCAABOuAA==
Date:   Mon, 24 Jun 2019 18:06:02 +0000
Message-ID: <20190624180558.GL7418@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-12-leon@kernel.org>
 <20190624120338.GD5479@mellanox.com>
 <3a2e53f8-e7dd-3e01-c7c7-99d41f711d87@dev.mellanox.co.il>
In-Reply-To: <3a2e53f8-e7dd-3e01-c7c7-99d41f711d87@dev.mellanox.co.il>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0135.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::27) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [66.187.232.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e65988a3-c9e0-4686-60b4-08d6f8ce9e0f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4109;
x-ms-traffictypediagnostic: VI1PR05MB4109:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <VI1PR05MB4109317014D5F5865D60BA48CFE00@VI1PR05MB4109.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(39860400002)(396003)(199004)(189003)(66066001)(6246003)(6512007)(81156014)(8676002)(81166006)(7736002)(68736007)(71190400001)(25786009)(478600001)(305945005)(316002)(54906003)(6862004)(4326008)(3846002)(6116002)(33656002)(6306002)(229853002)(966005)(53936002)(14454004)(36756003)(52116002)(8936002)(99286004)(26005)(6486002)(186003)(6436002)(386003)(102836004)(6506007)(76176011)(66556008)(446003)(14444005)(256004)(476003)(5660300002)(66476007)(1076003)(486006)(11346002)(66946007)(71200400001)(66446008)(64756008)(86362001)(2906002)(73956011)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4b88zScue+SwoF3y/lOdc9BCgvzxd6XzOHqEpS88XpPHkyvGCO3id/OMyiAuGed53ICjdA+ijoKs7Tg38k6HeB4PZJpMVGn+DivEuN5oA2uLXXcKLrpEZ5zcYDrip3rdXoLmRJ/XgdFBvFYAwz9wZcFn1kxwHUS8hJJiXmX9OdIp5Xuqo6YYfcAmYKariBOqdtqMDgdqFaZh15FShJIjUdcHwA05uNNoOSn43bHg+mYncoqWQD/ZjvQi6zt61QNFOuEzrSZqiKfCCfnQrGM+p8sXKe2XE0EjFDrtmyMoVEKF+4BoT03sDpjARlOj6lkFDeCI+Atxi35YALaWyf05vcT0dcxQ6U9nug818LjyxVWfA3CJGO3GJ7o91qE+0paF5MQewWup91wm77iOwn8A0rFHizoFmQCdFYgNbB3sdWc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CB263FBA6C9D2E498943F803633251F5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e65988a3-c9e0-4686-60b4-08d6f8ce9e0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 18:06:02.1021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 07:55:32PM +0300, Yishai Hadas wrote:

> > > +	/* Explicit filtering to kernel events which may occur frequently *=
/
> > > +	if (event_type =3D=3D MLX5_EVENT_TYPE_CMD ||
> > > +	    event_type =3D=3D MLX5_EVENT_TYPE_PAGE_REQUEST)
> > > +		return NOTIFY_OK;
> > > +
> > > +	table =3D container_of(nb, struct mlx5_devx_event_table, devx_nb.nb=
);
> > > +	dev =3D container_of(table, struct mlx5_ib_dev, devx_event_table);
> > > +	is_unaffiliated =3D is_unaffiliated_event(dev->mdev, event_type);
> > > +
> > > +	if (!is_unaffiliated)
> > > +		obj_type =3D get_event_obj_type(event_type, data);
> > > +	event =3D xa_load(&table->event_xa, event_type | (obj_type << 16));
> > > +	if (!event)
> > > +		return NOTIFY_DONE;
> >=20
> > event should be in the rcu as well
>=20
> Do we really need this ? I didn't see a flow that really requires
> that.

I think there are no frees left? Even so it makes much more sense to
include the event in the rcu as if we ever did need to kfree it would
have to be via rcu

> > > +	while (list_empty(&ev_queue->event_list)) {
> > > +		spin_unlock_irq(&ev_queue->lock);
> > > +
> > > +		if (filp->f_flags & O_NONBLOCK)
> > > +			return -EAGAIN;
> > > +
> > > +		if (wait_event_interruptible(ev_queue->poll_wait,
> > > +			    (!list_empty(&ev_queue->event_list) ||
> > > +			     ev_queue->is_destroyed))) {
> > > +			return -ERESTARTSYS;
> > > +		}
> > > +
> > > +		if (list_empty(&ev_queue->event_list) &&
> > > +		    ev_queue->is_destroyed)
> > > +			return -EIO;
> >=20
> > All these tests should be under the lock.
>=20
> We can't call wait_event_interruptible() above which may sleep under the
> lock, correct ? are you referring to the list_empty() and
> is_destroyed ?

yes

> By the way looking in uverb code [1], similar code which is not done unde=
r
> the lock as of here..
>=20
> [1] https://elixir.bootlin.com/linux/latest/source/drivers/infiniband/cor=
e/uverbs_main.c#L244

Also not a good idea

> > Why don't we return EIO as soon as is-destroyed happens? What is the
> > point of flushing out the accumulated events?
>=20
> It follows the above uverb code/logic that returns existing events even i=
n
> that case, also the async command events in this file follows that logic,=
 I
> suggest to stay consistent.

Don't follow broken uverbs stuff...

> > Maybe the event should be re-added on error? Tricky.
>=20
> What will happen if another copy_to_user may then fail again (loop ?) ...
> not sure that we want to get into this tricky handling ...
>=20
> As of above, It follows the logic from uverbs at that area.
> https://elixir.bootlin.com/linux/latest/source/drivers/infiniband/core/uv=
erbs_main.c#L267

again it is wrong...

There is no loop if you just stick the item back on the head of the
list and exit, which is probably the right thing to do..

> > > @@ -2374,6 +2705,17 @@ static int devx_hot_unplug_async_cmd_event_fil=
e(struct ib_uobject *uobj,
> > >   static int devx_hot_unplug_async_event_file(struct ib_uobject *uobj=
,
> > >   					    enum rdma_remove_reason why)
> > >   {
> > > +	struct devx_async_event_file *ev_file =3D
> > > +		container_of(uobj, struct devx_async_event_file,
> > > +			     uobj);
> > > +	struct devx_async_event_queue *ev_queue =3D &ev_file->ev_queue;
> > > +
> > > +	spin_lock_irq(&ev_queue->lock);
> > > +	ev_queue->is_destroyed =3D 1;
> > > +	spin_unlock_irq(&ev_queue->lock);
> > > +
> > > +	if (why =3D=3D RDMA_REMOVE_DRIVER_REMOVE)
> > > +		wake_up_interruptible(&ev_queue->poll_wait);
> >=20
> > Why isn't this wakeup always done?
>=20
> Maybe you are right and this can be always done to wake up any readers as
> the 'is_destroyed' was set.
>=20
> By the way, any idea why it was done as such in uverbs [1] for similar fl=
ow
> ? also the command events follows that.

I don't know, it is probably pointless too.

If we don't need it here then we shouldn't have it.

These random pointless ifs bother me as we have to spend time trying
to figure out that they are pointless down the road.

Jason
