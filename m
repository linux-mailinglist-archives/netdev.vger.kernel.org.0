Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D301CDCB5
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 16:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730384AbgEKOLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 10:11:19 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33648 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730180AbgEKOLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 10:11:17 -0400
Received: by mail-pf1-f193.google.com with SMTP id x77so4804466pfc.0;
        Mon, 11 May 2020 07:11:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AWgg7qj1bkym/xNblxQzDHT3If2HCewLrF/zJm6gRzY=;
        b=npawjWnwtbK/fg8Yq6Frejo0kpo7h9WnRz/l1yBtBW482mr4oFAS2C7X0dURs0p6k2
         U6DNLUs3t5YFi8ACItK//MfI6SHmvRKtppysbN0pUCF/WxwSJsXzbInb6fueD6Msd2wA
         uvkSa6Lei/iaZD0Q1OhKTAwHdlTdymrx0ZG7dKMDzuLMuyEiVOSPzaOynprs9YL19c53
         3lRzWst6p/AnKXPaLTnWLo0om7oEvHFcz1POEnWNgeRoNbvpE4Wb4OH1huufn7VatB30
         aE10OimdCe2wOc9Fz8SqLLeohUa9IJbgXHPcE945j3AQdbRv7sFKe71xJN8xYFDU+VLT
         f3aA==
X-Gm-Message-State: AGi0PuZ4m4Y09i2VXVACgSMVGQow72zG2Yl9xPyXfKr7zVVxVjLVc/6F
        5e2dOxfAPKAmwPGUrmIvnnA=
X-Google-Smtp-Source: APiQypJAWxBoNUs8vRFOmSa70+GttdBRfZ31F3iEsLPfSIWeZ0YvxscN5GsJ8v/OgCgqmm2miDWFVw==
X-Received: by 2002:a63:ee4f:: with SMTP id n15mr14981159pgk.149.1589206276809;
        Mon, 11 May 2020 07:11:16 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id g40sm10650446pje.38.2020.05.11.07.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 07:11:14 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id C270E40605; Mon, 11 May 2020 14:11:13 +0000 (UTC)
Date:   Mon, 11 May 2020 14:11:13 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] net: taint when the device driver firmware crashes
Message-ID: <20200511141113.GP11244@42.do-not-panic.com>
References: <20200509043552.8745-1-mcgrof@kernel.org>
 <20200509113546.7dcd1599@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509113546.7dcd1599@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 11:35:46AM -0700, Jakub Kicinski wrote:
> On Sat,  9 May 2020 04:35:37 +0000 Luis Chamberlain wrote:
> > Device driver firmware can crash, and sometimes, this can leave your
> > system in a state which makes the device or subsystem completely
> > useless. Detecting this by inspecting /proc/sys/kernel/tainted instead
> > of scraping some magical words from the kernel log, which is driver
> > specific, is much easier. So instead this series provides a helper which
> > lets drivers annotate this and shows how to use this on networking
> > drivers.
> > 
> > My methodology for finding when firmware crashes is to git grep for
> > "crash" and then doing some study of the code to see if this indeed
> > a place where the firmware crashes. In some places this is quite
> > obvious.
> > 
> > I'm starting off with networking first, if this gets merged later on I
> > can focus on the other drivers, but I already have some work done on
> > other subsytems.
> > 
> > Review, flames, etc are greatly appreciated.
> 
> Tainting itself may be useful, but that's just the first step. I'd much
> rather see folks start using the devlink health infrastructure. Devlink
> is netlink based, but it's _not_ networking specific (many of its
> optional features obviously are, but don't let that mislead you).
> 
> With devlink health we get (a) a standard notification on the failure; 
> (b) information/state dump in a (somewhat) structured form, which can be
> collected & shared with vendors; (c) automatic remediation (usually
> device reset of some scope).

It indeed sounds very useful!

> Now regarding the tainting - as I said it may be useful, but don't we
> have to define what constitutes a "firmware crash"?

Yes indeed, I missed clarifying this in the documentation. I'll do so
in my next respin.

> There are many
> failure modes, some perfectly recoverable (e.g. processing queue hang), 
> some mere bugs (e.g. device fails to initialize some functions). All of
> them may impact the functioning of the system. How do we choose those
> that taint? 

Its up to the maintainers of the device driver, what I was aiming for
were those firmware crashes which indeed *can* have an impact on user
experience, and can *even* potentially require a driver removal / addition
to to get things back in order again.

  Luis
