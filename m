Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24AF31078F2
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 20:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfKVTtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 14:49:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727176AbfKVTtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 14:49:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 015BB2072E;
        Fri, 22 Nov 2019 19:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574452148;
        bh=TWUIFvYxcxpAcHyaC4L/g1aet1SZVEHMCG8j8roj8dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fF23hjvp1tDxYdvXp9cWBQQsSHn0vb54DZx8JPJ4KaNWCr9UvOfXgNHpCw3yU1CF5
         w/GLYpBPAQTFzj6H8+SAmQJuq2Ho2n9P2/h+F9XHlF4MUoaSs4rmqiiN7ktyz26fWt
         CJbs/qICXsUb2hU1Q10Z1mIrdfpg4BMHvfUfDncc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaodong Xu <stid.smth@gmail.com>, Bo Chen <chenborfc@163.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/25] xfrm: release device reference for invalid state
Date:   Fri, 22 Nov 2019 14:48:41 -0500
Message-Id: <20191122194859.24508-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122194859.24508-1-sashal@kernel.org>
References: <20191122194859.24508-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaodong Xu <stid.smth@gmail.com>

[ Upstream commit 4944a4b1077f74d89073624bd286219d2fcbfce3 ]

An ESP packet could be decrypted in async mode if the input handler for
this packet returns -EINPROGRESS in xfrm_input(). At this moment the device
reference in skb is held. Later xfrm_input() will be invoked again to
resume the processing.
If the transform state is still valid it would continue to release the
device reference and there won't be a problem; however if the transform
state is not valid when async resumption happens, the packet will be
dropped while the device reference is still being held.
When the device is deleted for some reason and the reference to this
device is not properly released, the kernel will keep logging like:

unregister_netdevice: waiting for ppp2 to become free. Usage count = 1

The issue is observed when running IPsec traffic over a PPPoE device based
on a bridge interface. By terminating the PPPoE connection on the server
end for multiple times, the PPPoE device on the client side will eventually
get stuck on the above warning message.

This patch will check the async mode first and continue to release device
reference in async resumption, before it is dropped due to invalid state.

v2: Do not assign address family from outer_mode in the transform if the
state is invalid

v3: Release device reference in the error path instead of jumping to resume

Fixes: 4ce3dbe397d7b ("xfrm: Fix xfrm_input() to verify state is valid when (encap_type < 0)")
Signed-off-by: Xiaodong Xu <stid.smth@gmail.com>
Reported-by: Bo Chen <chenborfc@163.com>
Tested-by: Bo Chen <chenborfc@163.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 790b514f86b62..b0b1294daef17 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -246,6 +246,9 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			else
 				XFRM_INC_STATS(net,
 					       LINUX_MIB_XFRMINSTATEINVALID);
+
+			if (encap_type == -1)
+				dev_put(skb->dev);
 			goto drop;
 		}
 
-- 
2.20.1

