Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8302153A10
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 22:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgBEVVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 16:21:51 -0500
Received: from www62.your-server.de ([213.133.104.62]:50658 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbgBEVVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 16:21:51 -0500
Received: from 33.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.33] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1izS7H-0007UK-RQ; Wed, 05 Feb 2020 22:21:47 +0100
Date:   Wed, 5 Feb 2020 22:21:47 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        maximmi@mellanox.com
Subject: Re: [PATCH bpf 0/3] XSK related fixes
Message-ID: <20200205212147.GA5358@pc-9.home>
References: <20200205045834.56795-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205045834.56795-1-maciej.fijalkowski@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25716/Tue Feb  4 12:35:33 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 05, 2020 at 05:58:31AM +0100, Maciej Fijalkowski wrote:
> Cameron reported [0] that on fresh bpf-next he could not run multiple
> xdpsock instances in Tx-only mode on single network interface with i40e
> driver.
> 
> Turns out that Maxim's series [1] which was adding RCU protection around
> ndo_xsk_wakeup added check against the __I40E_CONFIG_BUSY being set on
> pf->state within i40e_xsk_wakeup() - if it's set, return -ENETDOWN.
> Since this bit is set per PF when UMEM is being enabled/disabled, the
> situation Cameron stumbled upon was that when he launched second xdpsock
> instance, second UMEM was being registered, hence set __I40E_CONFIG_BUSY
> which is now observed by first xdpsock and therefore xdpsock's kick_tx()
> gets -ENETDOWN as errno.
> 
> -ENETDOWN currently is not allowed in kick_tx(), so we were exiting the
> first application. Such exit means also XDP program being unloaded and
> its dedicated resources, which caused an -ENXIO being return in the
> second xdpsock instance.
> 
> Let's fix the issue from both sides - protect ourselves from future
> xdpsock crashes by allowing for -ENETDOWN errno being set in kick_tx()
> (patch 3) and from driver side, return -EAGAIN for the case where PF is
> busy (patch 1).
> 
> Remove also doubled variable from xdpsock_user.c (patch 2).
> 
> Note that ixgbe seems not to be affected since UMEM registration sets
> the busy/disable bit per ring, not per PF.
> 
> Thanks!
> Maciej
> 
> [0]: https://www.spinics.net/lists/xdp-newbies/msg01558.html
> [1]: https://lore.kernel.org/netdev/20191217162023.16011-1-maximmi@mellanox.com/

Applied, thanks!
