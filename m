Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 587148329F
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732515AbfHFNUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:20:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34621 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726713AbfHFNUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:20:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 81F8C22053;
        Tue,  6 Aug 2019 09:20:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 06 Aug 2019 09:20:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=0u0RvWU/+7jTEu054RW35SK2EQxavoI04ceavZ1WbBw=; b=MmpRcgnZ
        OOknHkmhdN8nLLkNox4QEyC/toJ5cxE18SpmpyrwS2cF6DlsYd5vLrMDAfPJ0dux
        TRYJ1V/C6SMGZaHFnhRmmrzRUP3ISCmYwS/jqjVhd1c8e7p0W1gS4DKLArJLe/H5
        406Q9kfC/DB/in35VW4++usN9OJ+9JjjMsYm218Z8DAhjlWavyGsqQOqDq/0qgyW
        8ZqZAYRp7xFYPl91JMGuvkkfLVvm7+mB0dI5BSD4xBprPSiqGLWvwVF8d3VcHP4G
        izLPeQ+EMPp9k5D4CwlV2XnbmC9uxpQDtgXF8WxXYqkDiRdSZRjTJXtSPINExnBx
        TZ8eyo6yf+PMtw==
X-ME-Sender: <xms:tH5JXdIEKm8Zb8-rPv67oBzynNhUz1aNZ3WgzrXjEn-IT3pAOmfPsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddutddgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:tH5JXeqvL0ve6uSgNNPHAryKQi3HGBQKn-gkgJfI6JYGp34iYSRFRQ>
    <xmx:tH5JXYaMlA1FrNjNxaJsVSUQ3MZAFKd-81mGsfFw130ipPtQDWK-Ow>
    <xmx:tH5JXby4Nv7J5ndaxJZM4lBGXJjPg2TWxWzwtrc4xdI7kJgm_FH2ZQ>
    <xmx:tH5JXZfLgwfjInWvMW4edyEBKy_yO7Ir87RKV2H4omeCmGagx_q1-A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A25C880063;
        Tue,  6 Aug 2019 09:20:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, toke@redhat.com,
        jiri@mellanox.com, dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/6] drop_monitor: Use pre_doit / post_doit hooks
Date:   Tue,  6 Aug 2019 16:19:56 +0300
Message-Id: <20190806131956.26168-7-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190806131956.26168-1-idosch@idosch.org>
References: <20190806131956.26168-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Each operation from user space should be protected by the global drop
monitor mutex. Use the pre_doit / post_doit hooks to take / release the
lock instead of doing it explicitly in each function.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/core/drop_monitor.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 1d463c0d4bc5..4deb86f990f1 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -247,12 +247,9 @@ static int set_all_monitor_traces(int state, struct netlink_ext_ack *extack)
 	struct dm_hw_stat_delta *new_stat = NULL;
 	struct dm_hw_stat_delta *temp;
 
-	mutex_lock(&net_dm_mutex);
-
 	if (state == trace_state) {
 		NL_SET_ERR_MSG_MOD(extack, "Trace state already set to requested state");
-		rc = -EAGAIN;
-		goto out_unlock;
+		return -EAGAIN;
 	}
 
 	switch (state) {
@@ -296,9 +293,6 @@ static int set_all_monitor_traces(int state, struct netlink_ext_ack *extack)
 	else
 		rc = -EINPROGRESS;
 
-out_unlock:
-	mutex_unlock(&net_dm_mutex);
-
 	return rc;
 }
 
@@ -380,10 +374,26 @@ static const struct genl_ops dropmon_ops[] = {
 	},
 };
 
+static int net_dm_nl_pre_doit(const struct genl_ops *ops,
+			      struct sk_buff *skb, struct genl_info *info)
+{
+	mutex_lock(&net_dm_mutex);
+
+	return 0;
+}
+
+static void net_dm_nl_post_doit(const struct genl_ops *ops,
+				struct sk_buff *skb, struct genl_info *info)
+{
+	mutex_unlock(&net_dm_mutex);
+}
+
 static struct genl_family net_drop_monitor_family __ro_after_init = {
 	.hdrsize        = 0,
 	.name           = "NET_DM",
 	.version        = 2,
+	.pre_doit	= net_dm_nl_pre_doit,
+	.post_doit	= net_dm_nl_post_doit,
 	.module		= THIS_MODULE,
 	.ops		= dropmon_ops,
 	.n_ops		= ARRAY_SIZE(dropmon_ops),
-- 
2.21.0

