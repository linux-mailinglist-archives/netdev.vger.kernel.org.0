Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948F11CC3B6
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 20:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgEISfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 14:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727787AbgEISft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 14:35:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BE57208E4;
        Sat,  9 May 2020 18:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589049349;
        bh=QmAmcuBAZpUIMlw5HlYzqJsGCOS1nyVcTJJrmxl+o8I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CPNViKbJ4P2YAC4mzyMHEyU/Dv1agQ2e7Ez3A26Z29NotTIHzIODp7vylN3E+Sihi
         9mfHXYRTMrbQvCTdFCJ47Jz92YHKcPv2iFoYP4EaBIJE2mJ3DvcANHMNDHFnMcWrxr
         DVynt0+0pdboSAXxlG9zGQS1QHqyb34xz4rjKiPo=
Date:   Sat, 9 May 2020 11:35:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Cc:     jeyu@kernel.org, akpm@linux-foundation.org, arnd@arndb.de,
        rostedt@goodmis.org, mingo@redhat.com, aquini@redhat.com,
        cai@lca.pw, dyoung@redhat.com, bhe@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, gpiccoli@canonical.com,
        pmladek@suse.com, tiwai@suse.de, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] net: taint when the device driver firmware
 crashes
Message-ID: <20200509113546.7dcd1599@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200509043552.8745-1-mcgrof@kernel.org>
References: <20200509043552.8745-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  9 May 2020 04:35:37 +0000 Luis Chamberlain wrote:
> Device driver firmware can crash, and sometimes, this can leave your
> system in a state which makes the device or subsystem completely
> useless. Detecting this by inspecting /proc/sys/kernel/tainted instead
> of scraping some magical words from the kernel log, which is driver
> specific, is much easier. So instead this series provides a helper which
> lets drivers annotate this and shows how to use this on networking
> drivers.
> 
> My methodology for finding when firmware crashes is to git grep for
> "crash" and then doing some study of the code to see if this indeed
> a place where the firmware crashes. In some places this is quite
> obvious.
> 
> I'm starting off with networking first, if this gets merged later on I
> can focus on the other drivers, but I already have some work done on
> other subsytems.
> 
> Review, flames, etc are greatly appreciated.

Tainting itself may be useful, but that's just the first step. I'd much
rather see folks start using the devlink health infrastructure. Devlink
is netlink based, but it's _not_ networking specific (many of its
optional features obviously are, but don't let that mislead you).

With devlink health we get (a) a standard notification on the failure; 
(b) information/state dump in a (somewhat) structured form, which can be
collected & shared with vendors; (c) automatic remediation (usually
device reset of some scope).

Now regarding the tainting - as I said it may be useful, but don't we
have to define what constitutes a "firmware crash"? There are many
failure modes, some perfectly recoverable (e.g. processing queue hang), 
some mere bugs (e.g. device fails to initialize some functions). All of
them may impact the functioning of the system. How do we choose those
that taint? 

