Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DB73D5D2B
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 17:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbhGZO6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 10:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234828AbhGZO57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 10:57:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A83660E08;
        Mon, 26 Jul 2021 15:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627313907;
        bh=01/JO6usR+VPk1oBGw6nYtyQUuT9bYjtw/c5SW8nOK4=;
        h=From:To:Cc:Subject:Date:From;
        b=PFAUZxnu/BSpW1blskUPPm10wnLnVLm5oFycXdoYiCumvF+Wa7C9IYuzIILk6t+f1
         fbW29/B+MB6XR6cL60TmpuIRUg3JTpYjDKu6xb11MwEmbBKNTAF/AK0BQgUYiIvitu
         5226mZb3LEPQ81IyObgs52WCoGh+YLm7tM0q9m3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH net] af_unix: fix garbage collect vs. MSG_PEEK
Date:   Mon, 26 Jul 2021 17:36:21 +0200
Message-Id: <20210726153621.2658658-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2514; i=gregkh@linuxfoundation.org; h=from:subject; bh=bz3syxy3B1km/gtEPYOzOd3gBFTVjESC3kq691QUQek=; b=owGbwMvMwCRo6H6F97bub03G02pJDAn/rmXbKGUkriuZuN5O4OM5KU6hg2/F2msydtkl5xxbO++y j7lgRywLgyATg6yYIsuXbTxH91ccUvQytD0NM4eVCWQIAxenAExE7wfDHM5lZwSZnUx376y9IBnCwS 18UbjgPMOC+f8ZPtkdPCn4YsV/174ZVztnCHf0AQA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

Gc assumes that in-flight sockets that don't have an external ref can't
gain one while unix_gc_lock is held.  That is true because
unix_notinflight() will be called before detaching fds, which takes
unix_gc_lock.

Only MSG_PEEK was somehow overlooked.  That one also clones the fds, also
keeping them in the skb.  But through MSG_PEEK an external reference can
definitely be gained without ever touching unix_gc_lock.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/af_unix.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

Note, this is a resend of this old submission that somehow fell through
the cracks:
	https://lore.kernel.org/netdev/CAOssrKcfncAYsQWkfLGFgoOxAQJVT2hYVWdBA6Cw7hhO8RJ_wQ@mail.gmail.com/
and was never submitted "properly" and this issue never seemed to get
resolved properly.

I've cleaned it up and made the change much smaller and localized to
only one file.  I kept Miklos's authorship as he did the hard work on
this, I just removed lines and fixed a formatting issue :)


diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 23c92ad15c61..cdea997aa5bf 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1526,6 +1526,18 @@ static int unix_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
 	return err;
 }
 
+static void unix_peek_fds(struct scm_cookie *scm, struct sk_buff *skb)
+{
+	scm->fp = scm_fp_dup(UNIXCB(skb).fp);
+
+	/* During garbage collection it is assumed that in-flight sockets don't
+	 * get a new external reference.  So we need to wait until current run
+	 * finishes.
+	 */
+	spin_lock(&unix_gc_lock);
+	spin_unlock(&unix_gc_lock);
+}
+
 static int unix_scm_to_skb(struct scm_cookie *scm, struct sk_buff *skb, bool send_fds)
 {
 	int err = 0;
@@ -2175,7 +2187,7 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 		sk_peek_offset_fwd(sk, size);
 
 		if (UNIXCB(skb).fp)
-			scm.fp = scm_fp_dup(UNIXCB(skb).fp);
+			unix_peek_fds(&scm, skb);
 	}
 	err = (flags & MSG_TRUNC) ? skb->len - skip : size;
 
@@ -2418,7 +2430,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 			/* It is questionable, see note in unix_dgram_recvmsg.
 			 */
 			if (UNIXCB(skb).fp)
-				scm.fp = scm_fp_dup(UNIXCB(skb).fp);
+				unix_peek_fds(&scm, skb);
 
 			sk_peek_offset_fwd(sk, chunk);
 
-- 
2.32.0

