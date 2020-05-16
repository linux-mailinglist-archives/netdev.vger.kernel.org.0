Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8111D5FBC
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 10:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgEPIqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 04:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgEPIqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 04:46:46 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051E4C061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 01:46:45 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jZsSx-0005rz-DX; Sat, 16 May 2020 10:46:43 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     pabeni@redhat.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net
Subject: [PATCH net-next 0/7] mptcp: do not block on subflow socket
Date:   Sat, 16 May 2020 10:46:16 +0200
Message-Id: <20200516084623.28453-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series reworks mptcp_sendmsg logic to avoid blocking on the subflow
socket.

It does so by removing the wait loop from mptcp_sendmsg_frag helper.

In order to do that, it moves prerequisites that are currently
handled in mptcp_sendmsg_frag (and cause it to wait until they are
met, e.g. frag cache refill) into the callers.

The worker can just reschedule in case no subflow socket is ready,
since it can't wait -- doing so would block other work items and
doesn't make sense anyway because we should not (re)send data
in case resources are already low.

The sendmsg path can use the existing wait logic until memory
becomes available.

Because large send requests can result in multiple mptcp_sendmsg_frag
calls from mptcp_sendmsg, we may need to restart the socket lookup in
case subflow can't accept more data or memory is low.

Doing so blocks on the mptcp socket, and existing wait handling
releases the msk lock while blocking.

Lastly, no need to use GFP_ATOMIC for extension allocation:
extend __skb_ext_alloc with gfp_t arg instead of hard-coded ATOMIC and
then relax the allocation constraints for mptcp case: those requests
occur in process context.

Florian Westphal (7):
      mptcp: move common nospace-pattern to a helper
      mptcp: break and restart in case mptcp sndbuf is full
      mptcp: avoid blocking in tcp_sendpages
      mptcp: fill skb extension cache outside of mptcp_sendmsg_frag
      mptcp: fill skb page frag cache outside of mptcp_sendmsg_frag
      mptcp: remove inner wait loop from mptcp_sendmsg_frag
      net: allow __skb_ext_alloc to sleep

 include/linux/skbuff.h |   2 +-
 net/core/skbuff.c      |   8 +--
 net/mptcp/protocol.c   | 139 ++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 109 insertions(+), 40 deletions(-)

