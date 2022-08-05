Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662DF58AC54
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 16:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240927AbiHEOWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 10:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiHEOWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 10:22:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D088A5724C;
        Fri,  5 Aug 2022 07:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82AF2B8293F;
        Fri,  5 Aug 2022 14:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C96C433D6;
        Fri,  5 Aug 2022 14:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659709329;
        bh=eeOR1aMLDowJXXETVzUrPqRnOqFYbjijqPZUbyAzk7I=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QNnn8DaarldpwiG+11+ab5RVfuaI8opzCO3qec5vuvzfoL90qfnsguiz6WCIfeXr8
         Xjrvr5TfQTzWqoJA/fkXa/0AQXdCoucYcO87aUwsS9uYj+EKrZXXJAmm2WuKrsUDKp
         ZXMYUBYe5X7E2VNJXnY5LTR4fRySMwC0i20EG7TuMHCQE62nCF77TqASQoEvXgkQpP
         05t1zfrmgbqqF6vDcQSAxgZRGGl/j5ZYk6fafxQ7xS01uNWUTn4qbk7tHOLZgSP0IP
         g3gcatZTDUDXaWciLuKZ0f11cbg4Vin5YXqaccaxsrqNlvDJKPc8Qdn6G2Zh4a8TWK
         Q0ALUBU/RrT1A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Veerendranath Jakkam <quic_vjakkam@quicinc.com>,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <aspriel@gmail.com>
Subject: Re: [GIT PULL] Networking for 6.0
References: <20220803101438.24327-1-pabeni@redhat.com>
        <CAHk-=wjhSSHM+ESVnchxazGx4Vi0fEfmHpwYxE45JZDSC8SUAQ@mail.gmail.com>
        <87les4id7b.fsf@kernel.org>
Date:   Fri, 05 Aug 2022 17:22:02 +0300
In-Reply-To: <87les4id7b.fsf@kernel.org> (Kalle Valo's message of "Thu, 04 Aug
        2022 12:13:12 +0300")
Message-ID: <877d3mixdh.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
>> Hmm. Another issue with the networking pull..
>>
>> On Wed, Aug 3, 2022 at 3:15 AM Paolo Abeni <pabeni@redhat.com> wrote:
>>>
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.0
>>>
>>> Veerendranath Jakkam (5):
>>>       cfg80211: Indicate MLO connection info in connect and roam callbacks
>>
>> This one added a
>>
>>                 for_each_valid_link(cr, link) {
>>                         if (WARN_ON_ONCE(!cr->links[link].bss))
>>                                 break;
>>                 }
>>
>> in net/wireless/sme.c, and it seems to trigger on my brand new M2 Macbook Air.
>>
>> Wireless still works fine (I'm writing this report on the machine),
>> but you get a scary splat:
>>
>>   WARNING: CPU: 5 PID: 514 at net/wireless/sme.c:786
>> __cfg80211_connect_result+0x2fc/0x5c0 [cfg80211]
>>
>> full call trace etc in the attachment.
>
> Thanks for the report, adding also Arend and changing Johannes' email.
> Unfortunately Johannes is away this week. Arend, would you be able to
> look at this? I don't have any brcmfmac hardware.

Veerendranath took a look at this and here's a quick fix:

https://patchwork.kernel.org/project/linux-wireless/patch/20220805135259.4126630-1-quic_vjakkam@quicinc.com/

Do note that this isn't tested with brcmfmac but it should work :)

Linus, do you want to take that directly or should I take it to wireless
tree? I assume with the latter you would then get it by the end of next
week.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
