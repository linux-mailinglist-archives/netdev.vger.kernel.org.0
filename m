Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9542AC981
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 00:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730734AbgKIXo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 18:44:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730180AbgKIXo6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 18:44:58 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BCCF206BE;
        Mon,  9 Nov 2020 23:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604965497;
        bh=q+Q5C3LOOUohAHuz+9+ERkhxjKYvOcSn+Co0anM60z8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VwH99c07l8ODLXMVwF59vg3yGrLW/NLqq6Fb8nxZntN7LGI+wGPAykbo6a62U6BPn
         nr8XgFQztP0PrzmA4OyDILS2KDxjw0WhbnNboxMYfTUesFxUxs3HpSRcwtWxPV3NNd
         I7X+P7MSJKftFQ44UW2yw3aXf1gQ37C5BFlWN15U=
Date:   Mon, 9 Nov 2020 15:44:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     Martin Willi <martin@strongswan.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] vrf: Fix fast path output packet handling with
 async Netfilter rules
Message-ID: <20201109154456.0d19e6c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201106073030.3974927-1-martin@strongswan.org>
References: <20201106073030.3974927-1-martin@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 08:30:30 +0100 Martin Willi wrote:
> VRF devices use an optimized direct path on output if a default qdisc
> is involved, calling Netfilter hooks directly. This path, however, does
> not consider Netfilter rules completing asynchronously, such as with
> NFQUEUE. The Netfilter okfn() is called for asynchronously accepted
> packets, but the VRF never passes that packet down the stack to send
> it out over the slave device. Using the slower redirect path for this
> seems not feasible, as we do not know beforehand if a Netfilter hook
> has asynchronously completing rules.
> 
> Fix the use of asynchronously completing Netfilter rules in OUTPUT and
> POSTROUTING by using a special completion function that additionally
> calls dst_output() to pass the packet down the stack. Also, slightly
> adjust the use of nf_reset_ct() so that is called in the asynchronous
> case, too.
> 
> Fixes: dcdd43c41e60 ("net: vrf: performance improvements for IPv4")
> Fixes: a9ec54d1b0cd ("net: vrf: performance improvements for IPv6")
> Signed-off-by: Martin Willi <martin@strongswan.org>

David, can we get an ack?
