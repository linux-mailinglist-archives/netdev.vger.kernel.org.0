Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128852F103E
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 11:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbhAKKjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 05:39:32 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:37864 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbhAKKjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 05:39:31 -0500
Date:   Mon, 11 Jan 2021 11:38:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610361529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gFMwVH0LwK1ioV30DuGf3L4/GzaRXnRGNbNpGIYu7uQ=;
        b=XbLJUkpsQlfZFbTEFf9AgSlV2zc8OR7ystWTdDdtbj9QpOK336eML/JzGhemmWjO7I0r+i
        yrdRCTBS1wEgWcP6NXJ0IkvqSMe1Tqq3Zv/BjmtiAPSbewZ1J+/EoBE1mz3bjaGKbp3XQU
        b5HlTppy0EZKjquVnq9wzdJHXcj/D5peCRNmvy78IM+ewgqEdo9PtgaKj28iyGqBuyHUy+
        NLSoT9TBvI+9LPk+k4LzVF7ITF1KKqH+Mi51pFUCiMhUypx6i19iXTO9YOcN3QaIpUNVW7
        ZbWaxa3E8NiyZWZjjUfjoIAPrlMdy3jLy4WI26tXNOZS+JyD4cQiadkt5xWyvg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610361529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gFMwVH0LwK1ioV30DuGf3L4/GzaRXnRGNbNpGIYu7uQ=;
        b=SP71bQWVqDR0XrLbvN7FyAQCf3zu+vkmEfk2EbDsWVQQh6voaR9vqcrBBl92VTT6vZDJY9
        AvPUxYSKJJHfODAA==
From:   "Sebastian A. Siewior" <bigeasy@linutronix.de>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 2/3] chelsio: cxgb: Move slow interrupt handling to
 threaded irqs
Message-ID: <20210111103847.cvp7ddd52cga3wuh@linutronix.de>
References: <20201224131148.300691-1-a.darwish@linutronix.de>
 <20201224131148.300691-3-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201224131148.300691-3-a.darwish@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-24 14:11:47 [+0100], Ahmed S. Darwish wrote:
> --- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
> +++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
> @@ -211,9 +211,9 @@ static int cxgb_up(struct adapter *adapter)
>  	t1_interrupts_clear(adapter);
>  
>  	adapter->params.has_msi = !disable_msi && !pci_enable_msi(adapter->pdev);
> -	err = request_irq(adapter->pdev->irq, t1_interrupt,
> -			  adapter->params.has_msi ? 0 : IRQF_SHARED,
> -			  adapter->name, adapter);
> +	err = request_threaded_irq(adapter->pdev->irq, t1_irq, t1_irq_thread,
> +				   adapter->params.has_msi ? 0 : IRQF_SHARED,
> +				   adapter->name, adapter);
>  	if (err) {
>  		if (adapter->params.has_msi)
>  			pci_disable_msi(adapter->pdev);
> diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet/chelsio/cxgb/sge.c
> index d6df1a87db0b..f1c402f6b889 100644
> --- a/drivers/net/ethernet/chelsio/cxgb/sge.c
> +++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
> @@ -1626,11 +1626,10 @@ int t1_poll(struct napi_struct *napi, int budget)
>  	return work_done;
>  }
>  
> -irqreturn_t t1_interrupt(int irq, void *data)
> +irqreturn_t t1_irq(int irq, void *data)
>  {
>  	struct adapter *adapter = data;
>  	struct sge *sge = adapter->sge;
> -	int handled;
>  
>  	if (likely(responses_pending(adapter))) {
>  		writel(F_PL_INTR_SGE_DATA, adapter->regs + A_PL_CAUSE);
> @@ -1645,9 +1644,19 @@ irqreturn_t t1_interrupt(int irq, void *data)
>  				napi_enable(&adapter->napi);
>  			}
>  		}
> +
>  		return IRQ_HANDLED;
>  	}
>  
> +	return IRQ_WAKE_THREAD;
> +}
> +
> +irqreturn_t t1_irq_thread(int irq, void *data)
> +{
> +	struct adapter *adapter = data;
> +	struct sge *sge = adapter->sge;
> +	int handled;
> +
>  	spin_lock(&adapter->async_lock);
>  	handled = t1_slow_intr_handler(adapter);
>  	spin_unlock(&adapter->async_lock);

This does not work in general, it might work in the MSI case but does
not work for the LEVEL interrupt case: The interrupt remains active
because it has not been ACKed. Chances are that the threaded handler
never gets scheduled because interrupt is still pending and t1_irq()
gets invoked right away.
For that reason, the primary must either mask the interrupt source or
use IRQF_ONESHOT to mask the interrupt line until the threaded handler
is done.

If you look at t1_elmer0_ext_intr() it disables F_PL_INTR_EXT before the
worker scheduled so the interrupt does not trigger again.
The worker then does what ever is needed (t1_elmer0_ext_intr_handler)
and then ACKs F_PL_INTR_EXT and enables F_PL_INTR_EXT again so it may
trigger an interrupt again.

Sebastian
