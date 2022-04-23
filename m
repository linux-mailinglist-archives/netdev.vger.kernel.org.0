Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093FA50CBAE
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 17:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbiDWP0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 11:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiDWP0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 11:26:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01E733A21
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 08:23:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C0C060908
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 15:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1A8C385AB;
        Sat, 23 Apr 2022 15:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650727386;
        bh=/dw6HhxBy3vSpQmWXJ6CHa8ThanPf9ZV66VAqfkXk/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7jQvmtPcY/dk/3Wp4E5/MRTy4QjC09IdkseLG3pVqrrBSFZgrt0sqCapd5SVfDrf
         L9nTfahFuWlzLkxni5MbNojrUKhizYesP6yHRUSPuwQWTzwur3L+hbx8tv8WWdXF4W
         E32GuJifUjBOFhDkStjpYnqBZMsYeto4hiZCd6ZkXD7rCOevKQ8EPYzV7tdG+wu7KM
         i8cI8BnkIuP9KQnZAPlyV8uykaXp6DXNDqiDDf3h3fVmlHkv9Uw5wP1XOe38X91voN
         Gpif3xBanZoBYSio1prp3NdZL7QX/AWeVVPiXvZ+ViSaN6CitHcgRH49sNfJVn5iJr
         Kfp86ofpic2mQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, toke@redhat.com, haliu@redhat.com,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next 1/3] libbpf: Use bpf_object__load instead of bpf_object__load_xattr
Date:   Sat, 23 Apr 2022 09:22:58 -0600
Message-Id: <20220423152300.16201-2-dsahern@kernel.org>
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

bpf_object__load_xattr is deprecated as of v0.8+; remove it
in favor of bpf_object__load.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 lib/bpf_libbpf.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
index f4f98caa1e58..f723f6310c28 100644
--- a/lib/bpf_libbpf.c
+++ b/lib/bpf_libbpf.c
@@ -248,7 +248,6 @@ static int handle_legacy_maps(struct bpf_object *obj)
 
 static int load_bpf_object(struct bpf_cfg_in *cfg)
 {
-	struct bpf_object_load_attr attr = {};
 	struct bpf_program *p, *prog = NULL;
 	struct bpf_object *obj;
 	char root_path[PATH_MAX];
@@ -305,11 +304,7 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
 	if (ret)
 		goto unload_obj;
 
-	attr.obj = obj;
-	if (cfg->verbose)
-		attr.log_level = 2;
-
-	ret = bpf_object__load_xattr(&attr);
+	ret = bpf_object__load(obj);
 	if (ret)
 		goto unload_obj;
 
-- 
2.24.3 (Apple Git-128)

