Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D3446AFC7
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhLGBeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:34:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58760 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbhLGBd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:33:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97022B81611
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 01:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A2BC004DD;
        Tue,  7 Dec 2021 01:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638840625;
        bh=76k2ErIpi9CvNDjJGX8NO9oepIptCo8cZX0EpIr+Xc8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XjjNagDjGk+u1AX2VxFNK+czs+FtDX6XoyMzeBbfEk6Ki5I1PSmZtXShuTzI4gj6M
         sp1c8GPK6yQPLGncEQSl8LMfKYOeU2q7QN0unP6XXOUG/2gdMKUJZISocagJlsiRYY
         rJ72kumk3Pv1MN8WSrWd6vdLwfx5TjpkSdt4y2aghIEiph1rlvJSNWg1myrfCxO5eG
         ZsF21EHPLCKYV2zCFgqA6cakclLg0eT+KqvfDaQQWmG1C81Ojnhv/bvgyCfJtN/nFz
         XCgJgr3f21fk9k/SgX1CU78aJnNxSKlNJcCblzKf6jzHbSitkQ9w/GbHkxThYK87u+
         2ofiQi/q7YuNw==
Date:   Mon, 6 Dec 2021 17:30:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, Maxim Galaganov <max@internet.ru>,
        davem@davemloft.net, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 10/10] mptcp: support TCP_CORK and TCP_NODELAY
Message-ID: <20211206173023.72aca8f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211203223541.69364-11-mathew.j.martineau@linux.intel.com>
References: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
        <20211203223541.69364-11-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Dec 2021 14:35:41 -0800 Mat Martineau wrote:
> +static int mptcp_setsockopt_sol_tcp_nodelay(struct mptcp_sock *msk, sockptr_t optval,
> +					    unsigned int optlen)
> +{
> +	struct mptcp_subflow_context *subflow;
> +	struct sock *sk = (struct sock *)msk;
> +	int val;
> +
> +	if (optlen < sizeof(int))
> +		return -EINVAL;
> +
> +	if (copy_from_sockptr(&val, optval, sizeof(val)))
> +		return -EFAULT;

Should we check that optval is not larger than sizeof(int) or if it is
that the rest of the buffer is zero? Or for the old school options we
should stick to the old school behavior?
