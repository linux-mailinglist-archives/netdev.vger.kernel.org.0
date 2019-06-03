Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD4F32720
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 06:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfFCEIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 00:08:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfFCEIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 00:08:21 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B73DB27B3E;
        Mon,  3 Jun 2019 04:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559534900;
        bh=gtWl6nVvDKdcdJ9S2IFPfo3eOkkpV2IttxPzujc1RD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUbiTLU/HktPJnWXYOo3hxxpql/ingENCeZqKeKbVHgg4GR+dg+t6R1igRYW286/S
         lJLJmWdd1IX2ZmukiSQxTrfCtrMIrTN3+v3IiKMrxj6nd3c7nKb2ifmaKb9u3bmdV8
         f7NElxvPw6V10nnzjgxS5mIbidliXgtvn3Eo+ZhE=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, saeedm@mellanox.com, kafai@fb.com,
        weiwan@google.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 net-next 6/7] mlx5: Fail attempts to use routes with nexthop objects
Date:   Sun,  2 Jun 2019 21:08:16 -0700
Message-Id: <20190603040817.4825-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190603040817.4825-1-dsahern@kernel.org>
References: <20190603040817.4825-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Fail attempts to use nexthop objects with routes until support can be
properly added.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index 2cbfaa8da7fc..e69766393990 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -262,6 +262,10 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 		fen_info = container_of(info, struct fib_entry_notifier_info,
 					info);
 		fi = fen_info->fi;
+		if (fi->nh) {
+			NL_SET_ERR_MSG_MOD(info->extack, "IPv4 route with nexthop objects is not supported");
+			return notifier_from_errno(-EINVAL);
+		}
 		fib_dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
 		if (fib_dev != ldev->pf[0].netdev &&
 		    fib_dev != ldev->pf[1].netdev) {
-- 
2.11.0

