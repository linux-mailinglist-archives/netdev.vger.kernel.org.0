Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B325D221
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 16:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbfGBOwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 10:52:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:51820 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726283AbfGBOwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 10:52:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 57B0FAF97;
        Tue,  2 Jul 2019 14:52:44 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 686B9E0159; Tue,  2 Jul 2019 16:52:41 +0200 (CEST)
Date:   Tue, 2 Jul 2019 16:52:41 +0200
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
Message-ID: <20190702145241.GD20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <e7fa3ad7e9cf4d7a8f9a2085e3166f7260845b0a.1562067622.git.mkubecek@suse.cz>
 <20190702122521.GN2250@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702122521.GN2250@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 02:25:21PM +0200, Jiri Pirko wrote:
> Tue, Jul 02, 2019 at 01:49:59PM CEST, mkubecek@suse.cz wrote:
> >+Request header
> >+--------------
> >+
> >+Each request or reply message contains a nested attribute with common header.
> >+Structure of this header is
> 
> Missing ":"

OK

> >+
> >+    ETHTOOL_A_HEADER_DEV_INDEX	(u32)		device ifindex
> >+    ETHTOOL_A_HEADER_DEV_NAME	(string)	device name
> >+    ETHTOOL_A_HEADER_INFOMASK	(u32)		info mask
> >+    ETHTOOL_A_HEADER_GFLAGS	(u32)		flags common for all requests
> >+    ETHTOOL_A_HEADER_RFLAGS	(u32)		request specific flags
> >+
> >+ETHTOOL_A_HEADER_DEV_INDEX and ETHTOOL_A_HEADER_DEV_NAME identify the device
> >+message relates to. One of them is sufficient in requests, if both are used,
> >+they must identify the same device. Some requests, e.g. global string sets, do
> >+not require device identification. Most GET requests also allow dump requests
> >+without device identification to query the same information for all devices
> >+providing it (each device in a separate message).
> >+
> >+Optional info mask allows to ask only for a part of data provided by GET
> 
> How this "infomask" works? What are the bits related to? Is that request
> specific?

The interpretation is request specific, the information returned for
a GET request is divided into multiple parts and client can choose to
request one of them (usually one). In the code so far, infomask bits
correspond to top level (nest) attributes but I would rather not make it
a strict rule.

I'll make the paragraph more verbose.

> >+request types. If omitted or zero, all data is returned. The two flag bitmaps
> >+allow enabling requestoptions; ETHTOOL_A_HEADER_GFLAGS are global flags common
> 
> s/requestoptions;/request options./  ?

Yes.

> >+for all request types, flags recognized in ETHTOOL_A_HEADER_RFLAGS and their
> >+interpretation are specific for each request type. Global flags are
> >+
> >+    ETHTOOL_RF_COMPACT		use compact format bitsets in reply
> 
> Why "RF"? Isn't this "GF"? I would like "ETHTOOL_GFLAG_COMPACT" better.

RF as Request Flags. At the moment, global flags use ETHTOOL_RF_name
pattern and request specific flags ETHTOOL_RF_msgtype_name. GFLAG and
RFLAG would probably show the relation better, so how about

  ETHTOOL_GFLAG_name          for global
  ETHTOOL_RFLAG_msgtype_name  for request specific

> >+    ETHTOOL_RF_REPLY		send optional reply (SET and ACT requests)
> >+
> >+Request specific flags are described with each request type. For both flag
> >+attributes, new flags should follow the general idea that if the flag is not
> >+set, the behaviour is the same as (or closer to) the behaviour before it was
> 
> "closer to" ? That would be unfortunate I believe...

There may be situations where it cannot be exactly the same, e.g.
because the flag affects interpretation of an attribute which was
introduced together with the flag. How about "...the behaviour is
backward compatible"?


> >+List of message types
> >+---------------------
> >+
> >+All constants identifying message types use ETHTOOL_CMD_ prefix and suffix
> >+according to message purpose:
> >+
> >+    _GET	userspace request to retrieve data
> >+    _SET	userspace request to set data
> >+    _ACT	userspace request to perform an action
> >+    _GET_REPLY	kernel reply to a GET request
> >+    _SET_REPLY	kernel reply to a SET request
> >+    _ACT_REPLY  kernel reply to an ACT request
> >+    _NTF	kernel notification
> >+
> >+"GET" requests are sent by userspace applications to retrieve device
> >+information. They usually do not contain any message specific attributes.
> >+Kernel replies with corresponding "GET_REPLY" message. For most types, "GET"
> >+request with NLM_F_DUMP and no device identification can be used to query the
> >+information for all devices supporting the request.
> >+
> >+If the data can be also modified, corresponding "SET" message with the same
> >+layout as "GET" reply is used to request changes. Only attributes where
> 
> s/"GET" reply"/"GET_REPLY" ?
> Maybe better to emphasize that the "GET_REPLY" is the one corresponding
> with "SET". But perhaps I got this sentence all wrong :/

OK

> >+a change is requested are included in such request (also, not all attributes
> >+may be changed). Replies to most "SET" request consist only of error code and
> >+extack; if kernel provides additional data, it is sent in the form of
> >+corresponding "SET_REPLY" message (if ETHTOOL_RF_REPLY flag was set in request
> >+header).
> >+
> >+Data modification also triggers sending a "NTF" message with a notification.
> >+These usually bear only a subset of attributes which was affected by the
> >+change. The same notification is issued if the data is modified using other
> >+means (mostly ioctl ethtool interface). Unlike notifications from ethtool
> >+netlink code which are only sent if something actually changed, notifications
> >+triggered by ioctl interface may be sent even if the request did not actually
> >+change any data.
> 
> Interesting. What's the reason for that?

Most setting commands in ioctl interface do not even query the original
state, they just pass the structure from ioctl() to ethtool_ops handler.
We could add retrieving the original state first but I suppose we would
still have to call the handler anyway even if requested values are the
same (as that's what kernel does now) and it's not clear if omitting the
notification in such case is the right thing to do.

> >diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
> >index 3ebfab2bca66..f30e0da88be5 100644
> >--- a/net/ethtool/Makefile
> >+++ b/net/ethtool/Makefile
> >@@ -1,3 +1,7 @@
> > # SPDX-License-Identifier: GPL-2.0
> > 
> >-obj-y		+= ioctl.o
> >+obj-y				+= ioctl.o
> >+
> >+obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
> 
> Hmm, I wonder, why not to make this always on? We want users to use
> it, memory savings in case it is off would be minimal. RTNetlink is also
> always on. Ethtool ioctl is also always on.

We have already discussed this in the previous version. Someone claimed
earlier that building a kernel without ethtool interface would make
sense for some minimalistic systems. My plan is to make the ioctl
interface also optional once it's possible for (sufficiently new)
ethtool to work without it.

Michal
