Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428DB6A2EDC
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 09:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjBZIv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 03:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjBZIvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 03:51:55 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B7B113EB;
        Sun, 26 Feb 2023 00:51:54 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 130so1900377pgg.3;
        Sun, 26 Feb 2023 00:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SB8yIXK0ux72SCLotKWWjyWNJLNinDvWe7sP24E/78I=;
        b=a4gboQ7L0RBOmQ5u0ufbHOnhsyuCSyxp/dd4uJLAutXOhFvbx8Ijr2QHsjNvlVkK/J
         kowWardUfmlatMFPhr8vLTgM7yZGw7DQ6lj9l77C4bpGmvhox9rFM8CmiMUBnFMVN352
         k1P0aL5Rk61gl+XVmF1DeKicS0BKpguZvIKm5eb05GIkO31OIYiP2We2GhJWm0Cb0jeO
         FVqeB9soMY2ONzshw/eWd7oIg0RQFkZhAnB2QGLHYpejdjhl2l4phKYNZvhYUYR7ANzk
         hFt1TeQp4eGqkggWIQzkyyJmpsP6s94Rq7wQQmD3K1oMQYxlyZDz+n2Z4ZJJoWoq4rPA
         qQ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SB8yIXK0ux72SCLotKWWjyWNJLNinDvWe7sP24E/78I=;
        b=hT4iKekiI4YSt2Fdb/UT9TkZU8VmyklHUtQGzULlVCme1LHsxkigYj+TmCO2ZGsDHE
         fEsIgpuqMoRxgwNf/INH3GcEl7AO9kwHmlEO2ensae8MCuqedBjAZpJ5KCqX4CGRRhOc
         1V34ObShlP5Li5yTp6UnDjFt93gMtCsnqH1HQBGXQ7GGpoqqlQVcErecD7zszmResYqU
         ZFJS64bKspbzdneDNguIwDVAgD7Uq1UKaEwuSNukamPyD48pYgckFoB1ZitAIXHJ1Mtw
         XTIrJkOyz0puBnqX69zeWbK+Lylw1FjZ8uH69hkUHn9/Nkx/j0I/G4qcRGQxRLGdEpAi
         3oaA==
X-Gm-Message-State: AO0yUKWfZebp2a2VYWAM+RP9T9FNvkDi8JTvljBXstNxzAhvMzszE1WP
        nLx/oUR1eIAYgAXvQrTilU3ZY4ED+3w=
X-Google-Smtp-Source: AK7set9twmySOnCZim7HaHcAlVYuyB8eYVTDOdk7cD4vHJknSlHlT+OQL76jj5JoQJ4uV84xiJqsgw==
X-Received: by 2002:a62:79c5:0:b0:5a9:4af:b05b with SMTP id u188-20020a6279c5000000b005a904afb05bmr20938583pfc.12.1677401513352;
        Sun, 26 Feb 2023 00:51:53 -0800 (PST)
Received: from gatsby.corp.tfbnw.net (75-172-126-232.tukw.qwest.net. [75.172.126.232])
        by smtp.gmail.com with ESMTPSA id s10-20020a62e70a000000b00592591d1634sm2227299pfh.97.2023.02.26.00.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 00:51:53 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v12 bpf-next 01/10] bpf: Support "sk_buff" and "xdp_buff" as valid kfunc arg types
Date:   Sun, 26 Feb 2023 00:51:11 -0800
Message-Id: <20230226085120.3907863-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230226085120.3907863-1-joannelkoong@gmail.com>
References: <20230226085120.3907863-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf mirror of the in-kernel sk_buff and xdp_buff data structures are
__sk_buff and xdp_md. Currently, when we pass in the program ctx to a
kfunc where the program ctx is a skb or xdp buffer, we reject the
program if the in-kernel definition is sk_buff/xdp_buff instead of
__sk_buff/xdp_md.

This change allows "sk_buff <--> __sk_buff" and "xdp_buff <--> xdp_md"
to be recognized as valid matches. The user program may pass in their
program ctx as a __sk_buff or xdp_md, and the in-kernel definition
of the kfunc may define this arg as a sk_buff or xdp_buff.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 kernel/bpf/btf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index fa22ec79ac0e..84cca8473873 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5683,6 +5683,10 @@ btf_get_prog_ctx_type(struct bpf_verifier_log *log, const struct btf *btf,
 	 * int socket_filter_bpf_prog(struct __sk_buff *skb)
 	 * { // no fields of skb are ever used }
 	 */
+	if (strcmp(ctx_tname, "__sk_buff") == 0 && strcmp(tname, "sk_buff") == 0)
+		return ctx_type;
+	if (strcmp(ctx_tname, "xdp_md") == 0 && strcmp(tname, "xdp_buff") == 0)
+		return ctx_type;
 	if (strcmp(ctx_tname, tname)) {
 		/* bpf_user_pt_regs_t is a typedef, so resolve it to
 		 * underlying struct and check name again
-- 
2.34.1

