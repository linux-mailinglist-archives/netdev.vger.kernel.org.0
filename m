Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34D6377C6B
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 01:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfG0Xha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 19:37:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48998 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfG0Xha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 19:37:30 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hrWFj-0003BH-5v; Sat, 27 Jul 2019 23:37:27 +0000
From:   Colin King <colin.king@canonical.com>
To:     David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rocker: fix memory leaks of fib_work on two error return paths
Date:   Sun, 28 Jul 2019 00:37:26 +0100
Message-Id: <20190727233726.3121-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently there are two error return paths that leak memory allocated
to fib_work. Fix this by kfree'ing fib_work before returning.

Addresses-Coverity: ("Resource leak")
Fixes: 19a9d136f198 ("ipv4: Flag fib_info with a fib_nh using IPv6 gateway")
Fixes: dbcc4fa718ee ("rocker: Fail attempts to use routes with nexthop objects")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/rocker/rocker_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 079f459c73a5..2c5d3f5b84dd 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2208,10 +2208,12 @@ static int rocker_router_fib_event(struct notifier_block *nb,
 
 			if (fen_info->fi->fib_nh_is_v6) {
 				NL_SET_ERR_MSG_MOD(info->extack, "IPv6 gateway with IPv4 route is not supported");
+				kfree(fib_work);
 				return notifier_from_errno(-EINVAL);
 			}
 			if (fen_info->fi->nh) {
 				NL_SET_ERR_MSG_MOD(info->extack, "IPv4 route with nexthop objects is not supported");
+				kfree(fib_work);
 				return notifier_from_errno(-EINVAL);
 			}
 		}
-- 
2.20.1

