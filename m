Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39961D88E1
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgERUIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgERUIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 16:08:53 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1ACC061A0C;
        Mon, 18 May 2020 13:08:53 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jam3D-00FjeM-Ku; Mon, 18 May 2020 22:07:51 +0200
Message-ID: <bb0b9a2da99c16a28c1dbee93d08abfa2aecdc8b.camel@sipsolutions.net>
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Steve deRosier <derosier@gmail.com>,
        Ben Greear <greearb@candelatech.com>, jeyu@kernel.org,
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
Date:   Mon, 18 May 2020 22:07:49 +0200
In-Reply-To: <20200518195950.GP11244@42.do-not-panic.com> (sfid-20200518_215954_551733_20DE2085)
References: <20200515212846.1347-13-mcgrof@kernel.org>
         <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
         <20200518165154.GH11244@42.do-not-panic.com>
         <4ad0668d-2de9-11d7-c3a1-ad2aedd0c02d@candelatech.com>
         <20200518170934.GJ11244@42.do-not-panic.com>
         <abf22ef3-93cb-61a4-0af2-43feac6d7930@candelatech.com>
         <20200518171801.GL11244@42.do-not-panic.com>
         <CALLGbR+ht2V3m5f-aUbdwEMOvbsX8ebmzdWgX4jyWTbpHrXZ0Q@mail.gmail.com>
         <20200518190930.GO11244@42.do-not-panic.com>
         <e3d978c8fa6a4075f12e843548d41e2c8ab537d1.camel@sipsolutions.net>
         <20200518195950.GP11244@42.do-not-panic.com>
         (sfid-20200518_215954_551733_20DE2085)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-05-18 at 19:59 +0000, Luis Chamberlain wrote:

> > Err, no. Those two are most definitely related. Have you looked at (most
> > or some or whatever) staging drivers recently? Those contain all kinds
> > of garbage that might do whatever with your kernel.
> 
> No, I stay away :)

:)

> > That's all fine, I just don't think it's appropriate to pretend that
> > your kernel is now 'tainted' (think about the meaning of that word) when
> > the firmware of some random device crashed.
> 
> If the firmware crash *does* require driver remove / addition again,
> or a reboot, would you think that this is a situation that merits a taint?

Not really. In my experience, that's more likely a hardware issue (card
not properly seated, for example) that a bus reset happens to "fix".

> > It's pretty clear, but even then, first of all I doubt this is the case
> > for many of the places that you've sprinkled the annotation on,
> 
> We can remove it, for this driver I can vouch for its location as it did
> reach a state where I required a reboot. And its not the first time this
> has happened. This got me thinking about the bigger picture of the lack
> of proper way to address these cases in the kernel, and how the user is
> left dumbfounded.

Fair, so the driver is still broken wrt. recovery here. I still don't
think that's a situation where e.g. the system should say "hey you have
a taint here, if your graphics go bad now you should not report that
bug" (which is effectively what the single taint bit does).

> > and secondly it actually hides useful information.
> 
> What is it hiding?

Most importantly, which device crashed. Secondarily I'd say how many
times (*).

The information "firmware crashed" is really only useful in relation to
the device. If your graphics firmware crashed, yeah, well, you probably
won't even see this. If your USB wifi firmware crashed? Not really
interesting, you'll anyway just unplug. In fact it's very hard for a USB
driver (short of arbitrary memory corruption) to significantly mess up
the system.

johannes

(*) though if it crashed only once, was that because it was wedged
enough to be unusable afterwards, or because everything was fine?


