Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6809A3F3634
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 23:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhHTV5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 17:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229760AbhHTV5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 17:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E299961165;
        Fri, 20 Aug 2021 21:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629496595;
        bh=H8F7zEjPQ5MdS7CKuOcQIJBhuhLnC7/yuq6MOfh72TE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X3aWgJ+FgJA2fZ1l+Msa+FUZkOe7TeOzZmyYdwggjcbE3o7x+FRfLFUUECZJJzjUT
         Vzsd5g6ebPmGH9vLnNMAdkD5fCHuvErNylgc8UHSBUBAps8fthL1qlI3tNC2xehnya
         TUW0s1hUed6UgD9Ztsfq0bBJQwjs1voEDS1a3TF6bepsXWpmsmA7vgwwJAkhqC5C/E
         i52x79IYulyU0pB5UoCFhgIK7GF1rYq/EpZZHbxQv8WGsSQs/Ttlbj2vjZFhBaSTnf
         Up6PyF5SPhEDc8qg01qKGz+1iENAnwtV3CZ5xMJ3Dr6vaTXPtgZFvYQnq/Ou15WtAa
         awhxKHeDV/Kkw==
Date:   Fri, 20 Aug 2021 14:56:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Aaron Ma <aaron.ma@canonical.com>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net 1/4] igc: fix page fault when thunderbolt is
 unplugged
Message-ID: <20210820145634.044fed9f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210820155915.1119889-2-anthony.l.nguyen@intel.com>
References: <20210820155915.1119889-1-anthony.l.nguyen@intel.com>
        <20210820155915.1119889-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Aug 2021 08:59:12 -0700 Tony Nguyen wrote:
> From: Aaron Ma <aaron.ma@canonical.com>
> 
> After unplug thunderbolt dock with i225, pciehp interrupt is triggered,
> remove call will read/write mmio address which is already disconnected,
> then cause page fault and make system hang.
> 
> Check PCI state to remove device safely.
> 
> Trace:
> BUG: unable to handle page fault for address: 000000000000b604
> Oops: 0000 [#1] SMP NOPTI
> RIP: 0010:igc_rd32+0x1c/0x90 [igc]
> Call Trace:
> igc_ptp_suspend+0x6c/0xa0 [igc]
> igc_ptp_stop+0x12/0x50 [igc]
> igc_remove+0x7f/0x1c0 [igc]
> pci_device_remove+0x3e/0xb0
> __device_release_driver+0x181/0x240
> 
> Fixes: 13b5b7fd6a4a ("igc: Add support for Tx/Rx rings")
> Fixes: b03c49cde61f ("igc: Save PTP time before a reset")

Seems like a whack-a-mole that should be addressed a little bit more
systematically. Why not return ~0 if hw_addr is NULL? That's what would
happen first time timeout is hit, right? Please consider this.

Pulled, thanks!
