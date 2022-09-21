Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C495E535E
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 20:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiIUSwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 14:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiIUSwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 14:52:33 -0400
X-Greylist: delayed 87891 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 21 Sep 2022 11:52:32 PDT
Received: from na01-obe.outbound.protection.outlook.com (unknown [52.101.56.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1EF9AF95;
        Wed, 21 Sep 2022 11:52:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bauoPKMx8gHOY9OKcZj09sniKgr612EMG4st4a8BKIuAjbn+r+vXiCiJG+W/aZNzAhYyEDLfRWsHdeIkxi+OwB6dBuCrATQUS/w44Zp4WEtxhavSj7qYmPjDOLvurVq8GDEsFgx+GVG9CSm9XJkViKcfsd829GQiUdHfrcBbHyntNt+EpA9uuXSnHubCEPv37l86NYIrjrfnWjBjWEKpdmoiovNhb7rb35SiXXDB5ZN2J81ksHawLjhHg2cf6TwQxJ0E9KjNLDj4SX08YPCl2as8xxt7cc/lQgXRGzN9pBH3+01Gcn9mssqe017m2dcnw/x6SG5eEJ5ciRHA0e8Oyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4eLQwSqywZDhDFjc9xJQTYOEw4VFk61v7no/rUuJA9s=;
 b=iZvN/4vln+V50QwjVbBx5C69q/puL1/ohkTvJJPgy3XRbdYNzHIcE+AwvyVLpcfE53Fvf/UuYqMn8gehGXFkx96YsUizXazfybbLpsuJsQtvy3RPl7J4b/mEWVndzQAsUJXDtj5GKq4qDpzzCOojzQJ/kNvwkSthSNzjYrGxt5blqae+PmuHb/OCdDVTUUZkQS0z+gZeaXleTkUnYn+rYb6ODkJ+wKAFS8jjMjnCsz/UII2L64h/87GpuFblC+qLjyj3PaA9u49tWSUDS3al8eiYvoX6xXARrE6vWVxFHU2pPk2+JLrFF/MMu2NCKwesFZZu4+aUCpHG1gslO9Klwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4eLQwSqywZDhDFjc9xJQTYOEw4VFk61v7no/rUuJA9s=;
 b=QIuonEH5K1hKdwTgkFYsS9Pb33J8LLxoLoUjEq+Y7xEz2QDeU9byMy7+cIsiGLVhqZ1Vf30lHeu66N8dBIImfFx0S3WuzgOymKzyuhXNFhApRN8s32xy4AMP2qKMrA+Ex+RV5ZxewHKJA+Wwr2d6z2rq+obE/TF3mqoWGoK3klY=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by PH0PR21MB1909.namprd21.prod.outlook.com (2603:10b6:510:1a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.7; Wed, 21 Sep
 2022 18:52:29 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::ce6d:5482:f64f:2ce6]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::ce6d:5482:f64f:2ce6%7]) with mapi id 15.20.5676.004; Wed, 21 Sep 2022
 18:52:29 +0000
From:   Long Li <longli@microsoft.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Dexuan Cui <decui@microsoft.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v5 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v5 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHYvNF9Ou2enAy4lUmWbFSQg4aWla3oumCAgAF16gCAACxV4A==
Date:   Wed, 21 Sep 2022 18:52:29 +0000
Message-ID: <PH7PR21MB32630127448E12FFCB37E781CE4F9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <1661906071-29508-13-git-send-email-longli@linuxonhyperv.com>
 <SA1PR21MB133500C46963854E242EC976BF4C9@SA1PR21MB1335.namprd21.prod.outlook.com>
 <Yys39Dfw42XjNA7e@ziepe.ca>
In-Reply-To: <Yys39Dfw42XjNA7e@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7ea760a3-60ce-4c1a-8947-42f310f5a53c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-21T18:51:16Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|PH0PR21MB1909:EE_
x-ms-office365-filtering-correlation-id: f7e25dd8-c75a-47e8-3a71-08da9c026f26
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2CXDRC6yjCyj08AhhciGrH1pARl3NBUxvE1U60uOyEfYf6+24RmW9DHGJo5aNY18vc58qkXfVwlTQwcXAn2WSqgHzkwiaJ8+tCt61WwNDkVHpnlSZQBnDDpdvITVPxqqwu+2EN2wCOVEC2LavLkGBudbJk8R9DsfZS3h3pj/YPRUOXVWaf7yBCjI1DZXdk/9dH4/gxdYaHXUF1hu71xxFPlGIRpU0Tyeqqkeva2GeXMJ03ZS+F/lxJX2QuLrTgDHUSZwT6hFMgOxwMEG0q37Au2j5/W7XyyVtCFY8bBd+tG/iRHGJtQ9y/e0JnUe9OYfljhINEOfT88QnPLXEle1fglWzVO2aJbitg2Nw+WO/f0Dib9vwRU7j0EPyEibRdcN92pA5M2Ix7OIL26hieutXjm/mX6hGl/8vEv0nA8L/jukgmWQR2O18s3HhUdkDHneVAhE4ZCrA5e2iv/kzuPUQLkrYrDegYTUXWFpOmIJTUA9N7n6Q6kxdiB4p6P3p+qx8uBc7E3xq3MIQhi9m8t1DVsh27VaxkdweSeej3jV8bG9iQEBzCTLF+w4fuLl97/6jfr99L2kv9+L3TfkYc43pp0Hy1EmlZLLYCqiVFvRQm/vZM3S5xzRnVeqka8XpMcme38NM3G/vZlNes5/bPL0S9SjnIxIwRRxRu/o+neU/MwKJa4zQg1BKzGt6XZbE8ZGuIN/ChUzVoUcLizU3SVl5/BagpT1JI1b1Nenok0ZxYjSNwwduhKEbWQ9p4P2ZPrZHE3/Ny/QNKjaeZD+qOqjX5Z7x2cJnOLsm8fYc2dqfE6JfgOqO4oslnsVaYq22dYn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(47530400004)(451199015)(33656002)(82960400001)(82950400001)(86362001)(122000001)(38100700002)(38070700005)(26005)(8990500004)(5660300002)(52536014)(2906002)(9686003)(186003)(71200400001)(7696005)(6506007)(41300700001)(76116006)(6636002)(316002)(64756008)(66946007)(66556008)(66476007)(66446008)(8676002)(4326008)(7416002)(4744005)(55016003)(8936002)(54906003)(478600001)(110136005)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8M5JfoL47fXWCtsCou6vvOaqPlrvhhT8M6BjP9ZacQv+9sKkdy6o2NYPsUvi?=
 =?us-ascii?Q?mNjrwEhADrMLW78ERqxCb0Pbep+InauuQEE7wJPNJezYvn1SsOJ7d0WsdMyY?=
 =?us-ascii?Q?VbEhKTNj/h4mR/+HM/yQ1JAq9Wm6VXY+P2WN5V+njXuS3P+y82ZQGJZF8G/X?=
 =?us-ascii?Q?ZkHlT2U5fdXaUHNtsnmx57rPADdJZQP762/6UG3GNV1ZzdvD8cjRPwM4OEp9?=
 =?us-ascii?Q?S2NoYsIhrzg/7kCg9fHuKxy61m3Haa9pUbheYYTcXxdmmcninRd+zyZvOahE?=
 =?us-ascii?Q?zcdaorEG6iyzMLJxgtMbgHNPEUHUsLksBmM7mBNlKj66p3BRzu/ezp+7pEp1?=
 =?us-ascii?Q?YK1lccPmZPsT/qUt+V8ifL8nyS7dnujANNFxOLVGKG7Gt3B0bg8ceRsy4IZ8?=
 =?us-ascii?Q?Cr/h4m/ed0PMggMfFaPrJ8ZWXYjQ2nmj0fRlXnEeoJog+P56t0LOONrpsb+D?=
 =?us-ascii?Q?15xF+SVJD3D04KWUUPVu+UvIRKr9DB+gcQgx1KE4eC5B5U5vB5Vzf75k4k+L?=
 =?us-ascii?Q?p8Ak799tWCV2BLwgoTB6KuQj9HVQ/6Ew9pjgDCwdpWMroYBjfM2v5C5rMstH?=
 =?us-ascii?Q?33GP1U6XEodK4YL0i4/p5Jx+4S12k18e20FkFo40BpFJBt0/kvpsC/z8H/bo?=
 =?us-ascii?Q?Imx73Njqf7TmoPeCmNlLrVSjTzI7F9pCcO0yTVly4dzLvGyHw/a14bdmtD6x?=
 =?us-ascii?Q?woxUUjcsIXvmqGEfWm/CJSqA3j+Vr5kIL/k/+XXQn0IGUQq/lxl3EPpW+kDR?=
 =?us-ascii?Q?kjkaFBMfVZuvnCCWc+0uNcnqNqFzgzoylXENQm3tL1e5VlY+s9KCNfji5oGv?=
 =?us-ascii?Q?1AgYzdBdGRJ8zJNmFkVA/r1/daJUEMNkN43tuqbparteDQUj/XKS3OWh6b3W?=
 =?us-ascii?Q?H8nT8pg1HaQvN59TF8zZrySN1HuiVd4EdnF5+Y2CQgqpFgzjlrCXpQb2VMzd?=
 =?us-ascii?Q?gplVPkz4uqE9GnYSyh3mn0Hx1zjDIPzq4NdL1sZ3GaepJY76z45vHNPXNsOq?=
 =?us-ascii?Q?NMGDQcvdDkG8p8D5wuqlQt81i2G2qDmrVGDmpuNITKGXMJz/Ktm6yJE9kl69?=
 =?us-ascii?Q?P80W9kdhJCPfnzLWqJse1yQwrwDNNgaShUVj8ufcTsHO2HznNFYnhjCY6Ezx?=
 =?us-ascii?Q?deS2QS2n9FpD68NsxZzrRZzjH8reVwdcdvVWKxh9LuWr9QCJCbAmyvL17KX5?=
 =?us-ascii?Q?ol3f0upgWU9NHHTXBBXXnDW13Nh1MDer5CRmc17YO0TAHiAQ7Spe2DLO8Z5s?=
 =?us-ascii?Q?D+ysAZpJHL4bsljPfbs/nepFDvXf+ZfvAkjGX5lQ8dVQYsoPHnoZCS0YS/zu?=
 =?us-ascii?Q?Oz3bur07kacA7ZCTlODdqnleidBLsByjmODWQOAOOOg8xr2Zh2HHNTZk5b9G?=
 =?us-ascii?Q?reti2nWJO4HOzAgnekBYraGRLh07B2pxA2oua+wN+pohvlSdE1sVjYg0b6lb?=
 =?us-ascii?Q?LpLlXj1skIJUQUPoAUpMm7Z/ui67ZK/IgwbWZVoGGd7QopNbu7GIwFFoAs5h?=
 =?us-ascii?Q?Zsaqrye5toG3/WGuFKcqZwTIsfjunHJO/ainkih2SU2FMsrcZrNXOoUNeKde?=
 =?us-ascii?Q?0AGRQTErFdXRHitK2p3ap4axtwiT17HK/YimGlzm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7e25dd8-c75a-47e8-3a71-08da9c026f26
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 18:52:29.4365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EiqR2ZuTCpoxFJg9GPMG0GVKagPQiRMdVIqw1qFHYls+C3rHDhThsjy/ZMsATTIcRHUOt+cYmCdYOGms7fjuDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1909
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [Patch v5 12/12] RDMA/mana_ib: Add a driver for Microsoft
> Azure Network Adapter
>=20
> On Tue, Sep 20, 2022 at 05:54:19PM +0000, Dexuan Cui wrote:
>=20
> > > +int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct
> > > ib_umem *umem,
> > > +				 mana_handle_t *gdma_region, u64 page_sz)
> {
> > > ...
> > > +
> > > +if (!err)
> > > +	return 0;
> >
> > Please add a Tab character to the above 2 lines.
>=20
> How are we still at the point where we have trivial style errors in this =
series at
> v6?? This is not OK, please handle reviews for this basic stuff internall=
y.
>=20
> Jason

I'm sorry for this style error. We'll review everything.

Long
