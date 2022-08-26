Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58CA15A32C1
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 01:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344328AbiHZXpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 19:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbiHZXp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 19:45:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33ED2AC63
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 16:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56F09B83343
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 23:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC98C433C1;
        Fri, 26 Aug 2022 23:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661557524;
        bh=mkQgteffRxsXxw/AS31iDaYU1ISuaTsPT5v3x+zTr+o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JLzNg8Bn2asRdseaLCv//uXRJxeerq/X+ZVIuaiwlwy0u4rW6DjgzW4sbAiyIo7Ka
         vrhYasivrvZEz1vwPxe2IVqjl2+0opLtCmhdHOWa2+MjbOlydn82CMb/VGo4/hFfb4
         UIp0zIzZ/8tzBLO7bDabduklbLbF+7pSG8sg/Hy55FscjVHS9o2/KEy36yn5RdlI6R
         Isa/Aw1IlJWhAKaWjRZnR7OPotIIPBGkvBmQOS9MvzDATgUkHSf9RX6AQHwfxkAEE8
         Z9JFp0ptuxoyoXrqw5zeeCmA9N1nhdqfOLtbQh+dt5jlv2+rrdnZ4Qvz/ktiUgVGdS
         q1EnQkGe8e0mg==
Date:   Fri, 26 Aug 2022 16:45:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH xfrm-next v3 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220826164522.33bfe68c@kernel.org>
In-Reply-To: <YwhnsWtzwC/wLq1i@unreal>
References: <cover.1661260787.git.leonro@nvidia.com>
        <20220825143610.4f13f730@kernel.org>
        <YwhnsWtzwC/wLq1i@unreal>
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

On Fri, 26 Aug 2022 09:26:57 +0300 Leon Romanovsky wrote:
> On Thu, Aug 25, 2022 at 02:36:10PM -0700, Jakub Kicinski wrote:
> > On Tue, 23 Aug 2022 16:31:57 +0300 Leon Romanovsky wrote:  
> > >  * I didn't hear any suggestion what term to use instead of
> > >    "full offload", so left it as is. It is used in commit messages
> > >    and documentation only and easy to rename.
> > >  * Added performance data and background info to cover letter
> > >  * Reused xfrm_output_resume() function to support multiple XFRM transformations
> > >  * Add PMTU check in addition to driver .xdo_dev_offload_ok validation
> > >  * Documentation is in progress, but not part of this series yet.  
> > 
> > Since the use case is somewhat in question, perhaps switch to RFC
> > postings until the drivers side incl. tc forwarding is implemented?  
> 
> Proposed driver implementation works fine with eswitch representors.
> All our flow steering magic is performed on local table entry and it
> ensures that representors receives/sends "clean" traffic.
> 
> We are using the following configuration snippet to achieve that.
> 
> ---------------------------------------------------------------------
> #!/bin/bash
> P0_OUTER_REMOTE_IP=192.168.50.2
> P0_OUTER_LOCAL_IP=192.168.50.1
> PF0=enp8s0f0
> VF0_REP=enp8s0f0_0
> 
> set -v
> # Configure IP and turn VF_REP on
> ifconfig $PF0 $P0_OUTER_LOCAL_IP/24 up
> ifconfig $VF0_REP up
> 
> # Clean all TC rules, start fresh
> tc qdisc del dev enp8s0f0 ingress >/dev/null 2>&1
> tc qdisc del dev enp8s0f0_0 ingress >/dev/null 2>&1
> 
> # Make sure steering mode is dmfs(FW) and eswitch encap is none
> devlink dev param set pci/0000:08:00.0 name flow_steering_mode value dmfs cmode runtime
> devlink dev eswitch set pci/0000:08:00.0 mode legacy
> devlink dev eswitch set pci/0000:08:00.0 encap none
> devlink dev eswitch set pci/0000:08:00.0 mode switchdev
> 
> sleep 2
> 
> tc qdisc add dev enp8s0f0 ingress
> tc qdisc add dev enp8s0f0_0 ingress
> 
> # Add TC rules
> tc filter add dev $PF0 parent ffff: protocol 802.1q chain 0 flower vlan_id 10 vlan_ethtype 802.1q cvlan_id 5 action vlan pop action vlan pop  action mirred egress redirect dev $VF0_REP
> tc filter add dev $VF0_REP parent ffff: protocol all chain 0 flower action vlan push protocol 802.1q id 5 action vlan push protocol 802.1q id 10 action mirred egress redirect dev $PF0
> tc filter show dev $PF0 ingress
> ----------------------------------------------------------------------------------------------------
> 
> We also don't offload anything related to routing as we can't
> differentiate between local traffic.

Yeah, nah, that's not what I'm asking for.
I said forwarding, not sending traffic thru a different virtual
interface. The TC rules must forward from or two the IPSec ifc.

That was the use case Jason mentioned.

> > Also the perf traces, I don't see them here.  
> 
> It is worth to separate it to standalone discussion with a title:
> "why crypto is not fast enough?". I don't think that mixed discussions
> about full offload which Steffen said that he is interested and
> research about crypto bottlenecks will be productive. These discussions
> are orthogonal.

What do you mean by crypto bottlenecks?

Please use more precise language. crypto here may mean "crypto only
offload" or "crypto as done by CPU". I have no idea which one you mean.

We are very much interested in the former, the latter is indeed out of
scope here.
