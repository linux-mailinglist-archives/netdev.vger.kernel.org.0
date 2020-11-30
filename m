Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DA12C8829
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 16:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgK3PhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 10:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbgK3PhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 10:37:24 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56605C0613CF;
        Mon, 30 Nov 2020 07:36:44 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kjlEJ-0001za-0y; Mon, 30 Nov 2020 16:36:43 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mptcp@lists.01.org, linux-security-module@vger.kernel.org
Subject: [PATCH net-next 0/3] mptcp: reject invalid mp_join requests right away
Date:   Mon, 30 Nov 2020 16:36:28 +0100
Message-Id: <20201130153631.21872-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment MPTCP can detect an invalid join request (invalid token,
max number of subflows reached, and so on) right away but cannot reject
the connection until the 3WHS has completed.
Instead the connection will complete and the subflow is reset afterwards.

To send the reset most information is already available, but we don't have
good spot where the reset could be sent:

1. The ->init_req callback is too early and also doesn't allow to return an
   error that could be used to inform the TCP stack that the SYN should be
   dropped.

2. The ->route_req callback lacks the skb needed to send a reset.

3. The ->send_synack callback is the best fit from the available hooks,
   but its called after the request socket has been inserted into the queue
   already. This means we'd have to remove it again right away.

From a technical point of view, the second hook would be best:
 1. Its before insertion into listener queue.
 2. If it returns NULL TCP will drop the packet for us.

Problem is that we'd have to pass the skb to the function just for MPTCP.

Paolo suggested to merge init_req and route_req callbacks instead:
This makes all info available to MPTCP -- a return value of NULL drops the
packet and MPTCP can send the reset if needed.

Because 'route_req' has a 'const struct sock *', this means either removal
of const qualifier, or a bit of code churn to pass 'const' in security land.

This does the latter; I did not find any spots that need write access to struct
sock.

To recap, the two alternatives are:
1. Solve it entirely in MPTCP: use the ->send_synack callback to
   unlink the request socket from the listener & drop it.
2. Avoid 'security' churn by removing the const qualifier.


