Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEAD57D415
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 21:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbiGUTYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 15:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbiGUTYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 15:24:18 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020019.outbound.protection.outlook.com [52.101.61.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633BA88F1B;
        Thu, 21 Jul 2022 12:24:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0HQu/uX502LG50fvpa4UCq5Pz8tLyVgflgGpD+9TICS4NCgaWMP+Lho8FVQ618LUxEPcWAlCMsqpMTOWeFJ4cHaGwcVz4Y18RaQV3gtUEIFMsF8rTENmVBoXAAXv8RTLEdJ6kfcpuxRdxVX0KO3mk/0jikeDyAoHrRKODwCCA/UXp8/SEV1WLBoIKw8wL5BQ24wpwS6zv0/gj2KlMagYOLrmcaD6MlORUXckky4AeAR/i3I49TYuW1NhELv39GSlZm8F9sjQmoVgOMNdbqUQXRN2xVz0Xgw0EoZWYqmRpvcTjYB5WSuw3haBYS3bGyOcfAzOY89M7fgKrEdiwgz0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=up+K7OljUP3tzlkWMo+JeqmVW61gVaqJ45ljF6uYoN4=;
 b=AXXhJ+fnGuN2DpOqOUTIlTx9/ykRxKo2wb0SEDA81ao6M3Il/WmjVrfSLJ5iDWUcYoBLjdUIH1YKOJIyPkYzZP8oIy3y7rvGjxAglY/O5UK8WYj9qGh5I2Et2U49M2fqe5NQoCO/mhqflCqhMLZx7w0z39lDostR5VcDP8WLuHgqd89+kV3JB1IlhVeM1/kWg9WEiF8RaWmbeiPiSRFwg4OXOelINIfEB/n1BPyt1U+Sv7osezf1Qmye9Mce9IC32c8HFY6HBayGwattt5P62F+KoXThM+HmokEZzQHgsTj8ODcDdbhpinhzshuVfpC+XqlRc5vmGSfDWwlYIJH+wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=up+K7OljUP3tzlkWMo+JeqmVW61gVaqJ45ljF6uYoN4=;
 b=ac0XKfrN+4za9+Ib38KtOqQ+tT4UraXi0MYVM+8jaUgdaRjZyZZvbDW/eraXOHfp0z6kTa/6XAhAPf2EfxXN3DrkKrF1ciTkudC6bEo1ec7PAVezC91aJFc/vvBu7zTthL/kie7InyCi3/qDM66tR7gZalQsH17tRO1PZ7LtX4A=
Received: from BL1PR21MB3283.namprd21.prod.outlook.com (2603:10b6:208:39b::8)
 by PH7PR21MB3117.namprd21.prod.outlook.com (2603:10b6:510:1d1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.1; Thu, 21 Jul
 2022 19:24:14 +0000
Received: from BL1PR21MB3283.namprd21.prod.outlook.com
 ([fe80::b1e4:5093:ad3b:fdcb]) by BL1PR21MB3283.namprd21.prod.outlook.com
 ([fe80::b1e4:5093:ad3b:fdcb%5]) with mapi id 15.20.5482.001; Thu, 21 Jul 2022
 19:24:14 +0000
From:   Ajay Sharma <sharmaajay@microsoft.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, Long Li <longli@microsoft.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>
Subject: RE: [EXTERNAL] Re: [Patch v4 12/12] RDMA/mana_ib: Add a driver for
 Microsoft Azure Network Adapter
Thread-Topic: [EXTERNAL] Re: [Patch v4 12/12] RDMA/mana_ib: Add a driver for
 Microsoft Azure Network Adapter
Thread-Index: AQHYnJNcseulqCCCd0emqwO4CIUe562JNWsg
Date:   Thu, 21 Jul 2022 19:24:14 +0000
Message-ID: <BL1PR21MB3283D431BE457B0FB1BA914DD6919@BL1PR21MB3283.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
 <20220720234924.GA406750@nvidia.com>
In-Reply-To: <20220720234924.GA406750@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a118a330-b43b-4506-b2ab-431e7927f25e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-21T19:22:58Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 126a3918-d0d0-47fd-5ddd-08da6b4e98ff
x-ms-traffictypediagnostic: PH7PR21MB3117:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v1UlQhk5+b8b4ONtWxv74vGNzA2CW6jInTr3GMRx788MfY/OVN9HpRANFpb0ILtFSwOIxgOFSeBS2aBg4rRlZ3SsWV/FUxUO8N/gev2pOTHr/rWiZfV963jFqi5yKjtyqF1CcX2Ss+AIxV57AZ+dc/0COA9a1Yiov/VggeqbshcbYAK4fVafhu+JxC2FvljgYkkb/ske01JhckNVcW5tgU0zYl7aMEkS0BVzn64f07TAPtgvHqziv36tVpVrPCj5qsN6Er+2TC08VGVkzOvzx/TotPUzd6UXGTSBEk5OWZPacfYUM9vPW6LRFBXJwKePnVVoTHVvI37y9sqT73NCLcxungpJ9xj1Q1O1Q1lH5M2fWDrIT2KnlNo3T+WmCz70tE+fc8QI132MiyHeKr2PIQ0hyHAaHRBk/I4Pvy8Vaf0eYw0DsCHqCbMvM07lmvA74EPULWGVqD+zh0a+B1/X3EeJrG9CUm6wz15DnEWZS41IhnuhZ8gtnJxxihvcmiHfALroTJj4rACtFTumt5gtojVuQh+WI5RKIUAanJkOPGmw2rJHwoJ/ssh0w/bnyMFX7wXHVbOjCXlIYJchYi2DFyjCQia0x7CrdRUSLEDbEzT83HZnMUaon+eG/3fn9tv/SpRtSrmiPvuYNsCav434CcvLV4yuxA5MjNYt7FHA4OsgnakHdyP719CAMbwGaW+8X7Jq9qq9m1VVpzlBdmoPd/eILXdVJjPPbQLpa49EnkoNMRO3k4e7fXL4e+ZMdfH8+n9+yAhS2xAi/+/X2kQcsCjHNA1L5L/DLzbdS3MbVtd6k3nku9ga75EDeYrBc6/QI+k9BrI/bDU2v5LtkzAGcWpJHk3ukFAqGgMNef7F78U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR21MB3283.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(47530400004)(451199009)(52536014)(110136005)(316002)(82950400001)(6636002)(82960400001)(53546011)(9686003)(54906003)(107886003)(38070700005)(33656002)(5660300002)(66446008)(8936002)(64756008)(66556008)(8676002)(6506007)(122000001)(55016003)(186003)(41300700001)(7696005)(7416002)(66476007)(4326008)(76116006)(86362001)(38100700002)(83380400001)(8990500004)(2906002)(478600001)(71200400001)(10290500003)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eBssN6BDQ1I0RTbOkNWyjLpNV7QTWlnhP8IokoLWOQwOqoFPF6AT+Ffu6PH3?=
 =?us-ascii?Q?UjK+r1Ct0joh+QWKQZosSYGhKdD/jJTprrk/exCw1QEgnDm6gpJPgT9gn0J4?=
 =?us-ascii?Q?9JWGp0GkeHSkxMtt1YPjaxaD+JI3t+w5eN2xUEc6yaUubXVokv8xluxL8g0c?=
 =?us-ascii?Q?1RtQPbTj8EpVkL4dmzINUsiS9Qb9eK4kiojvaU3Ps+JDTOLKC5WkxVlQ11S/?=
 =?us-ascii?Q?Kk04V4i/7DYbeVW+JXf8B2LZZacAW5ZYybjj9jmVxVE96B8oYNGg+c+JgLEt?=
 =?us-ascii?Q?czt+BmY+n4OHhVlJsPQFV97hWucxQ+cwNYaBO2mZJEGUfTgDc67oMofhrHHU?=
 =?us-ascii?Q?T79VzniSsu8M5SQPVDkyKQUL79LzOGtU6Z8UKByncd3RqZSyVRzBS2coUeYF?=
 =?us-ascii?Q?8vKtE6puTfYN9JofND7tjWiDql1PVcfcW7LOvHTvgZqqmfVJdtCbvx2NgL9x?=
 =?us-ascii?Q?EDWDHot/4IJYh+TrFxsJopQ+PntPycHM5ArOH/i2Lt2+yEvvknB6wWvApNNZ?=
 =?us-ascii?Q?aAUlATXkv9KuUNbiAucHPUPTuVhtp/TjpCfPRoYYvoBuNKpbHvNcwMOGMFC2?=
 =?us-ascii?Q?0zp5ARXr/GBi+6iqJX9ST9OBhfKBw7ep7lUWHsMfyRBqvs6iIFHdegNvjYs0?=
 =?us-ascii?Q?rXDCWc4xMfgVJOjj8ELa35dtdyJvONxI1ImlI3TyZrTp1A3165KUzHoz2uzc?=
 =?us-ascii?Q?/N0Bwo73wTGN5RLTFeJoRUWRbS+hmZC5mTmdpUJoVrCG3GYbqp7/wR/pYm5U?=
 =?us-ascii?Q?mFAIjywnmcd1y/5gVQneLFf0UQyOuTexp3oVC7Qi6/yjldHeHJLxk7EmI0G/?=
 =?us-ascii?Q?xQI6BniVnRc4iRGBF8VbnPHZJ7nV1vyMGkwOKvItiqMpT7GF0EmKvR+2yFm0?=
 =?us-ascii?Q?9ijs2QVzK5rdurK8UKFVdbt0pXJp3RRzWA3Su4rSfFINYvVDLnnmxX3NCkd3?=
 =?us-ascii?Q?UnCWWVGla8qyERNAZKOAIdlekdxqlGLnydZiATftogwfT0kq5ubN/sn5E1fY?=
 =?us-ascii?Q?OIusWyU1xP34Cig8wMVF8oPvzdJSjaaOnAry8wJWJy+ie82IXYdvjUEOMFIQ?=
 =?us-ascii?Q?nJl2e+IdD7ZBJzYU9hb0asV1PRkEhgLoYcAjjuUk5cipyLuzBQDNxw01eLs2?=
 =?us-ascii?Q?NLNuSNBBsYirC13fZa0sToWcn8JfLL2+f1VUG/MbWg1aCf5wZ2Ycs44pRAFa?=
 =?us-ascii?Q?MqvP+jXLKhwQU+vS6ARFdAnYZ2YxKMpDljajKmMeqyiq1iNXE752oMoL1NiR?=
 =?us-ascii?Q?B68BuoR6Ync8sXAJ2nymVMUY9jHZBIPFqbUEsdsiO7CQYnYt7ltPvdgNpCT2?=
 =?us-ascii?Q?d7f1TbnNsSM4JZ/sTVN5+42gW5ZJ/ikKS/m8wZiEXIjFB77JR6a7ZHptMQ4G?=
 =?us-ascii?Q?5pi/1NC7qn8oFyrztVdGK2/G0Qy2z7FnVRNkb4MLxUegRsS/wyy2us7pI4nO?=
 =?us-ascii?Q?jDn10IqnLZUSrH5l94crsvmaWDRfuOREQHo0P3uA8c6ouZsRfp37RNZmUuru?=
 =?us-ascii?Q?XNNefrN9m+ajdR6g2lEYpNjZbkX6+iJxAfeV9mPcTna5gYjcbqe756U8iZWy?=
 =?us-ascii?Q?yecuoUCZVfdZlHEuGEB6cIsagiOeYJMYUVXTlofO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR21MB3283.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 126a3918-d0d0-47fd-5ddd-08da6b4e98ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 19:24:14.4683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5o0BMCzJ6F/xkLZP3Hvv82LG2qeoRyJXW/l7ZMeTiABxTReM41YaUHwzm5xuK5ASRuH8CHqiyui8v/6pifpbVP86U3G/V12/dsrbY83NZK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3117
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, July 20, 2022 6:49 PM
> To: Long Li <longli@microsoft.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Dexuan Cui
> <decui@microsoft.com>; David S. Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Leon
> Romanovsky <leon@kernel.org>; edumazet@google.com;
> shiraz.saleem@intel.com; Ajay Sharma <sharmaajay@microsoft.com>; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org
> Subject: [EXTERNAL] Re: [Patch v4 12/12] RDMA/mana_ib: Add a driver for
> Microsoft Azure Network Adapter
>=20
> On Wed, Jun 15, 2022 at 07:07:20PM -0700, longli@linuxonhyperv.com
> wrote:
>=20
> > +static int mana_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata
> > +*udata) {
> > +	struct mana_ib_pd *pd =3D container_of(ibpd, struct mana_ib_pd, ibpd)=
;
> > +	struct ib_device *ibdev =3D ibpd->device;
> > +	enum gdma_pd_flags flags =3D 0;
> > +	struct mana_ib_dev *dev;
> > +	int ret;
> > +
> > +	dev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
> > +
> > +	/* Set flags if this is a kernel request */
> > +	if (!ibpd->uobject)
> > +		flags =3D GDMA_PD_FLAG_ALLOW_GPA_MR |
> GDMA_PD_FLAG_ALLOW_FMR_MR;
>=20
> I'm confused, this driver doesn't seem to support kverbs:
>=20
> > +static const struct ib_device_ops mana_ib_dev_ops =3D {
> > +	.owner =3D THIS_MODULE,
> > +	.driver_id =3D RDMA_DRIVER_MANA,
> > +	.uverbs_abi_ver =3D MANA_IB_UVERBS_ABI_VERSION,
> > +
> > +	.alloc_pd =3D mana_ib_alloc_pd,
> > +	.alloc_ucontext =3D mana_ib_alloc_ucontext,
> > +	.create_cq =3D mana_ib_create_cq,
> > +	.create_qp =3D mana_ib_create_qp,
> > +	.create_rwq_ind_table =3D mana_ib_create_rwq_ind_table,
> > +	.create_wq =3D mana_ib_create_wq,
> > +	.dealloc_pd =3D mana_ib_dealloc_pd,
> > +	.dealloc_ucontext =3D mana_ib_dealloc_ucontext,
> > +	.dereg_mr =3D mana_ib_dereg_mr,
> > +	.destroy_cq =3D mana_ib_destroy_cq,
> > +	.destroy_qp =3D mana_ib_destroy_qp,
> > +	.destroy_rwq_ind_table =3D mana_ib_destroy_rwq_ind_table,
> > +	.destroy_wq =3D mana_ib_destroy_wq,
> > +	.disassociate_ucontext =3D mana_ib_disassociate_ucontext,
> > +	.get_port_immutable =3D mana_ib_get_port_immutable,
> > +	.mmap =3D mana_ib_mmap,
> > +	.modify_qp =3D mana_ib_modify_qp,
> > +	.modify_wq =3D mana_ib_modify_wq,
> > +	.query_device =3D mana_ib_query_device,
> > +	.query_gid =3D mana_ib_query_gid,
> > +	.query_port =3D mana_ib_query_port,
> > +	.reg_user_mr =3D mana_ib_reg_user_mr,
>=20
> eg there is no way to create a kernel MR..
>=20
> So, why do I see so many kverbs like things - and why are things like FMR=
 in
> this driver that can never be used?
>=20
> Jason

The idea was to introduce kernel support in future. I will remove it from t=
he code and upload the patch.
