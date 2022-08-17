Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571E85975F0
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241161AbiHQSqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241122AbiHQSqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:46:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8E81C106
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 11:46:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8868F6142A
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 18:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8342BC433D6;
        Wed, 17 Aug 2022 18:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660762003;
        bh=dP5pKGzdtq8MBid6vK6mN2DfzfoYxt+dvTMnBsY9cgY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z/Yc2sl3cqBt/f7uMQbZ3tYkH3TwwGQT35HfeEzl37PUN21JioTWC1pOkX7Rryi/V
         /fJk2yagH7lez8BIvUmJJUu6754xP9+NUz/kwCiGeN5nSCrL6qUeHDCOfl0jPx8iww
         /oiKkSrmggOenu0A3uuKrUQWKKY2loELZbDtwCppMcEMwafQt1tppvfLRrJA+vzSSw
         etbMt9mYO8wS4+maRGrTWGPLMmJ6mMfnOlB914hl7DxToO2BY0hnVNv0out5IxnjoD
         kQruYKV6j+Wtv/kGybnFaCBRN6nL5dMYzNNIy8oPNUsuJAbvTQc1kWkzD9LvHrisFV
         GP3z+m1y30HQg==
Date:   Wed, 17 Aug 2022 11:46:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 0/7] 802.1Q Frame Preemption and 802.3 MAC
 Merge support via ethtool
Message-ID: <20220817114642.4de48b52@kernel.org>
In-Reply-To: <20220817115008.t56j2vkd6ludcuu6@skbuf>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
        <20220816203417.45f95215@kernel.org>
        <20220817115008.t56j2vkd6ludcuu6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 11:50:09 +0000 Vladimir Oltean wrote:
> On Tue, Aug 16, 2022 at 08:34:17PM -0700, Jakub Kicinski wrote:
> > I have a couple of general questions. The mm and fp are related but fp
> > can be implemented without mm or they must always come together? (I'd
> > still split patch 2 for ease of review, tho.)  
> 
> FP cannot be implemented without MM and MM makes limited (but some)
> sense without FP. Since FP just decides which packets you TX via the
> pMAC and which via the eMAC, you can configure just the MM layer such
> that you interoperate with a FP-capable switch, but you don't actually
> generate any preemptable traffic yourself.
> 
> In fact, the reasons why I decided to split these are:
> - because they are part of different specs, which call for different
>   managed objects
> - because in an SoC where IPs are mixed and matched from different
>   vendors, it makes perfect sense to me that the FP portion (more
>   related to the queue/classification system) is provided by one vendor,
>   and the MM portion is provided by another. In the future, we may find
>   enough commonalities to justify introducing the concept of a dedicated
>   MAC driver, independent/reusable between Ethernet controller ("net_device")
>   drivers. We have this today already with the PCS layer in phylink.
>   So if there is a physical split between the layers, I think keeping a
>   split in terms of callbacks makes some sense too.

Hah, interesting. I was under the impression that FP can be done
without MM, if frame is preempted it just gets scrambled (bad FCS 
gets injected or a special symbol) and dropped by the receiver.
I had it completely backwards, then.

> > When we have separate set of stats for pMAC the normal stats are sum of
> > all traffic, right? So normal - pMAC == eMAC, everything that's not
> > preemptible is express?  
> 
> Actually not quite, or at least not for the LS1028A ENETC and Felix switch.
> The normal counters report just what the eMAC sees, and the pMAC counters
> just what the pMAC sees. After all, only the eMAC was enabled up until now.
> Nobody does the addition currently.

I see. And the netdev stats are the total?

> > Did you consider adding an attribute for switching between MAC and pMAC
> > for stats rather than duplicating things?  
> 
> No. Could you expand on that idea a little? Add a netlink attribute
> where, and this helps reduce duplication where, and how?

Add a attribute to ETHTOOL_MSG_STATS_GET, let's call it
ETHTOOL_A_STATS_EXPRESS, a flag.

Plumb thru to all the stats callback an extra argument 
(a structure for future extensibility) with a bool pMAC;

Add a capability field to ethtool_ops to announce that
driver will pay attention to the bool pMAC / has support.

We can then use the existing callbacks.

Am I making sense?
