Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D5425F01A
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 21:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgIFTZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 15:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbgIFTZh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 15:25:37 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EE79207BB;
        Sun,  6 Sep 2020 19:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599420336;
        bh=r3R00rWeAW5JeWRxeGbtOmX+LmGpILhnS+TlH8J8a0U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tZj1Ic537J9/fzZs/1Ytdjto8YHjQVouenpxUv9k29HDjz4lsiF966dXQsQyZV4nL
         TtzAlDt/ukfuQZRcrag/JDLhmydergxKBVXy5U5I9T0117gND6oAIOaBexPG4OUlfu
         1wBzdip3xdpUdcqm0hmhxYLxhdvBRHd541m1Em7I=
Date:   Sun, 6 Sep 2020 12:25:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net 2/2] bnxt_en: Fix NULL ptr dereference crash in
 bnxt_fw_reset_task()
Message-ID: <20200906122534.54e16e08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1599360937-26197-3-git-send-email-michael.chan@broadcom.com>
References: <1599360937-26197-1-git-send-email-michael.chan@broadcom.com>
        <1599360937-26197-3-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Sep 2020 22:55:37 -0400 Michael Chan wrote:
> From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> 
> bnxt_fw_reset_task() which runs from a workqueue can race with
> bnxt_remove_one().  For example, if firmware reset and VF FLR are
> happening at about the same time.
> 
> bnxt_remove_one() already cancels the workqueue and waits for it
> to finish, but we need to do this earlier before the devlink
> reporters are destroyed.  This will guarantee that
> the devlink reporters will always be valid when bnxt_fw_reset_task()
> is still running.
> 
> Fixes: b148bb238c02 ("bnxt_en: Fix possible crash in bnxt_fw_reset_task().")
> Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 619eb55..8eb73fe 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -11779,6 +11779,10 @@ static void bnxt_remove_one(struct pci_dev *pdev)
>  	if (BNXT_PF(bp))
>  		bnxt_sriov_disable(bp);
>  
> +	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
> +	bnxt_cancel_sp_work(bp);
> +	bp->sp_event = 0;
> +
>  	bnxt_dl_fw_reporters_destroy(bp, true);
>  	if (BNXT_PF(bp))
>  		devlink_port_type_clear(&bp->dl_port);
> @@ -11786,9 +11790,6 @@ static void bnxt_remove_one(struct pci_dev *pdev)
>  	unregister_netdev(dev);
>  	bnxt_dl_unregister(bp);
>  	bnxt_shutdown_tc(bp);
> -	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
> -	bnxt_cancel_sp_work(bp);
> -	bp->sp_event = 0;
>  
>  	bnxt_clear_int_mode(bp);
>  	bnxt_hwrm_func_drv_unrgtr(bp);

devlink can itself scheduler a recovery via:

  bnxt_fw_fatal_recover() -> bnxt_fw_reset()

no? Maybe don't make the devlink recovery path need to go via a
workqueue?
