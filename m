Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24AA46AF91
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbhLGBRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:17:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50848 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbhLGBRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:17:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FE8EB8164D
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 01:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89992C004DD;
        Tue,  7 Dec 2021 01:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638839646;
        bh=4nqdqLzwhhwdn/ctmdUn4lWjyicymIrwQj/UrheMHFo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j1KiI28La9BZ2LkmsvPTZbwp3o2TkQM/YYMb6SBzGhyx3iQyaQEsiEG5q70r8pkuX
         Q4b6pLR7ikIBz7wPMCpVlE3OXTZ10Js+irrnhWG11W6w7HZR2QVJAHPoD8PcH/2b6/
         ZNZfjDij+DJdO1lJ63I1/92hzd4CQZZ0N7PGX1l0/9D3eCUeZTRj5sQBZf6L7sL7Tj
         H2QYcQfeY/qeEDMY3Gdx/Sb3IAMu1rJoCzOqxZ6dykZ25eH3OjylHezApwVl14tkUF
         1/Zw7yPZ5AhpPbOy7aAPcwSwBxFPmcyQvy4IHK1MC5A9tCo/uxuBcoGPA7xomwqEhL
         pt8oNMiQIlqwg==
Date:   Mon, 6 Dec 2021 17:14:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        davem@davemloft.net, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: Re: [PATCH net-next 01/10] mptcp: add TCP_INQ cmsg support
Message-ID: <20211206171405.13e9f9ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211203223541.69364-2-mathew.j.martineau@linux.intel.com>
References: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
        <20211203223541.69364-2-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Dec 2021 14:35:32 -0800 Mat Martineau wrote:
> +static int mptcp_put_int_option(struct mptcp_sock *msk, char __user *optval,
> +				int __user *optlen, int val)
> +{
> +	int len;
> +
> +	if (get_user(len, optlen))
> +		return -EFAULT;
> +
> +	len = min_t(unsigned int, len, sizeof(int));
> +	if (len < 0)
> +		return -EINVAL;

TCP has the same statement but surely it's dead code?

min_t(unsigned, .., 4)

cannot return anything outside of the range from 0 to 4.

> +	if (put_user(len, optlen))
> +		return -EFAULT;
> +	if (copy_to_user(optval, &val, len))
> +		return -EFAULT;
> +
> +	return 0;
