Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E8329F7C4
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgJ2WWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgJ2WWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 18:22:09 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 299002075E;
        Thu, 29 Oct 2020 22:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604009471;
        bh=ls7VqWJzgUgR+UhG3V4b/WnmCQ9UBDegbAbXV8a5odI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B47WIO7qVw3bRN90S89hfKr8IeZcZz6p1n6NDNnqWSgoo5SoeOH+uQRHB00t5zirb
         Zkyktfrx6pvFj7byU/VchZeLxVXRbrK4oUkPtOOrk/Rn9fBhGOjYrGO3lsE0ATCFMZ
         UYgBxhHNFeK3XpPR8mEpRDLYCf4klD/3WgI44bFU=
Date:   Thu, 29 Oct 2020 15:11:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     jmaloy@redhat.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, maloy@donjonn.com, xinl@redhat.com,
        ying.xue@windriver.com, parthasarathy.bhuvaragan@gmail.com
Subject: Re: [net] tipc: add stricter control of reserved service types
Message-ID: <20201029151110.41fae663@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201028131912.3773561-1-jmaloy@redhat.com>
References: <20201028131912.3773561-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 09:19:12 -0400 jmaloy@redhat.com wrote:
> From: Jon Maloy <jmaloy@redhat.com>
> 
> TIPC reserves 64 service types for current and future internal use.
> Therefore, the bind() function is meant to block regular user sockets
> from being bound to these values, while it should let through such
> bindings from internal users.
> 
> However, since we at the design moment saw no way to distinguish
> between regular and internal users the filter function ended up
> with allowing all bindings of the reserved types which were really
> in use ([0,1]), and block all the rest ([2,63]).
> 
> This is risky, since a regular user may bind to the service type
> representing the topology server (TIPC_TOP_SRV == 1) or the one used
> for indicating neighboring node status (TIPC_CFG_SRV == 0), and wreak
> havoc for users of those services, i.e., most users.
> 
> The reality is however that TIPC_CFG_SRV never is bound through the
> bind() function, since it doesn't represent a regular socket, and
> TIPC_TOP_SRV can also be made to bypass the checks in tipc_bind()
> by introducing a different entry function, tipc_sk_bind().
> 
> It should be noted that although this is a change of the API semantics,
> there is no risk we will break any currently working applications by
> doing this. Any application trying to bind to the values in question
> would be badly broken from the outset, so there is no chance we would
> find any such applications in real-world production systems.

You say above that it would wreak havoc for most users, not all :)

I'd be more comfortable applying this to net-next, does that work for
you? 

Also perhaps we could add a pr_warn_once() if an application tried
using the reserved values, to help identify this change right away.

> Acked-by: Yung Xue <ying.xue@windriver.com>
> Signed-off-by: Jon Maloy <jmaloy@redhat.com>
