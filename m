Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD45F269991
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgINXTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:19:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:41603 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgINXTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 19:19:12 -0400
IronPort-SDR: Nb4b08ecAWCuTkt2IOsbE7+ACVMyof7WvEFfyRT7uPlO9nUgoGG3EGFnggiDZ2hdoGGN63LzTi
 EHd4vHIpOnmw==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="146863595"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="146863595"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 16:19:10 -0700
IronPort-SDR: jD0tUzff6uJA3IQs9Cl+wJYxcjkW2NVl+pMVWx2oLT5vwd8/VxToY3PiNkRXeZ+gelnRxdsUgB
 bnBFzbFlk9UQ==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482533572"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.252.142.25]) ([10.252.142.25])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 16:19:10 -0700
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
To:     Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200908224812.63434-1-snelson@pensando.io>
 <20200908224812.63434-3-snelson@pensando.io>
 <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
 <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
 <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3d75c4be-ae5d-43b0-407c-5df1e7645447@pensando.io>
 <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <93b7cd42-0af7-6066-ba42-a18755f84863@intel.com>
Date:   Mon, 14 Sep 2020 16:19:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 10:56 AM, Jakub Kicinski wrote:
> On Wed, 9 Sep 2020 18:34:57 -0700 Shannon Nelson wrote:
>> On 9/9/20 12:22 PM, Jakub Kicinski wrote:
>>> On Wed, 9 Sep 2020 10:58:19 -0700 Shannon Nelson wrote:  
>>>>
>>>> I'm suggesting that this implementation using the existing devlink
>>>> logging services should suffice until someone can design, implement, and
>>>> get accepted a different bit of plumbing.  Unfortunately, that's not a
>>>> job that I can get to right now.  
>>> This hack is too nasty to be accepted.  
>>
>> Your comment earlier was
>>
>>  > I wonder if we can steal a page from systemd's book and display
>>  > "time until timeout", or whatchamacallit, like systemd does when it's
>>  > waiting for processes to quit. All drivers have some timeout set on the
>>  > operation. If users knew the driver sets timeout to n minutes and they
>>  > see the timer ticking up they'd be less likely to think the command has
>>  > hanged..  
>>
>> I implemented the loop such that the timeout value was the 100%, and 
>> each time through the loop the elapsed time value is sent, so the user 
>> gets to see the % value increasing as the wait goes on, in the same way 
>> they see the download progress percentage ticking away. 
> 
> Right but you said that in most cases the value never goes up to 25min,
> so user will see the value increment from 0 to say 5% very slowly and
> then jump to 100%.
> 
>> This is how I approached the stated requirement of user seeing the
>> "timer ticking up", using the existing machinery.  This seems to be
>> how devlink_flash_update_status_notify() is expected to be used, so
>> I'm a little surprised at the critique.
> 
> Sorry, I thought the systemd reference would be clear enough, see the
> screenshot here:
> 
> https://images.app.goo.gl/gz1Uwg6mcHEd3D2m7
> 
> Systemd prints something link:
> 
> bla bla bla (XXs / YYs)
> 
> where XX is the timer ticking up, and YY is the timeout value.
> 
>>> So to be clear your options are:
>>>   - plumb the single extra netlink parameter through to devlink
>>>   - wait for someone else to do that for you, before you get
>>> firmware flashing accepted upstream.
>>>  
>>
>> Since you seem to have something else in mind, a little more detail 
>> would be helpful.
>>
>> We currently see devlink updating a percentage, something like:
>> Downloading:  56%
>> using backspaces to overwrite the value as the updates are published.
>>
>> How do you envision the userland interpretation of the timeout
>> ticking? Do you want to see something like:
>> Installing - timeout seconds:  23
>> as a countdown?
> 
> I was under the impression that the systemd format would be familiar 
> to users, hence:
> 
> Downloading:  56% (Xm Ys / Zm Vz)

FWIW, I like this approach. I think all we need to implement it is to
send the additional timeout parameter as part of the status notify
command. Then, devlink userspace, if it sees a timeout can choose when
to start displaying the "(Xm Ys / Zm Vs)" portion. Userspace could track
elapsed time changed in its event loop until the message changes.

This would also work for the ice driver, where we indicate that an erase
command could take up to several minutes as well.

Thanks,
Jake
