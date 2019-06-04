Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E423733D78
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 05:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfFDDUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 23:20:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbfFDDT7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 23:19:59 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D441425EAF;
        Tue,  4 Jun 2019 03:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559618399;
        bh=g9A+bAamTEaDygEWNLMsxzpMN26y6WqToubu6Su8yZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eh+PedX/txgBaRZrx9KHq4EXNdHsx6av2PRAlQPAeKR0HuApSMM7CjsfyuCe6sXhi
         dNTe0EclzZpzSuqdke9cZNF3fBgofxW0mx7S7XOfMM7aKO19wE19MIKEnw4UNr3eZR
         JFqYyuvY4g/QvvDhMrwgwmPhOBZ3rolG9E0/3sJE=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, saeedm@mellanox.com, kafai@fb.com,
        weiwan@google.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v3 net-next 7/7] rocker: Fail attempts to use routes with nexthop objects
Date:   Mon,  3 Jun 2019 20:19:55 -0700
Message-Id: <20190604031955.26949-8-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190604031955.26949-1-dsahern@kernel.org>
References: <20190604031955.26949-1-dsahern@kernel.org>
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

