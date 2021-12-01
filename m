Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F8C4644C2
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 03:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345816AbhLACME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 21:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhLACMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 21:12:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05D4C061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 18:08:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4DA2B81C3E
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 02:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331B7C53FCB;
        Wed,  1 Dec 2021 02:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638324521;
        bh=PlK8M0ATr1vCP29y4xkVGBUPLKqmpAgulN4hFgPIr/Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OVXHMKj3jzmqFtIfocTMAp1viXDJxmoOxouT01OSWLCd4pGPufDO6B/YfYDNE2MRG
         Rkrbu7taQ0LqGxUl70KGpyPM5COkbJHbBj5BPJyFiAw/3HcmLc/GRV0UlWrxYmai4Q
         I/MmlDiYPL3uMgC45DkU+AVe2EZsyG6U6RpFZoH9ekC3snKoA0RNckxWcKEiV6kNtk
         G6KWFqgu1+mPrsnr40fSOEtr94suaUzbRDOcTVEGDO4TqRxN5T+MUl66Lnb1eK9H+Q
         R+z5in6b0C3jyq4QErIH12G724z7Nf5zwhsTPHLXF+uconjD10li9bfhH76MMGjuRf
         ths6tqkXdIKPg==
Date:   Tue, 30 Nov 2021 18:08:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, alexander.duyck@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net-sysfs: update the queue counts in the
 unregistration path
Message-ID: <20211130180839.285e31be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211129154520.295823-1-atenart@kernel.org>
References: <20211129154520.295823-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Nov 2021 16:45:20 +0100 Antoine Tenart wrote:
> When updating Rx and Tx queue kobjects, the queue count should always be
> updated to match the queue kobjects count. This was not done in the net
> device unregistration path and due to the Tx queue logic allowing
> updates when unregistering (for qdisc cleanup) it was possible with
> ethtool to manually add new queues after unregister, leading to NULL
> pointer exceptions and UaFs, such as:
> 
>   BUG: KASAN: use-after-free in kobject_get+0x14/0x90
>   Read of size 1 at addr ffff88801961248c by task ethtool/755
> 
>   CPU: 0 PID: 755 Comm: ethtool Not tainted 5.15.0-rc6+ #778
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/014
>   Call Trace:
>    dump_stack_lvl+0x57/0x72
>    print_address_description.constprop.0+0x1f/0x140
>    kasan_report.cold+0x7f/0x11b
>    kobject_get+0x14/0x90
>    kobject_add_internal+0x3d1/0x450
>    kobject_init_and_add+0xba/0xf0
>    netdev_queue_update_kobjects+0xcf/0x200
>    netif_set_real_num_tx_queues+0xb4/0x310
>    veth_set_channels+0x1c3/0x550
>    ethnl_set_channels+0x524/0x610
> 
> Updating the queue counts in the unregistration path solve the above
> issue, as the ethtool path updating the queue counts makes sanity checks
> and a queue count of 0 should prevent any update.

Would you mind pointing where in the code that happens? I can't seem 
to find anything looking at real_num_.x_queues outside dev.c and
net-sysfs.c :S

> Fixes: 5c56580b74e5 ("net: Adjust TX queue kobjects if number of queues changes during unregister")
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
> Following a previous thread[1] I had another look at this issue and now
> have a better fix (this patch). In this previous thread we also
> discussed preventing ethtool operations after unregister and adding a
> warning in netdev_queue_update_kobjects; I'll send two patches for this
> but targetting net-next.
