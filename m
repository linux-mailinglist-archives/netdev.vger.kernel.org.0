Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5180D68ECD
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388754AbfGOOJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388737AbfGOOJq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:09:46 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7640F21530;
        Mon, 15 Jul 2019 14:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199786;
        bh=QMd19WpKGYJalQzYk9IGJ+zHV5kW5Qk/do8V4oNjR8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNufNuNDFSMawH6WIhTl/zIQtQ/zNbNr+VCIzSA3gFE4lKKEp6E6MAvT6A2YYLpyI
         ufVk+4DqGTUTM8v7GYWCpJ9otE62CcoXaQi75zwuH2UyQemPtvLfauaijUHy2A0xmX
         Oeqq0oynuH9/TAMSut9lPAf4s/8/DgDlpHnUe+Sk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 105/219] vhost_net: disable zerocopy by default
Date:   Mon, 15 Jul 2019 10:01:46 -0400
Message-Id: <20190715140341.6443-105-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 098eadce3c622c07b328d0a43dda379b38cf7c5e ]

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
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index df51a35cf537..8beacbee2553 100644
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
2.20.1

