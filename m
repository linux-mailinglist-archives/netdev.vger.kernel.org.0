Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A828B1FE52C
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731689AbgFRCXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 22:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729829AbgFRBRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:17:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF8C021D82;
        Thu, 18 Jun 2020 01:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443071;
        bh=m5MjLN5kHPqximv4jc7KfEfNo/8ZvUuXiLLO/NUGhaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9Wtqzx4iz3mO3jUbqEh14Z1RhHbvWIp+aRbxIPUWQt2I/FNB8CFh968yZ1dn4Sbf
         t3eqkOaDj+9N2Ir2rnvXg92CByuBQp7dkRHhH/AbuMz1Em+kFSdVaG1QdTeKBhIjp6
         2qoaJj4+ufhivzWOyFAh+UA8c6sYDiK+bfKKIZrA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Mike Christie <mchristi@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 059/266] scsi: vhost: Notify TCM about the maximum sg entries supported per command
Date:   Wed, 17 Jun 2020 21:13:04 -0400
Message-Id: <20200618011631.604574-59-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>

[ Upstream commit 5ae6a6a915033bfee79e76e0c374d4f927909edc ]

vhost-scsi pre-allocates the maximum sg entries per command and if a
command requires more than VHOST_SCSI_PREALLOC_SGLS entries, then that
command is failed by it. This patch lets vhost communicate the max sg limit
when it registers vhost_scsi_ops with TCM. With this change, TCM would
report the max sg entries through "Block Limits" VPD page which will be
typically queried by the SCSI initiator during device discovery. By knowing
this limit, the initiator could ensure the maximum transfer length is less
than or equal to what is reported by vhost-scsi.

Link: https://lore.kernel.org/r/1590166317-953-1-git-send-email-sudhakar.panneerselvam@oracle.com
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index a9caf1bc3c3e..88ce114790d7 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2290,6 +2290,7 @@ static struct configfs_attribute *vhost_scsi_wwn_attrs[] = {
 static const struct target_core_fabric_ops vhost_scsi_ops = {
 	.module				= THIS_MODULE,
 	.fabric_name			= "vhost",
+	.max_data_sg_nents		= VHOST_SCSI_PREALLOC_SGLS,
 	.tpg_get_wwn			= vhost_scsi_get_fabric_wwn,
 	.tpg_get_tag			= vhost_scsi_get_tpgt,
 	.tpg_check_demo_mode		= vhost_scsi_check_true,
-- 
2.25.1

