Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D5D3390BA
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbhCLPFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:05:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232127AbhCLPF0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 10:05:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A522664F77;
        Fri, 12 Mar 2021 15:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615561526;
        bh=HxjTi4CD5M5CaHKrmYW6GLRrYkRcRRecOXvwvY5SycA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svR0gzcnVZsBKkm7/hyP5ozparzvN1yR2IXDOh1x6hIJYsOZ1gNBMSFtBTNvd/84F
         yApj2Bfye1NHwLlvcIho376/FZo5jZD+l6bT9cXqWKJ36lX3f54Xp9tEW+mlOqd41f
         0Os3/nWZAUY7k900jzUL5VHd2BG767RzAsLOvfw2BwSZ+bQbyX/kNYHErrI0gXE9aP
         jS1EgsiXobCIfg8uWjmMyFvy45nAAwXbKqmZG/4ovY+5ALCM79Wx2e6wkLuNAPCdgY
         U5Wo6xsLCt4JIksxzE/neyLTDVMJ8qepP2jQS3uEC3mkKvZjY0788//pexzENj0O0A
         ZZCZg3tjXSmdw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 14/16] net: NULL the old xps map entries when freeing them
Date:   Fri, 12 Mar 2021 16:04:42 +0100
Message-Id: <20210312150444.355207-15-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312150444.355207-1-atenart@kernel.org>
References: <20210312150444.355207-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In __netif_set_xps_queue, old map entries from the old dev_maps are
freed but their corresponding entry in the old dev_maps aren't NULLed.
Fix this.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 748e377c7fe3..4f1b38de00ac 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2766,6 +2766,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 					continue;
 			}
 
+			RCU_INIT_POINTER(dev_maps->attr_map[tci], NULL);
 			kfree_rcu(map, rcu);
 		}
 	}
-- 
2.29.2

