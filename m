Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D1D33DAEF
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 18:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237132AbhCPR1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 13:27:47 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:45125 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239042AbhCPR1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 13:27:24 -0400
Received: from [192.168.0.11] ([217.83.109.231]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N3sRi-1lmNG40rXE-00zraJ; Tue, 16 Mar 2021 18:27:12 +0100
Subject: Re: [PATCH] iavf: fix locking of critical sections
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, lihong.yang@intel.com,
        jesse.brandeburg@intel.com, slawomirx.laba@intel.com,
        nicholas.d.nunley@intel.com
References: <20210316100141.53551-1-sassmann@kpanic.de>
 <20210316101443.56b87cf6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Stefan Assmann <sassmann@kpanic.de>
Message-ID: <44b3f5f0-93f8-29e2-ab21-5fd7cc14c755@kpanic.de>
Date:   Tue, 16 Mar 2021 18:27:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210316101443.56b87cf6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:Io/XlaNymXq7CBfOVzViFtONLAYXSli5QpGHDs+cV1IUpUYmTUN
 J5ofW3PnkGcCHLJXAH4cseNqcsYgUsHjr9HvVzwXwtyeBIUoFFl9I8Dc5SakkWW66V9waC3
 vuywws5CCD5PR9yZ0L5MGBVhOdieWgLp60u65VGCs875O/L94z9hkw8jIASvGtirzL7bL67
 AMkYB0iinIrmlaDfbjcPw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:IZzDflusJsk=:XfQztw7nNrhz6ordKhHh+r
 j1HE2Dmawjh0rNaMlh/M0cRtBhA4we1qcQ/3HltPsq1q2HKT2pMfLvOhtQ5X/3LwvQYoor0vf
 vyh86P6Sb62s/oicxmVoKh5Enp+nhta9r+gsrEp/F7O2mT+Y4hTc4pUXwJXwFCojUePklB0oW
 3NBswU7ToqxHLXw7eV0G3vwd9uWcIWkKDgS8fmXiqaeILIdCPgDInQtxb8Q5A2gBUL6UG6SVr
 Onb+K1gLS5NuKcOduEz1mO5P3PoVMlWfF3NBdecXdIabfHUutrLNEXQ7bDFVYxDJSAIyj3X5n
 mWTD4ojCr/+LPD1uXA0xo8qVealRl4tZH/y3+OBzUqBTeNfpG3jmRbYxoVzsFR9tDR8pLD2By
 AZIzz4+9tO8XXYl0hHh487O7b04Q5vnrwR+1BaJ9Ccl2FV16fJlyNhcq8IGJUrxgguyWbb1ba
 xyQlEpIgAQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.03.21 18:14, Jakub Kicinski wrote:
> On Tue, 16 Mar 2021 11:01:41 +0100 Stefan Assmann wrote:
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
>> - The remove function perorms a state transition and also free's
>>   resources.
>>
>> iavf_lock_timeout() is introduced to avoid waiting infinitely
>> and cause a deadlock. Rather unlock and print a warning.
>>
>> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> 
> I personally think that the overuse of flags in Intel drivers brings
> nothing but trouble. At which point does it make sense to just add a
> lock / semaphore here rather than open code all this with no clear
> semantics? No code seems to just test the __IAVF_IN_CRITICAL_TASK flag,
> all the uses look like poor man's locking at a quick grep. What am I
> missing?
> 

Hi Jakub,

I agree with you that the locking could be done with other locking
mechanisms just as good. I didn't invent the current method so I'll let
Intel comment on that part, but I'd like to point out that what I'm
making use of is fixing what is currently in the driver.

Thanks!

  Stefan
