Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432314097D5
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344454AbhIMPvm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Sep 2021 11:51:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:23935 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244469AbhIMPvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 11:51:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10105"; a="208941499"
X-IronPort-AV: E=Sophos;i="5.85,290,1624345200"; 
   d="scan'208";a="208941499"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 08:49:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,290,1624345200"; 
   d="scan'208";a="469496135"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga007.fm.intel.com with ESMTP; 13 Sep 2021 08:49:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 13 Sep 2021 08:49:44 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 13 Sep 2021 08:49:43 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2242.012;
 Mon, 13 Sep 2021 08:49:43 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "yongxin.liu@windriver.com" <yongxin.liu@windriver.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Singhai, Anjali" <anjali.singhai@intel.com>,
        "Parikh, Neerav" <neerav.parikh@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [PATCH RESEND net] ice: Correctly deal with PFs that do not
 support RDMA
Thread-Topic: [PATCH RESEND net] ice: Correctly deal with PFs that do not
 support RDMA
Thread-Index: AQHXpcrK/jEhT3UrxEqhAh51dcd/n6udc5YA///U4xA=
Date:   Mon, 13 Sep 2021 15:49:43 +0000
Message-ID: <4bc2664ac89844a79242339f5e971335@intel.com>
References: <20210909151223.572918-1-david.m.ertman@intel.com>
 <YTsjDsFbBggL2X/8@unreal>
In-Reply-To: <YTsjDsFbBggL2X/8@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH RESEND net] ice: Correctly deal with PFs that do not
> support RDMA
> 
> On Thu, Sep 09, 2021 at 08:12:23AM -0700, Dave Ertman wrote:
> > There are two cases where the current PF does not support RDMA
> > functionality.  The first is if the NVM loaded on the device is set to
> > not support RDMA (common_caps.rdma is false).  The second is if the
> > kernel bonding driver has included the current PF in an active link
> > aggregate.
> >
> > When the driver has determined that this PF does not support RDMA,
> > then auxiliary devices should not be created on the auxiliary bus.
> 
> This part is wrong, auxiliary devices should always be created, in your case it will
> be one eth device only without extra irdma device.

It is worth considering having an eth aux device/driver but is it a hard-and-fast rule?
In this case, the RDMA-capable PCI network device spawns an auxiliary device for RDMA
and the core driver is a network driver.

> 
> Your "bug" is that you mixed auxiliary bus devices with "regular" ones and created
> eth device not as auxiliary one. This is why you are calling to auxiliary_device_init()
> for RDMA only and fallback to non-auxiliary mode.

It's a design choice on how you carve out function(s) off your PCI core device to be
managed by auxiliary driver(s) and not a bug.

Shiraz
