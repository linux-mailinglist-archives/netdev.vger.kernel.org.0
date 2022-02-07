Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902184AC8CE
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbiBGSqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 13:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbiBGSmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:42:50 -0500
X-Greylist: delayed 177 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 10:42:48 PST
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8041C0401DC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 10:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1644259188;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=1zLzD+pKzgJq3ttb1dJHn1NMh3h35TZHzqLiRbcdHvc=;
    b=Tgzseg/NuaxQdtc9m9XLkXMP6ukI+StPqsg/kXGGR+Ds9IjEf80Ezu4Spgc/WDhriz
    14vvGud4RuqieRXKYr1T46xEGOG64/GGzCDPLMBlSIyJuQXKnxSgG9v6/hjTHKEXTvcq
    gcoYTRwA/17s6I6GMPHOo+uvFTyfwCkYB6HvZebmDieeWsynZENRizJgmmsLXxMJrljK
    qkCXa4LQNqqV9/Q4VR9RaSBPLu1eE2HUSQYkZwp7WzqltJhJ0FxROgwk124JIsHqnTnC
    cGtCH1AQY2AXGynJcqdOLxFQVK2xKLkyVwVuXRQOsvn53ME+iEy2R23hwiDpmEcy91oh
    5v9Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXTKq7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::bd7]
    by smtp.strato.de (RZmta 47.39.0 AUTH)
    with ESMTPSA id L7379cy17IdmJUr
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 7 Feb 2022 19:39:48 +0100 (CET)
Message-ID: <70900ebc-876d-cbb3-a048-9104e2e96420@hartkopp.net>
Date:   Mon, 7 Feb 2022 19:39:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 09/11] can: gw: switch cangw_pernet_exit() to
 batch mode
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
 <20220207171756.1304544-10-eric.dumazet@gmail.com>
 <c81703cb-a2b1-4a45-3c5f-0833576f4785@hartkopp.net>
 <CANn89iJhf+-myjz0GgTeWmohnoBottRa+nP8DPqM3yoS64cmHQ@mail.gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <CANn89iJhf+-myjz0GgTeWmohnoBottRa+nP8DPqM3yoS64cmHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07.02.22 18:54, Eric Dumazet wrote:
> On Mon, Feb 7, 2022 at 9:41 AM Oliver Hartkopp <socketcan@hartkopp.net> wrote:
(..)
>>> -static void __net_exit cangw_pernet_exit(struct net *net)
>>> +static void __net_exit cangw_pernet_exit_batch(struct list_head *net_list)
>>>    {
>>> +     struct net *net;
>>> +
>>>        rtnl_lock();
>>> -     cgw_remove_all_jobs(net);
>>> +     list_for_each_entry(net, net_list, exit_list)
>>> +             cgw_remove_all_jobs(net);
>>
>> Instead of removing the jobs for ONE net namespace it seems you are
>> remove removing the jobs for ALL net namespaces?
>>
>> Looks wrong to me.
> 
> I see nothing wrong in my patch.
> 
> I think you have to look more closely at ops_exit_list() in
> net/core/net_namespace.c

Ok, thanks. Your patch just moved the list_for_each_entry() to gw.c.
So there is no functional difference.

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

> BTW, the sychronize_rcu() call in cgw_remove_all_jobs is definitely
> bad, you should absolutely replace it by call_rcu() or kfree_rcu()

Advise is welcome!

The synchronize_rcu() has been introduced in fb8696ab14ad ("can: gw: 
synchronize rcu operations before removing gw job entry") as 
can_can_gw_rcv() is called under RCU protection (NET_RX softirq).

That patch was a follow-up to d5f9023fa61e ("can: bcm: delay release of 
struct bcm_op after synchronize_rcu()") where Thadeu Lima de Souza 
Cascardo detected a race in the BCM code.

When call_rcu() is enough to make sure we do not get a race in 
can_can_gw_rcv() while receiving skbs and removing filters with 
cgw_unregister_filter() I would be happy this rcu thing being fixed up.

Best regards,
Oliver
