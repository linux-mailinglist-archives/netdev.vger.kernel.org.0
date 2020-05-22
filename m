Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C27A1DEE03
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 19:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730774AbgEVRRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 13:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730471AbgEVRRm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 13:17:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8464720738;
        Fri, 22 May 2020 17:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590167861;
        bh=JHvmQjCIw6/VvDscVfT+qCoWQLdg5aBrXbxB+sIlVv0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GWXiRViM+TXrBlInvfPJxiOUc0PtnWfYnR+Kujxt16bktx0kcR2oZWEzGOIuQm1fL
         r82t5OiPZMiJUTvwWrR1pwArgfPhI6rQ9oGnsHR601aIjzsQ5I+LDFuvPR1kdmqmiO
         cZkTQP4IInjzhZbjCiGd3ZDDM+Y8IkZ2KIm3oeRE=
Date:   Fri, 22 May 2020 10:17:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     johannes@sipsolutions.net, derosier@gmail.com,
        greearb@candelatech.com, jeyu@kernel.org,
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
Subject: Re: [RFC 1/2] devlink: add simple fw crash helpers
Message-ID: <20200522101738.1495f4cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200522052046.GY11244@42.do-not-panic.com>
References: <20200519010530.GS11244@42.do-not-panic.com>
        <20200519211531.3702593-1-kuba@kernel.org>
        <20200522052046.GY11244@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 May 2020 05:20:46 +0000 Luis Chamberlain wrote:
> > diff --git a/net/core/Makefile b/net/core/Makefile
> > index 3e2c378e5f31..6f1513781c17 100644
> > --- a/net/core/Makefile
> > +++ b/net/core/Makefile
> > @@ -31,7 +31,7 @@ obj-$(CONFIG_LWTUNNEL_BPF) += lwt_bpf.o
> >  obj-$(CONFIG_BPF_STREAM_PARSER) += sock_map.o
> >  obj-$(CONFIG_DST_CACHE) += dst_cache.o
> >  obj-$(CONFIG_HWBM) += hwbm.o
> > -obj-$(CONFIG_NET_DEVLINK) += devlink.o
> > +obj-$(CONFIG_NET_DEVLINK) += devlink.o devlink_simple_fw_reporter.o  
> 
> This was looking super sexy up to here. This is networking specific.
> We want something generic for *anything* that requests firmware.

You can't be serious. It's network specific because of how the Kconfig
is named?

Working for a company operating large data centers I would strongly
prefer if we didn't have ten different ways of reporting firmware
problems in the fleet.

> I'm afraid this won't work for something generic. I don't think its
> throw-away work though, the idea to provide a generic interface to
> dump firmware through netlink might be nice for networking, or other
> things.
> 
> But I have a feeling we'll want something still more generic than this.

Please be specific. Saying generic a lot is not helpful. The code (as
you can see in this patch) is in no way network specific. Or are you
saying there are machines out there running without netlink sockets?

> So networking may want to be aware that a firmware crash happened as
> part of this network device health thing, but firmware crashing is a
> generic thing.
> 
> I have now extended my patch set to include uvents and I am more set on
> that we need the taint now more than ever.

Please expect my nack if you're trying to add this to networking
drivers.

The irony is you have a problem with a networking device and all the
devices your initial set touched are networking. Two of the drivers 
you touched either have or will soon have devlink health reporters
implemented.
