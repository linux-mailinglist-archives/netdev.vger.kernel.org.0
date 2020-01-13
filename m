Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 284B9139D8E
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 00:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgAMXmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 18:42:47 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:55677 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728794AbgAMXmr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 18:42:47 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 3f012fc7;
        Mon, 13 Jan 2020 22:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=vfaA0feznXmzEGVM0zRUJJI5HOQ=; b=gdkHuyd1wqewMbe3xY5r
        0feSdi2yqb3Hs8XfWVcBZoLMbOe9Yoy8tNAMffRxiHl7ZgGgldmV+vDtqLdrpf2R
        Kn/SxKXTdG9x0DgwFvh3l06k/snN6Eqg6O7YadZej048mr2jgMzirw0PMkvcIwtL
        9Z4UhjurbOKZWRweYQ2heAUO9gm8zURhVW9SQvwOuIKJjuD4zE3BRAR8YUrx1g4N
        cM5awX2bnl+YNGhNubtwxtGVayP3+Xm8WqB/Ba52Z7SiC/TLuDzrII0DYIXEEVpR
        B2arDQUOo0n83GM8dCFBVOuwtbU6sNqN9sskeDnvxSEQKOvPbbA7rLghNEDyrKic
        MQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5aaf51bb (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 13 Jan 2020 22:42:47 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, johannes@sipsolutions.net,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 0/8] skb_list_walk_safe refactoring for net/*'s skb_gso_segment usage
Date:   Mon, 13 Jan 2020 18:42:25 -0500
Message-Id: <20200113234233.33886-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adjusts all return values of skb_gso_segment in net/* to
use the new skb_list_walk_safe helper.

First we fix a minor bug in the helper macro that didn't come up in the
last patchset's uses. Then we adjust several cases throughout net/. The
xfrm changes were a bit hairy, but doable. Reading and thinking about
the code in mac80211 indicates a memory leak, which the commit
addresses. All the other cases were pretty trivial.

Jason A. Donenfeld (8):
  net: skbuff: disambiguate argument and member for skb_list_walk_safe
    helper
  net: udp: use skb_list_walk_safe helper for gso segments
  net: xfrm: use skb_list_walk_safe helper for gso segments
  net: openvswitch: use skb_list_walk_safe helper for gso segments
  net: sched: use skb_list_walk_safe helper for gso segments
  net: ipv4: use skb_list_walk_safe helper for gso segments
  net: netfilter: use skb_list_walk_safe helper for gso segments
  net: mac80211: use skb_list_walk_safe helper for gso segments

 include/linux/skbuff.h          |  6 +++---
 net/ipv4/ip_output.c            |  8 +++-----
 net/ipv4/udp.c                  |  3 +--
 net/ipv6/udp.c                  |  3 +--
 net/mac80211/tx.c               | 13 +++++--------
 net/netfilter/nfnetlink_queue.c |  8 +++-----
 net/openvswitch/datapath.c      | 11 ++++-------
 net/sched/sch_cake.c            |  4 +---
 net/sched/sch_tbf.c             |  4 +---
 net/xfrm/xfrm_device.c          | 15 ++++-----------
 net/xfrm/xfrm_output.c          |  9 +++------
 11 files changed, 29 insertions(+), 55 deletions(-)

-- 
2.24.1

