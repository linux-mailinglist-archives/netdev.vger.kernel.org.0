Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8696216B892
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 05:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgBYEne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 23:43:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728725AbgBYEne (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 23:43:34 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F0072467F;
        Tue, 25 Feb 2020 04:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582605813;
        bh=1VP7h5RXiBX/niAD2aBjvAoddyCRYHuw8utQ8nNFXdA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SD6fty5SyCkfGSomS+UWHwKHvlcnj6wceZzOPHQh6DujGzptu5xDDSewqOh73fuQR
         gDQuTrEjTaMe3mEMeBf3W6ozU1ZFx3ccIJPhapzDZrKPSbDctfkDIK2k4U2HZfjcc3
         /jWeL9/Nsd1IfqW3jEvXDffbPGfcX4Uhregcdofc=
Date:   Mon, 24 Feb 2020 20:43:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 10/10] selftests: netdevsim: Extend devlink
 trap test to include flow action cookie
Message-ID: <20200224204332.1e126fb4@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200224210758.18481-11-jiri@resnulli.us>
References: <20200224210758.18481-1-jiri@resnulli.us>
        <20200224210758.18481-11-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Feb 2020 22:07:58 +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Extend existing devlink trap test to include metadata type for flow
> action cookie.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  .../testing/selftests/drivers/net/netdevsim/devlink_trap.sh  | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
> index f101ab9441e2..437d32bd4cfd 100755
> --- a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
> +++ b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
> @@ -103,6 +103,11 @@ trap_metadata_test()
>  	for trap_name in $(devlink_traps_get); do
>  		devlink_trap_metadata_test $trap_name "input_port"
>  		check_err $? "Input port not reported as metadata of trap $trap_name"
> +		if [ $trap_name == "ingress_flow_action_drop" ] ||
> +		   [ $trap_name == "egress_flow_action_drop" ]; then
> +			devlink_trap_metadata_test $trap_name "flow_action_cookie"
> +			check_err $? "Flow action cookie not reported as metadata of trap $trap_name"
> +		fi
>  	done
>  
>  	log_test "Trap metadata"

Oh, this doesn't seem to check the contents of the trap at all, does it?
