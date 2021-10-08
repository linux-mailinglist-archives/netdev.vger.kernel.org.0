Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5770A426CAC
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 16:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237740AbhJHOXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 10:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229756AbhJHOXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 10:23:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B17D661073;
        Fri,  8 Oct 2021 14:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633702866;
        bh=fmQt8v0FI8vFvz1/u9FYFw/uN9gfIO1CuYFBXqwdD8k=;
        h=From:To:Cc:Subject:Date:From;
        b=sMWjZbaYxh6lVFJ7iOKKNu7TUzsy0GdCDCddyBhENlrq/eBr3AkRsHbb+jVXKdAhD
         BaSvKanILeKydLi2R2o1P/tgk3scavaIaq5GYlOj2d/UyfoHrMFCbkZkFgWQz/xXsR
         o9B1JGpsEqnncTBmneArFOfOCDk05aZ+eioVoY1S2g87FQTOQkiKWiJtkp/k4OTv26
         wzr9kM3x5GYGkPSIUaFfyccAUmK8OgaLQ+aIHcZHlbIxyBbgmELSwVT0Ag5OTxobOm
         T5wn+7CZ/FR49BlmnZ6RqCGHYVFldluRT1gDiV/EAzfFgdpXJxaFqfE9XduARdWStM
         kb2oUBV02lx2Q==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: make dev_get_port_parent_id slightly more readable
Date:   Fri,  8 Oct 2021 16:21:03 +0200
Message-Id: <20211008142103.732398-1-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cosmetic commit making dev_get_port_parent_id slightly more readable.
There is no need to split the condition to return after calling
devlink_compat_switch_id_get and after that 'recurse' is always true.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/dev.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 16ab09b6a7f8..35fb32279d7f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9159,14 +9159,11 @@ int dev_get_port_parent_id(struct net_device *dev,
 	}
 
 	err = devlink_compat_switch_id_get(dev, ppid);
-	if (!err || err != -EOPNOTSUPP)
+	if (!recurse || err != -EOPNOTSUPP)
 		return err;
 
-	if (!recurse)
-		return -EOPNOTSUPP;
-
 	netdev_for_each_lower_dev(dev, lower_dev, iter) {
-		err = dev_get_port_parent_id(lower_dev, ppid, recurse);
+		err = dev_get_port_parent_id(lower_dev, ppid, true);
 		if (err)
 			break;
 		if (!first.id_len)
-- 
2.31.1

