Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4837F3CFAB0
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238531AbhGTMyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239091AbhGTMtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 08:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 631FD610C7;
        Tue, 20 Jul 2021 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626787810;
        bh=pM/Z7xBX0awLX5qAZcCmzltz6LpWjzPsabVIVtiP95Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ni2DTwoP6Nf5/sChghNv1vY3uySkuw3zo5pRp0xjh/8A39SuWOGg84LcrCGs48eWU
         vpkjN+OgjTruPbG3+4Kfs9C2TuBap3RKtc+DFxSXjDpxFD1sraEK00AU4GeEHi3cIj
         +OcfndnVE0QN1k54MKka5BaTjNaRQvk/3Iuistsf4kgV9k8sptVKIzIpFTikUIQtNY
         1m82TNBj3j0esP4Xma+AQ9BnuAQYTGqhtggkHRB8/mdkiULksIQI28omo2Fcgo7gsW
         1UoEaYmUD8j1+i/HNJ7HzoqS8kib1txRUK35J7KOUEU7GX27qOqu5Cz87npkvXslOu
         pOwGPojp/WKoQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5766260A4E;
        Tue, 20 Jul 2021 13:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15] net: bridge: multicast: add vlan support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162678781035.19709.7575566902962912080.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 13:30:10 +0000
References: <20210719170637.435541-1-razor@blackwall.org>
In-Reply-To: <20210719170637.435541-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Jul 2021 20:06:22 +0300 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi all,
> This patchset adds initial per-vlan multicast support, most of the code
> deals with moving to multicast context pointers from bridge/port pointers.
> That allows us to switch them with the per-vlan contexts when a multicast
> packet is being processed and vlan multicast snooping has been enabled.
> That is controlled by a global bridge option added in patch 06 which is
> off by default (BR_BOOLOPT_MCAST_VLAN_SNOOPING). It is important to note
> that this option can change only under RTNL and doesn't require
> multicast_lock, so we need to be careful when retrieving mcast contexts
> in parallel. For packet processing they are switched only once in
> br_multicast_rcv() and then used until the packet has been processed.
> For the most part we need these contexts only to read config values and
> check if they are disabled. The global mcast state which is maintained
> consists of querier and router timers, the rest are config options.
> The port mcast state which is maintained consists of query timer and
> link to router port list if it's ever marked as a router port. Port
> multicast contexts _must_ be used only with their respective global
> contexts, that is a bridge port's mcast context must be used only with
> bridge's global mcast context and a vlan/port's mcast context must be
> used only with that vlan's global mcast context due to the router port
> lists. This way a bridge port can be marked as a router in multiple
> vlans, but might not be a router in some other vlan. Also this allows us
> to have per-vlan querier elections, per-vlan queries and basically the
> whole multicast state becomes per-vlan when the option is enabled.
> One of the hardest parts is synchronization with vlan's memory
> management, that is done through a new vlan flag: BR_VLFLAG_MCAST_ENABLED
> which is changed only under multicast_lock. When a vlan is being
> destroyed first that flag is removed under the lock, then the multicast
> context is torn down which includes waiting for any outstanding context
> timers. Since all of the vlan processing depends on BR_VLFLAG_MCAST_ENABLED
> it must be checked first if the contexts are vlan and the multicast_lock
> has been acquired. That is done by all IGMP/MLD packet processing
> functions and timers. When processing a packet we have RCU so the vlan
> memory won't be freed, but if the flag is missing we must not process it.
> The timers are synchronized in the same way with the addition of waiting
> for them to finish in case they are running after removing the flag
> under multicast_lock (i.e. they were waiting for the lock). Multicast vlan
> snooping requires vlan filtering to be enabled, if it's disabled then
> snooping gets automatically disabled, too. BR_VLFLAG_GLOBAL_MCAST_ENABLED
> controls if a vlan has BR_VLFLAG_MCAST_ENABLED set which is used in all
> vlan disabled checks. We need both flags because one is controlled by
> user-space globally (BR_VLFLAG_GLOBAL_MCAST_ENABLED) and the other is
> for a particular bridge/vlan or port/vlan entry (BR_VLFLAG_MCAST_ENABLED).
> Since the latter is also used for synchronization between the multicast
> and vlan code, and also controlled by BR_VLFLAG_GLOBAL_MCAST_ENABLED we
> rely on it when checking if a vlan context is disabled. The multicast
> fast-path has 3 new bit tests on the cache-hot bridge flags field, I
> didn't observe any measurable difference. I haven't forced either
> context options to be always disabled when the other type is enabled
> because the state consists of timers which either expire (router) or
> don't affect the normal operation. Some options, like the mcast querier
> one, won't be allowed to change for the disabled context type, that will
> come with a future patch-set which adds per-vlan querier control.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net: bridge: multicast: factor out port multicast context
    https://git.kernel.org/netdev/net-next/c/9632233e7de8
  - [net-next,02/15] net: bridge: multicast: factor out bridge multicast context
    https://git.kernel.org/netdev/net-next/c/d3d065c0032b
  - [net-next,03/15] net: bridge: multicast: use multicast contexts instead of bridge or port
    https://git.kernel.org/netdev/net-next/c/adc47037a7d5
  - [net-next,04/15] net: bridge: vlan: add global and per-port multicast context
    https://git.kernel.org/netdev/net-next/c/613d61dbef8e
  - [net-next,05/15] net: bridge: multicast: add vlan state initialization and control
    https://git.kernel.org/netdev/net-next/c/7b54aaaf53cb
  - [net-next,06/15] net: bridge: add vlan mcast snooping knob
    https://git.kernel.org/netdev/net-next/c/f4b7002a7076
  - [net-next,07/15] net: bridge: multicast: add helper to get port mcast context from port group
    https://git.kernel.org/netdev/net-next/c/74edfd483de8
  - [net-next,08/15] net: bridge: multicast: use the port group to port context helper
    https://git.kernel.org/netdev/net-next/c/eb1593a0b4c4
  - [net-next,09/15] net: bridge: multicast: check if should use vlan mcast ctx
    https://git.kernel.org/netdev/net-next/c/4cdd0d10f31d
  - [net-next,10/15] net: bridge: multicast: add vlan querier and query support
    https://git.kernel.org/netdev/net-next/c/615cc23e6283
  - [net-next,11/15] net: bridge: multicast: include router port vlan id in notifications
    https://git.kernel.org/netdev/net-next/c/1e9ca45662d6
  - [net-next,12/15] net: bridge: vlan: add support for global options
    https://git.kernel.org/netdev/net-next/c/47ecd2dbd8ec
  - [net-next,13/15] net: bridge: vlan: add support for dumping global vlan options
    https://git.kernel.org/netdev/net-next/c/743a53d9636a
  - [net-next,14/15] net: bridge: vlan: notify when global options change
    https://git.kernel.org/netdev/net-next/c/9aba624d7cb2
  - [net-next,15/15] net: bridge: vlan: add mcast snooping control
    https://git.kernel.org/netdev/net-next/c/9dee572c3848

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


