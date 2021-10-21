Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6AB4364B5
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 16:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhJUOvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 10:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbhJUOvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 10:51:23 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A3BC0613B9;
        Thu, 21 Oct 2021 07:49:07 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mdZNR-00014c-IX; Thu, 21 Oct 2021 16:49:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     netfilter-devel@vger.kernel.org, dsahern@kernel.org,
        pablo@netfilter.org, crosser@average.org,
        lschlesinger@drivenets.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 0/2] vrf: rework interaction with netfilter/conntrack
Date:   Thu, 21 Oct 2021 16:48:55 +0200
Message-Id: <20211021144857.29714-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series aims to solve the to-be-reverted change 09e856d54bda5f288e
("vrf: Reset skb conntrack connection on VRF rcv") in a different way.

Rather than have skbs pass through conntrack and nat hooks twice, suppress
conntrack invocation if the conntrack/nat hook is called from the vrf driver.

First patch deals with 'incoming connection' case:
1. suppress NAT transformations
2. skip conntrack confirmation

NAT and conntrack confirmation is done when ip/ipv6 stack calls
the postrouting hook.

Second patch deals with local packets:
in vrf driver, mark the skbs as 'untracked', so conntrack output
hook ignores them.  This skips all nat hooks as well.

Afterwards, remove the untracked state again so the second
round will pick them up.

One alternative to the chosen implementation would be to add a 'caller
id' field to 'struct nf_hook_state' and then use that, these patches
use the more straightforward check of VRF flag on the state->out device.

The two patches apply to both net and net-next, i am targeting -next
because I think that since snat did not work correctly for so long that
we can take the longer route.  If you disagree, apply to net at your
discretion.

The patches apply both with 09e856d54bda5f288e reverted or still
in-place, but only with the revert in place ingress conntrack settings
(zone, notrack etc) start working again.

I've already submitted selftests for vrf+nfqueue and conntrack+vrf.

Florian Westphal (2):
  netfilter: conntrack: skip confirmation and nat hooks in postrouting
    for vrf
  vrf: run conntrack only in context of lower/physdev for locally
    generated packets

 drivers/net/vrf.c                  | 28 ++++++++++++++++++++++++----
 net/netfilter/nf_conntrack_proto.c | 16 ++++++++++++++++
 net/netfilter/nf_nat_core.c        | 12 +++++++++++-
 3 files changed, 51 insertions(+), 5 deletions(-)

-- 
2.32.0

