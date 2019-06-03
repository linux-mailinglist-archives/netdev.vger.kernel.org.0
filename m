Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30FA32727
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 06:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfFCEIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 00:08:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfFCEIX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 00:08:23 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CC6D27B3F;
        Mon,  3 Jun 2019 04:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559534901;
        bh=g9A+bAamTEaDygEWNLMsxzpMN26y6WqToubu6Su8yZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=beYlNn/TLCoPl2HsC8dMm9gZ+j4K3CFJRCi4fD/jHK2A5QE/31XGdS0x4hv7bpte7
         uO9h9PXZC2V6pMd4Xnm2E3mlolDT4kO7OTsZ9KTPBH/4h2kD4yT7AiOM4CVBZ1c1tb
         NQQOa4fzXtOPBlJcwsIipjTfR72fEvgtQDf2dZT4=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, saeedm@mellanox.com, kafai@fb.com,
        weiwan@google.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 net-next 7/7] rocker: Fail attempts to use routes with nexthop objects
Date:   Sun,  2 Jun 2019 21:08:17 -0700
Message-Id: <20190603040817.4825-8-dsahern@kernel.org>
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
 drivers/net/ethernet/rocker/rocker_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 7ae6c124bfe9..45b3325c3a38 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2214,6 +2214,10 @@ static int rocker_router_fib_event(struct notifier_block *nb,
 				NL_SET_ERR_MSG_MOD(info->extack, "IPv6 gateway with IPv4 route is not supported");
 				return notifier_from_errno(-EINVAL);
 			}
+			if (fen_info->fi->nh) {
+				NL_SET_ERR_MSG_MOD(info->extack, "IPv4 route with nexthop objects is not supported");
+				return notifier_from_errno(-EINVAL);
+			}
 		}
 
 		memcpy(&fib_work->fen_info, ptr, sizeof(fib_work->fen_info));
-- 
2.11.0

