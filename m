Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239A14104D7
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 09:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243317AbhIRHii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 03:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243245AbhIRHif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 03:38:35 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039FDC061574;
        Sat, 18 Sep 2021 00:37:11 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:105:465:1:3:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4HBN1x4xwszQjf4;
        Sat, 18 Sep 2021 09:37:09 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
To:     Brian Norris <briannorris@chromium.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
References: <20210830123704.221494-1-verdre@v0yd.nl>
 <20210830123704.221494-2-verdre@v0yd.nl>
 <CA+ASDXPKZ0i5Bi11Q=qqppY8OCgw=7m0dnPn0s+y+GAvvQodog@mail.gmail.com>
 <CAHp75VdR4VC+Ojy9NjAtewAaPAgowq-3rffrr3uAdOeiN8gN-A@mail.gmail.com>
 <CA+ASDXNGR2=sQ+w1LkMiY_UCfaYgQ5tcu2pbBn46R2asv83sSQ@mail.gmail.com>
 <YS/rn8b0O3FPBbtm@google.com>
Message-ID: <0ce93e7c-b041-d322-90cd-40ff5e0e8ef0@v0yd.nl>
Date:   Sat, 18 Sep 2021 09:37:03 +0200
MIME-Version: 1.0
In-Reply-To: <YS/rn8b0O3FPBbtm@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A83FB275
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/21 11:07 PM, Brian Norris wrote:
> Apologies for the brain-dead mailer. I forget that I should only reply
> via web when I _want_ text wrapping:
> 
> On Wed, Sep 01, 2021 at 02:04:04PM -0700, Brian Norris wrote:
>> (b) latency spikes to ~6ms:
>> # trace-cmd record -p function_graph -O funcgraph-abstime -l
>> mwifiex_pm_wakeup_card
>> # trace-cmd report
>>     kworker/u13:0-199   [003]   348.987306: funcgraph_entry:      #
>> 6219.500 us |  mwifiex_pm_wakeup_card();
>>     kworker/u13:0-199   [003]   349.316312: funcgraph_entry:      #
>> 6267.625 us |  mwifiex_pm_wakeup_card();
>>     kworker/u13:3-4057  [001]   352.238530: funcgraph_entry:      #
>> 6184.250 us |  mwifiex_pm_wakeup_card();
>>     kworker/u13:0-199   [002]   356.626366: funcgraph_entry:      #
>> 6553.166 us |  mwifiex_pm_wakeup_card();
>>     kworker/u13:3-4057  [002]   356.709389: funcgraph_entry:      #
>> 6212.500 us |  mwifiex_pm_wakeup_card();
>>     kworker/u13:3-4057  [002]   356.847215: funcgraph_entry:      #
>> 6230.292 us |  mwifiex_pm_wakeup_card();
>>     kworker/u13:3-4057  [000]   356.897576: funcgraph_entry:      #
>> 6451.667 us |  mwifiex_pm_wakeup_card();
>>     kworker/u13:0-199   [004]   357.175025: funcgraph_entry:      #
>> 6204.042 us |  mwifiex_pm_wakeup_card();
>>
>> whereas it used to look more like:
>>
>>     kworker/u13:1-173   [005]   212.230542: funcgraph_entry:
>> 7.000 us   |  mwifiex_pm_wakeup_card();
>>     kworker/u13:3-1768  [005]   213.886063: funcgraph_entry:
>> 9.334 us   |  mwifiex_pm_wakeup_card();
>>     kworker/u13:3-1768  [002]   214.473273: funcgraph_entry:      +
>> 11.375 us  |  mwifiex_pm_wakeup_card();
>>     kworker/u13:3-1768  [005]   214.530705: funcgraph_entry:
>> 5.542 us   |  mwifiex_pm_wakeup_card();
>>     kworker/u13:1-173   [002]   215.050168: funcgraph_entry:      +
>> 13.125 us  |  mwifiex_pm_wakeup_card();
>>     kworker/u13:1-173   [002]   215.106492: funcgraph_entry:      +
>> 11.959 us  |  mwifiex_pm_wakeup_card();
>>     kworker/u13:3-1768  [005]   215.484807: funcgraph_entry:
>> 8.459 us   |  mwifiex_pm_wakeup_card();
>>     kworker/u13:1-173   [003]   215.515238: funcgraph_entry:      +
>> 15.166 us  |  mwifiex_pm_wakeup_card();
>>     kworker/u13:3-1768  [001]   217.175691: funcgraph_entry:      +
>> 11.083 us  |  mwifiex_pm_wakeup_card();
> 
> That should read:
> 
> # trace-cmd record -p function_graph -O funcgraph-abstime -l mwifiex_pm_wakeup_card
> # trace-cmd report
>     kworker/u13:0-199   [003]   348.987306: funcgraph_entry:      # 6219.500 us |  mwifiex_pm_wakeup_card();
>     kworker/u13:0-199   [003]   349.316312: funcgraph_entry:      # 6267.625 us |  mwifiex_pm_wakeup_card();
>     kworker/u13:3-4057  [001]   352.238530: funcgraph_entry:      # 6184.250 us |  mwifiex_pm_wakeup_card();
>     kworker/u13:0-199   [002]   356.626366: funcgraph_entry:      # 6553.166 us |  mwifiex_pm_wakeup_card();
>     kworker/u13:3-4057  [002]   356.709389: funcgraph_entry:      # 6212.500 us |  mwifiex_pm_wakeup_card();
>     kworker/u13:3-4057  [002]   356.847215: funcgraph_entry:      # 6230.292 us |  mwifiex_pm_wakeup_card();
>     kworker/u13:3-4057  [000]   356.897576: funcgraph_entry:      # 6451.667 us |  mwifiex_pm_wakeup_card();
>     kworker/u13:0-199   [004]   357.175025: funcgraph_entry:      # 6204.042 us |  mwifiex_pm_wakeup_card();
> 
> vs.
> 
>     kworker/u13:1-173   [005]   212.230542: funcgraph_entry:        7.000 us   |  mwifiex_pm_wakeup_card();
>     kworker/u13:3-1768  [005]   213.886063: funcgraph_entry:        9.334 us   |  mwifiex_pm_wakeup_card();
>     kworker/u13:3-1768  [002]   214.473273: funcgraph_entry:      + 11.375 us  |  mwifiex_pm_wakeup_card();
>     kworker/u13:3-1768  [005]   214.530705: funcgraph_entry:        5.542 us   |  mwifiex_pm_wakeup_card();
>     kworker/u13:1-173   [002]   215.050168: funcgraph_entry:      + 13.125 us  |  mwifiex_pm_wakeup_card();
>     kworker/u13:1-173   [002]   215.106492: funcgraph_entry:      + 11.959 us  |  mwifiex_pm_wakeup_card();
>     kworker/u13:3-1768  [005]   215.484807: funcgraph_entry:        8.459 us   |  mwifiex_pm_wakeup_card();
>     kworker/u13:1-173   [003]   215.515238: funcgraph_entry:      + 15.166 us  |  mwifiex_pm_wakeup_card();
>     kworker/u13:3-1768  [001]   217.175691: funcgraph_entry:      + 11.083 us  |  mwifiex_pm_wakeup_card();
> 
> Brian
> 

Thanks for the pointer to that commit Brian, it turns out this is 
actually the change that causes the "Firmware wakeup failed" issues that 
I'm trying to fix with the second patch here.

Also my approach is a lot messier than just reverting 
062e008a6e83e7c4da7df0a9c6aefdbc849e2bb3 and also appears to be blocking 
even longer...

Does anyone have an idea what could be the reason for the posted write 
not going through, or could that also be a potential firmware bug in the 
chip?

Jonas
