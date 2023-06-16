Return-Path: <netdev+bounces-11384-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B440732D9D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:26:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8014281677
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A2718B02;
	Fri, 16 Jun 2023 10:26:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B076918C1B
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD969C433CD;
	Fri, 16 Jun 2023 10:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686911180;
	bh=PFdVP3w56nb0swUwL53Xe87mE6lCu9SOZzlblVkMk7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hT7Qfcds3Wr5cKyDDQ1DYdqpK9MxpfRcQhUmsEK0q6EEZtrHP96WDfYs4kJ5dpa7a
	 KjML+zhKcdP6gD+XUFVy33w8nijZhAD4RBe4Y0z/4NwCGQ+52DFEjEPsAy8f8VpX/g
	 V/f+Ahny6fx6Jh26jBBCgWPH/kyp28ECUNPi4agdZsVJlW1KKP36bHk9mAH6+Vg0YD
	 +wxY7QMb9K+2tIJXqLHtmLsd28g98A6QTscpfPbFyZt9wsc0EXSKJHstMemjQzKAeq
	 UW29PTUE0OFmMoxNbei12tjVukscBgyl6iTq6hsu0yiXHBm1xYDFrSKddPVf1OdySZ
	 XT5fUmlkY8XVg==
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
Subject: [PATCH AUTOSEL 6.3 29/30] vhost_vdpa: tell vqs about the negotiated
Date: Fri, 16 Jun 2023 06:25:17 -0400
Message-Id: <20230616102521.673087-29-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230616102521.673087-1-sashal@kernel.org>
References: <20230616102521.673087-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.3.8
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
index 74c7d1f978b75..a5e4722cbeda1 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -385,7 +385,10 @@ static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *featurep)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	struct vhost_dev *d = &v->vdev;
+	u64 actual_features;
 	u64 features;
+	int i;
 
 	/*
 	 * It's not allowed to change the features after they have
@@ -400,6 +403,16 @@ static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *featurep)
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


