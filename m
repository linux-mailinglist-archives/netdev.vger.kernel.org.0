Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068D14B3948
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 05:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiBMEG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 23:06:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiBMEG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 23:06:27 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DAD5F27D
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 20:06:22 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id g145so11723378qke.3
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 20:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8I8gICuNBArG3pkDEmVK5P9PUYHcWJAkO6uIaANuEpE=;
        b=QE9GrhPcOLOrD8bgDY2pVkfIDKgl0IKocSb9+x/oXOUy6jlvJWZJxO9aIN20+Tlynj
         sXBECxjpeVvLG1aXxxERd9bvEAT46MYhwWzP3FEqqXzvYrvfI5xGXUdaoqv+mAGU9Z2b
         lrkRDnJHNsKZVXamD5Q/2g48uWsoHc6D6yDyCZ+KGjYli7IzftC52Hl8GqZOHMw11RFU
         XNmiMw3s7Y77vIa6UDq0zydROrKELxX7+5gxCNAjOVB5zlecFX0kEa6kx1VMSYohr5Ng
         0NJu1VfNbjicuZpng03gM1L4CYVNs0n6XSCRRyFLc/7f6f6bW3rezE/HOBu/mlcjKiqi
         Z0iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8I8gICuNBArG3pkDEmVK5P9PUYHcWJAkO6uIaANuEpE=;
        b=fcF/17/f72tLoUlP4yfKrFj/jIJcBYzClsk9YIUdivV0Ue8VjgBC2KvOqpZd4h5Giy
         /aEbRbLr4vjkFwDB+62HfDKbFLSogByLOfOuFQ3KqrOys2UxEUJYV6ql1uCwyh49v46N
         bemgQ1eulaZv4Nb8fFiDNb9imu48dqGEEW0rOL4hgbDSwoOUtwxyngCGEVqs3RefUpkl
         sBc86FNMwOachcd0Y9wdexmSjv3H9XIIHSnoP8QPonrNENlpHce3Lrg7+oxlZlLGdax3
         C8y+8cKqdVRUiSTc79TQFnO9K8fddyrq8Q7q9YjucbzD/xiIN6XgxqrsCIWqRQp8nVUw
         FEvw==
X-Gm-Message-State: AOAM5324xzfrUe0/CKwcI7gkreaUhgNYRoIf7jmE3GAkQiQUKW304H2S
        HbRBpddKmUOZmugihYuY1IM=
X-Google-Smtp-Source: ABdhPJxOcX0Ok0kYtBq+gSKeRiPQtXaTNi7x7ULRknWF7vwv1s1QZQcqeEG2YoOf3rBmaEKbyOs5yw==
X-Received: by 2002:a05:620a:470c:: with SMTP id bs12mr4087650qkb.47.1644725181956;
        Sat, 12 Feb 2022 20:06:21 -0800 (PST)
Received: from tian-Alienware-15-R4.fios-router.home (pool-98-113-6-185.nycmny.east.verizon.net. [98.113.6.185])
        by smtp.gmail.com with ESMTPSA id y20sm14773103qtw.28.2022.02.12.20.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Feb 2022 20:06:21 -0800 (PST)
From:   Tian Lan <tilan7663@gmail.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Andrew.Chester@twosigma.com, Tian Lan <Tian.Lan@twosigma.com>
Subject: [PATCH] tcp: allow the initial receive window to be greater than 64KiB
Date:   Sat, 12 Feb 2022 23:05:45 -0500
Message-Id: <20220213040545.365600-1-tilan7663@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tian Lan <Tian.Lan@twosigma.com>

Commit 13d3b1ebe287 ("bpf: Support for setting initial receive window")
introduced a BPF_SOCK_OPS option which allows setting a larger value
for the initial advertised receive window up to the receive buffer space
for both active and passive TCP connections.

However, the commit a337531b942b ("tcp: up initial rmem to 128KB and SYN
rwin to around 64KB") would limit the initial receive window to be at most
64KiB which partially negates the change made previously.

With this patch, the initial receive window will be set to the 
min(64KiB, space) if there is no init_rcv_wnd provided. Else set the
initial receive window to be the min(init_rcv_wnd * mss, space).

Signed-off-by: Tian Lan <Tian.Lan@twosigma.com>
---
 net/ipv4/tcp_output.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5079832af5c1..6fc17efbe70f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -229,13 +229,14 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 	 * which we interpret as a sign the remote TCP is not
 	 * misinterpreting the window field as a signed quantity.
 	 */
-	if (sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows)
-		(*rcv_wnd) = min(space, MAX_TCP_WINDOW);
-	else
-		(*rcv_wnd) = min_t(u32, space, U16_MAX);
-
-	if (init_rcv_wnd)
-		*rcv_wnd = min(*rcv_wnd, init_rcv_wnd * mss);
+	if (sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows) {
+		*rcv_wnd = min(space, MAX_TCP_WINDOW);
+		if (init_rcv_wnd)
+			*rcv_wnd = min(*rcv_wnd, init_rcv_wnd * mss);
+	} else {
+		*rcv_wnd = (init_rcv_wnd ? init_rcv_wnd * mss : U16_MAX);
+		*rcv_wnd = min_t(u32, *rcv_wnd, space);
+	}
 
 	*rcv_wscale = 0;
 	if (wscale_ok) {
-- 
2.25.1

