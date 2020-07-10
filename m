Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A30B21B6BB
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgGJNmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:42:21 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35337 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726896AbgGJNmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:42:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 153665C0118;
        Fri, 10 Jul 2020 09:42:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 09:42:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=YPODZU0b1U+uFapg9MBgz/yJo+pklDRNe9kIVrvIalQ=; b=ko1fnckV
        /Yg2lHOQB64w4wt8hoFHoYf0QdGAQnf3hUuE5dwFyqE4zeIMaPfG2G8q0S768i8Q
        xAeZ7m+O/2Y36O81Fab71a6e1bn+QjUVx4j6gw0+8SHWbj/5BRwq3CG7o2B/TM4I
        VdgTwpwWW2WWl1ICb8twUJ6M7/wFrFi6rP0FjxsyUBCOirYttx+efxhFhu0TdR+M
        NzGhLfj3CKeb7+4QQ+t3ubbbP6LptRUzHzl45IYChxvczHswnCBlK2+lHh0jDnjz
        hS5snoyedgwCH+XOG4llWQmM9vGwwJmYtJ9MwonwpZdXpxusaEI0OfIkC6K+V12L
        2kr59SFpsG2VTA==
X-ME-Sender: <xms:OnAIX8jrO26ai2qi7JN1yoeJq-dPF5ES4bmSH6203WhCirk3CvDzUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeefteeijedugfejheffffeigeeijeehke
    eltdfgudevgfefieekgefhffetgeduudenucffohhmrghinhepqhgvmhhurdhorhhgnecu
    kfhppedutdelrdeiiedrudelrddufeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:OnAIX1Awr9nVF07n8S6_0T1HjI4_Img4LPTXvi9d4R7V7SxAYrYJYg>
    <xmx:OnAIX0HKH_bECIFwbdN3aoHpz6ztwL2VAz8bXH258wB2ZBpcmPzx0g>
    <xmx:OnAIX9TvDnJDHZX6nl9xFJswxCFFGGyAsmIuUa-myLwQbFm4ZTnSrA>
    <xmx:O3AIX6qh3GsKTQN9d71kbNvhhrI-aZLYiFBD5eNPXtI_DLsAIqW4PA>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id E7E5D3280065;
        Fri, 10 Jul 2020 09:42:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 1/2] mlxsw: spectrum_router: Remove inappropriate usage of WARN_ON()
Date:   Fri, 10 Jul 2020 16:41:38 +0300
Message-Id: <20200710134139.599811-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710134139.599811-1-idosch@idosch.org>
References: <20200710134139.599811-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

We should not trigger a warning when a memory allocation fails. Remove
the WARN_ON().

The warning is constantly triggered by syzkaller when it is injecting
faults:

[ 2230.758664] FAULT_INJECTION: forcing a failure.
[ 2230.758664] name failslab, interval 1, probability 0, space 0, times 0
[ 2230.762329] CPU: 3 PID: 1407 Comm: syz-executor.0 Not tainted 5.8.0-rc2+ #28
...
[ 2230.898175] WARNING: CPU: 3 PID: 1407 at drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:6265 mlxsw_sp_router_fib_event+0xfad/0x13e0
[ 2230.898179] Kernel panic - not syncing: panic_on_warn set ...
[ 2230.898183] CPU: 3 PID: 1407 Comm: syz-executor.0 Not tainted 5.8.0-rc2+ #28
[ 2230.898190] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014

Fixes: 3057224e014c ("mlxsw: spectrum_router: Implement FIB offload in deferred work")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 770de0222e7b..019ed503aadf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6262,7 +6262,7 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 	}
 
 	fib_work = kzalloc(sizeof(*fib_work), GFP_ATOMIC);
-	if (WARN_ON(!fib_work))
+	if (!fib_work)
 		return NOTIFY_BAD;
 
 	fib_work->mlxsw_sp = router->mlxsw_sp;
-- 
2.26.2

