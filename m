Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334641BB3B1
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 04:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgD1CDX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Apr 2020 22:03:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:27163 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbgD1CDX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 22:03:23 -0400
IronPort-SDR: HZCZxWM7Ifh3ksSp5jqYZIjukICPw/GiFlS59dbNRHxTj4N0GFVqxwP1prPqbwnEn0eNUSBJll
 Xxyjs3MotPOA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 19:03:22 -0700
IronPort-SDR: EEVweodwJPv5ns0rgawtysI/doduM6IAQsxWs4JCjCp4Ks6LLFI80LVpWrgewoYsHZddJGeUxv
 qvMKV0RGxvog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,326,1583222400"; 
   d="scan'208";a="302574221"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Apr 2020 19:03:22 -0700
Received: from fmsmsx156.amr.corp.intel.com (10.18.116.74) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 27 Apr 2020 19:03:22 -0700
Received: from fmsmsx102.amr.corp.intel.com ([169.254.10.190]) by
 fmsmsx156.amr.corp.intel.com ([169.254.13.73]) with mapi id 14.03.0439.000;
 Mon, 27 Apr 2020 19:03:21 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>
Subject: RE: [PATCH net-next v3 00/11] implement DEVLINK_CMD_REGION_NEW
Thread-Topic: [PATCH net-next v3 00/11] implement DEVLINK_CMD_REGION_NEW
Thread-Index: AQHWA52YJkClmu+te0+eCyMdKsLl+qiOVYuA//+lfRA=
Date:   Tue, 28 Apr 2020 02:03:21 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58B6CF569F@FMSMSX102.amr.corp.intel.com>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
 <20200427172653.483e032d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200427172653.483e032d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Jakub Kicinski
> Sent: Monday, April 27, 2020 5:27 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jiri Pirko <jiri@resnulli.us>
> Subject: Re: [PATCH net-next v3 00/11] implement
> DEVLINK_CMD_REGION_NEW
> 
> On Thu, 26 Mar 2020 11:37:07 -0700 Jacob Keller wrote:
> > This series adds support for the DEVLINK_CMD_REGION_NEW operation, used
> to
> > enable userspace requesting a snapshot of a region on demand.
> >
> > This can be useful to enable adding regions for a driver for which there is
> > no trigger to create snapshots. By making this a core part of devlink, there
> > is no need for the drivers to use a separate channel such as debugfs.
> >
> > The primary intent for this kind of region is to expose device information
> > that might be useful for diagnostics and information gathering.
> >
> > The first few patches refactor regions to support a new ops structure for
> > extending the available operations that regions can perform. This includes
> > converting the destructor into an op from a function argument.
> >
> > Next, patches refactor the snapshot id allocation to use an xarray which
> > tracks the number of current snapshots using a given id. This is done so
> > that id lifetime can be determined, and ids can be released when no longer
> > in use.
> >
> > Without this change, snapshot ids remain used forever, until the snapshot_id
> > count rolled over UINT_MAX.
> >
> > Finally, code to enable the previously unused DEVLINK_CMD_REGION_NEW is
> > added. This code enforces that the snapshot id is always provided, unlike
> > previous revisions of this series.
> >
> > Finally, a patch is added to enable using this new command via the .snapshot
> > callback in both netdevsim and the ice driver.
> >
> > For the ice driver, a new "nvm-flash" region is added, which will enable
> > read access to the NVM flash contents. The intention for this is to allow
> > diagnostics tools to gather information about the device. By using a
> > snapshot and gathering the NVM contents all at once, the contents can be
> > atomic.
> 
> Hi Jake,
> 
> does iproute2 needs some patches to make this work?
> 
> ./devlink region new netdevsim/netdevsim1/dummy snapshot_id 1
> Command "new" not found

Ahh, yes I think it does. I seem to have forgotten to send these, will do so now.

Thanks,
Jake
