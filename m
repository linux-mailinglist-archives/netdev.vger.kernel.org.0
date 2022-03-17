Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528294DC928
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbiCQOrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiCQOrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:47:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28622013F5
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 07:45:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A39BAB81ED5
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 14:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA69C340ED;
        Thu, 17 Mar 2022 14:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647528344;
        bh=InIbK3ax0ap6uuCBrkt7Xd/djxuGlI1V/oNcl/Xd6uo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=szCNuPuMfNuoeHRhc9QyEkWPhiKkKzxUs9JkZicIQqJ5WGd5nm6UEnDy2qu0FtXKg
         gwkjM/i90ZCBSTfkxmAb+9MdwLL39PGtdgBFzrODM09SXzyUucZOeBGtCc4uWh1Ngd
         o9KvTSkb0HJUuv2u+h7vvikH3l7RNIOq9bN05rOmWwzUDBB1xvkPDroz6Yz2BwVtgY
         4XgudmXktUhqWZW4xpBLLl76o2A1/5zzrmUL583yrNNayN4ZxBldooK+3YT0pvfLAt
         AkGKhwRNpBQMcvR3T9kEntScEr2yHKWa0HZ7mTmtEHJBeCYXWux15EXNAsa+5oylhb
         F5pZfMlM2ulow==
Message-ID: <7d15c878-c4bd-8a30-9faa-7279f78a271f@kernel.org>
Date:   Thu, 17 Mar 2022 08:45:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH] ipv6: acquire write lock for addr_list in
 dev_forward_change
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        Niels Dossche <dossche.niels@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20220315230222.49793-1-dossche.niels@gmail.com>
 <37e7909450ebd3b1abcc83119603aa75ab8fc22b.camel@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <37e7909450ebd3b1abcc83119603aa75ab8fc22b.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/22 5:13 AM, Paolo Abeni wrote:
> On Wed, 2022-03-16 at 00:02 +0100, Niels Dossche wrote:
>> No path towards dev_forward_change (common ancestor of paths is in
>> addrconf_fixup_forwarding) acquires idev->lock for idev->addr_list.
>> Since addrconf_{join,leave}_anycast acquire a write lock on addr_list in
>> __ipv6_dev_ac_inc and __ipv6_dev_ac_dec, temporarily unlock when calling
>> addrconf_{join,leave}_anycast analogous to how it's done in
>> addrconf_ifdown.
>>
>> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
>> ---
>>  net/ipv6/addrconf.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>> index f908e2fd30b2..4055ded4b7bf 100644
>> --- a/net/ipv6/addrconf.c
>> +++ b/net/ipv6/addrconf.c
>> @@ -818,14 +818,18 @@ static void dev_forward_change(struct inet6_dev *idev)
>>  		}
>>  	}
>>  
>> +	write_lock_bh(&idev->lock);
>>  	list_for_each_entry(ifa, &idev->addr_list, if_list) {
>>  		if (ifa->flags&IFA_F_TENTATIVE)
>>  			continue;
>> +		write_unlock_bh(&idev->lock);
> 
> This looks weird?!? if 'addr_list' integrity is guaranteed by 
> idev->lock, than this patch looks incorrect. If addr_list integrity is
> ensured elsewhere, why acquiring idev->lock at all?
> 
> @David: can you please comment here?
> 

I have stared at this change a few times. It does look weird and does
not seem to be really solving the problem (or completely solving it).

I think a better option is to investigate moving the locks in the
anycast functions up a layer or two so that the lock here can be held
for the entire list walk.
