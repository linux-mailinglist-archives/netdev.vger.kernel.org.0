Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3849D2B4228
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbgKPLEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 06:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729672AbgKPLEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 06:04:52 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFFBC0613CF;
        Mon, 16 Nov 2020 03:04:51 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id g11so8191036pll.13;
        Mon, 16 Nov 2020 03:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nr+2+6WRXsWhaA4LWd2Xz+d3TWMWGlcn6FscD/LmIDc=;
        b=Pcpv/MCkdP6bai7FyIzGwNvCNtAUZtXGnbVFOZxkqEhLn6dslYTgk+iNOVFKnyxTPT
         t1H49Hd6BnMb+T4G2d5fztETfp+t2d0R5X/+4Av3ChQ6BWPHSTWsMLAW5Q5lsAjTGVkA
         TyPa6eb7BOdQIZ3O2PWMvvrW8b9yndZB46zJobeCHQ/+NxA2B22VCzoD7cBFbRpvEWPt
         GIAKb8PeMW59YB1uvpTxkivaoEzmWRs69YYa/mXbq6KYglBzcoCqm4ad8zXwy8v/mH4T
         Mue6NO/isP/gepAYoYwIpXzYmYyp05gHOeGHkTPOwTV6LguHJmul10omx+11Kf5tWfFk
         vRMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nr+2+6WRXsWhaA4LWd2Xz+d3TWMWGlcn6FscD/LmIDc=;
        b=sGi4MzYXJ+fmQjyzxOyEnd583zfT1rmGH7B4XRXzCEqGOnO00BBE8Ql9gsm7iOdpAh
         LSvPDLflkBH7ygsnh4ma1Hozp8JLbPVXuIBno1niO+C6crmLzweoM0jNyboHsIxED94s
         NV3FEmiV4yRAZVmqGcF5EHjgD5ilFqh4eP9ZePTtyRuowSEDXs5yEUN/OXhBl9cpNaDJ
         PxosZUDWxM/QqanvuFP323rBc9cBq0UDymEIGP3OVyhZJ2lJcRMiEMQ7o9Ue4FUi75I1
         DjZv75hUzP5diSbENLVy5RQaKgp2pI4YqaS1ASTy99E25ol+1EzFlhgh6LZ/at3auc9M
         W3jw==
X-Gm-Message-State: AOAM530Ak/vgRKdX6DeoyJ+D5KYA3n66kWUk3a0WsMmY0v73wPvMALLw
        XmpJhgm6SXV5wUJgzSS4ajbtn0y3cj5Q4w==
X-Google-Smtp-Source: ABdhPJyRlFJPKUbSQXmeU6NwNWag7nMK4Crl7ZweRgADm7I773CM6DvFhRoMRb9bhp4ij9VIfUsFJg==
X-Received: by 2002:a17:902:bf48:b029:d8:abd5:7670 with SMTP id u8-20020a170902bf48b02900d8abd57670mr12095512pls.85.1605524690354;
        Mon, 16 Nov 2020 03:04:50 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id a23sm15752890pgv.35.2020.11.16.03.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 03:04:49 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v2 03/10] xsk: add support for recvmsg()
Date:   Mon, 16 Nov 2020 12:04:09 +0100
Message-Id: <20201116110416.10719-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201116110416.10719-1-bjorn.topel@gmail.com>
References: <20201116110416.10719-1-bjorn.topel@gmail.com>
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
index cfbec3989a76..bda23bd919ad 100644
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

