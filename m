Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2681D3D0C
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbgENTLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728240AbgENSwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:52:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B526620675;
        Thu, 14 May 2020 18:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482335;
        bh=YI+9V7nau8O3qGjdI0S6gJb+jAvnb6N82/kQ5n1bFtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1omJXutsLfT85/4XI0o0UbLxCLua+U7eK8oEB4HOAOFdFVgd0XCjo5TG3O7+DQ5Xn
         ZArxj8IO9Kka+fpyAWj4VK6eUkVkKpLvUSM70Glr3LwMDFdnMms2twhqm0YXQaKE7b
         +0jKGu+PlKCF1k8B8M9IHaMuzxpEv69gbbF8O08Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juliet Kim <julietk@linux.vnet.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.6 21/62] ibmvnic: Skip fatal error reset after passive init
Date:   Thu, 14 May 2020 14:51:06 -0400
Message-Id: <20200514185147.19716-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Juliet Kim <julietk@linux.vnet.ibm.com>

[ Upstream commit f9c6cea0b38518741c8dcf26ac056d26ee2fd61d ]

During MTU change, the following events may happen.
Client-driven CRQ initialization fails due to partner’s CRQ closed,
causing client to enqueue a reset task for FATAL_ERROR. Then passive
(server-driven) CRQ initialization succeeds, causing client to
release CRQ and enqueue a reset task for failover. If the passive
CRQ initialization occurs before the FATAL reset task is processed,
the FATAL error reset task would try to access a CRQ message queue
that was freed, causing an oops. The problem may be most likely to
occur during DLPAR add vNIC with a non-default MTU, because the DLPAR
process will automatically issue a change MTU request.

Fix this by not processing fatal error reset if CRQ is passively
initialized after client-driven CRQ initialization fails.

Signed-off-by: Juliet Kim <julietk@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 4bd33245bad62..3de549c6c6930 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2189,7 +2189,8 @@ static void __ibmvnic_reset(struct work_struct *work)
 				rc = do_hard_reset(adapter, rwi, reset_state);
 				rtnl_unlock();
 			}
-		} else {
+		} else if (!(rwi->reset_reason == VNIC_RESET_FATAL &&
+				adapter->from_passive_init)) {
 			rc = do_reset(adapter, rwi, reset_state);
 		}
 		kfree(rwi);
-- 
2.20.1

