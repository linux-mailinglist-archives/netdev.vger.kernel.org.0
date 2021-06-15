Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CFD3A89AE
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 21:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhFOTm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 15:42:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229898AbhFOTmz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 15:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE7446137D;
        Tue, 15 Jun 2021 19:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623786051;
        bh=Sob5rqGDvOdFc70UjzO1ySt1WBSdHvnfT5TsuZKq5j0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ezmz5xyFXNX6XsxJkUhoUljvIhTonaypjyet8y55fugd92LDItEKIkVFD1d0Q7xND
         IQ49CoblONFyA875wGP81766ldE5kHFWw0rPnZlvxcrd5jQ4X72WfbaqysfEBXs8rN
         hKVVAC9+bIrzjVTF53MhR34USwMRYaPE/N2X8QB2dT3KLM9k7RcElCm8OqpG2oY+yb
         /VsJVKeTzd3gyidOEjOb9/iQ/944k3/j3+/vk8siVmYC2gz/UMySatTd3E69toeeXb
         mhOvNXi9rTH2e64ZlKIZzP7fASPGJmyy4eXGNOZm8+mGhbo+3Fq76k+m4rYP63cJnZ
         SQp2w5mVto52w==
Date:   Tue, 15 Jun 2021 12:40:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kev Jackson <foamdino@gmail.com>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: ethtool discrepancy between observed behaviour and comments
Message-ID: <20210615124050.50138c05@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YMhJDzNrRNNeObly@linux-dev>
References: <YMhJDzNrRNNeObly@linux-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Jun 2021 07:30:39 +0100 Kev Jackson wrote:
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

> From putting all of this together, I have come to the conclusion that:
> * ioctl / ETHTOOL_SCHANNELS is a legacy method of setting channels
> * nl_schannels is the new / preferred method of setting channels
> * ethtool has fallback code to run ioctl functions for commands which don't yet
> * have a netlink equivalent
> 
> Our user experience is that ethtool -L currently does support (and should continue to
> support) just setting combined_count rather than having to set combined_count +
> one of rx_count/tx_count, which would mean removing the check in the ioctl.c,
> ethtool_set_channels code to make the netlink.c and ioctl.c commands consistent.
> 
> Obviously the other approach is to add the check for setting one of rx_count /
> tx_count into the nl_schannels function.
> 
> We're happy to provide a patch for either approach, but would like to raise this
> as potentially a bug in the current code.

I'm not sure I grasped what the problem is. Could you perhaps share
what you're trying to do that works with netlink vs IOCTL? Best if
it's in form of:

$ ethtool -l $ifc
$ ./ethtool-ioctl -L $ifc ...
# presumably fails IIUC?
$ ./ethtool-nl -L $ifc ...
# and this one succeeds?

where ethtool-ioctl and ethtool-nl would be hacked up ethtool binaries
which only use one mechanism instead of trying to autoselect.
