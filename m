Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955C9340D49
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhCRSjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232733AbhCRSie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 14:38:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 695076023B;
        Thu, 18 Mar 2021 18:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616092714;
        bh=uzN94fHajMiIsjzbQO3pvYjF0ozKYC3ReK8q4UiFoiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQ80vv+bj9tUCXPRMUmGV3VL48u8qHv4Aq1OjU2LD5hyjnKb4BtqRHTJ0zTdcdOr2
         wfCOE09n0tglqaJxR9XgLs3YRwN0Py6JY5zs8BoeCg7mo1gcYd0jnodcDdubQNQTI1
         +B+V+7bwoNEMg2PZi0oaGA7KCdx7zkkwGODxCmsnrNpe2C7C1WJxASdv/v0iTmcYD2
         yv2Ousg/7PoQKoC8cjgVQHBeeTmkzFrTdn/WJuQLjisLxLmWMtRL1ytphAWd3oE8bN
         kMPyuno0zB6S17Y8AQs0hzjd4SwN2OJHhleELYDL7rx6sxtsFnhL5flyzlACEUd4h1
         rqMe6F3TFmc5g==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v4 13/13] net: NULL the old xps map entries when freeing them
Date:   Thu, 18 Mar 2021 19:37:52 +0100
Message-Id: <20210318183752.2612563-14-atenart@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318183752.2612563-1-atenart@kernel.org>
References: <20210318183752.2612563-1-atenart@kernel.org>
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
index d5f6ba209f1e..4961fc2e9b19 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2764,6 +2764,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 					continue;
 			}
 
+			RCU_INIT_POINTER(dev_maps->attr_map[tci], NULL);
 			kfree_rcu(map, rcu);
 		}
 	}
-- 
2.30.2

