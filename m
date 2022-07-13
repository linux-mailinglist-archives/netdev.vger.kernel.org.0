Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C809572F53
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbiGMHhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234646AbiGMHg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:36:57 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2094.outbound.protection.outlook.com [40.107.237.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2532BE4F3A;
        Wed, 13 Jul 2022 00:36:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CuyedYIcgbIIMGGOZTvdY3PTHC/NCkljlpg9XiqtUp2gCvJF3myxg4eDMuhUXqnD26iA8zyoF6Q4MrcHj66oxIXI2k4LGa6XqmUxOOhTblKLzBBTGUUVSEzI8Z+5zArc7NREtRkRpNv+5LNDn62270EMVDTavVudEPqrczDzn0nVrh3CEXVFZSpllS5Z4sChnhXTFTABx+H4oCguK8onCAL35LZdrmvNlk/j52hQ5J8sHvQAgeM0wk8C5ZNV4lEGp60qPBESFY9SuYMsj1Dl6w2oinK2bhA3do/GFjrRB9jPU9p7ALNi9G7pjNuxqVo6PRHPz/dRiU3L4Xe3RQUX9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=974UDoe/38JS6oFCdZKGhtXdB43MQFueCOLcGRrJMBQ=;
 b=R7eLMd8eervxCcgPsc48jSW03dfx2BkBNsxcc0R2fztHA7CN7mHLmlQs+TqLIyEfAe2Ie0DsyO89C9LxJdycHHf/XlAgAH7t2T+i6IJ9V8HxjGnHDCmenNg/faVhvOp39fBjjNrE5tdxonPhiLFB0t37K7OXiWVZ5xxoZXeh7xnzJ8sPpPhWUDg0D4t/xxlkFR71g+UMoRdCPYHFjlcyUM++8yIWNCkPSDgp/eC/zQMINERJXgumpdUd/2TAMu8SZ457vWMIS1QfibQNZNhb57GSmRMYdXRj5YUeDFHmu9yp+G68BoEW6ZhimbrS3IJa4gLOoRUsEzB11isXquHe2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=974UDoe/38JS6oFCdZKGhtXdB43MQFueCOLcGRrJMBQ=;
 b=V0rkygYeYWV3+rq0Fnf+DboECTrHXFrJZdH243LVhv06yCIxhmXdPJ/d1OBrIMAJ+N0aezqofXLTmdHThZDYcFFQ3oS1XvX/CBDIJ597aTB5Jx6nLFZpZ0ViApFLn6kcGhmmy71ztuqt0KEfIeFZ4O+zCxJ/2nPgj/q+Uxttp8E=
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 (2603:10b6:805:107::9) by MN0PR21MB3535.namprd21.prod.outlook.com
 (2603:10b6:208:3d0::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.5; Wed, 13 Jul
 2022 07:36:53 +0000
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0]) by SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0%7]) with mapi id 15.20.5458.005; Wed, 13 Jul 2022
 07:36:53 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Ajay Sharma <sharmaajay@microsoft.com>,
        Long Li <longli@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHYgSXbp+YB12TPHUGa3Bv46Ly1sK14ihhQgANWzwCAADHU8A==
Date:   Wed, 13 Jul 2022 07:36:53 +0000
Message-ID: <SN6PR2101MB13271E9D5865923393D67649BF899@SN6PR2101MB1327.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB1327827B0EA68876717F0699BF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
 <BL1PR21MB328334421DE2FB3B33176646D6899@BL1PR21MB3283.namprd21.prod.outlook.com>
In-Reply-To: <BL1PR21MB328334421DE2FB3B33176646D6899@BL1PR21MB3283.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=37fbf502-6d30-442e-a817-37730b6e8ac6;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-11T01:33:17Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f9b41be-11b9-401a-d45e-08da64a27511
x-ms-traffictypediagnostic: MN0PR21MB3535:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r4G+9CtHP5Ff4HruDqi0hURt6ZDIa6cgMYtfFT0+6FJp4a6NSEdO9KI4AsWYj+WvpB+qpfbtDL2vUeV0wqxbnpmCT6pN8SRgNtHVNu6TOJ24hnsxoeP/Zgg6NI8tcfZ0aC9JM/v3RCPASDSNHE22iExJZG6N0fQ5oXrW7RtGBo0iLgRq7/nw6PVelSH/MYaAuzbSkGU2cpK1J0kZLK0CDD/oz12vaGOmS9JMOvAu77uPy3Zu4qmnBX/jahsn3t7K4QxmvD4rd3sS/crxpPdUqsV9YsQTY7rWt+pS7yHVMZwU6pzdnkMczTDaHUOK+cXh/dX0NjoMvhVHnJ9IikYvi2rbGLP9sOrDBxb+g0A/xJM2dSe7PP032ZiNrQRN05FGD9lINZwsBiXxpB1yOP7ZTh1zHATtT3ZniPUpcbPtJ4MFQv4Np+J/wSV+1LHTVW4VYedHO3p0P8W4zaaJGnvTXb8jlERJuFXxTxVRPwNSBuEVtDTW2FM7Qf6P6dO5+w0ny2vigVllnsSQcYLPEzF35N1l6PiIJWUtrXSA723VxsnjsSkZiK67sPnk7GPNeQGjYvVhP0xygkD4sbEpdtWI/H0CBQEWYwdeDeP1yMV40C3eUAgxQkF8OAzz7ZRqDjnHD5D/gz5j0oYvU2qd/XDlM6PPFiz6rYGGQ2OciGCBxp9zlEync3sdDaOEppQXKb66zHJ7lpg8yuVwz8LtYk+EX1QK9JUOd8pzpMFS3l8qyD6PYfgf7xo5Qs1piv1yQqY3MHKPhGn24pUEEsTsF239O4p2DM4agVKz4/igx5/Hbu1jw7y8b3Ec4RjEtJx9+KEoDcOC6tzblw0ZRCpOkbutje8GIVPaHefqxNOia4dP5L/W+k7KPi1hwR/hquueJbEE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1327.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(47530400004)(451199009)(7696005)(6506007)(478600001)(26005)(71200400001)(41300700001)(83380400001)(9686003)(10290500003)(186003)(2906002)(8990500004)(7416002)(5660300002)(55016003)(76116006)(54906003)(316002)(66946007)(66556008)(110136005)(8936002)(52536014)(8676002)(64756008)(66446008)(66476007)(4326008)(122000001)(38100700002)(33656002)(38070700005)(86362001)(82960400001)(82950400001)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VxdOYkISOiTPtujJ1a91yeoPBIVIbI1MYHcT1S9/lR6CZm5RCa1akq4klaRm?=
 =?us-ascii?Q?uSc0p79FXytK4fzFslI8VNId5LtyQvEHfP3ymskRdagwoFhJACLMv+vzUJcm?=
 =?us-ascii?Q?wGBuq+RzjFww8EFPXbZd9xqXB8S9aSPWZZNKOZMDo+50KEx0XFcUeN+aJrIc?=
 =?us-ascii?Q?8BF988MNRUainiy/Gki2YdhI22wSD6Gb8KjipgHzGKZ496NOhGdAnvt5j8FW?=
 =?us-ascii?Q?ba33ipO+yb1B3W9LiOsKFalYpeSpar5w6bf2NMpl0Uvrx1moj5kt/Edf2Hyl?=
 =?us-ascii?Q?mIk/pe5+SdZUsrxHZvusskXCC1XtNr3TGQKqBohs9P/9jlzcxXjMG+zaAbdQ?=
 =?us-ascii?Q?Udy2uOZZrEKiOFows2AmIllNADHPgoZ529vn529fY0zA/B0DhO6MB8geSb3/?=
 =?us-ascii?Q?FRkOB6HIeCC7ZWZpobXOND7giFy8bGA12l3EMCmXlOlKhdQBcr28+qIIkc5V?=
 =?us-ascii?Q?GRcTlEbPxVhv48HNHTDBGuhLNTxwB/QUHgKrTIdObWG7n7jRCvJ761P0Hy0k?=
 =?us-ascii?Q?9KKhlhZY6m05AY8sDKFspEGHk3owqhyPyFi5CHvivSRqXeq3GR15blniudcZ?=
 =?us-ascii?Q?1CjuPV85bSM08PgOUPkc7fOF7incD/Pf6Ccr8V0oRNXVVuDNsFlN7qULn44P?=
 =?us-ascii?Q?ko6wJTcoZr0seNxsQN7sxB3zOiV7jRuz2pYLer/GUEntbMrBDFd/iUl+jHF8?=
 =?us-ascii?Q?Gm/cS4tIb1jndJZ99hT8iahXuQL2ec56F5VmzaQjbI4QBnRs4TLFH1MwJlWU?=
 =?us-ascii?Q?zOjwU6KdPgGzAnffEd9qWWP3Jvrtnqwxz5oMGdf3WQsM+geSHTbeh8D6VHbo?=
 =?us-ascii?Q?8qtRyD+GD788r28eze+GnCQKoRnSp+kpOtqg+qXYHCj+eZD+cggblBVo/TEn?=
 =?us-ascii?Q?/x44EGmuve+VI9/DVjNiviFDvtSCpD+shCA8cCqNxF4QSb9Km/A+nqAAnlAj?=
 =?us-ascii?Q?0EtgvdMTJMU2VyqsRygeTJlp0yWmwAY17ka1ZCoi4d6G1r4mZv5AeVGrr7mQ?=
 =?us-ascii?Q?iKj+2Y2y6XCqpG21Y3Wdr6I7U+xmvOk2T3SyN8smsPYwb53mwInOZEa6SrDk?=
 =?us-ascii?Q?f6xhNAHq+zHg5y2Qjhrt5iiK47G3nyCojoDHX97gsZ9px91gKKgcGD4WmcSy?=
 =?us-ascii?Q?UO8hX0NyPvkA+8CWWVvIUVTs5mDu3nc+W8Pbq0PE/cXtAvCn5371kiAJ2WxE?=
 =?us-ascii?Q?yB/x3xntn8CIT2IQvl6EvCmAVsYcru+521RIpT+lU2vOhUujqgAAoFdiYiY3?=
 =?us-ascii?Q?rbUx8hgJVVRCvwMh9fq+PCyAeQwcJoBYoi3YQOn0dY+rUlSL7SZjmu0I7TYA?=
 =?us-ascii?Q?zjjHWxrL1mh8WankWw7izv1Uh2sCylbC+qjiUUkJtX+9tM7vyp4cAI96d7Ny?=
 =?us-ascii?Q?3bP2UfEv6EIPMCsGljua5JbnsPkoLYSJEK9w/WUEM2wzgb7w9QUyuebCljFH?=
 =?us-ascii?Q?2c1oxxmCvPBKqfAoF9zlHyPtXOm035WiPabLbKjPwhDDEL+WQGy/NOVyvB1F?=
 =?us-ascii?Q?mBMukdi24TKZBLWP1ZgtFcHV+hH8aUxs2Kz4B+bFh2w09apco9qXRJBQ4xrP?=
 =?us-ascii?Q?0fn8tOb6uNjEsqq8Wb/UHF4BtPfimAnn2AR0CxiL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1327.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f9b41be-11b9-401a-d45e-08da64a27511
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2022 07:36:53.7304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nWvnOjHhfKEyWq+yi1hyNZF/3XTrxtgcyRvUSsPDt3JYAL0cMHNZ0Kpe/hXR2Xfx4mEg/agFBwVuMITBHNqVww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3535
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Ajay Sharma <sharmaajay@microsoft.com>
> Sent: Tuesday, July 12, 2022 9:33 PM
> >  ...
> > +	switch (mr_params->mr_type) {
> > +	case GDMA_MR_TYPE_GVA:
> > +		req.mr_type =3D GDMA_MR_TYPE_GVA;
> > +		req.gva.dma_region_handle =3D mr_params->gva.dma_region_handle;
> > +		req.gva.virtual_address =3D mr_params->gva.virtual_address;
> > +		req.gva.access_flags =3D mr_params->gva.access_flags;
> > +		break;
> > +
> > +	case GDMA_MR_TYPE_GPA:
> > +		req.mr_type =3D GDMA_MR_TYPE_GPA;
> > +		req.gpa.access_flags =3D mr_params->gpa.access_flags;
> > +		break;
> > +
> > +	case GDMA_MR_TYPE_FMR:
> > +		req.mr_type =3D GDMA_MR_TYPE_FMR;
> > +		req.fmr.page_size =3D mr_params->fmr.page_size;
> > +		req.fmr.reserved_pte_count =3D mr_params->fmr.reserved_pte_count;
> > +		break;
> > +
> > +	default:
> > +		ibdev_dbg(&dev->ib_dev,
> > +			  "invalid param (GDMA_MR_TYPE) passed, type %d\n",
> > +			  req.mr_type);
>=20
> Here req.mr_type is always 0.
> We should remove the 3 above lines of "req.mr_type =3D ...", and add a li=
ne
> "req.mr_type =3D mr_params->mr_type;" before the "switch" line..
>=20
> No, That's incorrect. The mr_type is being explicitly set here to control=
 what
> regions get exposed to the user and kernel. GPA and FMR are never exposed=
 to
> user. So we cannot assign req.mr_type =3D mr_params->mr_type.

I'm not following you. I meant the below change, which should have no
functional change, right? In the "default:" branch , we just "goto error;",=
 so
there is no functional change either.

--- drivers/infiniband/hw/mana/main.c.orig
+++ drivers/infiniband/hw/mana/main.c
@@ -394,21 +394,19 @@
                             sizeof(resp));
        req.pd_handle =3D mr_params->pd_handle;

+       req.mr_type =3D mr_params->mr_type;
        switch (mr_params->mr_type) {
        case GDMA_MR_TYPE_GVA:
-               req.mr_type =3D GDMA_MR_TYPE_GVA;
                req.gva.dma_region_handle =3D mr_params->gva.dma_region_han=
dle;
                req.gva.virtual_address =3D mr_params->gva.virtual_address;
                req.gva.access_flags =3D mr_params->gva.access_flags;
                break;

        case GDMA_MR_TYPE_GPA:
-               req.mr_type =3D GDMA_MR_TYPE_GPA;
                req.gpa.access_flags =3D mr_params->gpa.access_flags;
                break;

        case GDMA_MR_TYPE_FMR:
-               req.mr_type =3D GDMA_MR_TYPE_FMR;
                req.fmr.page_size =3D mr_params->fmr.page_size;
                req.fmr.reserved_pte_count =3D mr_params->fmr.reserved_pte_=
count;
                break;
