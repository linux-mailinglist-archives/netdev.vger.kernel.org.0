Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA8C538791
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 20:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238788AbiE3Swm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 14:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbiE3Swl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 14:52:41 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C3F4F9C9;
        Mon, 30 May 2022 11:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3P4KzYhF63sLYOXorznhG4XjYdR4PWa+3SOrHzFYIB8=; b=nG4vAIg8xMFt5rvGJKlgQScY1Z
        OKXPTPUOOf+TicqcGuXwXL5CKEixaiZdduQL7FFyxyaK75Ou/K91KQb1v+Vftm7rwaMH3d6pQveun
        0X7dJao66dw60pchJClaygaC5mc7J8sIhQHyvY0yuQubdpjgUQYSQFqpMHTnhmHmPmyI=;
Received: from [217.114.218.22] (helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nvkVI-0001hK-Vw; Mon, 30 May 2022 20:52:37 +0200
Message-ID: <40ce1ec0-0527-7659-2da0-a9d643580f9e@nbd.name>
Date:   Mon, 30 May 2022 20:52:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RFC] netfilter: nf_tables: ignore errors on flowtable device hw
 offload setup
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Jo-Philipp Wich <jo@mein.io>
References: <20220510202739.67068-1-nbd@nbd.name> <Yn4NnwAkoVryQtCK@salvia>
 <b1fd2a80-f629-48a3-7466-0e04f2c531df@nbd.name> <Yn4TmdzQPUQ4TRUr@salvia>
 <88da25b7-0cd0-49df-c09e-8271618ba50f@nbd.name> <YoGhjjhsE1PcVeFC@salvia>
 <1c368b57-be21-5c37-ef38-e23fe344b70a@nbd.name> <YodIN0jLtAcHUq40@salvia>
 <ede77f8a-73d3-b507-5a7d-e8e3004e930d@nbd.name> <YogMj4PC/+DXYjQX@salvia>
 <YpT27/1oJgURRCYw@salvia>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <YpT27/1oJgURRCYw@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 30.05.22 18:55, Pablo Neira Ayuso wrote:
> On Fri, May 20, 2022 at 11:48:01PM +0200, Pablo Neira Ayuso wrote:
>> On Fri, May 20, 2022 at 08:07:44PM +0200, Felix Fietkau wrote:
>> > 
>> > On 20.05.22 09:50, Pablo Neira Ayuso wrote:
>> > > I'm sssuming we relax the requirement as I proposed, ie. allow for not
>> > > allow devices to support for hardware offload, but at least one.
>> > > 
>> > > Then, it should be possible to extend the netlink interface to promote
>> > > a flowtable to support hardware offload, e.g.
>> > > 
>> > >   add flowtable inet x y { hook ingress devices = { eth0, eth1 } priority 0; flags offload; }
>> > > 
>> > > For an existing flowtable, that will add eth0 and eth1, and it will
>> > > request to turn hardware offload.
>> > > 
>> > > This is not supported, these bits are missing in the netlink interface.
>> > > 
>> > > > I still think the best course of action is to silently accept the offload
>> > > > flag even if none of the devices support hw offload.
>> > > 
>> > > Silent means user is asking for something that is actually not
>> > > supported, there will be no effective way from the control plane to
>> > > check if what they request is actually being applied.
>> > > 
>> > > I'd propose two changes:
>> > > 
>> > > - relax the existing requirement, so if one device support hw offload,
>> > >    then accept the configuration.
>> > > 
>> > > - allow to update a flowtable to on/off hardware offload from netlink
>> > >    interface without needing to reload your whole ruleset.
>> >
>> > I still don't see the value in forcing user space to do the
>> > failure-and-retry dance if none of the devices support hw offload.
>> > If this is about notifying user space about the hw offload status, I think
>> > it's much better to simply accept such configurations as-is and extend the
>> > netlink api to report which of the member devices hw offload was actually
>> > enabled for.
>> > This would be much more valuable to users that actually care about the hw
>> > offload status than knowing if one of the devices in the list has hw offload
>> > support, and it would simplify the code as well, for kernel and user space
>> > alike.
>> 
>> I would suggest to extend the API to expose if the device actually
>> support for the flowtable hardware offload, then after the listing,
>> the user knows if the feature is available, so they can turn it on.
> 
> Thinking it well, something in between your proposal and mine.
> 
> Allow to set on 'offload', then the kernel will disable this flag if
> no devices support for hardware offload. The update path would also
> need to allow for this new behaviour.
> 
> The user can check via 'nft list ruleset' if the flag is on / off.

I think that's reasonable. Let's implement it this way for now.

Thanks,

- Felix
