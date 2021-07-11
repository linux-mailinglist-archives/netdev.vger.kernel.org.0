Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FE03C3C5F
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 14:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhGKMgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 08:36:24 -0400
Received: from mx4.wp.pl ([212.77.101.11]:13670 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232544AbhGKMgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 08:36:23 -0400
Received: (wp-smtpd smtp.wp.pl 30827 invoked from network); 11 Jul 2021 14:33:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1626006814; bh=yGD3+h86TDL0Au0dytegwySUcFcEQ6eQwHK3EqtKFOE=;
          h=Subject:To:Cc:From;
          b=gQ7B3LwZBxyuYVWozeXPPeSje5qiyZJsCYPaZKt9h1uec5e4nz6md1NPA8uvQiWb4
           Bq3cm7MrtltPqrGRw5dqPKxHJKn3b0nzf4/ufsBztz9L+Awlk4p/NFOl0evqJxYDaz
           w6nEcPteqrPN9RSdJT5jNCsNSPuvSjl9qOH4PDUQ=
Received: from ip-5-172-255-228.free.aero2.net.pl (HELO [100.82.33.98]) (olek2@wp.pl@[5.172.255.228])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <roid@nvidia.com>; 11 Jul 2021 14:33:34 +0200
Subject: Re: [PATCH nf] Revert "netfilter: flowtable: Remove redundant hw
 refresh bit"
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        pablo@netfilter.org
Cc:     nbd@nbd.name, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, roid@nvidia.com
References: <20210614215351.GA734@salvia>
 <20210711010244.1709329-1-martin.blumenstingl@googlemail.com>
From:   Aleksander Bajkowski <olek2@wp.pl>
Message-ID: <74c866f1-48e6-eccc-5bde-e9051f1c51cb@wp.pl>
Date:   Sun, 11 Jul 2021 14:33:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210711010244.1709329-1-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-WP-MailID: 87004a05ed87b34b5ad386b03fa5ffb3
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000005 [AQbA]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

Thanks for the IRC log. Today I repeated my previous tests. I think I had to have Hardware flow offloading enabled before, even though Lantiq xRX200 doesn't support it. With only the software flow offloading turned on, I do not see a significant performance drop.

Today's results (IPv6 routing with DSA driver and Burst Length Patch):
Device	Kernel	Flow offload	Upload	Download
HH5A	5.4.128	Disabled	101	170
HH5A	5.10.46	Disabled	95.4	159
HH5A	5.10.42	Disabled	96.6	165
HH5A	5.10.41	Disabled	101	165
HH5A	5.4.128	Soft		471	463
HH5A	5.10.46	Soft		553	472
HH5A	5.10.42	Soft		556	468
HH5A	5.10.41	Soft		558	492
HH5A	5.4.128	Soft+Hard	434	460
HH5A	5.10.46	Soft+Hard	229	181
HH5A	5.10.42	Soft+Hard	228	177
HH5A	5.10.41	Soft+Hard	577	482

It seems my workaround is unnecessary.

Best regards,
Aleksander Jan Bajkowski

On 7/11/21 3:02 AM, Martin Blumenstingl wrote:
> Hi Aleksander,
> 
>> The xt_flowoffload module is inconditionally setting on the hardware
>> offload flag:
> [...]
>>
>> which is triggering the slow down because packet path is allocating
>> work to offload the entry to hardware, however, this driver does not
>> support for hardware offload.
>>
>> Probably this module can be updated to unset the flowtable flag if the
>> harware does not support hardware offload.
> 
> yesterday there was a discussion about this on the #openwrt-devel IRC
> channel. I am adding the IRC log to the end of this email because I am
> not sure if you're using IRC.
> 
> I typically don't test with flow offloading enabled (I am testing with
> OpenWrt's "default" network configuration, where flow offloading is
> disabled by default). Also I am not familiar with the flow offloading
> code at all and reading the xt_FLOWOFFLOAD code just raised more
> questions for me.
> 
> Maybe you can share some info whether your workaround from [0] "fixes"
> this issue. I am aware that it will probably break other devices. But
> maybe it helps Pablo to confirm whether it's really an xt_FLOWOFFLOAD
> bug or rather some generic flow offload issue (as Felix suggested on
> IRC).
> 
> 
> Best regards,
> Martin
> 
> 
> [0] https://github.com/abajk/openwrt/commit/ee4d790574c0edd170e1710d7cd4819727b23721
> 
> 
> <rsalvaterra> nbd: I saw your flow offloading updates. Just to make sure, this issue hasn't been addressed yet, has it? https://lore.kernel.org/netdev/20210614215351.GA734@salvia/
> <nbd> i don't think so
> <nbd> can you reproduce it?
> <rsalvaterra> nbd: Not really, I don't have the hardware.
> <rsalvaterra> It's lantiq, I think (bthh5a).
> <rsalvaterra> However, I believe dwmw2_gone has one, iirc.
> <xdarklight> nbd: I also have a HH5A. if you have any patch ready you can also send it as RFC on the mailing list and Cc Aleksander
> <rsalvaterra> xdarklight: Have you been able to reproduce the flow offloading regression?
> <xdarklight> I can try (typically I test with a "default" network configuration, where flow offloading is disabled)
> <rsalvaterra> xdarklight: I don't have a lot of details, only this thread: https://github.com/openwrt/openwrt/pull/4225#issuecomment-855454607
> <xdarklight> rsalvaterra: this is the workaround that Aleksander has in his tree: https://github.com/abajk/openwrt/commit/ee4d790574c0edd170e1710d7cd4819727b23721
> <rsalvaterra> xdarklight: Well, but that basically breaks hw flow offloading everywhere else, if I'm reading correctly. :)
> <xdarklight> rsalvaterra: I am not arguing with that :). I wanted to point out that Pablo's finding on the netfilter mailing list seems to be correct
> <rsalvaterra> xdarklight: Sure, which is why I pinged nbd, since he's the original author of the xt_FLOWOFFLOAD target.
> <rsalvaterra> What it seems is that it isn't such trivial fix. :)
> <xdarklight> I looked at the xt_FLOWOFFLOAD code myself and it raised more questions than I had before looking at the code. so I decided to wait for someone with better knowledge to look into that issue :)
> <rsalvaterra> Same here. I just went "oh, this requires divine intervention" and set it aside. :P
> <nbd> xdarklight: which finding did you mean?
> <xdarklight> nbd: "The xt_flowoffload module is inconditionally setting on the hardware offload flag" [...] flowtable[1].ft.flags = NF_FLOWTABLE_HW_OFFLOAD;
> <xdarklight> nbd: from this email: https://lore.kernel.org/netdev/20210614215351.GA734@salvia/
> <nbd> i actually think that finding is wrong
> <nbd> xt_FLOWOFFLOAD registers two flowtables
> <nbd> one with hw offload, one without
> <nbd> the target code does this:
> <nbd> table = &flowtable[!!(info->flags & XT_FLOWOFFLOAD_HW)];
> <nbd> so it selects flowtable[1] only if info->flags has XT_FLOWOFFLOAD_HW set
> <rsalvaterra> nbd: That's between you and Pablo, I mustn't interfere. :)
> <nbd> i did reply to pablo, but never heard back from him
> <rsalvaterra> nbd: The merge window is still open, he's probably busy at the moment… maybe ping him on Monday?
> <xdarklight> nbd: it seems that your mail also didn't make it to the netdev mailing list (at least I can't find it)
> <rsalvaterra> xdarklight: Now that you mention it, neither do I.
> <nbd> he wrote to me in private for some reason
> <xdarklight> oh okay. so for me to summarize: you're saying that the xt_FLOWOFFLOAD code should be fine. in that case Aleksander's workaround (https://github.com/abajk/openwrt/commit/ee4d790574c0edd170e1710d7cd4819727b23721) is also a no-op and the original problem would still be seen
> <rsalvaterra> xdarklight: I don't think it's a no-op, otherwise he wouldn't carry it in his tree… maybe something's wrong in the table selection? table = &flowtable[!!(info->flags & XT_FLOWOFFLOAD_HW)]; does look correct, though.
> <nbd> xdarklight: well, it's not a no-op if the issue was reproduced with option flow_offloading_hw 1 in the config
> <rsalvaterra> nbd: Uh… If he has option flow_offloading_hw '1' on a system which doesn't support hw flow offloading… he gets to keep the pieces, right?
> <nbd> it shouldn't break
> <nbd> and normally i'd expect the generic flow offload api to be able to deal with it without attempting to re-enable hw offload over and over again
> 
