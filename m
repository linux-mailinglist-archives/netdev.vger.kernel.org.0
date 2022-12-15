Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C9A64E490
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 00:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiLOXO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 18:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiLOXO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 18:14:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B331B1FB;
        Thu, 15 Dec 2022 15:14:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E59A7B81CD8;
        Thu, 15 Dec 2022 23:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2C2C433EF;
        Thu, 15 Dec 2022 23:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671146093;
        bh=L6X16Hkdn6d8sRl1I6/wZT7PyWeA0fYlvkqLhj9xCrw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=GAXyhV8euUakOSi91gD2xRGsWRy7EJakd887r4kIZQ1kDqMy+TAEKvxCYG818YK0W
         rwnbk9gDi4gm4hKh6hq6I3E5E2VnxmcSpQFeAR/mtdFKQ/uF3S1cMRBhikduxpxG+c
         zwGI18C7P29jpHo6GdzniOZM4uSVL+waqs16qM0TWBgBNpqEXtm0L+w5ZW4lXUIvsg
         nRa7IfqoQKPhyExIaQZ3VBqAqveYSMUSs0apPMFvT7P43g98LFypMQutF2cLMrOn+v
         SbyjGLVQ2Heowp5+WcBCgDWKMjBZ3VYdoiYS71pWsZwQdzWmg7chc9fuo+VGLN7gvl
         1YlF1Zqr7gStw==
Message-ID: <2a3c3680-7018-6ca9-e8f0-43201e0d3272@kernel.org>
Date:   Thu, 15 Dec 2022 16:14:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH v1 1/1] net: neigh: persist proxy config across link flaps
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        David Decotigny <ddecotig@google.com>
Cc:     =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS1?=
         =?UTF-8?B?4KS+4KSwKQ==?= <maheshb@google.com>,
        David Decotigny <decot+git@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
References: <20221213073801.361500-1-decot+git@google.com>
 <20221214204851.2102ba31@kernel.org>
 <CAF2d9jh_O0-uceNq=AP5rqPm9xcn=9y8bVxMD-2EiJ3bD_mZsQ@mail.gmail.com>
 <CAG88wWbZ3eXCFJBZ8mrfvddKiVihF-GfEOYAOmT_7VX_AeOoqQ@mail.gmail.com>
 <20221215110544.7e832e41@kernel.org>
 <CAG88wWYA72sij4iaWowLpawzM7tJdYdHCKQnE0bjndGO74vROw@mail.gmail.com>
 <20221215131659.7410a1da@kernel.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221215131659.7410a1da@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/22 2:16 PM, Jakub Kicinski wrote:
> On Thu, 15 Dec 2022 12:36:32 -0800 David Decotigny wrote:
>>> Makes sense. This is not urgent, tho, right?  
>>
>> Not that kind of urgent.
>>
>> FTR, in the v2 you suggested to use NUD_PERMANENT,
> 
> I think that was Alex. I don't have a strong preference. I could see
> arguments being made in both directions (basically whether it's more
> important to leave objects which are clearly not cache vs we care 
> more about consistent behavior based on the permanent flag itself).
> 
> Let's limit the reposts until experts are in town ;)
> 
>>  I can try to see how this would look like. Note that this will make
>> the patch larger and more intrusive, and with potentially a behavior
>> change for whoever uses the netlink API directly instead of the
>> iproute2 implementation for ip neigh X proxy things.

My thinking is inline with Alex's comment on v2.
