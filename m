Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625B84DB9E1
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 22:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240932AbiCPVGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 17:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237976AbiCPVGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 17:06:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300A8E07;
        Wed, 16 Mar 2022 14:05:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1DE5B81B9C;
        Wed, 16 Mar 2022 21:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD4BC340E9;
        Wed, 16 Mar 2022 21:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647464726;
        bh=W+zVvbLr7763wZE7CgF92ost1JLexy2r+814x1pEmOs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qPzMsqMhDbr3dM3KZn8BzClGJi9v4nw9L8DR8Y1naJaiJvPPJSQFYgWaWspeKVMOC
         lHJjk8FRhXUO95yVvlezRqNVkitKDXUnX23LREc20ccSSFgbBdzjXDFSuL5EZMMwQR
         ibISh0E6UntORZRAv8m/aJ0gVrWwuNPl02MQIMPuIhhKmmpwqXJvEVf2vS5Q30Cyq7
         vN6FvtKNfRbITESqVm7OtbH2AS1vln8WdbbN41pHUsG8/teOLu5nj8VsRiH3F4syyQ
         T3h+Y3wtggjhAWfN4SK9JtxWCqEmGsJSP9JTXaCWOKqR6fWmEzBvYsGLOGkDx+/sBI
         2G3fiTJUgjiyA==
Message-ID: <8f6d5115-1158-7276-b991-31253476326b@kernel.org>
Date:   Wed, 16 Mar 2022 15:05:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH net-next 1/3] net: gre_demux: add skb drop reasons to
 gre_rcv()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     menglong8.dong@gmail.com, rostedt@goodmis.org, mingo@redhat.com,
        xeb@mail.ru, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Biao Jiang <benbjiang@tencent.com>
References: <20220314133312.336653-1-imagedong@tencent.com>
 <20220314133312.336653-2-imagedong@tencent.com>
 <20220315200847.68c2efee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <daa287f3-fbed-515d-8f37-f2a36234cc8a@kernel.org>
 <20220315215553.676a5d24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <30b0991a-8c41-2571-b1b6-9edc7dc9c702@kernel.org>
 <20220316115734.1899bb11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220316115734.1899bb11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/22 12:57 PM, Jakub Kicinski wrote:
> On Wed, 16 Mar 2022 08:56:14 -0600 David Ahern wrote:
>>> That's certainly true. I wonder if there is a systematic way of
>>> approaching these additions that'd help us picking the points were 
>>> we add reasons less of a judgment call.  
>>
>> In my head it's split between OS housekeeping and user visible data.
>> Housekeeping side of it is more the technical failure points like skb
>> manipulations - maybe interesting to a user collecting stats about how a
>> node is performing, but more than likely not. IMHO, those are ignored
>> for now (NOT_SPECIFIED).
>>
>> The immediate big win is for packets from a network where an analysis
>> can show code location (instruction pointer), user focused reason (csum
>> failure, 'otherhost', no socket open, no socket buffer space, ...) and
>> traceable to a specific host (headers in skb data).
> 
> Maybe I'm oversimplifying but would that mean first order of business
> is to have drop codes for where we already bump MIB exception stats?

That was the original motivation and it has since spun out of control -
walking the code base and assigning unique drop reasons for every single
call to kfree_skb.
