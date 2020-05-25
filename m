Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141951E09B5
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 11:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389339AbgEYJH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 05:07:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:18280 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389329AbgEYJH4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 05:07:56 -0400
IronPort-SDR: TwTGpNA9I0nt35eU9+sFcIXDiLghL9hQ99AStf5mZH78yEhh8ApDE3dRF017AnoOcYXNUk5wqX
 wVDIK0gmBEfQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2020 02:07:55 -0700
IronPort-SDR: 2hLbY16UNixp9uKwA+HoIovAgK51uxmidktw1TbuKfD5n9hRLrdAJfizedCATlB4/xfOf6J+bL
 +7VHvJIgi+Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,432,1583222400"; 
   d="scan'208";a="301770713"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008.jf.intel.com with ESMTP; 25 May 2020 02:07:47 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jd95J-008ktF-4y; Mon, 25 May 2020 12:07:49 +0300
Date:   Mon, 25 May 2020 12:07:49 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Steve deRosier <derosier@gmail.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ben Greear <greearb@candelatech.com>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com,
        Takashi Iwai <tiwai@suse.de>, schlad@suse.de,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, will@kernel.org,
        mchehab+samsung@kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org, jiri@resnulli.us,
        briannorris@chromium.org
Subject: Re: [RFC 1/2] devlink: add simple fw crash helpers
Message-ID: <20200525090749.GJ1634618@smile.fi.intel.com>
References: <20200519010530.GS11244@42.do-not-panic.com>
 <20200519211531.3702593-1-kuba@kernel.org>
 <20200522052046.GY11244@42.do-not-panic.com>
 <20200522101738.1495f4cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2e5199edb433c217c7974ef7408ff8c7253145b6.camel@sipsolutions.net>
 <20200522215145.GC11244@42.do-not-panic.com>
 <CALLGbR+QPcECtJbYmzztV_Qysc5qtwujT_qc785zvhZMCH50fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLGbR+QPcECtJbYmzztV_Qysc5qtwujT_qc785zvhZMCH50fg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 04:23:55PM -0700, Steve deRosier wrote:
> On Fri, May 22, 2020 at 2:51 PM Luis Chamberlain <mcgrof@kernel.org> wrote:

> I had to go RTFM re: kernel taints because it has been a very long
> time since I looked at them. It had always seemed to me that most were
> caused by "kernel-unfriendly" user actions.  The most famous of course
> is loading proprietary modules, out-of-tree modules, forced module
> loads, etc...  Honestly, I had forgotten the large variety of uses of
> the taint flags. For anyone who hasn't looked at taints recently, I
> recommend: https://www.kernel.org/doc/html/latest/admin-guide/tainted-kernels.html
> 
> In light of this I don't object to setting a taint on this anymore.
> I'm a little uneasy, but I've softened on it now, and now I feel it
> depends on implementation.
> 
> Specifically, I don't think we should set a taint flag when a driver
> easily handles a routine firmware crash and is confident that things
> have come up just fine again. In other words, triggering the taint in
> every driver module where it spits out a log comment that it had a
> firmware crash and had to recover seems too much. Sure, firmware
> shouldn't crash, sure it should be open source so we can fix it,
> whatever...

While it may sound idealistic the firmware for the end-user, and even for mere
kernel developer like me, is a complete blackbox which has more access than
root user in the kernel. We have tons of firmwares and each of them potentially
dangerous beast. As a user I really care about my data and privacy (hacker can
oops a firmware in order to set a specific vector attack). So, tainting kernel
is _a least_ we can do there, the strict rules would be to reboot immediately.

> those sort of wishful comments simply ignore reality and
> our ability to affect effective change.

We can encourage users not to buy cheap crap for the starter.

> A lot of WiFi firmware crashes
> and for well-known cases the drivers handle them well. And in some
> cases, not so well and that should be a place the driver should detect
> and thus raise a red flag.  If a WiFi firmware crash can bring down
> the kernel, there's either a major driver bug or some very funky
> hardware crap going on. That sort of thing we should be able to
> detect, mark with a taint (or something), and fix if within our sphere
> of influence. I guess what it comes down to me is how aggressive we
> are about setting the flag.

-- 
With Best Regards,
Andy Shevchenko


