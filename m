Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A45A1DD830
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 22:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgEUUWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 16:22:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:28892 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgEUUWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 16:22:35 -0400
IronPort-SDR: XFmOqO7iYudDgs0mDBzMFzwtB83GhMnEFdIgjlEKHcetyiihwfUKsIU5DnpBOV4/b1MKgPICei
 znHX2hJ/FJ9Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 13:22:34 -0700
IronPort-SDR: aw7kmRHYHRsAf4PzE1uGd9lt9RJ4Lq5uRp2M5id7JjDrGrN7I5WSNLi84VAcLEqZjOPKg1TBo4
 oP1WG0q1CQgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="440607564"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.213.183.94]) ([10.213.183.94])
  by orsmga005.jf.intel.com with ESMTP; 21 May 2020 13:22:34 -0700
Subject: Re: devlink interface for asynchronous event/messages from firmware?
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <fea3e7bc-db75-ce15-1330-d80483267ee2@intel.com>
 <20200520171655.08412ba5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <b0435043-269b-9694-b43e-f6740d1862c9@intel.com>
Date:   Thu, 21 May 2020 13:22:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520171655.08412ba5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/20/2020 5:16 PM, Jakub Kicinski wrote:
> On Wed, 20 May 2020 17:03:02 -0700 Jacob Keller wrote:
>> Hi Jiri, Jakub,
>>
>> I've been asked to investigate using devlink as a mechanism for
>> reporting asynchronous events/messages from firmware including
>> diagnostic messages, etc.
>>
>> Essentially, the ice firmware can report various status or diagnostic
>> messages which are useful for debugging internal behavior. We want to be
>> able to get these messages (and relevant data associated with them) in a
>> format beyond just "dump it to the dmesg buffer and recover it later".
>>
>> It seems like this would be an appropriate use of devlink. I thought
>> maybe this would work with devlink health:
>>
>> i.e. we create a devlink health reporter, and then when firmware sends a
>> message, we use devlink_health_report.
>>
>> But when I dug into this, it doesn't seem like a natural fit. The health
>> reporters expect to see an "error" state, and don't seem to really fit
>> the notion of "log a message from firmware" notion.
>>
>> One of the issues is that the health reporter only keeps one dump, when
>> what we really want is a way to have a monitoring application get the
>> dump and then store its contents.
>>
>> Thoughts on what might make sense for this? It feels like a stretch of
>> the health interface...
>>
>> I mean basically what I am thinking of having is using the devlink_fmsg
>> interface to just send a netlink message that then gets sent over the
>> devlink monitor socket and gets dumped immediately.
> 
> Why does user space need a raw firmware interface in the first place?
> 
> Examples?
> 

So the ice firmware can optionally send diagnostic debug messages via
its control queue. The current solutions we've used internally
essentially hex-dump the binary contents to the kernel log, and then
these get scraped and converted into a useful format for human consumption.

I'm not 100% of the format, but I know it's based on a decoding file
that is specific to a given firmware image, and thus attempting to tie
this into the driver is problematic.

There is also a plan to provide a simpler interface for some of the
diagnostic messages where a simple bijection between one code to one
message for a handful of events, like if the link engine can detect a
known reason why it wasn't able to get link. I suppose these could be
translated and immediately printed by the driver without a special
interface.

-Jake
