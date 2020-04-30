Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F741C0371
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgD3RCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:02:02 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45191 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727802AbgD3RB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:01:59 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 361FF5C0127;
        Thu, 30 Apr 2020 13:01:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 30 Apr 2020 13:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=VxoYT3NSs+EEOCpc9llSpA4xoLnszuS8m4TyiK1+cjI=; b=I6YhVuq1
        Aua/KXCS7aFcdVK94JYRYgdzd3+uQgANYf6Ln8eTMjXjXiEchBEl5Hg404wvqs0x
        ue1LfMRo2eNDtD006cNgEJDNiFgQ5C4uLOfhtSLhCEc9HZcAYdohIJDrfcgWFKZp
        UAYk9VYoXd+4FrzVO5ilWEB/q9RMYQk3e3WnaZ8AubQwDUk4ESFeWMScqDr+aGF+
        HonviwYRibd21Mt9Vs/LsQRssIPpz7yDJ+wjpSar+LfuUkZjuVJUVBPPaFB8jbM6
        FXmdkGfhNGfjoyw972NAd/OvVrxB1oM5yVuAM8H8dfDflRrTKAcZTmKDutfhJkEQ
        kmPrEOoqeMZiLA==
X-ME-Sender: <xms:hgSrXmfv0VGJEl0tEju8dFkrj0dllmC-v7DsKfiNV8_b5TRsZrSpSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieehgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudektddrheegrdduudei
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:hgSrXkdukhnvGANofBoBAaQ4_8CTEpC8h-WVDOabyn0icGtefsyyng>
    <xmx:hgSrXiiri2_dwzC7kmGxNuO0r6W_SvVl0N-ezU4I4Ltau45seAaPxA>
    <xmx:hgSrXoTZHIKKYeuwbhaVNXy5V4uPCR8VC2R9kIKcmAoKuODwb6vfXw>
    <xmx:hgSrXuMZvzww1H-loJgKBWRv5qxZ2835TYA2IXp1xqx6H0Lxw4yRzg>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id CBB693065F3A;
        Thu, 30 Apr 2020 13:01:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 8/9] mlxsw: spectrum_span: Use new analyzed ports list during speed / MTU change
Date:   Thu, 30 Apr 2020 20:01:15 +0300
Message-Id: <20200430170116.4081677-9-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200430170116.4081677-1-idosch@idosch.org>
References: <20200430170116.4081677-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

As previously explained, each port whose outgoing traffic is analyzed
needs to have an egress mirror buffer.

The size of the egress mirror buffer is calculated based on various
parameters, two of which are the speed and the MTU of the port.

Therefore, when the MTU or the speed of a port change, the SPAN code is
called to see if the egress mirror buffer of the port needs to be
adjusted.

Currently, this is done by traversing all the SPAN agents and for each
SPAN agent the list of bound ports is traversed.

Instead of the above, traverse the recently added list of analyzed
ports.

This will later allow us to remove the old SPAN API.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 72 +++++++++----------
 1 file changed, 35 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index de9012ab94d5..9cb8b509b849 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -776,24 +776,6 @@ static int mlxsw_sp_span_entry_put(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
-static bool mlxsw_sp_span_is_egress_mirror(struct mlxsw_sp_port *port)
-{
-	struct mlxsw_sp *mlxsw_sp = port->mlxsw_sp;
-	struct mlxsw_sp_span_inspected_port *p;
-	int i;
-
-	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
-		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span->entries[i];
-
-		list_for_each_entry(p, &curr->bound_ports_list, list)
-			if (p->local_port == port->local_port &&
-			    p->type == MLXSW_SP_SPAN_EGRESS)
-				return true;
-	}
-
-	return false;
-}
-
 static int
 mlxsw_sp_span_port_buffer_update(struct mlxsw_sp_port *mlxsw_sp_port, u16 mtu)
 {
@@ -823,20 +805,45 @@ static void mlxsw_sp_span_port_buffer_disable(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
 }
 
+static struct mlxsw_sp_span_analyzed_port *
+mlxsw_sp_span_analyzed_port_find(struct mlxsw_sp_span *span, u8 local_port,
+				 bool ingress)
+{
+	struct mlxsw_sp_span_analyzed_port *analyzed_port;
+
+	list_for_each_entry(analyzed_port, &span->analyzed_ports_list, list) {
+		if (analyzed_port->local_port == local_port &&
+		    analyzed_port->ingress == ingress)
+			return analyzed_port;
+	}
+
+	return NULL;
+}
+
 int mlxsw_sp_span_port_mtu_update(struct mlxsw_sp_port *port, u16 mtu)
 {
+	struct mlxsw_sp *mlxsw_sp = port->mlxsw_sp;
+	int err = 0;
+
 	/* If port is egress mirrored, the shared buffer size should be
 	 * updated according to the mtu value
 	 */
-	if (mlxsw_sp_span_is_egress_mirror(port))
-		return mlxsw_sp_span_port_buffer_update(port, mtu);
-	return 0;
+	mutex_lock(&mlxsw_sp->span->analyzed_ports_lock);
+
+	if (mlxsw_sp_span_analyzed_port_find(mlxsw_sp->span, port->local_port,
+					     false))
+		err = mlxsw_sp_span_port_buffer_update(port, mtu);
+
+	mutex_unlock(&mlxsw_sp->span->analyzed_ports_lock);
+
+	return err;
 }
 
 void mlxsw_sp_span_speed_update_work(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct mlxsw_sp_port *mlxsw_sp_port;
+	struct mlxsw_sp *mlxsw_sp;
 
 	mlxsw_sp_port = container_of(dwork, struct mlxsw_sp_port,
 				     span.speed_update_dw);
@@ -844,9 +851,15 @@ void mlxsw_sp_span_speed_update_work(struct work_struct *work)
 	/* If port is egress mirrored, the shared buffer size should be
 	 * updated according to the speed value.
 	 */
-	if (mlxsw_sp_span_is_egress_mirror(mlxsw_sp_port))
+	mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	mutex_lock(&mlxsw_sp->span->analyzed_ports_lock);
+
+	if (mlxsw_sp_span_analyzed_port_find(mlxsw_sp->span,
+					     mlxsw_sp_port->local_port, false))
 		mlxsw_sp_span_port_buffer_update(mlxsw_sp_port,
 						 mlxsw_sp_port->dev->mtu);
+
+	mutex_unlock(&mlxsw_sp->span->analyzed_ports_lock);
 }
 
 static struct mlxsw_sp_span_inspected_port *
@@ -1117,21 +1130,6 @@ void mlxsw_sp_span_agent_put(struct mlxsw_sp *mlxsw_sp, int span_id)
 	mlxsw_sp_span_entry_put(mlxsw_sp, span_entry);
 }
 
-static struct mlxsw_sp_span_analyzed_port *
-mlxsw_sp_span_analyzed_port_find(struct mlxsw_sp_span *span, u8 local_port,
-				 bool ingress)
-{
-	struct mlxsw_sp_span_analyzed_port *analyzed_port;
-
-	list_for_each_entry(analyzed_port, &span->analyzed_ports_list, list) {
-		if (analyzed_port->local_port == local_port &&
-		    analyzed_port->ingress == ingress)
-			return analyzed_port;
-	}
-
-	return NULL;
-}
-
 static struct mlxsw_sp_span_analyzed_port *
 mlxsw_sp_span_analyzed_port_create(struct mlxsw_sp_span *span,
 				   struct mlxsw_sp_port *mlxsw_sp_port,
-- 
2.24.1

