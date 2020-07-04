Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F039214924
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 01:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgGDXab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 19:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgGDXab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 19:30:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B5EC061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 16:30:31 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jrrc3-0004pK-1j; Sun, 05 Jul 2020 01:30:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <mptcp@lists.01.org>
Subject: [PATCH net-next 0/3] mptcp: add REUSEADDR/REUSEPORT/V6ONLY setsockopt support
Date:   Sun,  5 Jul 2020 01:30:14 +0200
Message-Id: <20200704233017.20831-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

restarting an mptcp-patched sshd yields following error:

  sshd: error: Bind to port 22 on 0.0.0.0 failed: Address already in use.
  sshd: error: setsockopt IPV6_V6ONLY: Operation not supported
  sshd: error: Bind to port 22 on :: failed: Address already in use.
  sshd: fatal: Cannot bind any address.

This series adds support for the needed setsockopts:

First patch skips the generic SOL_SOCKET handler for MPTCP:
in mptcp case, the setsockopt needs to alter the tcp socket, not the mptcp
parent socket.

Second patch adds minimal SOL_SOCKET support: REUSEPORT and REUSEADDR.
Rest is still handled by the generic SOL_SOCKET code.

Last patch adds IPV6ONLY support.  This makes ipv6 work for openssh:
It creates two listening sockets, before this patch, binding the ipv6
socket will fail because the port is already bound by the ipv4 one.

Florian Westphal (3):
      net: use mptcp setsockopt function for SOL_SOCKET on mptcp sockets
      mptcp: add REUSEADDR/REUSEPORT support
      mptcp: support IPV6_V6ONLY setsockopt

 net/mptcp/protocol.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 net/socket.c         | 13 ++++++++++-
 2 files changed, 76 insertions(+), 1 deletion(-)

