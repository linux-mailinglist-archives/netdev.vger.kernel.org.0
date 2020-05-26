Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691C11E30FD
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390453AbgEZVN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:13:27 -0400
Received: from mga07.intel.com ([134.134.136.100]:12851 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388900AbgEZVNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 17:13:24 -0400
IronPort-SDR: O2f/8DVrzlyC1aX8oj7NTmz9dqkbUHDQYmH6SivIvN//Do9Z+dtEAkfNf44HOd0jPwDaqQqGW+
 HRPNhmRGslXA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 14:13:23 -0700
IronPort-SDR: DUKU62Bnngw+OENvL3Rxv2Nq0o9mYdUF6oSiatt/puTHaNBYAjZSWIVruiXjJ+NQwfvs6tsIcP
 SbwByOHhlI9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,437,1583222400"; 
   d="scan'208";a="413958008"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.79.132]) ([10.212.79.132])
  by orsmga004.jf.intel.com with ESMTP; 26 May 2020 14:13:22 -0700
Subject: Re: devlink interface for asynchronous event/messages from firmware?
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        petrm@mellanox.com, amitc@mellanox.com
References: <fea3e7bc-db75-ce15-1330-d80483267ee2@intel.com>
 <20200520171655.08412ba5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b0435043-269b-9694-b43e-f6740d1862c9@intel.com>
 <20200521205213.GA1093714@splinter>
 <239b02dc-7a02-dcc3-a67c-85947f92f374@intel.com>
 <20200521145113.21f772bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200522110028.GC2478@nanopsycho>
 <20200522104633.41788851@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <1899d771-cf4b-7f22-3261-5b39feea2f7e@intel.com>
Date:   Tue, 26 May 2020 14:13:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200522104633.41788851@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/2020 10:46 AM, Jakub Kicinski wrote:
> On Fri, 22 May 2020 13:00:28 +0200 Jiri Pirko wrote:
>> Thu, May 21, 2020 at 11:51:13PM CEST, kuba@kernel.org wrote:
>>> For pure debug/tracing perhaps trace_devlink_hwerr() is the right fit?  
>>
>> Well, trace_devlink_hwerr() is for simple errors that are mapped 1:1
>> with some string.
> 
> Ah, damn, I missed it takes char :/

using trace_devlink_hwerr is better than what we *have* been doing at
least. :) I think if we instead made our own driver trace point it might
work well enough.

> 
>> From what I got, Jacob needs to pass some data structures to the
>> user. Something more similar to health reporter dumps and their fmsg.
> 
> For health reporters AFAIU right now every health reporter event
> indicates something bad has happened, so it should be logged and
> potentially reported to the vendor.
> 

Right, that's why I don't think it's a great fit.


> My understanding is that Jake needs more of a tracing infra, for
> debug messages. Is that true? Do you need an on/off switch for 
> those as well?
> 

The messages come over different "modules" of the firmware, I think we
have ~16-20 or so modules, so ideally we'd have an on-off switch for
each module, and there's also a message level range which is sort of
like the dbg, info, err messaging.

The current solution relies on a custom driver build that enables the
logging and the messaging, and uses some module parameters to configure
this stuff. The big downside is that we don't feel the current
implementation can be left in, certainly not upstream. This means,
anytime a firmware engineer says "please get us firmware logs" we have
to reproduce whatever issue with the custom build of the driver.

The value of having this information is a significant increase in
productivity when debugging issues that might be occurring in the
firmware, or in misuse of fw<->driver interfaces, or missed expectations
between developers, etc.

Our goal is to find something that we can safely leave in the driver
that will be off by default, but enabled if necessary to capture the
logging data.

From the sounds of it, maybe the best solution is to implement this as a
trace event. Possibly we could just implement it as a driver-specific
trace event so it'd show up in tracing/events/<driver>/fwlogs, or
something like that. That still leaves open the question of the best way
to configure which modules and levels are enabled...

This debug logging is separate from a similar-sounding system that is
intended to report non-debug messages such as link-failure reason. I do
agree that something like that ought to instead be handled by the driver
determining "oh this is a link failure indication, so I'll report it
over the ethtool netlink interface, and convert it to the value expected
by that interface".

I'm not sure what other data besides link-failure reporting that is
intended to be sent in this simpler format, as I haven't gotten any
other examples yet. The intent was to have these messages displayed by
doing a simple lookup from code to message, as there would be
significantly fewer of these and they are intended to help guide system
administrators. But given that the only example I've seen so far is the
link messages, it's unclear to me what else they would be used for.

And just to clarify, in either case the intention is that these are
one-way and read-only interfaces.

Thanks,
Jake
