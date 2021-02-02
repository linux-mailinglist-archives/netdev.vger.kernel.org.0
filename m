Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD55230B4BD
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 02:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhBBBex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 20:34:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhBBBem (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 20:34:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92F9764DD6;
        Tue,  2 Feb 2021 01:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612229641;
        bh=+r3UHx4Axi9AfKPNOu8Fb0UI++fCJmLsxFMaqsmyWis=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UxO26D1RH44SMnNhGXeZ567han+1Nc4a/UwX1i8qshHzGFgaCVIoPYnoCLkL0w7z9
         RrZqYqKA529+a9P42lMAXPjzHzWZ1EAbjjnOYjROKozQYUNazUHJ1yYTCx/l3MZlZt
         6/ogSGlrnfgTFehoRHePNIL1mHLvId/lFdymx5KXz9SNi1RIST8D7e6Ds4+clQE4k0
         Ld9/ZevUwOCo1B6Lu2gxx5u0mzs0e+gBccp/LxKHbkhThcjW+9Dvd6MLnsQh6RNwxd
         2uTlJSFftOCmcp5YKtJ0Q3DdL63J3Cen05Qx4zke8nCvm1rifrvlDOVqNmzFbbMNdp
         Ja41INryPG6Zg==
Date:   Mon, 1 Feb 2021 17:34:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH RESEND net-next] netlink: add tracepoint at
 NL_SET_ERR_MSG
Message-ID: <20210201173400.19f452d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fb6e25a4833e6a0e055633092b05bae3c6e1c0d3.1611934253.git.marcelo.leitner@gmail.com>
References: <fb6e25a4833e6a0e055633092b05bae3c6e1c0d3.1611934253.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  1 Feb 2021 15:12:19 -0300 Marcelo Ricardo Leitner wrote:
> Often userspace won't request the extack information, or they don't log it
> because of log level or so, and even when they do, sometimes it's not
> enough to know exactly what caused the error.
> 
> Netlink extack is the standard way of reporting erros with descriptive
> error messages. With a trace point on it, we then can know exactly where
> the error happened, regardless of userspace app. Also, we can even see if
> the err msg was overwritten.
> 
> The wrapper do_trace_netlink_extack() is because trace points shouldn't be
> called from .h files, as trace points are not that small, and the function
> call to do_trace_netlink_extack() on the macros is not protected by
> tracepoint_enabled() because the macros are called from modules, and this
> would require exporting some trace structs. As this is error path, it's
> better to export just the wrapper instead.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Did you measure the allyesconfig bloat from this?

How valuable is it to have the tracepoint in at the time it's set?
IIRC extack is passed in to the callbacks from the netlink core, it's
just not reported to user space if not requested. So we could capture
the message in af_netlink.c, no?
