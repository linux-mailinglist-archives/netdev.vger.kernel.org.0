Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAB1618FAB
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 05:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiKDE7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 00:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKDE7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 00:59:02 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5D4165B7
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 21:59:00 -0700 (PDT)
Message-ID: <187eec2c-f7d5-7c5a-1c75-aae9f7c98998@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667537939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UydbECnD7LrTu+BxE+4fJ+MVeHIxpUfHr6RXQYOSM8U=;
        b=OL0WqDADk9Six+m4ZlPCLcXh0LZ5nCfhQCyfXd2k6L4TyXoTR8RDVFOoYqnjLDlvH7usSG
        VXz7LNdxWLbbJ8al5U8e9pUhc31xDC0nNzinzZjKsRbdEFiWaRBxDdPXvLGc2I9kGCzvVy
        5Q9GJgR6d4aVG2/bLQvoF7OfqKZX2zY=
Date:   Thu, 3 Nov 2022 21:58:48 -0700
MIME-Version: 1.0
Subject: Re: [RFC] bhash2 and WARN_ON() for inconsistent sk saddr.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.com>, joannelkoong@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuni1840@gmail.com, martin.lau@kernel.org,
        mathew.j.martineau@linux.intel.com, netdev@vger.kernel.org,
        pabeni@redhat.com
References: <CAJnrk1b6=BBEAZTtMPvkqzqjrJrcDo7-dfFvJiYg_Tdd+uShLA@mail.gmail.com>
 <20221102183512.24744-1-kuniyu@amazon.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221102183512.24744-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/22 11:35 AM, Kuniyuki Iwashima wrote:
>> For avoiding adding sockets with ADDR_ANY to the bhash2 hashtable, I
>> think the issue is that other sockets need to detect whether there's a
>> bind conflict against an ADDR_ANY socket on that port, so if ADDR_ANY
>> is not hashed to bhash2, then on binds, we would have to iterate
>> through the regular bhash table to check against ADDR_ANY, where the
>> bhash table could be very long if there are many sockets bound to that
>> port.
> 
> Right, inet_bhash2_addr_any_conflict() will not work then and it means
> we cannot enjoy the very merit of bhash2.

One thought is to have the ADDR_ANY sk linked at either end of the bhash (head 
or tail) so that it can get to the ADDRY_ANY sk faster in bhash when checking 
conflict.  However, only the 'struct hlist_node owner' alone may not be good 
enough.  Just an idea.

