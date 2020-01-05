Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5DD0130A36
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 23:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgAEWWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 17:22:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40512 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgAEWWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 17:22:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF4C21573659A;
        Sun,  5 Jan 2020 14:22:12 -0800 (PST)
Date:   Sun, 05 Jan 2020 14:22:12 -0800 (PST)
Message-Id: <20200105.142212.220791290658183368.davem@davemloft.net>
To:     tony.luck@intel.com
Cc:     fenghua.yu@intel.com, michael.chan@broadcom.com,
        netdev@vger.kernel.org, tglx@linutronix.de, luto@kernel.org,
        peterz@infradead.org, David.Laight@aculab.com,
        ravi.v.shankar@intel.com
Subject: Re: [Patch v2] drivers/net/b44: Change to non-atomic bit
 operations on pwol_mask
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200102212706.GA29778@agluck-desk2.amr.corp.intel.com>
References: <20191225011020.GE241295@romley-ivt3.sc.intel.com>
        <20191224.182307.2303352806218314412.davem@davemloft.net>
        <20200102212706.GA29778@agluck-desk2.amr.corp.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jan 2020 14:22:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Luck, Tony" <tony.luck@intel.com>
Date: Thu, 2 Jan 2020 13:27:06 -0800

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Atomic operations that span cache lines are super-expensive on x86
> (not just to the current processor, but also to other processes as all
> memory operations are blocked until the operation completes). Upcoming
> x86 processors have a switch to cause such operations to generate a #AC
> trap. It is expected that some real time systems will enable this mode
> in BIOS.
> 
> In preparation for this, it is necessary to fix code that may execute
> atomic instructions with operands that cross cachelines because the #AC
> trap will crash the kernel.
> 
> Since "pwol_mask" is local and never exposed to concurrency, there is
> no need to set bits in pwol_mask using atomic operations.
> 
> Directly operate on the byte which contains the bit instead of using
> __set_bit() to avoid any big endian concern due to type cast to
> unsigned long in __set_bit().
> 
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Applied, thanks.

I wonder if this is being used in an endian safe way.  Maybe the way
the filter is written into the chip makes it work out, I don't know.
