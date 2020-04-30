Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE741C036A
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgD3RBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:01:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42267 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbgD3RBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:01:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6A8245C0114;
        Thu, 30 Apr 2020 13:01:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 30 Apr 2020 13:01:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=GWQ8+oOZUrMS/SomwRa9E8Bc1fiW8Z+tUhiiyOHlPxo=; b=r4C66HWm
        n3LXGvJogS0ZjIe+LgTVg1L/EFilnV1uhAAPmcZo12GRYRD93F6yXfVqY676tVp5
        y5ZsDqlThT6Y5HQTTNqolO1pAzAgXINl0wzzddl98LXKiozvwUrx18eksf8cIq4m
        Kx6ZEhShDQ3JxvIO+e+p38KaL0yT+DVLX58qOaFkPKvy6AUZ3sL09pjY0H+qFRz6
        InD2IwJAwnpdBU9PJQm3mKo1T3BheSU54Q64jpDAvqkeeyRC1eJbT+M227ufv7pg
        CTJctUqomO0fqNCXJb7UOuOVipXuieyrmE1vFLnO44BiQh8os2mIAtM1Sjg+X5h9
        36maY+SC9ohL0Q==
X-ME-Sender: <xms:ewSrXpKCL85uj3bH7srUimBULHW_nvu4WTdsqRskZWuQbWwzSE2Eog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieehgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudektddrheegrdduudei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ewSrXpa5RhWzIJA6ahYwYda398gcsNvj12yRy-1cChfVHCF1lk2rDQ>
    <xmx:ewSrXsu1zIUZjnDg2NYy8yp1wKl5XSlY-ZgToRpwXaeDjczPvVj8EQ>
    <xmx:ewSrXuvSoJMfzDrgUUkv5krPID95QfInsy8jV8WXl7g0jCNlYjAeSQ>
    <xmx:ewSrXua1S0cqy3ZsH6UBRHcB8xqnoWeFZr8S7XlewEn3tTmeiT23kw>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 01BBF3065F3A;
        Thu, 30 Apr 2020 13:01:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/9] mlxsw: spectrum_span: Add APIs to get / put a SPAN agent
Date:   Thu, 30 Apr 2020 20:01:08 +0300
Message-Id: <20200430170116.4081677-2-idosch@idosch.org>
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

Given a netdev that packets should be mirrored to, create a SPAN agent
and return its identifier to the caller.

The SPAN agent is reference counted, as multiple tc-mirred actions can
point to the same destination netdev.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 43 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |  4 ++
 2 files changed, 47 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index ae3c8a1e9a43..c4159f4a66e2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -1039,3 +1039,46 @@ void mlxsw_sp_span_respin(struct mlxsw_sp *mlxsw_sp)
 		return;
 	mlxsw_core_schedule_work(&mlxsw_sp->span->work);
 }
+
+int mlxsw_sp_span_agent_get(struct mlxsw_sp *mlxsw_sp,
+			    const struct net_device *to_dev, int *p_span_id)
+{
+	const struct mlxsw_sp_span_entry_ops *ops;
+	struct mlxsw_sp_span_entry *span_entry;
+	struct mlxsw_sp_span_parms sparms;
+	int err;
+
+	ASSERT_RTNL();
+
+	ops = mlxsw_sp_span_entry_ops(mlxsw_sp, to_dev);
+	if (!ops) {
+		dev_err(mlxsw_sp->bus_info->dev, "Cannot mirror to requested destination\n");
+		return -EOPNOTSUPP;
+	}
+
+	memset(&sparms, 0, sizeof(sparms));
+	err = ops->parms_set(to_dev, &sparms);
+	if (err)
+		return err;
+
+	span_entry = mlxsw_sp_span_entry_get(mlxsw_sp, to_dev, ops, sparms);
+	if (!span_entry)
+		return -ENOBUFS;
+
+	*p_span_id = span_entry->id;
+
+	return 0;
+}
+
+void mlxsw_sp_span_agent_put(struct mlxsw_sp *mlxsw_sp, int span_id)
+{
+	struct mlxsw_sp_span_entry *span_entry;
+
+	ASSERT_RTNL();
+
+	span_entry = mlxsw_sp_span_entry_find_by_id(mlxsw_sp, span_id);
+	if (WARN_ON_ONCE(!span_entry))
+		return;
+
+	mlxsw_sp_span_entry_put(mlxsw_sp, span_entry);
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index d23abdf957fa..b79de9a125bb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -77,4 +77,8 @@ void mlxsw_sp_span_entry_invalidate(struct mlxsw_sp *mlxsw_sp,
 int mlxsw_sp_span_port_mtu_update(struct mlxsw_sp_port *port, u16 mtu);
 void mlxsw_sp_span_speed_update_work(struct work_struct *work);
 
+int mlxsw_sp_span_agent_get(struct mlxsw_sp *mlxsw_sp,
+			    const struct net_device *to_dev, int *p_span_id);
+void mlxsw_sp_span_agent_put(struct mlxsw_sp *mlxsw_sp, int span_id);
+
 #endif
-- 
2.24.1

