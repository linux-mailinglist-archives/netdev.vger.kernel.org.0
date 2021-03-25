Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFC834965B
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhCYQEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:04:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229981AbhCYQDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 12:03:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F73C61A0E;
        Thu, 25 Mar 2021 16:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616688214;
        bh=emAfEeLHBQvZbla0b7x+tBWTGDNAOUBlHBSjSxTR2hc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sded5VbQpXZIMN2m9KADnpvEQ4WbLMF2DgTJSItdSN8c//WwuVyXdP2Fa5z/3UVzH
         jjMZOxsV/expXAGKR1pEUBKbZK2nqCfxwbEzSyAj3CXY8iNbbFJy3qLBssZg09ux5P
         bpR96CRiiJ3Cl8AWo/os7SXyCqR2vc2+m9TroQYiG07HXzcP8BeDkfdePFB3wnyfaj
         N3uapb+ssrdaLLoZU/eHi6cpg7+QgI9+aJ9ma8PacSaLhJJEGolhDrhsj0pJ7aHesF
         6bW671ZIenWUhD7FlI6qT+T+UWctb32u5VB0mRvAMoGYIJgxrRCJGGBHsXdSMTEx4R
         RAt4v3/JljS6g==
Date:   Thu, 25 Mar 2021 09:03:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@lists.01.org, davem@davemloft.net, lkp@intel.com,
        kbuild-all@lists.01.org, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, michael.chan@broadcom.com,
        damian.dybek@intel.com, paul.greenwalt@intel.com,
        rajur@chelsio.com, jaroslawx.gawin@intel.com, vkochan@marvell.com,
        alobakin@pm.me
Subject: Re: [PATCH net-next 5/6] ethtool: fec: sanitize
 ethtool_fecparam->fec
Message-ID: <20210325090333.26088719@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210325120047.GX1717@kadam>
References: <20210325011200.145818-6-kuba@kernel.org>
        <20210325120047.GX1717@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Mar 2021 15:00:47 +0300 Dan Carpenter wrote:
> Hi Jakub,
> 
> url:    https://github.com/0day-ci/linux/commits/Jakub-Kicinski/ethtool-clarify-the-ethtool-FEC-interface/20210325-091411
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 69cdfb530f7b8b094e49555454869afc8140b1bb
> config: x86_64-randconfig-m001-20210325 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> smatch warnings:
> net/ethtool/ioctl.c:2589 ethtool_set_fecparam() warn: bitwise AND condition is false here
> 
> vim +2589 net/ethtool/ioctl.c
> 
> 1a5f3da20bd966 net/core/ethtool.c  Vidya Sagar Ravipati 2017-07-27  2579  static int ethtool_set_fecparam(struct net_device *dev, void __user *useraddr)
> 1a5f3da20bd966 net/core/ethtool.c  Vidya Sagar Ravipati 2017-07-27  2580  {
> 1a5f3da20bd966 net/core/ethtool.c  Vidya Sagar Ravipati 2017-07-27  2581  	struct ethtool_fecparam fecparam;
> 1a5f3da20bd966 net/core/ethtool.c  Vidya Sagar Ravipati 2017-07-27  2582  
> 1a5f3da20bd966 net/core/ethtool.c  Vidya Sagar Ravipati 2017-07-27  2583  	if (!dev->ethtool_ops->set_fecparam)
> 1a5f3da20bd966 net/core/ethtool.c  Vidya Sagar Ravipati 2017-07-27  2584  		return -EOPNOTSUPP;
> 1a5f3da20bd966 net/core/ethtool.c  Vidya Sagar Ravipati 2017-07-27  2585  
> 1a5f3da20bd966 net/core/ethtool.c  Vidya Sagar Ravipati 2017-07-27  2586  	if (copy_from_user(&fecparam, useraddr, sizeof(fecparam)))
> 1a5f3da20bd966 net/core/ethtool.c  Vidya Sagar Ravipati 2017-07-27  2587  		return -EFAULT;
> 1a5f3da20bd966 net/core/ethtool.c  Vidya Sagar Ravipati 2017-07-27  2588  
> 15beed7dba77ce net/ethtool/ioctl.c Jakub Kicinski       2021-03-24 @2589  	if (!fecparam.fec || fecparam.fec & ETHTOOL_FEC_NONE_BIT)
>                                                                                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:o good catch. s/_BIT//. Thanks!
