Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768E3500900
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 10:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241282AbiDNI7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 04:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241278AbiDNI7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 04:59:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D8F68982
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 01:57:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CDACB828C1
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 08:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3FFC385A5;
        Thu, 14 Apr 2022 08:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649926631;
        bh=+BCznLdwYhU1fE3gxQduI2AmwWzGRbg40R4Q4CsZzYk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=md7sILLk4SheFi6CWP+5J/5MGX8SspIgZcMt46OhICvcwiJq0oJccuaRXA/Eahsg4
         oBFRG3WmQFttX64UGH6MdWo/6L+ePdzG5ygvHg0fZuRwpytrxktIPKcZ7tS33A+R9k
         GZnmVd2Yi9NB6VupXLWJ9nLyO+pPPYp/nROh+RI0BmtXf1FM814MGWvc7rgK1+UMHO
         iVx9YcrB95GF72AKXLp23HOlHj9Op1Pj6Qx/jomMMmg4xN74IvVXU2udXRTHuqlcIB
         wYF6q5u27mA47Z9lFMSZnBsVjQgrs7PjAYloHlk2BRMz1UVm/TNsNb82+vQ69EhVnG
         hwQ+FfEgdCQbw==
Date:   Thu, 14 Apr 2022 10:57:01 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@nvidia.com" <roid@nvidia.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [RFC net-next] net: tc: flow indirect framework issue
Message-ID: <20220414105701.54c3fba4@kernel.org>
In-Reply-To: <YlbR4Cgzd/ulpT25@salvia>
References: <20220413055248.1959073-1-mattias.forsblad@gmail.com>
        <DM5PR1301MB2172F573F9314D43F79D8F26E7EC9@DM5PR1301MB2172.namprd13.prod.outlook.com>
        <20220413090705.zkfrp2fjhejqdj6a@skbuf>
        <2a82cf39-48b9-2c6c-f662-c1d1bce391ba@gmail.com>
        <YlbR4Cgzd/ulpT25@salvia>
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

On Wed, 13 Apr 2022 15:36:32 +0200 Pablo Neira Ayuso wrote:
> A bit of a long email...
> 
> This commit 74fc4f828769 handles this scenario:
> 
> 1) eth0 is gone (module removal)
> 2) vxlan0 device is still in place, tc ingress also contains rules for
>    vxlan0.
> 3) eth0 is reloaded.
> 
> A bit of background: tc ingress removes rules for eth0 if eth0 is
> gone (I am refering to software rules, in general). In this model, the
> tc ingress rules are attached to the device, and if the device eth0 is
> gone, those rules are also gone and, then, once this device eth0 comes
> back, the user has to the tc ingress rules software for eth0 again.
> There is no replay mechanism for tc ingress rules in this case.
> 
> IIRC, Eli's patch re-adds the flow block for vxlan0 because he got a
> bug report that says that after reloading the driver module and eth0
> comes back, rules for tc vxlan0 were not hardware offloaded.
> 
> The indirect flow block infrastructure is tracking devices such as
> vxlan0 that the given driver *might* be able to hardware offload.
> But from the control plane (user) perspective, this detail is hidden.
> To me, the problem is that there is no way from the control plane to
> relate vxlan0 with the real device that performs the hardware offload.
> There is also no flag for the user to request "please hardware offload
> vxlan0 tc ingress rules". Instead, the flow indirect block
> infrastructure performs the hardware offload "transparently" to the user.

TBH I don't understand why indirect infra is important. Mattias said he
gets a replay of the block bind. So it's the replay of rules that's
broken. Whether the block bind came from indir infra or the block is
shared and got bound to a new dev is not important.

> I think some people believe doing things fully transparent is good, at
> the cost of adding more kernel complexity and hiding details that are
> relevant to the user (such as if hardware offload is enabled for
> vxlan0 and what is the real device that is actually being used for the
> vxlan0 to be offloaded).
> 
> So, there are no flags when setting up the vxlan0 device for the user
> to say: "I would like to hardware offload vxlan0", and going slightly
> further there is not "please attach this vxlan0 device to eth0 for
> hardware offload". Any real device could be potentially used to
> offload vxlan0, the user does not know which one is actually used.
> 
> Exposing this information is a bit more work on top of the user, but:
> 
> 1) it will be transparent: the control plane shows that the vxlan0 is
>    hardware offloaded. Then if eth0 is gone, vxlan0 tc ingress can be
>    removed too, because it depends on eth0.
> 
> 2) The control plane validates if hardware offload for vxlan0. If this
>    is not possible, display an error to the user: "sorry, I cannot
>    offload vxlan0 on eth0 for reason X".
> 
> Since this is not exposed to the control plane, the existing
> infrastructure follows a snooping scheme, but tracking devices that
> might be able to hardware offload.
> 
> There is no obvious way to relate vxlan0 with the real device
> (eth0) that is actually performing the hardware offloading.

Let's not over-complicate things, Mattias just needs replay to work.
90% sure it worked when we did the work back in the day with John H,
before the nft rewrite etc.
