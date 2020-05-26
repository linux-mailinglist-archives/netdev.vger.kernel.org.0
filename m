Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F211E30CB
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389362AbgEZVAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:00:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:39194 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389124AbgEZVAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 17:00:32 -0400
IronPort-SDR: s9skT7KOaKB7sE4Ryze84OPFJhyjvp33zcDNUJy97nTLGTvDKMPzs3UuRwWiih0boBIg97jg6R
 rgxnyHd+jMOQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 14:00:31 -0700
IronPort-SDR: g2QwqBqtg81DqwjuC9cs6bCfZ6GgQVV8alqPgaIV01y6Wcp17AjCOmNc+8vHzvaUpOZLYFflgQ
 hJr81UIqA/dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,437,1583222400"; 
   d="scan'208";a="413954883"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.79.132]) ([10.212.79.132])
  by orsmga004.jf.intel.com with ESMTP; 26 May 2020 14:00:30 -0700
Subject: Re: devlink interface for asynchronous event/messages from firmware?
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
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
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <e0f8f797-f7c5-efe6-0e40-8e5fb161a7ff@intel.com>
Date:   Tue, 26 May 2020 14:00:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200522110028.GC2478@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/2020 4:00 AM, Jiri Pirko wrote:
> Thu, May 21, 2020 at 11:51:13PM CEST, kuba@kernel.org wrote:
>> On Thu, 21 May 2020 13:59:32 -0700 Jacob Keller wrote:
>>>>> So the ice firmware can optionally send diagnostic debug messages via
>>>>> its control queue. The current solutions we've used internally
>>>>> essentially hex-dump the binary contents to the kernel log, and then
>>>>> these get scraped and converted into a useful format for human consumption.
>>>>>
>>>>> I'm not 100% of the format, but I know it's based on a decoding file
>>>>> that is specific to a given firmware image, and thus attempting to tie
>>>>> this into the driver is problematic.  
>>>>
>>>> You explained how it works, but not why it's needed :)  
>>>
>>> Well, the reason we want it is to be able to read the debug/diagnostics
>>> data in order to debug issues that might be related to firmware or
>>> software mis-use of firmware interfaces.
>>>
>>> By having it be a separate interface rather than trying to scrape from
>>> the kernel message buffer, it becomes something we can have as a
>>> possibility for debugging in the field.
>>
>> For pure debug/tracing perhaps trace_devlink_hwerr() is the right fit?
> 
> Well, trace_devlink_hwerr() is for simple errors that are mapped 1:1
> with some string. From what I got, Jacob needs to pass some data
> structures to the user. Something more similar to health reporter dumps
> and their fmsg.
> 

Right. From my understanding the messages for debugging are not in a
format that can be immediately turned into a text string.

The reasoning behind this is that the set of messages changes,
(especially during early firmware bringup) and thus sending actual ASCII
messages doesn't work well. It goes back to the "firmware is a black box".

The problem is that in practice, we need ways to help debug this black
box, and this was one method that doesn't require hooking up a more
expensive device to intercept and debug with a step-through debugger. It
also enables capturing more verbose information about what the firmware
is doing.

But from how I understand it, the messages can't really be immediately
interpreted into usable format by the kernel. I suppose in theory they
could but it then requires carrying the full translation table.

Today, this is done by using a custom driver which logs the messages
directly to the kernel log buffer, which we know isn't the best solution.

Using a trace point is less bad, since that goes into the tracefs, and
will be disabled by default and goes into the tracefs system instead of
going into the default print buffer...

The pain is the fact that we have to request loading a custom driver
that enables these prints, meaning that it is harder to obtain the data
than if we can just say "enable firmware logs, reproduce the issue, and
grab this data"

Thanks,
Jake
