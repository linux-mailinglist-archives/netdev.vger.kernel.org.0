Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F36C708AB
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 20:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbfGVSd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 14:33:28 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:45571 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726770AbfGVSd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 14:33:27 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id CBBD92237;
        Mon, 22 Jul 2019 14:33:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 22 Jul 2019 14:33:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=BBIr3gIHa0S4VzDEiHvR7PAjPwgOdqLA7KiJfRjHHPQ=; b=nHf9lrxc
        pdFuqIxMCE07Qho53IyDjn4MNte2wchnddSj96acKehv0NgpnF3DnBCitjLj1U/j
        7EjVC3o1Fsu5HGTVLRJPg0+GJLe8r7P9Ck4eQdoR0FkTGlZZb3oRHovgpoeVg6Xb
        WgnReh0aP635dmyeBQxIMUn7ccT61i+70MpbGK0/STKewzcWZuWsZnFYMjpKH1Bu
        5Xq48iNAD9a6MDEIo8LC6HQR6h8dyfbCGIzWEeYZv0jRFCNPpb2Brb78SqAbCBBX
        v/YOqjCQTTLdQkuKCpkv/TEW0FQSeewzUZE/c0J6/BGLga8uU3Rll8qooJDalOzu
        p/5AP69vpgmpgA==
X-ME-Sender: <xms:dgE2Xeow12VkTf6R0dKdb2u9bzdMkA7lWfKDL0vJ8MTobbWtswTaQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeeggdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:dgE2XTlfltoVDSOxBYuVI8t0LRAy1EzjhnRtAR2m7lj50WpHNVhREg>
    <xmx:dgE2XYXd5iO78QqgbvwhEOdZL234MiXxnJfmPESRplrn0G8uNeChDA>
    <xmx:dgE2XSReBvaa1afirLPWrgrAgGfAhRRggC-0Q7fshlWq4jt3AjK39w>
    <xmx:dgE2XR6-pFySfxV6AU4ySDhQK7N-mRryCpjAJKzztXt6fK-TrhJ04A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6256780062;
        Mon, 22 Jul 2019 14:33:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, toke@redhat.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 03/12] drop_monitor: Document scope of spinlock
Date:   Mon, 22 Jul 2019 21:31:25 +0300
Message-Id: <20190722183134.14516-4-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190722183134.14516-1-idosch@idosch.org>
References: <20190722183134.14516-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

While 'per_cpu_dm_data' is a per-CPU variable, its 'skb' and
'send_timer' fields can be accessed concurrently by the CPU sending the
netlink notification to user space from the workqueue and the CPU
tracing kfree_skb(). This spinlock is meant to protect against that.

Document its scope and suppress the checkpatch message "spinlock_t
definition without comment".

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/core/drop_monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 000ec8b66d1e..35d31b007da4 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -52,7 +52,7 @@ static int trace_state = TRACE_OFF;
 static DEFINE_MUTEX(net_dm_mutex);
 
 struct per_cpu_dm_data {
-	spinlock_t		lock;
+	spinlock_t		lock;	/* Protects 'skb' and 'send_timer' */
 	struct sk_buff		*skb;
 	struct work_struct	dm_alert_work;
 	struct timer_list	send_timer;
-- 
2.21.0

