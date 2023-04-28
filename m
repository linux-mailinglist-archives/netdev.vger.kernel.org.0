Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC7B6F132C
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 10:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345289AbjD1IUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 04:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345335AbjD1IUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 04:20:03 -0400
Received: from smtp.smtpout.orange.fr (smtp-15.smtpout.orange.fr [80.12.242.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A359199D
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 01:20:01 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id sJKepOxuqV1EUsJKepnWlF; Fri, 28 Apr 2023 10:19:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1682669999;
        bh=uhhBHis88E1IH5RfyVZBEsd08cqxwapq00piH9jDAsM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=oXbVB2XG44pKISEjqtw8AcMN+rPteN9eikBWZen2xSCrZkBtULwApdsJGU4X3GT4N
         qnnpeRtuKJzsNTq1PRm5qzo34yCHIhvceGRkTl0uLMylpQMo62Sr2nlwFb4PzZ8p45
         5RnofS/dFeYFuMqqIe4zOopds9R60C2xqI0jG/y41ChL4tu2SjcalZi5exjkSsNizR
         MhbQ5Ni2crBflm6v8RN2Vf2cmKoqqLPi42PbFnN+J25G0sck4t/yIdqJMQvZbSFj0l
         q51qVcU1myD52cHBADuUfajEL6rkWNXz308vBF42tZ8jh4kXjgz6WEUF+6C/IfaGxi
         m9ovOvrloi76g==
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 28 Apr 2023 10:19:59 +0200
X-ME-IP: 86.243.2.178
Message-ID: <a94ce60d-423a-5f8e-5f8e-9b462854db54@wanadoo.fr>
Date:   Fri, 28 Apr 2023 10:19:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net] wifi: mac80211: Fix puncturing bitmap handling in
 __ieee80211_csa_finalize()
Content-Language: fr, en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     christophe.jaillet@wanadoo.fr, davem@davemloft.net,
        edumazet@google.com, johannes.berg@intel.com,
        johannes@sipsolutions.net, kernel-janitors@vger.kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, quic_alokad@quicinc.com,
        quic_msinada@quicinc.com
References: <e84a3f80fe536787f7a2c7180507efc36cd14f95.1682358088.git.christophe.jaillet@wanadoo.fr>
 <87mt2sppgs.fsf@kernel.org>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <87mt2sppgs.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 28/04/2023 à 07:04, Kalle Valo a écrit :
> Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org> writes:
> 
>> 'changed' can be OR'ed with BSS_CHANGED_EHT_PUNCTURING which is larger than
>> an u32.
>> So, turn 'changed' into an u64 and update ieee80211_set_after_csa_beacon()
>> accordingly.
>>
>> In the commit in Fixes, only ieee80211_start_ap() was updated.
>>
>> Fixes: 2cc25e4b2a04 ("wifi: mac80211: configure puncturing bitmap")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
> 
> FWIW mac80211 patches go to wireless tree, not net.
> 

Hi,

net/<something> or drivers/net/<something> goes to 'net'.
drivers/net/wireless/<something> goes to 'wireless'.

now:
net/mac80211/ goes also to 'wireless' as well.
ath11 and ath12 are special cases that goes to 'ath'.

Based on the get_maintainer.pl, my last patch against drivers/isdn looks 
well suited to deserve a -net-next as well?


without speaking of -next variations.


How many other oddities are there?


I try to make my best to add net or net-next.
I could do the same with wireless. (I guess that there is also a 
wireless-next?)

I can do it when rules are SIMPLE.

Is there a place where ALL these "rules" are described?
Could MAINTAINERS and scripts be instrumented for that?


I DO understand that the easiest it is for maintainers, the better for 
them, but please stop asking for casual contributors to know that and 
follow your, not that easy to find or remember, rules.


I'm tempt not to TRY to put the right branch in the subject of my 
commits anymore, because even when I try to do it right and follow 
simple rules for that, it is not enough and I'm WRONG.


Most of my contributions are related to error handling paths.
The remaining ones are mostly related to number of LoC reduction.

Should my contributions be ignored because of the lack of tools to help 
me target the correct branch, then keep the bugs and keep the LoC.


git log --oneline --author=jaillet --grep Fixes: drivers/net | wc -l
97
git log --oneline --author=jaillet drivers/net | wc -l
341

git log --oneline --author=jaillet --grep Fixes: net | wc -l
7
git log --oneline --author=jaillet net | wc -l
327


No hard feelings, but slightly upset.

:/

CJ
