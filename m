Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568B56BE54
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 16:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbfGQOch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 10:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbfGQOch (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 10:32:37 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0318221743;
        Wed, 17 Jul 2019 14:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563373955;
        bh=k5Er4QeMYHcTtp8sBWP9hdIs+UOSwmDSV0HMPL1MnoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GtHynIopkZak6pQconRUj/Gs1WVyaLkRmmWWoGyDKrodxxKkxZhd5ke+CJfNquwhI
         F0gqjJgBJIwlok1POXkFdOvXazJ1ZoH3ec5Ji61oY+XQpPloWheoc1xbOS+EmGqO/b
         hZKutXkwh9psXHqeUmvpn9a/KoJRWjw75R2At3S0=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-rc v1 7/7] rdma: Document counter statistic
Date:   Wed, 17 Jul 2019 17:31:56 +0300
Message-Id: <20190717143157.27205-8-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190717143157.27205-1-leon@kernel.org>
References: <20190717143157.27205-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Add document of accessing the QP counter, including bind/unbind a QP
to a counter manually or automatically, and dump counter statistics.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 man/man8/rdma-dev.8       |   1 +
 man/man8/rdma-link.8      |   1 +
 man/man8/rdma-resource.8  |   1 +
 man/man8/rdma-statistic.8 | 167 ++++++++++++++++++++++++++++++++++++++
 man/man8/rdma.8           |   7 +-
 5 files changed, 176 insertions(+), 1 deletion(-)
 create mode 100644 man/man8/rdma-statistic.8

diff --git a/man/man8/rdma-dev.8 b/man/man8/rdma-dev.8
index 38e34b3b..e77e7cd0 100644
--- a/man/man8/rdma-dev.8
+++ b/man/man8/rdma-dev.8
@@ -77,6 +77,7 @@ previously created using iproute2 ip command.
 .BR rdma-link (8),
 .BR rdma-resource (8),
 .BR rdma-system (8),
+.BR rdma-statistic (8),
 .br
 
 .SH AUTHOR
diff --git a/man/man8/rdma-link.8 b/man/man8/rdma-link.8
index b3b40de7..32f80228 100644
--- a/man/man8/rdma-link.8
+++ b/man/man8/rdma-link.8
@@ -97,6 +97,7 @@ Removes RXE link rxe_eth0
 .BR rdma (8),
 .BR rdma-dev (8),
 .BR rdma-resource (8),
+.BR rdma-statistic (8),
 .br
 
 .SH AUTHOR
diff --git a/man/man8/rdma-resource.8 b/man/man8/rdma-resource.8
index 40b073db..05030d0a 100644
--- a/man/man8/rdma-resource.8
+++ b/man/man8/rdma-resource.8
@@ -103,6 +103,7 @@ Show CQs belonging to pid 30489
 .BR rdma (8),
 .BR rdma-dev (8),
 .BR rdma-link (8),
+.BR rdma-statistic (8),
 .br
 
 .SH AUTHOR
diff --git a/man/man8/rdma-statistic.8 b/man/man8/rdma-statistic.8
new file mode 100644
index 00000000..dea6ff24
--- /dev/null
+++ b/man/man8/rdma-statistic.8
@@ -0,0 +1,167 @@
+.TH RDMA\-STATISTIC 8 "17 Mar 2019" "iproute2" "Linux"
+.SH NAME
+rdma-statistic \- RDMA statistic counter configuration
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+.ti -8
+.B rdma
+.RI "[ " OPTIONS " ]"
+.B statistic
+.RI  " { " COMMAND " | "
+.BR help " }"
+.sp
+
+.ti -8
+.B rdma statistic
+.RI "[ " OBJECT " ]"
+.B show
+
+.ti -8
+.B rdma statistic
+.RI "[ " OBJECT " ]"
+.B show link
+.RI "[ " DEV/PORT_INDX " ]"
+
+.ti -8
+.B rdma statistic
+.IR OBJECT
+.B mode
+
+.ti -8
+.B rdma statistic
+.IR OBJECT
+.B set
+.IR COUNTER_SCOPE
+.RI "[ " DEV/PORT_INDEX "]"
+.B auto
+.RI "{ " CRITERIA " | "
+.BR off " }"
+
+.ti -8
+.B rdma statistic
+.IR OBJECT
+.B bind
+.IR COUNTER_SCOPE
+.RI "[ " DEV/PORT_INDEX "]"
+.RI "[ " OBJECT-ID " ]"
+.RI "[ " COUNTER-ID " ]"
+
+.ti -8
+.B rdma statistic
+.IR OBJECT
+.B unbind
+.IR COUNTER_SCOPE
+.RI "[ " DEV/PORT_INDEX "]"
+.RI "[ " COUNTER-ID " ]"
+.RI "[ " OBJECT-ID " ]"
+
+.ti -8
+.IR COUNTER_SCOPE " := "
+.RB "{ " link " | " dev " }"
+
+.ti -8
+.IR OBJECT " := "
+.RB "{ " qp " }"
+
+.ti -8
+.IR CRITERIA " := "
+.RB "{ " type " }"
+
+.SH "DESCRIPTION"
+.SS rdma statistic [object] show - Queries the specified RDMA device for RDMA and driver-specific statistics. Show the default hw counters if object is not specified
+
+.PP
+.I "DEV"
+- specifies counters on this RDMA device to show.
+
+.I "PORT_INDEX"
+- specifies counters on this RDMA port to show.
+
+.SS rdma statistic <object> set - configure counter statistic auto-mode for a specific device/port
+In auto mode all objects belong to one category are bind automatically to a single counter set.
+
+.SS rdma statistic <object> bind - manually bind an object (e.g., a qp) with a counter
+When bound the statistics of this object are available in this counter.
+
+.SS rdma statistic <object> unbind - manually unbind an object (e.g., a qp) from the counter previously bound
+When unbound the statistics of this object are no longer available in this counter; And if object id is not specified then all objects on this counter will be unbound.
+
+.I "COUNTER-ID"
+- specifies the id of the counter to be bound.
+If this argument is omitted then a new counter will be allocated.
+
+.SH "EXAMPLES"
+.PP
+rdma statistic show
+.RS 4
+Shows the state of the default counter of all RDMA devices on the system.
+.RE
+.PP
+rdma statistic show link mlx5_2/1
+.RS 4
+Shows the state of the default counter of specified RDMA port
+.RE
+.PP
+rdma statistic qp show
+.RS 4
+Shows the state of all qp counters of all RDMA devices on the system.
+.RE
+.PP
+rdma statistic qp show link mlx5_2/1
+.RS 4
+Shows the state of all qp counters of specified RDMA port.
+.RE
+.PP
+rdma statistic qp show link mlx5_2 pid 30489
+.RS 4
+Shows the state of all qp counters of specified RDMA port and belonging to pid 30489
+.RE
+.PP
+rdma statistic qp mode
+.RS 4
+List current counter mode on all devices
+.RE
+.PP
+rdma statistic qp mode link mlx5_2/1
+.RS 4
+List current counter mode of device mlx5_2 port 1
+.RE
+.PP
+rdma statistic qp set link mlx5_2/1 auto type on
+.RS 4
+On device mlx5_2 port 1, for each new QP bind it with a counter automatically. Per counter for QPs with same qp type in each process. Currently only "type" is supported.
+.RE
+.PP
+rdma statistic qp set link mlx5_2/1 auto off
+.RS 4
+Turn-off auto mode on device mlx5_2 port 1. The allocated counters can be manually accessed.
+.RE
+.PP
+rdma statistic qp bind link mlx5_2/1 lqpn 178
+.RS 4
+On device mlx5_2 port 1, allocate a counter and bind the specified qp on it
+.RE
+.PP
+rdma statistic qp unbind link mlx5_2/1 cntn 4 lqpn 178
+.RS 4
+On device mlx5_2 port 1, bind the specified qp on the specified counter
+.RE
+.PP
+rdma statistic qp unbind link mlx5_2/1 cntn 4
+.RS 4
+On device mlx5_2 port 1, unbind all QPs on the specified counter. After that this counter will be released automatically by the kernel.
+
+.RE
+.PP
+
+.SH SEE ALSO
+.BR rdma (8),
+.BR rdma-dev (8),
+.BR rdma-link (8),
+.BR rdma-resource (8),
+.br
+
+.SH AUTHOR
+Mark Zhang <markz@mellanox.com>
diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
index 3ae33987..ef29b1c6 100644
--- a/man/man8/rdma.8
+++ b/man/man8/rdma.8
@@ -19,7 +19,7 @@ rdma \- RDMA tool
 
 .ti -8
 .IR OBJECT " := { "
-.BR dev " | " link " | " system " }"
+.BR dev " | " link " | " system " | " statistic " }"
 .sp
 
 .ti -8
@@ -74,6 +74,10 @@ Generate JSON output.
 .B sys
 - RDMA subsystem related.
 
+.TP
+.B statistic
+- RDMA counter statistic related.
+
 .PP
 The names of all objects may be written in full or
 abbreviated form, for example
@@ -112,6 +116,7 @@ Exit status is 0 if command was successful or a positive integer upon failure.
 .BR rdma-link (8),
 .BR rdma-resource (8),
 .BR rdma-system (8),
+.BR rdma-statistic (8),
 .br
 
 .SH REPORTING BUGS
-- 
2.20.1

