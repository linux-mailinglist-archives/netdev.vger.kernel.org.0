Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5812861A7
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 16:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgJGO6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 10:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728637AbgJGO6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 10:58:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC175208C7;
        Wed,  7 Oct 2020 14:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602082689;
        bh=ttoWUFwHVHyUm2IiHU0uJpne+0dfPqCj8x3Qb36rnYc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QxOgLwChYgs+UzRJrJd7Ghs+bT5Qz42KDavabX8yIVHn3sPLEGtM/wcz6veIfqU8e
         6QhNT63LNIJ9aU5IBR3n4qB4jlDP1qhG/wb69REDYEPfazGjLjEBSWIAQPFJPNqTGp
         G55+HFOV+0ke/rRNyXz3Mius+dg6qMCKmoxGG05U=
Date:   Wed, 7 Oct 2020 07:58:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Message-ID: <20201007075807.4eb064c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007035502.3928521-3-liuhangbin@gmail.com>
References: <20201007035502.3928521-1-liuhangbin@gmail.com>
        <20201007035502.3928521-3-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 11:55:02 +0800 Hangbin Liu wrote:
> Based on RFC 8200, Section 4.5 Fragment Header:
> 
>   -  If the first fragment does not include all headers through an
>      Upper-Layer header, then that fragment should be discarded and
>      an ICMP Parameter Problem, Code 3, message should be sent to
>      the source of the fragment, with the Pointer field set to zero.
> 
> As the packet may be any kind of L4 protocol, I only checked if there
> has Upper-Layer header by pskb_may_pull(skb, offset + 1).
> 
> As the 1st truncated fragment may also be ICMP message, I also add
> a check in ICMP code is_ineligible() to let fragment packet with nexthdr
> ICMP but no ICMP header return false.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

net/ipv6/icmp.c:159:65: warning: incorrect type in argument 4 (different base types)
net/ipv6/icmp.c:159:65:    expected unsigned short *fragoff
net/ipv6/icmp.c:159:65:    got restricted __be16 *
