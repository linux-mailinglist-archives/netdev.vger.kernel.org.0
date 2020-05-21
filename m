Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B3D1DD8FF
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 22:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730422AbgEUU7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 16:59:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:10064 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgEUU7d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 16:59:33 -0400
IronPort-SDR: ueYZ0LThR4gXpzsxNGY15S/oGCodAZCvIc1YiceO/cCbSWMr9QJsPfMcJ3jvsFUFQFEVTvXDqk
 oefVG7VgWeCQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 13:59:32 -0700
IronPort-SDR: 5EXsJBCTPLAv1r0lrfI/hoXWxEBjf1Y316uDFhGqPfZPnJndSPD3PIgVhIWGkTlUpx0I7xUEL+
 CxkHHrJCLS0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="440617680"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.213.183.94]) ([10.213.183.94])
  by orsmga005.jf.intel.com with ESMTP; 21 May 2020 13:59:32 -0700
Subject: Re: devlink interface for asynchronous event/messages from firmware?
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        petrm@mellanox.com, amitc@mellanox.com
References: <fea3e7bc-db75-ce15-1330-d80483267ee2@intel.com>
 <20200520171655.08412ba5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b0435043-269b-9694-b43e-f6740d1862c9@intel.com>
 <20200521205213.GA1093714@splinter>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <239b02dc-7a02-dcc3-a67c-85947f92f374@intel.com>
Date:   Thu, 21 May 2020 13:59:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521205213.GA1093714@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/21/2020 1:52 PM, Ido Schimmel wrote:
> On Thu, May 21, 2020 at 01:22:34PM -0700, Jacob Keller wrote:
>> On 5/20/2020 5:16 PM, Jakub Kicinski wrote:
>>> On Wed, 20 May 2020 17:03:02 -0700 Jacob Keller wrote:
>>>> Hi Jiri, Jakub,
>>>>
>>>> I've been asked to investigate using devlink as a mechanism for
>>>> reporting asynchronous events/messages from firmware including
>>>> diagnostic messages, etc.
>>>>
>>>> Essentially, the ice firmware can report various status or diagnostic
>>>> messages which are useful for debugging internal behavior. We want to be
>>>> able to get these messages (and relevant data associated with them) in a
>>>> format beyond just "dump it to the dmesg buffer and recover it later".
>>>>
>>>> It seems like this would be an appropriate use of devlink. I thought
>>>> maybe this would work with devlink health:
>>>>
>>>> i.e. we create a devlink health reporter, and then when firmware sends a
>>>> message, we use devlink_health_report.
>>>>
>>>> But when I dug into this, it doesn't seem like a natural fit. The health
>>>> reporters expect to see an "error" state, and don't seem to really fit
>>>> the notion of "log a message from firmware" notion.
>>>>
>>>> One of the issues is that the health reporter only keeps one dump, when
>>>> what we really want is a way to have a monitoring application get the
>>>> dump and then store its contents.
>>>>
>>>> Thoughts on what might make sense for this? It feels like a stretch of
>>>> the health interface...
>>>>
>>>> I mean basically what I am thinking of having is using the devlink_fmsg
>>>> interface to just send a netlink message that then gets sent over the
>>>> devlink monitor socket and gets dumped immediately.
>>>
>>> Why does user space need a raw firmware interface in the first place?
>>>
>>> Examples?
>>>
>>
>> So the ice firmware can optionally send diagnostic debug messages via
>> its control queue. The current solutions we've used internally
>> essentially hex-dump the binary contents to the kernel log, and then
>> these get scraped and converted into a useful format for human consumption.
>>
>> I'm not 100% of the format, but I know it's based on a decoding file
>> that is specific to a given firmware image, and thus attempting to tie
>> this into the driver is problematic.
> 
> You explained how it works, but not why it's needed :)

Well, the reason we want it is to be able to read the debug/diagnostics
data in order to debug issues that might be related to firmware or
software mis-use of firmware interfaces.

By having it be a separate interface rather than trying to scrape from
the kernel message buffer, it becomes something we can have as a
possibility for debugging in the field.

> 
>> There is also a plan to provide a simpler interface for some of the
>> diagnostic messages where a simple bijection between one code to one
>> message for a handful of events, like if the link engine can detect a
>> known reason why it wasn't able to get link. I suppose these could be
>> translated and immediately printed by the driver without a special
>> interface.
> 
> Petr worked on something similar last year:
> https://lore.kernel.org/netdev/cover.1552672441.git.petrm@mellanox.com/
> 
> Amit is currently working on a new version based on ethtool (netlink).
> 

I'll take a look, thanks!

-Jake
