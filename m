Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A7852BE63
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 17:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbiEROgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 10:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238738AbiEROgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 10:36:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378FC33E31;
        Wed, 18 May 2022 07:36:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0760EB82123;
        Wed, 18 May 2022 14:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B3CC385A9;
        Wed, 18 May 2022 14:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652884587;
        bh=5uHRMXROqGI1jREuoXs06Hh8a5iU4VH9zbi+x+j3zP4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qqtkE77EhtH/MOwRftTZUurCR4Qgawjdfkav3u2UkX0Y4c9EqXVN4MdWElXxNwc5Y
         rCPkneNenYgAxO15LYoDhx+OcRWCaPBfnAWcKJcWDOn45IDfJQ9d9igHpdCYGbM2Dz
         ytqasYdjE9H1CeGVRn7asq8EVnf+8RnX087A9M2GMYQxQ2wj8JoDOWZfUNgcFyOPBq
         MyMaOlv6MlXJhGjjLIk3vMTpmUB1PJYkAxO3X+fnq7FyFytGzq+MRg6C/WbjKVMT5N
         dI6+1CvlxTFCXlpVyBUs4K19fVWoct/XUiLaymzLAAOvrOO79MvZQ77iMioly20+Wn
         HL4uSoyRcx3Dg==
Message-ID: <6f18ea96-0ba6-23ba-9d74-ebe76b42c828@kernel.org>
Date:   Wed, 18 May 2022 08:36:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH net-next] net: PIM register decapsulation and Forwarding.
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Saranya Panjarathina <plsaranya@gmail.com>, netdev@vger.kernel.org,
        Saranya_Panjarathina@dell.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, g_balaji1@dell.com,
        Nikolay Aleksandrov <razor@blackwall.org>
References: <20220512070138.19170-1-plsaranya@gmail.com>
 <20220516112906.2095-1-plsaranya@gmail.com>
 <20220517171026.1230e034@kernel.org> <YoS3kymdTBwRnrRI@shredder>
 <YoT/tea4TZ2lWN8f@shredder>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <YoT/tea4TZ2lWN8f@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/22 8:16 AM, Ido Schimmel wrote:
> On Wed, May 18, 2022 at 12:08:35PM +0300, Ido Schimmel wrote:
>> On Tue, May 17, 2022 at 05:10:26PM -0700, Jakub Kicinski wrote:
>>> On Mon, 16 May 2022 04:29:06 -0700 Saranya Panjarathina wrote:
>>>> PIM register packet is decapsulated but not forwarded in RP
>>>>
>>>> __pim_rcv decapsulates the PIM register packet and reinjects for forwarding
>>>> after replacing the skb->dev to reg_dev (vif with VIFF_Register)
>>>>
>>>> Ideally the incoming device should be same as skb->dev where the
>>>> original PIM register packet is received. mcache would not have
>>>> reg_vif as IIF. Decapsulated packet forwarding is failing
>>>> because of IIF mismatch. In RP for this S,G RPF interface would be
>>>> skb->dev vif only, so that would be IIF for the cache entry.
>>>>
>>>> Signed-off-by: Saranya Panjarathina <plsaranya@gmail.com>
>>>
>>> Not sure if this can cause any trouble. And why it had become 
>>> a problem now, seems like the code has been this way forever.
>>> David? Ido?
>>
>> Trying to understand the problem:
>>
>> 1. The RP has an (*, G) towards the receiver(s) (receiver joins first)
>> 2. The RP receives a PIM Register packet encapsulating the packet from
>> the source
>> 3. The kernel decapsulates the packet and injects it into the Rx path as
>> if the packet was received by the pimreg netdev
>> 4. The kernel forwards the packet according to the (*, G) route (no RPF
>> check)
>>
>> At the same time, the PIM Register packet should be received by whatever
>> routing daemon is running in user space via a raw socket for the PIM
>> protocol. My understanding is that it should cause the RP to send a PIM
>> Join towards the FHR, causing the FHR to send two copies of each packet
>> from the source: encapsulated in the PIM Register packet and over the
>> (S, G) Tree.
>>
>> If the RP already has an (S, G) route with IIF of skb->dev and the
>> decapsulated packet is injected into the Rx path via skb->dev, then what
>> prevents the RP from forwarding the same packet twice towards the
>> receiver(s)?
>>
>> I'm not a PIM expert so the above might be nonsense. Anyway, I will
>> check with someone from the FRR teams who understands PIM better than
>> me.
> 
> We discussed this patch in FRR slack with the author and PIM experts.
> The tl;dr is that the patch is working around what we currently believe
> is an FRR bug, which the author will try to fix.
> 
> After receiving a PIM Register message on the RP, FRR installs an (S, G)
> route with IIF being the interface via which the packet was received
> (skb->dev). FRR also sends a PIM Join towards the FHR and eventually a
> PIM Register Stop.
> 
> The current behavior means that due to RPF assertion, all the
> encapsulated traffic from the source is dropped on the RP after FRR
> installs the (S, G) route.
> 
> The patch is problematic because during the time the FHR sends both
> encapsulated and native traffic towards the RP, the RP will forward both
> copies towards the receiver(s).
> 
> Instead, the suggestion is for FRR to install the initial (S, G) route
> with IIF being the pimreg device. This should allow decapsulated traffic
> to be forwarded correctly. Native traffic will trigger RPF assertion and
> thereby prompt FRR to: a) Replace the IIF from pimreg to the one via
> which traffic is received b) Send a PIM Register Stop towards the FHR,
> instructing it to stop sending encapsulated traffic.
> 

Thanks for diving into the problem and for the detailed response.
