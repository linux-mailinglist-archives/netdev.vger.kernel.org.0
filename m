Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1387067896A
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 22:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbjAWVVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 16:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjAWVVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 16:21:40 -0500
Received: from mx08lb.world4you.com (mx08lb.world4you.com [81.19.149.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5DF1ABF0
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 13:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sEF25FgHJ3ewqd5AuCIKHnjGBalY8WIyCp2CYXJHJIA=; b=o1s5sL0qXXABJkBDhI0k1MJJ7o
        stEsI0+n2EQOquNP7LfFOLPiO8RZJEtY+kx3MG1+yaPbNem4o/urGr7JpXpl7KDGqTRFEP7Rhfewk
        +9NnRDNBS24vkloCoZpqIofWPRWSFdIvNICuNa3OShBtecxcPTYNvj7sibhr1FAgndDA=;
Received: from [88.117.49.184] (helo=[10.0.0.160])
        by mx08lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pK4Fy-0005pH-8z; Mon, 23 Jan 2023 22:21:34 +0100
Message-ID: <3e324602-a33a-b243-80db-6f6077ca5029@engleder-embedded.com>
Date:   Mon, 23 Jan 2023 22:21:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC PATCH net-next 00/11] ENETC mqprio/taprio cleanup
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.01.23 15:15, Vladimir Oltean wrote:
> I realize that this patch set will start a flame war, but there are
> things about the mqprio qdisc that I simply don't understand, so in an
> attempt to explain how I see things should be done, I've made some
> patches to the code. I hope the reviewers will be patient enough with me :)
> 
> I need to touch mqprio because I'm preparing a patch set for Frame
> Preemption (an IEEE 802.1Q feature). A disagreement started with
> Vinicius here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220816222920.1952936-3-vladimir.oltean@nxp.com/#24976672
> 
> regarding how TX packet prioritization should be handled. Vinicius said
> that for some Intel NICs, prioritization at the egress scheduler stage
> is fundamentally attached to TX queues rather than traffic classes.
> 
> In other words, in the "popular" mqprio configuration documented by him:
> 
> $ tc qdisc replace dev $IFACE parent root handle 100 mqprio \
>        num_tc 3 \
>        map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>        queues 1@0 1@1 2@2 \
>        hw 0
> 
> there are 3 Linux traffic classes and 4 TX queues. The TX queues are
> organized in strict priority fashion, like this: TXQ 0 has highest prio
> (hardware dequeue precedence for TX scheduler), TXQ 3 has lowest prio.
> Packets classified by Linux to TC 2 are hashed between TXQ 2 and TXQ 3,
> but the hardware has higher precedence for TXQ2 over TXQ 3, and Linux
> doesn't know that.

For my tsnep IP core it is similar, but with reverse priority. TXQ 0 has
the lowest priority (to be used for none real-time traffic). TXQ 1 has
priority over TXQ 0, TXQ 2 has priority over TXQ 1, ... . The number of
TX queues is flexible and depends on the requirements of the real-time
application and the available resources within the FPGA. The priority is
hard coded to save FPGA resources.

> I am surprised by this fact, and this isn't how ENETC works at all.
> For ENETC, we try to prioritize on TCs rather than TXQs, and TC 7 has
> higher priority than TC 7. For us, groups of TXQs that map to the same
> TC have the same egress scheduling priority. It is possible (and maybe
> useful) to have 2 TXQs per TC - one TXQ per CPU). Patch 07/11 tries to
> make that more clear.
> 
> Furthermore (and this is really the biggest point of contention), myself
> and Vinicius have the fundamental disagreement whether the 802.1Qbv
> (taprio) gate mask should be passed to the device driver per TXQ or per
> TC. This is what patch 11/11 is about.

tsnep also expects gate mask per TXQ. This simplifies the hardware
implementation. But it would be no problem if the gate mask would be
passed per TC and the driver is able to transform it to per TXQ.

> Again, I'm not *certain* that my opinion on this topic is correct
> (and it sure is confusing to see such a different approach for Intel).
> But I would appreciate any feedback.

In my opinion it makes sense to add mqprio queue configuration to
TAPRIO. This allows the driver to check if queue assignment and
prioritization makes sense for its device. Currently deep hardware
knowledge is needed to know how it is done right.

Gerhard
