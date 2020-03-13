Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39043184E77
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgCMSQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgCMSQx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 14:16:53 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBBA620674;
        Fri, 13 Mar 2020 18:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584123412;
        bh=Hjb5JSKDAzSM/rpmWbDyevws+dhX2J+Y4qgcvnnbMHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PTtHg65c6Q26DNyLVhmJoiBMkZMDIEOkqkASu4K4Zpy1jLU2MwQl/JV5qZBvUKNjE
         94l8Mw/ncWLKcx4LMThKWNLkHYVaVZHnGsuh+XFqJDcgJc3nO8ugHfkWkntY05UO8m
         g/TfaLqSufOfASKP4ibdzEPwsLpueaa5Oh5gUvSk=
Date:   Fri, 13 Mar 2020 20:16:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v2 net-next 2/7] octeontx2-pf: Handle VF function level
 reset
Message-ID: <20200313181648.GD67638@unreal>
References: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
 <1584092566-4793-3-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584092566-4793-3-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 03:12:41PM +0530, sunil.kovvuri@gmail.com wrote:
> From: Geetha sowjanya <gakula@marvell.com>
>
> When FLR is initiated for a VF (PCI function level reset),
> the parent PF gets a interrupt. PF then sends a message to
> admin function (AF), which then cleanups all resources attached
> to that VF.
>
> Also handled IRQs triggered when master enable bit is cleared
> or set for VFs. This handler just clears the transaction pending
> ie TRPEND bit.
>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   7 +
>  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 234 ++++++++++++++++++++-
>  2 files changed, 240 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> index 74439e1..c0a9693 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> @@ -191,6 +191,11 @@ struct otx2_hw {
>  	u64			cgx_tx_stats[CGX_TX_STATS_COUNT];
>  };
>
> +struct flr_work {
> +	struct work_struct work;
> +	struct otx2_nic *pf;
> +};
> +
>  struct refill_work {
>  	struct delayed_work pool_refill_work;
>  	struct otx2_nic *pf;
> @@ -226,6 +231,8 @@ struct otx2_nic {
>
>  	u64			reset_count;
>  	struct work_struct	reset_task;
> +	struct workqueue_struct	*flr_wq;
> +	struct flr_work		*flr_wrk;
>  	struct refill_work	*refill_wrk;
>
>  	/* Ethtool stuff */
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> index 967ef7b..bf6e2529 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> @@ -61,6 +61,224 @@ static int otx2_change_mtu(struct net_device *netdev, int new_mtu)
>  	return err;
>  }
>
> +static void otx2_disable_flr_me_intr(struct otx2_nic *pf)
> +{
> +	int irq, vfs = pf->total_vfs;
> +
> +	/* Disable VFs ME interrupts */
> +	otx2_write64(pf, RVU_PF_VFME_INT_ENA_W1CX(0), INTR_MASK(vfs));
> +	irq = pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFME0);
> +	free_irq(irq, pf);
> +
> +	/* Disable VFs FLR interrupts */
> +	otx2_write64(pf, RVU_PF_VFFLR_INT_ENA_W1CX(0), INTR_MASK(vfs));
> +	irq = pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFFLR0);
> +	free_irq(irq, pf);
> +
> +	if (vfs <= 64)
> +		return;
> +
> +	otx2_write64(pf, RVU_PF_VFME_INT_ENA_W1CX(1), INTR_MASK(vfs - 64));
> +	irq = pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFME1);
> +	free_irq(irq, pf);
> +
> +	otx2_write64(pf, RVU_PF_VFFLR_INT_ENA_W1CX(1), INTR_MASK(vfs - 64));
> +	irq = pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFFLR1);
> +	free_irq(irq, pf);
> +}
> +
> +static void otx2_flr_wq_destroy(struct otx2_nic *pf)
> +{
> +	if (!pf->flr_wq)
> +		return;
> +	flush_workqueue(pf->flr_wq);
> +	destroy_workqueue(pf->flr_wq);

destroy_workqueue() calls to drain_workqueue() which calls to
flush_workqueue() in proper order and not like it is written here.

> +	pf->flr_wq = NULL;
> +	devm_kfree(pf->dev, pf->flr_wrk);
> +}
> +
> +static void otx2_flr_handler(struct work_struct *work)
> +{
> +	struct flr_work *flrwork = container_of(work, struct flr_work, work);
> +	struct otx2_nic *pf = flrwork->pf;
> +	struct msg_req *req;
> +	int vf, reg = 0;
> +
> +	vf = flrwork - pf->flr_wrk;
> +
> +	otx2_mbox_lock(&pf->mbox);

It is so bad that such function exists, it hides simple mutex_lock()
which is standard primitive.

Thanks
