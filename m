Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C46822DE72
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 13:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgGZLU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 07:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbgGZLU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 07:20:26 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E16B720663;
        Sun, 26 Jul 2020 11:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595762425;
        bh=+zpQdwd8JTVYIwu1KLBwbvGSZRAgktrPzvW4ONWBHog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=voyv4xQ0ejHrLd4ONreSK+JDIOutOvoc89qOHyW4/Qa8H19zidB1TmzZGt9MoWR6P
         KSLh3P6I/9H2bsWBf5fWNCdU4zhpQ30lKggfegg/cQx9dFYVkj8n1OqrvpY297DHo0
         n8Ry6vIjAzpxR2Dzr6WNr+RcZ8Eui95WgaB4I6Ac=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Mark Zhang <markz@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Ido Kalir <idok@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [RFC PATCH iproute2-next 3/3] rdma: Document the new "pid" criteria for auto mode
Date:   Sun, 26 Jul 2020 14:20:11 +0300
Message-Id: <20200726112011.75905-4-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200726112011.75905-1-leon@kernel.org>
References: <20200726112011.75905-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Document the new supported criteria of auto mode. Examples:
$ rdma statistic qp set link mlx5_2/1 auto pid on
$ rdma statistic qp set link mlx5_2/1 auto pid,type on

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Ido Kalir <idok@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 man/man8/rdma-statistic.8 | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/man/man8/rdma-statistic.8 b/man/man8/rdma-statistic.8
index 7de495c9..7160bcdf 100644
--- a/man/man8/rdma-statistic.8
+++ b/man/man8/rdma-statistic.8
@@ -68,11 +68,11 @@ rdma-statistic \- RDMA statistic counter configuration

 .ti -8
 .IR CRITERIA " := "
-.RB "{ " type " }"
+.RB "{ " type " | " pid " }"

 .ti -8
 .IR FILTER_NAME " := "
-.RB "{ " cntn " | " lqpn " | " pid " }"
+.RB "{ " cntn " | " lqpn " | " pid " | " qp-type " }"

 .SH "DESCRIPTION"
 .SS rdma statistic [object] show - Queries the specified RDMA device for RDMA and driver-specific statistics. Show the default hw counters if object is not specified
@@ -88,7 +88,7 @@ rdma-statistic \- RDMA statistic counter configuration
 - specifies a filter to show only the results matching it.

 .SS rdma statistic <object> set - configure counter statistic auto-mode for a specific device/port
-In auto mode all objects belong to one category are bind automatically to a single counter set. Not applicable for MR's.
+In auto mode all objects belong to one category are bind automatically to a single counter set. The "off" is global for all auto modes together. Not applicable for MR's.

 .SS rdma statistic <object> bind - manually bind an object (e.g., a qp) with a counter
 When bound the statistics of this object are available in this counter. Not applicable for MR's.
@@ -127,6 +127,11 @@ rdma statistic qp show link mlx5_2 pid 30489
 Shows the state of all qp counters of specified RDMA port and belonging to pid 30489
 .RE
 .PP
+rdma statistic qp show link mlx5_2 qp-type UD
+.RS 4
+Shows the state of all qp counters of specified RDMA port and with QP type UD
+.RE
+.PP
 rdma statistic qp mode
 .RS 4
 List current counter mode on all devices
@@ -139,7 +144,17 @@ List current counter mode of device mlx5_2 port 1
 .PP
 rdma statistic qp set link mlx5_2/1 auto type on
 .RS 4
-On device mlx5_2 port 1, for each new QP bind it with a counter automatically. Per counter for QPs with same qp type in each process. Currently only "type" is supported.
+On device mlx5_2 port 1, for each new user QP bind it with a counter automatically. Per counter for QPs with same qp type.
+.RE
+.PP
+rdma statistic qp set link mlx5_2/1 auto pid on
+.RS 4
+On device mlx5_2 port 1, for each new user QP bind it with a counter automatically. Per counter for QPs with same pid.
+.RE
+.PP
+rdma statistic qp set link mlx5_2/1 auto pid,type on
+.RS 4
+On device mlx5_2 port 1, for each new user QP bind it with a counter automatically. Per counter for QPs with same pid and same type.
 .RE
 .PP
 rdma statistic qp set link mlx5_2/1 auto off
--
2.26.2

