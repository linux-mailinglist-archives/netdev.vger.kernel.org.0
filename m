Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A891E6493
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391256AbgE1Ov2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:51:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57847 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728648AbgE1OvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 10:51:24 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jeJsI-0006B0-7R; Thu, 28 May 2020 14:51:14 +0000
From:   Colin King <colin.king@canonical.com>
To:     David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][net-next] nexthop: fix incorrect allocation failure on nhg->spare
Date:   Thu, 28 May 2020 15:51:14 +0100
Message-Id: <20200528145114.420100-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The allocation failure check for nhg->spare is currently checking
the pointer nhg rather than nhg->spare which is never false. Fix
this by checking nhg->spare instead.

Addresses-Coverity: ("Logically dead code")
Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index ebafa5ed91ac..97423d6f2de9 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1185,7 +1185,7 @@ static struct nexthop *nexthop_create_group(struct net *net,
 
 	/* spare group used for removals */
 	nhg->spare = nexthop_grp_alloc(num_nh);
-	if (!nhg) {
+	if (!nhg->spare) {
 		kfree(nhg);
 		kfree(nh);
 		return NULL;
-- 
2.25.1

