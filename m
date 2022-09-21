Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A001D5E5366
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 20:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiIUSxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 14:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIUSxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 14:53:47 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020023.outbound.protection.outlook.com [52.101.61.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF119F746;
        Wed, 21 Sep 2022 11:53:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKR2ygOWRawKBNVm03waFApy9YlognxPGAx4linvxUpl63WfLnxWPBzcGYVaHdkXhM1CTR19WUtjYPJGVKWWKYEFbKDL93QJbRguCjxhw7H32OjPtyZ6gSrhb2yaAhxoNZXpI5vtAHfsG1ZXy8+wGLGi+fdWyy8DbqM72IBdhvTxXNcNUw4fabk9k+k48mxDQ0VEfXaaLpAgVmwoIuXc8O9bYetwKfubBntAC+9BpzhedoEJmHcNi3ivd0Et0Nxl1E5joLmaVpM/vXGrYf10LN5z2QELC9XUMwrLE7lZ62CxnFDk6Y2liAIoaaJ5Ffwcwl67bJMFnVxxDLCOGJkh/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JC8UwJewfouJPTytlRkeWkFoPxPqy3zq7cd9CkTq3jU=;
 b=KC5geB2IGzOxYsiiGX6EAdpFAbcQXFoFYvWf+0xCmroCcMxryCLB+x0SRYpdzuWELRLxqEF3+we13DDG/UOi6Rjl8nE8gRp7DRQgW3jdfPdYdIx7nTKFG4MqHGQ9DAeIRR/E4pT+d42hEDtbsJpIm5ZR7DwzbwupfAYQ20ppxGILLKU4IcXnJSrEKPsr8xZaDlOouwGIdlgunr1lvZmCkt55P6CZrdoLenoUT8GKHsT5a4mrMx/ynDhHYZtcCYXM8DTAP5JPM0BIsNl1IP4M02d0NxQcYfGu89XiZKdX9GnxDioLxXe9Sb6p0AuyhM46drGoKbW1Zun7STKRRvicPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JC8UwJewfouJPTytlRkeWkFoPxPqy3zq7cd9CkTq3jU=;
 b=JczzR54q973T9Dv4ApR6Q+LHIywQ8umELEjVbO+RAioHPcpXLSwpdSI9zppaNEAt3e42qqwEUzMh+qOrQrMO1UbR2M3Pi8gb0SaWDrl8Iwazd2jwgBQn/SbDzStD/Wi4oyQ9pYQ12Hk+RyDGZKJXjZLS3cfwQ9sWXDY22YI6INU=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by PH0PR21MB1909.namprd21.prod.outlook.com (2603:10b6:510:1a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.7; Wed, 21 Sep
 2022 18:53:44 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::ce6d:5482:f64f:2ce6]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::ce6d:5482:f64f:2ce6%7]) with mapi id 15.20.5676.004; Wed, 21 Sep 2022
 18:53:44 +0000
From:   Long Li <longli@microsoft.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
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
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v6 00/12] Introduce Microsoft Azure Network Adapter (MANA)
 RDMA driver
Thread-Topic: [Patch v6 00/12] Introduce Microsoft Azure Network Adapter
 (MANA) RDMA driver
Thread-Index: AQHYzViuILRXmOZQOEOj85iwelga1K3qEtCAgAApQtA=
Date:   Wed, 21 Sep 2022 18:53:44 +0000
Message-ID: <PH7PR21MB3263E722C2D1F34766ED7705CE4F9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1663723352-598-1-git-send-email-longli@linuxonhyperv.com>
 <Yys69cXCOdYL0LTo@ziepe.ca>
In-Reply-To: <Yys69cXCOdYL0LTo@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=82e2bb8d-8846-4f43-9eb5-4ecafcce1909;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-21T18:53:05Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|PH0PR21MB1909:EE_
x-ms-office365-filtering-correlation-id: 548da136-f22e-4a40-e4b8-08da9c029bc4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DwAJxaSW7kF9JGb/JHdLj+rnvwxCX+CmyBbF3ODkv4v7VEUMdrW8Iw7VlMmM26La3Fl7sWwaLRfs+lyVE8eCcx3WOVv7VHtBsV2f2pqMi41rPDQN0tZQWVnm25jppqDRhZ1i4QG8QMjA2c50/lxZa42jJygC1u+/ibRJIYCXTyUOkrjmFvHJKtlmw0h8TTh5sjhbQhoT3gfPI2/iTZTNtrq7T/htT5JFFcMK6n6NG73ID/oggDh2P64foluq4sFZHQ5bgK1vTzJhZ4YnGCeaMcdE2J4R9zibawWeohe9kMSnkFSX0MbdFWfitd77VXdqfIo8ETUAKWywrSfqP6bx9aCtA0sTahfELL67TR/N/CZPkQ7O6mAfqGNuW+mx9ctBZURGIsqN9GuBKSeC/17OxNjL+ER81ij35FE6z23V3x6pn3feBucFXsaGRQ2MSiyf+NKJSbwlVXyF0EBMI1/znaNjQ9E5JiRmSBYYAYioePiAP/B2LFtUEcKHD7b/GtncQ6mujmehBJg1rGTtJzxBE46SqmIXxQQRgioaF4luxvTkoIbz665IqOolirEjKbU1pXkwwQ9ufNm5fNZySApD9rHY61XHiNpDk9zC0t6R8gEoUHisSfjZ+/LO9h+N1w3HRcDfUYp/TtgepQs6WyLB4hGWkm6etius/jmFmY7Brx4eVPLeQC3V7KazL8JHS9/HnCbdJyTiU79P5yHW4JygMP5YLnAfCObNvgbHAX8fkYHXhluHN88RXfuxkAST0rOHrbYZKGfryPs3M//qsUrlFL+Wz5x53rUv1HvWSu+7/+hrr1Kamf9TUHglKq1kLXENUIy7QYYI9HFYiF/1A7Mggw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(47530400004)(451199015)(33656002)(82960400001)(82950400001)(86362001)(122000001)(38100700002)(38070700005)(26005)(8990500004)(5660300002)(52536014)(2906002)(83380400001)(9686003)(186003)(71200400001)(7696005)(6506007)(41300700001)(76116006)(316002)(64756008)(6916009)(66946007)(66556008)(66476007)(66446008)(8676002)(4326008)(7416002)(966005)(55016003)(8936002)(54906003)(478600001)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?d31G2NWkM92hidYgaMla0mdB3uNo9HRZxeeXdW7NH1Gp5nBbXACqyFrMUzvF?=
 =?us-ascii?Q?r6oai1YQ/rWfJdXIa0/0HJI/nlaZfRQns9fTwZomE3V2mLz5eCXozE0IgwEE?=
 =?us-ascii?Q?Ma2k5vfLPh79gJyCgkq4SAzUkVg1CWyU25p6n3czn5foNRrhX3eqHSR/jDQe?=
 =?us-ascii?Q?zps6LWN0JNF5D/BYKPy9I5i2JlX9uT+rNyBx0a5x4spWTBup4P1ChUfQZ+4N?=
 =?us-ascii?Q?G/mMBeW4UTVWcx4P5FPufJ9mTxn2//kVKEoMHWI4r2kYk1xP1KhjRLsskN2N?=
 =?us-ascii?Q?xGLMzU67Krd/0YQ5fOJZonYkGeVMW4ltP9XpReNe11fDYGld3zONS70BWFdb?=
 =?us-ascii?Q?h3R3L6BrYQ6cOhDusgoPJpqmNYSwZ9/ddbdEjxQdCikZ0uG0LAuI1OLn8Fig?=
 =?us-ascii?Q?APmCsaM95jgz4JKW90tDOnSbwae/vybEnxvjJoZZ60mvfWvukNuHITrAeVBK?=
 =?us-ascii?Q?z96bVczdC/3NJvWZQlR/NKNK9gbwUSQPFCcLJdcnOdNTGoi//tNG6uTg0rLd?=
 =?us-ascii?Q?DPge4mLndAfV1t78Ay3V7xzGUsGs/gGxGd1kuiqfrIr4gc+6Pwkmtd6yaBhw?=
 =?us-ascii?Q?G+BeSv5gi0VDyr/APuYYWo8xlkzWStfFas/U1H2U6n0hlXtbAxQP9fFI1hcr?=
 =?us-ascii?Q?vLAPgkF7cbQFULcIZPyt8FV45Yfp03+A5HC3TadhhOwV6CXudKGHh7rAeT0J?=
 =?us-ascii?Q?60gf/k7/X/HDOBy89suMw8e0o+BJhp2kqh7typfSlqIPxhEdc8G4B0wCfnaK?=
 =?us-ascii?Q?z4fvR+e6DZgjDD+SCMjIvixwTGguVML0rf9zWBdnctOBmDWd7UWJmwBbPek6?=
 =?us-ascii?Q?vlMp6mDlRZDzCrweb+aagE5CCCCPM5H8yY2BftLkhpvycuClDVicKu5CEIYb?=
 =?us-ascii?Q?P5TeFv/gc67t3N17kTRoT0rCfq78TnSF5nKmKQOd6oeceoHmqfwsQlNvx6Kx?=
 =?us-ascii?Q?90cTgIZOqWQXktHiTM4WhQlv0q/5EKieXKBe0v7GiLdyEGo8wgnZ2VtYkcbK?=
 =?us-ascii?Q?HUrmWNt3qqthxl6aq35/iO7FQqLwvrABJHqEVi2DOkQiXCw0hATtO1sTnb5g?=
 =?us-ascii?Q?LADYIdzcbLWdkS/eE/1GQP1Au2gme0AsxtI8CnCLaOBEik2WmvrurX/ohslk?=
 =?us-ascii?Q?7SlbPw63IAqNZ+XvJTqXjNT92Cza5lYLgEgI8TbnHeJ7H2vu7X3FnYFmCh6W?=
 =?us-ascii?Q?EtMEvk7hO52Ij2NeF7qPCTyyHACOLVU2INQarJE1D9uAkke3ouQSEQ/Omq91?=
 =?us-ascii?Q?gkJQ9FiZzrM+N/8gZn5glcOjTPgUv+YXiUxUnfFyLcgIJdWSjjCy8RZzZdWv?=
 =?us-ascii?Q?hQHl97wdqVGieBi4xhbt6q2atWlzVHAfGTwd4zA8wUIXTMfFcxOYSH1TlwNM?=
 =?us-ascii?Q?QO0A2XuX22ugASQBwpRUvf9rWXond2yXVTX80oleXdtHhjGLOLO3CGha0eOz?=
 =?us-ascii?Q?7A8AsquARBIHs1/472zTo6QnHqlnPMq1UzUxU5z3K2C8DSMuzgGu5UDXUOtp?=
 =?us-ascii?Q?WoIxW8zJPKjV9QWxTrrg72XXaJr5hxxCBccHlGTYv/1/EDpY7QncE3N9C26n?=
 =?us-ascii?Q?CufjvP6xJJ6yJ3MepwC9+9Y5A16syFOYldPcEQgL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 548da136-f22e-4a40-e4b8-08da9c029bc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 18:53:44.2962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X7spcSJfGrbXvYz6q3VXFueaDdSz7btpc+EvlKoU7dGmPi0CVCv02yZg+PecrXXV3TN9uFovuPHUbJFgTD0v8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1909
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [Patch v6 00/12] Introduce Microsoft Azure Network Adapter
> (MANA) RDMA driver
>=20
> On Tue, Sep 20, 2022 at 06:22:20PM -0700, longli@linuxonhyperv.com wrote:
> > From: Long Li <longli@microsoft.com>
> >
> > This patchset implements a RDMA driver for Microsoft Azure Network
> > Adapter (MANA). In MANA, the RDMA device is modeled as an auxiliary
> > device to the Ethernet device.
> >
> > The first 11 patches modify the MANA Ethernet driver to support RDMA
> driver.
> > The last patch implementes the RDMA driver.
> >
> > The user-mode of the driver is being reviewed at:
> >
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgith
> > ub.com%2Flinux-rdma%2Frdma-
> core%2Fpull%2F1177&amp;data=3D05%7C01%7Clongl
> >
> i%40microsoft.com%7C1d30ce9d49bc411b0fb808da9bede4bd%7C72f988bf86
> f141a
> >
> f91ab2d7cd011db47%7C1%7C0%7C637993743320198387%7CUnknown%7CT
> WFpbGZsb3d
> >
> 8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%
> 3D%7C
> >
> 3000%7C%7C%7C&amp;sdata=3D4cT9PFnKqb2yHRLkKNrbVVMAGwO6Ig91eoQ
> zomlm6lY%3D
> > &amp;reserved=3D0
> >
> >
> > Ajay Sharma (3):
> >   net: mana: Set the DMA device max segment size
> >   net: mana: Define and process GDMA response code
> >     GDMA_STATUS_MORE_ENTRIES
> >   net: mana: Define data structures for protection domain and memory
> >     registration
> >
> > Long Li (9):
> >   net: mana: Add support for auxiliary device
> >   net: mana: Record the physical address for doorbell page region
> >   net: mana: Handle vport sharing between devices
> >   net: mana: Add functions for allocating doorbell page from GDMA
> >   net: mana: Export Work Queue functions for use by RDMA driver
> >   net: mana: Record port number in netdev
> >   net: mana: Move header files to a common location
> >   net: mana: Define max values for SGL entries
> >   RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter
>=20
> Still some basic checkpatchy stuff:
>=20
> /tmp/tmpm2fsg47h/0012-RDMA-mana_ib-Add-a-driver-for-Microsoft-
> Azure-Network-Adapter.patch:412: WARNING: quoted string split across
> lines
> #412: FILE: drivers/infiniband/hw/mana/main.c:70:
> +		  "vport handle %llx pdid %x doorbell_id %x "
> +		  "tx_shortform_allowed %d tx_vp_offset %u\n",
>=20
> /tmp/tmpm2fsg47h/0012-RDMA-mana_ib-Add-a-driver-for-Microsoft-
> Azure-Network-Adapter.patch:540: WARNING: quoted string split across
> lines
> #540: FILE: drivers/infiniband/hw/mana/main.c:198:
> +		  "size_dma_region %lu num_pages_total %lu, "
> +		  "page_sz 0x%llx offset_in_page %u\n",
>=20
> And it thinks you should write more for the kconfig symbol, eg why would
> someone want to turn it on (hint, to use dpkd on some Azure
> instances)

Will fix those.

>=20
> /tmp/tmpm2fsg47h/0012-RDMA-mana_ib-Add-a-driver-for-Microsoft-
> Azure-Network-Adapter.patch:100: WARNING: please write a help
> paragraph that fully describes the config symbol
> #100: FILE: drivers/infiniband/hw/mana/Kconfig:2:
> +config MANA_INFINIBAND
> +	tristate "Microsoft Azure Network Adapter support"
> +	depends on NETDEVICES && ETHERNET && PCI &&
> MICROSOFT_MANA
> +	help
> +	  This driver provides low-level RDMA support for
> +	  Microsoft Azure Network Adapter (MANA).
>=20

