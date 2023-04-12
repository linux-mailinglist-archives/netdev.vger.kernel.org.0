Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3287E6DFC5C
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 19:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjDLRM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 13:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjDLRM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 13:12:57 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA5613E;
        Wed, 12 Apr 2023 10:12:56 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id pm7-20020a17090b3c4700b00246f00dace2so4318600pjb.2;
        Wed, 12 Apr 2023 10:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681319576; x=1683911576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W1bsHxONodsdqF8TgfdMtl92hC0T5JMSAwhTNiRqZ58=;
        b=AH5QGVDngjLys3NDuejMQqW4F0y7UDrqnlaJLDttMu8+6OKTe7heTOY3cXe6tH6FcR
         OcrpUF1Wp1c2sdtCk5GZP3vIn0ZJWqYA6FjWPMgi4YyApg1Uk9MYIw/PFyyNC4X9AMNr
         dYKyjT+Ox8LF2NXiqjyTZ0n/DeiOkOQylufacE919XoNWox4eWJif7C6YJLelp8T62y+
         B1q0T6/fCzY++Z2D0CvqEAtQXtx+VXMjK4ZkgHtvRUvqGoOs9+/jl/FjVtsPqWqg0Nhz
         7DU6NgpcC6FPC+2aUuT2JdhdKbeLeZlc2WqovKjX8bjZGs1Vs2UJbjVBB/REyvHzbvGm
         4ALQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681319576; x=1683911576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W1bsHxONodsdqF8TgfdMtl92hC0T5JMSAwhTNiRqZ58=;
        b=GU9ElbKGaljriXPW01jv6r35W/63PftTVIjMvwhaDreWm4f2tCpMo65XOyPUmdjT7k
         k2h2ZAdhu0pbV6nlqbbZZ/YADYYPitaRspCR69GNzo2Pns50GPSEXT9Ra0/QKxeZgz9e
         9zSwFlMUWqnWBp8o4QAUrbTDAlwAxO93hxNEK9YFlDBl3GBiS9ZKq9/tQtfOlChoe0Bi
         guVjTTySjRnydyuc2SUGoykmvsO1IKGQgEFm6Wan67Wqczjs2HDuB8zobEksGeU425q9
         hqv1SH8UAK7t7cNyvmjD9xxhpgtmMvToSSjKngRsWFS1z8Xh4uel/vHqlCRwcyBacINW
         eOdQ==
X-Gm-Message-State: AAQBX9fMR//FnrQxjcw7K4I7IjiKJpmRoFWvJIm1DyRM7QtvuJRgkJLp
        VA4oyvWYWBUNccs5Zc2WBYBBMudECJk=
X-Google-Smtp-Source: AKy350aDuI4d4b8IxfeXU7H5bAIlOr1R8sLWH8x3+FaeHdZqCkyKwV0Msy71/zF1n1jJTYU4B9ITKg==
X-Received: by 2002:a05:6a20:4e21:b0:eb:e3f2:edcc with SMTP id gk33-20020a056a204e2100b000ebe3f2edccmr1993211pzb.51.1681319575985;
        Wed, 12 Apr 2023 10:12:55 -0700 (PDT)
Received: from macbook-pro-6.DHCP.thefacebook.com ([2620:10d:c090:400::5:5010])
        by smtp.gmail.com with ESMTPSA id u22-20020aa78496000000b0063824fef275sm5895918pfn.37.2023.04.12.10.12.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 12 Apr 2023 10:12:55 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next] bpf: Handle NULL in bpf_local_storage_free.
Date:   Wed, 12 Apr 2023 10:12:52 -0700
Message-Id: <20230412171252.15635-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
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

From: Alexei Starovoitov <ast@kernel.org>

During OOM bpf_local_storage_alloc() may fail to allocate 'storage' and
call to bpf_local_storage_free() with NULL pointer will cause a crash like:
[ 271718.917646] BUG: kernel NULL pointer dereference, address: 00000000000000a0
[ 271719.019620] RIP: 0010:call_rcu+0x2d/0x240
[ 271719.216274]  bpf_local_storage_alloc+0x19e/0x1e0
[ 271719.250121]  bpf_local_storage_update+0x33b/0x740

Fixes: 7e30a8477b0b ("bpf: Add bpf_local_storage_free()")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/bpf_local_storage.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index dab2ff4c99d9..47d9948d768f 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -157,6 +157,9 @@ static void bpf_local_storage_free(struct bpf_local_storage *local_storage,
 				   struct bpf_local_storage_map *smap,
 				   bool bpf_ma, bool reuse_now)
 {
+	if (!local_storage)
+		return;
+
 	if (!bpf_ma) {
 		__bpf_local_storage_free(local_storage, reuse_now);
 		return;
-- 
2.34.1

