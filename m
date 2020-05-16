Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202AD1D6006
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 11:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgEPJdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 05:33:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:45870 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbgEPJdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 May 2020 05:33:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 93D5EB0F2;
        Sat, 16 May 2020 09:33:21 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 6A32660347; Sat, 16 May 2020 11:33:17 +0200 (CEST)
Date:   Sat, 16 May 2020 11:33:17 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        vladimir.oltean@nxp.com, po.liu@nxp.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
Message-ID: <20200516093317.GJ21714@lion.mk-sys.cz>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516012948.3173993-1-vinicius.gomes@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 06:29:44PM -0700, Vinicius Costa Gomes wrote:
> Hi,
> 
> This series adds support for configuring frame preemption, as defined
> by IEEE 802.1Q-2018 (previously IEEE 802.1Qbu) and IEEE 802.3br.
> 
> Frame preemption allows a packet from a higher priority queue marked
> as "express" to preempt a packet from lower priority queue marked as
> "preemptible". The idea is that this can help reduce the latency for
> higher priority traffic.
> 
> Previously, the proposed interface for configuring these features was
> using the qdisc layer. But as this is very hardware dependent and all
> that qdisc did was pass the information to the driver, it makes sense
> to have this in ethtool.
> 
> One example, for retrieving and setting the configuration:
> 
> $ ethtool $ sudo ./ethtool --show-frame-preemption enp3s0
> Frame preemption settings for enp3s0:
> 	support: supported

IMHO we don't need a special bool for this. IIUC this is not a state
flag that would change value for a particular device; either the device
supports the feature or it does not. If it does not, the ethtool_ops
callbacks would return -EOPNOTSUPP (or would not even exist if the
driver has no support) and ethtool would say so.

> 	active: active
> 	supported queues: 0xf
> 	supported queues: 0xe
> 	minimum fragment size: 68
> 
> 
> $ ethtool --set-frame-preemption enp3s0 fp on min-frag-size 68 preemptible-queues-mask 0xe
> 
> This is a RFC because I wanted to have feedback on some points:
> 
>   - The parameters added are enough for the hardware I have, is it
>     enough in general?
> 
>   - even with the ethtool via netlink effort, I chose to keep the
>     ioctl() way, in case someone wants to backport this to an older
>     kernel, is there a problem with this?

I would prefer not extending ioctl interface with new features, with
obvious exceptions like adding new link modes or so. Not only because
having new features only available through netlink will motivate authors
of userspace tools to support netlink but mostly because the lack of
flexibility and extensibility of ioctl interface inevitably leads to
compromises you wouldn't have to do if you only implement netlink
requests.

One example I can see is the use of u32 for queue bitmaps. Perhaps you
don't expect this feature to be supported on devices with more than 32
queues (and I don't have enough expertise to tell if it's justified at
the moment) but can you be sure it will be the case in 10 or 20 years?
As long as these hardcoded u32 bitmaps are only part of internal kernel
API (ethtool_ops), extending the support for bigger devices will mean
some code churn (possibly large if many drivers implement the feature)
but it's something that can be done. But if you have this limit in
userspace API, you are in a much bigger trouble. The same can be said
for adding new attributes - easy with netlink but with ioctl you never
know if those reserved fields will suffice.

> 
>   - Some space for bikeshedding the names and location (for example,
>     does it make sense for these settings to be per-queue?), as I am
>     not quite happy with them, one example, is the use of preemptible
>     vs. preemptable;
> 
> 
> About the patches, should be quite straightforward:
> 
> Patch 1, adds the ETHTOOL_GFP and ETHOOL_SFP commands and the
> associated data structures;
> 
> Patch 2, adds the ETHTOOL_MSG_PREEMPT_GET and ETHTOOL_MSG_PREEMPT_SET
> netlink messages and the associated attributes;

I didn't look too deeply but one thing I noticed is that setting the
parameters using ioctl() does not trigger netlink notification. If we
decide to implement ioctl support (and I'm not a fan of that), the
notifications should be sent even when ioctl is used.

Michal
