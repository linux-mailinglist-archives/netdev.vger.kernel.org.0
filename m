Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E7269DCCE
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 10:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbjBUJX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 04:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjBUJXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 04:23:25 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3287EE7
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 01:23:23 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id EAA8161CC457B;
        Tue, 21 Feb 2023 10:23:19 +0100 (CET)
Message-ID: <14182338-15eb-4cef-6b4f-a76f448434e1@molgen.mpg.de>
Date:   Tue, 21 Feb 2023 10:23:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [Intel-wired-lan] [PATCH net-next v3 1/1] ice: Change assigning
 method of the CPU affinity masks
Content-Language: en-US
To:     Pawel Chmielewski <pawel.chmielewski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@osuosl.org
References: <20230217220359.987004-1-pawel.chmielewski@intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230217220359.987004-1-pawel.chmielewski@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Pawel,


Thank you for your patch.

Am 17.02.23 um 23:03 schrieb Pawel Chmielewski:
> With the introduction of sched_numa_hop_mask() and for_each_numa_hop_mask(),
> the affinity masks for queue vectors can be conveniently set by preferring the
> CPUs that are closest to the NUMA node of the parent PCI device.

Please reflow the commit message for 75 characters per line.

Additionally, you could be more specific in the commit message summary:

ice: Prefer CPUs closest to NUMA node of parent PCI

In the commit message, please elaborate, how you tested and benchmarked 
your change.

> Signed-off-by: Pawel Chmielewski <pawel.chmielewski@intel.com>
> ---
> Changes since v2:
>   * Pointers for cpumasks point to const struct cpumask
>   * Removed unnecessary label
>   * Removed redundant blank lines
> 
> Changes since v1:
>   * Removed obsolete comment
>   * Inverted condition for loop escape
>   * Incrementing v_idx only in case of available cpu
> ---
>   drivers/net/ethernet/intel/ice/ice_base.c | 21 ++++++++++++++++-----
>   1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
> index 1911d644dfa8..30dc1c3c290f 100644
> --- a/drivers/net/ethernet/intel/ice/ice_base.c
> +++ b/drivers/net/ethernet/intel/ice/ice_base.c
> @@ -121,9 +121,6 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
>   
>   	if (vsi->type == ICE_VSI_VF)
>   		goto out;
> -	/* only set affinity_mask if the CPU is online */
> -	if (cpu_online(v_idx))
> -		cpumask_set_cpu(v_idx, &q_vector->affinity_mask);
>   
>   	/* This will not be called in the driver load path because the netdev
>   	 * will not be created yet. All other cases with register the NAPI
> @@ -662,8 +659,10 @@ int ice_vsi_wait_one_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx)
>    */
>   int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
>   {
> +	const struct cpumask *aff_mask, *last_aff_mask = cpu_none_mask;
>   	struct device *dev = ice_pf_to_dev(vsi->back);
> -	u16 v_idx;
> +	int numa_node = dev->numa_node;
> +	u16 v_idx, cpu = 0;

Could you use `unsigned int` for `cpu`?

     include/linux/cpumask.h:static inline bool cpu_online(unsigned int cpu)

>   	int err;
>   
>   	if (vsi->q_vectors[0]) {
> @@ -677,7 +676,19 @@ int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
>   			goto err_out;
>   	}
>   
> -	return 0;
> +	v_idx = 0;
> +	for_each_numa_hop_mask(aff_mask, numa_node) {
> +		for_each_cpu_andnot(cpu, aff_mask, last_aff_mask) {
> +			if (v_idx >= vsi->num_q_vectors)
> +				return 0;
> +
> +			if (cpu_online(cpu)) {
> +				cpumask_set_cpu(cpu, &vsi->q_vectors[v_idx]->affinity_mask);
> +				v_idx++;
> +			}
> +		}
> +		last_aff_mask = aff_mask;
> +	}
>   
>   err_out:
>   	while (v_idx--)


Kind regards,

Paul
