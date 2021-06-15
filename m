Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7073A8C65
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 01:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFOXYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 19:24:37 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36202 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhFOXYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 19:24:36 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DA18B1FD49;
        Tue, 15 Jun 2021 23:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623799350; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/Wk+ZrT8XyT4MwThIWbUw4nND3WOOskzjSsd0Vhk7ds=;
        b=JvY1sypkejwKcHyo6jR6P+Ya4paHzv/oQYYqDfoGlVSPtPJOS72RSuf4KKRtd3SrbKPGhR
        Rpi2PNZvO8Aien3w2PfGDJVqy5q2tO+JKPxsX3lZy8fLA0BrLfLX29IsCTZ1O7F1e2vzUl
        OA0ul87a0lSZ+G5bY5ENsS3qCZmmfuY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623799350;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/Wk+ZrT8XyT4MwThIWbUw4nND3WOOskzjSsd0Vhk7ds=;
        b=wCdxKixPdhUlwToxcKA7lWW2SMIdbiFc/WheDD2xkNUFkGCrJnBLliwbJcWVNeP9GgObEp
        Gukp2I89ZOVlldCA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D0760A3B91;
        Tue, 15 Jun 2021 23:22:30 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id B0AB3607D8; Wed, 16 Jun 2021 01:22:30 +0200 (CEST)
Date:   Wed, 16 Jun 2021 01:22:30 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Kev Jackson <foamdino@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: ethtool discrepancy between observed behaviour and comments
Message-ID: <20210615232230.ssjlx3x22nv5v37j@lion.mk-sys.cz>
References: <YMhJDzNrRNNeObly@linux-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMhJDzNrRNNeObly@linux-dev>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 07:30:39AM +0100, Kev Jackson wrote:
> Hi,
> 
> I have been working with ethtool, ioctl and Mellanox multi-queue NICs and I think
> I have discovered an issue with either the code or the comments that describe
> the code or recent changes.
> 
> My focus here is simply the ethtool -L command to set the channels for a
> multi-queue nic.  Running this command with the following params on a host with
> a Mellanox NIC works fine:
> 
> ethtool -L eth0 combined 4
> 
> The code however seems to check that one of rx or tx must be set as part of the
> command (channels.c):
> 
>         /* ensure there is at least one RX and one TX channel */
>         if (!channels.combined_count && !channels.rx_count)
>                 err_attr = ETHTOOL_A_CHANNELS_RX_COUNT;
>         else if (!channels.combined_count && !channels.tx_count)
>                 err_attr = ETHTOOL_A_CHANNELS_TX_COUNT;
>         else
>                 err_attr = 0;
> 
> and (ioctl.c):
> 
>         /* ensure there is at least one RX and one TX channel */
>         if (!channels.combined_count &&
>             (!channels.rx_count || !channels.tx_count))
>                 return -EINVAL;
> 
> This check was added in commit 7be9251, with the comment:
> "Having a channel config with no ability to RX or TX traffic is
> clearly wrong. Check for this in the core so the drivers don't
> have to."
> 
> However this comment and check is contradicted by a (much) older comment from
> commit 8b5933c, "Most multiqueue drivers pair up RX and TX
> queues so that most channels combine RX and TX work"
> 
> After working with ioctl and using a ETHTOOL_SCHANNELS command to try and set
> the number of channels (ETHTOOL_GCHANNELS works perfectly fine), I noticed I was
> always getting -EINVAL from ethtool_set_channels which led me to uncover these
> differences between the behaviour of the ethtool binary and using the
> ETHTOOL_SCHANNELS command via code.
> 
> After seeing this change I discovered the code in the latest ethtool is using
> netlink.c commands and nl_schannels is the command used to set the channels (if
> the kernel supports netlink).
> 
> nl_schannels was added in this commit: dd3ab09, which doesn't seem to have any
> checks for setting rx_count/tx_count/combined_count (although I could have
> missed them).
> 
> From putting all of this together, I have come to the conclusion that:
> * ioctl / ETHTOOL_SCHANNELS is a legacy method of setting channels
> * nl_schannels is the new / preferred method of setting channels
> * ethtool has fallback code to run ioctl functions for commands which don't yet
> * have a netlink equivalent
> 
> Our user experience is that ethtool -L currently does support (and
> should continue to support) just setting combined_count rather than
> having to set combined_count + one of rx_count/tx_count, which would
> mean removing the check in the ioctl.c, ethtool_set_channels code to
> make the netlink.c and ioctl.c commands consistent.

I don't understand what exactly are you reporting: do you have
a testcase where netlink and ioctl requests behave differently? Or do
you suggest that the sanity check should be also added to userspace
ethtool utility so that requests which do not make sense won't be passed
to kernel at all?

The logic behind the check is this: a combined channel can be used for
both receive and transmit, Rx and Tx channels only for one of them. Thus
the total number of receiving channels is combined_count + rx_count and
the total number of transmitting channels is combined_count + tx_count.

The conditions in ioctl and netlink paths are written in different ways
but they are equivalent: they prevent requests with no receiving (i.e.
combined or Rx) or no transmitting (i.e. combined or Tx) channel.
Examples:

  combined_count = 8, rx_count = 0, tx_count = 0 ... OK
  combined_count = 4, rx_count = 4, tx_count = 0 ... OK
  combined_count = 4, rx_count = 0, tx_count = 4 ... OK
  combined_count = 0, rx_count = 8, tx_count = 8 ... OK
  combined_count = 0, rx_count = 8, tx_count = 0 ... invalid
  combined_count = 0, rx_count = 0, tx_count = 8 ... invalid

Michal


> Obviously the other approach is to add the check for setting one of rx_count /
> tx_count into the nl_schannels function.
> 
> We're happy to provide a patch for either approach, but would like to
> raise this as potentially a bug in the current code.
> 
> Thanks,
> Kev
