Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6643543BC70
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 23:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbhJZVfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 17:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239636AbhJZVfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 17:35:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18CF060E8B;
        Tue, 26 Oct 2021 21:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635283957;
        bh=U3geapfZ8QwodJou2ZK1pGaE5e01kelvbwb5khpj5/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bkQITLNeTf6rKzQkskzVQBfzksPC5ED+Fm4qcOPQMb5ds208spS8jyHfX2QvwJTv3
         1DWWW05XbDg9ADHqY/OijOb2HtWP81wzsT6J51u/w/F5mMoyOixZpdKrBZ8TbWbH9y
         bFHdoM6wngCQPvXpNOjUySiWEtPVznVIohwSQe6w8g4Hz3m2JyRMqGSfNrD5RqA0u8
         CIlK4oArOT8NulY4QAlGpLScvivAU4NLfKkbFQVUINYx6dp5jlWSaOmIjoKsAwOLSr
         jh8tRRp3JQO2z9tRvhLcjmOCTstHuy7MbAO/jayIlXGM8E8c/OZNuWBixxP4Oel5jU
         GjiJquTm7w/iw==
Date:   Tue, 26 Oct 2021 14:32:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        linux-kselftest@vger.kernel.org, idosch@idosch.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com
Subject: Re: [RFC v5 net-next 4/5] rtnetlink: Add support for SyncE
 recovered clock configuration
Message-ID: <20211026143236.050af4e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211026173146.1031412-5-maciej.machnikowski@intel.com>
References: <20211026173146.1031412-1-maciej.machnikowski@intel.com>
        <20211026173146.1031412-5-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please add a write up of how things fit together in Documentation/.
I'm sure reviewers and future users will appreciate that.

Some nits below.

On Tue, 26 Oct 2021 19:31:45 +0200 Maciej Machnikowski wrote:
> Add support for RTNL messages for reading/configuring SyncE recovered
> clocks.
> The messages are:
> RTM_GETRCLKRANGE: Reads the allowed pin index range for the recovered
> 		  clock outputs. This can be aligned to PHY outputs or
> 		  to EEC inputs, whichever is better for a given
> 		  application
> 
> RTM_GETRCLKSTATE: Read the state of recovered pins that output recovered
> 		  clock from a given port. The message will contain the
> 		  number of assigned clocks (IFLA_RCLK_STATE_COUNT) and
> 		  a N pin inexes in IFLA_RCLK_STATE_OUT_IDX

Do we need two separate calls for the gets?

> RTM_SETRCLKSTATE: Sets the redirection of the recovered clock for
> 		  a given pin


> +struct if_set_rclk_msg {
> +	__u32 ifindex;
> +	__u32 out_idx;
> +	__u32 flags;

Why not break this out into separate attrs?

> +++ b/net/core/rtnetlink.c
> @@ -5524,8 +5524,10 @@ static int rtnl_eec_state_get(struct sk_buff *skb, struct nlmsghdr *nlh,
>  
>  	state = nlmsg_data(nlh);
>  	dev = __dev_get_by_index(net, state->ifindex);
> -	if (!dev)
> +	if (!dev) {
> +		NL_SET_ERR_MSG(extack, "unknown ifindex");
>  		return -ENODEV;
> +	}
>  
>  	nskb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>  	if (!nskb)

Belongs in previous patch?
