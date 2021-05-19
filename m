Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863C8389076
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354381AbhESORX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354090AbhESOP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:56 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3677FC061354;
        Wed, 19 May 2021 07:14:17 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id n2so14278159wrm.0;
        Wed, 19 May 2021 07:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I8t7IC8rszKDO64b8khK6AR6AKFnTbofVr0A+rLLUB4=;
        b=jfMrMsy5UAAC10en9iNj5b6UsSvI+9eVsNRclD5mxFTdDo1fV4oxafdbKPAhLnNJpE
         ebTvnEQhqJ8+TwGCL+x760x+RU/bnBIoK1dKQ9e1V6sEd4i4dQIMDDMUA/EwrKEYhIl5
         uKVwBMrafgR9MaYLTFBuLPPFewGifJJezI1nvJo0SLePNjo96ZUiAE/W0SzF8OYeASO7
         X3jRxvBjwM04gg0lswl2h/3tju7Zb8Pyz+1qAHAnt0LWXzt0byUJmIINondvh18W4r7y
         2z/TVIKaVWBsZQqD/BHyicmSHN5Y/ZxJBrefOdeeWjYj9Rq/UxH2SzsehL6kpV0ffBST
         j5rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I8t7IC8rszKDO64b8khK6AR6AKFnTbofVr0A+rLLUB4=;
        b=LmTlrX5oyejPfnE+RvLkmY+BSw//6XQ136ZdQHJ38zKDn45U2zdgts7C8hgiaRMcT8
         YdwQKAX9V5kihFIdRbZuWP1ReDD8giFYew7fXi5PkAyNVaDUQehWT6kFRRz6FmuoR0RO
         XvUb2gRISx3KjWBCRXZPvrp3AJn0WP6lxPULcpJikONX5ygPWuwsZOvpHEMp7hikpCDC
         n2qY+RbnZZ2YEIpcXY8DKuiCE9i7VhBBbAgwR2bE1oeKNbOIoJkxhB5WC55KUA0V8cHD
         r6i/VqyRCjQvHhqtFdVetebdufBsaySEB5k4ev03TrcoYwewyQzfEtgystXy2ZXTUmX2
         xt0g==
X-Gm-Message-State: AOAM530nNEfdTQsl7OQqdQJGMqfFSruRRz8ZK0FyTBRzYf+bnf8NAvWo
        V1CFhRpnLSaeQZKGtt++gd5YdK4JD9wTXEe6
X-Google-Smtp-Source: ABdhPJzZ+iq90liyYxgbay+X9B8r5t27hHDhqK57c2gZ+dA4QrLFSlq+2gQKwoKFLxc81ngdxCQdjQ==
X-Received: by 2002:a5d:5049:: with SMTP id h9mr15148372wrt.24.1621433655895;
        Wed, 19 May 2021 07:14:15 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:14:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
Subject: [PATCH 21/23] io_uring: wire bpf copy to user
Date:   Wed, 19 May 2021 15:13:32 +0100
Message-Id: <12ed7a929cca94a82023076ae99e90f7663f297f.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable io_uring to write to userspace memory

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c37846bca863..c4682146afa4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10467,6 +10467,8 @@ io_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	switch (func_id) {
 	case BPF_FUNC_copy_from_user:
 		return prog->aux->sleepable ? &bpf_copy_from_user_proto : NULL;
+	case BPF_FUNC_copy_to_user:
+		return prog->aux->sleepable ? &bpf_copy_to_user_proto : NULL;
 	case BPF_FUNC_iouring_queue_sqe:
 		return prog->aux->sleepable ? &io_bpf_queue_sqe_proto : NULL;
 	case BPF_FUNC_iouring_emit_cqe:
-- 
2.31.1

