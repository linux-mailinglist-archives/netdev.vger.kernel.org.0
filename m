Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5011C496EC2
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 01:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235414AbiAWAOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 19:14:15 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46196 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbiAWAN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 19:13:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7CE1CE0ACC;
        Sun, 23 Jan 2022 00:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D7DC340E2;
        Sun, 23 Jan 2022 00:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896769;
        bh=94AMPHSOMB0HPZgdjyDj+IRBX/Gt+wzDLbqEMbirc/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWGoU3AJkD9nVjesHd/41OidCDOR1jnscq454XaScSgH70WVt5RlUaiWfpNZ029sh
         mmvIAfK4pshIjw5BmrDPcANOJlwrl1DE4B5QajzhGR8wC/SBubMA0s4yXvWPwAmzMG
         4OiJVlWAp6KeQXJCb3+66zp8nd5sVJ92M4vF71dEkL3FnVXAVVw6pBQ4Vb+maQ7Pog
         AKh86q0F6Tt1BRNWy4r/s6aVJ6rpfrOunIR3wrVfOALjLMuxNBasZQmCUjyiGHaW+K
         FfshlZJcTXBHqRCGtpiSvnYJ+K2U31mWJhXL53E9ZgAFGxDX1NBSbWp84fkCA2lyaT
         kXn23q2YGfTSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 12/16] vhost/test: fix memory leak of vhost virtqueues
Date:   Sat, 22 Jan 2022 19:12:11 -0500
Message-Id: <20220123001216.2460383-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001216.2460383-1-sashal@kernel.org>
References: <20220123001216.2460383-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xianting Tian <xianting.tian@linux.alibaba.com>

[ Upstream commit 080063920777af65105e5953e2851e036376e3ea ]

We need free the vqs in .release(), which are allocated in .open().

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Link: https://lore.kernel.org/r/20211228030924.3468439-1-xianting.tian@linux.alibaba.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index a09dedc79f682..05740cba1cd89 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -166,6 +166,7 @@ static int vhost_test_release(struct inode *inode, struct file *f)
 	/* We do an extra flush before freeing memory,
 	 * since jobs can re-queue themselves. */
 	vhost_test_flush(n);
+	kfree(n->dev.vqs);
 	kfree(n);
 	return 0;
 }
-- 
2.34.1

