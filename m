Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCC76128B2
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 08:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJ3Hcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 03:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJ3Hcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 03:32:43 -0400
Received: from m12-17.163.com (m12-17.163.com [220.181.12.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD17D2D6
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 00:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=+G+F8
        6mjNEBp/QRqr8XmLHhCRs5YMzjh5Y+foIZGQe0=; b=LH8PIa1/mj/ZTBx7NyEuZ
        A6xy864mrisQ2uZKMn43Zf0HYMkbM+/L137noFmr15QuLmILHr/Mx9KN65CEYUqU
        xpvbujHr40cjOxTVFtuhxylgsWm6IZG1cEre4+MMbQ8WaZi95zVBB+PFHXdXWclI
        xdlwWp8O09bvh23vHtxUAA=
Received: from localhost.localdomain (unknown [122.233.228.90])
        by smtp13 (Coremail) with SMTP id EcCowACXhGR2KF5j+FRQmg--.28651S4;
        Sun, 30 Oct 2022 15:32:09 +0800 (CST)
From:   mrpre <mrpre@163.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, mrpre <mrpre@163.com>
Subject: [PATCH v2] fix missing map name when creating a eBPF map
Date:   Sun, 30 Oct 2022 07:32:04 +0000
Message-Id: <20221030073204.1876-1-mrpre@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221027083808.3304abd6@hermes.local>
References: <20221027083808.3304abd6@hermes.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowACXhGR2KF5j+FRQmg--.28651S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7XFW5GF1rXFy7Zw1xuw4xtFb_yoW8JF1DpF
        1kKa4xua1fJ3y2yr98JFs8u3s8XF4qqw4j9w1kG3W5ZF4DZw47Zr1Fva4j9rn8GFy7Za1U
        Xa12qayruayxZrJanT9S1TB71UUUUjUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRhmiiUUUUU=
X-Originating-IP: [122.233.228.90]
X-CM-SenderInfo: xpus2vi6rwjhhfrp/1tbi6xmqp1Xl2WDifgAAsq
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: mrpre <mrpre@163.com>
---
 lib/bpf_legacy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 4fabdcc8..0fff035b 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -1264,7 +1264,7 @@ static int bpf_map_create(enum bpf_map_type type, uint32_t size_key,
 			  uint32_t size_value, uint32_t max_elem,
 			  uint32_t flags, int inner_fd, int btf_fd,
 			  uint32_t ifindex, uint32_t btf_id_key,
-			  uint32_t btf_id_val)
+			  uint32_t btf_id_val, const char *name)
 {
 	union bpf_attr attr = {};
 
@@ -1278,6 +1278,7 @@ static int bpf_map_create(enum bpf_map_type type, uint32_t size_key,
 	attr.btf_fd = btf_fd;
 	attr.btf_key_type_id = btf_id_key;
 	attr.btf_value_type_id = btf_id_val;
+	strncpy(attr.map_name, name, sizeof(attr.map_name));
 
 	return bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
 }
@@ -1682,7 +1683,7 @@ probe:
 	errno = 0;
 	fd = bpf_map_create(map->type, map->size_key, map->size_value,
 			    map->max_elem, map->flags, map_inner_fd, ctx->btf_fd,
-			    ifindex, ext->btf_id_key, ext->btf_id_val);
+			    ifindex, ext->btf_id_key, ext->btf_id_val, name);
 
 	if (fd < 0 || ctx->verbose) {
 		bpf_map_report(fd, name, map, ctx, map_inner_fd);
-- 
2.25.1

