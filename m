Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462CC2AE614
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732420AbgKKBzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:55:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731610AbgKKBzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 20:55:10 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43153216C4;
        Wed, 11 Nov 2020 01:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605059710;
        bh=rGuo9pnD5AykSsVJ3UjlMpX+Fn7ArJ5Chrp3fxR5BXI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QSx7r83VZBSTG/98hQ84+zS4souxCXo0IlGeYM5X2R0h23cIlHrchHdUU0qtWU842
         OBq7NcJwca6Y2H2Pxffls409B2gb1hVoKnYKme0Ru3vZTjNlMllzSq8jf/lzVPf7et
         ygrPocA/I/xdFSo7wn3ALC+3hEns8ZchjLLS5e/8=
Date:   Tue, 10 Nov 2020 17:55:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v1] lan743x: fix "BUG: invalid wait context" when
 setting rx mode
Message-ID: <20201110175509.11a6d549@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109203828.5115-1-TheSven73@gmail.com>
References: <20201109203828.5115-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 15:38:28 -0500 Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> In the net core, the struct net_device_ops -> ndo_set_rx_mode()
> callback is called with the dev->addr_list_lock spinlock held.
> 
> However, this driver's ndo_set_rx_mode callback eventually calls
> lan743x_dp_write(), which acquires a mutex. Mutex acquisition
> may sleep, and this is not allowed when holding a spinlock.
> 
> Fix by removing the dp_lock mutex entirely. Its purpose is to
> prevent concurrent accesses to the data port. No concurrent
> accesses are possible, because the dev->addr_list_lock
> spinlock in the core only lets through one thread at a time.

Please remember about fixes tags, I've added:

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")

here. No idea what this lock was trying to protect from the start.

Applied, thanks!
