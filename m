Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC6652C002
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 19:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239900AbiERQSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 12:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiERQSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 12:18:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4CB1E3884;
        Wed, 18 May 2022 09:18:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 292A960FC4;
        Wed, 18 May 2022 16:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CB6C385A9;
        Wed, 18 May 2022 16:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652890712;
        bh=Qen+rBpTZVTMiRJ8ObK3ITSa2ixnsDPk6mQhH6+ezoQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SWtFL/Joj9dCL++3C3JFrNfLCiL3romgp73ZkYoBwY7bKOXV4HXWLIC6w1UwIGyH7
         UakO1OaXpxd2bBW3sVX2Kjmu0tjAs4bQKEhSnFC/t9W1PfutwudiQcJBjqsjckpcwZ
         e+YuepwFcRTTlSCxAOZ4mblj2XBOciivRNWcnhtU+c7YfjgOXpBHbe3NBTyFPuY2ic
         FgFXgW/AZIX4+eg7ERcdlUd5W5Z9BaiDsRkTErO+CvtdAG6O+PJKIJm1wDr3yVmrFC
         YD0X4IoQpEroycOJkJyjuMNa7iY/8sOhAxc4+DtbepjUEVnYtznh7jrtjuynCjZVQh
         V6KWEdJYmZ+eg==
Date:   Wed, 18 May 2022 09:18:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     Ido Schimmel <idosch@nvidia.com>,
        Saranya Panjarathina <plsaranya@gmail.com>,
        netdev@vger.kernel.org, Saranya_Panjarathina@dell.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, edumazet@google.com,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        g_balaji1@dell.com, Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH net-next] net: PIM register decapsulation and
 Forwarding.
Message-ID: <20220518091830.2db448f2@kernel.org>
In-Reply-To: <6f18ea96-0ba6-23ba-9d74-ebe76b42c828@kernel.org>
References: <20220512070138.19170-1-plsaranya@gmail.com>
        <20220516112906.2095-1-plsaranya@gmail.com>
        <20220517171026.1230e034@kernel.org>
        <YoS3kymdTBwRnrRI@shredder>
        <YoT/tea4TZ2lWN8f@shredder>
        <6f18ea96-0ba6-23ba-9d74-ebe76b42c828@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 08:36:26 -0600 David Ahern wrote:
> >> Trying to understand the problem:
> >>
> >> 1. The RP has an (*, G) towards the receiver(s) (receiver joins first)
> >> 2. The RP receives a PIM Register packet encapsulating the packet from
> >> the source
> >> 3. The kernel decapsulates the packet and injects it into the Rx path as
> >> if the packet was received by the pimreg netdev
> >> 4. The kernel forwards the packet according to the (*, G) route (no RPF
> >> check)
> >>
> >> At the same time, the PIM Register packet should be received by whatever
> >> routing daemon is running in user space via a raw socket for the PIM
> >> protocol. My understanding is that it should cause the RP to send a PIM
> >> Join towards the FHR, causing the FHR to send two copies of each packet
> >> from the source: encapsulated in the PIM Register packet and over the
> >> (S, G) Tree.
> >>
> >> If the RP already has an (S, G) route with IIF of skb->dev and the
> >> decapsulated packet is injected into the Rx path via skb->dev, then what
> >> prevents the RP from forwarding the same packet twice towards the
> >> receiver(s)?
> >>
> >> I'm not a PIM expert so the above might be nonsense. Anyway, I will
> >> check with someone from the FRR teams who understands PIM better than
> >> me.  
> > 
> > We discussed this patch in FRR slack with the author and PIM experts.
> > The tl;dr is that the patch is working around what we currently believe
> > is an FRR bug, which the author will try to fix.
> > 
> > After receiving a PIM Register message on the RP, FRR installs an (S, G)
> > route with IIF being the interface via which the packet was received
> > (skb->dev). FRR also sends a PIM Join towards the FHR and eventually a
> > PIM Register Stop.
> > 
> > The current behavior means that due to RPF assertion, all the
> > encapsulated traffic from the source is dropped on the RP after FRR
> > installs the (S, G) route.
> > 
> > The patch is problematic because during the time the FHR sends both
> > encapsulated and native traffic towards the RP, the RP will forward both
> > copies towards the receiver(s).
> > 
> > Instead, the suggestion is for FRR to install the initial (S, G) route
> > with IIF being the pimreg device. This should allow decapsulated traffic
> > to be forwarded correctly. Native traffic will trigger RPF assertion and
> > thereby prompt FRR to: a) Replace the IIF from pimreg to the one via
> > which traffic is received b) Send a PIM Register Stop towards the FHR,
> > instructing it to stop sending encapsulated traffic.
> >   
> 
> Thanks for diving into the problem and for the detailed response.

+1, thanks Ido!
