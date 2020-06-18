Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9357B1FFEE9
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 01:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgFRXuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 19:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbgFRXuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 19:50:10 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8B96207D8;
        Thu, 18 Jun 2020 23:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592524210;
        bh=p8RjmkFLLZDI7QuLOeEjhIGYbCEsHgGW33hVCOixeOk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ld33XPv0GdQzIcvHL11JuV3uSRk1h8NnJpTmXzUHJEN7vAyxhGBh0rpYxKLQ7xVr7
         jmePw60CmCFbjK/ae6OS5ae2L+2R77C8/f3Km1TcVp/jlLoflX8FDYu0uW5sd1qUuv
         0vTJJsh2jcyGJ0llWkPL3LsivlWMa5uXjtprKoK8=
Date:   Thu, 18 Jun 2020 16:50:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [net-next 13/15] iecm: Add ethtool
Message-ID: <20200618165008.4d475087@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200618051344.516587-14-jeffrey.t.kirsher@intel.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
        <20200618051344.516587-14-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 22:13:42 -0700 Jeff Kirsher wrote:
> +static const struct ethtool_ops iecm_ethtool_ops = {
> +	.get_drvinfo		= iecm_get_drvinfo,
> +	.get_msglevel		= iecm_get_msglevel,
> +	.set_msglevel		= iecm_set_msglevel,
> +	.get_coalesce		= iecm_get_coalesce,
> +	.set_coalesce		= iecm_set_coalesce,
> +	.get_per_queue_coalesce	= iecm_get_per_q_coalesce,
> +	.set_per_queue_coalesce	= iecm_set_per_q_coalesce,
> +	.get_ethtool_stats	= iecm_get_ethtool_stats,
> +	.get_strings		= iecm_get_strings,
> +	.get_sset_count		= iecm_get_sset_count,
> +	.get_rxnfc		= iecm_get_rxnfc,
> +	.get_rxfh_key_size	= iecm_get_rxfh_key_size,
> +	.get_rxfh_indir_size	= iecm_get_rxfh_indir_size,
> +	.get_rxfh		= iecm_get_rxfh,
> +	.set_rxfh		= iecm_set_rxfh,
> +	.get_channels		= iecm_get_channels,
> +	.set_channels		= iecm_set_channels,
> +	.get_ringparam		= iecm_get_ringparam,
> +	.set_ringparam		= iecm_set_ringparam,
> +	.get_link_ksettings	= iecm_get_link_ksettings,
> +};

Oh wow. So you're upstreaming this driver based on at least a 3 month
old tree? This:

commit 9000edb71ab29d184aa33f5a77fa6e52d8812bb9
Author: Jakub Kicinski <kuba@kernel.org>
Date:   Mon Mar 16 13:47:12 2020 -0700

+int ethtool_check_ops(const struct ethtool_ops *ops)
+{
+       if (WARN_ON(ops->set_coalesce && !ops->supported_coalesce_params))
+               return -EINVAL;

would have otherwise triggered.

