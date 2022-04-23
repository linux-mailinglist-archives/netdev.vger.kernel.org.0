Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8C950CBB3
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 17:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbiDWP0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 11:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbiDWP0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 11:26:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E441340DC
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 08:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9C02B80CCA
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 15:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28944C385A5;
        Sat, 23 Apr 2022 15:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650727387;
        bh=e/zfScGVuopU8PyymRkFp3yiGtMt1HyYl+Xh1LiNJ84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dr5yYIok7xD9pYkNdS/MijEvb4vM99ClD0JFZUNiqD4m1PxRfGkZDPytbpBJHgWHq
         quRatiYBfSB/zTUAntt5ip5YxANI/JPLjrT/N6Gs/bAEbLfH3ZDhy91Z42ZPwWuaYi
         g5tBhaPxOSYY+6G3hQFRK6p9wFS4GCdfRJOqf3LFjQDcBV5jUaLucJ7PSw9xCtAD7J
         zUBe9/JQM3V9/1Jd6F8N/jZjgNUAw3wqLgRIflW/s7aYWcsoCxvRSyR3u2VUHvUBTS
         ou3ESqwa9hxNs38oa88KyfN8PkK0u2qsdPDeuY4egtDP+TL3jb8LOllbXQScZtQTXk
         eQR48QU72CaTw==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, toke@redhat.com, haliu@redhat.com,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next 2/3] libbpf: Remove use of bpf_program__set_priv and bpf_program__priv
Date:   Sat, 23 Apr 2022 09:22:59 -0600
Message-Id: <20220423152300.16201-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20220423152300.16201-1-dsahern@kernel.org>
References: <20220423152300.16201-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_program__set_priv and bpf_program__priv are deprecated as of
libbpf v0.7+. Rather than store the map as priv on the program,
change find_legacy_tail_calls to take an argument to return a reference
to the map.

find_legacy_tail_calls is invoked twice from load_bpf_object - the
first time to check for programs that should be loaded. In this case
a reference to the map is not needed, but it does validate the map
exists. The second is invoked from update_legacy_tail_call_maps where
the map pointer is needed.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 lib/bpf_libbpf.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
index f723f6310c28..7dd1faf536f4 100644
--- a/lib/bpf_libbpf.c
+++ b/lib/bpf_libbpf.c
@@ -151,7 +151,8 @@ handle_legacy_map_in_map(struct bpf_object *obj, struct bpf_map *inner_map,
 	return ret;
 }
 
-static int find_legacy_tail_calls(struct bpf_program *prog, struct bpf_object *obj)
+static int find_legacy_tail_calls(struct bpf_program *prog, struct bpf_object *obj,
+				  struct bpf_map **pmap)
 {
 	unsigned int map_id, key_id;
 	const char *sec_name;
@@ -175,8 +176,8 @@ static int find_legacy_tail_calls(struct bpf_program *prog, struct bpf_object *o
 	if (!map)
 		return -1;
 
-	/* Save the map here for later updating */
-	bpf_program__set_priv(prog, map, NULL);
+	if (pmap)
+		*pmap = map;
 
 	return 0;
 }
@@ -190,8 +191,10 @@ static int update_legacy_tail_call_maps(struct bpf_object *obj)
 	struct bpf_map *map;
 
 	bpf_object__for_each_program(prog, obj) {
-		map = bpf_program__priv(prog);
-		if (!map)
+		/* load_bpf_object has already verified find_legacy_tail_calls
+		 * succeeds when it should
+		 */
+		if (find_legacy_tail_calls(prog, obj, &map) < 0)
 			continue;
 
 		prog_fd = bpf_program__fd(prog);
@@ -275,7 +278,8 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
 
 		/* Only load the programs that will either be subsequently
 		 * attached or inserted into a tail call map */
-		if (find_legacy_tail_calls(p, obj) < 0 && !prog_to_attach) {
+		if (find_legacy_tail_calls(p, obj, NULL) < 0 &&
+		    !prog_to_attach) {
 			ret = bpf_program__set_autoload(p, false);
 			if (ret)
 				return -EINVAL;
-- 
2.24.3 (Apple Git-128)

