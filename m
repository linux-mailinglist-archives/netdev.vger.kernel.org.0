Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B5E3ACCC7
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbhFRNya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbhFRNy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:54:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1E9C061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 06:52:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1luEup-0006v9-89; Fri, 18 Jun 2021 15:52:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, sd@queasysnail.net,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 0/5] xfrm: remove xfrm replay indirections
Date:   Fri, 18 Jun 2021 15:51:55 +0200
Message-Id: <20210618135200.14420-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is v2 of an older patchset that got stuck in backlog hell. Changes:

 - drop bogus "get rid of duplicated notification code" patch. As noted
   by Sabrina it does change behavior.
 - fix a compiler warning in patch 2.

ipsec.c selftest passes.

The xfrm replay logic is implemented via indirect calls.

xfrm_state struct holds a pointer to a
'struct xfrm_replay', which is one of several replay protection
backends.

XFRM then invokes the backend via state->repl->callback().
Due to retpoline all indirect calls have become a lot more
expensive.  Fortunately, there are no 'replay modules', all are available
for direct calls.

This series removes the 'struct xfrm_replay' and adds replay
functions that can be called instead of the redirection.

Example:
  -  err = x->repl->overflow(x, skb);
  +  err = xfrm_replay_overflow(x, skb);

Instead of a pointer to a struct with function pointers, xfrm_state
now holds an enum that tells the replay core what kind of replay
test is to be done.

Florian Westphal (5):
  xfrm: replay: avoid xfrm replay notify indirection
  xfrm: replay: remove advance indirection
  xfrm: replay: remove recheck indirection
  xfrm: replay: avoid replay indirection
  xfrm: replay: remove last replay indirection

 include/net/xfrm.h     |  29 ++++---
 net/xfrm/xfrm_input.c  |   6 +-
 net/xfrm/xfrm_output.c |   2 +-
 net/xfrm/xfrm_replay.c | 171 +++++++++++++++++++++++++----------------
 net/xfrm/xfrm_state.c  |   2 +-
 5 files changed, 123 insertions(+), 87 deletions(-)

-- 
2.31.1
