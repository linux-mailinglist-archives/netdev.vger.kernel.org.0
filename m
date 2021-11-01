Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E2F4419DF
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 11:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhKAKap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 06:30:45 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:47394 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbhKAKam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 06:30:42 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D10CB21941;
        Mon,  1 Nov 2021 10:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635762488; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=usVlcm16rD4WtoGbsEUNqTyTpA7Ux47Pw/hhZhArBGY=;
        b=tFJ5sBD3FBPtAw9MezQg7it8KhjmqH8K5z0bz2dIpVE8R2vGTfN06vUsgs9JfEGQ7FXrzt
        8mGqrz26LMEeO4jOoneRA4DgfxtgWq1H+CH67cpshO3AFKMGOIvjGIRLA1DxLB8dceqXy+
        LLWuKSNAb+U0rfVwbvY+77iznZnOARM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635762488;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=usVlcm16rD4WtoGbsEUNqTyTpA7Ux47Pw/hhZhArBGY=;
        b=dAwN2+J3gaHn1fuz1paoHW7kVdJdiP0wnJ4n5Yax8OIZdPBQ7QWvI2+ya5+0uGx8XRnwR9
        85aQcPoKfFFDFkAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C325113AA9;
        Mon,  1 Nov 2021 10:28:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BlubLzjBf2EsTgAAMHmgww
        (envelope-from <jwiesner@suse.de>); Mon, 01 Nov 2021 10:28:08 +0000
Received: by incl.suse.cz (Postfix, from userid 1000)
        id 56A415956F; Mon,  1 Nov 2021 11:28:03 +0100 (CET)
Date:   Mon, 1 Nov 2021 11:28:03 +0100
From:   Jiri Wiesner <jwiesner@suse.de>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] clocksource: increase watchdog retries
Message-ID: <20211101102803.GA16089@incl>
References: <20211027164352.GA23273@incl>
 <20211027213829.GB880162@paulmck-ThinkPad-P17-Gen-1>
 <20211028162025.GA1068@incl>
 <20211028184209.GH880162@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028184209.GH880162@paulmck-ThinkPad-P17-Gen-1>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 11:42:09AM -0700, Paul E. McKenney wrote:
> On Thu, Oct 28, 2021 at 06:20:25PM +0200, Jiri Wiesner wrote:
> > On Wed, Oct 27, 2021 at 02:38:29PM -0700, Paul E. McKenney wrote:
> > > I had something like this pending, but people came up with other workloads
> > > that resulted in repeated delays.  In those cases, it does not make sense
> > > to ever mark the affected clocksource unstable.  This led me to the patch
> > > shown below, which splats after about 100 consecutive long-delay retries,
> > > but which avoids marking the clocksource unstable.  This is queued on -rcu.
> > > 
> > > Does this work for you?
> > > 
> > > commit 9ec2a03bbf4bee3d9fbc02a402dee36efafc5a2d
> > > Author: Paul E. McKenney <paulmck@kernel.org>
> > > Date:   Thu May 27 11:03:28 2021 -0700
> > > 
> > >     clocksource: Forgive repeated long-latency watchdog clocksource reads
> > 
> > Yes, it does. I have done 100 reboots of the testing machine (running
> > 5.15-rc5 with the above patch applied) and TSC was stable every time. I
> > am going to start a longer test of 300 reboots for good measure and
> > report back next week. J.
> 
> Very good, and thank you for giving it a go!

Thank you for the fix! It resolves several strange results we got in our performance testing.

> If it passes the upcoming tests

I have done 300 reboots of the testing machine. Again, TSC was stable every time.

> may I have your Tested-by?

Absolutely:
Tested-by: Jiri Wiesner <jwiesner@suse.de>
