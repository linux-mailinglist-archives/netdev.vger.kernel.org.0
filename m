Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D945F18C406
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 01:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgCTABO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 20:01:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37320 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727238AbgCTABL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 20:01:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=vHZuTkIraH0j18C0yesq0h37iJWXExpW0+pRP9wHAFQ=; b=kiLnA4+HBazSxcmaF2vYSeDjTi
        GZySNj/qYjY7qWPGZkmvHOClubyAs6vb7qNyQfZbboMzJvAC4SHO+rElmWzJ0jHKOLMyU89vHKXK/
        n1M8PZ7nzbZS/ryrjge0YuJsfT2QgYPpt2RAbDeongoVB9W/tMUNAm/+H2dBMRuDAuWrU0PwbnQ75
        54EFHJNVY0SnoWPPNthdT3GTBbdGU8DxgXaRaLjrQZFGUO+ooZjTCdCB5e4iC3O2gyhwvHlCijgXg
        qdZtqnhJd8ufbtliHGhktsMMJQdKUHbLmcPLdZ0UbErD8gWdNNPnllI27n2u1y0WLcmNSdyDJUoWb
        Kec+VEjg==;
Received: from 99-123-7-132.lightspeed.sntcca.sbcglobal.net ([99.123.7.132] helo=[192.168.1.71])
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jF562-0000eU-0Q; Fri, 20 Mar 2020 00:01:06 +0000
Subject: Re: [patch V2 07/15] powerpc/ps3: Convert half completion to rcuwait
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Will Deacon <will@kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-wireless@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.102694393@linutronix.de>
 <20200319100459.GA18506@infradead.org>
 <20200319102613.hbwax7zrrvgcde4x@linutronix.de>
From:   Geoff Levand <geoff@infradead.org>
Message-ID: <efc2378e-cf8e-8bf9-d009-34c6bcf43c8e@infradead.org>
Date:   Thu, 19 Mar 2020 17:01:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200319102613.hbwax7zrrvgcde4x@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 3/19/20 3:26 AM, Sebastian Andrzej Siewior wrote:
> On 2020-03-19 03:04:59 [-0700], Christoph Hellwig wrote:
>> But I wonder how alive the whole PS3 support is to start with..
> 
> OtherOS can only be used on "old" PS3 which do not have have their
> firmware upgraded past version 3.21, released April 1, 2010 [0].
> It was not possible to install OtherOS on PS3-slim and I don't remember
> if it was a successor or a budget version (but it had lower power
> consumption as per my memory).
> *I* remember from back then that a few universities bought quite a few
> of them and used them as a computation cluster. However, whatever broke
> over the last 10 years is broken.
> 
> [0] https://en.wikipedia.org/wiki/OtherOS
There are still PS3-Linux users out there.  They generally use firmware
and other tools available through the 'hacker' communities that allow
Linux to be run on more than just the 'officially supported' platforms.

Anyway, the change to use rcuwait seems fine if that's needed for the
completion re-work.  I'll try to do some testing with the patch set
next week.

-Geoff
