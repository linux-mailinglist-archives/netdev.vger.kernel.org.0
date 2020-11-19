Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE55C2B8D4A
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgKSIbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgKSIbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:31:07 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67421C0613CF;
        Thu, 19 Nov 2020 00:31:07 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 81so3588006pgf.0;
        Thu, 19 Nov 2020 00:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qwp3HnTQ1KIV3ZM7P7W+zS8ITdMe0k/nV49s52PE+/w=;
        b=Sy8blwcpm1LYdmxM4fqaMSl2wIfym+jbdfwbljy5LEUxGIcmqQJbS6Tjzg5M7m84Z/
         Gx6/sf8qTns7HxrxOJgq64i5n94Y5Ef4uS/tyh+mUfH8s5OuY02waUYyhSf8XKesLqTB
         VP/GSUJYRoeMPO5BKLmfXvm/h1/wJyVGvO930lyJfD/Gs+4pRO6YGs1qnbdZCzGAxGaw
         n4uCD+ag7F0T1oDCZxjYcgzLGCB+UPrYLpVt5bhx8NhaQNYiomp449wOtOC5NxeMnpUu
         sJiVjIaa2zcISMy6ThDCCB6AjokYQX+cvEgZTeB1mYdkrPtrGRFiEpozqIIz1dVz4Hk5
         ryhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qwp3HnTQ1KIV3ZM7P7W+zS8ITdMe0k/nV49s52PE+/w=;
        b=VWM4wFCxFNTdXjTSQ5ykPIp+oIQ/tbNSxvdRqWPkgN9q+0JLrgSXc8Tg9SlSf4PN/u
         nQG5pWbl/T0TMswlgfp+OySPj8ZQ/58li589KHAvNIZXbfQUw1fwmLLNyMs28CWRBy3G
         nLTykBZcXHZxxMPSJQik91pTWxzbcdKEKb9sPl669N/s6gjqqu4CTs/1eQfz97ELyCKF
         I1mLy58xVc7yF4J9in8ctkQTrFnofNDDLOXpw8iR1vwJbBY1BAgjs0hLCnfHsUuPItuW
         K5ltAzNZRN+n22jvJ04Va9XzKVEXISculZ8uyWPTocWzYUM4qig6syym5cnJ6CXL2GVn
         sykA==
X-Gm-Message-State: AOAM531Z/Duh7sHDzmqPOqbVRJx/E75FNdHwVVsShLMaKRXo/sub0pgG
        MX9ckHKiPPM8T7WU76IANp+SmAVHL9xehr28
X-Google-Smtp-Source: ABdhPJzidSilzubl+VpvUsorRR3CHDu7DgNKkee4FCwbyf4gl8daq0r3+XAYf/Ji7k21qab2cg5V4w==
X-Received: by 2002:a17:90b:345:: with SMTP id fh5mr3404492pjb.198.1605774666425;
        Thu, 19 Nov 2020 00:31:06 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id r2sm5517713pji.55.2020.11.19.00.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 00:31:05 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v3 03/10] xsk: add support for recvmsg()
Date:   Thu, 19 Nov 2020 09:30:17 +0100
Message-Id: <20201119083024.119566-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201119083024.119566-1-bjorn.topel@gmail.com>
References: <20201119083024.119566-1-bjorn.topel@gmail.com>
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
index b0141973f23e..56a52ec75696 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -531,6 +531,26 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
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
@@ -1191,7 +1211,7 @@ static const struct proto_ops xsk_proto_ops = {
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

