Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D883EBEF3
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 02:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbhHNAVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 20:21:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235359AbhHNAVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 20:21:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A5C2610FD;
        Sat, 14 Aug 2021 00:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628900434;
        bh=hnk+ZN4VhqU929Ipn7RWIEWlm1/wl1UrEX+cJczdvfQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NIsXA1Pg1i9pUDajuZJDcXtN7g/9F4ZefGVScK2XI4xgeZsS/0jR+fCRjydi6B4uf
         hxOusQBBe0zNvUX8gubzImacH0OqpngZ/Kl+h4jJxlBFs8aSz9fYc10ivIpQs0DdEM
         yeqGL6kMUcCgGEwnsUbSMashBl9VKsBJYfRNUXF664v+V+U72ItmbsGl+o/bQC/kn9
         nCgcn1p2XMz+OLKDi57/cqBJCzFRKVbYLxFOrXlSGtNtGI3DsLR7b7j27Ad+GMjFac
         B2M/HhfXgYxBFGeJc39+tsxu/pYZsLDacn8aIjtzHeJhaEnC3/uN/aJziDnykTg9S2
         d8UWg9b2TAAHQ==
Date:   Fri, 13 Aug 2021 17:20:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Ken Cox <jkc@redhat.com>,
        netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: Re: [PATCH net 1/1] ixgbe: Add locking to prevent panic when
 setting sriov_numvfs to zero
Message-ID: <20210813172033.2c5c9101@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210812171856.1867667-1-anthony.l.nguyen@intel.com>
References: <20210812171856.1867667-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Aug 2021 10:18:56 -0700 Tony Nguyen wrote:
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
> index 214a38de3f41..0a1a8756f1fd 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
> @@ -206,8 +206,12 @@ int ixgbe_disable_sriov(struct ixgbe_adapter *adapter)
>  	unsigned int num_vfs = adapter->num_vfs, vf;
>  	int rss;
>  
> +	while (test_and_set_bit(__IXGBE_DISABLING_VFS, &adapter->state))
> +		usleep_range(1000, 2000);
> +
>  	/* set num VFs to 0 to prevent access to vfinfo */
>  	adapter->num_vfs = 0;
> +	clear_bit(__IXGBE_DISABLING_VFS, &adapter->state);
>  
>  	/* put the reference to all of the vf devices */
>  	for (vf = 0; vf < num_vfs; ++vf) {
> @@ -1307,6 +1311,9 @@ void ixgbe_msg_task(struct ixgbe_adapter *adapter)
>  	struct ixgbe_hw *hw = &adapter->hw;
>  	u32 vf;
>  
> +	if (test_and_set_bit(__IXGBE_DISABLING_VFS, &adapter->state))
> +		return;
> +
>  	for (vf = 0; vf < adapter->num_vfs; vf++) {
>  		/* process any reset requests */
>  		if (!ixgbe_check_for_rst(hw, vf))
> @@ -1320,6 +1327,7 @@ void ixgbe_msg_task(struct ixgbe_adapter *adapter)
>  		if (!ixgbe_check_for_ack(hw, vf))
>  			ixgbe_rcv_ack_from_vf(adapter, vf);
>  	}
> +	clear_bit(__IXGBE_DISABLING_VFS, &adapter->state);

Like I've already said two or three times. No flag based locking.
