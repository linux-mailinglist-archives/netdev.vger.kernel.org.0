Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B62353BED
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhDEFua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:50:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232120AbhDEFu2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:50:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B823B6138A;
        Mon,  5 Apr 2021 05:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617601822;
        bh=ZX6nMrTjbVRTF1HIZ1FsEV+ThojL4OW20xRXaCnWaVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtNlK/zpqXVFmqJNkjBVG1/n2H61wpYEGMcLmjuJ+NKNQml0wJ7YOIthbbkZa2qRV
         BBhLKACy0SZ0gAPrYjjZOXQj33NyknO5tktvAf4Q8IEmGEacZGQXUz39GayNo+5ZVH
         wF2OmwOcxk/htZYzTAGJX8qvlja3+JxmBj3aEIZWPFEhB9WsTj32FV+oPrCfR9CKP4
         FsEyJ0jgTOEohy+ovR/86YxtHe16s/yHFYMEiKAP6j/n3c/klRzJkQ4N3N0TciDaCH
         ksbTt0rZI+qwn4DljChW3yGeP7m14USIkfK3eKKR2r/eIEyUtBAi1cU0/HWVWLjumu
         DDR6MP8Sa7sew==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: [PATCH rdma-next 6/8] IB/opa_vnic: Move to client_supported callback
Date:   Mon,  5 Apr 2021 08:49:58 +0300
Message-Id: <20210405055000.215792-7-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405055000.215792-1-leon@kernel.org>
References: <20210405055000.215792-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Move to newly introduced client_supported callback
Avoid client registration using newly introduced helper callback if the
IB device doesn't have OPA VNIC capability.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
index cecf0f7cadf9..58658eba97dd 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
@@ -121,6 +121,7 @@ static struct ib_client opa_vnic_client = {
 	.name   = opa_vnic_driver_name,
 	.add    = opa_vnic_vema_add_one,
 	.remove = opa_vnic_vema_rem_one,
+	.is_supported = rdma_cap_opa_vnic,
 };
 
 /**
@@ -993,9 +994,6 @@ static int opa_vnic_vema_add_one(struct ib_device *device)
 	struct opa_vnic_ctrl_port *cport;
 	int rc, size = sizeof(*cport);
 
-	if (!rdma_cap_opa_vnic(device))
-		return -EOPNOTSUPP;
-
 	size += device->phys_port_cnt * sizeof(struct opa_vnic_vema_port);
 	cport = kzalloc(size, GFP_KERNEL);
 	if (!cport)
-- 
2.30.2

