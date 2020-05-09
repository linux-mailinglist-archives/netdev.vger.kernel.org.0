Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6707D1CBDF7
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 07:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgEIF5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 01:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgEIF5G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 01:57:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB94521582;
        Sat,  9 May 2020 05:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589003826;
        bh=ISc8bGy7yBICO1h3slM7QebMq5NKve758qzwmXPLuyA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JkWBYxwAaXAoo7yqlxjXhok/SauHRHC80crfJhhcGQlX0TP01RtK/ZvqamBZppFbJ
         IY3nVlquGkFgQHKhzuLRnPHXQeKYDyan6azu1xY8K4UkkL+2OGlpuz/1EcKAncxk+q
         cqg6Qg0Dvan4nnqy45DWmTtQILEdJ+8nrNTo6RHQ=
Date:   Fri, 8 May 2020 22:57:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Colin Walters <walters@redhat.com>
Subject: Re: [PATCH net] net: ipv4: really enforce backoff for redirects
Message-ID: <20200508225704.40f53162@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7f71c9a7ba0d514c9f2d006f4797b044c824ae84.1588954755.git.pabeni@redhat.com>
References: <7f71c9a7ba0d514c9f2d006f4797b044c824ae84.1588954755.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 May 2020 19:28:34 +0200 Paolo Abeni wrote:
> In commit b406472b5ad7 ("net: ipv4: avoid mixed n_redirects and
> rate_tokens usage") I missed the fact that a 0 'rate_tokens' will
> bypass the backoff algorithm.
> 
> Since rate_tokens is cleared after a redirect silence, and never
> incremented on redirects, if the host keeps receiving packets
> requiring redirect it will reply ignoring the backoff.
> 
> Additionally, the 'rate_last' field will be updated with the
> cadence of the ingress packet requiring redirect. If that rate is
> high enough, that will prevent the host from generating any
> other kind of ICMP messages
> 
> The check for a zero 'rate_tokens' value was likely a shortcut
> to avoid the more complex backoff algorithm after a redirect
> silence period. Address the issue checking for 'n_redirects'
> instead, which is incremented on successful redirect, and
> does not interfere with other ICMP replies.
> 
> Fixes: b406472b5ad7 ("net: ipv4: avoid mixed n_redirects and rate_tokens usage")

Looks like this one got backported all the way back to 3.16..

> Reported-and-tested-by: Colin Walters <walters@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thanks!
