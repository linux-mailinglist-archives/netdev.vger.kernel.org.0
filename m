Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618872333A3
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 15:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbgG3N5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 09:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728286AbgG3N5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 09:57:45 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC54C061574;
        Thu, 30 Jul 2020 06:57:45 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k192s-00DYvR-Pl; Thu, 30 Jul 2020 15:56:30 +0200
Message-ID: <943c5eaf12bc9e92e817fb9818ebd65038f5fb54.camel@sipsolutions.net>
Subject: Re: [RFC 1/2] devlink: add simple fw crash helpers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, derosier@gmail.com,
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
Date:   Thu, 30 Jul 2020 15:56:25 +0200
In-Reply-To: <20200525135746.45e764de@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20200519010530.GS11244@42.do-not-panic.com>
         <20200519211531.3702593-1-kuba@kernel.org>
         <20200522052046.GY11244@42.do-not-panic.com>
         <20200522101738.1495f4cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <2e5199edb433c217c7974ef7408ff8c7253145b6.camel@sipsolutions.net>
         <20200525135746.45e764de@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 (3.36.4-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sorry ... long delay.

> > The reason I'm asking is that it's starting to sound like we really
> > ought to be implementing devlink, but we've got a bunch of
> > infrastructure that uses the devcoredump, and it'll take time
> > (significantly so) to change all that...
> 
> In devlink world pure FW core dumps are exposed by devlink regions.
> An API allowing reading device memory, registers, etc., but also 
> creating dumps of memory regions when things go wrong. It should be
> a fairly straightforward migration.

Right. We also have regions (various memory pieces, registers, ...).

One issue might be that for devlink we wouldn't want to expose these as
a single blob, I guess, but for devcoredump we already have a custom
format to glue all the things together. Since it seems unlikely that
anyone else would want to use the *iwlwifi* format to glue things
together, we'd have to do something there.

But perhaps that could be a matter of providing a "glue things into a
devcoredump" function that would have a reasonable default but could be
overridden by the driver for those migration cases.

> Devlink health is more targeted, the dump is supposed to contain only
> relevant information, selected and formatted by the driver. When device
> misbehaves driver reads the relevant registers and FW state and creates
> a formatted state dump. I believe each element of the dump must fit
> into a netlink message (but there may be multiple elements, see
> devlink_fmsg_prepare_skb()).

That wouldn't help for our big memory dumps, but OK.

> We should be able to convert dl-regions dumps and dl-health dumps into
> devcoredumps, but since health reporters are supposed to be more
> targeted there's usually multiple of them per device.

Right.

> Conversely devcoredumps can be trivially exposed as dl-region dumps,
> but I believe dl-health would require driver changes to format the
> information appropriately.

Agree.

Anyway, thanks. I'll put it on my list of things to look at ... not too
hopeful that will be soon, given how long it even took me to get back to
this email :)

johannes

