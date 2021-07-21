Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DC73D0C37
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 12:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237603AbhGUJUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 05:20:42 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.166]:23941 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237306AbhGUJFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 05:05:17 -0400
X-Greylist: delayed 11355 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jul 2021 05:05:16 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626860714;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=lHplhRl0hkb8uudRlEZcdLXXxlm5Jp61m2gLulf4k6E=;
    b=nP62UfZ7YNpBZJ3TN3lGUhPIVmtF/uVbn5NzJh4JmxfLibJYRObztKEOLNXh+tSVSP
    ZYm9e0lKDRgz4x6CNPJPyCGP4PNFiCyQuuG0+iQgeYwyDp0lOAlie2en3MWnRpq2sHgf
    OLsQujeTqEWq31OlAJLkfl4eVEQNnf6LTiEIJgR+LAuaZWxat5FXw0oRDEpVPI47auvf
    xR9hEuqZw+pIIC3lO0Pjjpa0a4xP50ztIx4MSUkqcV8NAyzuuMFw360t2GKTKHrIl0aQ
    6IqU0RtQl/Xr5kyMvw9Rq/8XocxjzYRJzhU7zvzyoLmXQaq15ZrnCNL2SjYR/3FTwgW9
    00/A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3htNmYasgbo6AhaFdcg=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cee:8300::b82]
    by smtp.strato.de (RZmta 47.28.1 AUTH)
    with ESMTPSA id Z03199x6L9jDHLB
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 21 Jul 2021 11:45:13 +0200 (CEST)
Subject: Re: [PATCH net] can: raw: fix raw_rcv panic for sock UAF
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, kuba@kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210721010937.670275-1-william.xuanziyang@huawei.com>
 <YPeoQG19PSh3B3Dc@kroah.com>
 <44c3e0e2-03c5-80e5-001c-03e7e9758bca@hartkopp.net>
 <e3f56f35-00ca-e8f9-ba41-fdc87dc9bfd4@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <4d91f7bd-eef2-0b1a-f44f-d2006c465422@hartkopp.net>
Date:   Wed, 21 Jul 2021 11:45:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e3f56f35-00ca-e8f9-ba41-fdc87dc9bfd4@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.07.21 11:29, Ziyang Xuan (William) wrote:
> On 7/21/2021 2:35 PM, Oliver Hartkopp wrote:
>>
>>
>> On 21.07.21 06:53, Greg KH wrote:
>>> On Wed, Jul 21, 2021 at 09:09:37AM +0800, Ziyang Xuan wrote:
>>>> We get a bug during ltp can_filter test as following.
>>>>
>>>> ===========================================
>>>> [60919.264984] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
>>>> [60919.265223] PGD 8000003dda726067 P4D 8000003dda726067 PUD 3dda727067 PMD 0
>>>> [60919.265443] Oops: 0000 [#1] SMP PTI
>>>> [60919.265550] CPU: 30 PID: 3638365 Comm: can_filter Kdump: loaded Tainted: G        W         4.19.90+ #1
>>
>> This kernel version 4.19.90 is definitely outdated.
>>
>> Can you please check your issue with the latest uptream kernel as this problem should have been fixed with this patch:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8d0caedb759683041d9db82069937525999ada53
>> ("can: bcm/raw/isotp: use per module netdevice notifier")
>>
>> Thanks!
> 
> I have tested it under the latest 5.14-rc2 kernel version which includes commit 8d0caedb7596 before I submit the patch.
> Although I failed to get the vmcore-dmesg file after updating the kernel version to 5.14-rc2 to display here.
> But we can get the conclusion according to the following debug messages and my problem analysis.
> 
> ==========================================
> [ 1048.953574] unlist_netdevice name[vcan0]
> [ 1048.953661] raw_notify 283: enter, waiting
> [ 1050.950967] raw_setsockopt 552: ro->bound[1] ro->ifindex[8] sk[ffff9420c5699800]
> [ 1053.956002] can: receive list entry not found for dev any, id 000, mask 000
> [ 1053.961989] can: receive list entry not found for dev vcan0, id 123, mask 7FF
> 
> raw_setsockopt() executes after unlist_netdevice() and before raw_notify().
> The problem always exists.
> 

You are right!

In the meantime I sent a new reply to your original patch here:

https://lore.kernel.org/linux-can/11822417-5931-b2d8-ae77-ec4a84b8b895@hartkopp.net/

Thanks!
