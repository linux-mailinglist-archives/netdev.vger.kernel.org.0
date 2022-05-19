Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C7052D7F0
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbiESPio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241272AbiESPh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:37:58 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461FBEAD1D;
        Thu, 19 May 2022 08:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ynfWRfVAtXLBmBwNyPV0mgK+KQyPut44t0iu1lLmUl8=; b=iOueOoQMwx5/lbpKpM1Ib0uG4f
        fnstoL+PXMFXyD4HE5wotSk9OJHPnfcoBxkNfqn4SJlogVxRNgAj7+RdwXHH5TPFsh71b6auoBO6E
        NNcLtuYoiqsezClB3EJ/Gm1+7gHfOPVeHR+Gg9ycE1UhNhIEEQIgdzWJxEn2q7IUZ6c4=;
Received: from [217.114.218.28] (helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nriDB-00023D-9E; Thu, 19 May 2022 17:37:13 +0200
Message-ID: <1c368b57-be21-5c37-ef38-e23fe344b70a@nbd.name>
Date:   Thu, 19 May 2022 17:37:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [RFC] netfilter: nf_tables: ignore errors on flowtable device hw
 offload setup
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Jo-Philipp Wich <jo@mein.io>
References: <20220510202739.67068-1-nbd@nbd.name> <Yn4NnwAkoVryQtCK@salvia>
 <b1fd2a80-f629-48a3-7466-0e04f2c531df@nbd.name> <Yn4TmdzQPUQ4TRUr@salvia>
 <88da25b7-0cd0-49df-c09e-8271618ba50f@nbd.name> <YoGhjjhsE1PcVeFC@salvia>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <YoGhjjhsE1PcVeFC@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 16.05.22 02:57, Pablo Neira Ayuso wrote:
> On Fri, May 13, 2022 at 11:09:51AM +0200, Felix Fietkau wrote:
>> > > Assuming that is the case, wouldn't it be better if we simply have
>> > > an API that indicates, which flowtable members hardware offload was
>> > > actually enabled for?
>> > 
>> > What are you proposing?
>> > 
>> > I think it would be good to expose through netlink interface what the
>> > device can actually do according to the existing supported flowtable
>> > software datapath features.
>> In addition to the NFTA_FLOWTABLE_HOOK_DEVS array, the netlink API could
>> also return another array, e.g. NFTA_FLOWTABLE_HOOK_OFFLOAD_DEVS which
>> indicates devices for which hw offload is enabled.
>> 
>> What I really don't like about the current state of the flowtable offload
>> API is the (in my opinion completely unnecessary) complexity that is
>> required for the simple use case of enabling hw/sw flow offloading on a best
>> effort basis for all devices.
>> What I like even less is the number of implementation details that it has to
>> consider.
>> 
>> For example: Let's assume we have a machine with several devices, some of
>> which support hw offload, some of which don't. We have a mix of VLANs and
>> bridges in there as well, maybe even PPPoE.
>> Now the admin of that machine wants to enable best-effort hardware +
>> software flow offloading for that configuration.
>> Now he (or a piece of user space software dealing with the config) has to do
>> these things:
>> - figure out which devices could support hw offload, create a separate flow
>> table for them
>> - be aware of which of these devices are actually used by looking at the
>> stack of bridges, vlans, dsa devices, etc.
>> - if an error occurs, test them individually just to see which one actually
>> failed and leave it out of the flowtable
>> - for sw offload be aware that there is limited support for offloading decap
>> of vlans/pppoe, count the number of decaps and figure out the right input
>> device to add based on the behavior of nft_dev_path_info, so that the
>> 'indev' it selects matches the device you put in the flow table.
>> 
>> So I'm asking you: Am I getting any of this completely wrong? Do you
>> consider it to be a reasonable trade-off to force the admin (or intermediate
>> user space layer) to jump through these hoops for such a simple use case,
>> just because somebody might want more fine grained control?
>> 
>> I consider this patch to be a first step towards making simple use cases
>> easier to configure. I'd also be fine with adding a flag to make the
>> fallback behavior opt-in, even though I think it would make a much better
>> default.
>> 
>> Eventually I'd also like to add a flag that makes it unnecessary to even
>> specify the devices in the flow table by making the code auto-create hooks
>> for devices with active flows, just like I did in my xtables target.
>> You correctly pointed out to me in the past that this comes at the cost of a
>> few packets delay before offloading kicks in, but I'm still wondering: who
>> actually cares about that?
>> 
>> If I'm completely off-base with this, please let me know. I'm simply trying
>> to make sense of all of this...
> 
> Maybe only fail if _none_ of the selected devices support for hardware
> offload, ie. instead of silently accepting all devices, count of the
> number of devices for which a block has been set up, if it is == 0
> then bail out with EOPNOTSUPP.
I've thought about this some more. The problem with that is if you start 
by having only non-hw-offload devices in the flow table, you can't 
create it with the offload flag.
If you then want to add another device that is capable of doing hw 
offload, it means you have to delete the flowtable and recreate it 
(along with the rules that depend on it), since adding the offload flag 
at runtime isn't supported.

I still think the best course of action is to silently accept the 
offload flag even if none of the devices support hw offload.

- Felix
