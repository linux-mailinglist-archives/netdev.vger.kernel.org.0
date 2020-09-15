Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F47426AC6C
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgIOSpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:45:46 -0400
Received: from mga07.intel.com ([134.134.136.100]:49931 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbgIOSoT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 14:44:19 -0400
IronPort-SDR: fL/LOjbM14dgxXCkE3kxCmTBm0GP8SY5wDhNDHHTrd62UMOJeielLaMIwn62pDbyMMGc5ac8xQ
 e3fwRXjcy8Cw==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="223509174"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="223509174"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 11:44:11 -0700
IronPort-SDR: /xPcUcALlnKok2mXizOym86PTU/ytWVCEp7TxeOQOTONm6N9IGPi6Oav/N17v6XtyWC2PiQ2SQ
 G0TM1UkUBq6A==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="319557227"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.14.65]) ([10.212.14.65])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 11:44:10 -0700
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
To:     Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20200908224812.63434-1-snelson@pensando.io>
 <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
 <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
 <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3d75c4be-ae5d-43b0-407c-5df1e7645447@pensando.io>
 <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a04313f7-649e-a928-767c-b9d27f3a0c7c@intel.com>
 <20200914163605.750b0f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3b18d92f-3a0a-c0b0-1b46-ecfd4408038c@pensando.io>
 <7e44037cedb946d4a72055dd0898ab1d@intel.com>
 <f4e4e9c3-b293-cef1-bb84-db7fe691882a@pensando.io>
 <20200915085045.446b854b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4b5e3547f3854fd399b26a663405b1f8@intel.com>
 <ad9b1163-fe3b-6793-c799-75a9c4ce87f9@pensando.io>
 <20200915103913.46cebf69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <1dfa16c8-8bb6-a429-6644-68fd94fc2830@intel.com>
Date:   Tue, 15 Sep 2020 11:44:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200915103913.46cebf69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/15/2020 10:39 AM, Jakub Kicinski wrote:
> On Tue, 15 Sep 2020 10:20:11 -0700 Shannon Nelson wrote:
>>>>> What should the userland program do when the timeout expires?  Start
>>>>> counting backwards?  Stop waiting?  Do we care to define this at the moment?  
>>>> [component] bla bla X% (timeout reached)
>>>  
>>> Yep. I don't think userspace should bail or do anything but display
>>> here. Basically: the driver will timeout and then end the update
>>> process with an error. The timeout value is just a useful display
>>> so that users aren't confused why there is no output going on while
>>> waiting.
>>>
>> If individual notify messages have a timeout, how can we have a 
>> progress-percentage reported with a timeout?  This implies to me that 
>> the timeout is on the component:bla-bla pair, but there are many
>> notify messages in order to show the progress in percentage done.
>> This is why I was suggesting that if the timeout and component and
>> status messages haven't changed, then we're still working on the same
>> timeout.
> 
> My thinking is that the timeout is mostly useful for commands which
> can't meaningfully provide the progress percentage, or the percentage
> update is at a very high granularity. If percentage updates are reported
> often they should usually be sufficient.
> 
> We mostly want to make sure user doesn't think the system has hung.
> 

Exactly how I saw it.

Basically, the timeout should take effect as long as the (component,
msg) pair stays the same.

So if you send percentage reports with the same message and component,
then the timeout stays in effect. Once you start a new message, then the
timeout would be reset.

We could in theory provide both a "timeout" and "time elapsed" field,
which would allow the application to draw the timeout at an abitrary
point. Then it could progress the time as normal if it hasn't received a
new message yet, allowing for consistent screen updates...

But I think that might be overkill. For the cases where we do get some
sort of progress, then the percentage update is usually enough.
