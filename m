Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D7C349045
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 12:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhCYLdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 07:33:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231233AbhCYLb0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 07:31:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8197C61A6E;
        Thu, 25 Mar 2021 11:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671685;
        bh=1OFJEdSOk9+k2CitKDCY1YZwj0yGmnKRvZ+OURrxXC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dj44EsAuYtlCNt99CdxODHyRxM/KFBPW6jldU80q2/k+yLEqcbPQVVZRGKdDJwinB
         o9DDo7B+rzOZ4G7pKkrGuE4PQce/MGls/MtpXEcjq5R5z+NAZpKwq0EepYXSQ1jWi0
         2JBNHdOiJN5Reql7/qpCF66IetB6NRZUTJ6qFhbKb7Tt7ssM/vMrP4yc1FOBRhxlLI
         8hK+vnWHcqsTKzCVkFfBKrY+deu435puaRln1wbnHwROXV+VKPgbvaHD857X7nt2sU
         bmdBVA63Pa92lLQ7SkYROE3WP/caRJ6tFo2Ovn/OxmL47fAdaigEOdkZ20ofPwVELr
         j7fjqxcZ3ONWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/16] vhost: Fix vhost_vq_reset()
Date:   Thu, 25 Mar 2021 07:27:45 -0400
Message-Id: <20210325112751.1928421-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112751.1928421-1-sashal@kernel.org>
References: <20210325112751.1928421-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurent Vivier <lvivier@redhat.com>

[ Upstream commit beb691e69f4dec7bfe8b81b509848acfd1f0dbf9 ]

vhost_reset_is_le() is vhost_init_is_le(), and in the case of
cross-endian legacy, vhost_init_is_le() depends on vq->user_be.

vq->user_be is set by vhost_disable_cross_endian().

But in vhost_vq_reset(), we have:

    vhost_reset_is_le(vq);
    vhost_disable_cross_endian(vq);

And so user_be is used before being set.

To fix that, reverse the lines order as there is no other dependency
between them.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Link: https://lore.kernel.org/r/20210312140913.788592-1-lvivier@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 3d7bea15c57b..4b5590f4e98b 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -324,8 +324,8 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->call_ctx = NULL;
 	vq->call = NULL;
 	vq->log_ctx = NULL;
-	vhost_reset_is_le(vq);
 	vhost_disable_cross_endian(vq);
+	vhost_reset_is_le(vq);
 	vq->busyloop_timeout = 0;
 	vq->umem = NULL;
 	vq->iotlb = NULL;
-- 
2.30.1

