Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF37547E2D
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 11:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfFQJVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 05:21:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbfFQJVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 05:21:09 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 85F873086227;
        Mon, 17 Jun 2019 09:21:03 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C97613781;
        Mon, 17 Jun 2019 09:20:56 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     jasowang@redhat.com, mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     huhai@kylinos.cn
Subject: [PATCH net-next] vhost_net: disable zerocopy by default
Date:   Mon, 17 Jun 2019 05:20:54 -0400
Message-Id: <20190617092054.12299-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 17 Jun 2019 09:21:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vhost_net was known to suffer from HOL[1] issues which is not easy to
fix. Several downstream disable the feature by default. What's more,
the datapath was split and datacopy path got the support of batching
and XDP support recently which makes it faster than zerocopy part for
small packets transmission.

It looks to me that disable zerocopy by default is more
appropriate. It cold be enabled by default again in the future if we
fix the above issues.

[1] https://patchwork.kernel.org/patch/3787671/

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 2d9df786a9d3..21e0805e5e60 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -36,7 +36,7 @@
 
 #include "vhost.h"
 
-static int experimental_zcopytx = 1;
+static int experimental_zcopytx = 0;
 module_param(experimental_zcopytx, int, 0444);
 MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
 		                       " 1 -Enable; 0 - Disable");
-- 
2.18.1

