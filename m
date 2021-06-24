Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC9E3B2B0F
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 11:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhFXJIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 05:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbhFXJIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 05:08:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643CAC061574;
        Thu, 24 Jun 2021 02:05:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lwLJ3-0002ks-35; Thu, 24 Jun 2021 11:05:53 +0200
Date:   Thu, 24 Jun 2021 11:05:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Georg Kohmann <geokohma@cisco.com>
Cc:     netdev@vger.kernel.org, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, kuba@kernel.org,
        davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        pablo@netfilter.org
Subject: Re: [PATCH net] ipv6/netfilter: Drop Packet Too Big with invalid
 payload
Message-ID: <20210624090553.GB24271@breakpoint.cc>
References: <20210624090135.22406-1-geokohma@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210624090135.22406-1-geokohma@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Georg Kohmann <geokohma@cisco.com> wrote:
> PMTU is updated even though received ICMPv6 PTB do not match any
> transmitted traffic. This breaks TAHI IPv6 Core Conformance Test
> Revision 5.0.1, v6LC.4.1.12 Validate Packet Too Big[1].
> 
> Referring to RFC8201 IPv6 Path MTU Discovery, section 4: "Nodes should
> appropriately validate the payload of ICMPv6 PTB messages to ensure
> these are received in response to transmitted traffic (i.e., a reported
> error condition that corresponds to an IPv6 packet actually sent by the
> application) per [ICMPv6]."
> 
> nf_conntrack_inet_error() return -NF_ACCEPT if the inner header of
> ICMPv6 error packet is not related to an existing connection. Drop PTB
> packet when this occur. This will prevent ipv6 from handling the packet
> and update the PMTU.

This is intentional. We try to not auto-drop packets in conntrack.

Packet is marked as invalid, users can add nft/iptables rules to discard
such packets if they want to do so.
