Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05328337F14
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhCKUdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:33:11 -0500
Received: from mga05.intel.com ([192.55.52.43]:34284 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230454AbhCKUcf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 15:32:35 -0500
IronPort-SDR: VVghjzSiHlNMzfdtr3N+xwsQkJLMdFEJMZTQKjGlEjVLz7QJ28cTdOuZXQ3/tvMoPpovu/gg0K
 zOGO6tWiHAWg==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="273776822"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="273776822"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 12:32:34 -0800
IronPort-SDR: 8xNhb8wMcbUS77T52NVrxn7TvEEBcUq3HgASnvdPs2ySDrE05KoWH6NFqJDrxPfOx86BxTu34B
 SkoOJuQVEZ1w==
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="438277275"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.251.18.194])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 12:32:30 -0800
Date:   Thu, 11 Mar 2021 12:32:29 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "netanel@amazon.com" <netanel@amazon.com>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        "saeedb@amazon.com" <saeedb@amazon.com>,
        "GR-Linux-NIC-Dev@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        "skalluru@marvell.com" <skalluru@marvell.com>,
        "rmody@marvell.com" <rmody@marvell.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "doshir@vmware.com" <doshir@vmware.com>,
        "alexanderduyck@fb.com" <alexanderduyck@fb.com>
Subject: Re: [RFC PATCH 02/10] intel: Update drivers to use ethtool_gsprintf
Message-ID: <20210311123229.00007580@intel.com>
In-Reply-To: <161542652605.13546.13143472024905128153.stgit@localhost.localdomain>
References: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
        <161542652605.13546.13143472024905128153.stgit@localhost.localdomain>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Duyck wrote:

> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> Update the Intel drivers to make use of ethtool_gsprintf. The general idea
> is to reduce code size and overhead by replacing the repeated pattern of
> string printf statements and ETH_STRING_LEN counter increments.
> 
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_ethtool.c   |   16 ++----
>  drivers/net/ethernet/intel/ice/ice_ethtool.c     |   55 +++++++---------------
>  drivers/net/ethernet/intel/igb/igb_ethtool.c     |   40 ++++++----------
>  drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c |   40 ++++++----------
>  4 files changed, 50 insertions(+), 101 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> index c70dec65a572..932c6635cfd6 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> @@ -2368,21 +2368,15 @@ static void i40e_get_priv_flag_strings(struct net_device *netdev, u8 *data)
>  	struct i40e_netdev_priv *np = netdev_priv(netdev);
>  	struct i40e_vsi *vsi = np->vsi;
>  	struct i40e_pf *pf = vsi->back;
> -	char *p = (char *)data;
> +	u8 *p = data;
>  	unsigned int i;

As Jakub said, RCT... :-)

no other comments on the rest of the patch, looks good and Thanks!
