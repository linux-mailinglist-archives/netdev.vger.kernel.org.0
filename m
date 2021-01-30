Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1692E309261
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 06:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbhA3F7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 00:59:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233882AbhA3FzA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 00:55:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 338DF64DDC;
        Sat, 30 Jan 2021 05:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611986041;
        bh=d98GNTCskgXAbxdml0a/NaE8WH5Ub1tdcQ2oyLR8F9s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WmTx2MBqk/YO4wcyYX94muk7cV1fMRu80Q6xuk1aPnkJAS9DtQlItgpErCuTg/5mq
         LlW2biiIrBeKFyA/Bgn90WacMHgihHN7jG824NxJHmvgPy8qMxlG/XCRhshnUxBybg
         JpUMfsDm87kZoxDZ+TzEK8atsdiuqjfC3zKOKIWwmYff3S1d8JG6qLcYjc5nr5Npfq
         b5rETVz3ifOa1y6piFedoqY6v5vmzIT1EFqgbnsSx2I9J0TZLdVmlae2SMMIYKmTwI
         zh92tAv2pHBg7NV9jc2AhbIKWpdYPpaWjmzCn27pE3rjJF0gkJuTL9e5HVajv5buRJ
         QEma3oHugAPww==
Date:   Fri, 29 Jan 2021 21:54:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, Geliang Tang <geliangtang@gmail.com>,
        davem@davemloft.net, mptcp@lists.01.org
Subject: Re: [PATCH net-next 01/16] mptcp: use WRITE_ONCE/READ_ONCE for the
 pernet *_max
Message-ID: <20210129215400.500b63ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129011115.133953-2-mathew.j.martineau@linux.intel.com>
References: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
        <20210129011115.133953-2-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 17:11:00 -0800 Mat Martineau wrote:
> +	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL) {
> +		addr_max = READ_ONCE(pernet->add_addr_signal_max);
> +		WRITE_ONCE(pernet->add_addr_signal_max, addr_max + 1);
> +	}

This is an odd construct.

READ_ONCE() is used when the value can change underneath the reader,
not in writers. If we want to increment a variable, there must either
be a writer side lock, or the variable has to be switched to atomic_t.

I'm guessing the former is the case here, so there can be no concurrent
writers. Please omit the READ_ONCE():

	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL)
		WRITE_ONCE(pernet->add_addr_signal_max, 
			   pernet->add_addr_signal_max + 1);


Same for other 3 cases.
