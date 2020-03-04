Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A25F1787C4
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 02:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387480AbgCDBzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 20:55:02 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36968 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387406AbgCDBzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 20:55:02 -0500
Received: by mail-pl1-f193.google.com with SMTP id b8so279797plx.4;
        Tue, 03 Mar 2020 17:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KHKOkzT6FKCHf5W6DLoCVwvsWrrT80ew9b3fr7GlCe4=;
        b=Ia6LFwn0NZWO//0aW9+5FpHgym5/uDmqHXPLBi8/HgKFKh0ssrTiGZw3aXdLohkcY/
         Ol8so0/doI0LZRj0OtX9Wv0QJ+BASsBVvTZvF1VhxJvA1C1qsoLhy23dk+PKz78SoEI3
         L3ldcJFo/AyzEFrmoTL6nk7viS1gPUtZgXzqCyjpI8nHhcGBIk8RFSXAyvU19Vwkyqac
         /TZOk+/itTlA673RT8LZmSxmHwMiCcHGTJbpJKTAxVYCu1Gl+r+2dUXnvp9fCrfGix2O
         js0PHOOoQlOoj3Kly3Rb1jINzxDpaZPG8/r2IOFsw7wKMMoyG0bbQzGSpBlkimFoHqFl
         Dlyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KHKOkzT6FKCHf5W6DLoCVwvsWrrT80ew9b3fr7GlCe4=;
        b=PCdIMH7r+Jb6W2JZTeO0Z5G9Tkv6B6tca8LKlmhTd4wXGgRFTUpwlXqRzaHEBzj9DP
         OTe5HNDdPTM+0GEnQROYptA3qy/7RZOaeDH4qFv1IOS/6x54Fo5fFF6kHpqMo2uGCoyO
         xKECm4bST4QNQu2ljw0YIi9b9b/8/jWLVrt9LG3aCk7oafFn14t/W2UlOc58wgkAY/a8
         DZJ/Ce1mAaYnJrKlZ35+DODPKsM+E2T2ey5Htyf5AJKTFoajX23Vco/RbCuCQ1bx4z83
         9vgsQ+8g1B90eRRDpytG+9/ceY/ZPmsTw8hWkuxOQbohixIgDbB9lbgF7VlSeMs3O+6M
         qYUg==
X-Gm-Message-State: ANhLgQ16WcDiJl2GkfMVK/qDGsWim4C5Bpq5fvnEoP2eI7S813PF/kpm
        KYHjtURH2TPQUGBNuema++E=
X-Google-Smtp-Source: ADFU+vsn4O9prDyrAgjQDSFlDhDtMu35YiyfSMcvd4UbRmsCHBFAdzVOJuhd5F2hqVg73XWlR4QwaQ==
X-Received: by 2002:a17:90b:30c2:: with SMTP id hi2mr501364pjb.7.1583286900749;
        Tue, 03 Mar 2020 17:55:00 -0800 (PST)
Received: from localhost.localdomain.localdomain ([103.90.76.242])
        by smtp.gmail.com with ESMTPSA id t11sm424224pjo.21.2020.03.03.17.54.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 17:55:00 -0800 (PST)
From:   Lidong Jiang <jianglidong@gmail.com>
To:     davem@davemloft.net
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jianglidong3@jd.com
Subject: [PATCH] veth: ignore peer tx_dropped when counting local rx_dropped
Date:   Wed,  4 Mar 2020 09:49:29 +0800
Message-Id: <1583286569-144923-1-git-send-email-jianglidong@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiang Lidong <jianglidong3@jd.com>

When local NET_RX backlog is full due to traffic overrun,
peer veth tx_dropped counter increases. At that time, list
local veth stats, rx_dropped has double value of peer
tx_dropped, even bigger than transmit packets by peer.

In NET_RX softirq process, if any packet drop case happens,
it increases dev's rx_dropped counter and returns NET_RX_DROP.

At veth tx side, it records any error returned from peer netif_rx
into local dev tx_dropped counter.

In veth get stats process, it puts local dev rx_dropped and
peer dev tx_dropped into together as local rx_drpped value.
So that it shows double value of real dropped packets number in
this case.

This patch ignores peer tx_dropped when counting local rx_dropped,
since peer tx_dropped is duplicated to local rx_dropped at most cases.

Signed-off-by: Jiang Lidong <jianglidong3@jd.com>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index a552df3..bad9e03 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -328,7 +328,7 @@ static void veth_get_stats64(struct net_device *dev,
 	rcu_read_lock();
 	peer = rcu_dereference(priv->peer);
 	if (peer) {
-		tot->rx_dropped += veth_stats_tx(peer, &packets, &bytes);
+		veth_stats_tx(peer, &packets, &bytes);
 		tot->rx_bytes += bytes;
 		tot->rx_packets += packets;
 
-- 
1.8.3.1

