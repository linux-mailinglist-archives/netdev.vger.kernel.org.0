Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698CA69AB9C
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjBQMfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjBQMfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:35:15 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB145A3A9;
        Fri, 17 Feb 2023 04:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uzPCjjdWCXSVtSZ9YmbG4GcQfhzSs/F20C2/qfeAZE0=; b=FA6LLjU8XT1gZzDu8UB5pGcBjY
        YgqevsUF9ZLdIRn52COcqgI09NJ5pvfxocseMVr691/bf5ZZnbaFICvaBGC+Zd63W9wX6MS/FbMln
        XVYzq3ihnr+dfJgkQnkm6mBiqIJm4qrMjWEMP7VeM9Oh1lbbvManIyH06IfC2hvsl6rw=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pSzxC-009Bnn-KJ; Fri, 17 Feb 2023 13:35:06 +0100
Message-ID: <acaf1607-412d-3142-1465-8d8439520228@nbd.name>
Date:   Fri, 17 Feb 2023 13:35:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [RFC v2] net/core: add optional threading for rps backlog
 processing
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20230217100606.1234-1-nbd@nbd.name>
 <CANn89iJXjEWJcFbSMwKOXuupCVr4b-y4Gh+LwOQg+TQwJPQ=eg@mail.gmail.com>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <CANn89iJXjEWJcFbSMwKOXuupCVr4b-y4Gh+LwOQg+TQwJPQ=eg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.02.23 13:23, Eric Dumazet wrote:
> On Fri, Feb 17, 2023 at 11:06 AM Felix Fietkau <nbd@nbd.name> wrote:
>>
>> When dealing with few flows or an imbalance on CPU utilization, static RPS
>> CPU assignment can be too inflexible. Add support for enabling threaded NAPI
>> for RPS backlog processing in order to allow the scheduler to better balance
>> processing. This helps better spread the load across idle CPUs.
>>
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> ---
>>
>> RFC v2:
>>  - fix rebase error in rps locking
> 
> Why only deal with RPS ?
> 
> It seems you propose the sofnet_data backlog be processed by a thread,
> instead than from softirq ?
Right. I originally wanted to mainly improve RPS, but my patch does 
cover backlog in general. I will update the description in the next 
version. Does the approach in general make sense to you?

Thanks,

- Felix
