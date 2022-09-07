Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A8E5B0D2E
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 21:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiIGT1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 15:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiIGT1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 15:27:19 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1272AE2C
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 12:27:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VIbuCxye0A5k+i/IHPhRgW/tbbSKfvuIFktwNAUu7Vc9L4AI1IICG1vfyiRti5CRTMC8GOEUZ/9U1fI0ndMgKMHULIyc1j5uNInKcbk2i4T95aLOvIc9ZBekRJElY6wu++u9UEQvFYb+imq6HRi33OxOomndAmeW/MaWjWXTyssWqR8bchzh55QUpCZhEUei3GRcEWnY2xW6ThB7kmu5QvRvC26E08FNpeLfCgN8ncWm0EAldnpSyVtMYuzZnze9qBjFLHvAGVa/YDu61AtaGLAotrNol/tV+EuscfLfZlD6SSpK/lj2aUnRCGgUIMOeW1g5fYM8j91GMy7UtHxVWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E10qcP/udBNtN50M10Mpd9PSrAN81BxrUFRTIN7c09o=;
 b=cs2nU6ofdQeStvD/pLtyCPNTWH/EHEgmogKAxWH+ybb+69RWpdzSqzl5CFdiR/u6U5nCflQe09qGPsVHXorFzPg8QyzyXBCQAJi9w3sb2tUynvi+tdcXmoOuUKZMQHDVMdeRI4zuFahfW8x2DYHizdVUI12yGLJX/XnvLnYYcJvburJunNNASNQfabG3mBuOZ41mG2RA0O1ab5sB9QQt50+qdKAzaQ0LhAIqsxhiZBDDgsipRUHax9l7lLuQkcMCk5gUgQEEtfVi5U3xPXLgQTj6E+AzkSm5ysfCVOKWeENPInxp4/RW2iHZFn85p2DdMiI19l9sGmBmVj0SZOugBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E10qcP/udBNtN50M10Mpd9PSrAN81BxrUFRTIN7c09o=;
 b=kwaVLCGOe2gKe6HG7U1sASWPHSiH44P40rCD6JZC2mpWddXtWg9gdYfLj8iceY6KLWCTnmLtV9H9whamwrg2pT2VD6Ueu9Qxh/dRkDKGCo003UdbG9RUTNPnXhevaRav9+K3X5CSFMRCNPJC5fIpccSNwVdYCWwB+P82KyFbOf+j+pCfqcjE3Srq9pCZB/YbC5HQCCIKNXI+W6DDwu+7nm2oeVPuQEN2Q9OhAxzddPq7i8FQ2i+4WlSTnIz63Jzk/l3sCcWwr9Q3i9ScOKGrXcdttLH1qkncSaBA6GXfazM+az73ElP1yVLALa1TAeuWRnyByqbxjrpwoAKdzTwGaQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM6PR12MB4861.namprd12.prod.outlook.com (2603:10b6:5:1bd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 7 Sep
 2022 19:27:16 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98%9]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 19:27:16 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        Gavi Teitz <gavi@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: RE: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Thread-Topic: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Thread-Index: AQHYwpEbqLdY6RByfkyoSMo8wpA6EK3TsrMAgABG8oCAAA3LAIAAADnAgAACroCAABYGQIAAJjCAgAALaACAAAQwAIAAAFDQgAADKICAAACIkA==
Date:   Wed, 7 Sep 2022 19:27:16 +0000
Message-ID: <PH0PR12MB5481291080EBEC54C82A5641DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220907052317-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54812EC7F4711C1EA4CAA119DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907101335-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481D19E1E5DA11B2BD067CFDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907103420-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481066A18907753997A6F0CDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907141447-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481C6E39AB31AB445C714A1DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907151026-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54811F1234CB7822F47DD1B9DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907152156-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220907152156-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|DM6PR12MB4861:EE_
x-ms-office365-filtering-correlation-id: ea5c91e7-4cdf-4b48-e149-08da9106f927
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IkAJEMV1+qxsdRoc+iXc9A4Bemu755TBSrepZWjI5I3UDXfxNnd93dbE9zatSYOONdXz+i+FY/IyHMCHu6iFc07eRduIqnsKpynGpV0ClVY1TtfvswdpFKFxLVlufqmoqoYM7heyotDopQjhyqCPEDW0JvRb5N/lBTrFrb8/yZ0ioGPZjKm7XxSOl7sLjhf1/8kzRDvq9awlsffr7LpifQbtAt4Ptmtw66ImUrGFN3paMSL22YioEIy7El91g8vzlC4T3mNlO0jZE2QswmOHcs8Vj81w+Msy4GkUzRBmLMbbGPRClsnp4uPh/V1PZCOHcihxaVsNUxzAquCNYJlJaxhrAyhed0W3oQ8KCZw/YUBvuejYU1U83A603Ye4K5dcp/RCyZcVWD2Ie0XICfrUjLkRgSGPP+dJiW7wrxHXMOYhGberlPQp/SrMOny5L0SvO4CbTvee67d1mNAi9MYn0e3lAl+CvJW7N/93InGkbewzC7SYd4+Tr8NQMLSKPJAcaOmdCO5erfwJkCiU5anjlNQWee+w+gTl9m0EvRy92ptIjdTU1b1D5k0IjzXX4BoAsyqKGMQWuv6LVqAkNpo9/AlmzZfimqNVEtiqh8u2S82OwxjR+xc0B0aLvOqkBSoMME6CdnijEMOblJukY1ZCL9/RcG0MyKjDpY3trZvA8+M8x0WA3mI/D2NRIcYK38dLxHmayYH/OCs5eFtVDBi8Cv7+3VK1bTW00TC3THoalT5+Z+vrk06mGk8educ+nJieSbn8TAvAdCOmHCi2zn4QFFutMXauZIyHK5HFbXpMJ5s9BacX0sVhp0I7J0Tzsn9OzBWTrWdNFCmMxkngb3mO6CBsXWmgPAlFh15f+8Lgz5g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(38100700002)(45080400002)(71200400001)(54906003)(6916009)(186003)(122000001)(316002)(7696005)(66446008)(66946007)(966005)(52536014)(6506007)(478600001)(55016003)(64756008)(66476007)(4326008)(66556008)(76116006)(38070700005)(5660300002)(86362001)(8936002)(33656002)(4744005)(26005)(7416002)(83380400001)(8676002)(9686003)(2906002)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FJ0BHRM5TAOhDIl7oAIA/bvQ+1uEtdKhk+e3OOZQrP9sxrFPqw1awKN9a6RS?=
 =?us-ascii?Q?LxiNJSsqn4C1h/73bVMs8H6dLwz66fuvp5IKfuuVBmFQuutfryhzQNmjVXN0?=
 =?us-ascii?Q?UCE5d4ocTP0PcvFLbqIRSagucZvlTajALnvdCH/bM/hGTVorTBIov1iR0EL+?=
 =?us-ascii?Q?EC3mE543EbnTf6Hd0mz5Gvi8/0+g+yKgbXscC1xyWtCIc2C5ysnToIqtDUny?=
 =?us-ascii?Q?VFjYrmZfwAS1SDNhZK4jTgEvfVcbURSJj8YTWnmeJAKjxZvclJJGE69Oz9Jn?=
 =?us-ascii?Q?kKMziLFy86BXMHvA8aFjncDsXiSDjaNJKvo89EiV9fPO+tohnFyl6NftrREf?=
 =?us-ascii?Q?Tujw2XY5JOViIwaM9+9JwBS25XLRsPThQmmYy5uE3c+/+oVLgjRkTtbJQ0hW?=
 =?us-ascii?Q?+gtQowxiYOsg72eHXTs+1dFP1867LgHFvtVim16A9vrFcyDragT+giTQHaQz?=
 =?us-ascii?Q?qrQjJrgyiRRtm6SIqcKM6xrspqNuBqF+e/aaJsIbMkl23PQ4LJcDyYiUMKOH?=
 =?us-ascii?Q?D8QhwxCsJpDFO7hQxtQkYy6zm7pZ48UtOhv7pw47ocQMdsxwLL7YX1SXXvDb?=
 =?us-ascii?Q?E+qPFccMrFNFXlWmKWZILduoVhb+WHWrTzi3YPGa4YcK+kXlhbd40tB550rL?=
 =?us-ascii?Q?G0Clmunx+p7sCpSuWvfsRs52BGSqplwsFWdLRzqAdhBUzysN1q649NJqzZxY?=
 =?us-ascii?Q?cNoA4bFi/Ih2LVduO2Y8eeBIYMG2zbQWkp/Na+UkzleX2CM7Vteb5XzUFpds?=
 =?us-ascii?Q?uySU7+UKx+uGYC59Es6N3Olf/PVVm62UZjHyYRdFAYmOIpM21DZ8fvIEfJAM?=
 =?us-ascii?Q?E1gR9uW1Uqc64tYuvcCTKueiB3po+1Z2XALpsMtlyvL+zszEgezdDSJtSlCC?=
 =?us-ascii?Q?3cF5327bxArPAj7ikA2Ik/9lSxOHD/8jeOSEJLmOit2xjDAogHT91FxgUkdO?=
 =?us-ascii?Q?Qds/63fsCZZH1akIbYJSGNg/ppVwyT45kejj7/q7PBXMWFkJ6ewQE7k4QiHC?=
 =?us-ascii?Q?VWnqF0a98xmJDmllEAUS4L9JrIabO35dQdncbMOYjVlOsiPTl2B8oWQWp1+F?=
 =?us-ascii?Q?WMixJcJhew3jk9e3PuhEB0BgzrdL3llQg3ovcCb/jpNDBqD4mzWysbo6zQHW?=
 =?us-ascii?Q?x572/T3YEThLt9priHKKMPjatOLN5ZZReHuAqaYRDjlKftOCUSCzFsBBtepR?=
 =?us-ascii?Q?7MJtDfgcvq0ECrkiLItn7ZcwlwtTGYJ9XlKo0miTDhwgIGcOunXuVqmOwC8b?=
 =?us-ascii?Q?D+v+ahQmNt287P/vgz4v/HuqgLiKsIBUqlJnTr1gjjlR8pFH9qi2eTdclqyf?=
 =?us-ascii?Q?HXmaPvo6GZoMTHwc7XH2BE4CUkQFtVye/U7xy4zkMEkLQSzp8H5V1XjZZhZC?=
 =?us-ascii?Q?HLvEde5VffoyZtjO+gyvSiQtq/YWTePjSWxF6Q7Tud5psGMPEcJ7/5ZCbsgV?=
 =?us-ascii?Q?DUiKB3BiUtHnCGUxGVs91+YR7mHqlZ3SEck6+bCnLd7wzkKmkudC2/ZDwGtd?=
 =?us-ascii?Q?0CP7kBCW/KybesL3aIQz5BgD9L2qaExsDGo0xSj0IYfFMPOSL/7soXX466n3?=
 =?us-ascii?Q?gvMgv9RGpz2Kd9UpPlQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea5c91e7-4cdf-4b48-e149-08da9106f927
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 19:27:16.2161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kFgIr58pXD/OPE6xh13jm6mXBMuGdH+4rDtQVSNN1TOi2Vhqplt7I9VcajhwaDICOZtNXT90DN69AedASxVU5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4861
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Wednesday, September 7, 2022 3:24 PM
>=20
> On Wed, Sep 07, 2022 at 07:18:06PM +0000, Parav Pandit wrote:
> >
> > > From: Michael S. Tsirkin <mst@redhat.com>
> > > Sent: Wednesday, September 7, 2022 3:12 PM
> >
> > > > Because of shallow queue of 16 entries deep.
> > >
> > > but why is the queue just 16 entries?
> > I explained the calculation in [1] about 16 entries.
> >
> > [1]
> >
> https://lore.kernel.org/netdev/PH0PR12MB54812EC7F4711C1EA4CAA119DC
> 419@
> > PH0PR12MB5481.namprd12.prod.outlook.com/
> >
> > > does the device not support indirect?
> > >
> > Yes, indirect feature bit is disabled on the device.
>=20
> OK that explains it.

So can we proceed with v6 to contain=20
(a) updated commit message and
(b) function name change you suggested to drop _fields suffix?
