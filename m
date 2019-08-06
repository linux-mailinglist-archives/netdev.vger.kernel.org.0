Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E54E8329D
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbfHFNUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:20:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57527 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728582AbfHFNUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:20:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6320321FEB;
        Tue,  6 Aug 2019 09:20:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 06 Aug 2019 09:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=BBIr3gIHa0S4VzDEiHvR7PAjPwgOdqLA7KiJfRjHHPQ=; b=mam6/uYV
        YQR6MVI/w8T1P/15Vpy8yAZBWE1yCeZ62rYw9Zkl9Mr5bW4LShDR3Hn+q5kZH1v4
        Ll+txAHYjaA3KRffT1vFzSDRrKRoGcwaFtqM6h+p0f9LBJn+BGGl97Ll8c41HKBn
        sZ+ABQBVjeM6RNWa15Gr8locj7qcBCjVPvhtiR6ekxuE5r+v5DqGm7Re/+gPpCJ5
        IeZXA79di92kFN00/hDao6Pi+ISy7c7DZpIqB9Q3pVGfQRO9PldGxwqrYdnc3Cu0
        zDW01YTHeQkfsS6XDpUhA9EplgSqQfa+Hnki6QIvASu43IhgdsxRZkqFlaFEx6Od
        RqwqdiK1ys13gg==
X-ME-Sender: <xms:r35JXc5bpD-cbsEy9IuZ4yiUZ3ArWt4sGK4Tpia9xWFDBkcbpsDSBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddutddgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:r35JXVquKPKw4XKFuj4WsMdx3nqRxQw9v1psGAoNgW3YGpXQLRCLhA>
    <xmx:r35JXeiTUNkEGq6R-E-k9rqErGwnvqwx77F89N_MvOYoR1huHcG8OQ>
    <xmx:r35JXfLqooBWL3Z8kfKoo9s1qleoeGBo9NczxmSDUeBPTMRhx689DQ>
    <xmx:r35JXXjB9uDmWhGqFc3YHwnlJCf1ObVVhwXO6_c5BBGrS6jBiuRS8A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C59C38005B;
        Tue,  6 Aug 2019 09:20:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, toke@redhat.com,
        jiri@mellanox.com, dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/6] drop_monitor: Document scope of spinlock
Date:   Tue,  6 Aug 2019 16:19:53 +0300
Message-Id: <20190806131956.26168-4-idosch@idosch.org>
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

