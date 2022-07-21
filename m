Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D63B57D312
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiGUSOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiGUSOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:14:01 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021020.outbound.protection.outlook.com [52.101.57.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330963FA11;
        Thu, 21 Jul 2022 11:14:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGOX8ND4xrjvYWwT/kGPYzOY0ICDggv22vR1jEACs/ar5D9PsfuV/zS2xK37XofrNj6o0Hmf/sN69AIIUGpy1znZZp9AbsKcWZ7alZhr1k8PC/9lcW8iShtEcwH/eJU340cPJhd5mrw9Gou+SHcaELHhXTyDQ4bZvMnBAoy/5w2kVcMHmF9lgGWqbmMy8MP24cCStKT6ZBbj4RMS4/FJHwedx/5ITMLsaBBuuFnPhXmyIb5FFb88Fu4/SS9uU86/cXURIZT580pQdM90qh7LLeJKW0IL99UHD/0CH87GmNqvzzMcL/DHOq+F5AS0vPEnOckGG4KBZEtwCbJ6PE4vdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q07JP+vTbR0XdWRAbJWnM1SxaYsGedctoZoSlYh/Z9A=;
 b=YrZUduYoENYIWwFR9v6dSNr7fKej+iBGo7XB1LCsM9Gm0/J0HdPlAo8HgH7wiFJzanhtvGBUBXq7/ovYzrYq8SrfIAsVMj/8QKbabAmOcb1C2QuXf5LCKQOYZfCy/odC7FJzluwQOcsynv1ifLmtNj2ognDsDsVyen4/8OHNdsqrdh4wXAfa9qEdjqM8k1JkjhMK3vxmzXSvRRvJ45+LWC9CYYfw6sHrjV0lLiNhm9tNVdCN8/cPq+raatDMGdgQMb1RsOIAlF0SiTsdUGRnrcruYUbWxWy6kghrn9giF5TfEgDByPt6Q8iaSY+jSiM5YQmM38x1H5kjioLBcjvKQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q07JP+vTbR0XdWRAbJWnM1SxaYsGedctoZoSlYh/Z9A=;
 b=JBRNlgqDMY0P6FPpup0vhciUg4GOab25aJOtHVxkazQiOYX6pzXbl6rOiHNvj/BsE+SvwpeC/XnzoNVa+SGauBR7m1eQo8nVjv11nM52077cx2IOR+CPv1LbFpkr4jtpvUTPeIC8yhxwq8S3QS6JmHaBLVoB8gpYK9qkhNVxOoI=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by SJ0PR21MB1886.namprd21.prod.outlook.com (2603:10b6:a03:299::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.1; Thu, 21 Jul
 2022 17:58:40 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::69ca:919f:a635:db5a]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::69ca:919f:a635:db5a%7]) with mapi id 15.20.5482.001; Thu, 21 Jul 2022
 17:58:39 +0000
From:   Long Li <longli@microsoft.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
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
Subject: RE: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Thread-Topic: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Thread-Index: AQHYgSXY1SrlgLfyyEyOddi806gORa14hJeAgAK137CADOflgIAABSdwgAD1agCAADIx8A==
Date:   Thu, 21 Jul 2022 17:58:39 +0000
Message-ID: <PH7PR21MB326339501D9CA5ABE69F8AE9CE919@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-4-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB13272044B91D6E37F7F5124FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
 <PH7PR21MB3263F08C111C5D06C99CC32ACE869@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220720234209.GP5049@ziepe.ca>
 <PH7PR21MB3263F5FD2FA4BA6669C21509CE919@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220721143858.GV5049@ziepe.ca>
In-Reply-To: <20220721143858.GV5049@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=82b5236a-8f31-4d11-aba5-8a9bcec6e327;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-21T17:38:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c09c4a28-da59-40b9-a54e-08da6b42a477
x-ms-traffictypediagnostic: SJ0PR21MB1886:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YjsulhvpMiOE/OV+tNHmv3odW8676wcbQW47ZWltVw3Nm+obKXUUv9Bt7u8IMY58GklrmEp+jDqdnwnJrkKZoTAngH+Ge0YdpMQBqKFWNHE0MbwihDVMrCKUXBJETeYBh338mzQrnu401tkZzcWT/hEgY3cwnaGLRsPCGe++DXXK+7pdXdYcK0Dq0sg+Gdh5uKu4DwphVfES9agjti5MvVJM2cx96gkB4poFIo9sSpDM4dG4W79w5pAcJCp0P8sOI/mQn8TBNCgnbdRi73VwzrCoO9ze+pskjODl7jm4GPvXbjF9wKLtbmDc6V9VneZk9Cz7kSBbNHR1oyvxrXjPHQgQVomvDrpTwZs+OdUo0+ghqStOLUOXH2zvissOCvxeH7I5qeG3TB3skcrfcCceh6MBe9SPIEe2jQ1guQnDszxlpbJ0qFNp+yYQTru21m+4JhNO79Jk9hrDtEmEMxNNdSye7Ese+Z+IzCclpYyrnHjbbS4c88Kr1ID7tDHGdt5dz378jeQpq7ymniF9lLxh8Ha9boXFSzKI/4QPFCrPO1yHsvENliQcccTs/4KO8pPyr2WJ50ZyCHenmMXtjWckCiS3D3D9pTX2iMVB+DwMCIQlmGJvDOAV8m/xRaEPbLllBDyxPs+Q3AU3ci8qSlAn/79iS3modRNgENQqIjbZ8VX8BZAhx/J6xdLHO1veKOsfadxmP99GeNt3+zTzVr8gTM/O3UuH8m4M8HRTqtskLHdsvr6OAvtOc/aHx/Hqo+6lGlx7GXYYkO7ve8jedmlmOJz5BKgSr9lx9sKtGYFyBaR8QOhFVqgwU2XetVUuwd5EcTnD06L8usQJ4SUKROwxi51NDYNN8+3CFDSm2zuFR3I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(451199009)(6506007)(26005)(9686003)(38100700002)(5660300002)(82950400001)(2906002)(316002)(7696005)(33656002)(8990500004)(7416002)(86362001)(186003)(71200400001)(66946007)(122000001)(66446008)(55016003)(10290500003)(478600001)(41300700001)(76116006)(4326008)(8676002)(82960400001)(38070700005)(8936002)(52536014)(64756008)(66556008)(54906003)(83380400001)(6916009)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EOQsmvEEUyhqkDoTABkt0zWVym6B+oZUhohQ+7SHPpMHaHnu+COhDluBF8QU?=
 =?us-ascii?Q?c0inrS+GTtOPQkDUCTWGAP193Mo+mi8KNa3P5YpXZsxgN++HsUZ2S50VVZPP?=
 =?us-ascii?Q?hJ7fU9TCl9dGFJN22V4jBNy5Fv+nmrx2o+5bvU/xADMhQzleqOcAT7ofieP9?=
 =?us-ascii?Q?GvTcpXs2ofp6XRdU7f5uoXhtl5WWE03UFNZDuAlnnHDUfQYXLb7ET49SLcZe?=
 =?us-ascii?Q?VgZPoI4qGJ0b96uKeEj2vYzIzlkfGbSyULOw0pSp570JZN9MRkiyDTQQs96r?=
 =?us-ascii?Q?RNhwG3Ou0RS3r+XKlxQHZWfVYUXYkqbE2ckzm6wzdF3jDlt6y4sO57PUj3h4?=
 =?us-ascii?Q?l1aCJzx+iz1ogqljoPPRZxgcoD3DQgIcBxHL6Vl9RFyOqAtoBy/gd8JvR0g+?=
 =?us-ascii?Q?mSTFXJYPoZh3XeKpfoYyEDYrHeLiuZQXbDNw9hO6JPweu9AVBj1zLgDv/rD8?=
 =?us-ascii?Q?0pnpHmgSV0OnXSC2M4S1ZEcb2lYDXN68s3AU6mZJcYCaMVuDgmgkKx6ES6yH?=
 =?us-ascii?Q?qSTTjtpVWlqHPExJrHyaSX48nMtP6IwN5E9WfEf9BAgCZc4KhRg19dZHZICv?=
 =?us-ascii?Q?PfYlLFnM31VcDXZp3jn7GhE1eswgRVbRH/UDXQ9pSfksYrilxijL2WTORL9/?=
 =?us-ascii?Q?IxrEypbH0peAUzHrsL4SIdeh2433X5wBjAwM1WJNOBI7o7Ox64EXbLj11mR7?=
 =?us-ascii?Q?pb69VBnqZ0QiGop+QxZ7UbQyGUJotPM19zzrGiqwSiagStkIaZonFqZCaHvT?=
 =?us-ascii?Q?gWxyxJeH2JlucfROQi8T5TKPYkFi0qgdlNSIwVw9RDf2N4dfMG+WPSIpSgwi?=
 =?us-ascii?Q?bngxwMV9PLGDaJGmuNuz4OqMrrbXjp+b/oIZlyImWm5EhhCwJQfF+5PVmBkk?=
 =?us-ascii?Q?ObpjvrW+CZVFCu1xY11aoxqUs8at38tSp1hk01jFkgFjklJvhuy6UJFmn/mU?=
 =?us-ascii?Q?gNJvi6sehmloTQQYWq+0NgXPBCeSkb7Gc2PDDcoutfLFNUT28va/5EA2t6vl?=
 =?us-ascii?Q?eEGK7qilxjnR8Ih5dRBI0f5Uu3XGzWJJGXA2hsdem4HNeosMJBttkI0uhWsg?=
 =?us-ascii?Q?0YZ1jQZReLSUJHNXc2KFk9jlPKrSzK2BLf7emQHlERsHFe/rNlLmamSQV6hd?=
 =?us-ascii?Q?8Gte8QTFnSc+IeoN7pzrd/d2zVxsgFjzeP76iFwPBXjkMdvX6gaWPwrpH0M2?=
 =?us-ascii?Q?E+g35seHZEfS2/PuN5epA5G4UBoa3sYFbv3q6LcaHA2ZvZmJn9QbO8BjvBiX?=
 =?us-ascii?Q?+jAN0X0vxpVCjl57ll7HTW08uEkFvr21sCZdYluHYBFGDBIcB4MR1w882x+F?=
 =?us-ascii?Q?iY8l7mYK19UoWaXuTnEnJBfbS54ukC+oqy5sZ5qjg2m8pm13SAKhiCM3MtJZ?=
 =?us-ascii?Q?GKYbmi3AnH/YcNEl+gDEsFJJIksCS4u9vHyNtH7BBk1sn93fUP9aQUMq+VY4?=
 =?us-ascii?Q?IQ6v8RZygYZpI7yLkTTS/RiPH/cC7T8ih8rGKjQsyrQYvQPEjpdEB9HXcZVu?=
 =?us-ascii?Q?xWxSELk5xBb6cVtDnCb9QDhKD58bPzlIcm8MtqtiAEAOPjH/pTwrL+I9GEdY?=
 =?us-ascii?Q?6H87SLG3wu016IIOogX9ol/8kEk1tVuUIvxbqmF5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c09c4a28-da59-40b9-a54e-08da6b42a477
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 17:58:39.7195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tKrzNcEoylm6JGZSASi1yBrnReuiU9p7Im3Umbm3b4ur09XTjx+Y7AGPQvznntaacZdmeawYrqiVn52TUSyxNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1886
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [Patch v4 03/12] net: mana: Handle vport sharing between
> devices
>=20
> On Thu, Jul 21, 2022 at 12:06:12AM +0000, Long Li wrote:
> > > Subject: Re: [Patch v4 03/12] net: mana: Handle vport sharing
> > > between devices
> > >
> > > On Tue, Jul 12, 2022 at 06:48:09PM +0000, Long Li wrote:
> > > > > > @@ -563,9 +581,19 @@ static int mana_cfg_vport(struct
> > > > > > mana_port_context *apc, u32 protection_dom_id,
> > > > > >
> > > > > >  	apc->tx_shortform_allowed =3D resp.short_form_allowed;
> > > > > >  	apc->tx_vp_offset =3D resp.tx_vport_offset;
> > > > > > +
> > > > > > +	netdev_info(apc->ndev, "Configured vPort %llu PD %u
> DB %u\n",
> > > > > > +		    apc->port_handle, protection_dom_id,
> doorbell_pg_id);
> > > > > Should this be netdev_dbg()?
> > > > > The log buffer can be flooded if there are many vPorts per VF
> > > > > PCI device and there are a lot of VFs.
> > > >
> > > > The reason netdev_info () is used is that this message is
> > > > important for troubleshooting initial setup issues with Ethernet
> > > > driver. We rely on user to get this configured right to share the
> > > > same hardware port between Ethernet and RDMA driver. As far as I
> > > > know, there is no easy way for a driver to "take over" an
> > > > exclusive hardware resource from another driver.
> > >
> > > This seems like a really strange statement.
> > >
> > > Exactly how does all of this work?
> > >
> > > Jason
> >
> > "vport" is a hardware resource that can either be used by an Ethernet
> > device, or an RDMA device. But it can't be used by both at the same
> > time. The "vport" is associated with a protection domain and doorbell,
> > it's programmed in the hardware. Outgoing traffic is enforced on this
> > vport based on how it is programmed.
>=20
> Sure, but how is the users problem to "get this configured right" and wha=
t
> exactly is the user supposed to do?
>=20
> I would expect the allocation of HW resources to be completely transparen=
t
> to the user. Why is it not?
>=20
> Jason

In the hardware, RDMA RAW_QP shares the same hardware resource (in this cas=
e, the vPort in hardware table) with the ethernet NIC. When an RDMA user cr=
eates a RAW_QP, we can't just shut down the ethernet. The user is required =
to make sure the ethernet is not in used when he creates this QP type.
