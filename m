Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4DA3ABCC8
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 21:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbhFQTd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 15:33:28 -0400
Received: from foss.arm.com ([217.140.110.172]:59242 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231666AbhFQTd0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 15:33:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 99B2F1424;
        Thu, 17 Jun 2021 12:31:18 -0700 (PDT)
Received: from [10.57.9.136] (unknown [10.57.9.136])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98B2F3F694;
        Thu, 17 Jun 2021 12:31:10 -0700 (PDT)
Subject: Re: [PATCH v1 04/14] scsi: megaraid_sas: Use
 irq_set_affinity_and_hint
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pci@vger.kernel.org,
        tglx@linutronix.de, jesse.brandeburg@intel.com,
        mtosatti@redhat.com, mingo@kernel.org, jbrandeb@kernel.org,
        frederic@kernel.org, juri.lelli@redhat.com, abelits@marvell.com,
        bhelgaas@google.com, rostedt@goodmis.org, peterz@infradead.org,
        davem@davemloft.net, akpm@linux-foundation.org,
        sfr@canb.auug.org.au, stephen@networkplumber.org,
        rppt@linux.vnet.ibm.com, chris.friesen@windriver.com,
        maz@kernel.org, nhorman@tuxdriver.com, pjwaskiewicz@gmail.com,
        sassmann@redhat.com, thenzl@redhat.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jkc@redhat.com, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com, ahleihel@redhat.com,
        kheib@redhat.com, borisp@nvidia.com, saeedm@nvidia.com,
        benve@cisco.com, govind@gmx.com, jassisinghbrar@gmail.com,
        luobin9@huawei.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        nilal@redhat.com
References: <20210617182242.8637-1-nitesh@redhat.com>
 <20210617182242.8637-5-nitesh@redhat.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <ddee52a6-ac70-6e2d-b48e-e9bf38c94265@arm.com>
Date:   Thu, 17 Jun 2021 20:31:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210617182242.8637-5-nitesh@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-17 19:22, Nitesh Narayan Lal wrote:
> The driver uses irq_set_affinity_hint() specifically for the high IOPS
> queue interrupts for two purposes:
> 
> - To set the affinity_hint which is consumed by the userspace for
>    distributing the interrupts
> 
> - To apply an affinity that it provides
> 
> The driver enforces its own affinity to bind the high IOPS queue interrupts
> to the local NUMA node. However, irq_set_affinity_hint() applying the
> provided cpumask as an affinity for the interrupt is an undocumented side
> effect.
> 
> To remove this side effect irq_set_affinity_hint() has been marked
> as deprecated and new interfaces have been introduced. Hence, replace the
> irq_set_affinity_hint() with the new interface irq_set_affinity_and_hint()
> that clearly indicates the purpose of the usage and is meant to apply the
> affinity and set the affinity_hint pointer. Also, replace
> irq_set_affinity_hint() with irq_update_affinity_hint() when only
> affinity_hint needs to be updated.
> 
> Change the megasas_set_high_iops_queue_affinity_hint function name to
> megasas_set_high_iops_queue_affinity_and_hint to clearly indicate that the
> function is setting both affinity and affinity_hint.
> 
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>   drivers/scsi/megaraid/megaraid_sas_base.c | 25 ++++++++++++++---------
>   1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 4d4e9dbe5193..54f4eac09589 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -5666,7 +5666,7 @@ megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
>   				"Failed to register IRQ for vector %d.\n", i);
>   			for (j = 0; j < i; j++) {
>   				if (j < instance->low_latency_index_start)
> -					irq_set_affinity_hint(
> +					irq_update_affinity_hint(
>   						pci_irq_vector(pdev, j), NULL);
>   				free_irq(pci_irq_vector(pdev, j),
>   					 &instance->irq_context[j]);
> @@ -5709,7 +5709,7 @@ megasas_destroy_irqs(struct megasas_instance *instance) {
>   	if (instance->msix_vectors)
>   		for (i = 0; i < instance->msix_vectors; i++) {
>   			if (i < instance->low_latency_index_start)
> -				irq_set_affinity_hint(
> +				irq_update_affinity_hint(
>   				    pci_irq_vector(instance->pdev, i), NULL);
>   			free_irq(pci_irq_vector(instance->pdev, i),
>   				 &instance->irq_context[i]);
> @@ -5840,22 +5840,27 @@ int megasas_get_device_list(struct megasas_instance *instance)
>   }
>   
>   /**
> - * megasas_set_high_iops_queue_affinity_hint -	Set affinity hint for high IOPS queues
> - * @instance:					Adapter soft state
> - * return:					void
> + * megasas_set_high_iops_queue_affinity_and_hint -	Set affinity and hint
> + *							for high IOPS queues
> + * @instance:						Adapter soft state
> + * return:						void
>    */
>   static inline void
> -megasas_set_high_iops_queue_affinity_hint(struct megasas_instance *instance)
> +megasas_set_high_iops_queue_affinity_and_hint(struct megasas_instance *instance)
>   {
>   	int i;
> +	unsigned int irq;
>   	int local_numa_node;
> +	const struct cpumask *mask;
>   
>   	if (instance->perf_mode == MR_BALANCED_PERF_MODE) {
>   		local_numa_node = dev_to_node(&instance->pdev->dev);

Drive-by nit: you could assign mask in this scope.

> -		for (i = 0; i < instance->low_latency_index_start; i++)
> -			irq_set_affinity_hint(pci_irq_vector(instance->pdev, i),
> -				cpumask_of_node(local_numa_node));
> +		for (i = 0; i < instance->low_latency_index_start; i++) {
> +			irq = pci_irq_vector(instance->pdev, i);
> +			mask = cpumask_of_node(local_numa_node);
> +			irq_update_affinity_hint(irq, mask);

And this doesn't seem to match what the commit message says?

Robin.

> +		}
>   	}
>   }
>   
> @@ -5944,7 +5949,7 @@ megasas_alloc_irq_vectors(struct megasas_instance *instance)
>   		instance->msix_vectors = 0;
>   
>   	if (instance->smp_affinity_enable)
> -		megasas_set_high_iops_queue_affinity_hint(instance);
> +		megasas_set_high_iops_queue_affinity_and_hint(instance);
>   }
>   
>   /**
> 
