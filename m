Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7CD57C180
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 02:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiGUAPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 20:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiGUAPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 20:15:06 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021026.outbound.protection.outlook.com [52.101.57.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869BC1F8;
        Wed, 20 Jul 2022 17:15:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOldlqkJr3cknuFyuI/sLabEVbryoOylwf+dA9Di94GdWWv/DX3e5SwdWQskiz9RcOQ9T4qzN3/nxah8ADboNnYh9X/wTcWQc5WoqXQJJvDn9r9wyucwV9j9zIBcstgeARZz/vn67A+X7QPHWZV+5d0KDuiEXDHxbVZnh3fAmZh2AV8Y4OZs2ElQprGJrTizMGrnx/yxGlYIG6QlVpkKT1pxdx57+jEHx4ZQMRKfDzubCoGCnb258jeMSkthNOUjDGAV7EpSLWpgbQC1feS6SxWdNOR35QbTX0po1EjR2zhuXpyA9cp+l29Z679lDRZF5H0cZxx50v4kNYfHAMBuHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8HSSWmkLZpwPlAP7IqbuM2a7Ok/uUYjFUCLwbe27C5c=;
 b=n5AHRRbiz0HBlDxiPhyVxftGsjrEd6dy8ZQHhVf2McJNRSvWWDDcvwSrP6x+rIZu6+i6xHvGBx2Y4v9GVidEs+xmtj57dDZwY/mt75C0e+q8wDpx+ot+pg2CbS8ABEBz6RCva9a33PZphPfJfIFAAnKx7FG3H4kbRTMz9DZyZJnCtmDDGRqPKpiYNEwjhPIlZcEzhY6Ifm0L+aDrkKhKl7tHXXPvXY7gkht4WYjCC/m5riwDr2LUp86sDzfN2xec7KTFXrzIJ4ZcJQvo7mVDO2UAber8SjI/oturfiSG4AuR+VRMMAoZHBetiRpdtGidXm3eZfLa9OZ5asD46Z8YYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HSSWmkLZpwPlAP7IqbuM2a7Ok/uUYjFUCLwbe27C5c=;
 b=iac3Sv8CsJ63XV773TfBvuuLGHhOc1C8P2wvo8ZrNnR88NSqmVUPDRvjuMzKQt7ShK8iDVh4HJ0L5k2eKBR7BoC3XvImbwX3lUldAmRBnH10e/uOh1EIlXBHQlBjCKUBAeGVFDc2qZs5a/oXKvyv12b7fLMpifmGS2rwJ8S9VjE=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by MN0PR21MB3580.namprd21.prod.outlook.com (2603:10b6:208:3d3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.4; Thu, 21 Jul
 2022 00:15:02 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::69ca:919f:a635:db5a]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::69ca:919f:a635:db5a%7]) with mapi id 15.20.5482.001; Thu, 21 Jul 2022
 00:15:02 +0000
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
Subject: RE: [Patch v4 06/12] net: mana: Define data structures for protection
 domain and memory registration
Thread-Topic: [Patch v4 06/12] net: mana: Define data structures for
 protection domain and memory registration
Thread-Index: AQHYgSXZ4igJqU39v027Ac2C5KX/MK14iO8AgA+Z1ACAAAZm0A==
Date:   Thu, 21 Jul 2022 00:15:02 +0000
Message-ID: <PH7PR21MB3263DE7395EEF72796323D0BCE919@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-7-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB13276E8879F455D06318118EBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
 <20220720234336.GR5049@ziepe.ca>
In-Reply-To: <20220720234336.GR5049@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=82c29ab0-52e5-4657-acc2-fadb8db6b951;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-21T00:06:30Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51a14604-265e-4bcc-9cb3-08da6aae0e7b
x-ms-traffictypediagnostic: MN0PR21MB3580:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p9RBDaVYC8UyiPDcNWKjnLR35WDirvtLHiEf0GzXNzUEhSReW1D2dQW4bY9d2kP48yNPu564hWHL4vFMA+xJAAWQg2t/5dV9dWcl1XAJjlcG3rYnmfl+TIIGRXOd4kaYfE7jqNC+SAS/ldYFROnfxry7+bDiP4yiBE2nfSNGpNJj3rHUVUJtNj0a3RgQgUnLbn38qja3YdIx90Tx+mjlaUle2uUw4o3gKJwKQpA2fBL99MlLD3wG/HKd0pKfL19ivYrKNGizfREUqqQS3+zi9f6RrpEeRLZAXanhlUdvksZ42aT1Bu+h2DVZxBxvI9gwD1dl0sS+QmYdxdwgGai6Hwc6D5uJFpdKPSnbkPG85QsqLLc8Pd0fp7YuqOUEyZaWJKHQsRRWlU4BS00oEyxCvglR0pz3tMEw516HiolxOQlH5j+0kbc1ZnrDpBgx3HZoEmWgNJ4wyWbhBnfpQwN0HZ3kj8XnkyncKHQPyhICxHuwwBIHdB9Fqwcqp5Nm2VvuirrIi5/sZ25uDspyaHNiLiE/vbc4qY8JR7Pm5G+fgwQry9yf9MJVOTsySfWrIqljI53BudVeZvcuGFECyqcqMw86B6xNzXufLpFzHlGppOxJ/KMkOR4GNL6+9mOEB9+7Htp3hp8MBRitAiwsUoZwWU7e9OhUb9SrxPgvpIZdzrIobImJWC4TvMYI2mMw5H3X/XkQjlcBKbF0AVNJSIaOXF/FAI9yrATh94K8TiVJ9TPuc/8Sd+rZ9pfXVx+Pco0eRuJ7mBWq67D3qiC0O6i4h89YTmTQ7mqqRczjZOwx+lDkeGFGngEUAZJP6xeDHVdSaLzKSD3QBs6Xkknpi+IpgP4+MY+VjP0K8bl6P4ZRmIo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(451199009)(66446008)(6636002)(83380400001)(66556008)(4326008)(10290500003)(86362001)(38070700005)(186003)(26005)(8676002)(54906003)(66946007)(71200400001)(76116006)(7416002)(64756008)(55016003)(6506007)(110136005)(66476007)(7696005)(8990500004)(122000001)(38100700002)(82960400001)(5660300002)(478600001)(52536014)(9686003)(2906002)(8936002)(41300700001)(82950400001)(33656002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BmPfKJGf/mmHOGA78I5+gWueP8HvjHuHsgu0TqxEgFgmOnydH2kKO0QPvdBs?=
 =?us-ascii?Q?FkvzcwLx2I2bB0wnLSGoq1KaZ1tC+cGvhi1eQvyzWTpw5iIbYl31cjm4mzne?=
 =?us-ascii?Q?JAWWiHNJebFkGAq1OJMkmAi8MQLzbZL7q1VH1e8dtl9BfQRos8gPq8n/EGNu?=
 =?us-ascii?Q?wheMEr+X3uWu+3X79cq1cBVZnvhkoQqLJpJfALZs48G9ycBDm9AM8mDDwi85?=
 =?us-ascii?Q?shTs4UCsfLOjaw8lr3/JrRTexoRKk88uHXPlTZgwyJvP3G9P2rYWkJN+M6fT?=
 =?us-ascii?Q?49SHwjD/hH4jnaLtTWLlCC9HPflXLpKLeqFQKGcN75vsng/GPUGFJG6E/8La?=
 =?us-ascii?Q?GIpi10pfJ9MZvTso/7E/8/WhCu/KjvBTgdxZMam5ABUQmVFYEB/9ghjyOjgG?=
 =?us-ascii?Q?QgtVJNhwN6QoTyH83RVccg0O30WunWtUQXv0XugVLSrtCK+aucp4oJnKHYqN?=
 =?us-ascii?Q?VDSpAdjZRilOJ4UvFO4FuEfaZbUlEBcMne7vMSy3Pq3tDQu8OLjjPkre5pFq?=
 =?us-ascii?Q?S3C5N0ognRXKBRfVGtzjgosMsLTrfeTTo8h94UENU/T0QV2cjdK/cmgIO2w/?=
 =?us-ascii?Q?8j9sRXUy0zN14D2x1jkIjzbaek964U25WYTDVIp+d1cyykWK+VNMDYGaAw5y?=
 =?us-ascii?Q?oOBFYZJ/btq8ehGnrgFG5LsneDWaaSIYm3XjgAhmHgs/bIs49xeVMXOLtLzK?=
 =?us-ascii?Q?xlRh/Q13RMaFOFGYubIGxn4Ni2G2xpbBqHu/pP/M0cSBQ8TlGDz/hmRSuYNB?=
 =?us-ascii?Q?0uTiB0lxmXG17XBfYjlQwbRmCrNxZ6hOa7aeb0PotOLmmMHe0I74r3d2uU1Q?=
 =?us-ascii?Q?m5Rq7PIGGD5qN6raXzZnTwNxEU5H71rFXuc+/4i7zcPaqdrUIO61OF536zbM?=
 =?us-ascii?Q?VXMU7sOjv6Eej1HT4iOK/0YstQMxKUtnd7DPReeC4URuVLd+yO101hUIChXZ?=
 =?us-ascii?Q?ombiZRgDH/izK40jUAA44Szlc+01kja9saQPMFOylQHq4T0ljFQiTDV0GNC1?=
 =?us-ascii?Q?9LmbAWpTGt/SPas6XRcsj4Gv5+NLQeCJTaFVr7qInCD+QhMILLoOQFq8QLf5?=
 =?us-ascii?Q?Ef1xHj5KScRX0ETOn40y7dPtn13RCE7RczKgRjN5U/qWZADUtSHmiPATk1qg?=
 =?us-ascii?Q?v/YuPaYS6RGO8W5ghgrEHqgKXJ56HpOLDy/MwZxb4l6g5Bu0PuwcG8tsXvoj?=
 =?us-ascii?Q?RM1Ywy3I55sqfk1EHU1RPIXLz82PoJNrtOPaDlmcPJNKFraiphI5CMzGvEle?=
 =?us-ascii?Q?Pd9rVubaEImc0PBaMsSIg/6Uhr1m6yBRReYmJ1KcZ38NDqV4HYmT3IUiVYG2?=
 =?us-ascii?Q?xyDBLYye6CmMbB4jQqcTBwubunBZTUsRbnos2t08CmvJp698hVXe3a1wkd9T?=
 =?us-ascii?Q?6xvMn4IeBkEleWyHAkcpz8UxBKtDaYT01uf8MMrBa4Ln+8XNL/Nyp86KJnJp?=
 =?us-ascii?Q?dcymxTwD69XrVs9EuwqMfdh4VBCizfTf9OTTAQSB4+y2F4GdH1tuHq3PkuK6?=
 =?us-ascii?Q?qQl/2ZxifF7FIb/Q1DCfJAyTRmfFEaLFrljaE1XR9gpzTU2kiadK+iEmnOs3?=
 =?us-ascii?Q?ymMjZ0WBSb13pGYR6NxZ9sCFpQPotdUNoNPu/nKp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51a14604-265e-4bcc-9cb3-08da6aae0e7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 00:15:02.5869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QZo0NMIJvSnlHwoskEur3K8bcm7OB8/sDNSyCxRJDempxtqqY+OtcuUmH34RNmS7dx0AlwxOpnfh8IPgCoqdzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3580
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [Patch v4 06/12] net: mana: Define data structures for prote=
ction
> domain and memory registration
>=20
> On Mon, Jul 11, 2022 at 01:29:08AM +0000, Dexuan Cui wrote:
> > > From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> > > Sent: Wednesday, June 15, 2022 7:07 PM
> > >
> > > The MANA hardware support protection domain and memory
> registration
> > > for
> > s/support/supports
> >
> > > diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h
> > > b/drivers/net/ethernet/microsoft/mana/gdma.h
> > > index f945755760dc..b1bec8ab5695 100644
> > > --- a/drivers/net/ethernet/microsoft/mana/gdma.h
> > > +++ b/drivers/net/ethernet/microsoft/mana/gdma.h
> > > @@ -27,6 +27,10 @@ enum gdma_request_type {
> > >  	GDMA_CREATE_DMA_REGION		=3D 25,
> > >  	GDMA_DMA_REGION_ADD_PAGES	=3D 26,
> > >  	GDMA_DESTROY_DMA_REGION		=3D 27,
> > > +	GDMA_CREATE_PD			=3D 29,
> > > +	GDMA_DESTROY_PD			=3D 30,
> > > +	GDMA_CREATE_MR			=3D 31,
> > > +	GDMA_DESTROY_MR			=3D 32,
> > These are not used in this patch. They're used in the 12th patch for
> > the first time. Can we move these to that patch?
>=20
> This looks like RDMA code anyhow, why is it under net/ethernet?
>=20
> Jason

This header file belongs to the GDMA layer (as its filename implies) . It's=
 a hardware communication layer used by both ethernet and RDMA for communic=
ating with the hardware.

Some of the RDMA functionalities are implemented at GDMA layer in the PF ru=
nning on the host, so the message definitions are also there.

Long
