Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6EE2E79CB
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 14:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgL3Nsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 08:48:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:59780 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727000AbgL3Nsu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 08:48:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0DC0DABA1;
        Wed, 30 Dec 2020 13:48:08 +0000 (UTC)
Date:   Wed, 30 Dec 2020 14:48:06 +0100
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     YANG LI <abaci-bugfix@linux.alibaba.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ljp@linux.ibm.com, drt@linux.ibm.com,
        kuba@kernel.org, sukadev@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org, paulus@samba.org
Subject: Re: [PATCH] ibmvnic: fix: NULL pointer dereference.
Message-ID: <20201230134806.GN6564@kitsune.suse.cz>
References: <1609312994-121032-1-git-send-email-abaci-bugfix@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1609312994-121032-1-git-send-email-abaci-bugfix@linux.alibaba.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 03:23:14PM +0800, YANG LI wrote:
> The error is due to dereference a null pointer in function
> reset_one_sub_crq_queue():
> 
> if (!scrq) {
>     netdev_dbg(adapter->netdev,
>                "Invalid scrq reset. irq (%d) or msgs(%p).\n",
> 		scrq->irq, scrq->msgs);
> 		return -EINVAL;
> }
> 
> If the expression is true, scrq must be a null pointer and cannot
> dereference.
> 
> Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
> Reported-by: Abaci <abaci@linux.alibaba.com>
Fixes: 9281cf2d5840 ("ibmvnic: avoid memset null scrq msgs")
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index f302504..d7472be 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2981,9 +2981,7 @@ static int reset_one_sub_crq_queue(struct ibmvnic_adapter *adapter,
>  	int rc;
>  
>  	if (!scrq) {
> -		netdev_dbg(adapter->netdev,
> -			   "Invalid scrq reset. irq (%d) or msgs (%p).\n",
> -			   scrq->irq, scrq->msgs);
> +		netdev_dbg(adapter->netdev, "Invalid scrq reset.\n");
>  		return -EINVAL;
>  	}
>  
> -- 
> 1.8.3.1
> 
