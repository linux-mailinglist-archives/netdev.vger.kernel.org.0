Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA76143E5F8
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 18:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhJ1QW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 12:22:57 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:33268 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbhJ1QWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 12:22:54 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2C9781FD55;
        Thu, 28 Oct 2021 16:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635438026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vwnbx2mDtAHgOvvrGeNNThr1nWlRsUMHYSvEascbsuU=;
        b=rG/Y1pioiNpQEKED1jtN6UQ07SPJtZt+KNhxwg4Eo68LZmgtWqB29oxtDVn0L1e9ejAy6V
        IaywZd2Fgdqtbz/AQFY87yxNzQ/JTzdrj4jEe/FjwJw2f04Nfn2Qm8RmxeYfXoJO7AZWCo
        WUAdl7DDfkMilcIRMB20UWir4YjZi/Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635438026;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vwnbx2mDtAHgOvvrGeNNThr1nWlRsUMHYSvEascbsuU=;
        b=PengEVu6JizYyWkbjbkiVolnuMOQ1hVv7y4KjnG4UOsrTt9zg2O5nsMFnJrvFNYdjRDaTP
        RdXSDJ1frPD+MKCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1DD8F13A9C;
        Thu, 28 Oct 2021 16:20:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VrxAB8rNemEbTQAAMHmgww
        (envelope-from <jwiesner@suse.de>); Thu, 28 Oct 2021 16:20:26 +0000
Received: by incl.suse.cz (Postfix, from userid 1000)
        id A6896589BD; Thu, 28 Oct 2021 18:20:25 +0200 (CEST)
Date:   Thu, 28 Oct 2021 18:20:25 +0200
From:   Jiri Wiesner <jwiesner@suse.de>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] clocksource: increase watchdog retries
Message-ID: <20211028162025.GA1068@incl>
References: <20211027164352.GA23273@incl>
 <20211027213829.GB880162@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027213829.GB880162@paulmck-ThinkPad-P17-Gen-1>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 02:38:29PM -0700, Paul E. McKenney wrote:
> I had something like this pending, but people came up with other workloads
> that resulted in repeated delays.  In those cases, it does not make sense
> to ever mark the affected clocksource unstable.  This led me to the patch
> shown below, which splats after about 100 consecutive long-delay retries,
> but which avoids marking the clocksource unstable.  This is queued on -rcu.
> 
> Does this work for you?
> 
> commit 9ec2a03bbf4bee3d9fbc02a402dee36efafc5a2d
> Author: Paul E. McKenney <paulmck@kernel.org>
> Date:   Thu May 27 11:03:28 2021 -0700
> 
>     clocksource: Forgive repeated long-latency watchdog clocksource reads

Yes, it does. I have done 100 reboots of the testing machine (running 5.15-rc5 with the above patch applied) and TSC was stable every time. I am going to start a longer test of 300 reboots for good measure and report back next week. J.
