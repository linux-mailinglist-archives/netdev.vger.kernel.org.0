Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C8745A604
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 15:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbhKWOvD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Nov 2021 09:51:03 -0500
Received: from mga14.intel.com ([192.55.52.115]:50357 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhKWOvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 09:51:03 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="235269905"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="235269905"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 06:47:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="597103234"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 23 Nov 2021 06:47:55 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 23 Nov 2021 06:47:54 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 23 Nov 2021 06:47:54 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2242.012;
 Tue, 23 Nov 2021 06:47:54 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Parav Pandit <parav@nvidia.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "Kaliszczuk, Leszek" <leszek.kaliszczuk@intel.com>
Subject: RE: [PATCH net-next 2/3] net/ice: Add support for enable_iwarp and
 enable_roce devlink param
Thread-Topic: [PATCH net-next 2/3] net/ice: Add support for enable_iwarp and
 enable_roce devlink param
Thread-Index: AQHX3+Wwj2jkwMJw30a7BIv/n9/JUKwRGIqAgAAPGSA=
Date:   Tue, 23 Nov 2021 14:47:54 +0000
Message-ID: <b7cc7b5aeb7d4c7e98641195822e2019@intel.com>
References: <20211122211119.279885-1-anthony.l.nguyen@intel.com>
 <20211122211119.279885-3-anthony.l.nguyen@intel.com>
 <PH0PR12MB5481DD2B7212720BB387C3DEDC609@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB5481DD2B7212720BB387C3DEDC609@PH0PR12MB5481.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: RE: [PATCH net-next 2/3] net/ice: Add support for enable_iwarp and
> enable_roce devlink param
> 
> Hi Tony,
> 
> > From: Tony Nguyen <anthony.l.nguyen@intel.com>
> > Sent: Tuesday, November 23, 2021 2:41 AM
> >
> > From: Shiraz Saleem <shiraz.saleem@intel.com>
> >
> > Allow support for 'enable_iwarp' and 'enable_roce' devlink params to
> > turn on/off iWARP or RoCE protocol support for E800 devices.
> >
> > For example, a user can turn on iWARP functionality with,
> >
> > devlink dev param set pci/0000:07:00.0 name enable_iwarp value true
> > cmode runtime
> >
> > This add an iWARP auxiliary rdma device, ice.iwarp.<>, under this PF.
> >
> > A user request to enable both iWARP and RoCE under the same PF is
> > rejected since this device does not support both protocols
> > simultaneously on the same port.
> >
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > Tested-by: Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice.h         |   1 +
> >  drivers/net/ethernet/intel/ice/ice_devlink.c | 144 +++++++++++++++++++
> >  drivers/net/ethernet/intel/ice/ice_devlink.h |   6 +
> >  drivers/net/ethernet/intel/ice/ice_idc.c     |   4 +-
> >  drivers/net/ethernet/intel/ice/ice_main.c    |   9 +-
> >  include/linux/net/intel/iidc.h               |   7 +-
> >  6 files changed, 166 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/ice/ice.h
> > b/drivers/net/ethernet/intel/ice/ice.h
> > index b2db39ee5f85..b67ad51cbcc9 100644
> > --- a/drivers/net/ethernet/intel/ice/ice.h
> > +++ b/drivers/net/ethernet/intel/ice/ice.h
> > @@ -576,6 +576,7 @@ struct ice_pf {
> >  	struct ice_hw_port_stats stats_prev;
> >  	struct ice_hw hw;
> >  	u8 stat_prev_loaded:1; /* has previous stats been loaded */
> > +	u8 rdma_mode;
> This can be u8 rdma_mode: 1;
> See below.
> 
> >  	u16 dcbx_cap;
> >  	u32 tx_timeout_count;
> >  	unsigned long tx_timeout_last_recovery; diff --git
> > a/drivers/net/ethernet/intel/ice/ice_devlink.c
> > b/drivers/net/ethernet/intel/ice/ice_devlink.c
> > index b9bd9f9472f6..478412b28a76 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> > @@ -430,6 +430,120 @@ static const struct devlink_ops ice_devlink_ops = {
> >  	.flash_update = ice_devlink_flash_update,  };
> >
> > +static int
> > +ice_devlink_enable_roce_get(struct devlink *devlink, u32 id,
> > +			    struct devlink_param_gset_ctx *ctx) {
> > +	struct ice_pf *pf = devlink_priv(devlink);
> > +
> > +	ctx->val.vbool = pf->rdma_mode & IIDC_RDMA_PROTOCOL_ROCEV2;
> > +
> This is logical operation, and vbool will be still zero when rdma mode is rocev2,
> because it is not bit 0.
> Please see below. This error can be avoided by having rdma mode as Boolean.

Hi Parav -

rdma_mode is used as a bit-mask.
0 = disabled, i.e. enable_iwarp and enable_roce set to false by user.
1 = IIDC_RDMA_PROTOCOL_IWARP
2 = IIDC_RDMA_PROTOCOL_ROCEV2

Setting rocev2 involves,
pf->rdma_mode |= IIDC_RDMA_PROTOCOL_ROCEV2;

So this operation here should reflect correct value in vbool. I don't think this is a bug.

> > +static int
> > +ice_devlink_enable_iw_get(struct devlink *devlink, u32 id,
> > +			  struct devlink_param_gset_ctx *ctx) {
> > +	struct ice_pf *pf = devlink_priv(devlink);
> > +
> > +	ctx->val.vbool = pf->rdma_mode & IIDC_RDMA_PROTOCOL_IWARP;
> > +
> This works fine as this is bit 0, but not for roce. So lets just do boolean
> rdma_mode.

Boolean doesn't cut it as it doesn't reflect the disabled state mentioned above.

> > --- a/drivers/net/ethernet/intel/ice/ice_devlink.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_devlink.h
> > @@ -4,10 +4,16 @@
> >  #ifndef _ICE_DEVLINK_H_
> >  #define _ICE_DEVLINK_H_
> >
> > +enum ice_devlink_param_id {
> > +	ICE_DEVLINK_PARAM_ID_BASE =
> DEVLINK_PARAM_GENERIC_ID_MAX,
> > };
> > +
> This is unused in the patch. Please remove.

Sure.

Between, Thanks for the review!

Shiraz



