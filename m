Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39559525E17
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 11:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378728AbiEMJJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 05:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358383AbiEMJJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 05:09:55 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FA216A5C4;
        Fri, 13 May 2022 02:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:
        From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=3U+GKVWVVieM5BCte0/UQ+iZa5RQpeyFhWbAlOz3aXA=; b=TdL31caCb5Fwvit2w4hepVTGEb
        TF1w5lCjdn074ogWuPO+5/kPsSI5QcSa+OnJc2/EmBgIWV/D+xODWstOL83MIj2kqmiDVwpnYd26z
        V6dK8aGEqr3m0xgMaKQRWr/dx3CY/U96I4W7nAIO+Y2ql4qcIbViHx1azH13Cjfgp5xs=;
Received: from p200300daa70ef2007c2a1ceaba82ff54.dip0.t-ipconnect.de ([2003:da:a70e:f200:7c2a:1cea:ba82:ff54] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1npRJ1-00074J-KQ; Fri, 13 May 2022 11:09:51 +0200
Message-ID: <88da25b7-0cd0-49df-c09e-8271618ba50f@nbd.name>
Date:   Fri, 13 May 2022 11:09:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Jo-Philipp Wich <jo@mein.io>
References: <20220510202739.67068-1-nbd@nbd.name> <Yn4NnwAkoVryQtCK@salvia>
 <b1fd2a80-f629-48a3-7466-0e04f2c531df@nbd.name> <Yn4TmdzQPUQ4TRUr@salvia>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC] netfilter: nf_tables: ignore errors on flowtable device hw
 offload setup
In-Reply-To: <Yn4TmdzQPUQ4TRUr@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 13.05.22 10:15, Pablo Neira Ayuso wrote:
> On Fri, May 13, 2022 at 10:03:13AM +0200, Felix Fietkau wrote:
>> 
>> On 13.05.22 09:49, Pablo Neira Ayuso wrote:
>> > Hi,
>> > 
>> > On Tue, May 10, 2022 at 10:27:39PM +0200, Felix Fietkau wrote:
>> > > In many cases, it's not easily possible for user space to know, which
>> > > devices properly support hardware offload.
>> > 
>> > Then, it is a matter of extending the netlink interface to expose this
>> > feature? Probably add a FLOW_BLOCK_PROBE or similar which allow to
>> > consult if this feature is available?
>> > 
>> > > Even if a device supports hardware flow offload, it is not
>> > > guaranteed that it will actually be able to handle the flows for
>> > > which hardware offload is requested.
>> > 
>> > When might this happen?
>>
>> I think there are many possible reasons: The flow might be using features
>> not supported by the offload driver. Maybe it doesn't have any space left in
>> the offload table. I'm sure there are many other possible reasons it could
>> fail.
> 
> This fallback to software flowtable path for partial scenarios already
> exists.
I know. All I meant was to point out that hardware offload is not 
guaranteed in one place, so I don't think bailing out with an error 
because flow block bind didn't work for one of the flowtable devices is 
justified.

>> > > Ignoring errors on the FLOW_BLOCK_BIND makes it a lot easier to set up
>> > > configurations that use hardware offload where possible and gracefully
>> > > fall back to software offload for everything else.
>> > 
>> > I understand this might be useful from userspace perspective, because
>> > forcing the user to re-try is silly.
>> > 
>> > However, on the other hand, the user should have some way to know from
>> > the control plane that the feature (hardware offload) that they
>> > request is not available for their setup.
>>
>> In my opinion, most users of this API probably don't care and just want to
>> have offload on a best effort basis.
> 
> OK, but if the setup does not support hardware offload at all, why
> should the control plane accept this? I think user should know in
> first place that no one single flow is going to be offloaded to
> hardware.
It makes for a much cleaner configuration if you can just create a 
single hw-offload enabled flowtable containing multiple devices, some of 
which support hardware offload and some of which don't.

>> Assuming that is the case, wouldn't it be better if we simply have
>> an API that indicates, which flowtable members hardware offload was
>> actually enabled for?
> 
> What are you proposing?
> 
> I think it would be good to expose through netlink interface what the
> device can actually do according to the existing supported flowtable
> software datapath features.
In addition to the NFTA_FLOWTABLE_HOOK_DEVS array, the netlink API could 
also return another array, e.g. NFTA_FLOWTABLE_HOOK_OFFLOAD_DEVS which 
indicates devices for which hw offload is enabled.

What I really don't like about the current state of the flowtable 
offload API is the (in my opinion completely unnecessary) complexity 
that is required for the simple use case of enabling hw/sw flow 
offloading on a best effort basis for all devices.
What I like even less is the number of implementation details that it 
has to consider.

For example: Let's assume we have a machine with several devices, some 
of which support hw offload, some of which don't. We have a mix of VLANs 
and bridges in there as well, maybe even PPPoE.
Now the admin of that machine wants to enable best-effort hardware + 
software flow offloading for that configuration.
Now he (or a piece of user space software dealing with the config) has 
to do these things:
- figure out which devices could support hw offload, create a separate 
flow table for them
- be aware of which of these devices are actually used by looking at the 
stack of bridges, vlans, dsa devices, etc.
- if an error occurs, test them individually just to see which one 
actually failed and leave it out of the flowtable
- for sw offload be aware that there is limited support for offloading 
decap of vlans/pppoe, count the number of decaps and figure out the 
right input device to add based on the behavior of nft_dev_path_info, so 
that the 'indev' it selects matches the device you put in the flow table.

So I'm asking you: Am I getting any of this completely wrong? Do you 
consider it to be a reasonable trade-off to force the admin (or 
intermediate user space layer) to jump through these hoops for such a 
simple use case, just because somebody might want more fine grained control?

I consider this patch to be a first step towards making simple use cases 
easier to configure. I'd also be fine with adding a flag to make the 
fallback behavior opt-in, even though I think it would make a much 
better default.

Eventually I'd also like to add a flag that makes it unnecessary to even 
specify the devices in the flow table by making the code auto-create 
hooks for devices with active flows, just like I did in my xtables target.
You correctly pointed out to me in the past that this comes at the cost 
of a few packets delay before offloading kicks in, but I'm still 
wondering: who actually cares about that?

If I'm completely off-base with this, please let me know. I'm simply 
trying to make sense of all of this...

- Felix
