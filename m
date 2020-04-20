Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5EA1B04B4
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 10:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgDTInY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 04:43:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:15992 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgDTInX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 04:43:23 -0400
IronPort-SDR: h0lYUhWJZdooRot5/D6i4tHIo4pA1sefPqFOqsLqlRmss7ekuU4SBK/deZaIujNKTqkUgq+NPo
 aoWctAx2Ztpw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 01:43:21 -0700
IronPort-SDR: lSsNa/ish74j6oe4by+cDFOKlC8LCWgp3ExdSfVUMqp21bW54LB3nnX+4ZKKJBzmLXQYApaB8d
 IXoKfosg8Emg==
X-IronPort-AV: E=Sophos;i="5.72,406,1580803200"; 
   d="scan'208";a="429047884"
Received: from iastakh-mobl.ccr.corp.intel.com (HELO localhost) ([10.252.63.229])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 01:43:16 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Leon Romanovsky <leon@kernel.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        jonas@kwiboo.se, David Airlie <airlied@linux.ie>,
        jernej.skrabec@siol.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
In-Reply-To: <CAK7LNATmPD1R+Ranis2u3yohx8b0+dGKAvFpjg8Eo9yEHRT6zQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20200417011146.83973-1-saeedm@mellanox.com> <CAK7LNAQZd_LUyA2V_pCvMTr_201nSX1Nm0TDw5kOeNV64rOfpA@mail.gmail.com> <nycvar.YSQ.7.76.2004181509030.2671@knanqh.ubzr> <CAK7LNATmPD1R+Ranis2u3yohx8b0+dGKAvFpjg8Eo9yEHRT6zQ@mail.gmail.com>
Date:   Mon, 20 Apr 2020 11:43:13 +0300
Message-ID: <87v9lu1ra6.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Apr 2020, Masahiro Yamada <masahiroy@kernel.org> wrote:
> On Sun, Apr 19, 2020 at 4:11 AM Nicolas Pitre <nico@fluxnic.net> wrote:
>>
>> On Sun, 19 Apr 2020, Masahiro Yamada wrote:
>>
>> > (FOO || !FOO) is difficult to understand, but
>> > the behavior of "uses FOO" is as difficult to grasp.
>>
>> Can't this be expressed as the following instead:
>>
>>         depends on FOO if FOO
>>
>> That would be a little clearer.
>>
>>
>> Nicolas
>
>
>
> 'depends on' does not take the 'if <expr>'
>
> 'depends on A if B' is the syntax sugar of
> 'depends on (A || !B), right ?
>
> I do not know how clearer it would make things.
>
> depends on (m || FOO != m)
> is another equivalent, but we are always
> talking about a matter of expression.
>
>
> How important is it to stick to
> depends on (FOO || !FOO)
> or its equivalents?
>
>
> If a driver wants to use the feature FOO
> in most usecases, 'depends on FOO' is sensible.
>
> If FOO is just optional, you can get rid of the dependency,
> and IS_REACHABLE() will do logically correct things.

If by logically correct you mean the kernel builds, you're
right. However the proliferation of IS_REACHABLE() is making the kernel
config *harder* to understand. User enables FOO=m and expects BAR to use
it, however if BAR=y it silently gets ignored. I have and I will oppose
adding IS_REACHABLE() usage to i915 because it's just silently accepting
configurations that should be flagged and forbidden at kconfig stage.

> I do not think IS_REACHABLE() is too bad,
> but if it is confusing, we can add one more
> option to make it explicit.
>
>
>
> config DRIVER_X
>        tristate "driver x"
>
> config DRIVER_X_USES_FOO
>        bool "use FOO from driver X"
>        depends on DRIVER_X
>        depends on DRIVER_X <= FOO
>        help
>          DRIVER_X works without FOO, but
>          Using FOO will provide better usability.
>          Say Y if you want to make driver X use FOO.
>
>
>
> Of course,
>
>       if (IS_ENABLED(CONFIG_DRIVER_X_USES_FOO))
>                foo_init();
>
> works like
>
>       if (IS_REACHABLE(CONFIG_FOO))
>                 foo_init();
>
>
> At lease, it will eliminate a question like
> "I loaded the module FOO, I swear.
> But my built-in driver X still would not use FOO, why?"

Please let's not make that a more widespread problem than it already
is. I have yet to hear *one* good rationale for allowing that in the
first place. And if that pops up, you can make it work by using
IS_REACHABLE() *without* the depends, simply by checking if the module
is there.

Most use cases increasingly solved by IS_REACHABLE() should use the
"depends on FOO || FOO=n" construct, but the problem is that's not
widely understood. I'd like to have another keyword for people to
copy-paste into their Kconfigs.

In another mail I suggested

	optionally depends on FOO

might be a better alternative than "uses".


BR,
Jani.

-- 
Jani Nikula, Intel Open Source Graphics Center
