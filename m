Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDCA9425503
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 16:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241949AbhJGOJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 10:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240542AbhJGOJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 10:09:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 631D661040;
        Thu,  7 Oct 2021 14:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633615641;
        bh=dnoqmxyqmfIjs/xjwJbYc3OQ/vTLeq0s5NawMiNI3Hw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Le6WfdH4aaiINli/Gl59K/4lVSUFf3DI99mO570dSVbVMrUh6i83x4UbdgGKqrh5W
         QG+J+Go5xTGUTughIMsKkDzlDHAv1310ixrgAEn/9j9Pl40CHBGVGkbAz3T0OPxEUd
         gEJ0i1L0Hz/Q2oJueiYM4CI5cKQ87FvacobPSPgLY2OF414IaBaER0CABRehaO0ZwB
         A7deW0ek/GFtYQGvtbq3zFeiB81JwT47DNC+Q2fjhBvr6QdRr1cr87xlgR9bVyVpDh
         wSs1sfChumZbJzdn7VNOK557lNVeLF+6arQ5qNPJ8MqLKOgBkU0L8gYa1bhL3uIij/
         h9So/Y3+Qlr5A==
Date:   Thu, 7 Oct 2021 07:07:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Mike Manning <mvrmanning@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Saikrishna Arcot <sarcot@microsoft.com>
Subject: Re: [PATCH] net: prefer socket bound to interface when not in VRF
Message-ID: <20211007070720.31dd17bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cf0a8523-b362-1edf-ee78-eef63cbbb428@gmail.com>
References: <cf0a8523-b362-1edf-ee78-eef63cbbb428@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 14:03:42 +0100 Mike Manning wrote:
> The commit 6da5b0f027a8 ("net: ensure unbound datagram socket to be
> chosen when not in a VRF") modified compute_score() so that a device
> match is always made, not just in the case of an l3mdev skb, then
> increments the score also for unbound sockets. This ensures that
> sockets bound to an l3mdev are never selected when not in a VRF.
> But as unbound and bound sockets are now scored equally, this results
> in the last opened socket being selected if there are matches in the
> default VRF for an unbound socket and a socket bound to a dev that is
> not an l3mdev. However, handling prior to this commit was to always
> select the bound socket in this case. Reinstate this handling by
> incrementing the score only for bound sockets. The required isolation
> due to choosing between an unbound socket and a socket bound to an
> l3mdev remains in place due to the device match always being made.
> The same approach is taken for compute_score() for stream sockets.
> 
> Fixes: 6da5b0f027a8 ("net: ensure unbound datagram socket to be chosen when not in a VRF")
> Fixes: e78190581aff ("net: ensure unbound stream socket to be chosen when not in a VRF")
> Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>

David A, Ack?
