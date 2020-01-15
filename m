Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA7513BEEC
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 12:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbgAOLyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 06:54:21 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48025 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730192AbgAOLyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 06:54:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4D3A321FFC;
        Wed, 15 Jan 2020 06:54:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 15 Jan 2020 06:54:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=htUdC64cHRoTTXN2yDBL6pPine1X02jlhBSTYJyTnI0=; b=Mm8Gi/5z
        3uAJ7NliLNNExq8Pq+taN+qXwCcOPRQPDFefObiOCj01CmomGZ6ZiTykyVQQfsU+
        s5HRzvkXtC7j/muWiJsuLl0oLMFVEJxufb8J7XY+Ljoj5NWxYB5Ok/+hqyejIgEQ
        nuz7RflsJ9wmzHDdl7H8P2JNSmLxPu5/m8qZ+/8cIVOr1d9KMqsjZMh2Q286alXz
        QljHewMJi49t5pCNZ2r1Vp4DBZeNNoSBmBRLKtcEWxqfcMJUzjJUU9S6JhHbUgYH
        hcadaNuAlI/8Qs6C4TbPg+R1ENZAaiODMauAZx/3fwuiYLRJJDy+Fv5yWbhho4C6
        imeog91pOXnqWA==
X-ME-Sender: <xms:a_0eXuaiqBPWEwJBEn5FrA-eZvHUpeAj73HKxWDeu7a2UPKyY9gcxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdefgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppeduleefrd
    egjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehi
    ughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:a_0eXlr1VCJtw-lYEq9eF7LhIXkiMCtMRXSLVPUh7DakYu8rUjBOHg>
    <xmx:a_0eXj9APu-26A1IsJS60uqdxxwGAakOd4UPEdAuY4EZhwZFYq17Sw>
    <xmx:a_0eXk_-TLZPf4cxb6J1F_rM48E-Q7QNghQcIHGqqJA_EFH6AFlc8g>
    <xmx:a_0eXjrCAkV75ujQttTBGU1wvpaLQlrJAD6_zXbAafFksXAlwTJv9g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE42F80068;
        Wed, 15 Jan 2020 06:54:17 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net v2 5/6] mlxsw: spectrum: Wipe xstats.backlog of down ports
Date:   Wed, 15 Jan 2020 13:53:48 +0200
Message-Id: <20200115115349.1273610-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115115349.1273610-1-idosch@idosch.org>
References: <20200115115349.1273610-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Per-port counter cache used by Qdiscs is updated periodically, unless the
port is down. The fact that the cache is not updated for down ports is no
problem for most counters, which are relative in nature. However, backlog
is absolute in nature, and if there is a non-zero value in the cache around
the time that the port goes down, that value just stays there. This value
then leaks to offloaded Qdiscs that report non-zero backlog even if
there (obviously) is no traffic.

The HW does not keep backlog of a downed port, so do likewise: as the port
goes down, wipe the backlog value from xstats.

Fixes: 075ab8adaf4e ("mlxsw: spectrum: Collect tclass related stats periodically")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 2394c425b47d..8ed15199eb4f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1209,6 +1209,9 @@ static void update_stats_cache(struct work_struct *work)
 			     periodic_hw_stats.update_dw.work);
 
 	if (!netif_carrier_ok(mlxsw_sp_port->dev))
+		/* Note: mlxsw_sp_port_down_wipe_counters() clears the cache as
+		 * necessary when port goes down.
+		 */
 		goto out;
 
 	mlxsw_sp_port_get_hw_stats(mlxsw_sp_port->dev,
@@ -4318,6 +4321,15 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 	return 0;
 }
 
+static void
+mlxsw_sp_port_down_wipe_counters(struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	int i;
+
+	for (i = 0; i < TC_MAX_QUEUE; i++)
+		mlxsw_sp_port->periodic_hw_stats.xstats.backlog[i] = 0;
+}
+
 static void mlxsw_sp_pude_event_func(const struct mlxsw_reg_info *reg,
 				     char *pude_pl, void *priv)
 {
@@ -4339,6 +4351,7 @@ static void mlxsw_sp_pude_event_func(const struct mlxsw_reg_info *reg,
 	} else {
 		netdev_info(mlxsw_sp_port->dev, "link down\n");
 		netif_carrier_off(mlxsw_sp_port->dev);
+		mlxsw_sp_port_down_wipe_counters(mlxsw_sp_port);
 	}
 }
 
-- 
2.24.1

