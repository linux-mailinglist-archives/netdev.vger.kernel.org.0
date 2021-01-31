Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2EA309B92
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 12:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhAaLMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 06:12:52 -0500
Received: from mga07.intel.com ([134.134.136.100]:12760 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230527AbhAaKXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Jan 2021 05:23:11 -0500
IronPort-SDR: psNKASGuDS16T3qp29tHFay1Ac4Nd5UpYnlcG3zWIzakMjeiR3u/CRrYh4VjOu6PLHG1x7t9fA
 8n+f3iUKddlQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9880"; a="244663555"
X-IronPort-AV: E=Sophos;i="5.79,390,1602572400"; 
   d="scan'208";a="244663555"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 02:22:30 -0800
IronPort-SDR: bPsYnqvQnvItOJdz+hqR82pSeoASyVE6sBA51igFPoWfo8lYV6BK7Rd/V60XeJCnUy1B1tHZNy
 o+5T40c+Ui0g==
X-IronPort-AV: E=Sophos;i="5.79,390,1602572400"; 
   d="scan'208";a="367418764"
Received: from sneftin-mobl.ger.corp.intel.com (HELO [10.251.160.126]) ([10.251.160.126])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 02:22:27 -0800
Subject: Re: [PATCH net 1/4] igc: Report speed and duplex as unknown when
 device is runtime suspended
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20210128213851.2499012-1-anthony.l.nguyen@intel.com>
 <20210128213851.2499012-2-anthony.l.nguyen@intel.com>
 <20210129222255.5e7115bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <107f90ab-0466-67e8-8cc5-7ac79513f939@intel.com>
 <20210130101247.41592be3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <b692fbf3-8aaa-feea-f3c7-ea30484bd625@intel.com>
Date:   Sun, 31 Jan 2021 12:22:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210130101247.41592be3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/2021 20:12, Jakub Kicinski wrote:
> On Sat, 30 Jan 2021 16:00:06 +0200 Neftin, Sasha wrote:
>> On 1/30/2021 08:22, Jakub Kicinski wrote:
>>> On Thu, 28 Jan 2021 13:38:48 -0800 Tony Nguyen wrote:
>>>> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>>>
>>>> Similar to commit 165ae7a8feb5 ("igb: Report speed and duplex as unknown
>>>> when device is runtime suspended"), if we try to read speed and duplex
>>>> sysfs while the device is runtime suspended, igc will complain and
>>>> stops working:
>>>    
>>>> The more generic approach will be wrap get_link_ksettings() with begin()
>>>> and complete() callbacks, and calls runtime resume and runtime suspend
>>>> routine respectively. However, igc is like igb, runtime resume routine
>>>> uses rtnl_lock() which upper ethtool layer also uses.
>>>>
>>>> So to prevent a deadlock on rtnl, take a different approach, use
>>>> pm_runtime_suspended() to avoid reading register while device is runtime
>>>> suspended.
>>>
>>> Is someone working on the full fix to how PM operates?
>>>
>>> There is another rd32(IGC_STATUS) in this file which I don't think
>>> is protected either.
>>
>> What is another rd32(IGC_STATUS) you meant? in  igc_ethtool_get_regs?
> 
> Yes.
> 
>> While the device in D3 state there is no configuration space registers
>> access.
> 
> That's to say similar stack trace will be generated to the one fixed
> here, if someone runs ethtool -d, correct? I don't see anything
> checking runtime there either.
> 
yes.
This problem crosses many drivers. (not only igb, igc,...)

specific to this one (igc), can we check 'netif_running at begin of the 
_get_regs method:
if (!netif_running(netdev))
	return;
what do you think? (only OS can put device to the D3)

> To be clear I'm not asking for this to be addressed in this series.
> Rather for a strong commitment that PM handling will be restructured.
> It seems to me you should depend on refcounting / locking that the PM
> subsystem does more rather than involving rtnl_lock.
>
