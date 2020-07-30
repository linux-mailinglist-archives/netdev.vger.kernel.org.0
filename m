Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3B42338EE
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbgG3T0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgG3T0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:26:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB35C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:26:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k1EBo-0003VH-F3; Thu, 30 Jul 2020 21:26:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     edumazet@google.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: [PATCH v2 net-next 0/9] mptcp: add syncookie support
Date:   Thu, 30 Jul 2020 21:25:49 +0200
Message-Id: <20200730192558.25697-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v2:
- first patch renames req->ts_cookie to req->syncookie instead of
  removing ts_cookie member.
- patch to add 'want_cookie' arg to init_req() functions has been dropped.
  All users of that arg were changed to check 'req->syncookie' instead.

v1 cover letter:

When syn-cookies are used the SYN?ACK never contains a MPTCP option,
because the code path that creates a request socket based on a valid
cookie ACK lacks the needed changes to construct MPTCP request sockets.

After this series, if SYN carries MP_CAPABLE option, the option is not
cleared anymore and request socket will be reconstructed using the
MP_CAPABLE option data that is re-sent with the ACK.

This means that no additional state gets encoded into the syn cookie or
the TCP timestamp.

There are two caveats for SYN-Cookies with MPTCP:

1. When syn-cookies are used, the server-generated key is not stored.
The drawback is that the next connection request that comes in before
the cookie-ACK has a small chance that it will generate the same local_key.

If this happens, the cookie ACK that comes in second will (re)compute the
token hash and then detects that this is already in use.
Unlike normal case, where the server will pick a new key value and then
re-tries, we can't do that because we already committed to the key value
(it was sent to peer already).

Im this case, MPTCP cannot be used and late TCP fallback happens.

2). SYN packets with a MP_JOIN requests cannot be handled without storing
    state. This is because the SYN contains a nonce value that is needed to
    verify the HMAC of the MP_JOIN ACK that completes the three-way
    handshake.  Also, a local nonce is generated and used in the cookie
    SYN/ACK.

There are only 2 ways to solve this:
 a) Do not support JOINs when cookies are in effect.
 b) Store the nonces somewhere.

The approach chosen here is b).
Patch 8 adds a fixed-size (1024 entries) state table to store the
information required to validate the MP_JOIN ACK and re-build the
request socket.

State gets stored when syn-cookies are active and the token in the JOIN
request referred to an established MPTCP connection that can also accept
a new subflow.

State is restored if the ACK cookie is valid, an MP_JOIN option is present
and the state slot contains valid data from a previous SYN.

After the request socket has been re-build, normal HMAC check is done just
as without syn cookies.

Largely identical to last RFC, except patch #8 which follows Paolos
suggestion to use a private table storage area rather than keeping
request sockets around.  This also means I dropped the patch to remove
const qualifier from sk_listener pointers.

Florian Westphal (9):
      tcp: rename request_sock cookie_ts bit to syncookie
      mptcp: token: move retry to caller
      mptcp: subflow: split subflow_init_req
      mptcp: rename and export mptcp_subflow_request_sock_ops
      mptcp: subflow: add mptcp_subflow_init_cookie_req helper
      tcp: syncookies: create mptcp request socket for ACK cookies with MPTCP option
      mptcp: enable JOIN requests even if cookies are in use
      selftests: mptcp: make 2nd net namespace use tcp syn cookies unconditionally
      selftests: mptcp: add test cases for mptcp join tests with syn cookies

 drivers/crypto/chelsio/chtls/chtls_cm.c            |   2 +-
 include/net/mptcp.h                                |  11 ++
 include/net/request_sock.h                         |   2 +-
 include/net/tcp.h                                  |   2 +
 net/ipv4/syncookies.c                              |  44 ++++++-
 net/ipv4/tcp_input.c                               |   6 +-
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv6/syncookies.c                              |   5 +-
 net/mptcp/Makefile                                 |   1 +
 net/mptcp/ctrl.c                                   |   1 +
 net/mptcp/protocol.h                               |  21 ++++
 net/mptcp/subflow.c                                | 116 +++++++++++++++---
 net/mptcp/syncookies.c                             | 132 +++++++++++++++++++++
 net/mptcp/token.c                                  |  38 ++++--
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |  47 ++++++++
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  66 ++++++++++-
 16 files changed, 453 insertions(+), 43 deletions(-)
 create mode 100644 net/mptcp/syncookies.c

