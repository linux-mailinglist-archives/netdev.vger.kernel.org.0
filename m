Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2284523EBFE
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 13:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgHGLJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 07:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728091AbgHGKxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 06:53:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B6DC0617A9
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 03:52:24 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1k3zym-0004nB-Ib; Fri, 07 Aug 2020 12:52:04 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1k3zyk-0007IK-6V; Fri, 07 Aug 2020 12:52:02 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        syzbot+5322482fe520b02aea30@syzkaller.appspotmail.com,
        linux-stable <stable@vger.kernel.org>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH v1 2/5] can: j1939: transport: j1939_session_tx_dat(): fix use-after-free read in j1939_tp_txtimer()
Date:   Fri,  7 Aug 2020 12:51:57 +0200
Message-Id: <20200807105200.26441-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200807105200.26441-1-o.rempel@pengutronix.de>
References: <20200807105200.26441-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current stack implementation do not support ECTS requests of not
aligned TP sized blocks.

If ECTS will request a block with size and offset spanning two TP
blocks, this will cause memcpy() to read beyond the queued skb (which
does only contain one TP sized block).

Sometimes KASAN will detect this read if the memory region beyond the
skb was previously allocated and freed. In other situations it will stay
undetected. The ETP transfer in any case will be corrupted.

This patch adds a sanity check to avoid this kind of read and abort the
session with error J1939_XTP_ABORT_ECTS_TOO_BIG.

Reported-by: syzbot+5322482fe520b02aea30@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Cc: linux-stable <stable@vger.kernel.org> # >= v5.4
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/can/j1939/transport.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index b135c5e2a86e..30957c9a8eb7 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -787,6 +787,18 @@ static int j1939_session_tx_dat(struct j1939_session *session)
 		if (len > 7)
 			len = 7;
 
+		if (offset + len > se_skb->len) {
+			netdev_err_once(priv->ndev,
+					"%s: 0x%p: requested data outside of queued buffer: offset %i, len %i, pkt.tx: %i\n",
+					__func__, session, skcb->offset, se_skb->len , session->pkt.tx);
+			return -EOVERFLOW;
+		}
+
+		if (!len) {
+			ret = -ENOBUFS;
+			break;
+		}
+
 		memcpy(&dat[1], &tpdat[offset], len);
 		ret = j1939_tp_tx_dat(session, dat, len + 1);
 		if (ret < 0) {
@@ -1120,6 +1132,9 @@ static enum hrtimer_restart j1939_tp_txtimer(struct hrtimer *hrtimer)
 		 * cleanup including propagation of the error to user space.
 		 */
 		break;
+	case -EOVERFLOW:
+		j1939_session_cancel(session, J1939_XTP_ABORT_ECTS_TOO_BIG);
+		break;
 	case 0:
 		session->tx_retry = 0;
 		break;
-- 
2.28.0

