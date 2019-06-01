Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A81A3194B
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfFADgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfFADgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 23:36:21 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EA1D270D6;
        Sat,  1 Jun 2019 03:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559360181;
        bh=g9A+bAamTEaDygEWNLMsxzpMN26y6WqToubu6Su8yZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FnK1QgeZ2LnQuWy5AaPT+PSPwfo3T+n0X1DH0SnKOVYa9lhxwETG0AT423oGgeYaC
         vjLf0mqUJ8oB/pbsOK0TdX6Wxq2D8zICNr22pv3V9L1cpIlAY3P8Nxq9rZRmIEDHhA
         HcZhc00iUNe5CD0y8yRHG3n1j4tg92lqB+i8xw5E=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     alexei.starovoitov@gmail.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH RFC net-next 07/27] rocker: Fail attempts to use routes with nexthop objects
Date:   Fri, 31 May 2019 20:35:58 -0700
Message-Id: <20190601033618.27702-8-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601033618.27702-1-dsahern@kernel.org>
References: <20190601033618.27702-1-dsahern@kernel.org>
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

