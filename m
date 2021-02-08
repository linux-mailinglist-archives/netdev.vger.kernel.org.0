Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7963031419B
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 22:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbhBHVWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 16:22:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236342AbhBHVV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 16:21:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CF8A64EA4;
        Mon,  8 Feb 2021 21:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612819275;
        bh=CjLfdvjLjHY7owX0cES0KM8fOb4ZbrdpwB0cnsllKXA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pCepOw++zJEKZPq4WKtPU+Jiqf1147eq3ryim/U3MFNkPY8Ovcl5Eoci3fIlAvqx4
         NX9UiFAQ4CKRTEjJ05Kbces/efOAe+2rDmg+X14Q/jC7NzVDesUgF6O2bSifvTIUED
         bqd2HK/Om6wv5ddLTlBKxBC7U2h1HMFShgCF/bqOLCf2H7TrKrFvcke2eo6HxdEdx8
         j+BV80HEpyBJC9Z0y4ywuerBbcu4KbwTiKWYYBAMa87lv6UsMlk4xi9RtgOIxIQEyY
         qspcyxNWimYXXyFOhKzKqyEPh/4cg1kog3vPRjNmKBxdimDXhKu5sZprG6j46KBFGh
         b0m8gTzEiaU6A==
Date:   Mon, 8 Feb 2021 13:21:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 7/7] netdevsim: Add netdevsim port add test
 cases
Message-ID: <20210208132113.128b3116@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210207084412.252259-8-parav@nvidia.com>
References: <20210206125551.8616-1-parav@nvidia.com>
        <20210207084412.252259-1-parav@nvidia.com>
        <20210207084412.252259-8-parav@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 7 Feb 2021 10:44:12 +0200 Parav Pandit wrote:
> +	RET=0
> +	USR_PF_PORT_INDEX=600
> +	USR_PFNUM_A=2
> +	USR_PFNUM_B=3
> +	USR_SF_PORT_INDEX=601
> +	USR_SFNUM_A=44
> +	USR_SFNUM_B=55
> +
> +	devlink port add $DL_HANDLE flavour pcipf pfnum $USR_PFNUM_A
> +	check_err $? "Failed PF port addition"
> +
> +	devlink port show
> +	check_err $? "Failed PF port show"
> +
> +	devlink port add $DL_HANDLE flavour pcisf pfnum $USR_PFNUM_A
> +	check_err $? "Failed SF port addition"
> +
> +	devlink port add $DL_HANDLE flavour pcisf pfnum $USR_PFNUM_A \
> +			sfnum $USR_SFNUM_A
> +	check_err $? "Failed SF port addition"
> +
> +	devlink port add $DL_HANDLE flavour pcipf pfnum $USR_PFNUM_B
> +	check_err $? "Failed second PF port addition"
> +
> +	devlink port add $DL_HANDLE/$USR_SF_PORT_INDEX flavour pcisf \
> +			pfnum $USR_PFNUM_B sfnum $USR_SFNUM_B
> +	check_err $? "Failed SF port addition"
> +
> +	devlink port show
> +	check_err $? "Failed PF port show"
> +
> +	state=$(function_state_get "state")
> +	check_err $? "Failed to get function state"
> +	[ "$state" == "inactive" ]
> +	check_err $? "Unexpected function state $state"
> +
> +	state=$(function_state_get "opstate")
> +	check_err $? "Failed to get operational state"
> +	[ "$state" == "detached" ]
> +	check_err $? "Unexpected function opstate $opstate"
> +
> +	devlink port function set $DL_HANDLE/$USR_SF_PORT_INDEX state active
> +	check_err $? "Failed to set state"
> +
> +	state=$(function_state_get "state")
> +	check_err $? "Failed to get function state"
> +	[ "$state" == "active" ]
> +	check_err $? "Unexpected function state $state"
> +
> +	state=$(function_state_get "opstate")
> +	check_err $? "Failed to get operational state"
> +	[ "$state" == "attached" ]
> +	check_err $? "Unexpected function opstate $opstate"
> +
> +	devlink port del $DL_HANDLE/$USR_SF_PORT_INDEX
> +	check_err $? "Failed SF port deletion"
> +
> +	log_test "port_add test"

I don't think this very basic test is worth the 600 LoC of netdevsim
code.

If you come up with something better please don't post v3 it in reply 
to previous threads.
