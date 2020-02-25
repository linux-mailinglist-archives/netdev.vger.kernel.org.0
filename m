Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78F116ED3E
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 18:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbgBYR5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 12:57:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728483AbgBYR5X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 12:57:23 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E44C02084E;
        Tue, 25 Feb 2020 17:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582653443;
        bh=qyqYMvDx5GKxzCUrc/T70SpLbNyivOJG4XOA/FWZFxM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yd9Jo38aubMX5YvzdCvJW3stOnyKV6RP+vYTwqlbCGpngj2p5Zdk3IZSKhE4cCPdB
         MuI+R9X9sMTKzAq9Sksdw17v5DEDvPQRevUCuaojB7HNZxWJ0impUw++kdqRaWXBIV
         oSgROofcG8QhenfZGsvj5kTCNLkE4fW3BE01gFzo=
Date:   Tue, 25 Feb 2020 09:57:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 10/10] selftests: netdevsim: Extend devlink
 trap test to include flow action cookie
Message-ID: <20200225095721.657095ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200225074603.GC17869@nanopsycho>
References: <20200224210758.18481-1-jiri@resnulli.us>
        <20200224210758.18481-11-jiri@resnulli.us>
        <20200224204332.1e126fb4@cakuba.hsd1.ca.comcast.net>
        <20200225074603.GC17869@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Feb 2020 08:46:03 +0100 Jiri Pirko wrote:
> >>  		devlink_trap_metadata_test $trap_name "input_port"
> >>  		check_err $? "Input port not reported as metadata of trap $trap_name"
> >> +		if [ $trap_name == "ingress_flow_action_drop" ] ||
> >> +		   [ $trap_name == "egress_flow_action_drop" ]; then
> >> +			devlink_trap_metadata_test $trap_name "flow_action_cookie"
> >> +			check_err $? "Flow action cookie not reported as metadata of trap $trap_name"
> >> +		fi
> >>  	done
> >>  
> >>  	log_test "Trap metadata"  
> >
> >Oh, this doesn't seem to check the contents of the trap at all, does it?  
> 
> No. This is not the test for the actual trapped packets. It is a test to
> list devlink traps and supported metadata.
> 
> The packet trapping is done using dropmonitor which is currently
> not implemented in selftests, even for the existing traps. Not even for
> mlxsw. There is a plan to introduce these tests in the future, Ido is
> working on a tool to catch those packets to pcap using dropmon. I think
> he plans to send it to dropmon git soon. Then we can implement the
> selftests using it.

The extra 100 lines of code in netdevsim which is not used by selftests
does make me a little sad.. but okay, looking forward to fuller tests.
Those tests better make use of the variable cookie size, 'cause
otherwise we could have just stored the cookie on a u64 and avoided the
custom read/write functions all together ;)
