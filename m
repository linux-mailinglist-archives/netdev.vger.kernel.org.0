Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44523AE472
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 10:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhFUIDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 04:03:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhFUIDX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 04:03:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F3816109F;
        Mon, 21 Jun 2021 08:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624262469;
        bh=gPO/dZoq96/4oBsyGc1ThSkFDnPfX3ZoVFD1snea8ck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HoNf1YGzRXgmHTU0loB2T4/SVEkLSsgPC2LdgggESiQ/uR8KVA7Vc9FK+lMaTqEn3
         LCRUsDfVsGZ96ib/C5wbKl9kCzUcPfOYfn/MEH75lKXjG2Zm/TiV6awVNAKtdtCTM6
         JwR+eb3iepOdUsq7+qZp6+Ls9y2fPIbHlDgID+r0bqzE4Jpkh2E75XwNcCxIwPGCvD
         S6QIF89nU708IuCQcUBIQ/f3kUCMfYrUZTabOAvyNZLYAiz2pe+PADAE3lLRajHYDg
         VuEVdVy4jo0EFD+c3bqZ4hMTpFn+OiBNEuhL+eZpl0rb6ax5Culn7vFTzt6buowbaw
         eKMm/dci8g3Mg==
Date:   Mon, 21 Jun 2021 11:01:06 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pci@vger.kernel.org,
        tglx@linutronix.de, jesse.brandeburg@intel.com,
        robin.murphy@arm.com, mtosatti@redhat.com, mingo@kernel.org,
        jbrandeb@kernel.org, frederic@kernel.org, juri.lelli@redhat.com,
        abelits@marvell.com, bhelgaas@google.com, rostedt@goodmis.org,
        peterz@infradead.org, davem@davemloft.net,
        akpm@linux-foundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, maz@kernel.org, nhorman@tuxdriver.com,
        pjwaskiewicz@gmail.com, sassmann@redhat.com, thenzl@redhat.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jkc@redhat.com, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com, ahleihel@redhat.com,
        kheib@redhat.com, borisp@nvidia.com, saeedm@nvidia.com,
        benve@cisco.com, govind@gmx.com, jassisinghbrar@gmail.com,
        luobin9@huawei.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        nilal@redhat.com
Subject: Re: [PATCH v1 14/14] net/mlx4: Use irq_update_affinity_hint
Message-ID: <YNBHQvo1uDfBbr5c@unreal>
References: <20210617182242.8637-1-nitesh@redhat.com>
 <20210617182242.8637-15-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617182242.8637-15-nitesh@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 02:22:42PM -0400, Nitesh Narayan Lal wrote:
> The driver uses irq_set_affinity_hint() to update the affinity_hint mask
> that is consumed by the userspace to distribute the interrupts. However,
> under the hood irq_set_affinity_hint() also applies the provided cpumask
> (if not NULL) as the affinity for the given interrupt which is an
> undocumented side effect.
> 
> To remove this side effect irq_set_affinity_hint() has been marked
> as deprecated and new interfaces have been introduced. Hence, replace the
> irq_set_affinity_hint() with the new interface irq_update_affinity_hint()
> that only updates the affinity_hint pointer.
> 
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/eq.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
> index 9e48509ed3b2..f549d697ca95 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/eq.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
> @@ -244,9 +244,9 @@ static void mlx4_set_eq_affinity_hint(struct mlx4_priv *priv, int vec)
>  	    cpumask_empty(eq->affinity_mask))
>  		return;
>  
> -	hint_err = irq_set_affinity_hint(eq->irq, eq->affinity_mask);
> +	hint_err = irq_update_affinity_hint(eq->irq, eq->affinity_mask);
>  	if (hint_err)
> -		mlx4_warn(dev, "irq_set_affinity_hint failed, err %d\n", hint_err);
> +		mlx4_warn(dev, "irq_update_affinity_hint failed, err %d\n", hint_err);
>  }
>  #endif
>  
> @@ -1124,7 +1124,7 @@ static void mlx4_free_irqs(struct mlx4_dev *dev)
>  		if (eq_table->eq[i].have_irq) {
>  			free_cpumask_var(eq_table->eq[i].affinity_mask);
>  #if defined(CONFIG_SMP)
> -			irq_set_affinity_hint(eq_table->eq[i].irq, NULL);
> +			irq_update_affinity_hint(eq_table->eq[i].irq, NULL);
>  #endif

This #if/endif can be deleted.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
