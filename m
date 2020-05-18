Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DAA1D8835
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 21:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgERT0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 15:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbgERT0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 15:26:39 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C924C061A0C;
        Mon, 18 May 2020 12:26:39 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jalNw-00Fhxr-7e; Mon, 18 May 2020 21:25:14 +0200
Message-ID: <e3d978c8fa6a4075f12e843548d41e2c8ab537d1.camel@sipsolutions.net>
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Steve deRosier <derosier@gmail.com>
Cc:     Ben Greear <greearb@candelatech.com>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com,
        Takashi Iwai <tiwai@suse.de>, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Date:   Mon, 18 May 2020 21:25:09 +0200
In-Reply-To: <20200518190930.GO11244@42.do-not-panic.com> (sfid-20200518_210935_354047_0199DB8F)
References: <20200515212846.1347-1-mcgrof@kernel.org>
         <20200515212846.1347-13-mcgrof@kernel.org>
         <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
         <20200518165154.GH11244@42.do-not-panic.com>
         <4ad0668d-2de9-11d7-c3a1-ad2aedd0c02d@candelatech.com>
         <20200518170934.GJ11244@42.do-not-panic.com>
         <abf22ef3-93cb-61a4-0af2-43feac6d7930@candelatech.com>
         <20200518171801.GL11244@42.do-not-panic.com>
         <CALLGbR+ht2V3m5f-aUbdwEMOvbsX8ebmzdWgX4jyWTbpHrXZ0Q@mail.gmail.com>
         <20200518190930.GO11244@42.do-not-panic.com>
         (sfid-20200518_210935_354047_0199DB8F)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-05-18 at 19:09 +0000, Luis Chamberlain wrote:

> > Unfortunately a "taint" is interpreted by many users as: "your kernel
> > is really F#*D up, you better do something about it right now."
> > Assuming they're paying attention at all in the first place of course.
> 
> Taint historically has been used and still is today to help rule out
> whether or not you get support, or how you get support.
> 
> For instance, a staging driver is not supported by some upstream
> developers, but it will be by those who help staging and Greg. TAINT_CRAP
> cannot be even more clear.
> 
> So, no, it is not just about "hey your kernel is messed up", there are
> clear support boundaries being drawn.

Err, no. Those two are most definitely related. Have you looked at (most
or some or whatever) staging drivers recently? Those contain all kinds
of garbage that might do whatever with your kernel.

Of course that's not a completely clear boundary, maybe you can find a
driver in staging that's perfect code just not written to kernel style?
But I find that hard to believe, in most cases.

So no, it's really not about "[a] staging driver is not supported" vs.
"your kernel is messed up". The very fact that you loaded one of those
things might very well have messed up your kernel entirely.

> These days though, I think we all admit, that firmware crashes can use
> a better generic infrastructure for ensuring that clearly affecting-user
> experience issues. This patch is about that *when and if these happen*,
> we annotate it in the kernel for support pursposes.

That's all fine, I just don't think it's appropriate to pretend that
your kernel is now 'tainted' (think about the meaning of that word) when
the firmware of some random device crashed. Heck, that could have been a
USB device that was since unplugged. Unless the driver is complete
garbage (hello staging again?) that really should have no lasting effect
on the system itself.

> Recovery without affecting user experience would be great, the taint is
> *not* for those cases. The taint definition has:
> 
> + 18) ``Q`` used by device drivers to annotate that the device driver's firmware
> +     has crashed and the device's operation has been severely affected. The    
> +     device may be left in a crippled state, requiring full driver removal /   
> +     addition, system reboot, or it is unclear how long recovery will take.
> 
> Let me know if this is not clear.

It's pretty clear, but even then, first of all I doubt this is the case
for many of the places that you've sprinkled the annotation on, and
secondly it actually hides useful information.

Regardless of the support issue, I think this hiding of information is
also problematic.

I really think we'd all be better off if you just made a sysfs file (I
mistyped debugfs in some other email, sorry, apparently you didn't see
the correction in time) that listed which device(s) crashed and how many
times. That would actually be useful. Because honestly, if a random
device crashed for some random reason, that's pretty much a non-event.
If it keeps happening, then we might even want to know about it.

You can obviously save the contents of this file into your bug reports
automatically and act accordingly, but I think you'll find that this is
far more useful than saying "TAINT_FIRMWARE_CRASHED" so I'll ignore this
report. Yeah, that might be reasonable thing if the bug report is about
slow wifi *and* you see that ath10k firmware crashed every 10 seconds,
but if it just crashed once a few days earlier it's of no importance to
the system anymore ... And certainly a reasonable driver (which I
believe ath10k to be) would _not_ randomly start corrupting memory
because its firmware crashed. Which really is what tainting the kernel
is about.

So no, even with all that, I still really believe you're solving the
wrong problem. Having information about firmware crashes, preferably
with some kind of frequency information attached, and *clearly* with
information about which device attached would be _great_. Munging it all
into one bit is actively harmful, IMO.

johannes

