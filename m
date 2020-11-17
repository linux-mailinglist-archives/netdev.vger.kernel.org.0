Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958FB2B6BD4
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgKQReu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:34:50 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:36975 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726397AbgKQRet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 12:34:49 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 197F4F7C;
        Tue, 17 Nov 2020 12:34:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 17 Nov 2020 12:34:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=3GrWBrJ37CMBjYdWyXJ0G8+hT6ouKMNn/EOXhfA3gTE=; b=ZCs4hDgb
        51zcUdSJOnO4vyg/3M3dAOoD5Qp9agW2MhAvmcQPwORavfZYbK8ypqAegu0/rNM/
        cGGK55CqBqt0GsDmr9M5D8EizqVd8YQDT9gkts81VGjeXBZ0582OT5C4TUI2rka6
        +eJew2asAE34TV0BwIAKJscRROoCtgL1aWEOMyoWYLreMB31W0NlZfs7dAlDUYPs
        CYLqYE/zrWGn24G4zwsu4zBAoTgzo87gT4nNwKKkheS9ZRE/ihq3/F84dRfjdBWU
        l+f2Au0ajaOhRejh6qYFtlJIMBWG907yM1soUF8npibcj+WBss32O6FHZgaaa+/r
        JXOhMsLXnuMGGQ==
X-ME-Sender: <xms:twm0X4Vs3H0BUziJo-k5Cgnwyecvmeq-Y_AI6qso-9OomxuxdX9oSQ>
    <xme:twm0X8nO60gTPpgqMp_kn-fRodCw_BLWCh373uMxnNccKzK5JOMFFEyeJ_t_ayC1k
    eAPUjd5TtyQw-Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:twm0X8b5285vS81Mdqzi2JIsXs-ld4M2iHry038zzuX9hh5b9NP1Yw>
    <xmx:twm0X3WpfPG6Ns7TtemRI5XW_K7RD6uh4UR-e_4SqX8GuKgze0sWPA>
    <xmx:twm0XykJc7zbzZY2kUmlOQ2FbDD1MUbtlXjgTMKHExBQ6Xmo8466lg>
    <xmx:twm0X3yyPETto8Tg1QhkKOO0XwtyVll43uihesFRoREoT_2FOJULmg>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id D94DD3064AA6;
        Tue, 17 Nov 2020 12:34:45 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 2/2] mlxsw: core: Use variable timeout for EMAD retries
Date:   Tue, 17 Nov 2020 19:33:52 +0200
Message-Id: <20201117173352.288491-3-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117173352.288491-1-idosch@idosch.org>
References: <20201117173352.288491-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The driver sends Ethernet Management Datagram (EMAD) packets to the
device for configuration purposes and waits for up to 200ms for a reply.
A request is retried up to 5 times.

When the system is under heavy load, replies are not always processed in
time and EMAD transactions fail.

Make the process more robust to such delays by using exponential
backoff. First wait for up to 200ms, then retransmit and wait for up to
400ms and so on.

Fixes: caf7297e7ab5 ("mlxsw: core: Introduce support for asynchronous EMAD register access")
Reported-by: Denis Yulevich <denisyu@nvidia.com>
Tested-by: Denis Yulevich <denisyu@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 937b8e46f8c7..1a86535c4968 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -571,7 +571,8 @@ static void mlxsw_emad_trans_timeout_schedule(struct mlxsw_reg_trans *trans)
 	if (trans->core->fw_flash_in_progress)
 		timeout = msecs_to_jiffies(MLXSW_EMAD_TIMEOUT_DURING_FW_FLASH_MS);
 
-	queue_delayed_work(trans->core->emad_wq, &trans->timeout_dw, timeout);
+	queue_delayed_work(trans->core->emad_wq, &trans->timeout_dw,
+			   timeout << trans->retries);
 }
 
 static int mlxsw_emad_transmit(struct mlxsw_core *mlxsw_core,
-- 
2.28.0

