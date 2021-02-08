Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06B7313FD4
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbhBHUCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:02:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:47982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236561AbhBHUB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 15:01:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FC7B64D5D;
        Mon,  8 Feb 2021 20:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612814477;
        bh=XhNjYYCo7WYGfY41pMEn02AL7gtZEm9Lj6jCNTAIbbo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jJg6h8mcLuN7qTXqtoYvkUteXrvEokzQAjhLElhqwiaMHilp6CT0UjXMQPT2/B5uB
         /XZmy95/KXhZcLbQcZ/y3XA8oIGSjr78sET8A/mcIzefTTauMzr06WmCp7apGD8g4p
         awGt8SSAsOsAn6eXwndC4sf0iYTHUZZEwWxdLpGMtM1bnk226uK6BgRwkKf/tQb/UC
         zfsfGG8XBeIwVbQhIEk+CAYOhp3qowPfzQNN5FwKz+U9ZnnmMfaLkH+pvDQANzJAWB
         wv/FyTzUsMFFwsgr008UDgJ+AXq/hcpTbkIYu1pmOQI1H24CvT1tWuexCzdItcLWb8
         iaMo76SEgRNYg==
Date:   Mon, 8 Feb 2021 12:01:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net] net: watchdog: hold device global xmit lock during
 tx disable
Message-ID: <20210208120115.0372cbd7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210206013732.508552-1-edwin.peer@broadcom.com>
References: <20210206013732.508552-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Feb 2021 17:37:32 -0800 Edwin Peer wrote:
> Prevent netif_tx_disable() running concurrently with dev_watchdog() by
> taking the device global xmit lock. Otherwise, the recommended:
> 
> 	netif_carrier_off(dev);
> 	netif_tx_disable(dev);
> 
> driver shutdown sequence can happen after the watchdog has already
> checked carrier, resulting in possible false alarms. This is because
> netif_tx_lock() only sets the frozen bit without maintaining the locks
> on the individual queues.
> 
> Fixes: c3f26a269c24 ("netdev: Fix lockdep warnings in multiqueue configurations.")
> Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Even though using the dev->tx_global_lock as a barrier is not very
clean in itself the thinking is that this restores previous semantics
with deeper changes.
