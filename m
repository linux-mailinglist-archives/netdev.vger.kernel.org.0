Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E5B3F54B7
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 02:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbhHXA42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 20:56:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234352AbhHXAza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BA0B613A7;
        Tue, 24 Aug 2021 00:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766482;
        bh=wcH7vU2eTeQRAkcXC8NdS1JplMlqCQXC0XZMfkTE6z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBGSSXtrdCxbP6E2V3LcpbxzcBE99cdyjobvg85Sm8UaUFtjjAVYSnNyKVojI+eLx
         s9VSGnuPrU1QGewOb8Ogw38BXo+ZIubSeq2Q9OJ/67o8FbbVYg+njTF9dpCPUy4E/M
         W5wtip6bIvvyhnmjeLxESjFrgOZPJpjO4H00vttxE4QUO/4QjXt8wH8IthnAL9mJNU
         u9n7c7OATF8nFIaVbl/SZaRviakWrO1b2E1mw4zzOkiStM9PtCCalVFousrFq5NI0t
         SPWNYV1ZZgXXud9fqtC4cN+SntvbO3MRjQaorzdv+X4n5qDpLfCN1U84I+GrSqrcgo
         UThdEl3IjP0NQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neeraj Upadhyay <neeraju@codeaurora.org>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/18] vringh: Use wiov->used to check for read/write desc order
Date:   Mon, 23 Aug 2021 20:54:21 -0400
Message-Id: <20210824005432.631154-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005432.631154-1-sashal@kernel.org>
References: <20210824005432.631154-1-sashal@kernel.org>
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
index b7403ba8e7f7..0bd7e64331f0 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -341,7 +341,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
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

