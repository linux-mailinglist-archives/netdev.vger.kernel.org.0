Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED1237162D
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 15:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbhECNtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 09:49:18 -0400
Received: from mga04.intel.com ([192.55.52.120]:64831 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232195AbhECNtL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 09:49:11 -0400
IronPort-SDR: +FYjd2KjCYWOxdIUG1E2LD2LhxV5vUkD7e1sbjRyRDVM8EsRYT++rsVCyTCtiFyagxjp4QE+ma
 Rpj3f+KMGtbw==
X-IronPort-AV: E=McAfee;i="6200,9189,9973"; a="195687448"
X-IronPort-AV: E=Sophos;i="5.82,270,1613462400"; 
   d="scan'208";a="195687448"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2021 06:48:17 -0700
IronPort-SDR: +xSVnXJbRHsNB+axtW3WmD08iqybp6Qsy2ImH6A/U3h1BkB6kRCmgkqZUW27E1G89RylIp9lXf
 oC5uYYkfK2mw==
X-IronPort-AV: E=Sophos;i="5.82,270,1613462400"; 
   d="scan'208";a="530517064"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2021 06:48:13 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ldYvi-009HHh-Ku; Mon, 03 May 2021 16:48:10 +0300
Date:   Mon, 3 May 2021 16:48:10 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Timo =?iso-8859-1?B?U2NobPzfbGVy?= <schluessler@krause.de>,
        Tim Harvey <tharvey@gateworks.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Null pointer dereference in mcp251x driver when resuming from
 sleep
Message-ID: <YI//GqCv0nkvtQ54@smile.fi.intel.com>
References: <d031629f-4a28-70cd-4f27-e1866c7e1b3f@kontron.de>
 <YI/+OP4z787Tmd05@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YI/+OP4z787Tmd05@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 04:44:24PM +0300, Andy Shevchenko wrote:
> On Mon, May 03, 2021 at 03:11:40PM +0200, Frieder Schrempf wrote:
> > Hi,
> > 
> > with kernel 5.10.x and 5.12.x I'm getting a null pointer dereference
> > exception from the mcp251x driver when I resume from sleep (see trace
> > below).
> > 
> > As far as I can tell this was working fine with 5.4. As I currently don't
> > have the time to do further debugging/bisecting, for now I want to at least
> > report this here.
> > 
> > Maybe there is someone around who could already give a wild guess for what
> > might cause this just by looking at the trace/code!?
> 
> Does revert of c7299fea6769 ("spi: Fix spi device unregister flow") help?

Other than that, bisecting will take not more than 3-4 iterations only:
% git log --oneline v5.4..v5.10.34 -- drivers/net/can/spi/mcp251x.c
3292c4fc9ce2 can: mcp251x: fix support for half duplex SPI host controllers
e0e25001d088 can: mcp251x: add support for half duplex controllers
74fa565b63dc can: mcp251x: Use readx_poll_timeout() helper
2d52dabbef60 can: mcp251x: add GPIO support
cfc24a0aa7a1 can: mcp251x: sort include files alphabetically
df561f6688fe treewide: Use fallthrough pseudo-keyword
8ce8c0abcba3 can: mcp251x: only reset hardware as required
877a902103fd can: mcp251x: add mcp251x_write_2regs() and make use of it
50ec88120ea1 can: mcp251x: get rid of legacy platform data
14684b93019a Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net

-- 
With Best Regards,
Andy Shevchenko


