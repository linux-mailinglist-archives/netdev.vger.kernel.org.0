Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A96337F34
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhCKUno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:43:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229490AbhCKUnL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 15:43:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 844AF64F85;
        Thu, 11 Mar 2021 20:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615495390;
        bh=lACAyzgyWnB0qDdJmwRNuIg9HZ/bFs2tkjMU1/F663M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jygzY1rRtsVGwjNNJ8o9zfl+B5X/stcV78bX4sE+faSz2JjoSXOJ3oLk7wwA2OeAS
         sAIvIyainCGFTtRCs4yu4RBnIbZe471ktRhC+k+Tl3zVY/YGOObhY26RLhx09ZbU+8
         y2kpNk+J/GS/I0e4aYlU86gpoFILypwhTa+6K/sEavd526rPX7a+u/9FqoJi7SE1Tn
         cQhNPkn7M1fFaejJzxVWwKBIJevjmzdpNu1OdwHdppiAXmfITt4rj5kJvbRWxBoaJy
         bMPvrgkvC0zvqfCDh4TPsVV0F0GX44JTQ6G8MuBSbVka2p6T+Hz9fzGxRmJm7lxlWA
         J5oo+qUdLDCBQ==
Date:   Thu, 11 Mar 2021 12:43:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: lapbether: Prevent racing when checking
 whether the netif is running
Message-ID: <20210311124309.5ee0ef02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210311072311.2969-1-xie.he.0141@gmail.com>
References: <20210311072311.2969-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Mar 2021 23:23:09 -0800 Xie He wrote:
> There are two "netif_running" checks in this driver. One is in
> "lapbeth_xmit" and the other is in "lapbeth_rcv". They serve to make
> sure that the LAPB APIs called in these functions are called before
> "lapb_unregister" is called by the "ndo_stop" function.
> 
> However, these "netif_running" checks are unreliable, because it's
> possible that immediately after "netif_running" returns true, "ndo_stop"
> is called (which causes "lapb_unregister" to be called).
> 
> This patch adds locking to make sure "lapbeth_xmit" and "lapbeth_rcv" can
> reliably check and ensure the netif is running while doing their work.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Is this a theoretical issues or do you see a path where it triggers?

Who are the callers sending frames to a device which went down?
