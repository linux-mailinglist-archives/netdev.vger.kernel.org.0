Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425DE1E1338
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 19:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391289AbgEYRJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 13:09:15 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:60826 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391278AbgEYRJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 13:09:13 -0400
Received: from [192.168.254.4] (unknown [50.34.197.93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id AA4AC13C2B0;
        Mon, 25 May 2020 10:09:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com AA4AC13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1590426553;
        bh=EHPh+E1ZdE7p6ZvU4oC5fZ1YWPc4Oc9mXxUVaWe0EHc=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=cNd28c6TAYcBi4SOvvfxgiL28PAd8gdOHHzYe8KJZkh6AH7ES/Jw7RqF8KNwZRZHb
         txfs58Et5e+MY1pgeVmomgiFqNp08PQRnjG+iVEVYBWqY0JeM32G5yaSIdoz4wYt0t
         IJxuxlOo+WM4ImiDRZLZLvIWukeREUnNK6Yk3bh8=
Subject: Re: [RFC 1/2] devlink: add simple fw crash helpers
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Steve deRosier <derosier@gmail.com>
References: <20200519010530.GS11244@42.do-not-panic.com>
 <20200519211531.3702593-1-kuba@kernel.org>
 <20200522052046.GY11244@42.do-not-panic.com>
 <20200522101738.1495f4cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2e5199edb433c217c7974ef7408ff8c7253145b6.camel@sipsolutions.net>
 <20200522215145.GC11244@42.do-not-panic.com>
 <CALLGbR+QPcECtJbYmzztV_Qysc5qtwujT_qc785zvhZMCH50fg@mail.gmail.com>
 <20200525090749.GJ1634618@smile.fi.intel.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com,
        Takashi Iwai <tiwai@suse.de>, schlad@suse.de,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, will@kernel.org,
        mchehab+samsung@kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org, jiri@resnulli.us,
        briannorris@chromium.org
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <e453d720-bfe7-5f4f-e422-a7cfb9bce833@candelatech.com>
Date:   Mon, 25 May 2020 10:08:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20200525090749.GJ1634618@smile.fi.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/25/2020 02:07 AM, Andy Shevchenko wrote:
> On Fri, May 22, 2020 at 04:23:55PM -0700, Steve deRosier wrote:
>> On Fri, May 22, 2020 at 2:51 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
>> I had to go RTFM re: kernel taints because it has been a very long
>> time since I looked at them. It had always seemed to me that most were
>> caused by "kernel-unfriendly" user actions.  The most famous of course
>> is loading proprietary modules, out-of-tree modules, forced module
>> loads, etc...  Honestly, I had forgotten the large variety of uses of
>> the taint flags. For anyone who hasn't looked at taints recently, I
>> recommend: https://www.kernel.org/doc/html/latest/admin-guide/tainted-kernels.html
>>
>> In light of this I don't object to setting a taint on this anymore.
>> I'm a little uneasy, but I've softened on it now, and now I feel it
>> depends on implementation.
>>
>> Specifically, I don't think we should set a taint flag when a driver
>> easily handles a routine firmware crash and is confident that things
>> have come up just fine again. In other words, triggering the taint in
>> every driver module where it spits out a log comment that it had a
>> firmware crash and had to recover seems too much. Sure, firmware
>> shouldn't crash, sure it should be open source so we can fix it,
>> whatever...
>
> While it may sound idealistic the firmware for the end-user, and even for mere
> kernel developer like me, is a complete blackbox which has more access than
> root user in the kernel. We have tons of firmwares and each of them potentially
> dangerous beast. As a user I really care about my data and privacy (hacker can
> oops a firmware in order to set a specific vector attack). So, tainting kernel
> is _a least_ we can do there, the strict rules would be to reboot immediately.
>
>> those sort of wishful comments simply ignore reality and
>> our ability to affect effective change.
>
> We can encourage users not to buy cheap crap for the starter.

There is no stable wifi firmware for any price.

There is also no obvious feedback from even name-brand NICs like ath10k or AX200
when you report a crash.

That said, at least in my experience with ath10k-ct, the OS normally recovers fine
from firmware crashes.  ath10k already reports full crash reports on udev, so
easy for user-space to notice and report bug reports upstream if it cares to.  Probably
other NICs do the same, and if not, they certainly could.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
