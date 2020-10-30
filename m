Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8B22A094F
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 16:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgJ3PLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 11:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgJ3PLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 11:11:07 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AB5B20728;
        Fri, 30 Oct 2020 15:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604070666;
        bh=4O5gg/Tc6EZeLgVfjjEgjWW0bwV09Nf/kFGjo6+yc6M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H5tfwv6eD//N1e/nQU0pbXpS4giJnTSseFuGcjNVzh1b9ZxcWaSl9FuVgDlQA7F+3
         4DiHKpdLlp9b5RhrTX1h4rxPcP+muqbt1PdWKK+JceL36ec0zc5o0u4utJ/G5ILx0x
         byq5bJoqKwRGA0ZcBU1XIcGuIC0wgv+70NtBjYO0=
Date:   Fri, 30 Oct 2020 08:11:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Ovechkin <ovov@yandex-team.ru>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] ip6_tunnel: set inner ipproto before
 ip6_tnl_encap
Message-ID: <20201030081105.16623cc3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201029171012.20904-1-ovov@yandex-team.ru>
References: <20201029171012.20904-1-ovov@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 20:10:12 +0300 Alexander Ovechkin wrote:
> ip6_tnl_encap assigns to proto transport protocol which
> encapsulates inner packet, but we must pass to set_inner_ipproto
> protocol of that inner packet.
> 
> Calling set_inner_ipproto after ip6_tnl_encap might break gso.
> For example, in case of encapsulating ipv6 packet in fou6 packet, inner_ipproto 
> would be set to IPPROTO_UDP instead of IPPROTO_IPV6. This would lead to
> incorrect calling sequence of gso functions:
> ipv6_gso_segment -> udp6_ufo_fragment -> skb_udp_tunnel_segment -> udp6_ufo_fragment
> instead of:
> ipv6_gso_segment -> udp6_ufo_fragment -> skb_udp_tunnel_segment -> ip6ip6_gso_segment
> 
> Fixes: 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support")
> Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>

Applied, thanks!
