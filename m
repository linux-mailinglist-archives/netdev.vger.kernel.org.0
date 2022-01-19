Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BBD49423C
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 21:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245407AbiASU63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 15:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245242AbiASU60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 15:58:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A3BC061574;
        Wed, 19 Jan 2022 12:58:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0646B81B40;
        Wed, 19 Jan 2022 20:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD93AC340E1;
        Wed, 19 Jan 2022 20:58:19 +0000 (UTC)
Date:   Wed, 19 Jan 2022 15:58:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>, Eryk Brol <eryk.brol@amd.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Petr Mladek <pmladek@suse.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [PATCH 1/3] lib/string_helpers: Consolidate yesno()
 implementation
Message-ID: <20220119155818.7ab45e0e@gandalf.local.home>
In-Reply-To: <YehlEe1prbwhxZEv@smile.fi.intel.com>
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
        <20220119072450.2890107-2-lucas.demarchi@intel.com>
        <CAHp75Vf5QOD_UtDK8VbxNApEBuJvzUic0NkzDNmRo3Q7Ud+=qw@mail.gmail.com>
        <20220119100102.61f9bfde@gandalf.local.home>
        <06420a70f4434c2b8590cc89cad0dd6a@AcuMS.aculab.com>
        <9c26ca9bf75d494ea966059d9bcbc2b5@AcuMS.aculab.com>
        <YehlEe1prbwhxZEv@smile.fi.intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jan 2022 21:22:57 +0200
Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> On Wed, Jan 19, 2022 at 04:38:26PM +0000, David Laight wrote:
> > > > > > +static inline const char *yesno(bool v) { return v ? "yes" : "no"; }  
> > > 
> > > 	return "yes\0no" + v * 4;
> > > 
> > > :-)  
> > 
> > except '"no\0\0yes" + v * 4' works a bit better.  
> 
> Is it a C code obfuscation contest?
> 

	return '/'/'/';

-- Steve
