Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1B5206EA0
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389629AbgFXIIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388886AbgFXIIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:08:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FFEC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 01:08:10 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jo0S1-000685-CO; Wed, 24 Jun 2020 10:08:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     steffen.klassert@secunet.com
Cc:     <netdev@vger.kernel.org>
Subject: [PATCH ipsec-next v2 0/6] xfrm: remove xfrm replay indirections
Date:   Wed, 24 Jun 2020 10:07:58 +0200
Message-Id: <20200624080804.7480-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2: fix unitialized variable buf reported by kbuild robot.

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

Florian Westphal (6):
      xfrm: replay: avoid xfrm replay notify indirection
      xfrm: replay: get rid of duplicated notification code
      xfrm: replay: remove advance indirection
      xfrm: replay: remove recheck indirection
      xfrm: replay: avoid replay indirection
      xfrm: replay: remove last replay indirection

 include/net/xfrm.h     |  29 ++++----
 net/xfrm/xfrm_input.c  |   6 +-
 net/xfrm/xfrm_output.c |   2 +-
 net/xfrm/xfrm_replay.c | 189 +++++++++++++++++++++++++++----------------------
 net/xfrm/xfrm_state.c  |   2 +-
 5 files changed, 125 insertions(+), 103 deletions(-)

