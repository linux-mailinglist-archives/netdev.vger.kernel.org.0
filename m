Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218EA206EA5
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390306AbgFXIIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390293AbgFXIIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:08:19 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A246C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 01:08:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jo0S9-00068a-Mb; Wed, 24 Jun 2020 10:08:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     steffen.klassert@secunet.com
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 2/6] xfrm: replay: get rid of duplicated notification code
Date:   Wed, 24 Jun 2020 10:08:00 +0200
Message-Id: <20200624080804.7480-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624080804.7480-1-fw@strlen.de>
References: <20200624080804.7480-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After previous patch, we can consolidate some code:

xfrm_replay_notify, xfrm_replay_notify_bmp and _esn all contain the
same code at the end.

Remove it from xfrm_replay_notify_bmp/esn and reuse the one
in xfrm_replay_notify.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/xfrm/xfrm_replay.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index e42a7afb8ee5..fac2f3af4c1a 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -56,10 +56,10 @@ void xfrm_replay_notify(struct xfrm_state *x, int event)
 		break;
 	case XFRM_REPLAY_MODE_BMP:
 		xfrm_replay_notify_bmp(x, event);
-		return;
+		goto notify;
 	case XFRM_REPLAY_MODE_ESN:
 		xfrm_replay_notify_esn(x, event);
-		return;
+		goto notify;
 	}
 
 	switch (event) {
@@ -86,6 +86,8 @@ void xfrm_replay_notify(struct xfrm_state *x, int event)
 	}
 
 	memcpy(&x->preplay, &x->replay, sizeof(struct xfrm_replay_state));
+
+notify:
 	c.event = XFRM_MSG_NEWAE;
 	c.data.aevent = event;
 	km_state_notify(x, &c);
@@ -290,7 +292,6 @@ static void xfrm_replay_advance_bmp(struct xfrm_state *x, __be32 net_seq)
 
 static void xfrm_replay_notify_bmp(struct xfrm_state *x, int event)
 {
-	struct km_event c;
 	struct xfrm_replay_state_esn *replay_esn = x->replay_esn;
 	struct xfrm_replay_state_esn *preplay_esn = x->preplay_esn;
 
@@ -330,19 +331,11 @@ static void xfrm_replay_notify_bmp(struct xfrm_state *x, int event)
 
 	memcpy(x->preplay_esn, x->replay_esn,
 	       xfrm_replay_state_esn_len(replay_esn));
-	c.event = XFRM_MSG_NEWAE;
-	c.data.aevent = event;
-	km_state_notify(x, &c);
-
-	if (x->replay_maxage &&
-	    !mod_timer(&x->rtimer, jiffies + x->replay_maxage))
-		x->xflags &= ~XFRM_TIME_DEFER;
 }
 
 static void xfrm_replay_notify_esn(struct xfrm_state *x, int event)
 {
 	u32 seq_diff, oseq_diff;
-	struct km_event c;
 	struct xfrm_replay_state_esn *replay_esn = x->replay_esn;
 	struct xfrm_replay_state_esn *preplay_esn = x->preplay_esn;
 
@@ -396,13 +389,6 @@ static void xfrm_replay_notify_esn(struct xfrm_state *x, int event)
 
 	memcpy(x->preplay_esn, x->replay_esn,
 	       xfrm_replay_state_esn_len(replay_esn));
-	c.event = XFRM_MSG_NEWAE;
-	c.data.aevent = event;
-	km_state_notify(x, &c);
-
-	if (x->replay_maxage &&
-	    !mod_timer(&x->rtimer, jiffies + x->replay_maxage))
-		x->xflags &= ~XFRM_TIME_DEFER;
 }
 
 static int xfrm_replay_overflow_esn(struct xfrm_state *x, struct sk_buff *skb)
-- 
2.26.2

