Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705373CF94C
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 14:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237024AbhGTLWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 07:22:50 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:52981 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233914AbhGTLWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 07:22:46 -0400
Received: from [192.168.0.11] ([91.45.209.101]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N7yz7-1l1Q1U1got-0151Ss; Tue, 20 Jul 2021 14:03:11 +0200
Subject: Re: [PATCH net-next 3/3] iavf: fix locking of critical sections
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Konrad Jankowski <konrad0.jankowski@intel.com>
References: <20210719163154.986679-1-anthony.l.nguyen@intel.com>
 <20210719163154.986679-4-anthony.l.nguyen@intel.com>
 <20210720133153.0f13c92a@cakuba>
From:   Stefan Assmann <sassmann@kpanic.de>
Message-ID: <e1121302-9e06-0f16-de72-a782aceabda7@kpanic.de>
Date:   Tue, 20 Jul 2021 14:03:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210720133153.0f13c92a@cakuba>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:5hFk3NZSHBogFInhhMHY//0TzkcmGXLyU2mK2poN8WwfYS/vzrP
 7i/rSUxxJUFCf5rCQjoi30G13pvLBsBvD1xXqsaCcmTlQO16ka8c/rK7/eTMQenIQbX2b7p
 LVr4p1zDZ0Sb6ayPzU8B53DcLTwErCqwMdQ12is1VYClIfTPsjW2QEWgBq8e+LGK0YbXMNC
 b2ZXLhG/He6qqx/BjHiGg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:cRoiWlanfy0=:pRlcH2bzO3Iu5fEMylSiMg
 k79vghEtXdl42I2d3Z3p48g1TXJXAX9rTs8EWwurXVbVasGBG4DvIDIBCTa6rQYPEkMhee4uU
 +c9aSGj80u6Pu8Mg1DPfzi/R7BOIphT5DHv21xp9qIuMQSsHrWXatiQot802bF5WBH5eU9eE0
 Sz2c5y3Ia5+DyK7zrWVSr6EvLKCqKMVTGYsHBQ1s+rMdv8sVNm3F8sbSFSJ15KACgV9FDvNmJ
 vzfmBAZP0gv+/xKofBN0VmNn+1gxjXH2KX8GmwUzJmWIOcdvII3+AxgEWznRbTyrjnguHHuVy
 qzlbKhBiMfjAWGthcZJNnQ9DeIcTH+xqss5vBU4cqNJBFga5frcfyipoW7rWvkj3pkEXR23m8
 11J8utvfwL5g8JgpRZCctYZ7XK1eSWjfo6jgVnyUr23WWbLpDsJqIvs2EL7A+/xZpQIY14qaH
 kNiAA1s36tfNlACtMZ03ujQ+t2GKnNR7KKM9u5tgIN4XcpiPbqpS3OzOeRMgXkxyp9Lx4IRq4
 rWssLrDQFMZ5RbxinhxLe4GIKCoiKYAkJdMQuG6wtIqIp+fmD4hTNbCWTLlcjVxO76xLp1vXL
 gA5mXkYQpxvHNw5Vp+PsrO9o7Iv3Z4EU6kCJLsHGmW1TNO0bC0TE5vFtS9NCm5EUJZsrpAsJk
 CZjs/o4wHgoEeEvnSOaVbkP1LRmIXIsKQ/Wh896kPSjrl4/jQ6LhQPP4l6tEUjYsXTP9PdKsq
 BWrpa7lnHKfO9lqfLkpjLkWN4gxnW7iOv69nzQlkJOdvyJZYTrVTCEYr+yo92N9yLPugw+yCZ
 MHHLUmFc+cRfdEk6oXA40+3BmfjVb33R0wtIrZWHhnmPaY+4tVmz+0PPP01Qc6rM9AgLZjJyg
 T9iDEg5AWMZV6PcGIxNWBbVzsdkIWuDsVKNiQNX7E=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.07.21 13:31, Jakub Kicinski wrote:
> On Mon, 19 Jul 2021 09:31:54 -0700, Tony Nguyen wrote:
>> To avoid races between iavf_init_task(), iavf_reset_task(),
>> iavf_watchdog_task(), iavf_adminq_task() as well as the shutdown and
>> remove functions more locking is required.
>> The current protection by __IAVF_IN_CRITICAL_TASK is needed in
>> additional places.
>>
>> - The reset task performs state transitions, therefore needs locking.
>> - The adminq task acts on replies from the PF in
>>   iavf_virtchnl_completion() which may alter the states.
>> - The init task is not only run during probe but also if a VF gets stuck
>>   to reinitialize it.
>> - The shutdown function performs a state transition.
>> - The remove function performs a state transition and also free's
>>   resources.
>>
>> iavf_lock_timeout() is introduced to avoid waiting infinitely
>> and cause a deadlock. Rather unlock and print a warning.
> 
> I have a vague recollection of complaining about something like this
> previously. Why not use a normal lock? Please at the very least include
> an explanation in the commit message.
> 
> If you use bit locks you should use the _lock and _unlock flavours of
> the bitops.
> 

Hi Jakub,

yes you remember correctly, back then we agreed to fix this afterwards.
It's not been forgotten, working on the conversion is the next step.

Thanks!

  Stefan
