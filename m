Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD3B1E5BFA
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbfJZNVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728839AbfJZNVQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:21:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EBB42070B;
        Sat, 26 Oct 2019 13:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096075;
        bh=HnPFZ02iVfbrTtvh0ZuA8QJY/hHOGIQtzcqYGZ1T/1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5aJPvc7LGTIlfA6zBJNsMWYKPHCIO2LIy3YHcbyOB/qdL3BBbRMt3/H1UZ15juYB
         ID5Fn8UXti5IS6z2Gnn94Ub1mj6Cw7grAmOXi2bm7H7Qs3plBdE2tGXx2kPDZSU6Nu
         4+evbH3Cy0IUJ2rfEDfIv6m5BSH/8O8tN8FpLLwM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Hubert Feurstein <h.feurstein@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/33] net: dsa: b53: Do not clear existing mirrored port mask
Date:   Sat, 26 Oct 2019 09:20:41 -0400
Message-Id: <20191026132110.4026-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026132110.4026-1-sashal@kernel.org>
References: <20191026132110.4026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit c763ac436b668d7417f0979430ec0312ede4093d ]

Clearing the existing bitmask of mirrored ports essentially prevents us
from capturing more than one port at any given time. This is clearly
wrong, do not clear the bitmask prior to setting up the new port.

Reported-by: Hubert Feurstein <h.feurstein@gmail.com>
Fixes: ed3af5fd08eb ("net: dsa: b53: Add support for port mirroring")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index acf64d4cd94cb..434e6dced6b7f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1431,7 +1431,6 @@ int b53_mirror_add(struct dsa_switch *ds, int port,
 		loc = B53_EG_MIR_CTL;
 
 	b53_read16(dev, B53_MGMT_PAGE, loc, &reg);
-	reg &= ~MIRROR_MASK;
 	reg |= BIT(port);
 	b53_write16(dev, B53_MGMT_PAGE, loc, reg);
 
-- 
2.20.1

