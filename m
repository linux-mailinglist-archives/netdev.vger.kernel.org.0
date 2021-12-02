Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDEF466963
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 18:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376450AbhLBRw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 12:52:27 -0500
Received: from smtprelay0160.hostedemail.com ([216.40.44.160]:46652 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1348064AbhLBRw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 12:52:26 -0500
Received: from omf05.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id CD02818046C52;
        Thu,  2 Dec 2021 17:49:02 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf05.hostedemail.com (Postfix) with ESMTPA id 1F8BE20011;
        Thu,  2 Dec 2021 17:49:00 +0000 (UTC)
Message-ID: <9ee7bdaaf71f7bcdd0ed0dc5a3e1127a12b6a68f.camel@perches.com>
Subject: Re: [PATCH net-next 1/2] net/ice: Fix boolean assignment
From:   Joe Perches <joe@perches.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, mustafa.ismail@intel.com,
        jacob.e.keller@intel.com, parav@nvidia.com, jiri@nvidia.com
Date:   Thu, 02 Dec 2021 09:49:00 -0800
In-Reply-To: <20211130181243.3707618-2-anthony.l.nguyen@intel.com>
References: <20211130181243.3707618-1-anthony.l.nguyen@intel.com>
         <20211130181243.3707618-2-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.64
X-Stat-Signature: s6o15ompt7yo38juekihrmifn8p5fcra
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 1F8BE20011
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/3CitUhV9aje2XQtsPCle2bCUn1bMRXS4=
X-HE-Tag: 1638467340-379837
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-11-30 at 10:12 -0800, Tony Nguyen wrote:
> From: Shiraz Saleem <shiraz.saleem@intel.com>
> 
> vbool in ice_devlink_enable_roce_get can be assigned to a
> non-0/1 constant.
> 
> Fix this assignment of vbool to be 0/1.

This one seems fine, but another use of vbool in ice still exists

drivers/net/ethernet/intel/ice/ice_devlink.c:617:       value.vbool = test_bit(ICE_FLAG_RDMA_ENA, pf->flags) ? true : false;

Curiously, the vbool is defined in a union so it's possible
for the vbool value in the union to not just be 0 or 1.

> diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
[]
> @@ -436,7 +436,7 @@ ice_devlink_enable_roce_get(struct devlink *devlink, u32 id,
>  {
>  	struct ice_pf *pf = devlink_priv(devlink);
>  
> -	ctx->val.vbool = pf->rdma_mode & IIDC_RDMA_PROTOCOL_ROCEV2;
> +	ctx->val.vbool = pf->rdma_mode & IIDC_RDMA_PROTOCOL_ROCEV2 ? true : false;
>  
>  	return 0;
>  }


