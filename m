Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8995E6A7033
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjCAPuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCAPuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:50:51 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923D832CF7;
        Wed,  1 Mar 2023 07:50:50 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id x34so13826599pjj.0;
        Wed, 01 Mar 2023 07:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677685850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SB8yIXK0ux72SCLotKWWjyWNJLNinDvWe7sP24E/78I=;
        b=mpsPVL8YG6Cp3rHg+deL6I6EBWTUN7KKcWUt1lJ9qyb1u7u3y1LOfgwzf5vUEQadoG
         TE09601GWnIumLlSUH+vb1gS6JLNB+btbR4sHpPnc/FMOZyUgLBkeqrAroh6X4ELUZkY
         8rhKaa73sot6YY/pE47y1XIVUVjXCMieO8yNeHJDmG0blwHlFU0IbL2UUc5BkQ2O+Lq6
         I+xs3N+s+s3KCmL3vZnNyONRr+fb2vcdRzZn6la0bT9UKh9gIUIgHpGzHSxmJCTmD80Z
         Q5sxPVOJXCi3GKgFYd19Y/9/lpYY9iaR9TIjs7MwjzVqLXbhCyuPI94XAHy3yBwW/l2R
         a/IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677685850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SB8yIXK0ux72SCLotKWWjyWNJLNinDvWe7sP24E/78I=;
        b=pWwzjy+rcTjtgJR2Pbc/r/XzqV5PLFOqZvfuxxp96nIUdpc8sgMjysj+gNkpalBzRB
         jzxWDRo1ZmxEEchQIicyytAoOIu1tuz8Y1wt/3kjMAp1z6eI/dfnieQsKT7WVToa5Qz7
         DC/UqMaT22hCX/8B76HKtG7QfNiDxl/iNFdYN3B7G239orBZHpQ9i7t12PzYVjUTlO7i
         52dkKytYf7gS7x7SPa8oK6cP6lMhl31ZnMvMgJDfK+m1/75AdBQRAhUUw/1KTW/k71vk
         wYBrOBLIFYPIEngDIJHUpC4SeIPUMkf/hn41EjFXqaPCnwaZVo27dU0khwKjx/wonmRA
         //sA==
X-Gm-Message-State: AO0yUKWIcN+RxBcTk/jRVPh4frFyqY4A2Ur/q1WpTNcqX6xJwR/0/Sv0
        +DvY2no6zLWp0uumBi1DZXdOLZ80QrM=
X-Google-Smtp-Source: AK7set80uo7wpBkPda3h16/m+g5ouFP5m7S+erucj3U6KsZKZdaJovdQ469idaq3hEbs4ZfMumyFTg==
X-Received: by 2002:a05:6a21:9989:b0:cc:4118:7609 with SMTP id ve9-20020a056a21998900b000cc41187609mr7920921pzb.37.1677685849771;
        Wed, 01 Mar 2023 07:50:49 -0800 (PST)
Received: from gatsby.corp.tfbnw.net (75-172-126-232.tukw.qwest.net. [75.172.126.232])
        by smtp.gmail.com with ESMTPSA id c9-20020a637249000000b00502f20aa4desm7589490pgn.70.2023.03.01.07.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 07:50:49 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v13 bpf-next 01/10] bpf: Support "sk_buff" and "xdp_buff" as valid kfunc arg types
Date:   Wed,  1 Mar 2023 07:49:44 -0800
Message-Id: <20230301154953.641654-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230301154953.641654-1-joannelkoong@gmail.com>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
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

