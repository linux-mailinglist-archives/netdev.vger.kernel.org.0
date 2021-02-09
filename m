Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A133153BB
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbhBIQYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:24:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:40176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231520AbhBIQYJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 11:24:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEBF364EB6;
        Tue,  9 Feb 2021 16:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612887808;
        bh=kJ09jRljv0w/tUNism8JLS1yx9JLCUZZB0DT4I100MQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nW8v7QEC2CkvAAYd3v8DZrPNS1aMargSfT+gdrVI6OrqbC8A8d6vGKtsdvJlFe9ZY
         cpZd4Rx0aQKF/H8bXnORI/YOx7M+C18g04ccB+WVmDpSqux3Nv/bCkBrtlXq7hMCLb
         kJ66JbFFHAMIaT+R9L8wF27aYtRHg9smujYf6kkHc+hrJnKvkuZFrq/YFSgSpoP2Nf
         qDIGOrCOWy8vaVH/wMbpzOhBFtktz43eMQQzsbO7++WfhRLTuh+zvTk8YlP4t5H4Ox
         WnXRzFhTv6JgSnO73DhMoMQOGQBYDeCjifaxbUw+AzBReio692lTIvbs346ctvVlgM
         Ja8eRFe8VOLkQ==
Date:   Tue, 9 Feb 2021 08:23:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Jian Yang <jianyang.kernel@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, Mahesh Bandewar <maheshb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: Re: [PATCH net-next v3] net-loopback: set lo dev initial state to
 UP
Message-ID: <20210209082326.44dc3269@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87czx978x8.fsf@nvidia.com>
References: <20210201233445.2044327-1-jianyang.kernel@gmail.com>
        <87czx978x8.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 12:54:59 +0100 Petr Machata wrote:
> Jian Yang <jianyang.kernel@gmail.com> writes:
> 
> > From: Jian Yang <jianyang@google.com>
> >
> > Traditionally loopback devices come up with initial state as DOWN for
> > any new network-namespace. This would mean that anyone needing this
> > device would have to bring this UP by issuing something like 'ip link
> > set lo up'. This can be avoided if the initial state is set as UP.  
> 
> This will break user scripts, and it fact breaks kernel's very own
> selftest. We currently have this internally:
> 
>     diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
>     index 4c7d33618437..bf8ed24ab3ba 100755
>     --- a/tools/testing/selftests/net/fib_nexthops.sh
>     +++ b/tools/testing/selftests/net/fib_nexthops.sh
>     @@ -121,8 +121,6 @@ create_ns()
>      	set -e
>      	ip netns add ${n}
>      	ip netns set ${n} $((nsid++))
>     -	ip -netns ${n} addr add 127.0.0.1/8 dev lo
>     -	ip -netns ${n} link set lo up
> 
>      	ip netns exec ${n} sysctl -qw net.ipv4.ip_forward=1
>      	ip netns exec ${n} sysctl -qw net.ipv4.fib_multipath_use_neigh=1
> 
> This now fails because the ip commands are run within a "set -e" block,
> and kernel rejects addition of a duplicate address.

Thanks for the report, could you send a revert with this explanation?
