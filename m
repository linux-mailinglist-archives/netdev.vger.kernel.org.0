Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3AE9336A07
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 03:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhCKCIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 21:08:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhCKCIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 21:08:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1435564FAA;
        Thu, 11 Mar 2021 02:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615428489;
        bh=NLWsAdZX4Z7588LIkFwbfw139IjUY4CRLCIvxvC3TBA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Hsk/nFWRhJV6YvrHzO8BJOANQaMYYcu5PosERdHcsiub2TVeUY22/dJCqClyLsMkq
         BgvnvaB8zq6E+VQKu2pKTDqRk8e71ZgJy5q+S+D6jmf8DtMUFLqtAMmVynJPM4KW0v
         X7z157aXfnRAuqyrzREEw9mDqjoqJEvjOvt4DSIuodAIltlPKFO6PQX/TYS1ew6S4W
         fcZsLXedJYSn2X/4dYSmJPVcYjteHi4Tj3KK3Bd1O6CCs31cBV3LblF1l3BHAmaaZP
         gUkefhDSM03GAKDcrHjSiCNEgTC+H+9R2JaoOl8GlcLcT9S2Bli/ogr7n51xZ36xap
         LDY67frNuwO1Q==
Date:   Wed, 10 Mar 2021 18:08:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        drivers@pensando.io, snelson@pensando.io, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, saeedb@amazon.com,
        GR-Linux-NIC-Dev@marvell.com, skalluru@marvell.com,
        rmody@marvell.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, mst@redhat.com,
        jasowang@redhat.com, pv-drivers@vmware.com, doshir@vmware.com,
        alexanderduyck@fb.com
Subject: Re: [RFC PATCH 01/10] ethtool: Add common function for filling out
 strings
Message-ID: <20210310180807.5fb1752d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <161542651749.13546.3959589547085613076.stgit@localhost.localdomain>
References: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
        <161542651749.13546.3959589547085613076.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Mar 2021 17:35:17 -0800 Alexander Duyck wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> Add a function to handle the common pattern of printing a string into the
> ethtool strings interface and incrementing the string pointer by the
> ETH_GSTRING_LEN. Most of the drivers end up doing this and several have
> implemented their own versions of this function so it would make sense to
> consolidate on one implementation.
> 
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> ---
>  include/linux/ethtool.h |    9 +++++++++
>  net/ethtool/ioctl.c     |   12 ++++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index ec4cd3921c67..0493f13b2b20 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -571,4 +571,13 @@ struct ethtool_phy_ops {
>   */
>  void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops);
>  
> +/**
> + * ethtool_gsprintf - Write formatted string to ethtool string data
> + * @data: Pointer to start of string to update
> + * @fmt: Format of string to write
> + *
> + * Write formatted string to data. Update data to point at start of
> + * next string.
> + */
> +extern __printf(2, 3) void ethtool_gsprintf(u8 **data, const char *fmt, ...);

I'd drop the 'g' TBH, it seems to have made its way from the ethtool
command ('gstrings') to various places but without the 'string' after
it - it becomes less and less meaningful. Just ethtool_sprintf() would
be fine IMHO.

Other than that there is a minor rev xmas tree violation in patch 2 :)
