Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3869169B38
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 01:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgBXAdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 19:33:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58010 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgBXAdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 19:33:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 78C6F158DAD43;
        Sun, 23 Feb 2020 16:33:03 -0800 (PST)
Date:   Sun, 23 Feb 2020 16:33:02 -0800 (PST)
Message-Id: <20200223.163302.12435682075168491.davem@davemloft.net>
To:     haiyangz@microsoft.com
Cc:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [net PATCH] hv_netvsc: Fix unwanted wakeup in netvsc_attach()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1582302738-24352-1-git-send-email-haiyangz@microsoft.com>
References: <1582302738-24352-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Feb 2020 16:33:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Fri, 21 Feb 2020 08:32:18 -0800

> When netvsc_attach() is called by operations like changing MTU, etc.,
> an extra wakeup may happen while netvsc_attach() calling
> rndis_filter_device_add() which sends rndis messages when queue is
> stopped in netvsc_detach(). The completion message will wake up queue 0.
> 
> We can reproduce the issue by changing MTU etc., then the wake_queue
> counter from "ethtool -S" will increase beyond stop_queue counter:
>      stop_queue: 0
>      wake_queue: 1
> The issue causes queue wake up, and counter increment, no other ill
> effects in current code. So we didn't see any network problem for now.
> 
> To fix this, initialize tx_disable to true, and set it to false when
> the NIC is ready to be attached or registered.
> 
> Fixes: 7b2ee50c0cd5 ("hv_netvsc: common detach logic")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Applied, thank you.
