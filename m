Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A76615CA9
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 08:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiKBHGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 03:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKBHGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 03:06:01 -0400
Received: from m12-13.163.com (m12-13.163.com [220.181.12.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A9B21E709
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 00:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=It6tc
        gGLGWT9Vm0OwHLSVIbR6HHFjOSSxmcjWgA1bMk=; b=cA9Y+R8+beC+3NE224eCa
        Rmtgyl2Vjhz+5DnboUkc0VTuAKCpT8yVEbfOUTx+dhV7MC1xRt7hgyS5GnuB5Ud2
        NyG2ZZ/cwmvE8tC/XYqPayQeZPbtKYw1his//0kbHWSUa+TV7DEw+IlBt32QOQWO
        H4R3pcOZML15tutljEgUQU=
Received: from localhost.localdomain (unknown [140.205.11.19])
        by smtp9 (Coremail) with SMTP id DcCowADH3uKlFmJjf6xoIQ--.13857S4;
        Wed, 02 Nov 2022 15:05:14 +0800 (CST)
From:   mrpre <mrpre@163.com>
To:     daniel@iogearbox.net, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, mrpre <mrpre@163.com>
Subject: [PATCH iproute2 v2] fix missing map name when creating eBPF maps
Date:   Wed,  2 Nov 2022 07:05:06 +0000
Message-Id: <20221102070506.1403-1-mrpre@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ecd50658-d021-ef03-deac-868ad9416b4a@iogearbox.net>
References: <ecd50658-d021-ef03-deac-868ad9416b4a@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowADH3uKlFmJjf6xoIQ--.13857S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7KF45uw13AFyxWr1DGw4rXwb_yoW8Jw48pF
        4kta4xua1fJ3y2yrZ8XFs8uas8XF4qqw4093WkG3W5ZF4Duw47Zr1F9a4j9rn8WFy7Za1U
        Xa12qayruayxZrJanT9S1TB71UUUUj7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pi0tCrUUUUU=
X-Originating-IP: [140.205.11.19]
X-CM-SenderInfo: xpus2vi6rwjhhfrp/1tbiFQutp15mNL-3bwAAs-
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix missing map name when creating eBPF maps

Signed-off-by: Chen Jiayuan <mrpre@163.com>
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

