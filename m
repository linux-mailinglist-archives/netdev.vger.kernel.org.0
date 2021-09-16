Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E53D40DB78
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240269AbhIPNl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240091AbhIPNl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 09:41:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B4E3F61241;
        Thu, 16 Sep 2021 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631799607;
        bh=ew7MRuaXZ3fY9OuCRzD0POsQjgTywAwBRBHU92xh4mY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gszOiuA5X6pTnwYzn82P3PoawtNxTxP0C2yNquNFlnxeZLkreLb1gd//vwZZuSWd8
         YElF1xlfk5KcfuDB5tr1N6jgyINMX5Bxn0+nu/McPQynk/b6PN1+jNqUHDINL8RsCG
         rWkg4u7AeOe3930axMCEVOyzbGlHhXa8ySsVyiNMeezSkelugmsvage+LFfWq77Ra2
         umE7DW3xRZ/VehTFlVGAlXdOlgack0KIiF57SWxp3nKllkJm++9WEhAHYURwhxekcs
         AMm2eeU4BO90qAPQn0t1fL1BfXAPUVjwifhScsn05iS6Kzb7S+tJ2jlhH2rzrS/iux
         pM7O3zi3V6SlA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AB18160A9E;
        Thu, 16 Sep 2021 13:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] igc: fix tunnel offloading
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163179960769.17264.4011657714613530372.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Sep 2021 13:40:07 +0000
References: <20210915171907.1652824-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210915171907.1652824-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinschen@redhat.com,
        nechamax.kraus@linux.intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 15 Sep 2021 10:19:07 -0700 you wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> 
> Checking tunnel offloading, it turns out that offloading doesn't work
> as expected.  The following script allows to reproduce the issue.
> Call it as `testscript DEVICE LOCALIP REMOTEIP NETMASK'
> 
> === SNIP ===
> if [ $# -ne 4 ]
> then
>   echo "Usage $0 DEVICE LOCALIP REMOTEIP NETMASK"
>   exit 1
> fi
> DEVICE="$1"
> LOCAL_ADDRESS="$2"
> REMOTE_ADDRESS="$3"
> NWMASK="$4"
> echo "Driver: $(ethtool -i ${DEVICE} | awk '/^driver:/{print $2}') "
> ethtool -k "${DEVICE}" | grep tx-udp
> echo
> echo "Set up NIC and tunnel..."
> ip addr add "${LOCAL_ADDRESS}/${NWMASK}" dev "${DEVICE}"
> ip link set "${DEVICE}" up
> sleep 2
> ip link add vxlan1 type vxlan id 42 \
> 		   remote "${REMOTE_ADDRESS}" \
> 		   local "${LOCAL_ADDRESS}" \
> 		   dstport 0 \
> 		   dev "${DEVICE}"
> ip addr add fc00::1/64 dev vxlan1
> ip link set vxlan1 up
> sleep 2
> rm -f vxlan.pcap
> echo "Running tcpdump and iperf3..."
> ( nohup tcpdump -i any -w vxlan.pcap >/dev/null 2>&1 ) &
> sleep 2
> iperf3 -c fc00::2 >/dev/null
> pkill tcpdump
> echo
> echo -n "Max. Paket Size: "
> tcpdump -r vxlan.pcap -nnle 2>/dev/null \
> | grep "${LOCAL_ADDRESS}.*> ${REMOTE_ADDRESS}.*OTV" \
> | awk '{print $8}' | awk -F ':' '{print $1}' \
> | sort -n | tail -1
> echo
> ip link del vxlan1
> ip addr del ${LOCAL_ADDRESS}/${NWMASK} dev "${DEVICE}"
> === SNAP ===
> 
> [...]

Here is the summary with links:
  - [net,1/1] igc: fix tunnel offloading
    https://git.kernel.org/netdev/net/c/40ee363c844f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


