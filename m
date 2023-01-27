Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37F967F1ED
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 00:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbjA0XCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 18:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjA0XCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 18:02:52 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611F78BB80
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 15:02:43 -0800 (PST)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pLXju-0007Rf-H2; Sat, 28 Jan 2023 00:02:34 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pLXju-0000cM-0W; Sat, 28 Jan 2023 00:02:34 +0100
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Jamal Hadi Salim <hadi@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
References: <20230124170346.316866-1-jhs@mojatatu.com>
 <20230126153022.23bea5f2@kernel.org> <Y9QXWSaAxl7Is0yz@nanopsycho>
 <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b47d1950-add0-6449-4160-d5e2f7a8d7f7@iogearbox.net>
Date:   Sat, 28 Jan 2023 00:02:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26794/Fri Jan 27 09:44:08 2023)
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/23 9:04 PM, Jamal Hadi Salim wrote:
> On Fri, Jan 27, 2023 at 1:26 PM Jiri Pirko <jiri@resnulli.us> wrote:
>> Fri, Jan 27, 2023 at 12:30:22AM CET, kuba@kernel.org wrote:
>>> On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:
>>>> There have been many discussions and meetings since about 2015 in regards to
>>>> P4 over TC and now that the market has chosen P4 as the datapath specification
>>>> lingua franca
>>>
>>> Which market?
>>>
>>> Barely anyone understands the existing TC offloads. We'd need strong,
>>> and practical reasons to merge this. Speaking with my "have suffered
>>> thru the TC offloads working for a vendor" hat on, not the "junior
>>> maintainer" hat.
>>
>> You talk about offload, yet I don't see any offload code in this RFC.
>> It's pure sw implementation.
>>
>> But speaking about offload, how exactly do you plan to offload this
>> Jamal? AFAIK there is some HW-specific compiler magic needed to generate
>> HW acceptable blob. How exactly do you plan to deliver it to the driver?
>> If HW offload offload is the motivation for this RFC work and we cannot
>> pass the TC in kernel objects to drivers, I fail to see why exactly do
>> you need the SW implementation...
> 
> Our rule in TC is: _if you want to offload using TC you must have a
> s/w equivalent_.
> We enforced this rule multiple times (as you know).
> P4TC has a sw equivalent to whatever the hardware would do. We are pushing that
> first. Regardless, it has value on its own merit:
> I can run P4 equivalent in s/w in a scriptable (as in no compilation
> in the same spirit as u32 and pedit),

`62001 insertions(+), 45 deletions(-)` and more to come for a software
datapath which in the end no-one will use (assuming you'll have the hw
offloads) is a pretty heavy lift.. imo the layer of abstraction is wrong
here as Stan hinted. What if tomorrow P4 programming language is not the
'lingua franca' anymore and something else comes along? Then all of it is
still baked into uapi instead of having a generic/versatile intermediate
later.
