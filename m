Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9673F5526
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 02:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhHXBAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 21:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233986AbhHXA5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 20:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77560617E2;
        Tue, 24 Aug 2021 00:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766542;
        bh=qhESlreqaguGA6UjYwAFl9MniaY/yGL8vZMgJ69S/zY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQcbf4OsSTUMWcexDJg6LKYFdW3xQkGX3kgU+bF+RK7rtq8V3yTdKqSGfjLTc2yy5
         oNggMYYiZfu+3lXKiBg5ZZcVCTVIjQDvuXYh/cFCVMQK2Wfbjmerq9v1YI9O0MbLKJ
         0ty5wfylSsCfyJ7NfYgWnaWwO2TPVewZnxp/cKhQFS5W4fXrutBTVo9Oo3oeoVfAc8
         sAvLbUADY3bxqHUyydwKB+6t1UdmEZ9Cc6OVcdqXd5lkMA7b3glwniedZKhFn4O39T
         7M99vaYyn9+1on7XsSsByB3Eqr6XwnnKtjWqR6qYFKOhIQq4i0pk2AUZQJKK7+Qbm5
         7aHEzv0PWnXkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neeraj Upadhyay <neeraju@codeaurora.org>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/3] vringh: Use wiov->used to check for read/write desc order
Date:   Mon, 23 Aug 2021 20:55:38 -0400
Message-Id: <20210824005539.631820-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005539.631820-1-sashal@kernel.org>
References: <20210824005539.631820-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neeraj Upadhyay <neeraju@codeaurora.org>

[ Upstream commit e74cfa91f42c50f7f649b0eca46aa049754ccdbd ]

As __vringh_iov() traverses a descriptor chain, it populates
each descriptor entry into either read or write vring iov
and increments that iov's ->used member. So, as we iterate
over a descriptor chain, at any point, (riov/wriov)->used
value gives the number of descriptor enteries available,
which are to be read or written by the device. As all read
iovs must precede the write iovs, wiov->used should be zero
when we are traversing a read descriptor. Current code checks
for wiov->i, to figure out whether any previous entry in the
current descriptor chain was a write descriptor. However,
iov->i is only incremented, when these vring iovs are consumed,
at a later point, and remain 0 in __vringh_iov(). So, correct
the check for read and write descriptor order, to use
wiov->used.

Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Link: https://lore.kernel.org/r/1624591502-4827-1-git-send-email-neeraju@codeaurora.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index d56736655dec..da47542496cc 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -329,7 +329,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 			iov = wiov;
 		else {
 			iov = riov;
-			if (unlikely(wiov && wiov->i)) {
+			if (unlikely(wiov && wiov->used)) {
 				vringh_bad("Readable desc %p after writable",
 					   &descs[i]);
 				err = -EINVAL;
-- 
2.30.2

