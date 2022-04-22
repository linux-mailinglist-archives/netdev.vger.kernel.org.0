Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96EBB50C489
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbiDVXPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiDVXOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:14:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D6E18E1BD
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 15:47:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C85960F16
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 22:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1016BC385A4;
        Fri, 22 Apr 2022 22:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650667674;
        bh=CsL1ha6f0eJZW7cIi2/2P2urwspvEBMalVE9j2+eixo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fQIZ3weq9HTT5SJuIk2DMlTM88JMjKEvxkldM7dbikd/q9n2BnptpKg227XNjTBJ0
         vjDOgFxL2ym2QiBV1p1d3aKETMNqTUgcV9MOWg/qgfKJPXD+k/qU74DKi0adGdjPle
         wF6+zKcb/9cTVUQhSzOoZ3HSG1Ps9MvvwdCrZjyMn8fYj5C9rzVbz2QO6sazz8+BaK
         dBFx2iuNVQU13mrX57GzyzbZEcees2LOW1S0rOZUcEB2sXa44xQqJy03ZjeXzTy0nr
         0RWZJHcgqsW0xyhwHKeZuM8iBxZZH942GW7Vt7Om3tdl/vSfW9A+xS9k6YTjGP61Z9
         tz6PbSoiM5i5Q==
Date:   Fri, 22 Apr 2022 15:47:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com,
        Michal Maloszewski <michal.maloszewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net 1/2] iavf: Fix error when changing ring parameters
 on ice PF
Message-ID: <20220422154752.1fab6496@kernel.org>
In-Reply-To: <20220420172624.931237-2-anthony.l.nguyen@intel.com>
References: <20220420172624.931237-1-anthony.l.nguyen@intel.com>
        <20220420172624.931237-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Apr 2022 10:26:23 -0700 Tony Nguyen wrote:
> From: Michal Maloszewski <michal.maloszewski@intel.com>
> 
> Reset is triggered when ring parameters are being changed through
> ethtool and queues are reconfigured for VF's VSI. If ring is changed
> again immediately, then the next reset could be executed before
> queues could be properly reinitialized on VF's VSI. It caused ice PF
> to mess up the VSI resource tree.
> 
> Add a check in iavf_set_ringparam for adapter and VF's queue
> state. If VF is currently resetting or queues are disabled for the VF
> return with EAGAIN error.

Can't we wait for the device to get into the right state?
Throwing EAGAIN back to user space is not very friendly.

> diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> index 3bb56714beb0..08efbc50fbe9 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> @@ -631,6 +631,11 @@ static int iavf_set_ringparam(struct net_device *netdev,
>  	if ((ring->rx_mini_pending) || (ring->rx_jumbo_pending))
>  		return -EINVAL;
>  
> +	if (adapter->state == __IAVF_RESETTING ||
> +	    (adapter->state == __IAVF_RUNNING &&
> +	     (adapter->flags & IAVF_FLAG_QUEUES_DISABLED)))
> +		return -EAGAIN;

nit: why add this check in the middle of input validation 
(i.e. checking the ring params are supported)?

>  	if (ring->tx_pending > IAVF_MAX_TXD ||
>  	    ring->tx_pending < IAVF_MIN_TXD ||
>  	    ring->rx_pending > IAVF_MAX_RXD ||
