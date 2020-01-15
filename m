Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C698213C158
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgAOMoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:44:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:57474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgAOMoH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:44:07 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A414F2465A;
        Wed, 15 Jan 2020 12:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579092247;
        bh=Vx7YqZ/k22cc8K5Q83ICDc15J5HPJf1Ilju5QsfJpH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wn+xJQ8bN1Vq262yJ+ALIMQbBXA2jvdUB7daXmdKTCanSMwhZIZdeOKF5c+LNgzFL
         HZoGYJqwwa4xSXZesnGagrEbsX5i1SR/mjEyrK1nvHJyZeTDYh+FL/YxvqEHRJ4SQ9
         YAOalELfroimSCw3AQHwo+DzHXzmQn2kcsA6H7QI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 08/10] net/rds: Detect need of On-Demand-Paging memory registration
Date:   Wed, 15 Jan 2020 14:43:38 +0200
Message-Id: <20200115124340.79108-9-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115124340.79108-1-leon@kernel.org>
References: <20200115124340.79108-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>

Add code to check if memory intended for RDMA is FS-DAX-memory. RDS
will fail with error code EOPNOTSUPP if FS-DAX-memory is detected.

Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 net/rds/rdma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 916f5ec373d8..eb23c38ce2b3 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -156,11 +156,13 @@ void rds_rdma_drop_keys(struct rds_sock *rs)
 static int rds_pin_pages(unsigned long user_addr, unsigned int nr_pages,
 			struct page **pages, int write)
 {
+	unsigned int gup_flags = FOLL_LONGTERM;
 	int ret;

-	ret = get_user_pages_fast(user_addr, nr_pages, write ? FOLL_WRITE : 0,
-				  pages);
+	if (write)
+		gup_flags |= FOLL_WRITE;

+	ret = get_user_pages_fast(user_addr, nr_pages, gup_flags, pages);
 	if (ret >= 0 && ret < nr_pages) {
 		while (ret--)
 			put_page(pages[ret]);
--
2.20.1

