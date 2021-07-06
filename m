Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509ED3BCF7A
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbhGFLae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234127AbhGFL1B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:27:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DCA261D6D;
        Tue,  6 Jul 2021 11:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570399;
        bh=9f4U18zgpgzwMfn2wNYwWW5+rtYiDiEiuDTIc+NA4i8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mArFGm8Rxw0Wxerad562tUhnxkLfrHPg++m8IjCNIYbx6e5S+5qBldQTenqkTaiK2
         XUkp7gWH3Gq3D8a0MeFmBDqQ1vbsWaerBSAsZxYr+KMxhBvedPZ9S3OEmI3TA4bDmm
         UA0v9NyHxL1buNbQKIpQObp7SahgQGGTZS9LicCpQ02lVo1jcmbXO6ngAH+AC6DDCr
         /ZBMn+JhiPpi6sIFd3bzObutKTUtXyb+VCZOf8vpioLbBPRg2ur77sg6bYOat3ZGq/
         QPN7CVAonqi3EWKaBpJIyqq0VASfrf/FljxuEDcQcuEkhnWC97A0kXwWpnr+C2oumL
         7o8IYQmPUP6Qw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 069/160] virtio_net: Remove BUG() to avoid machine dead
Date:   Tue,  6 Jul 2021 07:16:55 -0400
Message-Id: <20210706111827.2060499-69-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xianting Tian <xianting.tian@linux.alibaba.com>

[ Upstream commit 85eb1389458d134bdb75dad502cc026c3753a619 ]

We should not directly BUG() when there is hdr error, it is
better to output a print when such error happens. Currently,
the caller of xmit_skb() already did it.

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 447582fa20a5..f7ce341bb328 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1558,7 +1558,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
 				    virtio_is_little_endian(vi->vdev), false,
 				    0))
-		BUG();
+		return -EPROTO;
 
 	if (vi->mergeable_rx_bufs)
 		hdr->num_buffers = 0;
-- 
2.30.2

