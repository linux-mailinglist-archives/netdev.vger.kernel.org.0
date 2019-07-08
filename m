Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBEB46270C
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 19:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733129AbfGHR1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 13:27:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:42434 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728744AbfGHR1d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 13:27:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 65D94AFE2;
        Mon,  8 Jul 2019 17:27:31 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 9676BE00B7; Mon,  8 Jul 2019 19:27:29 +0200 (CEST)
Date:   Mon, 8 Jul 2019 19:27:29 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 04/15] ethtool: introduce ethtool netlink
 interface
Message-ID: <20190708172729.GC24474@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <e7fa3ad7e9cf4d7a8f9a2085e3166f7260845b0a.1562067622.git.mkubecek@suse.cz>
 <20190702122521.GN2250@nanopsycho>
 <20190702145241.GD20101@unicorn.suse.cz>
 <20190703084151.GR2250@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703084151.GR2250@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 10:41:51AM +0200, Jiri Pirko wrote:
> Tue, Jul 02, 2019 at 04:52:41PM CEST, mkubecek@suse.cz wrote:
> >On Tue, Jul 02, 2019 at 02:25:21PM +0200, Jiri Pirko wrote:
> >> Tue, Jul 02, 2019 at 01:49:59PM CEST, mkubecek@suse.cz wrote:
> >> >+
> >> >+    ETHTOOL_A_HEADER_DEV_INDEX	(u32)		device ifindex
> >> >+    ETHTOOL_A_HEADER_DEV_NAME	(string)	device name
> >> >+    ETHTOOL_A_HEADER_INFOMASK	(u32)		info mask
> >> >+    ETHTOOL_A_HEADER_GFLAGS	(u32)		flags common for all requests
> >> >+    ETHTOOL_A_HEADER_RFLAGS	(u32)		request specific flags
> >> >+
> >> >+ETHTOOL_A_HEADER_DEV_INDEX and ETHTOOL_A_HEADER_DEV_NAME identify the device
> >> >+message relates to. One of them is sufficient in requests, if both are used,
> >> >+they must identify the same device. Some requests, e.g. global string sets, do
> >> >+not require device identification. Most GET requests also allow dump requests
> >> >+without device identification to query the same information for all devices
> >> >+providing it (each device in a separate message).
> >> >+
> >> >+Optional info mask allows to ask only for a part of data provided by GET
> >> 
> >> How this "infomask" works? What are the bits related to? Is that request
> >> specific?
> >
> >The interpretation is request specific, the information returned for
> >a GET request is divided into multiple parts and client can choose to
> >request one of them (usually one). In the code so far, infomask bits
> >correspond to top level (nest) attributes but I would rather not make it
> >a strict rule.
> 
> Wait, so it is a matter of verbosity? If you have multiple parts and the
> user is able to chose one of them, why don't you rather have multiple
> get commands, one per bit. This infomask construct seems redundant to me.

I thought it was a matter of verbosity because it is a very basic
element of the design, it was even advertised in the cover letter among
the basic ideas, it has been there since the very beginning and in five
previous versions through year and a half, noone did question it. That's
why I thought you objected against unclear description, not against the
concept as such.

There are two reasons for this design. First is to reduce the number of
requests needed to get the information. This is not so much a problem of
ethtool itself; the only existing commands that would result in multiple
request messages would be "ethtool <dev>" and "ethtool -s <dev>". Maybe
also "ethtool -x/-X <dev>" but even if the indirection table and hash
key have different bits assigned now, they don't have to be split even
if we split other commands. It may be bigger problem for daemons wanting
to keep track of system configuration which would have to issue many
requests whenever a new device appears.

Second reason is that with 8-bit genetlink command/message id, the space
is not as infinite as it might seem. I counted quickly, right now the
full series uses 14 ids for kernel messages, with split you propose it
would most likely grow to 44. For full implementation of all ethtool
functionality, we could get to ~60 ids. It's still only 1/4 of the
available space but it's not clear what the future development will look
like. We would certainly need to be careful not to start allocating new
commands for single parameters and try to be foreseeing about what can
be grouped together. But we will need to do that in any case.

On kernel side, splitting existing messages would make some things a bit
easier. It would also reduce the number of scenarios where only part of
requested information is available or only part of a SET request fails.

Michal
