Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41FAE3E0A
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 23:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbfJXVUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 17:20:51 -0400
Received: from cache12.mydevil.net ([128.204.216.223]:16395 "EHLO
        cache12.mydevil.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbfJXVUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 17:20:51 -0400
From:   =?UTF-8?q?Micha=C5=82=20=C5=81yszczek?= <michal.lyszczek@bofc.pl>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Micha=C5=82=20=C5=81yszczek?= <michal.lyszczek@bofc.pl>
Subject: [PATCH iproute2] rdma/sys.c: fix possible out-of-bound array access
Date:   Thu, 24 Oct 2019 23:20:43 +0200
Message-Id: <20191024212043.17663-1-michal.lyszczek@bofc.pl>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AV-Check: Passed
X-System-Sender: michal.lyszczek@bofc.pl
X-Spam-Flag: NO
X-Spam-Status: NO, score=0.8 required=5.0, tests=(BAYES_50=0.8,
        NO_RELAYS=-0.001, URIBL_BLOCKED=0.001) autolearn=disabled
        version=3.4.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netns_modes_str[] array has 2 elements, when netns_mode is 2,
condition (2 <= 2) will be true and `mode_str = netns_modes_str[2]'
will be executed, which will result in out-of-bound read.

Signed-off-by: Michał Łyszczek <michal.lyszczek@bofc.pl>
---
 rdma/sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rdma/sys.c b/rdma/sys.c
index cef39081..1a434a25 100644
--- a/rdma/sys.c
+++ b/rdma/sys.c
@@ -31,7 +31,7 @@ static int sys_show_parse_cb(const struct nlmsghdr *nlh, void *data)
 		netns_mode =
 			mnl_attr_get_u8(tb[RDMA_NLDEV_SYS_ATTR_NETNS_MODE]);
 
-		if (netns_mode <= ARRAY_SIZE(netns_modes_str))
+		if (netns_mode < ARRAY_SIZE(netns_modes_str))
 			mode_str = netns_modes_str[netns_mode];
 		else
 			mode_str = "unknown";
-- 
2.21.0

