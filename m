Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E005228A02
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgGUUhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGUUhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:37:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB641C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:37:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jxz0a-0003up-GH; Tue, 21 Jul 2020 22:37:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mathew.j.martineau@linux.intel.com, edumazet@google.com,
        mptcp@lists.01.org, matthieu.baerts@tessares.net
Subject: [RFC v2 mptcp-next 01/12] mptcp: add syncookie support
Date:   Tue, 21 Jul 2020 22:36:30 +0200
Message-Id: <20200721203642.32753-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TL;DR: please review the changes in TCP for sanity, thanks.

This RFC series adds syn cookie support to MPTCP.

At this time, when syn-cookies are used and the SYN had an MPTCP-option,
the cookie SYNACK is sent with MPTCP option cleared, as the code path
that creates a request socket based off a valid ACK token lacks the
needed changes to construct MPTCP request sockets.

After this series, if SYN carries an MPTCP option, the MPTCP option is
not cleared anymore and reconstruction will be done using the MPTCP option
that is re-sent with the ACK.

No additional state gets encoded into the syn cookie or the timestamp.

There are differences from the normal (syn queue) case with MPTCP:

I. When syn-cookies are used, the server-generated key is not stored,
   it is best-effort only: Storing state would defeat the purpose of
   cookies.

The drawback is that the next connection request that comes in before
the cookie-ACK has a small chance that it will generate the same
local_key.

If this happens, the cookie ACK that comes in "second" (and contains
the local and remote key in mptcp options) will recompute the token hash
and then detects that this is already in use.
This results in late TCP fallback, i.e. the connection sock is not marked
as mptcp capable.

II). SYN packets containing a MP_JOIN requests cannot be handled without
     storing state.  This is because the SYN contains a nonce value that
     we need to validate the HMAC of the MP_JOIN ACK that completes 3whs.

There are only 2 ways to solve this:
 a). Do not support JOINs when cookies are used.
 b). Store the nonce somewhere.

The approach chosen here is b), by allowing the MPTCP init_req function to
override the listener sockets queue limits and store the request socket
anyway.

This is subject to following constraints:
1. The token in the JOIN request is valid (i.e. it refers an
   established MPTCP connection).
2. The MPTCP connection can still accept a new subflow.

Extra accounting is added to the MPTCP parent socket.  In case the
parent already has too many subflow connections (including half-open ones),
cookie mode is used instead (which won't work for a join request).
This will trigger TCP fallback + RST when ack comes back to notify
peer about failed JOIN.

I've added comments to a few of the TCP patches to suggest alternative
approaches for a few details.

Comments welcome.

Florian Westphal (12):
      tcp: remove cookie_ts bit from request_sock
      tcp: syncookies: use single reqsk_free location
      mptcp: token: move retry to caller
      mptcp: subflow: split subflow_init_req into helpers
      mptcp: rename and export mptcp_subflow_request_sock_ops
      tcp: remove sk_listener const qualifier from req_init function
      tcp: pass want_cookie down to req_init function
      mptcp: subflow: add mptcp_subflow_init_cookie_req helper
      tcp: syncookies: keep mptcp option enabled
      tcp: handle want_cookie clause via reqsk_put
      mptcp: enable JOIN requests even if cookies are in use
      selftests: mptcp: make 2nd net namespace use tcp syn cookies unconditionally

 drivers/crypto/chelsio/chtls/chtls_cm.c            |   1 -
 include/net/mptcp.h                                |  11 ++
 include/net/request_sock.h                         |   3 +-
 include/net/tcp.h                                  |   5 +-
 net/ipv4/syncookies.c                              |  40 ++--
 net/ipv4/tcp_input.c                               |  14 +-
 net/ipv4/tcp_ipv4.c                                |   5 +-
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv6/syncookies.c                              |  17 +-
 net/ipv6/tcp_ipv6.c                                |   5 +-
 net/mptcp/pm_netlink.c                             |   2 +-
 net/mptcp/protocol.h                               |   3 +
 net/mptcp/subflow.c                                | 203 +++++++++++++++++----
 net/mptcp/token.c                                  |  38 +++-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |  50 +++++
 15 files changed, 321 insertions(+), 78 deletions(-)

