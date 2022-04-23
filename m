Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A76450CBB0
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 17:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbiDWP0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 11:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbiDWP0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 11:26:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF1B33EB5
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 08:23:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D397360916
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 15:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6ADDC385AE;
        Sat, 23 Apr 2022 15:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650727388;
        bh=rOx4xgNOOjQem/D9bbV2YUdibw3hn+YHtvP17Pu7bOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ezwutf8QLGl+dN05EVegoPdYeRNtKCbTw3XNhy57AO52X0sqT5cZMblvIK4j9zUbi
         w3CagxpTzdxaYB8zUVBCwa0azyiB5+rxMTbNtv+ub2H3ha70jCkU/p+LP4/5xHeCYp
         3gUjeHxNcsqw0RCl38RfOBlfxCKTKXhNkzK65EsCsy7Cdx5eGTR3a3tH7h/JPtERd4
         wAwmB8X5DxuAJj6Q+NlQ2Nzlx1VZ6jaXlw/X0NX4KpPbkjgKQ9HYv0Qq7gxtm/N+J7
         fpolM0knDmSpVWL2UKNYrB0wTCrPWuX1SH3nD5RpMQMXkDSXG9tADWNIlH+Eur0APp
         7QJ8wJx0W/7LA==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, toke@redhat.com, haliu@redhat.com,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next 3/3] libbpf: Remove use of bpf_map_is_offload_neutral
Date:   Sat, 23 Apr 2022 09:23:00 -0600
Message-Id: <20220423152300.16201-4-dsahern@kernel.org>
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

bpf_map_is_offload_neutral is deprecated as of v0.8+;
import definition to maintain backwards compatibility.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 lib/bpf_libbpf.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
index 7dd1faf536f4..7b16ee71589d 100644
--- a/lib/bpf_libbpf.c
+++ b/lib/bpf_libbpf.c
@@ -249,6 +249,11 @@ static int handle_legacy_maps(struct bpf_object *obj)
 	return ret;
 }
 
+static bool bpf_map_is_offload_neutral(const struct bpf_map *map)
+{
+	return bpf_map__type(map) == BPF_MAP_TYPE_PERF_EVENT_ARRAY;
+}
+
 static int load_bpf_object(struct bpf_cfg_in *cfg)
 {
 	struct bpf_program *p, *prog = NULL;
@@ -294,7 +299,7 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
 	}
 
 	bpf_object__for_each_map(map, obj) {
-		if (!bpf_map__is_offload_neutral(map))
+		if (!bpf_map_is_offload_neutral(map))
 			bpf_map__set_ifindex(map, cfg->ifindex);
 	}
 
-- 
2.24.3 (Apple Git-128)

