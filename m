Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E7B40AAA1
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 11:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbhINJUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 05:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhINJUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 05:20:35 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35158C0613E7
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 02:19:14 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id h9so27409631ejs.4
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 02:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XfMLrua0MdTHFZoz901/cpqoFG6QjfNV3NlQ/D/QR3U=;
        b=gPWrggkwreW6UsCt1ca/dqpXFRIuN1Tg1Qsx00cwx40Q9Q4y5fqtmWJDPfDhaUTy6r
         ixeCls6foCcPZKbIS5owz6HxN0Tuksbg6AdUmOxnp8b+sSLYEC11jHXMS1djaAtHFurE
         OZnEVW7sRAOswaUjsvzVBaT19Q2Y01uCRIs5GHQLUmvyqtgDnBF5n33aAjo9Wxp3muC8
         TbJoEZatoKz/xWRTRsaIjerAKQ5qNAjqcH3/GLBLo0p5Y3MNe+aZ36t5z0GwBwTZAtsF
         WwxadtVIZ1Lmidlk3YivRVAWSSXkis0Q8dCHBA6EIdsMg4MFPNRV1jnxmBIjcUpsz/It
         x/3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XfMLrua0MdTHFZoz901/cpqoFG6QjfNV3NlQ/D/QR3U=;
        b=ByVYn6x7lI7I3tiOZDyj/wJs49ILngtCT5+3RI6OC1BlSNqLchsXmXgVORM51oUYfc
         sjs/F9g21P0w68ywHKoEw48IifDapUTLgX3GlPlI1lgC/8dQwWL2g2UwCAfRU/TEM2/9
         krqNGq2ezO0mF0jxH3nnle0t49VK11/zbUFtMlfAkZ7y/rQ8Jc/4OgZUEQlzkIxyfCnU
         B4ZSTmIpUZi/ik+MY78ahP/ZcndQLIhnD2go3ULshvus1Vq6oegIsBaGdebRgUre8Fbv
         VvEDr8Iqe9Aazr3XqUvRpxXn/gLwXFGnpF7UM024V5goFtbAWgcFr8n5+L0arVTCvmBk
         aR9A==
X-Gm-Message-State: AOAM532TC78pwyOSIqQCCIwpNB8zqTw7eMBzK/imVmC5eZ02joRWXUjE
        e7WuUMMJMlvNdkECUMzgcZjsug==
X-Google-Smtp-Source: ABdhPJzyQWcCvhb8CObZAoq7/xs9ux3Xt9bPPpRdR4cUcUR7/d4EAIHwyFk1urCRGVd9nwkIFu8+ew==
X-Received: by 2002:a17:906:150c:: with SMTP id b12mr17768565ejd.275.1631611152800;
        Tue, 14 Sep 2021 02:19:12 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id h10sm4615915ede.28.2021.09.14.02.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 02:19:12 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, yangtiezhu@loongson.cn, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf v4 08/14] bpf/tests: Add test case flag for verifier zero-extension
Date:   Tue, 14 Sep 2021 11:18:36 +0200
Message-Id: <20210914091842.4186267-9-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210914091842.4186267-1-johan.almbladh@anyfinetworks.com>
References: <20210914091842.4186267-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new flag to indicate that the verified did insert
zero-extensions, even though the verifier is not being run for any
of the tests.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 6a04447171c7..26f7c244c78a 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -52,6 +52,7 @@
 #define FLAG_NO_DATA		BIT(0)
 #define FLAG_EXPECTED_FAIL	BIT(1)
 #define FLAG_SKB_FRAG		BIT(2)
+#define FLAG_VERIFIER_ZEXT	BIT(3)
 
 enum {
 	CLASSIC  = BIT(6),	/* Old BPF instructions only. */
@@ -11280,6 +11281,8 @@ static struct bpf_prog *generate_filter(int which, int *err)
 		fp->type = BPF_PROG_TYPE_SOCKET_FILTER;
 		memcpy(fp->insnsi, fptr, fp->len * sizeof(struct bpf_insn));
 		fp->aux->stack_depth = tests[which].stack_depth;
+		fp->aux->verifier_zext = !!(tests[which].aux &
+					    FLAG_VERIFIER_ZEXT);
 
 		/* We cannot error here as we don't need type compatibility
 		 * checks.
-- 
2.30.2

