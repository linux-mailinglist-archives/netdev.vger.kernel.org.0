Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739C233EACC
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 08:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhCQHuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 03:50:07 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:35395 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhCQHtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 03:49:51 -0400
Received: from [192.168.0.11] ([217.83.109.231]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1M1YlB-1lOv6n1icl-0035ux; Wed, 17 Mar 2021 08:49:38 +0100
Subject: Re: [PATCH] iavf: fix locking of critical sections
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, lihong.yang@intel.com,
        slawomirx.laba@intel.com, nicholas.d.nunley@intel.com
References: <20210316100141.53551-1-sassmann@kpanic.de>
 <20210316101443.56b87cf6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <44b3f5f0-93f8-29e2-ab21-5fd7cc14c755@kpanic.de>
 <20210316132905.5d0f90dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210316150210.00007249@intel.com>
From:   Stefan Assmann <sassmann@kpanic.de>
Message-ID: <3a4078fe-0be5-745c-91a3-ed83d4dc372f@kpanic.de>
Date:   Wed, 17 Mar 2021 08:49:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210316150210.00007249@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:gRd4vCW3FwvCWtRZFM1mFvUNSuQeqs3yqR7d2psXmAkpdodvbmp
 jELxRJ/kFiCjKERsqJ0RCXDkJCuvE5WU3i0im9Ebsj3eCYjkb1SCsZwQJTkdU3Wjg2kzyqz
 zjQvmxJbRXysZOgEnhMNEZh/qplaeg/ujblsMEOHioFqYVQhpFchHX8XH7Dj6TkUy1mWvNR
 IAI8ddYa7sR1pdXe5aaZQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:CuStMjcPZck=:VFZgZwZ3C7elvlmZTfyymL
 /bvRy6YjpC1IcqYM+HqN2IXL1aMzmORfir4dpHH1fCvMZ+gTZjcAf4Fi8Oun1dEtcLKOFHzZn
 YY2KoGi3WOxAFG2wDGfrPTgzHlugtq1Hc+mLGNXZq3MWEDjoBbnNiiYlX9I6ZpiqK9H5gzKVV
 ecJv6FlD4YLwWelqzQOq95rSkpNBQO5FJCIE44DgBRcRCVqYzcMhrKcBBqY+bV+0irjm/uCDe
 1hDMk5IHCCD167UMkd7oPhJ1UJn5/wLuxrcqA3RQxVYJfSnUns8xwFR9o9KPtxifgYnsp1IpG
 TecC3P8oyDuOfUoV0bMW1i6GpXH9DZxlDap6FM/QhlFAdUCYRwGHL8MygaPwXLXgsluD2gO+Q
 yWnntCZL5H8CE8PhIwMozviBiFmdTVmGdmAHcb7cJH2AdqXz0S4L/N8zQnIfzidf1oaUZToaH
 2qKtkVDheA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.03.21 23:02, Jesse Brandeburg wrote:
> Jakub Kicinski wrote:
>>>> I personally think that the overuse of flags in Intel drivers brings
>>>> nothing but trouble. At which point does it make sense to just add a
>>>> lock / semaphore here rather than open code all this with no clear
>>>> semantics? No code seems to just test the __IAVF_IN_CRITICAL_TASK flag,
>>>> all the uses look like poor man's locking at a quick grep. What am I
>>>> missing?
>>>
>>> I agree with you that the locking could be done with other locking
>>> mechanisms just as good. I didn't invent the current method so I'll let
>>> Intel comment on that part, but I'd like to point out that what I'm
>>> making use of is fixing what is currently in the driver.
>>
>> Right, I should have made it clear that I don't blame you for the
>> current state of things. Would you mind sending a patch on top of 
>> this one to do a conversion to a semaphore? 

Sure, I'm happy to help working on the conversion once the current issue
is resolved.

>> Intel folks any opinions?
> 
> I know Slawomir has been working closely with Stefan on figuring out
> the right ways to fix this code.  Hopefully he can speak for himself,
> but I know he's on Europe time.
> 
> As for conversion to mutexes I'm a big fan, and as long as we don't
> have too many collisions with the RTNL lock I think it's a reasonable
> improvement to do, and if Stefan doesn't want to work on it, we can
> look into whether Slawomir or his team can.

I'd appreciate to be involved.
Thanks!

  Stefan
