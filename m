Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D28533A4B7
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbhCNMVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:21:06 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:58307 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235340AbhCNMUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 08:20:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 04DCD5808BA;
        Sun, 14 Mar 2021 08:20:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 14 Mar 2021 08:20:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=VwvK5tXMKKGxoe7iIaHVHCyEgOIkh5Lv+d/MOz+hBxY=; b=VNXS8a9A
        5cbX3Vvf8Ds5x7S/80xSm+PMC3AQOtShHBhHur8kBsvwp8883OqHra4tyRSvb63V
        gpoabHfuL9MGhpcD8ETdNlaH5AmtYM2NOKQb0pwRVS1GFKyKVmgkWAEAncNCVTmE
        p1tin/79nOqP+031551oiEEUegt2/jgCOpff9WeOYe9d2KRQD5Igv4wh9LklWhij
        hL47VaSLI3iG9cf+yZP5ICYsR3D4DciBkNQGIn4RCk4deqtslRQEsMy8tR66JX/1
        n/wYyal7hHb4NEc/guruEUjSclJ5GZ/pSl49rwLlAsPFAoXLJ6VhZdZ3MN6OA20O
        0IeFyNWMORhN/g==
X-ME-Sender: <xms:lv9NYCTcfiK6wO7LC9vi2GIXp6bV4k5Hq0EhWEellOfkHvXGqH80Zg>
    <xme:lv9NYHwv8hqIqCFxv8Zu536NVchoc-Oz23_E131DCYP8Vtm4FG2DhkPCGoTaPdZwm
    _es-_J8ob48sPM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvjedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:lv9NYP33d1UH3_SbrdagGts8Qem38wmOY0o00UUyapfyzAFw4pNbxw>
    <xmx:lv9NYOBQAXW3xTs0wLaCgjUJQFVHp9NMdthiMuI4IjedNtCobBtzSg>
    <xmx:lv9NYLhz_AqTLfP4mxdMPTS_JLr1kdTe49EcxW6XUKRqtJ9Uw_-SEw>
    <xmx:l_9NYMXZuBndhw3dQP-rmtdNk8R0HOxrNX706ZX-U5kbVRdXt_Q-Vw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 49696240054;
        Sun, 14 Mar 2021 08:20:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        yotam.gi@gmail.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/11] mlxsw: spectrum: Remove unnecessary RCU read-side critical section
Date:   Sun, 14 Mar 2021 14:19:37 +0200
Message-Id: <20210314121940.2807621-9-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210314121940.2807621-1-idosch@idosch.org>
References: <20210314121940.2807621-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Since commit 7d8e8f3433dc ("mlxsw: core: Increase scope of RCU read-side
critical section"), all Rx handlers are called from an RCU read-side
critical section.

Remove the unnecessary rcu_read_lock() / rcu_read_unlock().

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 3b15f8d728a3..3d8e8d8dfff5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2225,15 +2225,12 @@ void mlxsw_sp_sample_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 		goto out;
 	}
 
-	rcu_read_lock();
 	sample = rcu_dereference(mlxsw_sp_port->sample);
 	if (!sample)
-		goto out_unlock;
+		goto out;
 	md.trunc_size = sample->truncate ? sample->trunc_size : skb->len;
 	md.in_ifindex = mlxsw_sp_port->dev->ifindex;
 	psample_sample_packet(sample->psample_group, skb, sample->rate, &md);
-out_unlock:
-	rcu_read_unlock();
 out:
 	consume_skb(skb);
 }
-- 
2.29.2

