Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F054F0A54
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 16:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348561AbiDCOpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 10:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359054AbiDCOpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 10:45:12 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24827396B2;
        Sun,  3 Apr 2022 07:43:19 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id c2so6269293pga.10;
        Sun, 03 Apr 2022 07:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6tbHk2+CAC5YQR/AzksFLm5f5AJ/80aev2xPCgPl5tA=;
        b=e5vYXo9voRKnA5EfdGL/2VYBbYFH6k7dPahjpKz0UskqllFrR+G1+eO7X5zdjt5I9A
         cDOtjELWRVyUiWMgXIpYYYQfVOo8921212JOfxvW3hS2qnoU40z2FOxZouhuMi8riXQ1
         k7kslLYK1orvsjmN7dkjeh+gOy8VPFHBEjXwYQgLSgd6y0MaRDN5yoibOUgocXETxQAU
         KRiKtOgluempkaWgSrekH61PU7rHzn2km5/kJBYHenedR94oVPRPppv86eZAE+utZWXs
         xQ/+bkBWwdKugkxrTRhlBYwWqj7vfD/IvHLhMXRqcasSE342jRz+v7N7LzBC1+Jv8NQK
         haww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6tbHk2+CAC5YQR/AzksFLm5f5AJ/80aev2xPCgPl5tA=;
        b=tJJmDu39jn3hUdStshIEHMp84adlSpXyyFXHxfmE/EN/O/qEWkENDAT1Q/48e5bANw
         S/LY4OztF3N00z865CvRuNJ2B9vWgiGD/jrPt45t5227qvQAu14CZPIuF7VibH0MbqHp
         3KYocJ98AdY3VXVrhAZY4+iWQlb38BgijDUHaMqDiKZuxPzw9/IjpYOdXN/utCpC1Uii
         0T583HxtvD+Jg0TgmmlY7pKXMtUdC8Z1stETT0t9gFXbUA+jXNx2l/crAFz8Su6mp7Vf
         SGgDLlcA0e1NHaO0kwHevQaxUxXMqkHkXRHpqHMdWWHeiXfCmeuMhEyicCXygW9l3R0O
         ANUw==
X-Gm-Message-State: AOAM530MzAe1q8cE551sYyV93EY37aNEbe/hkKLNS5NdBD4QAdW2JZMI
        wwiIsjZPE/kXn+HfBiWzGkc=
X-Google-Smtp-Source: ABdhPJxM8su8FkFzY+mTx8zV864MB5EHXhrsr7BUDk9v6BvfIYwFXb1/DeMNIItWSyceCIGXyB/g7A==
X-Received: by 2002:a63:1a5f:0:b0:381:f043:320d with SMTP id a31-20020a631a5f000000b00381f043320dmr22770436pgm.63.1648996998574;
        Sun, 03 Apr 2022 07:43:18 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:51a7:5400:3ff:feee:9f61])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm9464910pfl.44.2022.04.03.07.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 07:43:18 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v2 8/9] bpf: bpftool: Set LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK for legacy libbpf
Date:   Sun,  3 Apr 2022 14:42:59 +0000
Message-Id: <20220403144300.6707-9-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220403144300.6707-1-laoar.shao@gmail.com>
References: <20220403144300.6707-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK has already been set for non legacy
libbpf, let's also set it for legacy libbpf then we can avoid setting the
deprecatred RLIMIT_MEMLOCK directly.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/bpf/bpftool/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 451cefc2d0da..9062ef2b8767 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -508,6 +508,8 @@ int main(int argc, char **argv)
 		 * mode for loading generated skeleton.
 		 */
 		libbpf_set_strict_mode(LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS);
+	} else {
+		libbpf_set_strict_mode(LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK);
 	}
 
 	argc -= optind;
-- 
2.17.1

