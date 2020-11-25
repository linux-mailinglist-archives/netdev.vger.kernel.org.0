Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42342C4440
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 16:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731768AbgKYPma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 10:42:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730542AbgKYPgW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 10:36:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A51C21527;
        Wed, 25 Nov 2020 15:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318581;
        bh=4gu0UGDR9VqIfsJu+7+Ew5aXzDMrtErgwkWyRjtxuuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYEJTLQSSmGFxYvD4DSM6orTT/mMWOS6FYVe1Iv/y+cfl2/6cXOnWNLbPP+V5iZgv
         T60wA+VnHaMI21evIHPEuJXnoSPRRqzsylczSti5xotaqRDviZpScIYTrR9jWAB/mn
         VwbEPKMM7yHo9EueCRK2LvqzQ4/D6idk0VikQqi4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
Date:   Wed, 25 Nov 2020 10:35:39 -0500
Message-Id: <20201125153550.810101-22-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153550.810101-1-sashal@kernel.org>
References: <20201125153550.810101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 18f1becb6948cd411fd01968a0a54af63732e73c ]

Move code to parse lun from req's lun_buf to helper, so tmf code
can use it in the next patch.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/1604986403-4931-5-git-send-email-michael.christie@oracle.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 5d8850f5aef16..ed7dc6b998f65 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -898,6 +898,11 @@ vhost_scsi_get_req(struct vhost_virtqueue *vq, struct vhost_scsi_ctx *vc,
 	return ret;
 }
 
+static u16 vhost_buf_to_lun(u8 *lun_buf)
+{
+	return ((lun_buf[2] << 8) | lun_buf[3]) & 0x3FFF;
+}
+
 static void
 vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 {
@@ -1036,12 +1041,12 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			tag = vhost64_to_cpu(vq, v_req_pi.tag);
 			task_attr = v_req_pi.task_attr;
 			cdb = &v_req_pi.cdb[0];
-			lun = ((v_req_pi.lun[2] << 8) | v_req_pi.lun[3]) & 0x3FFF;
+			lun = vhost_buf_to_lun(v_req_pi.lun);
 		} else {
 			tag = vhost64_to_cpu(vq, v_req.tag);
 			task_attr = v_req.task_attr;
 			cdb = &v_req.cdb[0];
-			lun = ((v_req.lun[2] << 8) | v_req.lun[3]) & 0x3FFF;
+			lun = vhost_buf_to_lun(v_req.lun);
 		}
 		/*
 		 * Check that the received CDB size does not exceeded our
-- 
2.27.0

