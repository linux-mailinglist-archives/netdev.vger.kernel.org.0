Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 149CAE2C06
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 10:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438140AbfJXIXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 04:23:46 -0400
Received: from mx58.baidu.com ([61.135.168.58]:33406 "EHLO
        tc-sys-mailedm04.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726265AbfJXIXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 04:23:46 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm04.tc.baidu.com (Postfix) with ESMTP id 196C5236C006;
        Thu, 24 Oct 2019 16:23:33 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, saeedm@mellanox.com, leon@kernel.org
Subject: [PATCH][net-next] net/mlx5: rate limit alloc_ent error messages
Date:   Thu, 24 Oct 2019 16:23:33 +0800
Message-Id: <1571905413-28405-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when debug a bug, which triggers TX hang, and kernel log is
spammed with the following info message

    [ 1172.044764] mlx5_core 0000:21:00.0: cmd_work_handler:930:(pid 8):
    failed to allocate command entry

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index ea934cd02448..34cba97f7bf4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -866,7 +866,7 @@ static void cmd_work_handler(struct work_struct *work)
 	if (!ent->page_queue) {
 		alloc_ret = alloc_ent(cmd);
 		if (alloc_ret < 0) {
-			mlx5_core_err(dev, "failed to allocate command entry\n");
+			mlx5_core_err_rl(dev, "failed to allocate command entry\n");
 			if (ent->callback) {
 				ent->callback(-EAGAIN, ent->context);
 				mlx5_free_cmd_msg(dev, ent->out);
-- 
2.16.2

