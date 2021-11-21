Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932054586A6
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 22:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhKUV7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 16:59:50 -0500
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:57416 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbhKUV7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 16:59:49 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id oupFmUkCKE8xToupFmqrnz; Sun, 21 Nov 2021 22:56:42 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 21 Nov 2021 22:56:42 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] hv_netvsc: Use bitmap_zalloc() when applicable
Date:   Sun, 21 Nov 2021 22:56:39 +0100
Message-Id: <534578d2296a1f4bd86c9bd4676e9d6b92eceb59.1637531723.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'send_section_map' is a bitmap. So use 'bitmap_zalloc()' to simplify code,
improve the semantic and avoid some open-coded arithmetic in allocator
arguments.

Also change the corresponding 'kfree()' into 'bitmap_free()' to keep
consistency.

While at it, change an '== NULL' test into a '!'.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/hyperv/netvsc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 396bc1c204e6..5086cd07d1ed 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -155,7 +155,7 @@ static void free_netvsc_device(struct rcu_head *head)
 	kfree(nvdev->extension);
 	vfree(nvdev->recv_buf);
 	vfree(nvdev->send_buf);
-	kfree(nvdev->send_section_map);
+	bitmap_free(nvdev->send_section_map);
 
 	for (i = 0; i < VRSS_CHANNEL_MAX; i++) {
 		xdp_rxq_info_unreg(&nvdev->chan_table[i].xdp_rxq);
@@ -336,7 +336,6 @@ static int netvsc_init_buf(struct hv_device *device,
 	struct net_device *ndev = hv_get_drvdata(device);
 	struct nvsp_message *init_packet;
 	unsigned int buf_size;
-	size_t map_words;
 	int i, ret = 0;
 
 	/* Get receive buffer area. */
@@ -528,10 +527,9 @@ static int netvsc_init_buf(struct hv_device *device,
 		   net_device->send_section_size, net_device->send_section_cnt);
 
 	/* Setup state for managing the send buffer. */
-	map_words = DIV_ROUND_UP(net_device->send_section_cnt, BITS_PER_LONG);
-
-	net_device->send_section_map = kcalloc(map_words, sizeof(ulong), GFP_KERNEL);
-	if (net_device->send_section_map == NULL) {
+	net_device->send_section_map = bitmap_zalloc(net_device->send_section_cnt,
+						     GFP_KERNEL);
+	if (!net_device->send_section_map) {
 		ret = -ENOMEM;
 		goto cleanup;
 	}
-- 
2.30.2

