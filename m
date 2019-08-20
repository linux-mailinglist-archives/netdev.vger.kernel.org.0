Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A56A95BF5
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 12:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbfHTKFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 06:05:00 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36341 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfHTKFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 06:05:00 -0400
Received: by mail-pl1-f194.google.com with SMTP id f19so2096289plr.3;
        Tue, 20 Aug 2019 03:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rj7SDym9UNxyg0oSA1OfNeIBnB06iO8MD1npAu2+BTI=;
        b=JtxtXgiVKCdj2zs5yiCEZ1rb2h6TGGbtd1BbgNGzkqTztKQhEWYmE6Jqk/73FBDcUx
         4sBlBKTihdiMJR/PLabdINYC5RoZxzXHYlOVTJDqqEa/6kGdZItMPfzYNx8F3Ny3urDy
         BX5/bCANsTwNA9aKKSJeCl/KmsU9F934H0EWSUxtWdk6FW7u4CQJTn9lcIFNIeJoCX8D
         N2Qs2+eKE9a6gQAVCJOtLeHOVYDgJt6Pg1I2W0GaO6qQQVZUiZyyB4K6YoGXBMhuF15H
         hUE7lO/IHljvng6B9MXGWmB0pcdbJLRSjN/+UdetUIcGnNY9lpDN/F5K6WlzOJkgFzB/
         x5ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rj7SDym9UNxyg0oSA1OfNeIBnB06iO8MD1npAu2+BTI=;
        b=szgkW24OvZ8BqmEVW2Cxmx6SCeqe3wf+AskofwMtNRlkP3H17OzDcIFm+sK5+iTIuY
         gslVB3uuK+NeWiTPIMZY3Yc5ZLnFtmgxBJ9lmJOlWEFVWD2irGJ9z23Spq6yW0lAyQOs
         tt2wY+kQQYWcEcnPCPmowR8DKS/EIgafc0knkSLmtcIBzD9qz7rzY0KjuQ9wjVOrTBmL
         yMlraxX+uUkRHRfN24JiwGeeclbSVfDkPGOHcHlq1HkOGd8B6spqRbBRfkAuzFNw60ZX
         OfRH/oq6uT92FErYFV63gv/sYbvLnc8G2W3PGi9dmoJ3+lEZZXtR6IlXI96yhmp2qyYv
         EA0Q==
X-Gm-Message-State: APjAAAWrGgxGCMlCJs7Ut97tufq5KBIvuJg+XzXl1erH0figDAzTfF9s
        nEF14iwo13+PQmCMVUEXaJM=
X-Google-Smtp-Source: APXvYqy+/CbGkRnUzDNk57X5X3BHv5GNk/qLIHNfAWzPlLXSaatbk93fURQJsdlf3TYSO/YYPt58kA==
X-Received: by 2002:a17:902:7d82:: with SMTP id a2mr28078362plm.57.1566295499426;
        Tue, 20 Aug 2019 03:04:59 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id c2sm9078201pjs.13.2019.08.20.03.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 03:04:58 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     bjorn.topel@intel.com, bpf@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, jonathan.lemon@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, magnus.karlsson@intel.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        xdp-newbies@vger.kernel.org, yhs@fb.com, hdanton@sina.com
Subject: [PATCH bpf-next] xsk: proper socket state check in xsk_poll
Date:   Tue, 20 Aug 2019 12:04:05 +0200
Message-Id: <20190820100405.25564-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0000000000009167320590823a8c@google.com>
References: <0000000000009167320590823a8c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The poll() implementation for AF_XDP sockets did not perform the
proper state checks, prior accessing the socket umem. This patch fixes
that by performing a xsk_is_bound() check.

Suggested-by: Hillf Danton <hdanton@sina.com>
Reported-by: syzbot+c82697e3043781e08802@syzkaller.appspotmail.com
Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP rings")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index ee4428a892fa..08bed5e92af4 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -356,13 +356,20 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 	return err;
 }
 
+static bool xsk_is_bound(struct xdp_sock *xs)
+{
+	struct net_device *dev = READ_ONCE(xs->dev);
+
+	return dev && xs->state == XSK_BOUND;
+}
+
 static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 {
 	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
 
-	if (unlikely(!xs->dev))
+	if (unlikely(!xsk_is_bound(xs)))
 		return -ENXIO;
 	if (unlikely(!(xs->dev->flags & IFF_UP)))
 		return -ENETDOWN;
@@ -383,6 +390,9 @@ static unsigned int xsk_poll(struct file *file, struct socket *sock,
 	struct net_device *dev = xs->dev;
 	struct xdp_umem *umem = xs->umem;
 
+	if (unlikely(!xsk_is_bound(xs)))
+		return mask;
+
 	if (umem->need_wakeup)
 		dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
 						umem->need_wakeup);
@@ -417,7 +427,7 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
 {
 	struct net_device *dev = xs->dev;
 
-	if (!dev || xs->state != XSK_BOUND)
+	if (!xsk_is_bound(xs))
 		return;
 
 	xs->state = XSK_UNBOUND;
-- 
2.20.1

