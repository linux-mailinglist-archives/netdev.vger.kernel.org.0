Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A824DD1E1
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 01:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbiCRAVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 20:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiCRAVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 20:21:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6B1F1EB7;
        Thu, 17 Mar 2022 17:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A582DB81F81;
        Fri, 18 Mar 2022 00:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38FDEC340EF;
        Fri, 18 Mar 2022 00:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647562814;
        bh=VhMA0U/HDQoA1cmOY4Bw3fD0npt5Q4VMst5fHYiRhmA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P6Go+x8KVLt2xjAZm2WceBHay10DQUhwETNW0CAa436/pxozvw3gfdDDZLfBCeZjM
         +iim+PYuyZVmXu3qGxseThgyfqcAWTDgH+SXULnOChAIZCYDpM0PUqby68bZWrttit
         8IJ4xAVtwDxfSlZKUU5TPJfZ9Go3KAnIpAPs6uEbGFDQI9G/tiYIGjVd2F2JF7yp1D
         84Eo4tyw4xeURBuNUU6v+qQ2iVY4qRomm3WfjQV/qVfHpGnOGydA1a6FzMfuRDNQQL
         AJ+h3r9m1RKBZnO7xQGOlWhkD8t7SPy32MxvxWeX87Rg78FdTqWZp7v+euptDvT5LI
         BZ60cpxZaNNFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0E41BF0383F;
        Fri, 18 Mar 2022 00:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 00/15] net: bridge: Multiple Spanning Trees
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164756281405.28197.1278570234241451207.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 00:20:14 +0000
References: <20220316150857.2442916-1-tobias@waldekranz.com>
In-Reply-To: <20220316150857.2442916-1-tobias@waldekranz.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ivecera@redhat.com, roopa@nvidia.com,
        razor@blackwall.org, linux@armlinux.org.uk, petrm@nvidia.com,
        idosch@nvidia.com, matt@codeconstruct.com.au, me@cooperlees.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Mar 2022 16:08:42 +0100 you wrote:
> The bridge has had per-VLAN STP support for a while now, since:
> 
> https://lore.kernel.org/netdev/20200124114022.10883-1-nikolay@cumulusnetworks.com/
> 
> The current implementation has some problems:
> 
> - The mapping from VLAN to STP state is fixed as 1:1, i.e. each VLAN
>   is managed independently. This is awkward from an MSTP (802.1Q-2018,
>   Clause 13.5) point of view, where the model is that multiple VLANs
>   are grouped into MST instances.
> 
> [...]

Here is the summary with links:
  - [v5,net-next,01/15] net: bridge: mst: Multiple Spanning Tree (MST) mode
    https://git.kernel.org/netdev/net-next/c/ec7328b59176
  - [v5,net-next,02/15] net: bridge: mst: Allow changing a VLAN's MSTI
    https://git.kernel.org/netdev/net-next/c/8c678d60562f
  - [v5,net-next,03/15] net: bridge: mst: Support setting and reporting MST port states
    https://git.kernel.org/netdev/net-next/c/122c29486e1f
  - [v5,net-next,04/15] net: bridge: mst: Notify switchdev drivers of MST mode changes
    https://git.kernel.org/netdev/net-next/c/87c167bb94ee
  - [v5,net-next,05/15] net: bridge: mst: Notify switchdev drivers of VLAN MSTI migrations
    https://git.kernel.org/netdev/net-next/c/6284c723d9b9
  - [v5,net-next,06/15] net: bridge: mst: Notify switchdev drivers of MST state changes
    https://git.kernel.org/netdev/net-next/c/7ae9147f4312
  - [v5,net-next,07/15] net: bridge: mst: Add helper to map an MSTI to a VID set
    https://git.kernel.org/netdev/net-next/c/cceac97afa09
  - [v5,net-next,08/15] net: bridge: mst: Add helper to check if MST is enabled
    https://git.kernel.org/netdev/net-next/c/48d57b2e5f43
  - [v5,net-next,09/15] net: bridge: mst: Add helper to query a port's MST state
    https://git.kernel.org/netdev/net-next/c/f54fd0e16306
  - [v5,net-next,10/15] net: dsa: Validate hardware support for MST
    https://git.kernel.org/netdev/net-next/c/332afc4c8c0d
  - [v5,net-next,11/15] net: dsa: Pass VLAN MSTI migration notifications to driver
    https://git.kernel.org/netdev/net-next/c/8e6598a7b0fa
  - [v5,net-next,12/15] net: dsa: Handle MST state changes
    https://git.kernel.org/netdev/net-next/c/7414af30b7d8
  - [v5,net-next,13/15] net: dsa: mv88e6xxx: Disentangle STU from VTU
    https://git.kernel.org/netdev/net-next/c/49c98c1dc7d9
  - [v5,net-next,14/15] net: dsa: mv88e6xxx: Export STU as devlink region
    https://git.kernel.org/netdev/net-next/c/7dc96039b967
  - [v5,net-next,15/15] net: dsa: mv88e6xxx: MST Offloading
    https://git.kernel.org/netdev/net-next/c/acaf4d2e36b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


