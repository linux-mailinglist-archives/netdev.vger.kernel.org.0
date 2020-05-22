Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBDD1DDF2C
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 07:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgEVFRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 01:17:25 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54543 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgEVFRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 01:17:25 -0400
Received: by mail-pj1-f67.google.com with SMTP id s69so4414196pjb.4;
        Thu, 21 May 2020 22:17:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BtJ06i567hX+2QZknlU/wf223kz0tV6LDTyNLOjOgno=;
        b=aphFSbT26TQ+3HvtnKt4GibHNn7RSpiwELcWw8g3AHZg6ilYrAb+k6hP2GFXt36CQP
         JpApPau2S7i91HJ5VzUzNW5t+8/V4Cas3KSPyjLVIKbn78Ztlm2EQTex5pTUamGix6DE
         8ZsFTjYieV6kkwXbBqA6QSAoecDeyoDCee4TyH5TQj3G4n453CDcGVzQhbr+ryuVv9ye
         9kLEGClLLGZ0vJ1oxjpnnvaGjX4JZCwDua8qVAPJ/gH7f5u0ElPCCZvkQzzWb7ZQg1rD
         L7n6eaq/v3rlfXwiVqZzOBHhXFk9/B77Y1C2LxnMzpk8p93winY+NrcsztU80Rg9F3to
         OrhA==
X-Gm-Message-State: AOAM532eWDSV/9X0VWyCwc5auImHzWklAphAExi7ei488cDd4HMfUF2H
        WOyQzSbIkHv4B0k6JkuNBho=
X-Google-Smtp-Source: ABdhPJwsfT4Q1gia3l0sVwVM0j5AVWdem5kRmPrpe6OlE0OFzeroG40YNZA8rUHSoEbyWo1ary6RLQ==
X-Received: by 2002:a17:90a:e38c:: with SMTP id b12mr2508684pjz.227.1590124643875;
        Thu, 21 May 2020 22:17:23 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id v22sm6393671pfu.172.2020.05.21.22.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 22:17:22 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 744C84088B; Fri, 22 May 2020 05:17:21 +0000 (UTC)
Date:   Fri, 22 May 2020 05:17:21 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jessica Yu <jeyu@kernel.org>
Cc:     akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/15] taint: add module firmware crash taint support
Message-ID: <20200522051721.GX11244@42.do-not-panic.com>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-2-mcgrof@kernel.org>
 <20200519164231.GA27392@linux-8ccs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519164231.GA27392@linux-8ccs>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 06:42:31PM +0200, Jessica Yu wrote:
> +++ Luis Chamberlain [15/05/20 21:28 +0000]:
> > Device driver firmware can crash, and sometimes, this can leave your
> > system in a state which makes the device or subsystem completely
> > useless. Detecting this by inspecting /proc/sys/kernel/tainted instead
> > of scraping some magical words from the kernel log, which is driver
> > specific, is much easier. So instead provide a helper which lets drivers
> > annotate this.
> > 
> > Once this happens, scrapers can easily look for modules taint flags
> > for a firmware crash. This will taint both the kernel and respective
> > calling module.
> > 
> > The new helper module_firmware_crashed() uses LOCKDEP_STILL_OK as this
> > fact should in no way shape or form affect lockdep. This taint is device
> > driver specific.
> > 
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> > Documentation/admin-guide/tainted-kernels.rst |  6 ++++++
> > include/linux/kernel.h                        |  3 ++-
> > include/linux/module.h                        | 13 +++++++++++++
> > include/trace/events/module.h                 |  3 ++-
> > kernel/module.c                               |  5 +++--
> > kernel/panic.c                                |  1 +
> > tools/debugging/kernel-chktaint               |  7 +++++++
> > 7 files changed, 34 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/tainted-kernels.rst b/Documentation/admin-guide/tainted-kernels.rst
> > index 71e9184a9079..92530f1d60ae 100644
> > --- a/Documentation/admin-guide/tainted-kernels.rst
> > +++ b/Documentation/admin-guide/tainted-kernels.rst
> > @@ -100,6 +100,7 @@ Bit  Log  Number  Reason that got the kernel tainted
> >  15  _/K   32768  kernel has been live patched
> >  16  _/X   65536  auxiliary taint, defined for and used by distros
> >  17  _/T  131072  kernel was built with the struct randomization plugin
> > + 18  _/Q  262144  driver firmware crash annotation
> > ===  ===  ======  ========================================================
> > 
> > Note: The character ``_`` is representing a blank in this table to make reading
> > @@ -162,3 +163,8 @@ More detailed explanation for tainting
> >      produce extremely unusual kernel structure layouts (even performance
> >      pathological ones), which is important to know when debugging. Set at
> >      build time.
> > +
> > + 18) ``Q`` used by device drivers to annotate that the device driver's firmware
> > +     has crashed and the device's operation has been severely affected. The
> > +     device may be left in a crippled state, requiring full driver removal /
> > +     addition, system reboot, or it is unclear how long recovery will take.
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index 04a5885cec1b..19e1541c82c7 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -601,7 +601,8 @@ extern enum system_states {
> > #define TAINT_LIVEPATCH			15
> > #define TAINT_AUX			16
> > #define TAINT_RANDSTRUCT		17
> > -#define TAINT_FLAGS_COUNT		18
> > +#define TAINT_FIRMWARE_CRASH		18
> > +#define TAINT_FLAGS_COUNT		19
> > 
> > struct taint_flag {
> > 	char c_true;	/* character printed when tainted */
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index 2c2e988bcf10..221200078180 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -697,6 +697,14 @@ static inline bool is_livepatch_module(struct module *mod)
> > bool is_module_sig_enforced(void);
> > void set_module_sig_enforced(void);
> > 
> > +void add_taint_module(struct module *mod, unsigned flag,
> > +		      enum lockdep_ok lockdep_ok);
> > +
> > +static inline void module_firmware_crashed(void)
> > +{
> > +	add_taint_module(THIS_MODULE, TAINT_FIRMWARE_CRASH, LOCKDEP_STILL_OK);
> > +}
> 
> Just a nit: I think module_firmware_crashed() is a confusing name - it
> doesn't really tell me what it's doing, and it's not really related to
> the rest of the module_* symbols, which mostly have to do with module
> loader/module specifics. Especially since a driver can be built-in, too.
> How about taint_firmware_crashed() or something similar?

Sure.

> Also, I think we might crash in add_taint_module() if a driver is
> built into the kernel, because THIS_MODULE will be null and there is
> no null pointer check in add_taint_module(). We could unify the
> CONFIG_MODULES and !CONFIG_MODULES stubs and either add an `if (mod)`
> check in add_taint_module() or add an #ifdef MODULE check in the stub
> itself to call add_taint() or add_taint_module() as appropriate. Hope
> that makes sense.

I had to do something a bit different but I think you'll agree with it.
Will include it in my next iteration.

  Luis
