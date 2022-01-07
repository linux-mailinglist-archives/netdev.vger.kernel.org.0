Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C1F4871C4
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 05:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345471AbiAGEc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 23:32:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51672 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiAGEc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 23:32:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1975EB824D9
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 04:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889B5C36AE5;
        Fri,  7 Jan 2022 04:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641529975;
        bh=P8ycnvOVDoXgnQPNsr6j2Gc9mXqzPoVJhtYKAK7nwp4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OQlSYbYVFPtu7VvsOVI2CKyfI0EnDQfjEa67U+mnRpfcx05pJga7qqceH8J+KlY9w
         TkgL8AQ2khPc2IIhvjDwhQFhPfwlf70hI8wTnEzD17+SJ6xFC5BlWrjA5pdmhyeT9X
         aLdt5y5ZA2eCxCunKKDrnbbxzC75hbI4J8dVJGyozROJxZtriKYf8P1Lz+fWtiNKAc
         A6CNoAQPxi3vaI55vami5KUoM9e+2oAoUfmXqd6+mNvqimPBzgE5gZBtCa0gwZUtqD
         hM74AuVg9v8kTjnebSbarBmwvmlmSAA70W6vN2XCb2hlQiQWWRdGCeppp2+6ewwhE1
         zb63vH2nUMlUA==
Date:   Thu, 6 Jan 2022 20:32:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Karen Sornek <karen.sornek@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net-next 2/7] i40e: Add placeholder for ndo set VLANs
Message-ID: <20220106203254.1c6159fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220106213301.11392-3-anthony.l.nguyen@intel.com>
References: <20220106213301.11392-1-anthony.l.nguyen@intel.com>
        <20220106213301.11392-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Jan 2022 13:32:56 -0800 Tony Nguyen wrote:
> From: Karen Sornek <karen.sornek@intel.com>
> 
> VLANs set by ndo, were not accounted.
> Implement placeholder, by which driver can account VLANs set by
> ndo. Ensure that once PF changes trunk, every guest filter
> is removed from the list 'vm_vlan_list'.
> Implement logic for deletion/addition of guest(from VM) filters.

I could not understand what this change is achieving from reading this.

> +/**
> + * i40e_add_vmvlan_to_list
> + * @vf: pointer to the VF info
> + * @vfl:  pointer to the VF VLAN tag filters list
> + * @vlan_idx: vlan_id index in VLAN tag filters list
> + *
> + * add VLAN tag into the VLAN list for VM
> + **/
> +static i40e_status
> +i40e_add_vmvlan_to_list(struct i40e_vf *vf,
> +			struct virtchnl_vlan_filter_list *vfl,
> +			u16 vlan_idx)
> +{
> +	struct i40e_vm_vlan *vlan_elem;
> +
> +	vlan_elem = kzalloc(sizeof(*vlan_elem), GFP_KERNEL);
> +	if (!vlan_elem)
> +		return I40E_ERR_NO_MEMORY;
> +	vlan_elem->vlan = vfl->vlan_id[vlan_idx];
> +	vlan_elem->vsi_id = vfl->vsi_id;
> +	INIT_LIST_HEAD(&vlan_elem->list);
> +	vf->num_vlan++;
> +	list_add(&vlan_elem->list, &vf->vm_vlan_list);
> +	return 0;

Why not call i40e_vsi_add_vlan() here?

i40e_del_vmvlan_from_list() calls i40e_vsi_kill_vlan(), the functions
are not symmetric.

> +}
> +
> +/**
> + * i40e_del_vmvlan_from_list
> + * @vsi: pointer to the VSI structure
> + * @vf: pointer to the VF info
> + * @vlan: VLAN tag to be removed from the list
> + *
> + * delete VLAN tag from the VLAN list for VM
> + **/
> +static void i40e_del_vmvlan_from_list(struct i40e_vsi *vsi,
> +				      struct i40e_vf *vf, u16 vlan)
> +{
> +	struct i40e_vm_vlan *entry, *tmp;
> +
> +	list_for_each_entry_safe(entry, tmp, &vf->vm_vlan_list, list) {
> +		if (vlan == entry->vlan) {
> +			i40e_vsi_kill_vlan(vsi, vlan);
> +			vf->num_vlan--;
> +			list_del(&entry->list);
> +			kfree(entry);
> +			break;
> +		}
> +	}
> +}
> +
> +/**
> + * i40e_free_vmvlan_list
> + * @vsi: pointer to the VSI structure
> + * @vf: pointer to the VF info
> + *
> + * remove whole list of VLAN tags for VM
> + **/
> +static void i40e_free_vmvlan_list(struct i40e_vsi *vsi, struct i40e_vf *vf)
> +{
> +	struct i40e_vm_vlan *entry, *tmp;
> +
> +	if (list_empty(&vf->vm_vlan_list))
> +		return;
> +
> +	list_for_each_entry_safe(entry, tmp, &vf->vm_vlan_list, list) {
> +		if (vsi)

This function is only called with vsi = NULL AFAICT.

Please remove all dead code.

> +			i40e_vsi_kill_vlan(vsi, entry->vlan);
> +		list_del(&entry->list);
> +		kfree(entry);
> +	}
> +	vf->num_vlan = 0;
> +}
> +
>  /**
>   * i40e_free_vf_res
>   * @vf: pointer to the VF info


> @@ -2969,12 +3046,13 @@ static int i40e_vc_add_vlan_msg(struct i40e_vf *vf, u8 *msg)
>  	struct i40e_pf *pf = vf->pf;
>  	struct i40e_vsi *vsi = NULL;
>  	i40e_status aq_ret = 0;
> -	int i;
> +	u16 i;
>  
> -	if ((vf->num_vlan >= I40E_VC_MAX_VLAN_PER_VF) &&
> +	if ((vf->num_vlan + vfl->num_elements > I40E_VC_MAX_VLAN_PER_VF) &&
>  	    !test_bit(I40E_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps)) {
>  		dev_err(&pf->pdev->dev,
>  			"VF is not trusted, switch the VF to trusted to add more VLAN addresses\n");
> +		aq_ret = I40E_ERR_CONFIG;

seems unrelated

>  		goto error_param;
>  	}
>  	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
