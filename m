Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2595B1DF0BC
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 22:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgEVUrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 16:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730946AbgEVUrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 16:47:23 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73C2C061A0E;
        Fri, 22 May 2020 13:47:22 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jcEYU-000zou-Ao; Fri, 22 May 2020 22:46:10 +0200
Message-ID: <2e5199edb433c217c7974ef7408ff8c7253145b6.camel@sipsolutions.net>
Subject: Re: [RFC 1/2] devlink: add simple fw crash helpers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     derosier@gmail.com, greearb@candelatech.com, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, jiri@resnulli.us,
        briannorris@chromium.org
Date:   Fri, 22 May 2020 22:46:07 +0200
In-Reply-To: <20200522101738.1495f4cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200519010530.GS11244@42.do-not-panic.com>
         <20200519211531.3702593-1-kuba@kernel.org>
         <20200522052046.GY11244@42.do-not-panic.com>
         <20200522101738.1495f4cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-05-22 at 10:17 -0700, Jakub Kicinski wrote:

> > > --- a/net/core/Makefile
> > > +++ b/net/core/Makefile
> > > @@ -31,7 +31,7 @@ obj-$(CONFIG_LWTUNNEL_BPF) += lwt_bpf.o
> > >  obj-$(CONFIG_BPF_STREAM_PARSER) += sock_map.o
> > >  obj-$(CONFIG_DST_CACHE) += dst_cache.o
> > >  obj-$(CONFIG_HWBM) += hwbm.o
> > > -obj-$(CONFIG_NET_DEVLINK) += devlink.o
> > > +obj-$(CONFIG_NET_DEVLINK) += devlink.o devlink_simple_fw_reporter.o  
> > 
> > This was looking super sexy up to here. This is networking specific.
> > We want something generic for *anything* that requests firmware.
> 
> You can't be serious. It's network specific because of how the Kconfig
> is named?

Wait, yeah, what?

> Working for a company operating large data centers I would strongly
> prefer if we didn't have ten different ways of reporting firmware
> problems in the fleet.

Agree. I don't actually operate anything, but still ...

Thinking about this - maybe there's a way to still combine devcoredump
and devlink somehow?

Or (optionally) make devlink trigger devcoredump while userspace
migrates?

> > So networking may want to be aware that a firmware crash happened as
> > part of this network device health thing, but firmware crashing is a
> > generic thing.
> > 
> > I have now extended my patch set to include uvents and I am more set on
> > that we need the taint now more than ever.

FWIW, I still completely disagree on that taint. You (Luis) obviously
have been running into a bug in that driver, I doubt the firmware
actually managed to wedge the hardware.

But even if it did, that's still not really a kernel taint. The kernel
itself isn't in any way affected by this.

Yes, the system is in a weird state now. But that's *not* equivalent to
"kernel tainted".

> The irony is you have a problem with a networking device and all the
> devices your initial set touched are networking. Two of the drivers 
> you touched either have or will soon have devlink health reporters
> implemented.

Like I said above, do you think it'd be feasible to make a devcoredump
out of devlink health reports? And can the report be in a way that we
control the file format, or are there limits? I guess I should read the
code to find out, but I figure you probably just know. But feel free to
tell me to read it :)

The reason I'm asking is that it's starting to sound like we really
ought to be implementing devlink, but we've got a bunch of
infrastructure that uses the devcoredump, and it'll take time
(significantly so) to change all that...

johannes

