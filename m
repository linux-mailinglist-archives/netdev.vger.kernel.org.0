Return-Path: <netdev+bounces-11386-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E17732DB8
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:27:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E87951C20852
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0178418B0C;
	Fri, 16 Jun 2023 10:27:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B982C174CB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B945EC43215;
	Fri, 16 Jun 2023 10:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686911236;
	bh=PqWY0Izk+DDcwQcpaRdD0UwcVqLKMHm+disNuaNZoD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puh6NNJfQBvGU5xSV6m3tIGhSsKtm5G4fSKT0WiO2kckgluwDnQxQ7K9dD3eKRhry
	 3Yk+oczTz3OTohINMsPAI5M5CskUltsEEiudu3LQrqFidbOo7gKMB2rsirbIajXVbi
	 2VXTN2+xoCdhDPWfb71P8O1Rysc3MoNv2FB09GzGT9Xb+urTGTd3ktOC+lJWhbrXjb
	 //yqLrIvBbLeFRuKH8Emyy21gNo8gKeBHz5IrxhDRsm8nwt8jlBVTlGE+NFYpsvJ38
	 xzKC7a6OZA0Y5W59yG03clVZ+uyV5bisES70n3uSQFPAs6yj92Iq1sMJ0P+oMAYmiR
	 M57xN7OLyKUVw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Shannon Nelson <shannon.nelson@amd.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 25/26] vhost_vdpa: tell vqs about the negotiated
Date: Fri, 16 Jun 2023 06:26:22 -0400
Message-Id: <20230616102625.673454-25-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230616102625.673454-1-sashal@kernel.org>
References: <20230616102625.673454-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.34
Content-Transfer-Encoding: 8bit

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 376daf317753ccb6b1ecbdece66018f7f6313a7f ]

As is done in the net, iscsi, and vsock vhost support, let the vdpa vqs
know about the features that have been negotiated.  This allows vhost
to more safely make decisions based on the features, such as when using
PACKED vs split queues.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20230424225031.18947-2-shannon.nelson@amd.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 6f532da59e08a..57f7c71da571c 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -377,7 +377,10 @@ static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *featurep)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	struct vhost_dev *d = &v->vdev;
+	u64 actual_features;
 	u64 features;
+	int i;
 
 	/*
 	 * It's not allowed to change the features after they have
@@ -392,6 +395,16 @@ static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *featurep)
 	if (vdpa_set_features(vdpa, features))
 		return -EINVAL;
 
+	/* let the vqs know what has been configured */
+	actual_features = ops->get_driver_features(vdpa);
+	for (i = 0; i < d->nvqs; ++i) {
+		struct vhost_virtqueue *vq = d->vqs[i];
+
+		mutex_lock(&vq->mutex);
+		vq->acked_features = actual_features;
+		mutex_unlock(&vq->mutex);
+	}
+
 	return 0;
 }
 
-- 
2.39.2


