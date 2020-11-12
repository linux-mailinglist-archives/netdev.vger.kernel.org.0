Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3812B0419
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgKLLmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbgKLLl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:41:26 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C99C0613D1;
        Thu, 12 Nov 2020 03:41:26 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id w14so4279376pfd.7;
        Thu, 12 Nov 2020 03:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p+7zqDEUsInVWiiKbv2mU/avNMxBK0HvJzz4eBBZxRg=;
        b=PqWAOovk2sbOSLyqp3MndWVByj8dXqw5jmHdXY4t1K0YdH7mlmNwQ7p2mJqOl61mNm
         APbyqGP/F9W0eAn3QScLKpoeNOklbfJscYkh7x+Jn+gizX9XoOxDNvjMklH787D7Y7tc
         tDpCYM/7c97inoIajWfKhn1cOU4YMJCJnmgJSK9bzLIuKpNFTD/iEVcbh8Xuz3Z176tf
         w3jVqVQ3ef5/RLkRNYgtEJAJ1OgOEASphiU/ltfjN/u06G8HBZk2aOaMPFPfut9RgX/q
         h5UtTN3h5FgvKzwukwnUOIX8m0SotZmLHdg7D7HgjcbQwPrML0tu5J/EmNdRKAQU99vH
         oobA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p+7zqDEUsInVWiiKbv2mU/avNMxBK0HvJzz4eBBZxRg=;
        b=mkoOlwa7MZDLm6MKLSoQARA/JKFWSnhJs4bGhaRSvWRp6+JU48abQuefm7QJeRHiNB
         DB7YNJQjqJWMTrNrTE8LBnH6uwaWay0cePajW+MCdIG3crqfn0XAYIv+1vR0DKUqVrdw
         Qn+FhAsnvuuCf82bKNleoZMkbUWjBxJKfWRxntFCbSF8d6TRuq5+7yTVzbSeH+kKRg87
         jm8GxAXPpbdd4KCUeUe+1BeGBsKYx0+nj2V+JlyXSVEqOFgEyYjC4eCILaTtTdGA24fv
         t5H701hzZDu2LXc+VLMRHiDav4QwSBSMWMEZnMCnF3CeHnmWc23t6EJgq4B+uK7GuNOg
         XTUQ==
X-Gm-Message-State: AOAM533QMW7xy5fl/IuRQsh+xt7gVwrzWlIuaik3L1oqXgxkiEBtlvl4
        uIncYWhJw7lCKfu2yyNINwt6/kZfFVnqQA==
X-Google-Smtp-Source: ABdhPJySR8Nb3lqQoX7/ng9AYuz1ZP54Oorn9hNSI0+hRLCCIXYYpr/gvlAeng/Qr5dHi0FqrKEOvg==
X-Received: by 2002:a63:fc1c:: with SMTP id j28mr24487449pgi.95.1605181285000;
        Thu, 12 Nov 2020 03:41:25 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id y8sm6161629pfe.33.2020.11.12.03.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:41:23 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next 3/9] xsk: add support for recvmsg()
Date:   Thu, 12 Nov 2020 12:40:35 +0100
Message-Id: <20201112114041.131998-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201112114041.131998-1-bjorn.topel@gmail.com>
References: <20201112114041.131998-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Add support for non-blocking recvmsg() to XDP sockets. Previously,
only sendmsg() was supported by XDP socket. Now, for symmetry and the
upcoming busy-polling support, recvmsg() is added.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index b71a32eeae65..17d51d1a5752 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -474,6 +474,26 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	return __xsk_sendmsg(sk);
 }
 
+static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
+{
+	bool need_wait = !(flags & MSG_DONTWAIT);
+	struct sock *sk = sock->sk;
+	struct xdp_sock *xs = xdp_sk(sk);
+
+	if (unlikely(!(xs->dev->flags & IFF_UP)))
+		return -ENETDOWN;
+	if (unlikely(!xs->rx))
+		return -ENOBUFS;
+	if (unlikely(!xsk_is_bound(xs)))
+		return -ENXIO;
+	if (unlikely(need_wait))
+		return -EOPNOTSUPP;
+
+	if (xs->pool->cached_need_wakeup & XDP_WAKEUP_RX && xs->zc)
+		return xsk_wakeup(xs, XDP_WAKEUP_RX);
+	return 0;
+}
+
 static __poll_t xsk_poll(struct file *file, struct socket *sock,
 			     struct poll_table_struct *wait)
 {
@@ -1134,7 +1154,7 @@ static const struct proto_ops xsk_proto_ops = {
 	.setsockopt	= xsk_setsockopt,
 	.getsockopt	= xsk_getsockopt,
 	.sendmsg	= xsk_sendmsg,
-	.recvmsg	= sock_no_recvmsg,
+	.recvmsg	= xsk_recvmsg,
 	.mmap		= xsk_mmap,
 	.sendpage	= sock_no_sendpage,
 };
-- 
2.27.0

