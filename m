Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF76526516
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 16:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381538AbiEMOqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 10:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381450AbiEMOp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 10:45:58 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB093C4B7;
        Fri, 13 May 2022 07:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=A7LCydQD5IYNzaoDGyfG1KKM7tCxGhr7TuWULSo03X0=;
        t=1652453114; x=1653662714; b=LYs2Kri0cw+/UGCEdaklFX6++OP3d6XjJhLcC02jkMM6M13
        enCTtLPVnFDCrQRFLX819G3cOwVdjYiBSa9JccmqbQblnXISEdyq/7i5O4aMDV5xAFeJh8X61XWYA
        3hNxcWPO6okKyPbXVAhEt6WHQ/sVkV0gcWR0C3dCeQWocdHTJKZWVZ25I4x63uWgmbhevhAje3sRQ
        ynAaFSpM6xFAePbWKVwYY4aWUVh0Ju93mi2MceapTMkNIryb6lt7v4/iXwdFQzg89Tz18COaji5Fq
        iSqUu6mUSMMlAVO2Bcj32MYDMrCOrP4TWkawclAlZw9o6WbW7KIcYMOBD7zR8fsA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1npWX2-00AdYm-Tp;
        Fri, 13 May 2022 16:44:41 +0200
Message-ID: <1760d499824f9ef053af7a8dac04b48ab7d7fd3d.camel@sipsolutions.net>
Subject: Re: [PATCH 11/30] um: Improve panic notifiers consistency and
 ordering
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Petr Mladek <pmladek@suse.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>
Cc:     akpm@linux-foundation.org, bhe@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-um@lists.infradead.org,
        linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net, rcu@vger.kernel.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org
Date:   Fri, 13 May 2022 16:44:36 +0200
In-Reply-To: <4b003501-f5c3-cd66-d222-88d98c93e141@igalia.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
         <20220427224924.592546-12-gpiccoli@igalia.com> <Ynp2hRodh04K3pzK@alley>
         <4b003501-f5c3-cd66-d222-88d98c93e141@igalia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-05-11 at 17:22 -0300, Guilherme G. Piccoli wrote:
> On 10/05/2022 11:28, Petr Mladek wrote:
> > [...]
> > It is not clear to me why user mode linux should not care about
> > the other notifiers. It might be because I do not know much
> > about the user mode linux.
> > 
> > Is the because they always create core dump or are never running
> > in a hypervisor or ...?
> > 
> > AFAIK, the notifiers do many different things. For example, there
> > is a notifier that disables RCU watchdog, print some extra
> > information. Why none of them make sense here?
> > 
> 
> Hi Petr, my understanding is that UML is a form of running Linux as a
> regular userspace process for testing purposes.

Correct.

> With that said, as soon
> as we exit in the error path, less "pollution" would happen, so users
> can use GDB to debug the core dump for example.
> 
> In later patches of this series (when we split the panic notifiers in 3
> lists) these UML notifiers run in the pre-reboot list, so they run after
> the informational notifiers for example (in the default level).
> But without the list split we cannot order properly, so my gut feeling
> is that makes sense to run them rather earlier than later in the panic
> process...
> 
> Maybe Anton / Johannes / Richard could give their opinions - appreciate
> that, I'm not attached to the priority here, it's more about users'
> common usage of UML I can think of...

It's hard to say ... In a sense I'm not sure it matters?

OTOH something like the ftrace dump notifier (kernel/trace/trace.c)
might still be useful to run before the mconsole and coredump ones, even
if you could probably use gdb to figure out the information.

Personally, I don't have a scenario where I'd care about the trace
buffers though, and most of the others I found would seem irrelevant
(drivers that aren't even compiled, hung tasks won't really happen since
we exit immediately, and similar.)

johannes
