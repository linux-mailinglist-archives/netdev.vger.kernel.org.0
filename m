Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E957D4CE619
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 17:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbiCEQyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 11:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbiCEQyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 11:54:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9A546670
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 08:53:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB530B80C94
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 16:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADD9C004E1;
        Sat,  5 Mar 2022 16:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646499228;
        bh=yHcHKUkpEt4AN6MdE0Clenbr3T34gdX7zCf72EttqJs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=HmoW1xkgcpMixExSiUo+4TVS7SI8NG+DqNSwSr2dj9v47Bh+OkSQU9EeuviFSFgd3
         zssK0T1mHAz1k5MeEsMaNaqufvUsY1XsZ6zMdQGjHPZnbQkKFEractbyDNkMJxx1vL
         Pfq1gWFfQcDqkdY8hk0hwtlsOACnTyMkNDAcmjRfba80H4m6/kQ6CKcv5AvYSxFrx1
         j91yRoxmdguyrUJ+lpaE/HhPGHFn44+1iMwBCl2fhu9yJFXID6V1bXS84y7hm4M7/W
         7847EeuBfqnrApdDY40qTe33nFWs85zcFh1rYfMpZx2ieIlIv9uYzqP323RZpiS2Q9
         tqQEg+R+pCo3Q==
Message-ID: <e2f36bd0-5a78-9093-9eef-7cc301259128@kernel.org>
Date:   Sat, 5 Mar 2022 09:53:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v2 net-next 08/14] ipv6: Add hop-by-hop header to
 jumbograms in ip6_output
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-9-eric.dumazet@gmail.com>
 <726720e6-cd28-646c-1ba3-576a258ae02e@kernel.org>
 <f478bb059d701b774b3d457eb5934f142a6044e8.camel@gmail.com>
 <CANn89i+qJmD9At7otrptkCpnqVUCNi6wXNYnKiwJ1jnse5qNgg@mail.gmail.com>
 <ea73ca6cb4569847d5f2b2a3a5e1f88d78ba1c1a.camel@gmail.com>
 <CANn89iK-treGphHqA-052DMSuuL_-ubdnhBUcpptqT_gnJyovw@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CANn89iK-treGphHqA-052DMSuuL_-ubdnhBUcpptqT_gnJyovw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/22 12:13 PM, Eric Dumazet wrote:
>> I am not saying we have to do this. I am simply stating a "what if"
>> just to gauge this approach. You could think of it as thinking out
>> loud, but in written form.

my point as well.

> 
> Understood.
> 
> BTW I spent time adding a new gso_type flag, but also gave up because we have
> no more room in features_t type.
> 
> Solving features_t exhaustion alone is a delicate topic.
> 
> 
>>
>>> For instance, input path will not like packets larger than 64KB.
>>>
>>> There is this thing trimming padding bytes, you probably do not want
>>> to mess with this.
>>
>> I had overlooked the fact that this is being used on the input path,
>> the trimming would be an issue. I suppose the fact that the LSOv2
>> didn't have an Rx counterpart would be one reason for us to not
>> consider the IPv4 approach.
>>

I'm aware of the trim on ingress; it can be properly handled. Drivers
(LRO) and the S/W GRO stack would know when it is exceeding the 64kB
length so the skb can be marked that is a large packet.

I am not trying to derail this set from getting merged. v6 has a
standard header for the large packet support, so certainly use it. That
said, it is always best in the long run for IPv4 and IPv6 to have
consistent feature support and implementation. Hence the asking about
alternative solutions that work for both.
