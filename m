Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD0224EFAE
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 22:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgHWUQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 16:16:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:37336 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgHWUQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 16:16:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9C28AAC48;
        Sun, 23 Aug 2020 20:16:53 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id DEDBE6030D; Sun, 23 Aug 2020 22:16:23 +0200 (CEST)
Date:   Sun, 23 Aug 2020 22:16:23 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     "Hans-Christian Egtvedt (hegtvedt)" <hegtvedt@cisco.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: ethtool 5.8 segfaults when changing settings on a device
Message-ID: <20200823201623.soezu7b3dal6nfao@lion.mk-sys.cz>
References: <31867b3d-341c-6ed5-c212-bfde37a1059d@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31867b3d-341c-6ed5-c212-bfde37a1059d@cisco.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 12:25:22PM +0000, Hans-Christian Egtvedt (hegtvedt) wrote:
> Hello,
> 
> I am testing ethtool 5.8, and I noticed it segfaulted with the command
>    ethtool -s eth0 autoneg on
> 
> Backtrace as follows:
> (gdb) run -s eth0 autoneg on
> Starting program: /tmp/ethtool-5.8 -s eth0 autoneg on
> 
> Program received signal SIGSEGV, Segmentation fault.
> 0x0040bef8 in do_sset ()
> (gdb) bt
> #0  0x0040bef8 in do_sset ()
> #1  0x00407d9c in do_ioctl_glinksettings ()
> #2  0x00000000 in ?? ()
> Backtrace stopped: previous frame identical to this frame (corrupt stack?)
> 
> I then tested reverting 
> https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/ethtool.c?id=bef780467fa7aa95dca3ed5cc3ebb8bec5882f08
> 
> And the command now passes.
> 
> I am running ethtool on top of Linux 4.4.232, hence there is no support 
> for ETHTOOL_xLINKSETTINGS.
> 
> Is the bef780467fa7aa95dca3ed5cc3ebb8bec5882f08 patch not correct, one 
> should check link_usettings pointer for non-NULL before memset'ing?
> 
> Since do_ioctl_glinksettings() will return NULL upon failure, which 
> matches well with kernels not supporting ETHTOOL_GLINKSETTINGS ioctl.

Thank you for the report. Reverting commit bef780467fa7 would bring back
the issue it fixed. AFAICS the only problem is indeed the missing null
check which allows dereferencing the pointer returned by
do_ioctl_glinksettings() even if it is null. I didn't realize the
pointer can be null which is rather shameful as there is a null check
right below the inserted memset(). Thus adding the null check (which can
be combined with one that is already there) should be the easiest way to
fix this.

Please feel free to submit the fix.

Michal
