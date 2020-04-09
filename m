Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79C281A310F
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 10:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgDIIlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 04:41:17 -0400
Received: from mga12.intel.com ([192.55.52.136]:18402 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbgDIIlR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 04:41:17 -0400
IronPort-SDR: BUIQ9jcktPupZ+KATaEXNsjE+VZy0p1LUdJ/Iw+Y9pv6HQmpgINhXybTeZMmuUImrNcRqCA2b+
 G0JRF0BpApQA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2020 01:41:17 -0700
IronPort-SDR: VRkD0xl0Hi3Ldvuf0kEfJ8F4gCAOL43B4AsAFq3BlZ1Jho9cZYh4n5YVd8dXC/Z9fBC7Vpc3HU
 VNRFRnBMmHYQ==
X-IronPort-AV: E=Sophos;i="5.72,362,1580803200"; 
   d="scan'208";a="425437262"
Received: from ashakhno-mobl.ccr.corp.intel.com (HELO localhost) ([10.252.61.38])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2020 01:41:10 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>
Cc:     Jernej Skrabec <jernej.skrabec@siol.net>,
        Leon Romanovsky <leon@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        David Airlie <airlied@linux.ie>,
        Networking <netdev@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-rdma <linux-rdma@vger.kernel.org>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
In-Reply-To: <20200408224224.GD11886@ziepe.ca>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20200408202711.1198966-1-arnd@arndb.de> <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr> <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com> <20200408224224.GD11886@ziepe.ca>
Date:   Thu, 09 Apr 2020 11:41:08 +0300
Message-ID: <87k12pgifv.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 08 Apr 2020, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Wed, Apr 08, 2020 at 10:49:48PM +0200, Arnd Bergmann wrote:
>> On Wed, Apr 8, 2020 at 10:38 PM Nicolas Pitre <nico@fluxnic.net> wrote:
>> > On Wed, 8 Apr 2020, Arnd Bergmann wrote:
>> > > I have created workarounds for the Kconfig files, which now stop using
>> > > imply and do something else in each case. I don't know whether there was
>> > > a bug in the kconfig changes that has led to allowing configurations that
>> > > were not meant to be legal even with the new semantics, or if the Kconfig
>> > > files have simply become incorrect now and the tool works as expected.
>> >
>> > In most cases it is the code that has to be fixed. It typically does:
>> >
>> >         if (IS_ENABLED(CONFIG_FOO))
>> >                 foo_init();
>> >
>> > Where it should rather do:
>> >
>> >         if (IS_REACHABLE(CONFIG_FOO))
>> >                 foo_init();
>> >
>> > A couple of such patches have been produced and queued in their
>> > respective trees already.
>> 
>> I try to use IS_REACHABLE() only as a last resort, as it tends to
>> confuse users when a subsystem is built as a module and already
>> loaded but something relying on that subsystem does not use it.
>> 
>> In the six patches I made, I had to use IS_REACHABLE() once,
>> for the others I tended to use a Kconfig dependency like
>> 
>> 'depends on FOO || FOO=n'
>
> It is unfortunate kconfig doesn't have a language feature for this
> idiom, as the above is confounding without a lot of kconfig knowledge
>
>> I did come up with the IS_REACHABLE() macro originally, but that
>> doesn't mean I think it's a good idea to use it liberally ;-)
>
> It would be nice to have some uniform policy here
>
> I also don't like the IS_REACHABLE solution, it makes this more
> complicated, not less..

Just chiming "me too" here.

IS_REACHABLE() is not a solution, it's a hack to hide a dependency link
problem under the carpet, in a way that is difficult for the user to
debug and figure out.

The user thinks they've enabled a feature, but it doesn't get used
anyway, because a builtin depends on something that is a module and
therefore not reachable. Can someone please give me an example where
that kind of behaviour is desirable?

AFAICT IS_REACHABLE() is becoming more and more common in the kernel,
but arguably it's just making more undesirable configurations
possible. Configurations that should simply be blocked by using suitable
dependencies on the Kconfig level.

For example, you have two graphics drivers, one builtin and another
module. Then you have backlight as a module. Using IS_REACHABLE(),
backlight would work in one driver, but not the other. I'm sure there is
the oddball person who finds this desirable, but the overwhelming
majority would just make the deps such that either you make all of them
modules, or also require backlight to be builtin.


BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center
